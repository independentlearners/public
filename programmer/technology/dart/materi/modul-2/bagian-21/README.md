# [Runtime Type][0]

Ini adalah konsep penting yang berkaitan dengan bagaimana Dart, sebagai bahasa dengan sistem tipe yang kuat dan juga memiliki aspek dinamis, menangani tipe data selama eksekusi program.

<details>
  <summary>📃 Daftar Isi</summary>

---

- [Runtime Type](#runtime-type)
    - [1. Pendahuluan](#1-pendahuluan)
    - [2. Apa Itu Runtime Type?](#2-apa-itu-runtime-type)
    - [3. Properti `.runtimeType`](#3-properti-runtimetype)
      - [a. Sintaks](#a-sintaks)
      - [b. Contoh Dasar](#b-contoh-dasar)
    - [4. Peran `runtimeType` dalam Type System Dart](#4-peran-runtimetype-dalam-type-system-dart)
      - [a. Statis vs. Dinamis](#a-statis-vs-dinamis)
      - [b. Hubungan dengan `Object`](#b-hubungan-dengan-object)
      - [c. Hubungan dengan Generics](#c-hubungan-dengan-generics)
    - [5. Kapan Menggunakan `runtimeType`?](#5-kapan-menggunakan-runtimetype)
      - [a. Debugging dan Logging](#a-debugging-dan-logging)
      - [b. Pemeriksaan Tipe dalam Kasus Dinamis (Jarang Disarankan)](#b-pemeriksaan-tipe-dalam-kasus-dinamis-jarang-disarankan)
      - [c. Penanganan Kasus Edge atau Library Eksternal](#c-penanganan-kasus-edge-atau-library-eksternal)
    - [6. Kapan **TIDAK** Menggunakan `runtimeType`?](#6-kapan-tidak-menggunakan-runtimetype)
      - [a. Jangan Gantikan `is` Operator](#a-jangan-gantikan-is-operator)
      - [b. Jangan Gunakan untuk Kontrol Aliran Utama](#b-jangan-gunakan-untuk-kontrol-aliran-utama)
      - [c. Implikasi Performa](#c-implikasi-performa)
      - [d. Masalah dengan Obfuscation (di Flutter/Release Builds)](#d-masalah-dengan-obfuscation-di-flutterrelease-builds)
    - [7. Perbandingan `.runtimeType` vs. `is` Operator](#7-perbandingan-runtimetype-vs-is-operator)
    - [8. Ringkasan](#8-ringkasan)

</details>

---

### 1\. Pendahuluan

Dart adalah bahasa yang _statically typed_, artinya kompiler mengetahui tipe variabel pada waktu kompilasi. Namun, setiap objek di Dart juga memiliki tipe yang sebenarnya pada waktu eksekusi program, yang disebut **Runtime Type**. Pemahaman tentang _runtime type_ penting karena membantu Anda memahami bagaimana Dart bekerja dengan objek secara dinamis dan kapan harus berhati-hati dalam penanganan tipe.

---

### 2\. Apa Itu Runtime Type?

**Runtime Type** adalah tipe data sebenarnya dari sebuah objek pada saat program sedang berjalan. Meskipun sebuah variabel mungkin dideklarasikan dengan tipe yang lebih umum (misalnya, `Object` atau _supertype_), _runtime type_ akan selalu mencerminkan tipe yang paling spesifik dari objek yang disimpan oleh variabel tersebut.

Setiap objek di Dart (kecuali `null`) memiliki _runtime type_. Anda dapat mengakses _runtime type_ dari setiap objek menggunakan properti `.runtimeType`.

---

### 3\. Properti `.runtimeType`

#### a. Sintaks

Untuk mendapatkan _runtime type_ dari sebuah objek, Anda cukup mengakses properti `.runtimeType` pada objek tersebut.

```dart
objectInstance.runtimeType
```

Properti ini mengembalikan sebuah objek dari tipe `Type`.

#### b. Contoh Dasar

```dart
void main() {
  int myInt = 10;
  double myDouble = 3.14;
  String myString = "Hello";
  bool myBool = true;
  List<int> myIntList = [1, 2, 3];
  Map<String, double> myMap = {'a': 1.0, 'b': 2.0};

  print('myInt type: ${myInt.runtimeType}');        // Output: int
  print('myDouble type: ${myDouble.runtimeType}');    // Output: double
  print('myString type: ${myString.runtimeType}');    // Output: String
  print('myBool type: ${myBool.runtimeType}');      // Output: bool
  print('myIntList type: ${myIntList.runtimeType}');  // Output: List<int>
  print('myMap type: ${myMap.runtimeType}');        // Output: _Map<String, double> (atau sejenisnya, tergantung implementasi)

  // Meskipun dideklarasikan sebagai Object, runtimeType adalah tipe sebenarnya
  Object genericObject = "Dart";
  print('genericObject type: ${genericObject.runtimeType}'); // Output: String

  // Dengan var, runtimeType adalah tipe inferensi
  var inferredString = "Inferred";
  print('inferredString type: ${inferredString.runtimeType}'); // Output: String
}
```

---

### 4\. Peran `runtimeType` dalam Type System Dart

#### a. Statis vs. Dinamis

- **Tipe Statis**: Tipe yang dikenal kompiler pada waktu kompilasi. Ini membantu dalam deteksi error dini dan _autocompletion_ IDE.
- **Tipe Dinamis (`runtimeType`)**: Tipe sebenarnya dari objek pada waktu program berjalan.

Dart menggunakan sistem tipe yang kuat pada waktu kompilasi (`static typing`), tetapi setiap objek tetap membawa informasi tipe *runtime*nya. Ini adalah fitur yang memungkinkan _reflection_ (meskipun `dart:mirrors` tidak tersedia di semua platform) dan operasi _downcasting_ yang aman dengan `is`.

#### b. Hubungan dengan `Object`

Semua objek di Dart (kecuali `null`) adalah subtipe dari `Object`. Properti `.runtimeType` adalah metode yang diwarisi dari kelas `Object`.

```dart
class MyClass {}

void main() {
  Object obj = MyClass();
  print(obj.runtimeType); // Output: MyClass
}
```

#### c. Hubungan dengan Generics

`runtimeType` juga akan mencerminkan argumen tipe generik pada _runtime_.

```dart
void main() {
  List<int> intList = [1, 2, 3];
  List<double> doubleList = [1.0, 2.0, 3.0];
  List<dynamic> dynamicList = [1, 'two', true];

  print(intList.runtimeType);     // Output: List<int>
  print(doubleList.runtimeType);  // Output: List<double>
  print(dynamicList.runtimeType); // Output: List<dynamic>

  // Contoh fungsi yang menerima List<Object>
  void processList(List<Object> list) {
    print('Processing list of type: ${list.runtimeType}');
  }

  processList(intList);    // Output: Processing list of type: List<int>
  processList(doubleList); // Output: Processing list of type: List<double>
}
```

Ini menunjukkan bahwa Dart mempertahankan informasi tipe generik pada _runtime_, yang berguna untuk debugging dan beberapa kasus penggunaan canggih.

---

### 5\. Kapan Menggunakan `runtimeType`?

Penggunaan `runtimeType` biasanya terbatas pada skenario tertentu dan seringkali merupakan indikasi bahwa ada cara yang lebih _idiomatic_ dan aman untuk mencapai tujuan yang sama.

#### a. Debugging dan Logging

Ini adalah kasus penggunaan yang paling umum dan aman. Ketika Anda mencoba memahami mengapa sebuah program berperilaku dengan cara tertentu, mencetak `object.runtimeType` dapat memberikan informasi yang berharga tentang tipe sebenarnya dari sebuah variabel pada saat eksekusi.

```dart
void processUnknownData(dynamic data) {
  print('Received data of type: ${data.runtimeType}');
  // ...
}

void main() {
  processUnknownData(123);      // Output: Received data of type: int
  processUnknownData("Test");   // Output: Received data of type: String
  processUnknownData({'key': 'value'}); // Output: Received data of type: _Map<String, String>
}
```

#### b. Pemeriksaan Tipe dalam Kasus Dinamis (Jarang Disarankan)

Dalam kasus yang sangat jarang terjadi di mana Anda harus berurusan dengan `dynamic` dan perlu melakukan tindakan berdasarkan tipe _runtime_ objek. Namun, ini hampir selalu harus digantikan oleh operator `is`.

```dart
// Meskipun berfungsi, ini TIDAK disarankan!
void processItemLegacy(dynamic item) {
  if (item.runtimeType == String) {
    print("String detected: ${item.toUpperCase()}");
  } else if (item.runtimeType == int) {
    print("Int detected: ${item * 2}");
  } else {
    print("Unknown type: ${item.runtimeType}");
  }
}
```

#### c. Penanganan Kasus Edge atau Library Eksternal

Kadang-kadang, ketika berinteraksi dengan _library_ JavaScript melalui Dart FFI atau mekanisme _interop_ lainnya, di mana informasi tipe statis mungkin hilang, `runtimeType` bisa menjadi alat terakhir untuk memeriksa apa yang sebenarnya Anda dapatkan.

---

### 6\. Kapan **TIDAK** Menggunakan `runtimeType`?

Sebagian besar waktu, Anda **tidak boleh** menggunakan `runtimeType` untuk logika program inti atau kontrol aliran.

#### a. Jangan Gantikan `is` Operator

- **`is` operator jauh lebih aman dan _idiomatic_** untuk pemeriksaan tipe karena memicu _type promotion_ dan bekerja dengan _subtyping_. `runtimeType` hanya memeriksa kesamaan tipe yang persis.

  ```dart
  class Animal {}
  class Dog extends Animal {}
  class Poodle extends Dog {}

  void main() {
    Animal myAnimal = Poodle();

    print(myAnimal.runtimeType == Poodle); // Output: true
    print(myAnimal.runtimeType == Dog);    // Output: false (Padahal Poodle adalah Dog)
    print(myAnimal.runtimeType == Animal); // Output: false (Padahal Poodle adalah Animal)

    if (myAnimal is Poodle) { print("Is Poodle"); } // OK
    if (myAnimal is Dog)    { print("Is Dog"); }    // OK
    if (myAnimal is Animal) { print("Is Animal"); } // OK
  }
  ```

  Seperti yang terlihat, `runtimeType == SomeType` tidak menghormati hierarki pewarisan, sedangkan `is` melakukannya.

#### b. Jangan Gunakan untuk Kontrol Aliran Utama

- Jika Anda mendapati diri Anda menulis banyak blok `if/else if` yang menggunakan `runtimeType` untuk memutuskan tindakan, kemungkinan besar ada pola desain yang lebih baik (misalnya, _polymorphism_, pola _visitor_, atau _sealed classes_ di masa depan Dart).

#### c. Implikasi Performa

- Mengakses `runtimeType` mungkin memiliki sedikit _overhead_ performa dibandingkan dengan pemeriksaan tipe statis. Meskipun biasanya tidak signifikan, sering menggunakannya dalam _hot path_ dapat menjadi masalah.

#### d. Masalah dengan Obfuscation (di Flutter/Release Builds)

- Dalam _release builds_ Flutter atau aplikasi Dart yang dikompilasi ke kode asli, nama kelas mungkin di-_obfuscate_ (diubah menjadi nama yang lebih pendek dan tidak dapat dibaca) untuk mengurangi ukuran file. Ini berarti `object.runtimeType.toString()` mungkin mengembalikan `_MyClass` atau nama lain yang tidak terduga, bukan `MyClass`. Ini membuat `runtimeType` tidak andal untuk perbandingan string.

  ```dart
  // Dalam debug build:
  print(MyClass().runtimeType); // Output: MyClass

  // Dalam release build (dengan obfuscation):
  print(MyClass().runtimeType); // Output: d atau _MyClassImpl atau sejenisnya
  ```

  Meskipun `obj.runtimeType == MyClass` masih berfungsi karena membandingkan objek `Type`, mencetak `toString()` dari _runtime type_ dapat menyesatkan.

---

### 7\. Perbandingan `.runtimeType` vs. `is` Operator

| Fitur                  | `.runtimeType`                                                  | `is` Operator                                                             |
| :--------------------- | :-------------------------------------------------------------- | :------------------------------------------------------------------------ |
| **Tujuan**             | Mendapatkan objek `Type` aktual dari objek.                     | Memeriksa apakah objek adalah instance dari tipe tertentu (atau subtipe). |
| **Subtyping**          | **Tidak menghormati subtyping** (hanya cocok persis).           | **Menghormati subtyping** (akan `true` untuk supertipe).                  |
| **Type Promotion**     | Tidak ada.                                                      | Ya, mempromosikan tipe di dalam _scope_ kondisional.                      |
| **Return Value**       | Objek `Type`.                                                   | `bool` (`true` atau `false`).                                             |
| **Kapan Digunakan**    | Debugging, logging, kasus sangat khusus (hindari jika mungkin). | **Sangat direkomendasikan** untuk pemeriksaan tipe dan kontrol aliran.    |
| **Risiko Obfuscation** | `toString()` bisa terpengaruh di release build.                 | Tidak terpengaruh.                                                        |

---

### 8\. Ringkasan

**Runtime Type** di Dart merujuk pada tipe data sebenarnya dari sebuah objek saat program sedang berjalan, dapat diakses melalui properti `.runtimeType`. Meskipun berguna untuk tujuan **debugging dan logging**, sangat penting untuk memahami bahwa:

- Anda **tidak boleh** menggunakan `runtimeType` untuk kontrol aliran program atau sebagai pengganti operator `is`.
- Operator `is` jauh lebih aman, efisien, dan benar karena menghormati hierarki pewarisan (`subtyping`) dan memicu _type promotion_.
- Ada implikasi performa dan potensi masalah dengan _obfuscation_ di _release builds_ yang membuat `runtimeType` kurang andal untuk logika program inti.

Selalu prioritaskan penggunaan operator `is` dan _type promotion_ untuk pemeriksaan dan penanganan tipe yang aman dan _idiomatic_ di Dart.

---

<!-- > - **[Selanjutnya][selanjutnya]** -->

> - **[Ke Atas](#)**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-20/README.md
[0]: ../README.md

<!-- [selanjutnya]: ../bagian-18/README.md -->
