# [Modul 1 — Dasar-Dasar Standard Library Lua][0]

**Mini-daftar isi (struktur internal untuk Modul 1)**

<details>
  <summary>📃 Daftar Isi</summary>

---

1. Struktur Materi (apa yang akan dibahas di sini)

   * 1.1 Pengenalan Umum Standard Library

     * Tujuan & peran, filosofi, hubungan ke runtime/embedding
     * Identitas teknis (bahasa implementasi, bagaimana dimodifikasi)
     * Instalasi & cara menjalankan REPL / interpreter
     * Visualisasi: diagram arsitektur runtime + library
   * 1.2 Global Environment dan Basic Functions

     * \_G, \_VERSION, fungsi dasar (print, assert, error)
     * Type checking & metatable dasar (type, getmetatable, setmetatable)
     * Conversion functions (tonumber, tostring)
     * Contoh-contoh/praktik terbaik dan jebakan umum
2. Latihan & Kuiz singkat (dengan solusi pendek)
3. Referensi resmi & bacaan lanjut

</details>

---

## 1.1 Pengenalan Umum Standard Library

### Struktur Pembelajaran Internal (mini-TOC)

* Ringkasan praktis: apa itu standard library
* Peran dalam ekosistem Lua
* Identitas teknis: bahasa implementasi, lokasi kode sumber, cara modifikasi
* Cara instalasi dan menjalankan Lua (REPL & script)
* Visualisasi arsitektur: interpreter ↔ C API ↔ libraries
* Praktik & tip pengembangan / debugging

### Deskripsi Konkret & Peran dalam Kurikulum

Standard library Lua adalah sekumpulan modul dan fungsi dasar yang disertakan bersama interpreter (mis. fungsi dasar `print`, modul `string`, `table`, `math`, `io`, `os`, dst.). Standard library memberi kemampuan praktis sehari-hari pada skrip Lua dan merupakan landasan untuk modul lanjutan (metatable, C API, embedding, paket eksternal). Menguasai standard library membuat Anda dapat menulis kode efektif tanpa bergantung banyak pada eksternal, dan merupakan prasyarat untuk pengembangan plugin/embedding.

**Sumber resmi (referensi utama):** Manual resmi Lua 5.4 (reference manual). ([lua.org][1])

### Konsep Kunci & Filosofi Mendalam

* **Ringan & Embeddable:** Lua dirancang agar kecil dan mudah disematkan dalam aplikasi lain; banyak fungsi inti ditulis di C untuk performance dan interoperabilitas. Pengembang perlu paham batasan lingkungan (sandboxing, resource limits). ([lua.org][2])
* **Minimal core, extensible libraries:** Bahasa inti (syntax + VM) kecil; fungsi-fungsi richer disediakan lewat libraries yang dapat di-extend (LuaRocks, C modules). Ini memberi keseimbangan antara kesederhanaan dan ekspresivitas. ([Gumroad][3])
* **Tables-first design:** Banyak struktur data dan modul dibangun di atas tables. Pemahaman table adalah fundamental untuk semua library. ([lua.org][4])

### Identitas Teknis & Persyaratan Pengembangan / Modifikasi

* **Bahasa implementasi:** Interpreter resmi Lua ditulis dalam *ANSI C* (portable C). Standard libraries standar (banyak) diimplementasikan dalam C dan/atau Lua sesuai modul. Untuk memodifikasi library bawaaan, Anda memerlukan:

  * Pengetahuan **C (ANSI C)** untuk menulis/ubah native library. ([lua.org][2])
  * Pengetahuan **Lua** untuk bagian yang ditulis di Lua (mis. beberapa utilitas).
  * Tooling: kompiler C (gcc/clang), make, autotools; akses ke kode sumber Lua (download dari lua.org).
  * Untuk packaging: **LuaRocks** (manajemen paket). ([lua.org][5])
* **Cara modifikasi ringkas:** clone repo Lua, ubah file C/implementasi library, jalankan `make linux` atau target OS yang sesuai, test dengan REPL lokal. (instruksi build di manual). ([lua.org][2])

