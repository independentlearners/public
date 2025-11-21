# Struktur kontrol

---

## Ringkasan konsep singkat (inti)

* **If / Kondisi**: memilih jalur eksekusi berdasarkan nilai boolean.
* **Loop / Perulangan**: mengulangi blok kode selama kondisi terpenuhi (pre-test / post-test / counted loop / iterator).
* **Switch / Case**: memilih di antara beberapa cabang berdasarkan nilai ekspresi (umumnya lebih efisien/terbaca saat banyak cabang diskrit).
* **Break / Continue / Return / Goto**: mengontrol aliran dari dalam struktur kontrol (perilaku spesifik bergantung bahasa).
* **Scoping dan truthiness**: perbedaan penting antara bahasa bertipe statis (Dart — ekspresi kondisi harus `bool`) dan bahasa dinamis (Lua — hanya `false` dan `nil` dianggap falsey; sisanya truthy).

---

# Bagian A — `if` / Kondisi (konsep & jebakan)

**Konsep:** Evaluasi ekspresi kondisi → hasil boolean (`true`/`false`) → jalankan blok yang sesuai.
**Jebakan umum:**

* **Implicit truthiness:** di Dart kondisi harus `bool` (tipe ketat). Di Lua, nilai lain selain `false` dan `nil` dianggap true — hati-hati saat memeriksa 0 atau string kosong.
* **Assignment dalam kondisi:** beberapa bahasa mengizinkan `=` di kondisi (assignment), yang memicu bug; Dart tidak mengizinkan penempatan non-bool di kondisi (menolong mencegah kelas bug ini).
* **Precedence**: gunakan tanda kurung bila kondisi kompleks agar tidak salah evaluasi.

---

# Bagian B — Loop (jenis & semantik)

1. **For counted**: umumnya untuk iterasi numerik (mis. `for (i=0; i<n; i++)`).
2. **For-in / foreach**: iterasi koleksi/iterable.
3. **While**: pre-test — cek kondisi sebelum mengeksekusi tubuh.
4. **Do / repeat-until**: post-test — tubuh dieksekusi minimal sekali.
5. **Generic iterator loop**: di Lua `for k,v in pairs(t) do`, di Dart `for (var e in iterable)`.
   **Jebakan umum:** mengubah koleksi saat sedang diiterasi, off-by-one, variabel loop yang bocor scope (tergantung bahasa), dan biaya alokasi iterator dalam loop performa-sensitive.

---

# Bagian C — `switch` / pemilihan kasus (perbedaan bahasa)

* **Dart:** `switch` tersedia; **tidak** mengizinkan implicit fall-through — setiap `case` harus diakhiri dengan `break`, `return`, `throw`, atau `continue` ke label lain. `default` tersedia. Bisa menggunakan `enum` secara aman (umumnya ada pemeriksaan exhaustiveness untuk `sealed`/`enum` pattern dalam versi terbaru).
* **Lua:** tidak ada `switch` built-in. Gunakan `if/elseif/else` atau **table dispatch** (mapping nilai ke fungsi) atau `goto` + label untuk implementasi alternatif.

---

# Contoh lengkap: **DART** — identity & persiapan singkat

**Identitas singkat Dart**

* **Dibuat oleh:** Google.
* **Implementasi inti:** runtime Dart VM/C++ untuk VM, kompiler ditulis sebagian (C++/Dart).
* **Dokumentasi referensi:** *Language tour* dan API reference di `dart.dev`.
  **Persiapan untuk mengembangkan / memodifikasi kode Dart**
* Instal **Dart SDK** (`dart` CLI) dan editor (VSCode/Neovim + plugin Dart/Flutter).
* Untuk memodifikasi runtime/kompiler: kemampuan C++ dan proses build (GN/Ninja), serta membaca repo resmi Dart.
* CLI help: `dart --help`, `dart run --help`.

### Contoh Dart (if, for, while, switch) + penjelasan kata-per-kata

```dart
void main() {
  int x = 3;
  if (x % 2 == 0) {
    print('even');
  } else if (x > 10) {
    print('greater than 10');
  } else {
    print('odd and <= 10');
  }

  // for counted
  for (int i = 0; i < 5; i++) {
    print('i = $i');
    if (i == 3) break;
  }

  // for-in (iterable)
  var list = [10, 20, 30];
  for (var v in list) {
    print(v);
  }

  // while
  int t = 2;
  while (t > 0) {
    t--;
  }

  // do-while
  int y = 0;
  do {
    y++;
  } while (y < 1);

  // switch
  var tag = 'B';
  switch (tag) {
    case 'A':
      print('case A');
      break;
    case 'B':
      print('case B');
      break;
    default:
      print('default case');
  }
}
```

