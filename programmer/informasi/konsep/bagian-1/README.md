# Variabel, Tipe Data, dan Ekspresi

---

# 1. Variabel — konsep & rincian teknis

**Definisi singkat:** variabel adalah nama simbolik yang menunjuk ke lokasi penyimpanan nilai dalam program. Ia berfungsi sebagai *identifier* untuk membaca/menulis nilai.

**Aspek penting:**

* **Deklarasi vs Inisialisasi**

  * *Deklarasi* = memperkenalkan identifier ke compiler/interpreter.
  * *Inisialisasi* = memberi nilai awal pada variabel.
* **Tipe (static/dinamik)**

  * *Static typing:* tipe diketahui saat waktu kompilasi (mis. Dart dengan tipe statis opsional).
  * *Dynamic typing:* tipe ditentukan saat runtime (mis. Lua).
* **Mutabilitas**

  * Bisa *mutable* (nilai dapat diubah) atau *immutable/konstan* (nilai tetap).
* **Ruang lingkup (scope)**

  * *Global*, *local*, *block scope* (mis. `{}` di banyak bahasa), *function scope*.
* **Lifetime & storage**

  * Variabel lokal biasanya di-stack; objek yang dialokasikan dinamis di-heap (bahasa runtime-managed di-manage oleh garbage collector).
* **Nama variabel (naming)**

  * Harus mengikuti aturan lexer/tokenizer: huruf/underscore awal, alfanumerik setelahnya; hindari kata kunci.

---

# 2. Tipe Data — kategorisasi dan teknis

**Pembagian umum:**

* **Primitif**: integer, floating-point (float/double), boolean, char.
* **String**: urutan karakter; sering immutable di banyak bahasa.
* **Composite / Struktur data**: array, list, tuple, map/dictionary, record, object/class.
* **Special**: `null` / `nil` / `undefined`, `function` (first-class), `enum`.
* **User-defined**: `struct`, `class`, `typedef`, union, dsb.

**Sifat sistem tipe:**

* **Strong vs Weak typing** — seberapa ketat konversi implisit diperbolehkan.
* **Nominal vs Structural** — cara tipe dibandingkan.
* **Type coercion** dan *implicit conversion* (berbahaya jika tidak dipahami).

**Representasi memori (ringkas):**

* Integer/float tersimpan sebagai bit di register/heap; string biasanya pointer + length + konten di heap; objek kompleks memiliki header (garbage collector, vtable/tipe-info) + field.

---

# 3. Ekspresi — definisi & aturan evaluasi

**Definisi:** ekspresi adalah kombinasi literal, variabel, operator, dan pemanggilan fungsi yang dievaluasi menjadi sebuah nilai.

**Contoh kelas operator:**

* Aritmetika: `+ - * / %`
* Perbandingan: `== != < <= > >=`
* Logika: `&& || !` (atau `and/or/not` di Lua)
* Bitwise: `& | ^ ~ << >>`
* Assignment: `=`, compound `+=`, `-=`, dsb.
* Unary & ternary: unary `-`, `!`; ternary `cond ? a : b` (tidak ada di Lua)

**Poin penting:**

* **Precedence & associativity** menentukan urutan evaluasi.
* **Short-circuit**: operator logika sering menghentikan evaluasi (mis. `a && b` tidak mengevaluasi `b` jika `a` false).
* **Side effects**: ekspresi bisa mempunyai efek samping (assignment, pemanggilan fungsi yang mengubah state).
* **Pure expression** = tidak memiliki efek samping — lebih mudah diuji dan dioptimalkan.

---

# 4. Contoh singkat: DART (tipikal statically typed modern language)

### Identitas singkat Dart

