# [Null Safety][0]

Null Safety adalah perubahan besar yang dirancang untuk membantu developer menghindari salah satu jenis bug paling umum dan mengganggu: _null reference errors_ (juga dikenal sebagai _NullPointerExceptions_ di bahasa lain). Ini bukan hanya tentang mencegah `null`, tetapi tentang membuat kode Anda lebih andal dan mudah dipahami.

<details>
  <summary>📃 Daftar Isi</summary>

- [Null Safety](#null-safety)
  - [1. Pendahuluan: Apa itu Null Safety?](#1-pendahuluan-apa-itu-null-safety)
    - [Masalah `null` di Masa Lalu (dan Mengapa Null Safety Penting)](#masalah-null-di-masa-lalu-dan-mengapa-null-safety-penting)
    - [Tujuan Null Safety](#tujuan-null-safety)
    - [Konsep Dasar: Non-Nullable by Default](#konsep-dasar-non-nullable-by-default)
  - [2. Tipe Non-Nullable (Non-Nullable Types)](#2-tipe-non-nullable-non-nullable-types)
    - [Sintaks Default](#sintaks-default)
    - [Aturan Main](#aturan-main)
    - [Inisialisasi Wajib](#inisialisasi-wajib)
  - [3. Tipe Nullable (Nullable Types)](#3-tipe-nullable-nullable-types)
    - [Sintaks `?`](#sintaks-)
    - [Kapan Menggunakan Tipe Nullable?](#kapan-menggunakan-tipe-nullable)
    - [Penanganan Tipe Nullable: Pentingnya Pengecekan Null](#penanganan-tipe-nullable-pentingnya-pengecekan-null)
      - [Flow Analysis (Analisis Alur)](#flow-analysis-analisis-alur)
  - [4. Operator Penanganan Null (Null-Aware Operators)](#4-operator-penanganan-null-null-aware-operators)
    - [`?.` (Null-aware Member Access)](#-null-aware-member-access)
    - [`??` (Null Coalescing Operator)](#-null-coalescing-operator)
    - [`??=` (Null-aware Assignment Operator)](#-null-aware-assignment-operator)
    - [`!` (Null Assertion Operator)](#-null-assertion-operator)
      - [Mengapa `!` Berbahaya?](#mengapa--berbahaya)
      - [Kapan Menggunakan `!`?](#kapan-menggunakan-)
  - [5. Kata Kunci `late`](#5-kata-kunci-late)
    - [Pengantar Singkat (`late` vs. Null Safety)](#pengantar-singkat-late-vs-null-safety)
    - [Penggunaan Utama `late`](#penggunaan-utama-late)
      - [Lazy Initialization](#lazy-initialization)
      - [Variabel yang Tidak Bisa Diinisialisasi di Konstruktor](#variabel-yang-tidak-bisa-diinisialisasi-di-konstruktor)
    - [Kapan Tidak Menggunakan `late`?](#kapan-tidak-menggunakan-late)
  - [6. Parameter Fungsi dengan Null Safety](#6-parameter-fungsi-dengan-null-safety)
    - [Parameter Wajib Non-Nullable (Default)](#parameter-wajib-non-nullable-default)
    - [Parameter Wajib Nullable](#parameter-wajib-nullable)
    - [Optional Positional Parameters (`[]`)](#optional-positional-parameters-)
    - [Named Parameters (`{}`)](#named-parameters-)
      - [Optional Named Parameters (Default)](#optional-named-parameters-default)
      - [Required Named Parameters (`required`)](#required-named-parameters-required)
  - [7. Null Safety pada Koleksi (Collections)](#7-null-safety-pada-koleksi-collections)
    - [Nullable List (`List<T>?`)](#nullable-list-listt)
    - [List dengan Elemen Nullable (`List<T?>`)](#list-dengan-elemen-nullable-listt)
    - [Kombinasi Keduanya (`List<T?>?`)](#kombinasi-keduanya-listt)
    - [Set dan Map](#set-dan-map)
  - [8. `typedef` dan Null Safety](#8-typedef-dan-null-safety)
  - [9. Strategi Migrasi (Singkat)](#9-strategi-migrasi-singkat)
  - [10. Keuntungan Null Safety](#10-keuntungan-null-safety)
  - [11. Terminologi Kunci](#11-terminologi-kunci)
  - [12. Ringkasan](#12-ringkasan)
  - [13. Sumber Referensi](#13-sumber-referensi)

</details>

---

### 1\. Pendahuluan: Apa itu Null Safety?

**Null Safety** adalah sistem yang diperkenalkan di Dart untuk membantu Anda menulis kode yang lebih aman dan terhindar dari _null reference errors_ yang sering terjadi. Ini adalah bagian dari "sound type system" Dart.

#### Masalah `null` di Masa Lalu (dan Mengapa Null Safety Penting)

Sebelum Null Safety, di banyak bahasa pemrograman (termasuk Dart versi lama), setiap variabel dapat secara implisit menyimpan nilai `null` selain tipe data yang dimaksudkan. Ini menyebabkan masalah yang dikenal sebagai "miliar dolar error" oleh Tony Hoare, penemu `null` itu sendiri.

Contoh masalah:

```dart
String nama; // Sebelum null safety, ini defaultnya null
// print(nama.length); // Ini akan crash saat runtime jika 'nama' belum diinisialisasi
                      // dengan String non-null, karena Anda mencoba mengakses properti 'length'
                      // pada nilai null.
```

Masalahnya adalah kompiler tidak bisa mengetahui apakah `nama` benar-benar akan memiliki nilai String atau `null` pada saat itu. Kesalahan ini hanya muncul saat program berjalan, membuat debugging menjadi sulit.

#### Tujuan Null Safety

- **Menghilangkan Null Reference Errors:** Tujuan utama adalah mencegah program crash karena mencoba mengakses anggota dari variabel yang `null`.
- **Kejelasan Kode:** Kode lebih mudah dipahami karena secara eksplisit menyatakan apakah suatu variabel boleh `null` atau tidak.
- **Performa Lebih Baik:** Kompiler Dart dapat mengoptimalkan kode dengan asumsi bahwa variabel non-nullable tidak akan pernah `null`, menghasilkan ukuran biner yang lebih kecil dan eksekusi yang lebih cepat.
- **Pengalaman Pengembang yang Lebih Baik:** IDE dapat memberikan peringatan dan saran _compile-time_ (sebelum program berjalan) tentang potensi masalah `null`, memungkinkan developer memperbaikinya lebih awal.

#### Konsep Dasar: Non-Nullable by Default

Pilar utama dari Null Safety di Dart adalah: **semua variabel adalah non-nullable secara _default_**.
Ini berarti:

- Jika Anda mendeklarasikan `String nama;`, maka `nama` **tidak bisa** menjadi `null`. Anda harus menginisialisasi dengan nilai `String` yang valid.
- Jika Anda ingin sebuah variabel bisa `null`, Anda harus secara eksplisit menandainya sebagai `nullable` dengan menambahkan `?` setelah tipenya (misalnya, `String?`).

---

### 2\. Tipe Non-Nullable (Non-Nullable Types)

#### Sintaks Default

Tipe non-nullable adalah cara default Dart beroperasi. Anda tidak perlu menambahkan sintaks khusus.

```dart
int usia = 30; // 'usia' tidak bisa null
String nama = "Alice"; // 'nama' tidak bisa null
bool isActive = true; // 'isActive' tidak bisa null
List<int> numbers = [1, 2, 3]; // 'numbers' tidak bisa null, dan elemennya juga tidak bisa null
```

#### Aturan Main

- **Harus diinisialisasi:** Variabel non-nullable harus diinisialisasi sebelum digunakan untuk pertama kalinya. Jika tidak, Anda akan mendapatkan _compile-time error_.
  ```dart
  int quantity;
  // print(quantity); // ERROR: Non-nullable variable 'quantity' must be assigned before it can be used.
  quantity = 10;
  print(quantity); // OK
  ```
- **Tidak bisa ditugaskan `null`:** Anda tidak bisa menugaskan nilai `null` ke variabel non-nullable.
  ```dart
  String username = "user123";
  // username = null; // ERROR: A value of type 'Null' can't be assigned to a variable of type 'String'.
  ```
- **Aman untuk diakses:** Setelah variabel non-nullable diinisialisasi, kompiler menjamin bahwa variabel tersebut tidak akan pernah `null` saat Anda mengaksesnya. Ini berarti Anda dapat memanggil properti atau metode padanya dengan aman tanpa khawatir `null reference error`.

#### Inisialisasi Wajib

Variabel non-nullable memiliki persyaratan inisialisasi yang ketat. Ini bisa diatasi dengan beberapa cara:

1.  **Inisialisasi Langsung:**
    ```dart
    int count = 0;
    String message = "Hello";
    ```
2.  **Inisialisasi di Konstruktor (untuk properti kelas):**

    ```dart
    class User {
      String id;
      String name;

      User(this.id, this.name); // Semua properti non-nullable diinisialisasi oleh constructor
    }
    ```

3.  **Inisialisasi di `late` (akan dibahas lebih lanjut):** Untuk kasus di mana inisialisasi tidak dapat dilakukan segera.
    ```dart
    late String configPath;
    // ... nanti diinisialisasi di setup()
    ```

---

### 3\. Tipe Nullable (Nullable Types)

#### Sintaks `?`

Untuk mengizinkan variabel menyimpan nilai `null`, Anda harus secara eksplisit menambahkan tanda tanya (`?`) setelah tipe data.

```dart
int? maybeNumber; // 'maybeNumber' bisa berupa int atau null
String? optionalMessage; // 'optionalMessage' bisa berupa String atau null
bool? isEnabled; // 'isEnabled' bisa berupa bool atau null
List<String>? userList; // 'userList' bisa berupa List<String> atau null
```

Saat mendeklarasikan variabel nullable tanpa inisialisasi, nilai default-nya adalah `null`.

#### Kapan Menggunakan Tipe Nullable?

Anda harus menggunakan tipe nullable ketika:

- Sebuah nilai secara alami bisa tidak ada (misalnya, email opsional, tanggal lahir yang tidak diketahui).
- Anda menerima data dari sumber eksternal (misalnya, API) yang mungkin mengembalikan `null`.
- Sebuah variabel belum memiliki nilai pada saat deklarasi tetapi akan diinisialisasi nanti (seringkali dalam konteks asinkron atau di mana `late` tidak sepenuhnya cocok).

#### Penanganan Tipe Nullable: Pentingnya Pengecekan Null

Ketika Anda memiliki variabel nullable, kompiler **tidak akan membiarkan Anda mengakses properti atau metode padanya secara langsung** karena ada kemungkinan nilainya `null`. Anda harus membuktikan kepada kompiler bahwa nilai tersebut tidak `null` sebelum dapat mengaksesnya.

Ini bisa dilakukan dengan beberapa cara:

1.  **Pengecekan `if (variable != null)`:** Cara paling langsung. Setelah pengecekan, Dart menggunakan _flow analysis_ untuk mengetahui bahwa variabel tidak `null` dalam blok `if` tersebut.

    ```dart
    String? email = "user@example.com";

    if (email != null) {
      print(email.length); // OK: Dart tahu 'email' bukan null di sini
    } else {
      print("Email tidak tersedia.");
    }
    ```

2.  **Menggunakan Operator Null-Aware (dibahas di bagian berikutnya):** `?.`, `??`, `??=`

##### Flow Analysis (Analisis Alur)

Dart memiliki fitur canggih yang disebut **Flow Analysis**. Kompiler menganalisis jalur eksekusi kode Anda untuk menentukan apakah variabel yang awalnya nullable telah dibuktikan tidak `null` pada titik tertentu. Jika demikian, Anda dapat memperlakukannya sebagai non-nullable dalam _scope_ tersebut.

```dart
String? userInput;

void processInput() {
  userInput = "Hello world"; // Diinisialisasi di sini

  // Setelah if ini, Dart tahu userInput bukan null dalam blok ini
  if (userInput != null) {
    print("Panjang input: ${userInput.length}"); // Aman
  }
}

String getPesanOrDefault(String? pesan) {
  if (pesan != null) {
    return pesan; // Dart tahu 'pesan' non-null di sini
  }
  return "Pesan default";
}
```

---

### 4\. Operator Penanganan Null (Null-Aware Operators)

Dart menyediakan operator khusus untuk bekerja dengan tipe nullable secara ringkas dan aman.

#### `?.` (Null-aware Member Access)

- **Fungsi:** Mengakses properti atau memanggil metode pada objek hanya jika objek tersebut **bukan `null`**. Jika objeknya `null`, seluruh ekspresi akan mengevaluasi menjadi `null`.
- **Sintaks:** `object?.member`
- **Contoh:**

  ```dart
  String? namaDepan;
  print(namaDepan?.length); // Output: null (tidak error)

  namaDepan = "Budi";
  print(namaDepan?.length); // Output: 4

  List<String>? colors;
  print(colors?.isEmpty); // Output: null

  colors = ["Red", "Green"];
  print(colors?.isEmpty); // Output: false
  ```

#### `??` (Null Coalescing Operator)

- **Fungsi:** Memberikan nilai _default_ jika ekspresi di sebelah kiri adalah `null`. Ini sangat berguna untuk menyediakan _fallback value_.
- **Sintaks:** `expressionIfNull ?? defaultValue`
- **Contoh:**

  ```dart
  String? username;
  String displayName = username ?? "Tamu"; // Jika username null, gunakan "Tamu"
  print(displayName); // Output: Tamu

  username = "admin123";
  displayName = username ?? "Pengguna";
  print(displayName); // Output: admin123

  // Contoh dengan metode
  String? pesanSelamatDatang;
  print(pesanSelamatDatang?.toUpperCase() ?? "SELAMAT DATANG");
  // Output: SELAMAT DATANG
  ```

#### `??=` (Null-aware Assignment Operator)

- **Fungsi:** Menetapkan nilai ke variabel hanya jika variabel tersebut saat ini **`null`**. Jika variabel sudah memiliki nilai non-`null`, penugasan akan diabaikan.
- **Sintaks:** `variable ??= value`
- **Contoh:**

  ```dart
  String? userRole;
  userRole ??= "guest"; // userRole sekarang "guest" karena sebelumnya null
  print(userRole);     // Output: guest

  userRole ??= "admin"; // userRole tetap "guest" karena sudah ada nilainya
  print(userRole);     // Output: guest

  int? counter;
  counter ??= 0; // counter sekarang 0
  print(counter); // Output: 0
  ```

#### `!` (Null Assertion Operator)

- **Fungsi:** Memberi tahu kompiler Dart bahwa Anda, sebagai programmer, yakin bahwa nilai variabel yang _nullable_ tidak akan pernah `null` pada titik eksekusi tertentu. Ini secara efektif "membatalkan" null safety untuk ekspresi tersebut.
- **Sintaks:** `variable!`
- **Contoh:**

  ```dart
  String? imageUrl = getProfilePictureUrl(); // Anggap ini mengembalikan String?

  // print(imageUrl.length); // ERROR: imageUrl bisa null

  // Jika Anda 100% yakin imageUrl tidak akan null di sini:
  String actualUrl = imageUrl!; // Menggunakan !
  print(actualUrl.length); // OK, tetapi berisiko!

  // Jika imageUrl ternyata null, baris 'actualUrl = imageUrl!;' akan crash dengan LateInitializationError
  // atau NoSuchMethodError (tergantung konteks dan versi Dart).
  ```

##### Mengapa `!` Berbahaya?

- **Menghilangkan Keamanan Kompiler:** Anda secara manual mengabaikan peringatan kompiler.
- **Potensi _Runtime Error_:** Jika Anda salah dan nilai tersebut ternyata `null` pada saat eksekusi, program akan _crash_. Ini mengalahkan tujuan utama null safety.
- **Sulit untuk Dibaca:** Penggunaannya dapat menyembunyikan potensi bug dari pembaca kode lain.

##### Kapan Menggunakan `!`?

`!` harus digunakan sebagai upaya terakhir, dan hanya ketika Anda benar-benar tidak memiliki cara lain untuk membuktikan kepada kompiler bahwa nilai tersebut tidak `null`, dan Anda sangat yakin itu tidak akan `null` karena logika program atau asumsi yang kuat.

Contoh kasus yang (mungkin) bisa diterima:

- Dalam situasi di mana Anda telah melakukan pengecekan `if (!variable.isDisposed)` atau sejenisnya, dan yakin `variable` sudah ada.
- Ketika Anda berinteraksi dengan API lama yang belum sepenuhnya mendukung null safety, dan Anda harus memaksa tipe.
- Dalam konteks _testing_ di mana Anda ingin memastikan suatu kondisi tertentu tidak pernah `null`.

**Prinsip:** Lebih baik menggunakan `?.` atau `??` kapan pun memungkinkan.

---

### 5\. Kata Kunci `late`

`late` adalah bagian dari Null Safety yang memberikan fleksibilitas untuk variabel non-nullable.

#### Pengantar Singkat (`late` vs. Null Safety)

Seperti yang sudah dibahas di bagian **Variables & Constants**, `late` digunakan untuk mendeklarasikan variabel non-nullable yang tidak dapat diinisialisasi pada saat deklarasi, tetapi Anda berjanji akan menginisialisasinya sebelum pertama kali digunakan. Jika janji ini tidak ditepati, program akan _crash_.

#### Penggunaan Utama `late`

##### Lazy Initialization

Variabel `late` tidak akan diinisialisasi sampai mereka diakses untuk pertama kalinya. Ini berguna untuk inisialisasi yang mahal secara komputasi.

```dart
class HeavyResource {
  HeavyResource() {
    print("HeavyResource diinisialisasi!");
    // Anggap ini proses yang sangat memakan waktu/memori
  }
}

late HeavyResource resource = HeavyResource(); // Tidak akan diinisialisasi sampai diakses

void main() {
  print("Memulai aplikasi...");
  // 'resource' belum diinisialisasi di sini

  print("Mengakses resource...");
  resource.toString(); // Saat baris ini dieksekusi, 'resource' baru diinisialisasi
  print("Resource berhasil diakses.");

  // Output:
  // Memulai aplikasi...
  // Mengakses resource...
  // HeavyResource diinisialisasi!
  // Resource berhasil diakses.
}
```

##### Variabel yang Tidak Bisa Diinisialisasi di Konstruktor

Ini umum terjadi di Flutter, di mana properti `State` atau variabel tertentu diinisialisasi dalam metode siklus hidup seperti `initState()`.

```dart
class MyService {
  void doSomething() => print("Service is doing something.");
}

class MyWidget {
  late MyService _service; // Akan diinisialisasi di initState atau di luar constructor

  MyWidget() {
    // _service = MyService(); // Tidak mungkin di sini jika inisialisasi kompleks
  }

  void initState() {
    _service = MyService(); // Diinisialisasi saat widget dibuat dan diattach
  }

  void build() {
    _service.doSomething(); // Aman karena sudah diinisialisasi di initState
  }
}

void main() {
  MyWidget widget = MyWidget();
  widget.initState(); // Simulasi initState
  widget.build();     // Output: Service is doing something.
}
```

#### Kapan Tidak Menggunakan `late`?

- Jika Anda bisa menginisialisasi variabel segera, lakukan saja. `late` menambah sedikit risiko _runtime error_.
- Jika variabel benar-benar bisa `null` dan itu adalah kondisi yang valid, gunakan tipe `nullable` (`?`) daripada `late`. `late` menyiratkan bahwa nilai _akan_ ada.

---

### 6\. Parameter Fungsi dengan Null Safety

Null Safety juga berlaku untuk parameter fungsi, memastikan kejelasan tentang apakah argumen yang diteruskan boleh `null` atau tidak.

#### Parameter Wajib Non-Nullable (Default)

- Argumen harus selalu non-`null`.
- **Sintaks:** `ReturnType functionName(Type param1, Type param2)`
- **Contoh:**

  ```dart
  void printNama(String nama) {
    print("Nama: $nama");
  }

  void main() {
    printNama("Alice");
    // printNama(null); // ERROR: Argument type 'Null' can't be assigned to the parameter type 'String'.
  }
  ```

#### Parameter Wajib Nullable

- Argumen bisa `null`.
- **Sintaks:** `ReturnType functionName(Type? param1)`
- **Contoh:**

  ```dart
  void printAlamat(String? alamat) {
    print("Alamat: ${alamat ?? 'Tidak Tersedia'}");
  }

  void main() {
    printAlamat("Jl. Merdeka");
    printAlamat(null); // OK
  }
  ```

#### Optional Positional Parameters (`[]`)

- Secara _default_, parameter posisi opsional bersifat **nullable**.
- Anda bisa memberikan nilai _default_ non-`null` jika diinginkan.
- **Sintaks:** `ReturnType functionName(Type requiredParam, [Type? optionalParam1, Type optionalParam2 = defaultValue])`
- **Contoh:**

  ```dart
  void greet(String name, [String? message, String country = "USA"]) {
    print("Hello $name! ${message ?? 'Welcome'} from $country.");
  }

  void main() {
    greet("John");                      // Output: Hello John! Welcome from USA.
    greet("Jane", "Good Morning");      // Output: Hello Jane! Good Morning from USA.
    greet("Mike", "Hi", "Canada");      // Output: Hello Mike! Hi from Canada.
  }
  ```

#### Named Parameters (`{}`)

- Secara _default_, parameter bernama bersifat **nullable**.
- **Sintaks:** `ReturnType functionName({Type? namedParam1, Type namedParam2 = defaultValue})`

##### Optional Named Parameters (Default)

```dart
void configureUser({String? email, int? age}) {
  print("Email: ${email ?? 'N/A'}, Age: ${age ?? 'N/A'}");
}

void main() {
  configureUser(email: "test@example.com"); // Output: Email: test@example.com, Age: N/A
  configureUser(age: 30);                   // Output: Email: N/A, Age: 30
  configureUser();                          // Output: Email: N/A, Age: N/A
}
```

##### Required Named Parameters (`required`)

- Untuk membuat parameter bernama menjadi wajib, gunakan kata kunci `required`. Ini sering digunakan dalam konstruktor di Flutter.
- **Sintaks:** `ReturnType functionName({required Type namedParam1, Type? namedParam2})`
- **Contoh:**

  ```dart
  class Product {
    String name;
    double price;
    String? description; // Optional nullable

    Product({required this.name, required this.price, this.description});
  }

  void main() {
    Product laptop = Product(name: "Laptop", price: 1200.0);
    Product phone = Product(name: "Phone", price: 800.0, description: "Smartphone terbaru");

    // Product camera = Product(price: 500.0); // ERROR: The named parameter 'name' is required.
  }
  ```

---

### 7\. Null Safety pada Koleksi (Collections)

Null safety juga berlaku untuk koleksi seperti `List`, `Set`, dan `Map`. Anda harus membedakan antara koleksi itu sendiri yang `null` dan elemen-elemen di dalamnya yang `null`.

#### Nullable List (`List<T>?`)

- List itu sendiri bisa `null`.
- Artinya, variabel `myList` bisa menyimpan objek `List` atau `null`.
- Elemen di dalam List (jika List ada) adalah non-nullable secara default.

<!-- end list -->

```dart
List<String>? daftarBelanja = null; // List-nya null
// print(daftarBelanja.length); // ERROR, karena daftarBelanja bisa null. Harus pakai ?.

daftarBelanja = ["Apel", "Susu"]; // List-nya sekarang ada isinya
print(daftarBelanja?.first); // Output: Apel
```

#### List dengan Elemen Nullable (`List<T?>`)

- List itu sendiri tidak bisa `null` (harus diinisialisasi dengan objek List).
- Namun, elemen-elemen di dalam List bisa `null`.

<!-- end list -->

```dart
List<String?> daftarNama = ["Alice", null, "Bob"]; // List tidak null, tapi elemennya bisa null
print(daftarNama[0]); // Output: Alice
print(daftarNama[1]); // Output: null

// daftarNama = null; // ERROR: A value of type 'Null' can't be assigned to a variable of type 'List<String?>'.
```

#### Kombinasi Keduanya (`List<T?>?`)

- List itu sendiri bisa `null`, dan elemen-elemen di dalamnya juga bisa `null`.

<!-- end list -->

```dart
List<int?>? dataServer = null; // List-nya null

dataServer = [1, null, 3, null, 5]; // List-nya ada, elemennya bisa null

print(dataServer?[1]); // Output: null (aman, karena dataServer bisa null)
print(dataServer![0]); // Output: 1 (hati-hati dengan !)
```

#### Set dan Map

Konsep yang sama berlaku untuk `Set` dan `Map`.

- **Nullable Set:** `Set<String>? mySet = null;` (Set-nya bisa null)
- **Set dengan Elemen Nullable:** `Set<String?> myNullableElementsSet = {'a', null};` (Set-nya ada, elemennya bisa null)
- **Nullable Map:** `Map<String, int>? myMap = null;` (Map-nya bisa null)
- **Map dengan Key/Value Nullable:** `Map<String?, int?> myNullableEntries = {null: 10, 'b': null};`

---

### 8\. `typedef` dan Null Safety

`typedef` digunakan untuk membuat alias tipe fungsi atau tipe lainnya. Null Safety juga berlaku di sini.

```dart
// typedef sebelum null safety
typedef void MyVoidCallback();

// typedef dengan null safety:
// A function type that returns nothing and takes no arguments.
typedef VoidCallback = void Function();

// A function type that returns a String and takes a String? argument.
typedef StringProcessor = String Function(String? input);

// A function type that returns a nullable int and takes two non-nullable ints.
typedef NullableIntCalculator = int? Function(int a, int b);

// Menggunakan typedef:
String processText(String? text, StringProcessor processor) {
  return processor(text);
}

void main() {
  StringProcessor toUpperCaseOrEmpty = (String? s) => s?.toUpperCase() ?? "";
  print(processText("hello", toUpperCaseOrEmpty)); // Output: HELLO
  print(processText(null, toUpperCaseOrEmpty));    // Output: (string kosong)

  NullableIntCalculator divide = (a, b) => b == 0 ? null : a ~/ b;
  print(divide(10, 2)); // Output: 5
  print(divide(10, 0)); // Output: null
}
```

---

### 9\. Strategi Migrasi (Singkat)

Saat mengupgrade proyek Dart/Flutter lama ke Null Safety, ada beberapa strategi:

1.  **Migrasi Otomatis:** Dart menyediakan alat migrasi otomatis (`dart migrate`). Ini adalah titik awal yang bagus tetapi seringkali memerlukan penyesuaian manual.
2.  **Pahami _Flow Analysis_:** Biarkan kompiler Dart bekerja untuk Anda. Ketika Anda menambahkan pengecekan `if (variable != null)`, kompiler akan otomatis memperlakukan variabel sebagai non-nullable dalam blok tersebut.
3.  **Gunakan `?` secara Konservatif:** Tandai variabel sebagai nullable hanya jika mereka benar-benar bisa `null`. Jangan menandai semuanya sebagai nullable hanya untuk menghilangkan error.
4.  **Prioritaskan `?.` dan `??`:** Gunakan operator _null-aware_ ini untuk penanganan `null` yang aman dan ekspresif.
5.  **Hati-hati dengan `!` dan `late`:** Pahami risikonya. `late` berguna untuk inisialisasi yang tertunda, tetapi `!` adalah pengereman darurat yang harus dihindari jika ada alternatif yang lebih aman.

---

### 10\. Keuntungan Null Safety

- **Lebih Sedikit _Runtime Error_:** Peningkatan signifikan dalam keandalan aplikasi karena sebagian besar _null reference errors_ dicegah saat kompilasi.
- **Peningkatan Keterbacaan Kode:** Jelas terlihat apakah suatu variabel bisa `null` atau tidak hanya dari deklarasinya.
- **Meningkatkan Produktivitas:** IDE memberikan umpan balik instan tentang potensi masalah `null`, mengurangi waktu debugging.
- **Performa Lebih Baik:** Kompiler dapat mengoptimalkan kode dengan asumsi non-nullability, menghasilkan kode yang lebih efisien.
- **Desain API yang Lebih Baik:** Memaksa developer untuk memikirkan kondisi `null` saat merancang API, menghasilkan antarmuka yang lebih robust.

---

### 11\. Terminologi Kunci

- **Null Safety:** Sistem di Dart yang membantu mencegah _null reference errors_ dengan membuat variabel non-nullable secara default.
- **Non-Nullable Type:** Tipe data yang tidak diizinkan untuk menyimpan nilai `null` (misalnya, `String`, `int`).
- **Nullable Type:** Tipe data yang diizinkan untuk menyimpan nilai `null` (ditandai dengan `?`, misalnya, `String?`, `int?`).
- **Null Reference Error:** Kesalahan yang terjadi saat mencoba mengakses properti atau metode pada variabel yang nilainya `null`.
- **Compile-time Error:** Kesalahan yang terdeteksi oleh kompiler sebelum program dijalankan. Null Safety mengubah banyak _runtime error_ menjadi _compile-time error_.
- **Runtime Error:** Kesalahan yang terjadi saat program sedang berjalan.
- **Flow Analysis:** Kemampuan kompiler Dart untuk menganalisis alur kode dan menentukan status nullability suatu variabel pada titik tertentu.
- **`?.` (Null-aware Member Access):** Operator untuk mengakses anggota secara aman pada objek nullable.
- **`??` (Null Coalescing Operator):** Operator untuk memberikan nilai default jika ekspresi di sebelah kiri adalah `null`.
- **`??=` (Null-aware Assignment Operator):** Operator untuk menugaskan nilai jika variabel saat ini `null`.
- **`!` (Null Assertion Operator):** Operator yang memaksa ekspresi nullable menjadi non-nullable, berisiko _runtime error_ jika salah.
- **`late`:** Modifier untuk variabel non-nullable yang akan diinisialisasi nanti, sebelum digunakan. Berguna untuk _lazy initialization_ atau mengatasi dependensi.
- **Lazy Initialization:** Menunda inisialisasi suatu variabel sampai variabel tersebut pertama kali diakses.
- **Required Named Parameter:** Parameter bernama yang wajib diberikan saat memanggil fungsi atau konstruktor (menggunakan `required`).

---

### 12\. Ringkasan

**Null Safety** adalah fitur yang mengubah permainan di Dart, memindahkan banyak _null reference errors_ dari _runtime_ ke _compile-time_. Dengan menjadikan tipe non-nullable sebagai _default_, Dart memaksa Anda untuk secara eksplisit menangani kasus di mana suatu nilai mungkin `null`, menghasilkan kode yang lebih andal dan mudah dipelihara.

Anda telah mempelajari:

- Prinsip **non-nullable by default**.
- Cara menggunakan `?` untuk membuat tipe **nullable**.
- Pentingnya **flow analysis** Dart untuk memahami nullability.
- Berbagai **operator null-aware** (`?.`, `??`, `??=`) untuk penanganan `null` yang aman.
- Risiko dan penggunaan `!` (Null Assertion Operator).
- Manfaat dan penggunaan kata kunci **`late`** untuk inisialisasi tertunda variabel non-nullable.
- Penerapan Null Safety pada **parameter fungsi** dan **koleksi**.

Menguasai Null Safety adalah langkah besar menuju penulisan aplikasi Dart dan Flutter yang kokoh dan bebas bug. Ini mungkin terasa sedikit lebih ketat pada awalnya, tetapi manfaat jangka panjang dalam hal keandalan dan kemudahan debugging sangat besar.

---

### 13\. Sumber Referensi

- **Dart Documentation - Sound null safety:** [https://dart.dev/null-safety](https://dart.dev/null-safety) (Mulai dari sini, ada banyak tautan ke topik spesifik)
- **Dart Documentation - Understanding null safety:** [https://dart.dev/null-safety/understanding-null-safety](https://dart.dev/null-safety/understanding-null-safety)
- **Dart Documentation - Null-aware operators:** [https://dart.dev/guides/language/language-tour\#null-aware-operators](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23null-aware-operators)
- **Dart Documentation - Late variables:** [https://dart.dev/guides/language/language-tour\#late-variables](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23late-variables)
- **Dart Documentation - Required parameters:** [https://dart.dev/guides/language/language-tour\#required-parameters](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23required-parameters)

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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
