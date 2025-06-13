[Ke Bawah](#sumber-referensi-lengkap)

# [Keywords][0]

### Pendahuluan: Mengapa Keywords Penting?

Dalam bahasa pemrograman, **keywords (kata kunci)** adalah kata-kata yang memiliki makna khusus dan telah dicadangkan oleh bahasa tersebut untuk tujuan tertentu. Mereka tidak dapat digunakan sebagai nama variabel, fungsi, kelas, atau pengidentifikasi lainnya. Keywords adalah fondasi sintaksis suatu bahasa, yang memungkinkan kompiler (atau interpreter) untuk memahami struktur dan niat kode Anda. Tanpa keywords, kode akan menjadi ambigu dan tidak dapat diproses.

Dart, sebagai bahasa yang berorientasi objek, berprinsip asinkron, dan dirancang untuk pengembangan multi-platform, memiliki seperangkat keywords yang kaya untuk mendukung fitur-fitur ini.

### Kategori Keywords di Dart

Dart membagi keywordsnya menjadi beberapa kategori berdasarkan fungsinya:

1.  **Keywords yang Dicadangkan (Reserved Keywords):** Kata-kata ini memiliki makna khusus dan tidak dapat digunakan sebagai pengidentifikasi.
2.  **Keywords yang Dibangun dalam Konteks (Contextual Keywords):** Kata-kata ini memiliki makna khusus hanya dalam konteks tertentu. Di luar konteks tersebut, mereka dapat digunakan sebagai pengidentifikasi.
3.  **Keywords Pembangun (Built-in Identifiers):** Ini adalah kata-kata yang dapat digunakan sebagai pengidentifikasi, tetapi juga memiliki makna khusus. Namun, disarankan untuk tidak menggunakannya sebagai pengidentifikasi untuk menghindari kebingungan.

Mari kita bahas masing-masing secara rinci.

---

### 1\. Reserved Keywords (Keywords yang Dicadangkan)

Ini adalah inti dari keywords Dart. Anda _tidak boleh_ menggunakannya untuk nama variabel, fungsi, kelas, atau pengidentifikasi lainnya.

- **`abstract`**: Digunakan untuk mendeklarasikan kelas abstrak. Kelas abstrak tidak dapat diinisialisasi langsung dan harus diwarisi oleh kelas lain. Mereka dapat memiliki metode abstrak (tanpa implementasi) yang harus diimplementasikan oleh subkelas.

  - Contoh:

    ```dart
    abstract class Shape {
      void draw(); // Metode abstrak
    }

    class Circle extends Shape {
      @override
      void draw() {
        print("Drawing a circle");
      }
    }
    ```

- **`as`**:

  - Digunakan untuk casting tipe data (type casting). Mengonversi objek dari satu tipe ke tipe lainnya. Jika casting gagal, akan melempar `CastError`.
  - Digunakan dalam `import` untuk memberi alias pada prefiks library.
  - Contoh:

    ```dart
    // Type casting
    Object obj = "Hello";
    String str = obj as String;

    // Import aliasing
    import 'dart:math' as math;
    double pi = math.pi;
    ```

- **`assert`**: Digunakan untuk pengembangan. Memeriksa apakah suatu kondisi benar. Jika salah, `assert` akan melemparkan `AssertionError`. Hanya aktif dalam mode debug.

  - Contoh:
    ```dart
    void checkPositive(int number) {
      assert(number > 0, 'Number must be positive');
      print('Number is positive: $number');
    }
    ```

- **`async`**: Menandai sebuah fungsi sebagai fungsi asinkron, yang berarti fungsi tersebut dapat melakukan operasi yang mungkin memakan waktu tanpa memblokir eksekusi program. Fungsi `async` selalu mengembalikan `Future`.

  - Contoh:
    ```dart
    Future<String> fetchData() async {
      await Future.delayed(Duration(seconds: 2));
      return "Data fetched!";
    }
    ```

- **`await`**: Digunakan di dalam fungsi `async` untuk menunggu penyelesaian `Future`. Eksekusi fungsi `async` akan berhenti sementara sampai `Future` yang ditunggu selesai, tanpa memblokir _main thread_.

  - Contoh: (lihat `async` di atas)

- **`break`**: Menghentikan eksekusi loop (`for`, `while`, `do-while`) atau `switch` statement dan melanjutkan ke statement setelahnya.

  - Contoh:
    ```dart
    for (int i = 0; i < 5; i++) {
      if (i == 3) break;
      print(i); // Output: 0, 1, 2
    }
    ```

- **`case`**: Digunakan dalam `switch` statement untuk mendefinisikan blok kode yang akan dieksekusi jika nilai `switch` cocok dengan nilai `case`.

  - Contoh:
    ```dart
    var grade = 'A';
    switch (grade) {
      case 'A':
        print('Excellent!');
        break;
      case 'B':
        print('Good!');
        break;
      default:
        print('Needs improvement.');
    }
    ```

- **`catch`**: Digunakan dalam blok `try-catch` untuk menangkap pengecualian (exceptions) yang terjadi di dalam blok `try`.

  - Contoh:
    ```dart
    try {
      throw Exception("Something went wrong");
    } catch (e) {
      print("Caught error: $e");
    }
    ```

- **`class`**: Digunakan untuk mendeklarasikan sebuah kelas, yang merupakan blueprint untuk membuat objek.

  - Contoh:
    ```dart
    class Person {
      String name;
      Person(this.name);
    }
    ```

- **`const`**:

  - Digunakan untuk mendeklarasikan variabel yang nilainya adalah compile-time constant (konstanta kompilasi-waktu). Nilainya harus diketahui saat kompilasi dan tidak dapat diubah.
  - Digunakan untuk membuat instance objek yang bersifat konstan pada compile-time.
  - Contoh:
    ```dart
    const double PI = 3.14159;
    const List<int> numbers = [1, 2, 3]; // Konstanta List
    ```

- **`continue`**: Melewatkan sisa iterasi saat ini dalam loop dan melanjutkan ke iterasi berikutnya.

  - Contoh:
    ```dart
    for (int i = 0; i < 5; i++) {
      if (i % 2 == 0) continue; // Melewatkan angka genap
      print(i); // Output: 1, 3
    }
    ```

- **`default`**: Digunakan dalam `switch` statement untuk mendefinisikan blok kode yang akan dieksekusi jika tidak ada `case` yang cocok.

  - Contoh: (lihat `case` di atas)

- **`deferred`**: Digunakan dalam `import` untuk menunda pemuatan library hingga dibutuhkan (lazy loading). Berguna untuk aplikasi besar yang ingin menghemat memori atau mengurangi waktu startup awal.

  - Contoh:

    ```dart
    import 'package:mylib/mylib.dart' deferred as mylib;

    Future<void> loadLibrary() async {
      await mylib.loadLibrary();
      mylib.doSomething();
    }
    ```

- **`do`**: Bagian dari loop `do-while`, yang menjamin blok kode dieksekusi setidaknya sekali sebelum kondisi dievaluasi.

  - Contoh:
    ```dart
    int i = 0;
    do {
      print(i);
      i++;
    } while (i < 3); // Output: 0, 1, 2
    ```

- **`dynamic`**: Tipe data yang memungkinkan variabel untuk menampung nilai dari tipe apa pun. Dart akan melakukan pemeriksaan tipe saat runtime. Menggunakan `dynamic` mengurangi keamanan tipe.

  - Contoh:
    ```dart
    dynamic x = "Hello";
    x = 123;
    ```

- **`else`**: Digunakan dalam `if-else` statement untuk mendefinisikan blok kode yang akan dieksekusi jika kondisi `if` bernilai salah.

  - Contoh:
    ```dart
    int age = 17;
    if (age >= 18) {
      print("Adult");
    } else {
      print("Minor");
    }
    ```

- **`enum`**: Digunakan untuk mendeklarasikan enumerasi (enum), kumpulan nilai konstan bernama. Membantu membuat kode lebih mudah dibaca dan mengurangi kesalahan.

  - Contoh:
    ```dart
    enum Status {
      pending,
      approved,
      rejected,
    }
    Status currentStatus = Status.pending;
    ```

- **`export`**: Digunakan untuk mengekspos isi dari satu atau lebih library dari suatu file ke file lain. Berguna untuk membuat "barrel file" yang mengekspor banyak file lainnya.

  - Contoh:
    ```dart
    // in lib/my_library.dart
    export 'src/file1.dart';
    export 'src/file2.dart';
    ```

- **`extends`**: Digunakan untuk menunjukkan bahwa sebuah kelas mewarisi dari kelas lain (inheritance).

  - Contoh:
    ```dart
    class Dog extends Animal {
      // ...
    }
    ```

- **`extension`**: Digunakan untuk menambahkan fungsionalitas baru ke kelas yang sudah ada tanpa memodifikasi kode sumber aslinya.

  - Contoh:
    ```dart
    extension StringExtension on String {
      String capitalize() {
        return "${this[0].toUpperCase()}${substring(1)}";
      }
    }
    "hello".capitalize(); // Output: Hello
    ```

- **`external`**: Digunakan untuk mendeklarasikan fungsi atau variabel yang implementasinya disediakan di luar Dart (misalnya, di C/C++ melalui FFI atau dalam platform-specific code di Flutter).

  - Contoh (FFI):
    ```dart
    import 'dart:ffi';
    final dylib = DynamicLibrary.open('mylib.so');
    typedef NativeAdd = Int32 Function(Int32 a, Int32 b);
    typedef DartAdd = int Function(int a, int b);
    final add = dylib.lookupFunction<NativeAdd, DartAdd>('add');
    ```

- **`factory`**: Digunakan untuk membuat konstruktor yang tidak selalu membuat instance baru dari kelas yang sama. Bisa mengembalikan instance yang sudah ada, atau instance dari subkelas.

  - Contoh:
    ```dart
    class Logger {
      static final Map<String, Logger> _cache = <String, Logger>{};
      factory Logger(String name) {
        if (_cache.containsKey(name)) {
          return _cache[name]!;
        }
        final logger = Logger._internal(name);
        _cache[name] = logger;
        return logger;
      }
      Logger._internal(this.name);
      final String name;
    }
    ```

- **`false`**: Literal boolean untuk nilai kebenaran salah.

  - Contoh: `bool isActive = false;`

- **`final`**: Digunakan untuk mendeklarasikan variabel yang hanya dapat diinisialisasi sekali. Nilainya ditetapkan saat runtime dan tidak dapat diubah setelahnya.

  - Contoh:
    ```dart
    final String name = "Alice";
    // name = "Bob"; // Error: A final variable can only be set once.
    ```

- **`finally`**: Digunakan dalam blok `try-catch-finally`. Blok `finally` akan selalu dieksekusi, terlepas dari apakah pengecualian terjadi atau tidak.

  - Contoh:
    ```dart
    try {
      // Some code
    } catch (e) {
      // Handle error
    } finally {
      print("This always runs.");
    }
    ```

- **`for`**: Digunakan untuk membuat loop iterasi.

  - Contoh:
    ```dart
    for (int i = 0; i < 5; i++) {
      print(i);
    }
    ```

- **`Function`**: Tipe data yang merepresentasikan fungsi.

  - Contoh:
    ```dart
    void myCallback(Function callback) {
      callback();
    }
    myCallback(() => print("Hello from callback"));
    ```

- **`get`**: Digunakan untuk mendeklarasikan _getter_ (accessor method) yang memungkinkan Anda membaca nilai properti seolah-olah itu adalah variabel.

  - Contoh:
    ```dart
    class MyClass {
      int _value = 10;
      int get value => _value;
    }
    ```

- **`hide`**: Digunakan dalam `import` untuk menyembunyikan bagian tertentu dari library yang diimpor.

  - Contoh:
    ```dart
    import 'dart:math' hide pi; // pi tidak akan tersedia
    ```

- **`if`**: Digunakan untuk membuat statement kondisional.

  - Contoh: (lihat `else` di atas)

- **`implements`**: Digunakan untuk menunjukkan bahwa sebuah kelas mengimplementasikan satu atau lebih antarmuka (interfaces). Di Dart, semua kelas secara implisit mendefinisikan sebuah interface.

  - Contoh:
    ```dart
    class Flyer {
      void fly() {}
    }
    class Bird implements Flyer {
      @override
      void fly() {
        print("Bird is flying");
      }
    }
    ```

- **`import`**: Digunakan untuk mengimpor library lain ke dalam file Anda.

  - Contoh:
    ```dart
    import 'dart:io';
    ```

- **`in`**: Digunakan dalam `for-in` loop (iterasi koleksi).

  - Contoh:
    ```dart
    List<String> names = ['Alice', 'Bob'];
    for (var name in names) {
      print(name);
    }
    ```

- **`interface`**: **Ini bukan keyword yang digunakan secara langsung untuk mendeklarasikan interface di Dart.** Di Dart, setiap kelas secara implisit mendefinisikan interface. Ketika Anda ingin mengimplementasikan perilaku suatu kelas, Anda menggunakan keyword `implements`. Keyword `interface` adalah reserved tetapi tidak digunakan secara sintaksis untuk mendeklarasikan interface seperti di Java.

- **`is`**: Digunakan untuk memeriksa apakah suatu objek adalah instance dari tipe tertentu (type checking).

  - Contoh:
    ```dart
    Object obj = "Hello";
    if (obj is String) {
      print("obj is a String");
    }
    ```

- **`late`**: Digunakan untuk mendeklarasikan variabel yang akan diinisialisasi nanti, tetapi sebelum digunakan. Ini memungkinkan variabel non-nullable untuk tidak diinisialisasi pada saat deklarasi.

  - Contoh:
    ```dart
    late String description;
    void setup() {
      description = 'A very important description.';
    }
    ```

- **`library`**: Digunakan untuk mendeklarasikan nama library untuk suatu file.

  - Contoh:
    ```dart
    library my_package.utils; // Di bagian atas file
    ```

- **`mixin`**: Digunakan untuk mendeklarasikan mixin, yang merupakan cara untuk menggunakan kembali kode kelas secara horizontal di hierarki kelas. Mixin dapat diimplementasikan oleh kelas lain menggunakan `with`.

  - Contoh:
    ```dart
    mixin Walk {
      void walk() {
        print("Walking!");
      }
    }
    class Human with Walk {
      // Human sekarang memiliki metode walk()
    }
    ```

- **`new`**: Digunakan untuk membuat instance baru dari sebuah kelas. Di Dart 2.0+, penggunaan `new` bersifat opsional dan jarang digunakan karena kompiler dapat menyimpulkannya.

  - Contoh:
    ```dart
    // class Person { String name; Person(this.name); }
    Person p1 = new Person("Alice"); // `new` opsional
    Person p2 = Person("Bob");
    ```

- **`null`**: Literal untuk nilai tidak ada atau kosong.

  - Contoh: `String? name = null;`

- **`on`**: Digunakan dalam `try-on-catch` untuk menangani pengecualian dari tipe tertentu.

  - Contoh:
    ```dart
    try {
      int.parse('abc');
    } on FormatException catch (e) {
      print('Invalid format: $e');
    }
    ```

- **`operator`**: Digunakan untuk mengoverload operator (seperti `+`, `-`, `*`, `==`) untuk sebuah kelas.

  - Contoh:
    ```dart
    class Vector {
      int x, y;
      Vector(this.x, this.y);
      Vector operator +(Vector other) => Vector(x + other.x, y + other.y);
    }
    Vector v1 = Vector(1, 2);
    Vector v2 = Vector(3, 4);
    Vector v3 = v1 + v2; // Output: Vector(4, 6)
    ```

- **`part`**: Digunakan bersama dengan `part of` untuk membagi sebuah library menjadi beberapa file. Berguna untuk mengorganisir kode tanpa memecah sebuah library logis menjadi beberapa library fisik.

  - Contoh:

    ```dart
    // in main_library.dart
    library my_library;
    part 'part_file.dart';

    // in part_file.dart
    part of my_library;
    class Helper { /* ... */ }
    ```

- **`rethrow`**: Digunakan di dalam blok `catch` untuk melemparkan kembali pengecualian yang sama yang baru saja ditangkap. Ini mempertahankan stack trace asli.

  - Contoh:
    ```dart
    try {
      throw Exception("Original error");
    } catch (e) {
      print("Handling error: $e");
      rethrow; // Melemparkan kembali pengecualian yang sama
    }
    ```

- **`return`**: Mengakhiri eksekusi fungsi dan mengembalikan nilai (jika ada) kepada pemanggil.

  - Contoh:
    ```dart
    int add(int a, int b) {
      return a + b;
    }
    ```

- **`set`**: Digunakan untuk mendeklarasikan _setter_ (mutator method) yang memungkinkan Anda menetapkan nilai properti seolah-olah itu adalah variabel.

  - Contoh:
    ```dart
    class MyClass {
      int _value = 0;
      set value(int newValue) {
        if (newValue >= 0) {
          _value = newValue;
        }
      }
    }
    ```

- **`show`**: Digunakan dalam `import` untuk hanya mengimpor bagian tertentu dari library.

  - Contoh:
    ```dart
    import 'dart:math' show Random; // Hanya Random yang diimpor
    ```

- **`static`**: Digunakan untuk mendeklarasikan anggota (variabel atau metode) yang dimiliki oleh kelas itu sendiri, bukan oleh instance dari kelas. Dapat diakses langsung melalui nama kelas.

  - Contoh:
    ```dart
    class Calculator {
      static int add(int a, int b) {
        return a + b;
      }
    }
    int sum = Calculator.add(5, 3);
    ```

- **`super`**: Digunakan untuk merujuk pada kelas induk (superclass). Digunakan untuk memanggil konstruktor atau metode dari kelas induk.

  - Contoh:
    ```dart
    class Animal {
      void makeSound() { print("Generic sound"); }
    }
    class Dog extends Animal {
      @override
      void makeSound() {
        super.makeSound(); // Memanggil makeSound dari Animal
        print("Woof!");
      }
    }
    ```

- **`switch`**: Digunakan untuk membuat statement percabangan berdasarkan nilai variabel.

  - Contoh: (lihat `case` di atas)

- **`sync*`**: Digunakan untuk mendeklarasikan generator sinkron, yang mengembalikan `Iterable`. Menggunakan `yield` untuk menghasilkan nilai.

  - Contoh:
    ```dart
    Iterable<int> countUpTo(int limit) sync* {
      for (int i = 1; i <= limit; i++) {
        yield i;
      }
    }
    ```

- **`this`**: Mengacu pada instance kelas saat ini. Digunakan untuk mengatasi ambiguitas antara variabel instance dan parameter fungsi/konstruktor.

  - Contoh:
    ```dart
    class Person {
      String name;
      Person(this.name); // Ini adalah shorthand untuk this.name = name;
    }
    ```

- **`throw`**: Digunakan untuk melemparkan pengecualian (exception) secara eksplisit.

  - Contoh:
    ```dart
    void validateAge(int age) {
      if (age < 0) {
        throw ArgumentError("Age cannot be negative.");
      }
    }
    ```

- **`true`**: Literal boolean untuk nilai kebenaran benar.

  - Contoh: `bool isLoggedIn = true;`

- **`try`**: Digunakan dalam blok `try-catch` untuk mengelilingi kode yang mungkin melempar pengecualian.

  - Contoh: (lihat `catch` di atas)

- **`typedef`**: Digunakan untuk mendeklarasikan alias tipe fungsi (function type alias). Ini memungkinkan Anda untuk memberikan nama yang lebih pendek dan deskriptif untuk tipe fungsi yang kompleks.

  - Contoh:
    ```dart
    typedef MessageHandler = void Function(String message);
    void processMessage(String msg) { print(msg); }
    MessageHandler handler = processMessage;
    handler("Hello Dart!");
    ```

- **`var`**: Digunakan untuk mendeklarasikan variabel di mana tipe datanya akan disimpulkan (inferred) oleh Dart saat kompilasi.

  - Contoh:
    ```dart
    var count = 10; // count disimpulkan sebagai int
    var name = "Dart"; // name disimpulkan sebagai String
    ```

- **`void`**: Digunakan untuk menunjukkan bahwa suatu fungsi tidak mengembalikan nilai.

  - Contoh:
    ```dart
    void printMessage() {
      print("Hello!");
    }
    ```

- **`while`**: Digunakan untuk membuat loop yang terus berjalan selama kondisi tertentu bernilai benar.

  - Contoh:
    ```dart
    int count = 0;
    while (count < 3) {
      print(count);
      count++;
    }
    ```

- **`with`**: Digunakan untuk menerapkan satu atau lebih mixin ke sebuah kelas.

  - Contoh: (lihat `mixin` di atas)

- **`yield`**: Digunakan di dalam generator sinkron (`sync*`) atau asinkron (`async*`) untuk menghasilkan nilai ke `Iterable` atau `Stream`.

  - Contoh: (lihat `sync*` di atas dan `async*` di bawah)

- **`yield*`**: Digunakan di dalam generator sinkron (`sync*`) atau asinkron (`async*`) untuk menghasilkan semua nilai dari `Iterable` atau `Stream` lain.

  - Contoh:
    ```dart
    Iterable<int> allNumbers() sync* {
      yield* countUpTo(3); // Menghasilkan 1, 2, 3
      yield* [4, 5]; // Menghasilkan 4, 5
    }
    ```

---

### 2\. Contextual Keywords (Keywords yang Dibangun dalam Konteks)

Kata-kata ini memiliki makna khusus hanya dalam konteks tertentu. Di luar konteks tersebut, Anda _dapat_ menggunakannya sebagai pengidentifikasi. Namun, ini tidak disarankan untuk menjaga kejelasan kode.

- **`on`**: (Sudah dibahas di `try-on-catch`).

- **`_`** (underscore): Bukan keyword dalam arti tradisional, tetapi memiliki makna kontekstual khusus:

  - Sebagai prefiks untuk anggota kelas (`_variable`, `_method`) untuk menandakan bahwa mereka bersifat _private_ dalam konteks library.
  - Sebagai placeholder untuk variabel yang tidak digunakan dalam pola deklarasi atau parameter fungsi.
  - Contoh:

    ```dart
    // Private member
    class MyClass {
      int _privateVar = 0;
    }

    // Unused variable
    var list = [1, 2, 3];
    for (var _ in list) {
      print("Iterating");
    }
    ```

- **`async*`**: Menandai fungsi generator asinkron, yang mengembalikan `Stream`.

  - Contoh:
    ```dart
    Stream<int> countStream(int limit) async* {
      for (int i = 1; i <= limit; i++) {
        await Future.delayed(Duration(milliseconds: 100));
        yield i;
      }
    }
    ```

---

### 3\. Built-in Identifiers (Pembangun Pengidentifikasi)

Ini adalah kata-kata yang berfungsi sebagai nama kelas atau fungsi bawaan di Dart. Meskipun Anda _dapat_ menggunakannya sebagai pengidentifikasi Anda sendiri (misalnya, nama variabel), hal itu sangat tidak disarankan karena akan menyebabkan kebingungan dan berpotensi menimpa fungsionalitas bawaan.

- **`covariant`**: Digunakan dalam parameter metode atau properti untuk memungkinkan subtipe dari parameter untuk menggantikan supertipe. Ini umumnya digunakan dalam skenario di mana Anda ingin melonggarkan batasan tipe untuk parameter yang tidak dapat diubah (immutable).

  - Contoh:

    ```dart
    class Animal {
      void feed(covariant Animal food) {
        print('Feeding animal');
      }
    }

    class Cat extends Animal {
      @override
      void feed(covariant Cat food) { // Parameter `food` diizinkan menjadi Cat
        print('Feeding cat');
      }
    }
    ```

- **`extension`**: (Sudah dibahas di Reserved Keywords).

- **`external`**: (Sudah dibahas di Reserved Keywords).

- **`factory`**: (Sudah dibahas di Reserved Keywords).

- **`Function`**: (Sudah dibahas di Reserved Keywords).

- **`get`**: (Sudah dibahas di Reserved Keywords).

- **`implements`**: (Sudah dibahas di Reserved Keywords).

- **`late`**: (Sudah dibahas di Reserved Keywords).

- **`library`**: (Sudah dibahas di Reserved Keywords).

- **`mixin`**: (Sudah dibahas di Reserved Keywords).

- **`part`**: (Sudah dibahas di Reserved Keywords).

- **`set`**: (Sudah dibahas di Reserved Keywords).

- **`static`**: (Sudah dibahas di Reserved Keywords).

- **`typedef`**: (Sudah dibahas di Reserved Keywords).

- **`var`**: (Sudah dibahas di Reserved Keywords).

---

### Keywords yang Jarang atau Tidak Lagi Direkomendasikan (Depreciated/Less Common)

- **`native`**: Pernah digunakan untuk interop dengan kode platform (native). Sekarang sebagian besar digantikan oleh FFI (Foreign Function Interface) di Dart. Meskipun masih ada di beberapa konteks lama, untuk kode modern, FFI adalah pendekatan yang lebih disukai.

### Mengapa Dart Memiliki Banyak Keywords?

Dart memiliki banyak keywords karena dirancang untuk menjadi bahasa yang ekspresif dan kuat, mendukung berbagai paradigma pemrograman:

- **Orientasi Objek (OO):** Keywords seperti `class`, `extends`, `implements`, `abstract`, `super`, `this` adalah inti dari OO.
- **Asinkronitas:** `async`, `await`, `yield`, `yield*` adalah kunci untuk menangani operasi yang membutuhkan waktu (I/O, jaringan) tanpa memblokir UI.
- **Keamanan Null (Null Safety):** `late`, `?` (bukan keyword tetapi operator terkait null safety), `!` (operator null assertion) mendukung sistem tipe yang kuat untuk mencegah kesalahan null-pointer.
- **Pengelolaan Dependensi/Modularitas:** `import`, `export`, `library`, `part`, `deferred`, `show`, `hide` membantu dalam mengorganisir dan mengelola kode.
- **Fleksibilitas:** `dynamic`, `var`, `covariant` memberikan tingkat fleksibilitas yang berbeda dalam penanganan tipe.
- **Pengembangan Flutter:** Beberapa fitur, seperti `mixin` dan `extension`, sangat berguna dalam konteks pengembangan UI dengan Flutter.

### Sumber Referensi Lengkap

1.  **Dokumentasi Resmi Dart (Paling Utama dan Terpercaya):**

    - **Keywords:** [https://dart.dev/language/keywords](https://dart.dev/language/keywords)
    - **Tour of the Dart language:** [https://dart.dev/language](https://dart.dev/language) (Ini adalah sumber yang sangat bagus untuk memahami setiap fitur bahasa, termasuk bagaimana keywords digunakan.)
    - **Effective Dart:** [https://dart.dev/effective-dart](https://dart.dev/effective-dart) (Memberikan panduan tentang bagaimana menggunakan fitur bahasa, termasuk keywords, secara efektif.)

2.  **Buku-buku Dart/Flutter:**

    - "Dart in Action"
    - "Flutter in Action"
    - "Learning Dart"

3.  **Blog dan Artikel Komunitas:**

    - Medium, dev.to, GeeksforGeeks, dan berbagai blog teknis sering memiliki artikel mendetail tentang fitur Dart, termasuk keywords. Cari artikel dengan query seperti "Dart keywords explained", "Dart async await tutorial", "Dart mixins deep dive".
    - Contoh pencarian yang relevan: `site:medium.com dart keywords detailed explanation` atau `site:dev.to dart language features`

4.  **Repositori GitHub Proyek Dart/Flutter:**

    - Melihat bagaimana kode sumber proyek-proyek besar (seperti Flutter SDK itu sendiri atau paket-paket populer) menggunakan keywords dapat memberikan pemahaman praktis yang mendalam.

5.  **Stack Overflow:**

    - Untuk pertanyaan spesifik tentang penggunaan atau perbedaan antar keywords, Stack Overflow adalah sumber yang bagus untuk menemukan jawaban dan penjelasan dari komunitas.

Dengan memahami keywords ini, Anda akan memiliki pemahaman yang kuat tentang bagaimana Dart beroperasi dan bagaimana Anda dapat menulis kode yang efisien, aman, dan mudah dibaca. Ingatlah untuk selalu merujuk pada dokumentasi resmi sebagai sumber kebenaran utama.

#

> - **[Kembali][1]**
> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../../../../README.md
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