* **Dibuat oleh:** Google.
* **Implementasi inti:** runtime (Dart VM) ditulis sebagian besar dalam C++ (VM & runtime), kompiler `dart2js`/`dartdevc` untuk JS.
* **Sumber resmi:** `dart.dev`.
* **Persyaratan untuk mengembangkan/modifikasi:**

  * *Untuk menulis/menjalankan kode Dart:* pasang **Dart SDK** (tooling: `dart`, `pub`/`dart pub`), editor (VSCode/Neovim + plugin).
  * *Untuk memodifikasi runtime/kompiler:* pengetahuan C++ sangat diperlukan, build system (GN/Ninja), dan mempelajari kode sumber Dart di GitHub.
* **Bantuan CLI:** `dart --help`, `dart help <command>`, `dart format --help`.

#### Kode (Dart) — contoh dan penjelasan kata-per-kata

```dart
void main() {
  final int count = 5;
  var name = "Poweruser";
  double ratio = 3.5;
  bool active = true;

  // ekspresi: penjumlahan dan concat
  final int total = count + (ratio.toInt()); 
  print('$name has $total items');
}
```

**Penjelasan baris per baris, kata-per-kata:**

1. `void main() {`

   * `void` : tipe return fungsi `main` (tidak mengembalikan nilai).
   * `main` : nama fungsi entry point program.
   * `()` : tanda kurung parameter (kosong = tidak ada parameter).
   * `{` : mulai block fungsi.

2. `final int count = 5;`

   * `final` : kata kunci membuat variabel *immutable* (nilai hanya bisa di-set sekali).
   * `int` : tipe integer (32/64-bit tergantung implementasi).
   * `count` : identifier/variabel.
   * `=` : operator assignment.
   * `5` : literal integer.
   * `;` : akhir pernyataan.

3. `var name = "Poweruser";`

   * `var` : deklarasi variabel dengan *type inference* (compiler menetapkan tipe `String`).
   * `name` : identifier.
   * `"Poweruser"` : literal string (double quotes).

4. `double ratio = 3.5;`

   * `double` : tipe floating-point (double precision).
   * `ratio` : identifier.
   * `3.5` : literal floating.

5. `bool active = true;`

   * `bool` : tipe boolean.
   * `true` : literal boolean.

6. `final int total = count + (ratio.toInt());`

   * `total` : variabel immutable bertipe `int`.
   * `count + (...)` : ekspresi penjumlahan.
   * `ratio.toInt()` : pemanggilan metode pada `double` untuk mengonversi ke `int`; `()` menunjukkan pemanggilan fungsi/metode.
   * `( ... )` : parentheses memaksa evaluasi bagian di dalam terlebih dahulu.

7. `print('$name has $total items');`

   * `print` : fungsi bawaan untuk menulis ke stdout.
   * `'$name has $total items'` : *string interpolation* — `$name` dan `$total` digantikan dengan nilai variabel.
   * `;` : mengakhiri statement.

8. `}` : menutup block `main`.

**Catatan tipe & ekspresi di Dart:** Dart memisahkan *compile-time constants* (`const`) dan *run-time final* (`final`). `const` lebih ketat (harus diketahui pada kompilasi).

---

# 5. Contoh singkat: LUA (dynamically typed, embeddable)

### Identitas singkat Lua

* **Dibuat oleh:** Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes (PUC-Rio).
* **Implementasi:** interpreter/sumber utama ditulis dalam C.
* **Situs resmi:** `lua.org`.
* **Persyaratan untuk mengembangkan/modifikasi:**

  * *Untuk menulis script Lua:* pasang interpreter `lua` (runtime), dan paket manager `luarocks` bila perlu.
  * *Untuk memodifikasi interpreter:* pengetahuan C, build system (make), dan baca implementasi sumber Lua di repositori resmi.
* **Bantuan CLI:** `lua -v`, `man lua`, dokumentasi `lua.org/manual.html`.

#### Kode (Lua) — contoh dan penjelasan kata-per-kata

```lua
local count = 5
name = "Poweruser"
local ratio = 3.5
active = true

-- ekspresi dan tipe dinamis
local total = count + math.floor(ratio)
print(name .. " has " .. total .. " items")
```