**Penjelasan baris-per-baris (kata-per-kata) — bagian penting:**

* `void main() {`

  * `void` : tipe return fungsi `main` (tidak mengembalikan nilai).
  * `main` : entry point program.
  * `()` : parameter list kosong.
  * `{` : mulai block fungsi.

* `int x = 3;`

  * `int` : tipe integer.
  * `x` : identifier variabel.
  * `=` : operator assignment.
  * `3` : literal integer.
  * `;` : akhir statement.

* `if (x % 2 == 0) {`

  * `if` : kata kunci kondisi.
  * `(` `)` : menandai ekspresi kondisi.
  * `x % 2` : operator modulus (sisa bagi).
  * `== 0` : perbandingan sama dengan nol (menghasilkan `bool`); di Dart kondisi harus `bool`.
  * `{` : mulai blok yang dieksekusi jika kondisi `true`.

* `} else if (x > 10) {`

  * `else if` : cabang kondisi kedua; `x > 10` evaluasi bool.

* `} else {`

  * `else` : cabang default jika semua kondisi sebelumnya false.

* `for (int i = 0; i < 5; i++) {`

  * `for` : kata kunci loop.
  * `int i = 0` : inisialisasi (tipe `int`, variable `i`).
  * `i < 5` : kondisi ulangan (pre-test).
  * `i++` : increment setelah tiap iterasi (`i = i + 1`).
  * `{` : mulai tubuh loop.

* `if (i == 3) break;`

  * `==` : operator perbandingan.
  * `break` : keluar dari loop paling dekat.

* `var list = [10, 20, 30];`

  * `var` : type inference — compiler menetapkan `List<int>`.
  * `[...]` : literal list.

* `for (var v in list) {`

  * `for ... in` : iterasi elemen iterable, `v` mendapat setiap elemen.

* `while (t > 0) { t--; }`

  * `while` : pre-test loop; `t--` decrement.

* `do { y++; } while (y < 1);`

  * `do { ... } while(cond);` : tubuh dieksekusi dulu, lalu cek kondisi (post-test).

* `switch (tag) { case 'A': ... break; ... }`

  * `switch` : evaluasi ekspresi `tag`.
  * `case 'A':` : cocokkan nilai literal; perhatikan **Dart tidak mengizinkan implicit fall-through**.
  * `break` : mengakhiri case (atau gunakan `return`, `throw`, atau `continue caseLabel` jika perlu memindahkan kontrol).

**Catatan tambahan Dart:** kondisi harus `bool`. Tidak ada implicit truthiness. `for-in` aman untuk koleksi yang tidak diubah selama iterasi.

---

# Contoh lengkap: **LUA** — identity & persiapan singkat

**Identitas singkat Lua**

* **Dibuat oleh:** tim PUC-Rio (Roberto Ierusalimschy, dkk.).
* **Implementasi inti:** interpreter dalam bahasa C (sumber di `lua.org`).
* **Dokumentasi referensi:** *Lua Reference Manual* dan buku *Programming in Lua*.
  **Persiapan untuk mengembangkan / memodifikasi kode Lua**
* Pasang interpreter `lua` (atau `luajit` untuk performa), gunakan `luarocks` untuk paket.
* Untuk memodifikasi interpreter: pengetahuan C, Makefile/build, baca source repo Lua.
* CLI help: `lua -v`, `man lua`.

### Contoh Lua (if, for, while, repeat, no-switch built-in) + penjelasan kata-per-kata

```lua
local x = 3

-- if / elseif / else
if x % 2 == 0 then
  print("even")
elseif x > 10 then
  print("greater than 10")
else
  print("odd and <= 10")
end

-- numeric for
for i = 1, 5 do
  print("i = " .. i)
  if i == 3 then break end
end

-- generic for (iterate table)
local t = {10, 20, 30}
for idx, val in ipairs(t) do
  print(idx, val)
end

-- while
local n = 2
while n > 0 do
  n = n - 1
end

-- repeat-until (post-test)
local y = 0
repeat
  y = y + 1
until y >= 1

-- "switch" style via table dispatch
local function switch_example(tag)
  local cases = {
    A = function() print("case A") end,
    B = function() print("case B") end
  }
  local f = cases[tag] or function() print("default case") end
  f()
end
switch_example('B')
```

**Penjelasan baris-per-baris (kata-per-kata) — bagian penting:**

* `local x = 3`

  * `local` : deklarasi variabel lokal dalam scope chunk/fungsi.
  * `x` : identifier.
  * `=` : assignment.
  * `3` : literal number.
  * Tidak ada titik koma: akhir baris otomatis diakhiri oleh newline.

