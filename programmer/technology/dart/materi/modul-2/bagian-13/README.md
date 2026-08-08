# [Multi-line Strings][0]

<details>
  <summary>📃 Daftar Isi</summary>

- [Multi-line Strings](#multi-line-strings)
    - [1. Pendahuluan](#1-pendahuluan)
    - [2. Sintaks Dasar](#2-sintaks-dasar)
      - [a. Menggunakan Tiga Tanda Kutip Tunggal (`'''`)](#a-menggunakan-tiga-tanda-kutip-tunggal-)
      - [b. Menggunakan Tiga Tanda Kutip Ganda (`"""`)](#b-menggunakan-tiga-tanda-kutip-ganda-)
    - [3. Fitur dan Perilaku Multi-line Strings](#3-fitur-dan-perilaku-multi-line-strings)
      - [a. Mempertahankan Spasi dan Line Break](#a-mempertahankan-spasi-dan-line-break)
      - [b. Indentasi](#b-indentasi)
      - [c. String Interpolation](#c-string-interpolation)
      - [d. Raw Multi-line Strings](#d-raw-multi-line-strings)
    - [4. Kapan Menggunakan Multi-line Strings?](#4-kapan-menggunakan-multi-line-strings)
      - [a. Pesan Panjang atau Paragraf](#a-pesan-panjang-atau-paragraf)
      - [b. Template HTML/XML/JSON](#b-template-htmlxmljson)
      - [c. SQL Queries](#c-sql-queries)
      - [d. Konfigurasi atau Data String](#d-konfigurasi-atau-data-string)
    - [5. Perbandingan dengan Menggabungkan String (Concatenation)](#5-perbandingan-dengan-menggabungkan-string-concatenation)
    - [6. Ringkasan](#6-ringkasan)

---

</details>

### 1\. Pendahuluan

Dalam pengembangan aplikasi, seringkali kita perlu membuat string yang panjangnya lebih dari satu baris. Menggunakan string satu baris dengan karakter _newline_ (`\n`) secara berulang bisa menjadi tidak rapi dan sulit dibaca. Untuk mengatasi ini, Dart menyediakan fitur **Multi-line Strings** yang memungkinkan Anda mendefinisikan string yang membentang di beberapa baris kode secara langsung.

Multi-line strings meningkatkan keterbacaan kode secara signifikan ketika Anda berurusan dengan blok teks yang besar.

---

### 2\. Sintaks Dasar

Dart menyediakan dua cara untuk mendeklarasikan multi-line strings, yaitu dengan menggunakan tiga tanda kutip tunggal atau tiga tanda kutip ganda.

#### a. Menggunakan Tiga Tanda Kutip Tunggal (`'''`)

Anda memulai dan mengakhiri string dengan tiga tanda kutip tunggal.

```dart
void main() {
  String pesanUndangan = '''
Kepada Yth. Bapak/Ibu,

Dengan hormat, kami mengundang Anda untuk menghadiri
acara penting kami yang akan diselenggarakan pada:

Tanggal: 15 Agustus 2025
Waktu: 10:00 WIB
Lokasi: Gedung Serbaguna

Besar harapan kami atas kehadiran Anda.

Hormat kami,
Panitia Acara
''';

  print(pesanUndangan);
}
```

**Output:**

```
Kepada Yth. Bapak/Ibu,

Dengan hormat, kami mengundang Anda untuk menghadiri
acara penting kami yang akan diselenggarakan pada:

Tanggal: 15 Agustus 2025
Waktu: 10:00 WIB
Lokasi: Gedung Serbaguna

Besar harapan kami atas kehadiran Anda.

Hormat kami,
Panitia Acara
```

#### b. Menggunakan Tiga Tanda Kutip Ganda (`"""`)

Sama seperti kutip tunggal, Anda juga bisa menggunakan tiga tanda kutip ganda. Pilihan antara `'''` dan `"""` biasanya didasarkan pada preferensi pribadi atau konsistensi dalam _codebase_ proyek. Jika string Anda mengandung tanda kutip tunggal, lebih mudah menggunakan tiga kutip ganda untuk string multi-baris, dan sebaliknya.

```dart
void main() {
  String puisi = """
Di antara bintang dan cahaya rembulan,
Kisah lama terukir dalam ingatan.
Angin berbisik, membawa harapan,
Di setiap sudut, ada kehidupan.
""";

  print(puisi);
}
```

**Output:**

```
Di antara bintang dan cahaya rembulan,
Kisah lama terukir dalam ingatan.
Angin berbisik, membawa harapan,
Di setiap sudut, ada kehidupan.
```

---

### 3\. Fitur dan Perilaku Multi-line Strings

#### a. Mempertahankan Spasi dan Line Break

Fitur utama dari multi-line string adalah bahwa mereka akan **mempertahankan semua spasi (whitespace) dan _line breaks_** (baris baru) yang Anda ketikkan dalam editor kode.

```dart
void main() {
  String formattedText = """
  Ini adalah baris pertama.
    Ini adalah baris kedua dengan indentasi lebih dalam.
  Ini baris ketiga.
""";

  print(formattedText);
}
```

**Output:**

```

  Ini adalah baris pertama.
    Ini adalah baris kedua dengan indentasi lebih dalam.
  Ini baris ketiga.
```

Perhatikan bahwa baris pertama dan terakhir dari string multi-baris juga akan menyertakan _newline_ jika Anda menekan Enter setelah `'''` pembuka dan sebelum `'''` penutup. Jika Anda ingin menghilangkan _newline_ awal/akhir, Anda bisa memulai/mengakhiri string pada baris yang sama dengan tanda kutip.

```dart
void main() {
  String noInitialNewline = '''Baris pertama tanpa newline awal.
Baris kedua.''';
  print(noInitialNewline);
  // Output: Baris pertama tanpa newline awal.
  // Baris kedua.
}
```

#### b. Indentasi

Perhatikan bahwa indentasi di dalam kode Anda (spasi atau tab yang digunakan untuk merapikan kode) juga akan menjadi bagian dari string jika Anda tidak berhati-hati.

```dart
void main() {
  // Indentasi ini akan menjadi bagian dari string
  String indentedText = '''
    Hello,
    World!
  ''';
  print(indentedText);
}
```

**Output:**

```

    Hello,
    World!

```

Untuk menghindari masalah indentasi ini, Anda bisa mengidentasi seluruh string ke kiri tanpa spasi awal pada baris pertama dan akhir, atau menggunakan metode `trim()` jika Anda tidak peduli dengan spasi di awal/akhir string.

```dart
void main() {
  String cleanText = '''
Hello,
World!
'''; // Tidak ada spasi di awal baris pertama dan akhir
  print(cleanText);

  String trimmedText = """
    Hello,
    World!
  """.trim(); // Menghapus spasi di awal dan akhir string
  print(trimmedText);
}
```

#### c. String Interpolation

Multi-line strings mendukung **String Interpolation** sepenuhnya, sama seperti string satu baris. Anda dapat menyisipkan variabel atau ekspresi menggunakan `$variabel` atau `${ekspresi}`.

```dart
void main() {
  String namaProduk = "Laptop Gaming";
  double harga = 1500.0;
  int garansiTahun = 2;

  String detailProduk = """
Detail Produk:
Nama: $namaProduk
Harga: Rp${harga.toStringAsFixed(2)}
Garansi: ${garansiTahun} tahun

Terima kasih telah berbelanja!
""";

  print(detailProduk);
}
```

**Output:**

```
Detail Produk:
Nama: Laptop Gaming
Harga: Rp1500.00
Garansi: 2 tahun

Terima kasih telah berbelanja!
```

#### d. Raw Multi-line Strings

Anda juga bisa menggabungkan multi-line string dengan fitur **Raw String** dengan menambahkan prefiks `r` sebelum tiga tanda kutip. Ini akan memastikan bahwa _escape sequences_ seperti `\n` tidak diinterpretasikan, bahkan dalam string multi-baris.

```dart
void main() {
  String dokumenPath = r"""
Lokasi Dokumen:
C:\Users\Pengguna\Dokumenku\Laporan_2024\
File: laporan_akhir.pdf
""";

  print(dokumenPath);
}
```

**Output:**

```
Lokasi Dokumen:
C:\Users\Pengguna\Dokumenku\Laporan_2024\
File: laporan_akhir.pdf
```

Di sini, `\n` dan `\` lainnya dalam path tidak diinterpretasikan sebagai _newline_ atau _escape sequence_, melainkan sebagai karakter literal.

---

### 4\. Kapan Menggunakan Multi-line Strings?

Multi-line strings sangat cocok untuk skenario di mana Anda memiliki blok teks yang besar dan terstruktur.

#### a. Pesan Panjang atau Paragraf

Misalnya, pesan email, deskripsi produk, atau teks bantuan.

```dart
String disclaimer = '''
Penting: Harap baca syarat dan ketentuan ini dengan cermat.
Penggunaan layanan ini berarti Anda menyetujui semua
poin yang disebutkan di bawah ini. Kami berhak
untuk mengubah syarat dan ketentuan kapan saja.
''';
```

#### b. Template HTML/XML/JSON

Saat membuat string yang merepresentasikan struktur data atau markup.

```dart
String htmlTemplate = """
<!DOCTYPE html>
<html>
<head>
    <title>Halaman Contoh</title>
</head>
<body>
    <h1>Selamat Datang!</h1>
    <p>Ini adalah halaman yang dihasilkan Dart.</p>
</body>
</html>
""";
```

#### c. SQL Queries

Untuk _query_ database yang panjang dan kompleks.

```dart
String sqlQuery = """
SELECT
    p.id,
    p.name,
    p.price,
    c.category_name
FROM
    products p
JOIN
    categories c ON p.category_id = c.id
WHERE
    p.stock > 0
ORDER BY
    p.name ASC;
""";
```

#### d. Konfigurasi atau Data String

Ketika Anda menyimpan blok konfigurasi atau data yang panjang dalam kode Anda.

```dart
String configData = '''
[Settings]
AppName=MyDartApp
Version=1.0.0
[Database]
Host=localhost
Port=5432
''';
```

---

### 5\. Perbandingan dengan Menggabungkan String (Concatenation)

Meskipun Anda bisa membuat string multi-baris dengan operator `+` dan `\n`, multi-line strings (`'''` / `"""`) jauh lebih disukai karena:

- **Keterbacaan:** Jauh lebih mudah membaca teks yang terstruktur seperti yang akan muncul, daripada serangkaian string yang disambung dengan `+` dan `\n`.
- **Kemudahan Penulisan:** Tidak perlu mengetik `\n` secara manual di setiap akhir baris.
- **Perawatan:** Lebih mudah untuk memodifikasi, menambah, atau menghapus baris.

<!-- end list -->

```dart
// Menggunakan concatenation (kurang disarankan untuk teks panjang)
String pesanConcatenated = "Baris satu.\n" +
                           "Baris dua.\n" +
                           "Baris tiga.";
print(pesanConcatenated);

print("\n--- vs ---\n");

// Menggunakan multi-line string (sangat disarankan)
String pesanMultiLine = """
Baris satu.
Baris dua.
Baris tiga.
""";
print(pesanMultiLine);
```

Output keduanya akan sama, tetapi perhatikan betapa `pesanMultiLine` jauh lebih mudah dibaca di dalam kode.

---

### 6\. Ringkasan

**Multi-line Strings** di Dart adalah fitur yang sangat praktis untuk mendefinisikan blok teks yang membentang di beberapa baris. Dengan menggunakan tiga tanda kutip tunggal (`'''`) atau tiga tanda kutip ganda (`"""`), Anda dapat dengan mudah membuat string yang mempertahankan semua spasi dan _line breaks_ seperti yang Anda ketikkan. Fitur ini sangat meningkatkan keterbacaan kode saat berurusan dengan pesan panjang, template, _query_ SQL, atau data tekstual terstruktur.

Anda juga telah melihat bagaimana multi-line strings dapat digabungkan dengan **String Interpolation** untuk menyisipkan nilai dinamis, dan dengan **Raw Strings** untuk menghindari interpretasi _escape sequences_.

Menggunakan multi-line strings adalah praktik terbaik untuk mengelola teks yang panjang dan terstruktur dalam aplikasi Dart Anda.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-12/README.md
[selanjutnya]: ../bagian-14/README.md

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
