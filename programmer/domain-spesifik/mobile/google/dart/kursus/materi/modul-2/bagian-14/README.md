# String Methods

<details>
  <summary>📃 Daftar Isi</summary>

- [String Methods](#string-methods)
  - [1. Pendahuluan](#1-pendahuluan)
  - [2. Properti Umum String](#2-properti-umum-string)
  - [3. Metode Pemeriksaan (Checking Methods)](#3-metode-pemeriksaan-checking-methods)
    - [`isEmpty` / `isNotEmpty`](#isempty--isnotempty)
    - [`contains(Pattern other)`](#containspattern-other)
    - [`startsWith(Pattern other)`](#startswithpattern-other)
    - [`endsWith(String other)`](#endswithstring-other)
  - [4. Metode Pencarian dan Pengambilan (Searching and Retrieving Methods)](#4-metode-pencarian-dan-pengambilan-searching-and-retrieving-methods)
    - [`indexOf(Pattern other, [int startIndex = 0])`](#indexofpattern-other-int-startindex--0)
    - [`lastIndexOf(Pattern other, [int? startIndex])`](#lastindexofpattern-other-int-startindex)
    - [`substring(int startIndex, [int? endIndex])`](#substringint-startindex-int-endindex)
    - [`split(Pattern pattern)`](#splitpattern-pattern)
    - [`splitMapJoin(Pattern pattern, {String? onMatch(Match), String? onNonMatch(String)})`](#splitmapjoinpattern-pattern-string-onmatchmatch-string-onnonmatchstring)
    - [`codeUnitAt(int index)` / `codeUnits` / `runes`](#codeunitatint-index--codeunits--runes)
  - [5. Metode Manipulasi (Manipulation Methods)](#5-metode-manipulasi-manipulation-methods)
    - [`toLowerCase()` / `toUpperCase()`](#tolowercase--touppercase)
    - [`trim()` / `trimLeft()` / `trimRight()`](#trim--trimleft--trimright)
    - [`replaceFirst()` / `replaceAll()` / `replaceRange()`](#replacefirst--replaceall--replacerange)
    - [`padLeft(int width, [String padding = ' '])` / `padRight(int width, [String padding = ' '])`](#padleftint-width-string-padding-----padrightint-width-string-padding---)
  - [6. Metode Perbandingan (Comparison Methods)](#6-metode-perbandingan-comparison-methods)
    - [`compareTo(String other)`](#comparetostring-other)
    - [Operator Kesamaan (`==`)](#operator-kesamaan-)
  - [7. Konversi String (Parsing)](#7-konversi-string-parsing)
  - [8. Ringkasan](#8-ringkasan)

---

</details>

### 1\. Pendahuluan

String adalah tipe data fundamental untuk bekerja dengan teks di Dart. Kelas `String` di Dart (bagian dari library `dart:core`) menyediakan banyak properti dan metode bawaan yang memungkinkan Anda untuk memeriksa, memanipulasi, mencari, dan membandingkan string dengan efisien.

Mengingat bahwa **string di Dart bersifat _immutable_** (tidak dapat diubah setelah dibuat), hampir semua metode manipulasi string akan **mengembalikan string baru** dan tidak mengubah string asli.

---

### 2\. Properti Umum String

Sebelum masuk ke metode, ada beberapa properti (atribut) penting dari objek `String` yang sering digunakan:

- **`length`**: Mengembalikan panjang string (jumlah _UTF-16 code units_).
- **`isEmpty`**: Mengembalikan `true` jika string kosong (`''`).
- **`isNotEmpty`**: Mengembalikan `true` jika string tidak kosong.

<!-- end list -->

```dart
void main() {
  String greeting = "Hello Dart!";
  String emptyString = "";
  String spaceString = " ";

  print("Panjang 'greeting': ${greeting.length}");     // Output: 11
  print("Is 'emptyString' empty? ${emptyString.isEmpty}"); // Output: true
  print("Is 'greeting' not empty? ${greeting.isNotEmpty}"); // Output: true
  print("Is 'spaceString' empty? ${spaceString.isEmpty}"); // Output: false (spasi dihitung)
}
```

---

### 3\. Metode Pemeriksaan (Checking Methods)

Metode-metode ini digunakan untuk memeriksa karakteristik atau keberadaan substring dalam sebuah string.

#### `isEmpty` / `isNotEmpty`

Sudah dibahas di properti, tapi perlu diingat fungsinya.

#### `contains(Pattern other)`

Memeriksa apakah string ini berisi pola yang ditentukan (`other`). Pola bisa berupa `String` atau `RegExp`. Mengembalikan `true` atau `false`.

```dart
void main() {
  String sentence = "The quick brown fox jumps over the lazy dog.";

  print(sentence.contains("fox"));       // Output: true
  print(sentence.contains("cat"));       // Output: false
  print(sentence.contains("quick brown")); // Output: true

  // Dengan RegExp
  print(sentence.contains(RegExp(r'\d'))); // Output: false (tidak ada digit)
}
```

#### `startsWith(Pattern other)`

Memeriksa apakah string ini dimulai dengan pola yang ditentukan.

```dart
void main() {
  String filename = "document.pdf";

  print(filename.startsWith("doc"));    // Output: true
  print(filename.startsWith("report")); // Output: false
  print(filename.startsWith(".pdf", 9)); // Mulai dari indeks 9: Output: true ('.pdf' ada di indeks 9)
}
```

#### `endsWith(String other)`

Memeriksa apakah string ini diakhiri dengan string yang ditentukan.

```dart
void main() {
  String filename = "image.jpg";

  print(filename.endsWith(".jpg"));    // Output: true
  print(filename.endsWith(".png"));    // Output: false
}
```

---

### 4\. Metode Pencarian dan Pengambilan (Searching and Retrieving Methods)

Metode-metode ini membantu menemukan posisi substring atau mengambil bagian dari string.

#### `indexOf(Pattern other, [int startIndex = 0])`

Mengembalikan indeks kemunculan pertama dari pola yang ditentukan. Mengembalikan `-1` jika pola tidak ditemukan. Anda bisa menentukan `startIndex` untuk memulai pencarian dari indeks tertentu.

```dart
void main() {
  String text = "banana";

  print(text.indexOf("an"));      // Output: 1 (kemunculan pertama 'an' ada di indeks 1)
  print(text.indexOf("na", 2));   // Output: 2 (cari 'na' mulai dari indeks 2)
  print(text.indexOf("xyz"));     // Output: -1
}
```

#### `lastIndexOf(Pattern other, [int? startIndex])`

Mengembalikan indeks kemunculan terakhir dari pola yang ditentukan. Mengembalikan `-1` jika pola tidak ditemukan. Pencarian dimulai dari `startIndex` ke belakang, atau dari akhir string jika `startIndex` tidak diberikan.

```dart
void main() {
  String text = "abracadabra";

  print(text.lastIndexOf("a"));     // Output: 10
  print(text.lastIndexOf("bra"));   // Output: 7
}
```

#### `substring(int startIndex, [int? endIndex])`

Mengekstrak bagian string dari `startIndex` hingga (tidak termasuk) `endIndex`. Jika `endIndex` tidak diberikan, akan mengekstrak hingga akhir string.

```dart
void main() {
  String sentence = "Dart Programming";

  print(sentence.substring(0, 4));   // Output: "Dart"
  print(sentence.substring(5));      // Output: "Programming"
  print(sentence.substring(5, sentence.length - 4)); // Output: "Programm"
}
```

#### `split(Pattern pattern)`

Membagi string menjadi daftar substring (`List<String>`) berdasarkan pola yang ditentukan. Pola bisa berupa `String` atau `RegExp`.

```dart
void main() {
  String csvData = "apple,banana,cherry";
  List<String> fruits = csvData.split(',');
  print(fruits); // Output: [apple, banana, cherry]

  String sentence = "Hello world! This is a test.";
  List<String> words = sentence.split(' ');
  print(words); // Output: [Hello, world!, This, is, a, test.]

  // Split dengan RegExp
  String data = "id=123&name=Alice&city=NewYork";
  List<String> parts = data.split(RegExp(r'[&=]')); // Split berdasarkan '&' atau '='
  print(parts); // Output: [id, 123, name, Alice, city, NewYork]
}
```

#### `splitMapJoin(Pattern pattern, {String? onMatch(Match), String? onNonMatch(String)})`

Metode yang lebih canggih untuk membagi string, memungkinkan Anda untuk memetakan bagian yang cocok dan tidak cocok dengan pola.

```dart
void main() {
  String sentence = "One two three four";
  String result = sentence.splitMapJoin(
    RegExp(r'\s+'), // Pecah berdasarkan satu atau lebih spasi
    onMatch: (m) => '-', // Ganti spasi dengan strip
    onNonMatch: (nm) => nm.toUpperCase(), // Ubah kata menjadi huruf besar
  );
  print(result); // Output: ONE-TWO-THREE-FOUR
}
```

#### `codeUnitAt(int index)` / `codeUnits` / `runes`

Ini berkaitan dengan representasi karakter Unicode dalam string.

- **`codeUnitAt(int index)`**: Mengembalikan _UTF-16 code unit_ pada indeks tertentu.
- **`codeUnits`**: Mengembalikan _list_ dari semua _UTF-16 code units_ dalam string.
- **`runes`**: Mengembalikan objek `Runes` (iterable dari _Unicode code points_). Penting untuk bekerja dengan karakter di luar Basic Multilingual Plane (BMP), seperti emoji.

<!-- end list -->

```dart
void main() {
  String normalChar = "A";
  print("Code unit 'A': ${normalChar.codeUnitAt(0)}"); // Output: 65

  String complexChar = "😀"; // Emoji (diwakili oleh 2 code units UTF-16)
  print("Length '😀': ${complexChar.length}");          // Output: 2
  print("Code units '😀': ${complexChar.codeUnits}");    // Output: [55357, 56832]

  // Menggunakan runes untuk mendapatkan code point yang benar
  print("Runes '😀': ${complexChar.runes.first}"); // Output: 128512
  // Anda bisa mengonversi rune kembali ke string
  print(String.fromCharCode(complexChar.runes.first)); // Output: 😀
}
```

---

### 5\. Metode Manipulasi (Manipulation Methods)

Metode-metode ini mengembalikan string baru yang merupakan hasil modifikasi dari string asli.

#### `toLowerCase()` / `toUpperCase()`

Mengembalikan string baru dengan semua karakter diubah menjadi huruf kecil atau huruf kapital.

```dart
void main() {
  String mixedCase = "Hello World";

  print(mixedCase.toLowerCase()); // Output: hello world
  print(mixedCase.toUpperCase()); // Output: HELLO WORLD
}
```

#### `trim()` / `trimLeft()` / `trimRight()`

Menghapus spasi (whitespace) dari awal dan/atau akhir string.

- `trim()`: Menghapus spasi di kedua sisi.
- `trimLeft()`: Menghapus spasi di sisi kiri.
- `trimRight()`: Menghapus spasi di sisi kanan.

<!-- end list -->

```dart
void main() {
  String paddedString = "   Dart Programming   ";

  print("Original: '${paddedString}'");
  print("Trimmed: '${paddedString.trim()}'");       // Output: 'Dart Programming'
  print("TrimLeft: '${paddedString.trimLeft()}'");   // Output: 'Dart Programming   '
  print("TrimRight: '${paddedString.trimRight()}'"); // Output: '   Dart Programming'
}
```

#### `replaceFirst()` / `replaceAll()` / `replaceRange()`

Mengganti bagian dari string.

- **`replaceFirst(Pattern from, String replace)`**: Mengganti kemunculan pertama dari pola.
- **`replaceAll(Pattern from, String replace)`**: Mengganti semua kemunculan pola.
- **`replaceRange(int start, int end, String replacement)`**: Mengganti rentang indeks dengan string lain.

<!-- end list -->

```dart
void main() {
  String sentence = "apple,banana,apple,orange";

  print(sentence.replaceFirst("apple", "grape")); // Output: grape,banana,apple,orange
  print(sentence.replaceAll("apple", "kiwi"));    // Output: kiwi,banana,kiwi,orange

  String text = "Dart is fun.";
  print(text.replaceRange(0, 4, "Flutter")); // Output: Flutter is fun.
}
```

#### `padLeft(int width, [String padding = ' '])` / `padRight(int width, [String padding = ' '])`

Menambahkan karakter padding ke sisi kiri atau kanan string hingga mencapai `width` tertentu.

```dart
void main() {
  String number = "42";

  print(number.padLeft(5, '0'));   // Output: 00042
  print(number.padRight(5, '*'));  // Output: 42***

  String name = "Alice";
  print(name.padRight(10, '.')); // Output: Alice.....
}
```

---

### 6\. Metode Perbandingan (Comparison Methods)

#### `compareTo(String other)`

Membandingkan string ini dengan string lain secara leksikografis (berdasarkan urutan karakter Unicode).

- Mengembalikan `0` jika string sama.
- Mengembalikan nilai `< 0` jika string ini lebih "kecil" dari `other`.
- Mengembalikan nilai `> 0` jika string ini lebih "besar" dari `other`.

<!-- end list -->

```dart
void main() {
  print("apple".compareTo("banana"));  // Output: -1 (apple < banana)
  print("banana".compareTo("apple"));  // Output: 1 (banana > apple)
  print("apple".compareTo("apple"));   // Output: 0 (apple == apple)
}
```

#### Operator Kesamaan (`==`)

Operator `==` digunakan untuk memeriksa kesamaan nilai string. Ini adalah cara paling umum dan direkomendasikan untuk membandingkan string di Dart.

```dart
void main() {
  String s1 = "hello";
  String s2 = "hello";
  String s3 = "world";

  print(s1 == s2); // Output: true
  print(s1 == s3); // Output: false
}
```

---

### 7\. Konversi String (Parsing)

Perlu diingat bahwa tidak ada metode `String.parse()`. Untuk mengonversi string ke tipe numerik atau boolean, Anda menggunakan metode `parse()` yang ada pada kelas target (`int`, `double`, `bool`).

- **`int.parse(String source)`**: Mengonversi string ke `int`. Melempar `FormatException` jika gagal.
- **`double.parse(String source)`**: Mengonversi string ke `double`. Melempar `FormatException` jika gagal.
- **`bool.parse(String source)`**: Mengonversi string ke `bool`. Mengembalikan `true` jika string adalah `'true'` (case-insensitive), selain itu `false`.

<!-- end list -->

```dart
void main() {
  String numStr = "123";
  int number = int.parse(numStr);
  print(number * 2); // Output: 246

  String doubleStr = "3.14";
  double pi = double.parse(doubleStr);
  print(pi / 2); // Output: 1.57

  String boolTrueStr = "true";
  bool isTrue = bool.parse(boolTrueStr);
  print(isTrue); // Output: true

  String boolFalseStr = "FALSE"; // Case-insensitive
  bool isFalse = bool.parse(boolFalseStr);
  print(isFalse); // Output: false

  // Menggunakan tryParse() untuk menghindari exception
  String invalidNum = "abc";
  int? safeNumber = int.tryParse(invalidNum);
  print(safeNumber); // Output: null
}
```

---

### 8\. Ringkasan

Kelas `String` di Dart menyediakan kumpulan metode dan properti yang sangat kaya untuk bekerja dengan teks secara efektif. Mengingat sifat _immutable_ dari string di Dart, penting untuk diingat bahwa sebagian besar operasi manipulasi akan mengembalikan string baru.

Dengan menguasai metode-metode ini, Anda dapat melakukan berbagai tugas pemrosesan teks, mulai dari validasi sederhana hingga manipulasi data yang kompleks, dengan mudah dan efisien dalam aplikasi Dart Anda.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-13/README.md
[selanjutnya]: ../bagian-15/README.md

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
