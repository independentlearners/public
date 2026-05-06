# Literal

---

### 1. Contoh dasar (Dart)

```dart
var a = 10;        // 10 → integer literal
var b = "hello";   // "hello" → string literal
var c = true;      // true → boolean literal
```

Di sini:

* `10`, `"hello"`, `true` → semuanya literal
* `a`, `b`, `c` → identifier (variabel), bukan literal

---

### 2. Klasifikasi literal di Dart

Dalam Dart, literal cukup kaya karena mendukung struktur kompleks:

**a. Primitive literal**

```dart
42        // int literal
3.14      // double literal
true      // bool literal
"abc"     // string literal
null      // null literal
```

**b. Collection literal**

```dart
[1, 2, 3]                 // list literal
{'a': 1, 'b': 2}          // map literal
{'x', 'y', 'z'}           // set literal
```

**c. Const literal (compile-time constant)**

```dart
const pi = 3.14;
const list = [1, 2, 3];
```

Ini penting dalam *constant evaluation system* Dart.

---

### 3. Perbedaan penting: literal vs expression

```dart
var x = 5;        // 5 → literal
var y = 2 + 3;    // 2 dan 3 literal, tapi "2 + 3" adalah expression
```

* Literal → nilai langsung
* Expression → kombinasi operasi yang menghasilkan nilai

---

### 4. Perspektif lintas bahasa

Konsep literal bersifat universal, muncul di hampir semua bahasa:

* C
* Rust
* Lua

Contoh:

**C**

```c
int x = 10;      // 10 literal
char* s = "hi";  // string literal
```

**Lua**

```lua
local x = 10
local s = "hello"
```

**Rust**

```rust
let x = 10;
let s = "hello";
```

Semua bahasa ini menggunakan literal sebagai **entry point untuk value creation** dalam AST (*Abstract Syntax Tree*).

---

### 5. Level lebih dalam (penting untuk kamu sebagai engineer)

Literal tidak sekadar “nilai langsung”. Ia punya implikasi sistem:

**a. Parsing phase**

* Literal dikenali oleh lexer/parser
* Contoh: `"hello"` → token STRING_LITERAL

**b. Type inference**

```dart
var x = 10;
```

→ Dart infer `x` sebagai `int` dari literal `10`

**c. Memory model**

* String literal sering di-*intern*
* Numeric literal bisa langsung masuk ke register/stack

**d. Compile-time optimization**

```dart
const x = 2 + 3;
```

→ di-*folding* jadi `5`

---

### 6. Hubungan dengan pembelajaran kamu (Dart + CLI + Lua)

Ini poin kritis:

* Literal = fondasi untuk **data modeling**
* Sangat penting untuk:

  * CLI input/output mapping
  * konfigurasi tool
  * parsing command argument

Contoh CLI sederhana:

```dart
var commands = ['init', 'build', 'run'];
```

→ `'init'`, `'build'`, `'run'` adalah literal yang mendefinisikan interface CLI kamu

---

### 7. Kesalahan umum (hindari ini)

* Mengira literal = variabel ❌
* Mengira semua nilai adalah literal ❌
* Tidak memahami bahwa literal punya tipe implisit ❌

---

### Ringkasan inti

* Literal = nilai langsung di kode
* Bukan variabel, bukan hasil operasi
* Digunakan oleh compiler untuk inferensi tipe dan optimasi
* Berlaku universal di semua bahasa

---

Jika membaca hingga sampai titik ini maka level berikutnya yang logis adalah:

* memahami **“constant vs runtime value”**
* memahami **AST dan tokenization**
* memahami **type inference berbasis literal**

