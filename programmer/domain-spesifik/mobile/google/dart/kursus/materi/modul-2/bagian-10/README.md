# [String Fundamentals][0]

### 1. Pendahuluan

String adalah salah satu tipe data paling dasar dan sering digunakan dalam hampir setiap aplikasi. String adalah urutan karakter. Dalam Dart, string merepresentasikan teks. Dart memiliki dukungan yang sangat kuat dan fleksibel untuk bekerja dengan string.

**Penting:** Di Dart, string adalah objek yang tidak dapat diubah (immutable). Ini berarti, setelah sebuah string dibuat, Anda tidak dapat mengubah isinya. Setiap operasi yang "memodifikasi" string sebenarnya akan membuat string baru.

### 2. Deklarasi String

Anda dapat mendeklarasikan string menggunakan tanda kutip tunggal (`'`) atau tanda kutip ganda (`"`). Keduanya berfungsi sama.

```dart
void main() {
  String singleQuoteString = 'Ini adalah string dengan kutip tunggal.';
  String doubleQuoteString = "Ini adalah string dengan kutip ganda.";

  print(singleQuoteString);
  print(doubleQuoteString);
}
```

- **Kapan menggunakan yang mana?** Ini lebih ke masalah gaya. Pilih salah satu dan konsistenlah dalam proyek Anda. Jika string Anda mengandung tanda kutip, gunakan jenis kutip yang lain untuk menghindari _escaping_.

  ```dart
  String withSingleQuote = "Don't do that!"; // Kutip ganda menampung kutip tunggal
  String withDoubleQuote = 'He said, "Hello!"'; // Kutip tunggal menampung kutip ganda
  ```

### 3. String Multi-Baris

Untuk string yang membentang beberapa baris, Anda dapat menggunakan tiga tanda kutip tunggal (`'''`) atau tiga tanda kutip ganda (`"""`). Spasi dan _line breaks_ akan dipertahankan.

```dart
void main() {
  String multiLineString1 = '''
Ini adalah baris pertama.
Ini adalah baris kedua.
Ini adalah baris ketiga.
''';

  String multiLineString2 = """
Ini juga string multi-baris.
Dengan tanda kutip ganda.
""";

  print(multiLineString1);
  print(multiLineString2);
}
```

Output:

```
Ini adalah baris pertama.
Ini adalah baris kedua.
Ini adalah baris ketiga.

Ini juga string multi-baris.
Dengan tanda kutip ganda.
```

### 4. String Interpolation (Penggabungan String)

Seperti yang sudah kita bahas sebelumnya, String Interpolation adalah cara yang disarankan untuk menggabungkan string dengan nilai variabel atau ekspresi. Ini jauh lebih bersih daripada menggunakan operator `+`.

- **`$variableName`**: Untuk menyisipkan nilai variabel.
- **`${expression}`**: Untuk menyisipkan hasil ekspresi yang lebih kompleks.

```dart
void main() {
  String nama = "Alice";
  int usia = 25;
  double harga = 10.5;

  print("Halo, nama saya $nama dan saya berusia $usia tahun.");
  // Output: Halo, nama saya Alice dan saya berusia 25 tahun.

  print("Total harga: Rp${harga * 2}.");
  // Output: Total harga: Rp21.0.

  String teks = "Dart";
  print("Panjang dari kata '${teks}' adalah ${teks.length}.");
  // Output: Panjang dari kata 'Dart' adalah 4.
}
```

### 5. Penggabungan String (Concatenation)

Meskipun interpolation adalah metode yang direkomendasikan, Anda masih bisa menggabungkan string menggunakan operator `+`.

```dart
void main() {
  String firstName = "John";
  String lastName = "Doe";

  String fullName = firstName + " " + lastName;
  print(fullName); // Output: John Doe

  // String literal yang berdekatan otomatis digabungkan oleh kompiler
  String pesanPanjang = 'Baris pertama '
      'baris kedua '
      'baris ketiga.';
  print(pesanPanjang); // Output: Baris pertama baris kedua baris ketiga.
}
```

**Catatan:** Untuk penggabungan string dalam _loop_ atau skenario _high-performance_ di mana Anda membangun string besar secara iteratif, lebih baik menggunakan `StringBuffer` untuk efisiensi memori.

```dart
void main() {
  var sb = StringBuffer();
  for (int i = 0; i < 5; i++) {
    sb.write('Item ke-$i. ');
  }
  print(sb.toString()); // Output: Item ke-0. Item ke-1. Item ke-2. Item ke-3. Item ke-4.
}
```

### 6. Raw String (String Mentah)