**Penjelasan baris per baris, kata-per-kata:**

1. `local count = 5`

   * `local` : kata kunci membuat variabel *lokal* pada scope saat ini (fungsi atau chunk).
   * `count` : identifier.
   * `=` : assignment.
   * `5` : literal number (di Lua 5.3+ ada integer dan float; sebelum 5.3 semua `number` = float).

2. `name = "Poweruser"`

   * Tanpa `local` berarti variabel global (menetapkan di *global environment*).
   * `"Poweruser"` : string.

3. `local ratio = 3.5`

   * `ratio` bertipe `number` (floating).

4. `active = true`

   * `true` : tipe boolean; lagi-lagi global karena tanpa `local`.

5. `local total = count + math.floor(ratio)`

   * `math.floor` : fungsi dari library `math` yang mengembalikan floor(ratio).
   * `+` : operator aritmetika; Lua akan melakukan coercion sesuai tipe number.

6. `print(name .. " has " .. total .. " items")`

   * `print` : fungsi global untuk mencetak ke stdout.
   * `..` : operator konkatenasi string di Lua (menggabungkan string).
   * Jika salah satu operand bukan string, Lua memaksa konversi ke string jika memungkinkan.

**Catatan Lua:** tipe bersifat *dynamic* — variabel tidak diberi tipe eksplisit; tipe adalah properti nilai, bukan variabel. Struktur composite utama adalah **table** (serbaguna: array, dictionary, object-like).

---

# 6. Operator, Prioritas & Short-Circuit (ringkas)

* **Prioritas umum (dari tinggi ke rendah)**: unary (negasi), multiplicative `* / %`, additive `+ -`, shifts/bitwise, comparison, logical `and`/`or`. (Detail bisa berbeda per bahasa — lihat dokumentasi bahasa.)
* **Short-circuit**:

  * Dart: `&&` dan `||` short-circuit.
  * Lua: `and`/`or` juga short-circuit, tapi `and`/`or` mengembalikan operand aktual, bukan boolean kaku (truthy/falsey semantics).

---

# 7. Praktik terbaik dan jebakan umum

* **Selalu deklarasikan scope yang sesempurna mungkin**: gunakan `local` di Lua, `var/late/final/const` di Dart dengan tepat.
* **Hati-hati nullability**: dart memiliki sistem null-safety (`String?` vs `String`), pahami operator `?`, `!`, `??`.
* **Hindari side-effects di ekspresi yang sulit dibaca**: jangan gabungkan assignment berantai dengan pemanggilan fungsi yang mengubah state.
* **Bakuin gaya penamaan**: camelCase untuk variabel di Dart, snake_case kadang dipakai di Lua.
* **Performa**: alokasikan objek secukupnya; pahami kapan pembuatan objek kecil berulang menekan GC.

---

# 8. Bantuan & Referensi singkat

* **Dart (resmi):** dart.dev — dokumentasi bahasa, panduan SDK, `dart --help`.
* **Lua (resmi):** lua.org — reference manual; `man lua`.
* **Buku & spesifikasi:** "Programming in Lua" (Ierusalimschy) — referensi utama untuk Lua.
* **CLI help:**

  * Dart: `dart --help`, `dart format --help`, `dart run --help`.
  * Lua: `lua -v`, `man lua`, `luac -l` untuk listing bytecode (advanced).

---

# 9. Ringkasan cepat (cheat sheet)

* **Variabel:** nama → alamat → nilai. Deklarasi + inisialisasi. Perhatikan scope & mutability.
* **Tipe data:** primitive, composite, special (`nil`/`null`). Ketahui apakah bahasa Anda static/dynamic.
* **Ekspresi:** unit evaluasi → menghasilkan nilai; perhatikan precedence & side effects.

---

> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ./../../../../README.md
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