### Instalasi & menjalankan (contoh cepat)

* Instal dari distro (contoh Arch Linux): `sudo pacman -S lua` (distribusi berbeda punya paket berbeda).
* Dari sumber (umum, sesuai manual):

  ```bash
  wget https://www.lua.org/ftp/lua-5.4.6.tar.gz
  tar xzf lua-5.4.6.tar.gz
  cd lua-5.4.6
  make linux       # atau make macosx / mingw sesuai platform
  sudo make install
  ```

  (lihat README/build pada paket sumber). ([lua.org][2])

### Rekomendasi Visualisasi (berguna)

* Diagram arsitektur sederhana:

  * `Lua script` → `Lua VM (interpreter)` → `C API / standard libraries (C / Lua)` → `host application`
* Visualisasi modul: tabel modul (`string`, `table`, `math`, ...) sebagai kotak yang terhubung ke VM.

---

## 1.2 Global Environment dan Basic Functions

### Struktur Pembelajaran Internal (mini-TOC)

* Pengenalan \_G dan environment global
* Fungsi dasar (print, assert, error, ipairs/pairs) — catatan mana milik base library
* Fungsi type checking & metatable: `type`, `getmetatable`, `setmetatable`
* Konversi & parsing: `tonumber`, `tostring`
* Contoh implementasi minimal, studi kasus, flow diagram
* Terminologi penting + jebakan umum
* Latihan praktis

### Deskripsi Konkret & Peran dalam Kurikulum

Bagian ini mengajarkan bagaimana variabel dan fungsi biasa diakses dalam ruang nama global, serta fungsi dasar yang hampir selalu dipakai. Pemahaman environment global (`_G`) penting sebelum masuk ke topik yang lebih dalam seperti modul, sandboxing, dan metatable (module design dan pengamanan global). Fungsi dasar juga mendasari debugging cepat dan interaksi REPL.

**Dokumentasi fungsi dasar & environment:** Manual resmi (lihat bagian Global Environment dan Base Library). ([lua.org][6])

### Konsep Kunci & Filosofi

* `_G` adalah tabel global yang menyimpan semua variable/global yang didefinisikan tanpa local. Mengelola apa yang dimasukkan ke `_G` adalah praktik keamanan & desain penting (hindari polusi global).
* **Fungsi base** (mis. `print`, `assert`) merupakan alat kecil untuk debugging dan validasi; `assert` memaksa precondition, `error` memicu exception.
* `type` memberikan jenis nilai runtime (string: `"nil"`, `"number"`, `"string"`, `"table"`, `"function"`, `"thread"`, `"userdata"`, `"boolean"`). Interpretasi yang benar penting untuk validasi input. ([lua.org][1])

### Sintaks Dasar / Contoh Implementasi Inti (kode minimal dan penjelasan)

> Penjelasan: contoh berikut dapat dijalankan pada REPL `lua` atau disimpan sebagai `example.lua` dan dijalankan `lua example.lua`.

1. Melihat versi dan \_G:

```lua
-- tampilkan versi interpreter dan struktur global
print("_VERSION:", _VERSION)       -- contoh: Lua 5.4
print("_G type:", type(_G))        -- _G adalah table

-- menambah global lewat _G
_G.myAppName = "BelajarLua"
print("global myAppName:", myAppName)
print("_G.myAppName:", _G["myAppName"])
```

Penjelasan: `_VERSION` adalah string versi (base library). `_G` adalah tabel yang menyimpan binding global. Menggunakan `_G` membuat eksplisit bahwa Anda memodifikasi environment global.

2. Fungsi validasi dasar: `assert`, `error`, `pcall` (pcall akan lebih detail di Modul Error Handling tetapi contoh ringkas diperbolehkan):

```lua
function divide(a, b)
  assert(type(a) == "number" and type(b) == "number", "divide: numeric args required")
  if b == 0 then
    error("divide by zero")
  end
  return a / b
end

local ok, result = pcall(divide, 10, 2)   -- pcall: protected call (lihat modul error)
print(ok, result)  -- true 5
```