Jika Anda ingin menghindari interpretasi karakter khusus seperti `\` (backslash) untuk _escape sequence_ (`\n` untuk baris baru, `\t` untuk tab, dll.), Anda dapat menggunakan _raw string_ dengan menambahkan prefiks `r` sebelum tanda kutip.

```dart
void main() {
  print("Baris pertama\nBaris kedua."); // Output: Baris pertama (baris baru) Baris kedua.
  print(r"Baris pertama\nBaris kedua."); // Output: Baris pertama\nBaris kedua. (literal \n)

  String path = r"C:\Program Files\Dart\bin";
  print(path); // Output: C:\Program Files\Dart\bin
}
```

Ini sangat berguna saat bekerja dengan _regular expressions_ atau path sistem file.

### 7. Karakter Escape (Escape Sequences)

Untuk menyertakan karakter khusus yang sulit diketik langsung, Dart menggunakan _escape sequences_ yang dimulai dengan `\`.

- `\n`: Baris baru (newline)
- `\t`: Tab
- `\'`: Kutip tunggal (jika string dikelilingi kutip tunggal)
- `\"`: Kutip ganda (jika string dikelilingi kutip ganda)
- `\\`: Backslash
- `\uXXXX`: Karakter Unicode, di mana `XXXX` adalah 4 digit heksadesimal.
- `\u{XXXXXX}`: Karakter Unicode, di mana `XXXXXX` adalah 1 hingga 6 digit heksadesimal (untuk _code points_ di atas FFFF).

```dart
void main() {
  print('Ini adalah baris pertama.\nIni adalah baris kedua.');
  print('Pengaturan lokasi:\tIndonesia');
  print('Dia berkata, "Halo!"'); // Perhatikan kutip tunggal di luar
  print("Dia berkata, \"Halo!\""); // Perhatikan kutip ganda di luar
  print("Ini adalah backslash: \\");
  print("Simbol hati: \u2665"); // Unicode Heart Symbol
  print("Emoji senyum: \u{1F600}"); // Unicode Grinning Face Emoji
}
```

### 8. Properti dan Metode String Penting

Dart `String` adalah objek dengan banyak properti dan metode yang berguna.

| Properti/Metode                              | Deskripsi                                                                  | Contoh                                                    |
| :------------------------------------------- | :------------------------------------------------------------------------- | :-------------------------------------------------------- |
| `length`                                     | Mengembalikan panjang string (jumlah _code units_).                        | `'Hello'.length` // 5                                     |
| `isEmpty`                                    | Mengembalikan `true` jika string kosong.                                   | `('').isEmpty` // true                                    |
| `isNotEmpty`                                 | Mengembalikan `true` jika string tidak kosong.                             | `'abc'.isNotEmpty` // true                                |
| `[index]`                                    | Mengakses karakter pada posisi tertentu (sebagai string 1 karakter).       | `'Dart'[0]` // 'D'                                        |
| `contains(Pattern other)`                    | Memeriksa apakah string mengandung substring lain.                         | `'Hello World'.contains('World')` // true                 |
| `startsWith(Pattern other)`                  | Memeriksa apakah string dimulai dengan substring lain.                     | `'Apple'.startsWith('App')` // true                       |
| `endsWith(Pattern other)`                    | Memeriksa apakah string diakhiri dengan substring lain.                    | `'Banana'.endsWith('ana')` // true                        |
| `indexOf(Pattern other)`                     | Mengembalikan indeks kemunculan pertama substring, atau -1 jika tidak ada. | `'ababa'.indexOf('ba')` // 1                              |
| `lastIndexOf(Pattern other)`                 | Mengembalikan indeks kemunculan terakhir substring.                        | `'ababa'.lastIndexOf('ba')` // 3                          |
| `substring(int startIndex, [int? endIndex])` | Mengekstrak bagian string.                                                 | `'Dart Programming'.substring(5, 10)` // 'Progr'          |
| `split(Pattern pattern)`                     | Memisahkan string menjadi `List<String>` berdasarkan delimiter.            | `'satu,dua,tiga'.split(',')` // `['satu', 'dua', 'tiga']` |
| `replaceAll(Pattern from, String replace)`   | Mengganti semua kemunculan substring.                                      | `'banana'.replaceAll('a', 'o')` // 'bonono'               |
| `toUpperCase()`                              | Mengonversi string menjadi huruf kapital.                                  | `'hello'.toUpperCase()` // 'HELLO'                        |
| `toLowerCase()`                              | Mengonversi string menjadi huruf kecil.                                    | `'HELLO'.toLowerCase()` // 'hello'                        |
| `trim()`                                     | Menghapus spasi (whitespace) di awal dan akhir string.                     | `'  abc  '.trim()` // 'abc'                               |
| `trimLeft()`                                 | Menghapus spasi di awal string.                                            | `'  abc  '.trimLeft()` // 'abc '                          |
| `trimRight()`                                | Menghapus spasi di akhir string.                                           | `'  abc  '.trimRight()` // ' abc'                         |
| `compareTo(String other)`                    | Membandingkan dua string secara leksikografis (mengembalikan int).         | `'a'.compareTo('b')` // -1                                |
| `codeUnitAt(int index)`                      | Mengembalikan _code unit_ (nilai UTF-16) karakter pada indeks.             | `'A'.codeUnitAt(0)` // 65                                 |
| `codeUnits`                                  | Mengembalikan `List<int>` dari semua _code units_ string.                  | `'abc'.codeUnits` // `[97, 98, 99]`                       |
| `runes`                                      | Mengembalikan _iterable_ `Runes` (Unicode _code points_).                  | `'😀'.runes.first` // 128512                              |

