# [Runes and Unicode][0]

Ini adalah topik yang sangat penting untuk dipahami, terutama jika Anda berurusan dengan teks dari berbagai bahasa di seluruh dunia, emoji, atau karakter khusus lainnya.

<details>
  <summary>📃 Daftar Isi</summary>

---

- [Runes and Unicode](#runes-and-unicode)
    - [1. Pendahuluan](#1-pendahuluan)
    - [2. Apa Itu Unicode?](#2-apa-itu-unicode)
      - [a. Code Point](#a-code-point)
      - [b. UTF-8, UTF-16, UTF-32](#b-utf-8-utf-16-utf-32)
    - [3. Bagaimana Dart Menangani String?](#3-bagaimana-dart-menangani-string)
      - [a. String sebagai Urutan UTF-16 Code Units](#a-string-sebagai-urutan-utf-16-code-units)
      - [b. Masalah dengan `String.length` dan Indeks](#b-masalah-dengan-stringlength-dan-indeks)
    - [4. `Runes` di Dart](#4-runes-di-dart)
      - [a. Definisi `Runes`](#a-definisi-runes)
      - [b. Sintaks dan Penggunaan `Runes`](#b-sintaks-dan-penggunaan-runes)
      - [c. Mengakses `Code Point` Individual](#c-mengakses-code-point-individual)
      - [d. Mengonversi `Code Point` Kembali ke String](#d-mengonversi-code-point-kembali-ke-string)
    - [5. `characters` Package (Solusi Rekomendasi)](#5-characters-package-solusi-rekomendasi)
      - [a. Mengapa `characters`?](#a-mengapa-characters)
      - [b. Contoh Penggunaan `characters`](#b-contoh-penggunaan-characters)
    - [6. Kapan Menggunakan `Runes` vs `characters`?](#6-kapan-menggunakan-runes-vs-characters)
    - [7. Ringkasan](#7-ringkasan)

</details>

---

### 1\. Pendahuluan

Di dunia modern, teks tidak hanya terbatas pada alfabet Latin dasar. Kita berurusan dengan berbagai bahasa dengan skrip yang berbeda, simbol matematika, emoji, dan karakter khusus lainnya. Untuk menangani semua ini secara konsisten dan akurat, dibutuhkan standar encoding karakter, dan itulah peran **Unicode**.

Dart, sebagai bahasa pemrograman modern, memiliki dukungan bawaan untuk Unicode. Namun, cara Dart merepresentasikan string secara internal (sebagai urutan _UTF-16 code units_) bisa menimbulkan kebingungan saat menghitung panjang string atau mengakses karakter jika kita tidak memahami konsep dasar **Unicode** dan **Runes**.

---

### 2\. Apa Itu Unicode?

**Unicode** adalah standar encoding karakter universal yang bertujuan untuk merepresentasikan setiap karakter dari semua bahasa di dunia, termasuk simbol dan emoji, dalam satu set karakter terpadu.

#### a. Code Point

Inti dari Unicode adalah **Code Point**. Sebuah _code point_ adalah nilai numerik unik (biasanya ditulis dalam format heksadesimal dengan prefiks `U+`) yang diberikan untuk setiap karakter dalam standar Unicode.

- Contoh:
  - `U+0041` adalah karakter 'A' (Latin Capital Letter A)
  - `U+03B1` adalah karakter 'α' (Greek Small Letter Alpha)
  - `U+1F600` adalah karakter '😀' (Grinning Face emoji)

#### b. UTF-8, UTF-16, UTF-32

_Code points_ ini perlu di-_encode_ menjadi _byte_ agar bisa disimpan atau ditransmisikan. Ada beberapa skema encoding Unicode yang umum:

- **UTF-8**: Encoding yang paling umum di web dan sistem file. Menggunakan 1 hingga 4 _byte_ per _code point_. Ini _backward-compatible_ dengan ASCII.
- **UTF-16**: Encoding yang digunakan secara internal oleh banyak sistem (termasuk Java, JavaScript, dan **Dart**). Menggunakan 1 atau 2 _code units_ 16-bit per _code point_. _Code points_ dalam Basic Multilingual Plane (BMP) (`U+0000` hingga `U+FFFF`) diwakili oleh satu _code unit_. _Code points_ di luar BMP (seperti sebagian besar emoji) diwakili oleh dua _code units_ (disebut _surrogate pair_).
- **UTF-32**: Menggunakan 4 _byte_ (1 _code unit_ 32-bit) per _code point_. Ini sederhana karena setiap _code point_ memiliki ukuran yang sama, tetapi sangat boros memori.

---

### 3\. Bagaimana Dart Menangani String?

Dart `String` adalah urutan dari **UTF-16 _code units_**. Ini adalah detail implementasi yang penting untuk dipahami.

#### a. String sebagai Urutan UTF-16 Code Units

Ketika Anda membuat string di Dart, string tersebut secara internal disimpan sebagai urutan angka 16-bit. Setiap angka 16-bit ini disebut _code unit_.

- Untuk karakter dalam Basic Multilingual Plane (BMP) (sebagian besar karakter Latin, Cyrillic, Greek, dll.), satu karakter biasanya diwakili oleh **satu _code unit_**.
- Untuk karakter di luar BMP (seperti emoji, beberapa karakter Tionghoa/Jepang langka), satu karakter tunggal dapat diwakili oleh **dua _code units_** (sepasang _surrogate_).

#### b. Masalah dengan `String.length` dan Indeks

Karena `String.length` mengembalikan jumlah _UTF-16 code units_, bukan jumlah _Unicode code points_ atau _grapheme clusters_ (karakter yang terlihat), ini bisa menyebabkan hasil yang tidak intuitif.

```dart
void main() {
  String text1 = "Hello"; // Semua karakter di BMP
  print("'$text1' length: ${text1.length}"); // Output: 5

  String text2 = "Dart!"; // Semua karakter di BMP
  print("'$text2' length: ${text2.length}"); // Output: 5

  String emoji = "😀"; // Emoji, di luar BMP
  print("'$emoji' length: ${emoji.length}"); // Output: 2 (bukan 1!)

  String flag = "🇮🇩"; // Bendera Indonesia (regional indicator symbols, sering 4 code units)
  print("'$flag' length: ${flag.length}"); // Output: 4

  String combinedChar = "é"; // 'e' + combining acute accent
  print("'$combinedChar' length: ${combinedChar.length}"); // Output: 2

  // Mengakses karakter dengan indeks juga bisa bermasalah
  print(emoji[0]); // Output: � (karakter aneh/tidak lengkap)
  print(emoji[1]); // Output: �
}
```

Contoh di atas menunjukkan bahwa `length` tidak selalu mencerminkan jumlah karakter yang terlihat atau _code points_. Mengakses `emoji[0]` tidak akan memberikan emoji secara lengkap karena `emoji` sebenarnya terdiri dari dua _code units_.

---

### 4\. `Runes` di Dart

Untuk mengatasi masalah ini dan bekerja dengan _Unicode code points_ (bukan _code units_), Dart menyediakan properti `runes` pada objek `String`.

#### a. Definisi `Runes`

Properti `runes` dari sebuah string mengembalikan sebuah _iterable_ dari objek `int` yang merepresentasikan **Unicode _code points_** string tersebut. Ini adalah cara Dart untuk melihat string pada level _code point_ yang lebih tinggi.

#### b. Sintaks dan Penggunaan `Runes`

Anda dapat mengakses `runes` langsung dari sebuah string:

```dart
void main() {
  String emoji = "😀";
  // runes akan mengembalikan Iterable<int> yang berisi code point
  print("Emoji code points: ${emoji.runes.toList()}"); // Output: [128512]
  print("Jumlah code points (runes.length): ${emoji.runes.length}"); // Output: 1

  String flag = "🇮🇩";
  print("Flag code points: ${flag.runes.toList()}"); // Output: [127470, 127465]
  print("Jumlah code points (runes.length): ${flag.runes.length}"); // Output: 2 (2 regional indicator symbols)

  String combinedChar = "é"; // 'e' + combining acute accent
  print("Combined char code points: ${combinedChar.runes.toList()}"); // Output: [101, 769]
  print("Jumlah code points (runes.length): ${combinedChar.runes.length}"); // Output: 2

  String text = "Hello 👋 dunia";
  print("Text code points: ${text.runes.toList()}");
  // Output: [72, 101, 108, 108, 111, 32, 128075, 32, 100, 117, 110, 105, 97]
  print("Jumlah code points (runes.length): ${text.runes.length}"); // Output: 13
  // Bandingkan dengan text.length: 15 (👋 adalah 2 code units)
}
```

#### c. Mengakses `Code Point` Individual

Anda bisa mengulang `runes` untuk memproses setiap _code point_:

```dart
void main() {
  String text = "Dart 😎";
  for (int rune in text.runes) {
    print(rune.toRadixString(16).padLeft(4, '0')); // Cetak dalam heksadesimal
  }
}
```

**Output:**

```
0044
0061
0072
0074
0020
1f60e
```

(D=0044, a=0061, r=0072, t=0074, spasi=0020, 😎=1f60e)

#### d. Mengonversi `Code Point` Kembali ke String

Anda dapat membuat string dari daftar _code points_ menggunakan `String.fromCharCode()` atau `String.fromCharCodes()`:

```dart
void main() {
  // Dari satu code point
  print(String.fromCharCode(0x1F600)); // Output: 😀

  // Dari daftar code points
  List<int> customChars = [0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x20, 0x1F31F]; // 'Hello ✨'
  print(String.fromCharCodes(customChars)); // Output: Hello ✨
}
```

---

### 5\. `characters` Package (Solusi Rekomendasi)

Meskipun `runes` memungkinkan Anda bekerja dengan _code points_, ini masih belum sepenuhnya menyelesaikan masalah karakter "visual" atau **grapheme clusters**. Contohnya, `é` (e dengan aksen akut) adalah dua _code points_ (`U+0065` 'e' dan `U+0301` combining acute accent), tetapi secara visual itu adalah satu "karakter".

Untuk menangani _grapheme clusters_ dengan benar, terutama di Flutter di mana rendering teks visual sangat penting, tim Dart/Flutter merekomendasikan penggunaan _package_ `characters`.

#### a. Mengapa `characters`?

- `characters` package menyediakan ekstensi pada `String` yang memungkinkan Anda bekerja dengan **grapheme clusters** (elemen teks yang terlihat oleh manusia).
- Ini mengimplementasikan rekomendasi dari standar Unicode untuk segmentasi _grapheme cluster_.
- Memberikan `length` yang akurat, substring yang benar, dan akses elemen berbasis grapheme.

#### b. Contoh Penggunaan `characters`

Pertama, Anda perlu menambahkan dependensi ini ke `pubspec.yaml` Anda:

```yaml
dependencies:
  characters: ^1.3.0 # Pastikan Anda menggunakan versi terbaru
```

Kemudian, impor di Dart code Anda:

```dart
import 'package:characters/characters.dart';

void main() {
  String text = "😀Hello é World 🇮🇩";

  // String.length (jumlah code units)
  print("String.length: ${text.length}"); // Output: 23 (tidak akurat untuk karakter visual)

  // characters.length (jumlah grapheme clusters)
  print("Characters.length: ${text.characters.length}"); // Output: 18 (lebih akurat)

  // Mengakses elemen berdasarkan grapheme cluster
  print("First char: '${text.characters.first}'"); // Output: '😀'
  print("Last char: '${text.characters.last}'");   // Output: '🇮🇩'

  // Mengambil substring berdasarkan grapheme cluster
  print("Substring (0, 7): '${text.characters.substring(0, 7)}'"); // Output: '😀Hello '
  print("Substring (8, 11): '${text.characters.substring(8, 11)}'"); // Output: 'é W'

  // Mengakses elemen dengan index
  print("Char at index 0: '${text.characters.elementAt(0)}'"); // Output: '😀'
  print("Char at index 7: '${text.characters.elementAt(7)}'"); // Output: 'o'

  // Membalik string berdasarkan grapheme cluster
  print("Reversed: '${text.characters.reversed.join()}'"); // Output: 🇩🇮 dlroW éolleH😀
}
```

---

### 6\. Kapan Menggunakan `Runes` vs `characters`?

- **Gunakan `Runes`**:

  - Ketika Anda perlu bekerja pada level **Unicode _code point_**.
  - Misalnya, jika Anda ingin memfilter berdasarkan _code point_ individual, atau melakukan _encoding/decoding_ yang membutuhkan akses ke nilai _code point_.
  - Jika Anda tahu persis struktur Unicode yang Anda hadapi dan _grapheme clusters_ bukan perhatian utama Anda.
  - Jarang digunakan secara langsung di kode aplikasi kecuali untuk kasus-kasus sangat spesifik.

- **Gunakan `characters` package**:

  - Ketika Anda perlu bekerja dengan teks yang **terlihat oleh manusia** (yaitu, _grapheme clusters_).
  - Ini adalah pilihan yang tepat untuk sebagian besar operasi manipulasi teks di Dart/Flutter, seperti menghitung panjang string yang akurat, mengambil substring yang masuk akal, atau membalik string.
  - **Direkomendasikan** untuk semua manipulasi teks yang berhadapan dengan _user-facing text_.

---

### 7\. Ringkasan

Memahami **Unicode** dan bagaimana Dart menangani string secara internal sebagai urutan **UTF-16 _code units_** adalah kunci untuk menghindari masalah umum terkait panjang string dan indeks.

- `String.length` mengembalikan jumlah _UTF-16 code units_, yang mungkin tidak sama dengan jumlah karakter visual.
- Properti **`runes`** memberikan akses ke **Unicode _code points_**, yang merupakan representasi numerik unik dari setiap karakter Unicode.
- Untuk bekerja dengan **grapheme clusters** (karakter yang terlihat oleh manusia) secara akurat, **sangat disarankan** untuk menggunakan _package_ **`characters`**. Ini adalah solusi paling robust untuk manipulasi teks yang tepat di Dart/Flutter.

Dengan pemahaman ini, Anda dapat menangani teks dari berbagai bahasa dan emoji dengan benar dalam aplikasi Dart Anda.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-15/README.md
[selanjutnya]: ../bagian-17/README.md

[0]:../README.md