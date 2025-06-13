# [Type System Mastery][0]

Ini adalah salah satu aspek fundamental Dart yang sangat powerful dan berkontribusi pada penulisan kode yang robust dan mudah dirawat.

<details>
  <summary>📃 Daftar Isi</summary>

---

- [Type System Mastery](#type-system-mastery)
    - [1. Pendahuluan](#1-pendahuluan)
    - [2. Dart: Strong \& Statically Typed (dengan Type Inference)](#2-dart-strong--statically-typed-dengan-type-inference)
      - [a. Apa Itu Strong Type?](#a-apa-itu-strong-type)
      - [b. Apa Itu Statically Typed?](#b-apa-itu-statically-typed)
      - [c. Apa Itu Type Inference?](#c-apa-itu-type-inference)
    - [3. Dasar-Dasar Tipe Data (Tinjauan Cepat)](#3-dasar-dasar-tipe-data-tinjauan-cepat)
      - [`num`, `int`, `double`](#num-int-double)
      - [`String`](#string)
      - [`bool`](#bool)
      - [`List`, `Set`, `Map`](#list-set-map)
      - [`Object`, `dynamic`, `null`](#object-dynamic-null)
    - [4. Null Safety: Pilar Penting Type System Dart](#4-null-safety-pilar-penting-type-system-dart)
      - [a. Non-nullable by Default](#a-non-nullable-by-default)
      - [b. Nullable Types (`?`)](#b-nullable-types-)
      - [c. Type Promotion](#c-type-promotion)
      - [d. Null Assertion Operator (`!`)](#d-null-assertion-operator-)
      - [e. Late Variables](#e-late-variables)
    - [5. Type Casting dan Type Checking](#5-type-casting-dan-type-checking)
      - [a. Operator `is`](#a-operator-is)
      - [b. Operator `is!`](#b-operator-is)
      - [c. Operator `as` (Type Cast)](#c-operator-as-type-cast)
    - [6. `dynamic` vs `Object?` vs `Object`](#6-dynamic-vs-object-vs-object)
      - [`dynamic`](#dynamic)
      - [`Object?`](#object)
      - [`Object`](#object-1)
    - [7. `typedef` (Type Aliases)](#7-typedef-type-aliases)
    - [8. Generics: Tipe yang Fleksibel](#8-generics-tipe-yang-fleksibel)
      - [a. Mengapa Generics?](#a-mengapa-generics)
      - [b. Sintaks Generics](#b-sintaks-generics)
      - [c. Type Bounds (`<T extends SomeType>`)](#c-type-bounds-t-extends-sometype)
    - [9. Efek Samping Type System yang Kuat](#9-efek-samping-type-system-yang-kuat)
      - [a. Keamanan Kode](#a-keamanan-kode)
      - [b. Bantuan IDE (Autocompletion, Refactoring)](#b-bantuan-ide-autocompletion-refactoring)
      - [c. Deteksi Bug Lebih Awal](#c-deteksi-bug-lebih-awal)
      - [d. Dokumentasi Kode yang Lebih Baik](#d-dokumentasi-kode-yang-lebih-baik)
    - [10. Ringkasan](#10-ringkasan)

</details>

---

### 1\. Pendahuluan

Sistem tipe (Type System) adalah kumpulan aturan yang menetapkan bagaimana sebuah bahasa pemrograman mengkategorikan dan mengelola nilai-nilai. Dart memiliki sistem tipe yang **kuat (strong)** dan **statis (static)**, yang diperkuat dengan **null safety**. Menguasai sistem tipe ini adalah kunci untuk menulis kode Dart yang efisien, mudah dirawat, dan bebas bug.

Sistem tipe yang kuat membantu mencegah kesalahan _runtime_ dengan menangkap potensi masalah pada waktu kompilasi. Ini juga memberikan IDE (Integrated Development Environment) informasi yang kaya untuk _autocompletion_, _refactoring_, dan _debugging_.

---

### 2\. Dart: Strong & Statically Typed (dengan Type Inference)

#### a. Apa Itu Strong Type?

- **Strongly Typed** berarti bahwa tipe data suatu variabel sudah **ditetapkan dan tidak dapat diubah** setelah diinisialisasi. Anda tidak bisa secara implisit menugaskan nilai dari satu tipe ke variabel dengan tipe lain yang tidak kompatibel.
- Misalnya, Anda tidak bisa langsung menugaskan `String` ke variabel `int` tanpa konversi eksplisit.
  ```dart
  int count = 10;
  // count = "twenty"; // ERROR: A value of type 'String' can't be assigned to a variable of type 'int'.
  ```

#### b. Apa Itu Statically Typed?

- **Statically Typed** berarti pemeriksaan tipe dilakukan pada **waktu kompilasi**, sebelum program berjalan. Kompiler akan menemukan dan melaporkan _type mismatch_ sebagai _error_ atau _warning_.
- Ini berbeda dengan bahasa _dynamically typed_ (seperti JavaScript tanpa TypeScript) di mana pemeriksaan tipe terjadi pada _runtime_.
- Manfaatnya adalah bug terkait tipe dapat terdeteksi lebih awal, yang mengarah pada pengembangan yang lebih cepat dan kode yang lebih stabil.

#### c. Apa Itu Type Inference?

- Meskipun Dart adalah _statically typed_, Anda tidak selalu harus secara eksplisit menuliskan tipe data. Dart memiliki kemampuan **Type Inference** yang kuat.
- Kompiler dapat secara otomatis menyimpulkan tipe data variabel berdasarkan nilai awal yang Anda berikan.

  ```dart
  var nama = "Alice"; // Dart menginferensi 'nama' sebagai String
  var umur = 30;     // Dart menginferensi 'umur' sebagai int
  var isActive = true; // Dart menginferensi 'isActive' sebagai bool

  // Setelah diinferensi, tipenya tetap tidak bisa diubah
  // nama = 123; // ERROR
  ```

- Penggunaan `var` direkomendasikan ketika tipe datanya jelas dari inisialisasinya, membuat kode lebih ringkas tanpa mengorbankan keamanan tipe.

---

### 3\. Dasar-Dasar Tipe Data (Tinjauan Cepat)

Dart memiliki set tipe data bawaan yang kaya:

#### `num`, `int`, `double`

- `num`: Superkelas dari `int` dan `double`. Bisa menyimpan bilangan bulat atau desimal.
- `int`: Bilangan bulat (integer).
- `double`: Bilangan _floating-point_ (desimal).

#### `String`

- Urutan karakter (teks). Bersifat _immutable_.

#### `bool`

- Nilai boolean: `true` atau `false`.

#### `List`, `Set`, `Map`

- **`List<T>`**: Koleksi terurut dari objek dengan tipe `T`. Mendukung duplikat.
  ```dart
  List<int> numbers = [1, 2, 3];
  List<String> names = ['Alice', 'Bob'];
  ```
- **`Set<T>`**: Koleksi tidak terurut dari objek unik dengan tipe `T`. Tidak mendukung duplikat.
  ```dart
  Set<String> uniqueColors = {'red', 'green', 'blue'};
  ```
- **`Map<K, V>`**: Koleksi pasangan kunci-nilai, di mana kunci bertipe `K` dan nilai bertipe `V`.
  ```dart
  Map<String, int> ages = {'Alice': 30, 'Bob': 25};
  ```

#### `Object`, `dynamic`, `null`

- **`Object`**: Superkelas dari semua tipe data di Dart (kecuali `null`).
- **`dynamic`**: Tipe yang mematikan pemeriksaan tipe pada waktu kompilasi. Variabel `dynamic` dapat menyimpan nilai apa pun dan metode apa pun dapat dipanggil padanya. Ini adalah pilihan yang _powerful_ tetapi berbahaya karena bug terkait tipe hanya akan muncul pada _runtime_.
- **`null`**: Nilai khusus yang menunjukkan tidak adanya nilai.

---

### 4\. Null Safety: Pilar Penting Type System Dart

Null Safety, diperkenalkan di Dart 2.12, adalah fitur revolusioner yang menghilangkan _Null Reference Exceptions_ (atau `NoSuchMethodError` pada `null` di Dart) pada _runtime_ dengan menjadikan `nullability` sebagai bagian dari sistem tipe.

#### a. Non-nullable by Default

- Secara _default_, semua tipe di Dart adalah **non-nullable**. Artinya, variabel non-nullable **tidak boleh** berisi nilai `null`.
  ```dart
  String name = "Alice";
  // name = null; // ERROR: A value of type 'Null' can't be assigned to a variable of type 'String'.
  ```
- Ini secara drastis mengurangi _NullPointerExceptions_ yang sering terjadi di banyak bahasa.

#### b. Nullable Types (`?`)

- Jika Anda memang ingin sebuah variabel bisa berisi `null`, Anda harus secara eksplisit mendeklarasikannya sebagai **nullable type** dengan menambahkan tanda tanya (`?`) setelah tipe data.
  ```dart
  String? optionalName; // Bisa null
  optionalName = "Bob";
  optionalName = null; // OK
  ```
- Kompiler akan mewajibkan Anda untuk memeriksa `null` sebelum menggunakan variabel nullable.
  ```dart
  String? greeting;
  // print(greeting.length); // ERROR: The property 'length' can't be unconditionally accessed because the receiver can be 'null'.
  if (greeting != null) {
    print(greeting.length); // OK, karena sudah diperiksa
  }
  ```

#### c. Type Promotion

- Dart memiliki fitur **Type Promotion** yang cerdas. Jika Anda memeriksa variabel nullable dan memastikan bahwa itu bukan `null` dalam sebuah _scope_ (misalnya, di dalam blok `if`), kompiler akan secara otomatis "mempromosikan" tipenya dari nullable ke non-nullable dalam _scope_ tersebut.

  ```dart
  String? message = getMessage(); // Asumsi getMessage() bisa mengembalikan null

  if (message != null) {
    // Di sini, 'message' dipromosikan dari String? menjadi String
    print(message.length); // OK
  }
  ```

#### d. Null Assertion Operator (`!`)

- Jika Anda (sebagai _developer_) **yakin** bahwa variabel nullable tidak akan pernah `null` pada titik tertentu, Anda bisa menggunakan **Null Assertion Operator** (`!`) setelah variabel. Ini memberitahu kompiler untuk "percaya" pada Anda.

  ```dart
  String? name = someFunctionThatReturnsStringOrNull();
  // name = "Budi"; // Anggaplah Anda yakin name sudah diinisialisasi di sini

  print(name!.length); // Hati-hati! Jika name ternyata null, ini akan melempar runtime error (LateInitializationError)
  ```

- Gunakan operator ini dengan hati-hati dan hanya ketika Anda benar-benar yakin, karena ini bisa mengembalikan _runtime error_ jika asumsi Anda salah.

#### e. Late Variables

- Untuk variabel non-nullable yang nilainya akan diinisialisasi nanti (misalnya, di `initState()` Flutter atau metode _setup_), gunakan kata kunci `late`.

  ```dart
  late String description;

  void initialize() {
    description = "Product description";
  }

  void main() {
    // print(description); // ERROR: LateInitializationError (jika diakses sebelum initialize)
    initialize();
    print(description); // OK
  }
  ```

- Seperti `!`, `late` juga memberikan jaminan kepada kompiler. Jika Anda mengakses `late` variabel sebelum diinisialisasi, itu akan melempar `LateInitializationError` pada _runtime_.

---

### 5\. Type Casting dan Type Checking

#### a. Operator `is`

- Digunakan untuk memeriksa apakah suatu objek adalah instance dari tipe tertentu (atau subtipe-nya). Mengembalikan `true` atau `false`.

- Seringkali digunakan bersama dengan _type promotion_.

  ```dart
  void describe(Object obj) {
    if (obj is String) {
      // obj dipromosikan menjadi String di sini
      print("Ini adalah string dengan panjang: ${obj.length}");
    } else if (obj is int) {
      // obj dipromosikan menjadi int di sini
      print("Ini adalah integer dengan nilai: ${obj + 10}");
    } else {
      print("Ini adalah tipe lain.");
    }
  }

  void main() {
    describe("Hello"); // Output: Ini adalah string dengan panjang: 5
    describe(123);     // Output: Ini adalah integer dengan nilai: 133
    describe(true);    // Output: Ini adalah tipe lain.
  }
  ```

#### b. Operator `is!`

- Kebalikan dari `is`. Memeriksa apakah suatu objek _bukan_ instance dari tipe tertentu.

  ```dart
  Object data = 123;
  if (data is! String) {
    print("Data bukan string."); // Output: Data bukan string.
  }
  ```

#### c. Operator `as` (Type Cast)

- Digunakan untuk secara eksplisit "meng-_cast_" (mengubah tipe) suatu objek ke tipe lain.
- **Hati-hati\!** Jika objek bukan instance dari tipe yang Anda _cast_ ke dalamnya, ini akan melempar `CastError` (_runtime error_).
- Gunakan `as` hanya ketika Anda **sangat yakin** bahwa _cast_ akan berhasil.

  ```dart
  Object value = "Dart";
  String text = value as String; // Aman karena 'value' memang String
  print(text.toUpperCase()); // Output: DART

  Object number = 123;
  // String anotherText = number as String; // ERROR: _CastError (type 'int' is not a subtype of type 'String' in type cast)
  ```

- Lebih aman menggunakan `is` dan _type promotion_ atau `tryCast` (jika ada di konteks tertentu) daripada `as` secara membabi buta.

---

### 6\. `dynamic` vs `Object?` vs `Object`

Ini adalah tiga tipe yang sering membingungkan, terutama bagi pemula:

#### `dynamic`

- **Mematikan pemeriksaan tipe pada waktu kompilasi.** Anda dapat menugaskan nilai apa pun ke `dynamic` dan memanggil metode apa pun padanya.
- Keamanan tipe hanya diberlakukan pada **runtime**. Ini meningkatkan risiko _runtime errors_ jika Anda memanggil metode yang tidak ada.
- Harus digunakan dengan sangat hati-hati dan hanya ketika fleksibilitas _dynamic_ benar-benar diperlukan.

  ```dart
  dynamic myValue = 10;
  myValue = "Hello"; // OK
  myValue = true;    // OK

  myValue.someMethod(); // Ini akan lolos compile-time, tapi melempar NoSuchMethodError di runtime jika myValue tidak punya someMethod
  ```

#### `Object?`

- Ini adalah tipe **nullable** dari superkelas dasar `Object`.
- Variabel `Object?` dapat berisi **nilai apa pun** (karena semua tipe di Dart adalah subtipe dari `Object`) **atau `null`**.
- **Pemeriksaan tipe masih berlaku pada waktu kompilasi.** Anda harus memeriksa `null` sebelum mengakses properti atau metode, dan Anda harus menggunakan _type casting_ atau _type promotion_ untuk menggunakan nilai sebagai tipe spesifik.
- Lebih aman daripada `dynamic` karena mempertahankan keamanan tipe pada waktu kompilasi.

  ```dart
  Object? myObject = 10;
  myObject = "Hello"; // OK
  myObject = null;    // OK

  // myObject.length; // ERROR: Bisa null
  if (myObject is String) {
    print(myObject.length); // OK
  }
  ```

#### `Object`

- Ini adalah superkelas dari semua tipe data **non-nullable** di Dart.
- Variabel `Object` dapat berisi **nilai apa pun kecuali `null`**.
- **Pemeriksaan tipe masih berlaku pada waktu kompilasi.** Mirip dengan `Object?` tetapi tanpa kemungkinan `null`.
  ```dart
  Object data = 123;
  // data = null; // ERROR
  // data.length; // ERROR: Object tidak punya properti length, perlu cast
  if (data is int) {
    print(data + 10); // OK
  }
  ```

**Kesimpulan:** Selalu prioritaskan tipe yang lebih spesifik (`String`, `int`, dll.) \> `Object?` \> `Object` \> `dynamic`. Gunakan `dynamic` hanya jika tidak ada pilihan lain.

---

### 7\. `typedef` (Type Aliases)

`typedef` memungkinkan Anda untuk membuat alias (nama alternatif) untuk tipe data yang kompleks atau panjang. Ini meningkatkan keterbacaan kode.

- Sering digunakan untuk fungsi atau tipe koleksi yang kompleks.

  ```dart
  // Sebelum typedef
  void processUser(Map<String, Object> userData) { /* ... */ }

  // Dengan typedef
  typedef UserData = Map<String, Object>;

  void processUserTyped(UserData userData) { /* ... */ }

  // Contoh lain untuk alias fungsi
  typedef IntOperation = int Function(int a, int b);

  int add(int a, int b) => a + b;
  int subtract(int a, int b) => a - b;

  void main() {
    IntOperation myAddition = add;
    print(myAddition(5, 3)); // Output: 8

    IntOperation mySubtraction = subtract;
    print(mySubtraction(10, 4)); // Output: 6
  }
  ```

---

### 8\. Generics: Tipe yang Fleksibel

Generics memungkinkan Anda menulis kode yang bekerja dengan berbagai tipe data sambil tetap mempertahankan keamanan tipe.

#### a. Mengapa Generics?

- **Keamanan Tipe:** Mencegah kesalahan _runtime_ dengan memastikan bahwa koleksi atau fungsi hanya beroperasi pada tipe data yang diharapkan.
- **Reusabilitas Kode:** Anda dapat menulis satu fungsi atau kelas yang dapat digunakan kembali untuk beberapa tipe data tanpa perlu duplikasi kode.

#### b. Sintaks Generics

Generics menggunakan kurung sudut (`< >`) untuk menentukan parameter tipe.

```dart
// Contoh List<T>
List<int> numbers = [1, 2, 3];
List<String> names = ['Alice', 'Bob'];

// Contoh fungsi generic
T getFirstElement<T>(List<T> list) {
  return list[0];
}

void main() {
  print(getFirstElement<int>(numbers)); // Output: 1
  print(getFirstElement<String>(names)); // Output: Alice

  // Type inference juga bekerja di sini
  print(getFirstElement(['X', 'Y', 'Z'])); // Inferred as List<String>
}
```

#### c. Type Bounds (`<T extends SomeType>`)

Anda dapat membatasi jenis tipe yang dapat digunakan dengan generic menggunakan `extends`. Ini berarti `T` harus berupa `SomeType` atau subtipe dari `SomeType`.

```dart
// Fungsi yang hanya menerima List dari tipe numerik
num sumList<T extends num>(List<T> list) {
  num total = 0;
  for (T item in list) {
    total += item;
  }
  return total;
}

void main() {
  List<int> intList = [1, 2, 3];
  List<double> doubleList = [1.1, 2.2, 3.3];
  // List<String> stringList = ["a", "b"]; // ERROR: Type 'String' doesn't satisfy the 'num' bound.

  print(sumList(intList));    // Output: 6
  print(sumList(doubleList)); // Output: 6.6
}
```

---

### 9\. Efek Samping Type System yang Kuat

Menguasai dan memanfaatkan sistem tipe Dart memiliki banyak manfaat:

#### a. Keamanan Kode

- Mengurangi _runtime errors_ yang berkaitan dengan tipe, membuat aplikasi lebih stabil.
- Menangkap bug lebih awal dalam siklus pengembangan.

#### b. Bantuan IDE (Autocompletion, Refactoring)

- IDE seperti VS Code atau Android Studio (dengan plugin Dart/Flutter) dapat memberikan _autocompletion_ yang akurat, peringatan kesalahan, dan kemampuan _refactoring_ yang canggih karena mereka "memahami" tipe data.

#### c. Deteksi Bug Lebih Awal

- Kompiler bertindak sebagai penjaga gerbang, memastikan bahwa kode Anda memenuhi aturan tipe sebelum Anda bahkan menjalankannya.

#### d. Dokumentasi Kode yang Lebih Baik

- Deklarasi tipe yang eksplisit berfungsi sebagai bentuk dokumentasi mandiri, menjelaskan ekspektasi input dan output fungsi serta jenis data yang disimpan variabel.

---

### 10\. Ringkasan

**Type System Mastery** di Dart adalah fondasi untuk menulis kode yang berkualitas tinggi. Dart adalah bahasa yang **kuat (strong)** dan **statis (static)**, yang berarti tipe data diperiksa pada waktu kompilasi. Dengan fitur **Type Inference** yang cerdas, Anda bisa menulis kode yang ringkas tanpa kehilangan keamanan tipe.

**Null Safety** adalah tambahan yang krusial, membuat variabel non-nullable secara _default_ dan memaksa pemeriksaan eksplisit untuk tipe nullable, secara drastis mengurangi _Null Reference Exceptions_.

Memahami `dynamic` vs `Object?` vs `Object`, cara kerja `typedef`, dan kekuatan **Generics** adalah kunci untuk memanfaatkan sepenuhnya sistem tipe Dart. Dengan menguasai aspek-aspek ini, Anda akan menulis kode yang lebih aman, lebih mudah dipelihara, dan lebih efisien.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-16/README.md
[selanjutnya]: ../bagian-18/README.md
[0]:../README.md