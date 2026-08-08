# [Symbol Type][0]

<details>
  <summary>📃 Daftar Isi</summary>

- [Symbol Type](#symbol-type)
    - [1. Pendahuluan](#1-pendahuluan)
    - [2. Apa Itu `Symbol`?](#2-apa-itu-symbol)
    - [3. Sintaks Deklarasi `Symbol`](#3-sintaks-deklarasi-symbol)
      - [a. Menggunakan Literal `#` (Disarankan)](#a-menggunakan-literal--disarankan)
      - [b. Menggunakan Konstruktor `Symbol()` (Jarang Digunakan)](#b-menggunakan-konstruktor-symbol-jarang-digunakan)
    - [4. Karakteristik Utama `Symbol`](#4-karakteristik-utama-symbol)
      - [a. Unik dan Immutable](#a-unik-dan-immutable)
      - [b. Compile-time Constant (Konstan Waktu Kompilasi)](#b-compile-time-constant-konstan-waktu-kompilasi)
      - [c. Keunikan vs. String](#c-keunikan-vs-string)
    - [5. Kapan Menggunakan `Symbol`? (Kasus Penggunaan)](#5-kapan-menggunakan-symbol-kasus-penggunaan)
      - [a. Refleksi dan Metaprogramming (Sangat Niche)](#a-refleksi-dan-metaprogramming-sangat-niche)
      - [b. Pencarian Properti/Metode Dinamis (Internal Dart)](#b-pencarian-propertimetode-dinamis-internal-dart)
      - [c. Alternatif untuk String dalam `Map` (Jarang)](#c-alternatif-untuk-string-dalam-map-jarang)
    - [6. Mengapa `Symbol` Jarang Digunakan dalam Kode Aplikasi Umum?](#6-mengapa-symbol-jarang-digunakan-dalam-kode-aplikasi-umum)
      - [a. Alternatif yang Lebih Umum dan Mudah](#a-alternatif-yang-lebih-umum-dan-mudah)
      - [b. Fokus pada Code Generation daripada Refleksi](#b-fokus-pada-code-generation-daripada-refleksi)
    - [7. Perbandingan dengan `String`](#7-perbandingan-dengan-string)
    - [8. Ringkasan](#8-ringkasan)

---

</details>

### 1\. Pendahuluan

Di Dart, `Symbol` adalah tipe data yang mungkin paling jarang Anda temui atau gunakan dalam pengembangan aplikasi sehari-hari (terutama di Flutter). Ini karena kasus penggunaannya sangat spesifik dan seringkali lebih relevan untuk alat-alat internal Dart, _framework_, atau _library_ yang melibatkan _reflection_ atau _metaprogramming_.

Meskipun jarang digunakan, penting untuk memahami apa itu `Symbol` dan perannya dalam ekosistem Dart agar tidak bingung jika suatu saat Anda menemukannya.

---

### 2\. Apa Itu `Symbol`?

`Symbol` adalah objek yang merepresentasikan **identifikasi unik** dari nama-nama yang dideklarasikan di level program, seperti nama _library_, kelas, metode, atau variabel. Mereka pada dasarnya adalah _string_ yang "diinternalkan" dan dioptimalkan oleh Dart untuk digunakan dalam konteks tertentu di mana identitas nama itu sendiri penting.

Bayangkan `Symbol` sebagai sebuah nama yang sudah "diresmikan" oleh Dart pada waktu kompilasi.

---

### 3\. Sintaks Deklarasi `Symbol`

Ada dua cara untuk membuat objek `Symbol`:

#### a. Menggunakan Literal `#` (Disarankan)

Ini adalah cara paling umum dan direkomendasikan untuk membuat `Symbol`. Anda cukup menambahkan tanda pagar (`#`) di depan nama identifier.

```dart
void main() {
  Symbol mySymbol = #myVariable;
  Symbol anotherSymbol = #someFunction;
  Symbol classSymbol = #MyClass;

  print(mySymbol);      // Output: Symbol("myVariable")
  print(anotherSymbol); // Output: Symbol("someFunction")
  print(classSymbol);   // Output: Symbol("MyClass")

  // Anda bisa membuat Symbol dari operator atau kata kunci Dart:
  Symbol plusSymbol = #+;
  Symbol printSymbol = #print;
  print(plusSymbol);    // Output: Symbol("+")
  print(printSymbol);   // Output: Symbol("print")
}
```

Ketika Anda menggunakan sintaks `#identifier`, Dart akan membuat objek `Symbol` yang mewakili nama `identifier` tersebut.

#### b. Menggunakan Konstruktor `Symbol()` (Jarang Digunakan)

Anda juga bisa membuat `Symbol` dari sebuah `String` menggunakan konstruktor `Symbol()`. Namun, ini jauh lebih jarang digunakan karena:

- Lebih tidak efisien dibandingkan literal `#`.
- Hanya digunakan untuk _string_ yang tidak valid sebagai _identifier_ Dart (misalnya, mengandung spasi atau karakter khusus).

<!-- end list -->

```dart
void main() {
  // Membuat Symbol dari string yang valid sebagai identifier
  Symbol fromString = Symbol("anotherVariable");
  print(fromString); // Output: Symbol("anotherVariable")

  // Membuat Symbol dari string yang TIDAK valid sebagai identifier
  Symbol spaceSymbol = Symbol("my variable with spaces");
  print(spaceSymbol); // Output: Symbol("my variable with spaces")

  // Bandingkan dengan literal # (lebih bersih dan efisien)
  Symbol literalSymbol = #myVariable;
  print(literalSymbol); // Output: Symbol("myVariable")
}
```

---

### 4\. Karakteristik Utama `Symbol`

#### a. Unik dan Immutable

Setiap objek `Symbol` yang mewakili nama yang sama adalah unik secara kanonik. Artinya, `Symbol` yang dibuat dari nama yang sama akan selalu merujuk pada objek `Symbol` yang sama di memori. Mereka juga _immutable_, jadi nilainya tidak bisa diubah setelah dibuat.

```dart
void main() {
  Symbol s1 = #myIdentifier;
  Symbol s2 = #myIdentifier;
  Symbol s3 = Symbol("myIdentifier");
  Symbol s4 = #anotherIdentifier;

  print(s1 == s2); // Output: true (karena mereka merujuk ke objek Symbol yang sama)
  print(s1 == s3); // Output: true (literal dan konstruktor untuk nama yang sama adalah identik)
  print(s1 == s4); // Output: false
}
```

#### b. Compile-time Constant (Konstan Waktu Kompilasi)

Literal `Symbol` yang dibuat dengan `#` adalah **konstan waktu kompilasi (`const`)**. Ini berarti mereka dibuat pada saat kode dikompilasi, bukan saat program berjalan.

```dart
void main() {
  const Symbol constantSymbol = #appVersion;
  print(constantSymbol); // Output: Symbol("appVersion")

  // Anda bisa menggunakan const pada Symbol literal
  final dynamic varName = 'someVar';
  // const Symbol dynamicSymbol = Symbol(varName); // ERROR: Constant constructor can't call a non-constant constructor.
                                                // Karena 'varName' tidak dikenal pada compile time.
}
```

#### c. Keunikan vs. String

Meskipun `Symbol` dan `String` sama-sama merepresentasikan teks, ada perbedaan fundamental:

- `String` merepresentasikan urutan karakter. Dua `String` yang memiliki urutan karakter yang sama dianggap sama.
- `Symbol` merepresentasikan **identitas unik dari sebuah nama program**. Mereka dirancang untuk secara efisien merujuk ke nama-nama dalam konteks _runtime_ atau _reflection_.

---

### 5\. Kapan Menggunakan `Symbol`? (Kasus Penggunaan)

Kasus penggunaan `Symbol` sangat terbatas dan seringkali melibatkan _reflection_ (inspeksi atau modifikasi struktur program saat _runtime_) atau _metaprogramming_.

#### a. Refleksi dan Metaprogramming (Sangat Niche)

Penggunaan utama `Symbol` adalah dalam _library_ `dart:mirrors` (untuk refleksi) atau dalam kode yang memproses program Dart secara dinamis.

Misalnya, jika Anda ingin secara dinamis memanggil metode atau mengakses properti objek berdasarkan namanya yang diketahui pada _runtime_:

```dart
import 'dart:mirrors'; // Peringatan: dart:mirrors tidak didukung di Flutter/web/AOT

class MyClass {
  String myField = "Hello";
  void myMethod() {
    print("myMethod called!");
  }
}

void main() {
  var obj = MyClass();

  // Dapatkan Mirror untuk objek
  InstanceMirror im = reflect(obj);

  // Dapatkan Mirror untuk kelas
  ClassMirror cm = im.type;

  // Menggunakan Symbol untuk mengakses field/method secara dinamis
  // print(im.getField(#myField).reflectee); // Output: Hello
  // im.invoke(#myMethod, []);              // Output: myMethod called!

  // Contoh ini hanya bekerja di Dart VM (misalnya, aplikasi konsol), bukan di Flutter atau web.
  // Ini menunjukkan mengapa Symbol ada, meskipun jarang Anda gunakan.
}
```

Karena `dart:mirrors` tidak tersedia di sebagian besar platform Dart modern (Flutter, web), penggunaan `Symbol` untuk tujuan ini sangat jarang terlihat di luar pengembangan _tooling_ Dart itu sendiri.

#### b. Pencarian Properti/Metode Dinamis (Internal Dart)

Secara internal, Dart Virtual Machine menggunakan `Symbol` untuk mencari _member_ (properti atau metode) dari suatu objek secara dinamis. Ini adalah bagian dari bagaimana Dart Runtime berfungsi.

#### c. Alternatif untuk String dalam `Map` (Jarang)

Dalam kasus yang sangat, sangat langka, Anda mungkin melihat `Symbol` digunakan sebagai kunci dalam sebuah `Map` jika Anda membutuhkan jaminan keunikan kanonik dan _compile-time constant_ untuk kunci yang merepresentasikan _identifier_. Namun, ini hampir selalu dapat digantikan oleh `String` biasa atau `enum` dengan cara yang lebih mudah dipahami.

```dart
void main() {
  Map<Symbol, dynamic> settings = {
    #theme: "dark",
    #language: "en_US",
    #debugMode: true,
  };

  print(settings[#theme]); // Output: dark
  print(settings[#language]); // Output: en_US
}
```

Meskipun ini berfungsi, menggunakan `String` atau `enum` sebagai kunci `Map` jauh lebih umum dan _idiomatic_ di Dart.

---

### 6\. Mengapa `Symbol` Jarang Digunakan dalam Kode Aplikasi Umum?

#### a. Alternatif yang Lebih Umum dan Mudah

Untuk sebagian besar kebutuhan pengidentifikasi atau konstanta, Dart menyediakan alternatif yang lebih mudah dipahami dan digunakan:

- **`String`**: Paling umum untuk nama properti, ID, atau kunci `Map`.
- **`enum`**: Sangat direkomendasikan untuk kumpulan nilai diskrit yang terdefinisi dengan baik (misalnya, status, tipe, opsi). Enum menyediakan keamanan tipe yang kuat.
- **`const String`**: Untuk konstanta string yang diketahui pada waktu kompilasi.

#### b. Fokus pada Code Generation daripada Refleksi

Komunitas Dart (terutama di Flutter) cenderung menghindari _reflection_ saat _runtime_ karena dapat memengaruhi performa dan ukuran aplikasi. Sebagai gantinya, mereka mendorong penggunaan **code generation** (misalnya, dengan _packages_ seperti `json_serializable`, `freezed`, `build_runner`). _Code generation_ menghasilkan kode yang sangat efisien pada waktu kompilasi, menghilangkan kebutuhan untuk _reflection_ yang dapat lambat. Karena `Symbol` sangat terkait dengan _reflection_, penggunaannya secara alami berkurang.

---

### 7\. Perbandingan dengan `String`

| Fitur                | `String`                                                    | `Symbol`                                                                         |
| :------------------- | :---------------------------------------------------------- | :------------------------------------------------------------------------------- |
| **Representasi**     | Urutan karakter (teks)                                      | Identifikasi unik dari nama (identifier)                                         |
| **Tujuan Umum**      | Menampilkan teks, data, kunci dalam `Map`                   | Identifikasi elemen program dalam refleksi/metaprogramming                       |
| **Immutability**     | Ya, immutable                                               | Ya, immutable                                                                    |
| **Canonicalization** | Ya, string yang identik akan di-kanonisasi (diinternalkan). | Ya, Symbol yang identik akan di-kanonisasi.                                      |
| **Sintaks**          | `'teks'` atau `"teks"`                                      | `#identifier` atau `Symbol("string")`                                            |
| **Kapan Digunakan**  | **Hampir selalu**, untuk data tekstual.                     | **Sangat jarang**, untuk kasus refleksi atau identifikasi nama program internal. |
| **Keamanan Tipe**    | Tipe String                                                 | Tipe Symbol                                                                      |

---

### 8\. Ringkasan

`Symbol` adalah tipe data khusus di Dart yang merepresentasikan identitas unik dari nama-nama yang dideklarasikan dalam program. Mereka dibuat dengan literal `#` (misalnya, `#myVariable`) dan bersifat _immutable_ serta _compile-time constant_.

Meskipun secara teknis ada, `Symbol` jarang digunakan dalam pengembangan aplikasi Dart/Flutter sehari-hari karena peran utamanya terletak pada _reflection_ dan _metaprogramming_ yang sebagian besar dihindari demi _code generation_ di lingkungan modern Dart. Untuk sebagian besar kebutuhan, `String`, `const String`, atau `enum` adalah pilihan yang jauh lebih umum, aman, dan mudah dipahami.

Jika Anda melihat `Symbol` dalam kode, kemungkinan besar itu adalah bagian dari _library_ internal Dart atau _tooling_ tingkat lanjut.

---


> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-14/README.md
[selanjutnya]: ../bagian-16/README.md

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
