# [Type Annotations][0]

Ini adalah topik yang sangat berkaitan erat dengan Type System dan Type Inference yang baru saja kita diskusikan.

<details>
  <summary>📃 Daftar Isi</summary>

---

- [Type Annotations](#type-annotations)
  - [1. Pendahuluan](#1-pendahuluan)
  - [2. Apa Itu Type Annotation?](#2-apa-itu-type-annotation)
  - [3. Mengapa Menggunakan Type Annotation (Meskipun Ada Type Inference)?](#3-mengapa-menggunakan-type-annotation-meskipun-ada-type-inference)
    - [a. Klarifikasi dan Keterbacaan](#a-klarifikasi-dan-keterbacaan)
    - [b. API Publik](#b-api-publik)
    - [c. Mencegah Ambiguitas Inferensi Tipe](#c-mencegah-ambiguitas-inferensi-tipe)
    - [d. Variabel yang Tidak Diinisialisasi Awal](#d-variabel-yang-tidak-diinisialisasi-awal)
  - [4. Dimana Type Annotation Digunakan?](#4-dimana-type-annotation-digunakan)
    - [a. Deklarasi Variabel](#a-deklarasi-variabel)
    - [b. Parameter Fungsi/Metode](#b-parameter-fungsimetode)
    - [c. Return Type Fungsi/Metode](#c-return-type-fungsimetode)
    - [d. Class Fields (Properti Kelas)](#d-class-fields-properti-kelas)
    - [e. Generic Type Arguments](#e-generic-type-arguments)
    - [f. Type Casts](#f-type-casts)
  - [5. Type Annotation dan Null Safety](#5-type-annotation-dan-null-safety)
    - [a. Non-nullable by Default](#a-non-nullable-by-default)
    - [b. Nullable Types (`?`)](#b-nullable-types-)
  - [6. Type Annotation dalam Praktek (Kode Bersih)](#6-type-annotation-dalam-praktek-kode-bersih)
  - [7. Kapan Menghindari Type Annotation Eksplisit?](#7-kapan-menghindari-type-annotation-eksplisit)
  - [8. Ringkasan](#8-ringkasan)

</details>

---

### 1\. Pendahuluan

Dart adalah bahasa _statically typed_, yang berarti setiap variabel memiliki tipe yang diketahui pada waktu kompilasi. Meskipun **Type Inference** memungkinkan kompiler untuk secara otomatis menentukan tipe data, ada kalanya Anda perlu (atau ingin) secara eksplisit menyatakan tipe data. Proses penulisan tipe data secara eksplisit ini disebut **Type Annotation**.

Type annotation adalah praktik menambahkan deklarasi tipe di samping variabel, parameter, atau nilai kembalian. Ini adalah fitur dasar dari sistem tipe Dart yang berkontribusi pada keamanan dan kejelasan kode.

---

### 2\. Apa Itu Type Annotation?

**Type Annotation** adalah penulisan tipe data secara eksplisit di dalam kode. Ini memberitahu kompiler (dan pengembang lain) apa jenis nilai yang diharapkan untuk sebuah variabel, parameter fungsi, atau apa yang akan dikembalikan oleh sebuah fungsi.

Contoh paling dasar:

```dart
void main() {
  String message = "Hello Dart!"; // 'String' adalah type annotation
  int count = 10;                // 'int' adalah type annotation
  bool isActive = true;          // 'bool' adalah type annotation
}
```

Dalam contoh di atas, kita secara eksplisit mendeklarasikan bahwa `message` akan menyimpan `String`, `count` akan menyimpan `int`, dan `isActive` akan menyimpan `bool`.

---

### 3\. Mengapa Menggunakan Type Annotation (Meskipun Ada Type Inference)?

Meskipun Type Inference sangat membantu, Type Annotation tetap memiliki peran penting:

#### a. Klarifikasi dan Keterbacaan

- Ketika tipe data mungkin tidak sepenuhnya jelas dari nilai inisialisasinya, atau ketika Anda ingin memberikan petunjuk yang lebih kuat tentang niat Anda.

- Untuk pembaca kode (termasuk diri Anda di masa depan), type annotation dapat berfungsi sebagai bentuk dokumentasi instan.

  ```dart
  // Tanpa annotation (apa tipe List ini?)
  var data = []; // Inferensi List<dynamic> - mungkin bukan yang diinginkan

  // Dengan annotation (lebih jelas)
  List<String> names = []; // Jelas ini adalah List of Strings
  ```

#### b. API Publik

- Untuk _field_ publik, parameter fungsi/metode, dan _return type_ di API yang Anda ekspos ke bagian lain dari aplikasi Anda atau ke _developer_ lain.

- Ini adalah bagian penting dari kontrak API Anda, membantu pengguna API memahami bagaimana menggunakannya dengan benar.

  ```dart
  // Fungsi di library publik
  String formatCurrency(double amount, String currencyCode) {
    // ...
  }
  // Jelas bahwa dibutuhkan double dan String, dan mengembalikan String.
  ```

#### c. Mencegah Ambiguitas Inferensi Tipe

- Seperti yang kita bahas di Type Inference, ada kasus di mana inferensi bisa menjadi terlalu umum (misalnya `List<dynamic>`) atau tidak sesuai dengan niat Anda. Type annotation memungkinkan Anda untuk secara tepat menentukan tipe yang diinginkan.

  ```dart
  var values = {1, 'two', 3.0}; // Inferensi sebagai Set<Object>
  // Jika Anda ingin hanya angka:
  Set<num> numericValues = {1, 2.0, 3}; // Memaksa ke num
  ```

#### d. Variabel yang Tidak Diinisialisasi Awal

- Jika Anda mendeklarasikan variabel tanpa memberinya nilai awal, Anda **harus** menyediakan type annotation agar Dart tahu tipe apa yang akan disimpan variabel tersebut.

  ```dart
  String? userName; // Harus ada 'String?' karena tidak ada inisialisasi awal
  // int count; // ERROR: Non-nullable instance field 'count' must be initialized.
  // Jika memang tidak diinisialisasi awal, harus nullable atau late
  late int totalItems; // Atau 'int? totalItems;'
  ```

---

### 4\. Dimana Type Annotation Digunakan?

Type annotation dapat ditemukan di beberapa tempat dalam kode Dart:

#### a. Deklarasi Variabel

- Untuk variabel lokal, _top-level_, atau _static field_.

  ```dart
  double temperature = 25.5; // Lokal
  const String APP_NAME = "My App"; // Top-level const
  static int counter = 0; // Static field
  ```

#### b. Parameter Fungsi/Metode

- Mendefinisikan tipe data yang diharapkan untuk setiap parameter fungsi atau metode.

  ```dart
  void greet(String name, int age) { // 'String' dan 'int' adalah annotations
    print("Hello $name, you are $age years old.");
  }
  ```

#### c. Return Type Fungsi/Metode

- Mendefinisikan tipe data nilai yang akan dikembalikan oleh fungsi atau metode.

  ```dart
  String getFullName(String firstName, String lastName) { // 'String' adalah return type
    return '$firstName $lastName';
  }

  // Untuk fungsi yang tidak mengembalikan apa-apa, gunakan 'void'
  void printMessage(String message) {
    print(message);
  }
  ```

#### d. Class Fields (Properti Kelas)

- Mendefinisikan tipe data untuk properti (variabel instance) dalam sebuah kelas.

  ```dart
  class Product {
    String name;       // Type annotation
    double price;      // Type annotation
    int? stock;        // Type annotation (nullable)

    Product(this.name, this.price, {this.stock});
  }
  ```

#### e. Generic Type Arguments

- Saat menggunakan koleksi generik (seperti `List`, `Set`, `Map`) atau kelas/fungsi generik kustom.

  ```dart
  List<String> items = ['A', 'B', 'C'];
  Map<int, bool> statusFlags = {1: true, 2: false};
  Future<User> fetchUser(String id) async { /* ... */ }
  ```

#### f. Type Casts

- Menggunakan operator `as` untuk secara eksplisit mengubah tipe suatu objek.

  ```dart
  Object data = "some text";
  String text = data as String; // 'String' di sini adalah bagian dari type cast
  ```

---

### 5\. Type Annotation dan Null Safety

Type annotation adalah inti dari bagaimana Dart's Null Safety bekerja.

#### a. Non-nullable by Default

- Ketika Anda memberikan type annotation tanpa `?`, variabel tersebut secara otomatis dianggap **non-nullable**.

  ```dart
  String userName = "Alice"; // userName tidak bisa null
  int count = 10;             // count tidak bisa null
  ```

#### b. Nullable Types (`?`)

- Anda menggunakan type annotation dengan tanda tanya (`?`) untuk secara eksplisit menunjukkan bahwa variabel, parameter, atau _return type_ **dapat** berisi `null`.

  ```dart
  String? optionalName; // Bisa null
  int? nullableCount = 5;
  nullableCount = null; // OK

  // Parameter fungsi yang bisa null
  void printGreeting(String? name) {
    if (name != null) {
      print("Hello, $name!");
    } else {
      print("Hello, stranger!");
    }
  }

  // Return type yang bisa null
  String? findUser(int id) {
    if (id == 123) {
      return "John Doe";
    }
    return null;
  }
  ```

---

### 6\. Type Annotation dalam Praktek (Kode Bersih)

Gaya kode yang baik di Dart seringkali menyeimbangkan antara menggunakan type inference untuk keringkasan dan type annotation untuk kejelasan.

- **Gunakan type inference (`var`, `final`, `const`)** ketika tipe sudah sangat jelas dari nilai inisialisasinya.
  ```dart
  var age = 30; // Jelas int
  final name = 'Alice'; // Jelas String
  const pi = 3.14; // Jelas double
  ```
- **Gunakan type annotation eksplisit** ketika:
  - Mendeklarasikan variabel tanpa inisialisasi awal.
  - Tipe data koleksi yang kosong atau elemennya tidak jelas.
  - Parameter dan _return type_ dari fungsi/metode (terutama yang bersifat publik).
  - Ketika inferensi menghasilkan tipe yang terlalu umum (misalnya `dynamic`, `Object?`) dan Anda membutuhkan tipe yang lebih spesifik.

<!-- end list -->

```dart
// Contoh gaya yang disarankan:
// Variabel lokal yang jelas:
var message = "Hello";
var products = ['Laptop', 'Mouse'];

// Variabel tanpa inisialisasi awal, atau ketika tipe tidak jelas dari inisialisasi
String? userName; // Nullable, belum ada nilai
List<Map<String, dynamic>> userList = []; // Jelas struktur datanya

// Fungsi/metode dengan type annotations yang jelas
void processData(List<String> data, {required int limit}) {
  // ...
}

Future<double> calculateAverage(List<double> values) async {
  // ...
}
```

---

### 7\. Kapan Menghindari Type Annotation Eksplisit?

Meskipun penting, terlalu banyak type annotation juga bisa membuat kode menjadi _verbose_ dan kurang mudah dibaca. Hindari type annotation eksplisit ketika:

- **Type inference sudah cukup jelas**: Jika `var result = someFunction();` sudah cukup jelas bahwa `result` adalah `SomeClass`, tidak perlu menulis `SomeClass result = someFunction();`.
- **Menyebabkan redundansi**: Mengulangi tipe yang sudah jelas dari inisialisasi.

Tujuannya adalah keseimbangan: gunakan type annotation untuk meningkatkan kejelasan dan keamanan, tetapi jangan berlebihan sampai mengorbankan keringkasan dan keterbacaan.

---

### 8\. Ringkasan

**Type Annotations** adalah penulisan tipe data secara eksplisit di kode Dart. Mereka adalah bagian integral dari sistem tipe statis Dart dan Null Safety.

Fungsi utama Type Annotation adalah untuk:

- **Meningkatkan klarifikasi dan keterbacaan kode.**
- **Mendefinisikan kontrak yang jelas untuk API publik.**
- **Mencegah ambiguitas dalam inferensi tipe.**
- **Memungkinkan deklarasi variabel tanpa inisialisasi awal.**

Anda akan menemukan type annotation digunakan untuk deklarasi variabel, parameter fungsi, _return type_, _class fields_, dan _generic type arguments_. Dalam konteks Null Safety, type annotation juga secara eksplisit menunjukkan apakah suatu tipe dapat berupa `null` dengan tanda `?`.

Dengan penggunaan Type Annotation yang bijak, dikombinasikan dengan Type Inference, Anda dapat menulis kode Dart yang robust, aman, dan mudah dipahami.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-18/README.md
[selanjutnya]: ../bagian-20/README.md
[0]: ../README.md