* `if x % 2 == 0 then`

  * `if` : kata kunci kondisi.
  * `x % 2` : sisa pembagian (operator modulus).
  * `== 0` : perbandingan; hasilnya boolean.
  * `then` : mulai blok kondisi (syntax Lua).

* `elseif x > 10 then` / `else` / `end`

  * `elseif` : cabang tambahan.
  * `end` : menutup struktur `if`.

* `for i = 1, 5 do`

  * `for` : numeric for loop.
  * `i = 1, 5` : inisialisasi `i=1` dan kondisi sampai `5` (inkremen default 1).
  * `do` : mulai block loop.
  * `i` variabel lokal ke loop (scope terbatas di dalam loop).

* `for idx, val in ipairs(t) do`

  * `in` : generic for (iterasi menggunakan iterator function).
  * `ipairs(t)` : iterator standar untuk indeks numerik berurutan.
  * `idx, val` : multiple assignment tiap iterasi.

* `while n > 0 do ... end`

  * `while` : pre-test loop; `do` dan `end` membatasi block.

* `repeat ... until y >= 1`

  * `repeat` : mulai block post-test.
  * `until` : cek kondisi, jika `false` ulangi.

* **"Switch" via table dispatch:**

  * `local cases = { A = function() ... end, B = function() ... end }` : table yang memetakan kunci ke fungsi.
  * `local f = cases[tag] or function() print("default case") end` : ambil fungsi dari table, jika nil gunakan fallback function.
  * `f()` : panggil fungsi terpilih.

**Catatan khusus Lua:**

* **Truthiness:** hanya `false` dan `nil` dianggap falsey; `0`, `""` (string kosong) dianggap truthy.
* **No `continue`:** standar Lua tidak memiliki `continue`; gunakan `goto label` atau susun ulang logika.
* **Tables:** struktur utama untuk objek/associative arrays — sangat berguna untuk dispatch pattern (switch emulasi).

---

# Best practices & jebakan praktis (perbandingan)

* **Dart**

  * Kondisi harus `bool` → mencegah bug akibat implicit truthiness.
  * `switch` tanpa fall-through membuat struktur kasus lebih aman.
  * Gunakan `final`/`const` bila memungkinkan agar state lebih mudah ditelusuri.
  * Hindari memodifikasi list saat `for-in` berjalan; gunakan indeks atau salinan.

* **Lua**

  * Ingat truthiness unik (`false` + `nil` falsey). Ketika memeriksa keberadaan kunci di table, gunakan `== nil` eksplisit bila perlu.
  * Untuk switch, gunakan table dispatch untuk performa dan keterbacaan.
  * Tidak ada `continue` — gunakan `goto` jika desain memerlukannya, tetapi prefer refactor agar lebih jelas.

---

# Tanda & sintaks penting (cheat sheet singkat)

* **Dart**: `if (cond) { } else if (cond2) { } else { }` ; `for (init; cond; update) { }` ; `for (var v in iterable) { }` ; `while (cond) { }` ; `do { } while (cond);` ; `switch(expr) { case v: ... break; default: ... }`
* **Lua**: `if cond then ... elseif cond2 then ... else ... end` ; `for i = a, b, step do ... end` ; `for k,v in pairs(t) do ... end` ; `while cond do ... end` ; `repeat ... until cond` ; no native `switch` — gunakan `if` atau `table` dispatch.

---

# Persiapan & tools untuk pengembangan/modifikasi (ringkas)

* **Dart**

  * Install: **Dart SDK**, editor (VSCode/Neovim + plugin `dart-code`/LSP).
  * Debugging/Testing: `dart run`, `dart test`, `dart analyze`.
  * Untuk berkontribusi ke runtime/kompiler: C++ skill, GN/Ninja, baca repo `github.com/dart-lang/sdk`.

* **Lua**

  * Install: `lua` interpreter (atau `luajit`), paket manager `luarocks`.
  * Tools: `lua -v`, REPL interactive, `luac` (bytecode).
  * Untuk mengubah interpreter: C skill, build via `make`, baca source di `www.lua.org`.

---

# Referensi & sumber bacaan (resmi / terverifikasi)

* **Dart language tour** — panduan bahasa resmi di *dart.dev* (Language tour, control flow).
* **Dart CLI** — `dart --help`, `dart run`, `dart analyze`.
* **Lua Reference Manual** — `lua.org/manual.html` dan buku *Programming in Lua* (Roberto Ierusalimschy).
* Dokumentasi resmi ini adalah titik rujukan untuk detail sintaks, prioritas operator, dan perilaku runtime.

---

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
