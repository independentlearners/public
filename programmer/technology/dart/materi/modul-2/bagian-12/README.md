# [Raw Strings][0]

<details>
  <summary>📃 Daftar Isi</summary>

- [Raw Strings](#raw-strings)
    - [1. Pendahuluan](#1-pendahuluan)
    - [2. Apa Itu Raw String?](#2-apa-itu-raw-string)
    - [3. Sintaks Dasar](#3-sintaks-dasar)
    - [4. Mengapa Menggunakan Raw String?](#4-mengapa-menggunakan-raw-string)
      - [Contoh 1: Path Sistem File](#contoh-1-path-sistem-file)
      - [Contoh 2: Regular Expressions (Regex)](#contoh-2-regular-expressions-regex)
      - [Contoh 3: URL atau String dengan Banyak Backslash](#contoh-3-url-atau-string-dengan-banyak-backslash)
    - [5. Perbandingan dengan String Reguler (dengan Escape Sequences)](#5-perbandingan-dengan-string-reguler-dengan-escape-sequences)
    - [6. Kombinasi dengan String Interpolation](#6-kombinasi-dengan-string-interpolation)
    - [7. Keterbatasan Raw String](#7-keterbatasan-raw-string)
    - [8. Ringkasan](#8-ringkasan)

</details>

---

### 1\. Pendahuluan

Dalam pemrograman, kita sering berinteraksi dengan string yang mengandung karakter khusus. Salah satu karakter khusus yang paling umum adalah _backslash_ (`\`). Dalam string reguler, _backslash_ seringkali berfungsi sebagai awal dari sebuah **escape sequence** (misalnya, `\n` untuk _newline_, `\t` untuk _tab_, `\\` untuk _backslash_ literal). Namun, terkadang kita ingin _backslash_ dan karakter lain diinterpretasikan persis seperti apa adanya, tanpa Dart mencoba mengubahnya menjadi karakter khusus. Di sinilah **Raw Strings** berperan.

---

### 2\. Apa Itu Raw String?

**Raw String** adalah jenis string literal di Dart di mana **escape sequences tidak diinterpretasikan**. Semua karakter di dalam _raw string_ akan dianggap sebagai karakter literal, termasuk _backslash_.

Ini sangat berguna ketika Anda perlu menulis string yang mengandung banyak _backslash_ atau karakter yang biasanya akan di-_escape_, tanpa harus menambahkan _backslash_ ganda (`\\`) di mana-mana.

---

### 3\. Sintaks Dasar

Untuk membuat _raw string_, Anda cukup menambahkan prefiks huruf `r` (huruf kecil) tepat sebelum tanda kutip pembuka string.

```dart
// Dengan kutip tunggal
String rawStringSingleQuote = r'Ini adalah raw string dengan kutip tunggal.';

// Dengan kutip ganda
String rawStringDoubleQuote = r"Ini adalah raw string dengan kutip ganda.";

// Dengan kutip tiga (untuk multi-baris raw string)
String rawStringMultiLine = r'''
Ini adalah raw string multi-baris.
Backslash \n dan \t tidak akan diinterpretasikan.
''';
```

---

### 4\. Mengapa Menggunakan Raw String?

Raw String sangat membantu dalam skenario di mana Anda ingin menghindari _parsing_ atau interpretasi khusus dari karakter dalam string.

#### Contoh 1: Path Sistem File

_Path_ sistem file seringkali menggunakan _backslash_ sebagai pemisah direktori (terutama di Windows). Jika Anda menggunakan string reguler, Anda harus menggandakan setiap _backslash_ untuk menghindari interpretasinya sebagai _escape sequence_.

```dart
void main() {
  // String reguler (membutuhkan escape untuk backslash)
  String normalPath = "C:\\Program Files\\Dart\\bin";
  print("Normal Path: $normalPath");
  // Output: C:\Program Files\Dart\bin

  // Raw string (tidak perlu escape backslash)
  String rawPath = r"C:\Program Files\Dart\bin";
  print("Raw Path: $rawPath");
  // Output: C:\Program Files\Dart\bin

  // Perhatikan perbedaan saat mencoba menyertakan \n secara literal
  print("Normal: Baris1\nBaris2");
  // Output:
  // Normal: Baris1
  // Baris2

  print(r"Raw: Baris1\nBaris2");
  // Output: Raw: Baris1\nBaris2
}
```

Seperti yang Anda lihat, `r"C:\Program Files\Dart\bin"` jauh lebih bersih dan mudah dibaca daripada `C:\\Program Files\\Dart\\bin`.

#### Contoh 2: Regular Expressions (Regex)

_Regular Expressions_ adalah pola pencarian string yang sering menggunakan _backslash_ untuk karakter _escape_ atau _metacharacter_ khusus (misalnya, `\d` untuk digit, `\s` untuk spasi). Jika Anda menggunakan string reguler untuk regex, Anda seringkali harus menggandakan _backslash_ tersebut, membuat regex menjadi sangat sulit dibaca. Raw strings menyelesaikan masalah ini.

```dart
void main() {
  // Regex untuk mencari digit dalam string, menggunakan string reguler
  // "\\d+" berarti cari satu atau lebih digit
  RegExp normalRegex = RegExp("\\d+");
  print(normalRegex.hasMatch("abc123def")); // Output: true

  // Regex yang sama menggunakan raw string (lebih mudah dibaca)
  RegExp rawRegex = RegExp(r"\d+");
  print(rawRegex.hasMatch("xyz456uvw")); // Output: true

  // Contoh regex yang lebih kompleks: mencari email (sederhana)
  String emailPatternNormal = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\$";
  // Betapa rumitnya dengan backslash ganda!

  String emailPatternRaw = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
  // Jauh lebih mudah dibaca dan sesuai dengan sintaks regex aslinya

  RegExp emailRegExp = RegExp(emailPatternRaw);
  print(emailRegExp.hasMatch("test@example.com")); // Output: true
  print(emailRegExp.hasMatch("invalid-email"));   // Output: false
}
```

#### Contoh 3: URL atau String dengan Banyak Backslash

Jika Anda memiliki URL yang mungkin mengandung _backslash_ atau string lainnya di mana Anda ingin semua karakter dianggap literal.

```dart
void main() {
  String apiEndpoint = r"https://api.example.com/data\users\profiles";
  print(apiEndpoint);
  // Output: https://api.example.com/data\users\profiles
}
```

---

### 5\. Perbandingan dengan String Reguler (dengan Escape Sequences)

| Fitur                       | String Reguler (`'...'` atau `"..."`)                                                             | Raw String (`r'...'` atau `r"..."`)                                                |
| :-------------------------- | :------------------------------------------------------------------------------------------------ | :--------------------------------------------------------------------------------- |
| **Interpretasi Escape**     | Ya, _escape sequences_ (seperti `\n`, `\t`, `\\`) akan diinterpretasikan menjadi karakter khusus. | **Tidak**, semua karakter (termasuk `\`) dianggap literal.                         |
| **Karakter `\`**            | Harus di-_escape_ dengan `\\` jika ingin menjadi literal.                                         | Dianggap sebagai karakter literal.                                                 |
| **Keterbacaan (Backslash)** | Kurang jika banyak _backslash_ yang ingin diliteralkan.                                           | Jauh lebih baik jika banyak _backslash_ yang ingin diliteralkan.                   |
| **Penggunaan Umum**         | Teks biasa, pesan UI, string dengan karakter _newline_/tab.                                       | Path sistem file, _regular expressions_, template yang berisi _backslash_ literal. |

```dart
void main() {
  print('String reguler: Baris 1\nBaris 2');
  // Output:
  // String reguler: Baris 1
  // Baris 2

  print(r'Raw string: Baris 1\nBaris 2');
  // Output: Raw string: Baris 1\nBaris 2
}
```

---

### 6\. Kombinasi dengan String Interpolation

Raw strings masih mendukung **String Interpolation**. Artinya, Anda masih bisa menyisipkan nilai variabel atau ekspresi ke dalam _raw string_ menggunakan `$variabel` atau `${ekspresi}`. Hanya _escape sequences_ yang tidak akan diinterpretasikan.

```dart
void main() {
  String namaFile = "dokumen_rahasia.pdf";
  String folder = "MyDocuments";

  // Menggabungkan raw string dengan interpolation
  String fullPath = r"C:\Users\Admin\""$folder\$namaFile";
  print(fullPath);
  // Output: C:\Users\Admin\MyDocuments\dokumen_rahasia.pdf

  int versi = 1;
  String regexUntukVersi = r"aplikasi_v${versi}\.\d+\.log";
  print(regexUntukVersi);
  // Output: aplikasi_v1\.\d+\.log
}
```

**Catatan:** Dalam contoh `fullPath`, ada sedikit trik. Karena `$` akan diinterpretasikan, jika Anda memiliki `$`, `\`, dan literal `"` secara bersamaan, Anda mungkin perlu membagi string atau lebih berhati-hati. Namun, umumnya, `r` akan membuat `\` menjadi literal, dan `$` tetap untuk interpolation.

```dart
// Contoh kasus khusus: jika string interpolation Anda melibatkan ekspresi dengan backslash
String data = "data";
print(r"Ini adalah ${data}\path"); // Output: Ini adalah data\path
```

---

### 7\. Keterbatasan Raw String

- **Tidak Bisa Mencegah Interpolation:** Meskipun _raw string_ mengabaikan _escape sequences_, mereka **tidak mengabaikan string interpolation**. Karakter `$` akan tetap memicu interpolation. Jika Anda ingin karakter `$` muncul secara literal, Anda harus meng-_escapenya_ (tapi ini hanya berfungsi di string reguler, bukan raw string). Dalam _raw string_, `$` akan selalu mencoba melakukan interpolation.
  - Jika Anda benar-benar membutuhkan `$` literal dalam raw string, Anda harus menggunakan `\u0024` (kode Unicode untuk `$`):
    ```dart
    print(r'Ini adalah harga: \u002410.00'); // Output: Ini adalah harga: $10.00
    ```
- **Tidak Ideal untuk Semua Karakter Khusus:** Raw string didesain khusus untuk menangani _backslash_ literal. Untuk karakter non-cetak lainnya seperti _newline_ (`\n`) atau _tab_ (`\t`) yang ingin Anda masukkan secara fungsional (bukan literal `\n`), Anda harus kembali menggunakan string reguler atau menggabungkan keduanya.

---

### 8\. Ringkasan

**Raw Strings** adalah alat yang sangat berguna di Dart untuk membuat string di mana Anda ingin semua karakter (terutama _backslash_) diinterpretasikan secara literal, tanpa adanya _escape sequences_. Ini sangat meningkatkan keterbacaan kode saat bekerja dengan:

- **Path sistem file.**
- **Regular Expressions.**
- String apa pun yang secara alami mengandung banyak _backslash_ literal.

Ingatlah untuk menggunakan prefiks `r` sebelum tanda kutip pembuka string. Meskipun demikian, raw string masih mendukung **String Interpolation**, jadi Anda tetap bisa menyisipkan nilai variabel atau ekspresi ke dalamnya.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-11/README.md
[selanjutnya]: ../bagian-13/README.md

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