Penjelasan: `assert(cond, msg)` memicu error jika cond false/nil. `error(msg)` memicu error. `pcall` menjalankan fungsi dalam *protected mode* dan mengembalikan (boolean success, result/error).

3. Type checking & metatable:

```lua
local s = "halo"
print(type(s))                  -- "string"
local mt = getmetatable(s)      -- string memiliki metatable yang menunjuk ke library string
print("string metatable present?", mt ~= nil)

local t = {}
print(type(t))                  -- "table"
-- setmetatable/getmetatable bekerja pada tables
setmetatable(t, { __index = function(_, k) return "missing:"..k end })
print(t.foo)                    -- "missing:foo"
```

Penjelasan: `getmetatable` dan `setmetatable` mengatur perilaku objek (metamethods). Untuk string, library string menetapkan metatable sehingga Anda bisa menulis `s:sub(1,2)`.

4. Konversi: `tonumber`, `tostring`

```lua
print(tonumber("42") + 8)       -- 50
print(tostring(3.14))           -- "3.14"

-- parsing with base
print(tonumber("ff", 16))       -- 255
```

### Studi Kasus kecil (kebutuhan praktis)

Buat skrip yang membaca argumen CLI (arg), validasi, dan gunakan `_G` untuk menyimpan konfigurasi singkat:

```lua
-- config.lua
_G.config = {
  mode = arg[1] or "dev",
  level = tonumber(arg[2]) or 1
}
print("Mode:", config.mode, "Level:", config.level)
```

Penjelasan: `arg` adalah table global yang berisi argumen CLI (standard).

### Terminologi Esensial & Penjelasan Detil

* **\_G**: tabel global dimana nama global direferensikan.
* **Base library**: kumpulan fungsi global standar (print, assert, tostring, tonumber, load, dofile, etc.). ([lua.org][6])
* **Metatable**: tabel yang dapat menambah/memodifikasi perilaku tipe (mis. operator, indexing, tostring).
* **Metamethod**: kunci khusus dalam metatable (`__index`, `__add`, dll.) yang menangani operasi tertentu.
* **Protected call (pcall/xpcall)**: mekanisme untuk menjalankan kode yang mungkin melempar error tanpa menghentikan program.
* **REPL**: Read-Eval-Print Loop (interaktif `lua`).

### Visualisasi yang direkomendasikan

* Diagram \_G sebagai node pusat: semua nama global → (point) ke `_G` table.
* Diagram alir untuk error handling sederhana: function → assert → error → pcall menangkap → proses hasil.

### ASCII Diagram — hubungan environment & libraries

