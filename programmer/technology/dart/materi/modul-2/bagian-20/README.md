# [Casting dan Conversion][0]

Tentang manajemen tipe data, namun memiliki tujuan dan mekanisme yang berbeda.

<details>
  <summary>📃 Daftar Isi</summary>

---

- [Casting dan Conversion](#casting-dan-conversion)
    - [1. Pendahuluan](#1-pendahuluan)
    - [2. Casting (Type Cast)](#2-casting-type-cast)
      - [a. Apa Itu Casting?](#a-apa-itu-casting)
      - [b. Operator `as`](#b-operator-as)
      - [c. Kapan Menggunakan `as`?](#c-kapan-menggunakan-as)
      - [d. Risiko Menggunakan `as` (Runtime Error)](#d-risiko-menggunakan-as-runtime-error)
      - [e. Alternatif yang Lebih Aman: `is` dan Type Promotion](#e-alternatif-yang-lebih-aman-is-dan-type-promotion)
      - [f. Contoh Praktis: Iterasi List Campuran](#f-contoh-praktis-iterasi-list-campuran)
    - [3. Conversion (Type Conversion)](#3-conversion-type-conversion)
      - [a. Apa Itu Conversion?](#a-apa-itu-conversion)
      - [b. Perbedaan Utama dengan Casting](#b-perbedaan-utama-dengan-casting)
      - [c. Metode Konversi Umum](#c-metode-konversi-umum)
        - [String ke Angka (`int.parse()`, `double.parse()`)](#string-ke-angka-intparse-doubleparse)
        - [Angka ke String (`.toString()`)](#angka-ke-string-tostring)
        - [Tipe Lain ke String (String Interpolation)](#tipe-lain-ke-string-string-interpolation)
        - [Angka ke Angka (Implicit dan Explicit)](#angka-ke-angka-implicit-dan-explicit)
        - [Boolean ke String](#boolean-ke-string)
        - [List ke Set dan Sebaliknya](#list-ke-set-dan-sebaliknya)
      - [d. `tryParse()` untuk Konversi Aman](#d-tryparse-untuk-konversi-aman)
    - [4. Perbedaan Kunci: Casting vs. Conversion](#4-perbedaan-kunci-casting-vs-conversion)
    - [5. Ringkasan](#5-ringkasan)

</details>

---

### 1\. Pendahuluan

Dalam pemrograman, Anda akan sering menghadapi situasi di mana Anda perlu mengubah cara Dart "melihat" sebuah nilai atau mengubah nilai itu sendiri ke representasi tipe data yang berbeda. Inilah yang dilakukan oleh **Casting** dan **Conversion**. Meskipun keduanya melibatkan perubahan tipe, mereka beroperasi pada level yang berbeda dan memiliki implikasi yang berbeda pula terhadap keamanan kode.

Memahami perbedaan dan kapan menggunakan masing-masing adalah fundamental untuk menulis kode Dart yang benar dan robust.

---

### 2\. Casting (Type Cast)

#### a. Apa Itu Casting?

**Casting** (atau _Type Cast_) adalah proses di mana Anda memberitahu kompiler untuk memperlakukan sebuah objek sebagai tipe data yang berbeda dari tipe yang diinferensi atau dideklarasikan oleh kompiler. Casting **tidak mengubah nilai objek itu sendiri**; itu hanya mengubah cara kompiler melihat objek tersebut pada waktu kompilasi, dengan asumsi bahwa objek tersebut sebenarnya adalah instance dari tipe target pada waktu _runtime_.

Casting biasanya digunakan ketika Anda memiliki sebuah objek dengan tipe yang lebih umum (misalnya `Object` atau _supertype_), tetapi Anda tahu (atau menduga) bahwa objek tersebut sebenarnya adalah instance dari tipe yang lebih spesifik (_subtype_) pada waktu _runtime_.

#### b. Operator `as`

Di Dart, operator utama untuk _explicit casting_ adalah `as`.

```dart
void main() {
  Object myVariable = "Hello Dart!"; // Tipe deklarasi adalah Object

  // Casting 'myVariable' sebagai String
  String message = myVariable as String;
  print(message.length); // OK, karena sekarang Dart tahu ini adalah String
}
```

Dalam contoh di atas, nilai `"Hello Dart!"` sebenarnya adalah `String`, tetapi dideklarasikan sebagai `Object`. Dengan `myVariable as String`, kita memberitahu Dart untuk memperlakukan `myVariable` sebagai `String`, sehingga kita bisa mengakses properti `length`.

#### c. Kapan Menggunakan `as`?

- **Ketika Anda yakin objek adalah tipe yang benar**: Skenario paling umum adalah ketika Anda mengambil objek dari koleksi `List<Object>` atau `Map<String, Object>` dan Anda tahu apa tipe sebenarnya dari elemen tersebut.
- **Untuk _downcasting_**: Mengubah tipe dari superkelas ke subkelas.

<!-- end list -->

```dart
class Animal {}
class Dog extends Animal {
  void bark() => print('Woof!');
}
class Cat extends Animal {
  void meow() => print('Meow!');
}

void main() {
  Animal myAnimal = Dog(); // Animal adalah supertipe Dog

  // Kita tahu myAnimal sebenarnya Dog, jadi bisa di-cast
  (myAnimal as Dog).bark(); // Output: Woof!

  // Jika kita tidak yakin, ini berbahaya
  // (myAnimal as Cat).meow(); // ERROR: _CastError
}
```

#### d. Risiko Menggunakan `as` (Runtime Error)

Bahaya utama dari `as` adalah jika objek yang Anda coba _cast_ ternyata **bukan** instance dari tipe target pada waktu _runtime_, Dart akan melempar `_CastError`. Ini adalah _runtime error_ yang akan menghentikan program Anda.

```dart
void main() {
  Object data = 123; // Ini adalah int

  // Mencoba meng-cast int ke String
  // String text = data as String; // Ini akan melempar _CastError pada runtime
  // print(text);
}
```

Karena risiko ini, penggunaan `as` harus dilakukan dengan hati-hati dan hanya ketika Anda memiliki jaminan kuat (misalnya, dari logika program sebelumnya atau API yang Anda tahu) bahwa _cast_ akan berhasil.

#### e. Alternatif yang Lebih Aman: `is` dan Type Promotion

Cara yang lebih aman dan direkomendasikan untuk menangani _downcasting_ adalah dengan menggunakan operator `is` bersama dengan fitur **Type Promotion** Dart.

```dart
void main() {
  Object data = "Hello Safe Cast!";

  if (data is String) {
    // Di dalam blok ini, 'data' secara otomatis dipromosikan menjadi String
    print(data.length); // OK, akses properti String
  } else {
    print("Data bukan String.");
  }

  Object number = 42;
  if (number is int) {
    print(number * 2); // OK, akses operasi int
  }
}
```

Dengan `is`, Anda memeriksa tipe terlebih dahulu. Jika cocok, Dart secara cerdas mempromosikan tipe variabel tersebut di dalam _scope_ kondisional, memungkinkan Anda menggunakan metode atau properti dari tipe yang lebih spesifik tanpa risiko `_CastError`.

#### f. Contoh Praktis: Iterasi List Campuran

```dart
void processItems(List<Object> items) {
  for (var item in items) {
    if (item is String) {
      print("String: ${item.toUpperCase()}");
    } else if (item is int) {
      print("Integer: ${item * 10}");
    } else {
      print("Unknown type: $item");
    }
  }
}

void main() {
  List<Object> mixedList = ["apple", 123, true, "banana", 45.6];
  processItems(mixedList);
}
```

Output:

```
String: APPLE
Integer: 1230
Unknown type: true
String: BANANA
Unknown type: 45.6
```

Ini adalah cara yang aman dan _idiomatic_ untuk menangani tipe data yang bervariasi dalam koleksi.

---

### 3\. Conversion (Type Conversion)

#### a. Apa Itu Conversion?

**Conversion** (atau _Type Conversion_) adalah proses mengubah nilai dari satu tipe data menjadi nilai dengan tipe data yang berbeda. Berbeda dengan _casting_, _conversion_ **membuat nilai baru** dari tipe target berdasarkan nilai asli. Ini adalah operasi yang secara fundamental mengubah representasi data.

Contoh: Mengubah `String` `"123"` menjadi `int` `123`.

#### b. Perbedaan Utama dengan Casting

| Fitur                | Casting (`as`)                                     | Conversion                                                   |
| :------------------- | :------------------------------------------------- | :----------------------------------------------------------- |
| **Apa yang Diubah?** | Cara kompiler melihat tipe objek yang sudah ada.   | Nilai objek itu sendiri menjadi representasi tipe lain.      |
| **Output**           | Objek yang sama, diperlakukan dengan tipe berbeda. | Objek baru dengan tipe dan nilai baru.                       |
| **Risiko Runtime**   | `_CastError` jika tipe tidak cocok.                | `FormatException` atau error lain jika konversi tidak valid. |
| **Contoh**           | `Object x = "a"; String s = x as String;`          | `String s = "123"; int i = int.parse(s);`                    |

#### c. Metode Konversi Umum

Dart menyediakan banyak metode bawaan untuk konversi antar tipe data dasar.

##### String ke Angka (`int.parse()`, `double.parse()`)

- **`int.parse(String source)`**: Mengonversi string menjadi integer.
- **`double.parse(String source)`**: Mengonversi string menjadi double.

<!-- end list -->

```dart
void main() {
  String numStr = "123";
  int number = int.parse(numStr);
  print("Int from string: ${number + 1}"); // Output: 124

  String doubleStr = "3.14";
  double pi = double.parse(doubleStr);
  print("Double from string: ${pi * 2}"); // Output: 6.28
}
```

##### Angka ke String (`.toString()`)

- Semua objek di Dart memiliki metode `toString()` yang mengembalikan representasi string dari objek tersebut.

<!-- end list -->

```dart
void main() {
  int num = 123;
  String numAsString = num.toString();
  print("Number as string: $numAsString"); // Output: 123

  double price = 99.99;
  String priceAsString = price.toStringAsFixed(2); // Untuk format desimal
  print("Price as string: $priceAsString"); // Output: 99.99
}
```

##### Tipe Lain ke String (String Interpolation)

- String interpolation (`$variable` atau `${expression}`) secara otomatis memanggil `toString()` di balik layar, membuatnya sangat nyaman.

<!-- end list -->

```dart
void main() {
  bool isLoggedIn = true;
  List<int> scores = [80, 90, 75];

  print("User logged in: $isLoggedIn");   // Output: User logged in: true
  print("Scores: $scores");             // Output: Scores: [80, 90, 75]
}
```

##### Angka ke Angka (Implicit dan Explicit)

- **Implicit**: Dart bisa secara otomatis mengonversi `int` ke `double` jika konteks membutuhkannya (misalnya, dalam operasi dengan `double`).

  ```dart
  int a = 5;
  double b = 2.5;
  double result = a + b; // int 'a' diubah secara implisit menjadi double
  print(result); // Output: 7.5
  ```

- **Explicit**: Anda perlu secara eksplisit mengonversi `double` ke `int` (misalnya, dengan membuang bagian desimal).

  ```dart
  double x = 7.8;
  int y = x.toInt(); // Mengonversi double ke int (membulatkan ke bawah)
  print(y); // Output: 7

  int z = x.round(); // Pembulatan terdekat
  print(z); // Output: 8
  ```

##### Boolean ke String

```dart
void main() {
  bool isActive = false;
  String status = isActive.toString();
  print(status); // Output: false
}
```

##### List ke Set dan Sebaliknya

Untuk menghilangkan duplikat atau mengubah struktur koleksi.

```dart
void main() {
  List<int> numbers = [1, 2, 2, 3, 4, 4, 5];

  Set<int> uniqueNumbers = numbers.toSet(); // Konversi List ke Set
  print(uniqueNumbers); // Output: {1, 2, 3, 4, 5}

  List<int> backToList = uniqueNumbers.toList(); // Konversi Set kembali ke List
  print(backToList); // Output: [1, 2, 3, 4, 5]
}
```

#### d. `tryParse()` untuk Konversi Aman

Ketika mengonversi string ke angka, string mungkin tidak dalam format yang valid. Daripada melempar `FormatException` (yang akan menghentikan program), gunakan `tryParse()` yang akan mengembalikan `null` jika konversi gagal.

```dart
void main() {
  String validNum = "123";
  int? parsedInt = int.tryParse(validNum);
  print(parsedInt); // Output: 123

  String invalidNum = "abc";
  int? failedParse = int.tryParse(invalidNum);
  print(failedParse); // Output: null

  if (failedParse == null) {
    print("Gagal mengonversi string menjadi angka.");
  }
}
```

---

### 4\. Perbedaan Kunci: Casting vs. Conversion

| Fitur                    | Casting (`as`)                                                                     | Conversion (`.parse()`, `.toString()`, dll.)                         |
| :----------------------- | :--------------------------------------------------------------------------------- | :------------------------------------------------------------------- |
| **Tujuan**               | Mengubah pandangan kompiler terhadap tipe objek yang sudah ada.                    | Mengubah nilai satu tipe data menjadi nilai tipe data yang berbeda.  |
| **Objek Asli**           | Tetap sama, tidak ada objek baru yang dibuat.                                      | Objek baru dari tipe target dibuat.                                  |
| **Risiko Error**         | `_CastError` jika tipe runtime tidak cocok.                                        | `FormatException` atau error logis jika nilai tidak bisa dikonversi. |
| **Kapan Digunakan**      | Saat Anda memiliki _supertype_ dan perlu mengakses _subtype_ (setelah verifikasi). | Saat Anda perlu mengubah nilai dari satu tipe ke tipe lain.          |
| **Intensitas Perubahan** | "Re-interpretasi" tipe data.                                                       | "Transformasi" nilai data.                                           |

---

### 5\. Ringkasan

**Casting** (`as`) dan **Conversion** (metode seperti `parse()`, `toString()`) adalah dua mekanisme penting untuk mengelola tipe data di Dart:

- **Casting (`as`)**:
  - Memberitahu kompiler untuk memperlakukan objek sebagai tipe yang berbeda (biasanya lebih spesifik).
  - Tidak mengubah nilai objek asli.
  - Berisiko melempar `_CastError` jika objek bukan instance dari tipe target pada _runtime_.
  - Lebih aman digunakan dengan `is` dan _type promotion_.
- **Conversion (`int.parse()`, `toString()`, dll.)**:
  - Mengubah nilai dari satu tipe data menjadi nilai dari tipe data yang berbeda.
  - Menghasilkan objek baru.
  - Berisiko melempar `FormatException` jika nilai sumber tidak valid untuk konversi.
  - Gunakan `tryParse()` untuk konversi yang lebih aman.

Menguasai perbedaan antara _casting_ dan _conversion_, serta memilih metode yang tepat untuk setiap skenario, akan membantu Anda menulis kode Dart yang lebih aman, lebih efisien, dan lebih mudah dipelihara.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-19/README.md
[selanjutnya]: ../bagian-21/README.md
[0]:../README.md