**Contoh Penggunaan Metode:**

```dart
void main() {
  String kalimat = "  Halo Dunia! Ini Dart.  ";

  print("Original: '$kalimat'");
  print("Panjang: ${kalimat.length}"); // Output: 25 (termasuk spasi)

  String trimmed = kalimat.trim();
  print("Trimmed: '$trimmed'"); // Output: 'Halo Dunia! Ini Dart.'
  print("Panjang Trimmed: ${trimmed.length}"); // Output: 21

  print("Huruf kapital: ${trimmed.toUpperCase()}"); // Output: HALO DUNIA! INI DART.
  print("Huruf kecil: ${trimmed.toLowerCase()}");   // Output: halo dunia! ini dart.

  print("Mengandung 'Dunia'? ${trimmed.contains('Dunia')}"); // Output: true
  print("Dimulai dengan 'Halo'? ${trimmed.startsWith('Halo')}"); // Output: true

  String bagian = trimmed.substring(5, 11); // 'Dunia!'
  print("Bagian: '$bagian'"); // Output: 'Dunia!'

  List<String> kataKata = trimmed.split(' ');
  print("Kata-kata: $kataKata"); // Output: [Halo, Dunia!, Ini, Dart.]

  String diganti = trimmed.replaceAll('Dunia', 'Semua');
  print("Diganti: '$diganti'"); // Output: 'Halo Semua! Ini Dart.'

  String angka = "123";
  int num = int.parse(angka); // Konversi string ke int
  print("Angka: ${num + 1}"); // Output: 124
}
```

### 9. Unicode dan Grapheme Clusters

Dart `String` adalah urutan _UTF-16 code units_. Namun, karakter yang terlihat oleh manusia (grapheme clusters) bisa terdiri dari satu atau lebih _code units_ atau _code points_. Untuk bekerja dengan karakter yang sebenarnya, terutama saat menangani emoji atau karakter dari bahasa lain, Anda mungkin perlu menggunakan _packages_ seperti `characters` dari Flutter (atau Dart).

- `String.length` mengembalikan jumlah _UTF-16 code units_, bukan jumlah karakter yang terlihat.
- `String.runes` memberikan _iterable_ dari _Unicode code points_.

```dart
void main() {
  String emoji = '😀'; // Grapheme cluster (1 karakter visual)
  print('Panjang emoji (code units): ${emoji.length}'); // Output: 2 (karena diwakili oleh 2 UTF-16 code units)
  print('Code points emoji: ${emoji.runes.first}'); // Output: 128512 (nilai Unicode code point)

  String family = '👨‍👩‍👧‍👦'; // Contoh grapheme cluster kompleks
  print('Panjang keluarga (code units): ${family.length}'); // Output: 11
  print('Code points keluarga: ${family.runes.length}'); // Output: 4 (jumlah code points)
}
```

### 10. Ringkasan

String adalah bagian integral dari Dart, dan Dart menyediakan banyak fitur untuk mempermudah manipulasi teks.

- Gunakan tanda kutip tunggal atau ganda untuk deklarasi string.
- Manfaatkan tanda kutip tiga untuk string multi-baris.
- Selalu pilih **String Interpolation** (`$variabel` atau `${ekspresi}`) untuk penggabungan string yang lebih bersih.
- Gunakan **Raw String** (`r'...'`) saat perlu menghindari _escape sequences_.
- Pahami **karakter escape** untuk menyisipkan karakter khusus.
- Kuasai **properti dan metode string** yang kaya untuk berbagai operasi teks.
- Ingat bahwa string bersifat **immutable**; setiap "modifikasi" menghasilkan string baru.

Pemahaman yang kuat tentang String Fundamentals adalah kunci untuk bekerja secara efektif dengan data tekstual dalam aplikasi Dart Anda.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md

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