```
┌─────────────────────────────────────┐
│            Lua Interpreter          │
│  (VM + base libraries + C API)      │
│  ┌───────────────────────────────┐  │
│  │           _G (table)          │  │
│  │  (global binding storage)     │  │
│  │ ┌────────┬────────┬─────────┐ │  │
│  │ │ print  │ tonumber│ tostring│ │  │
│  │ │ string │ table   │ math    │ │  │
│  │ └────────┴────────┴─────────┘ │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

### Praktik Terbaik (Tips)

* **Minimalkan polusi global**: gunakan `local` sebanyak mungkin; hanya publikasikan API yang perlu ke `_G` atau package table.
* **Gunakan `assert` untuk validasi awal** pada fungsi publik.
* **Jangan mengubah metatable bawaan tipe primitif** kecuali Anda tahu implikasinya.
* **Gunakan `tonumber` dengan base jika mengurai bilangan non-desimal.**
* **Gunakan `pcall` saat memanggil kode tak dipercaya atau I/O**.

### Potensi Kesalahan Umum & Solusi

* **Mengasumsikan `nil` sama dengan false**: `nil` memang falsy; namun perbedaan `nil` di table berarti key hilang. Periksa `type` bila perlu.
* **Polusi global yang tak disadari**: menulis `x = 1` bukan `local x = 1` akan membuat `x` global. Solusi: biasakan `local`.
* **Mengandalkan `tonumber` tanpa fallback**: `tonumber("abc")` → `nil`. Selalu cek hasilnya.
* **Mengubah metatable tipe primitif** (mis. string) dapat memengaruhi seluruh program—hindari kecuali untuk tujuan sangat spesifik.

### Latihan & Kuiz Ringkas

1. **Latihan 1 (basic)**: Tulis skrip `cloneenv.lua` yang menampilkan `_VERSION`, lalu menambahkan `app_name` ke `_G` dan menampilkannya.

   * Jawaban singkat: contoh kode di bagian Sintaks Dasar (lihat atas).
2. **Latihan 2 (kesalahan umum)**: Mengapa `tonumber("08")` bisa menghasilkan `8` di beberapa kondisi tapi `nil` pada konversi basis tertentu? Jelaskan.

   * Jawaban: `tonumber("08", 10)` → 8; tapi jika base tidak ditentukan dan implementasi menafsirkan angka dengan leading zero sebagai octal di platform lama (tidak di Lua modern), itu bisa gagal; praktik aman: gunakan base 10 eksplisit atau sanitasi input.
3. **Quiz singkat**: Apa tipe hasil dari `type(getmetatable("abc"))`? (jawab: `table` atau `nil` tergantung implementasi, biasanya table karena string library menetapkan metatable). ([Stack Overflow][7])

---

## Keterkaitan Modul 1 dengan Modul Lain (prasyarat & berikutnya)

* **Module 2 (String)**: pemahaman buffer string & metatable string dibutuhkan untuk mengerti API string (Module 2 memperluas topik ringkas ini). ([lua.org][8])
* **Module 3 (Table)**: karena `_G` adalah table dan tables adalah kontainer utama — Module 3 adalah landasan. ([lua.org][4])
* **Module 7 (Package/require)**: perlu pemahaman tentang global environment untuk memahami bagaimana `require`/`package` mengubah namespace. ([lua.org][6])
* **Module 14 (C API)**: bila ingin memodifikasi library atau menulis extension, keterampilan C & build diperlukan (lihat bagian Identitas Teknis). ([lua.org][2])

---

## Referensi Utama & Bacaan Lanjut (penting — sumber yang saya gunakan)

* **Lua 5.4 Reference Manual (official)** — dokumentasi bahasa & standard libraries. ([lua.org][1])
* **Programming in Lua (Roberto Ierusalimschy)** — buku resmi & pola pemrograman Lua. ([Gumroad][3])
* **String Library / metatable behavior** — diskusi & catatan implementasi string metatable. ([Stack Overflow][7])
* **Tables tutorial (lua-users.org)** — penjelasan mendalam fungsi table. ([lua-users.org][9])
* **Build & installation instructions (README di lua.org)** — cara build dari sumber (untuk modul pengembangan). ([lua.org][2])

---

[1]: https://www.lua.org/manual/5.4/?utm_source=chatgpt.com "Lua 5.4 Reference Manual - contents"
[2]: https://www.lua.org/manual/5.4/readme.html?utm_source=chatgpt.com "Lua 5.4 readme"
[3]: https://feistyduck.gumroad.com/l/programming-in-lua-fourth-edition-ebook?utm_source=chatgpt.com "Programming in Lua, Fourth Edition - Feisty Duck"
[4]: https://www.lua.org/pil/2.5.html?utm_source=chatgpt.com "2.5 – Tables - Lua"
[5]: https://www.lua.org/docs.html?utm_source=chatgpt.com "documentation - Lua"
[6]: https://www.lua.org/manual/5.4/manual.html?utm_source=chatgpt.com "Lua 5.4 Reference Manual"
[7]: https://stackoverflow.com/questions/67025836/lua-internals-how-do-string-methods-work-as-methods?utm_source=chatgpt.com "Lua internals: how do string methods work as methods?"
[8]: https://www.lua.org/pil/20.html?utm_source=chatgpt.com "20 – The String Library - Lua"
[9]: https://lua-users.org/wiki/TablesTutorial?utm_source=chatgpt.com "lua-users wiki: Tables Tutorial"


> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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
