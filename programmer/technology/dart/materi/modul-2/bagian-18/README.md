# [Type Inference][0]

<details>
  <summary>📃 Daftar Isi</summary>

---

- [Type Inference](#type-inference)
    - [1. Pendahuluan](#1-pendahuluan)
    - [2. Apa Itu Type Inference?](#2-apa-itu-type-inference)
    - [3. Bagaimana Type Inference Bekerja di Dart?](#3-bagaimana-type-inference-bekerja-di-dart)
      - [a. Variabel Lokal (`var`, `final`, `const`)](#a-variabel-lokal-var-final-const)
      - [b. Initializers (Inisialisasi)](#b-initializers-inisialisasi)
      - [c. Generics](#c-generics)
      - [d. Functions dan Lambdas](#d-functions-dan-lambdas)
    - [4. Kapan Menggunakan `var`, `final`, `const` dengan Type Inference?](#4-kapan-menggunakan-var-final-const-dengan-type-inference)
      - [a. Prioritas `const` \> `final` \> `var` \> Tipe Eksplisit](#a-prioritas-const--final--var--tipe-eksplisit)
      - [b. Panduan Umum untuk Penggunaan](#b-panduan-umum-untuk-penggunaan)
    - [5. Manfaat Type Inference](#5-manfaat-type-inference)
      - [a. Keterbacaan Kode](#a-keterbacaan-kode)
      - [b. Keringkasan Kode](#b-keringkasan-kode)
      - [c. Pemeliharaan Kode](#c-pemeliharaan-kode)
      - [d. Keamanan Tipe Tetap Terjaga](#d-keamanan-tipe-tetap-terjaga)
    - [6. Batasan dan Kapan Tidak Menggunakan Type Inference](#6-batasan-dan-kapan-tidak-menggunakan-type-inference)
      - [a. Inisialisasi `null`](#a-inisialisasi-null)
      - [b. Koleksi Kosong](#b-koleksi-kosong)
      - [c. Ketika Tipe Tidak Jelas](#c-ketika-tipe-tidak-jelas)
      - [d. API Publik](#d-api-publik)
    - [7. Ringkasan](#7-ringkasan)

---

</details>

### 1\. Pendahuluan

Dart adalah bahasa yang _statically typed_ (pemeriksaan tipe dilakukan pada waktu kompilasi), namun Anda tidak selalu harus secara eksplisit menuliskan tipe data untuk setiap variabel. Ini dimungkinkan berkat fitur yang disebut **Type Inference**. Type Inference adalah kemampuan kompiler untuk secara otomatis menentukan tipe data suatu variabel, parameter, atau nilai lain berdasarkan konteks di mana ia digunakan, biasanya dari nilai yang diberikan saat inisialisasi.

Fitur ini memungkinkan Anda untuk menulis kode yang lebih ringkas dan mudah dibaca tanpa mengorbankan keamanan tipe yang kuat yang ditawarkan oleh Dart.

---

### 2\. Apa Itu Type Inference?

Secara sederhana, **Type Inference** adalah kemampuan kompiler Dart untuk "menebak" atau "menyimpulkan" tipe data suatu ekspresi. Ketika Anda mendeklarasikan variabel menggunakan kata kunci seperti `var`, `final`, atau `const` (bukan tipe eksplisit seperti `String`, `int`, `List<T>`), kompiler akan menganalisis nilai yang Anda tugaskan kepadanya dan menetapkan tipe yang paling sesuai.

Setelah tipe diinferensi, variabel tersebut berperilaku persis seperti jika Anda mendeklarasikannya dengan tipe eksplisit. Artinya, Anda tidak dapat menugaskan nilai dengan tipe yang tidak kompatibel ke variabel tersebut setelah inisialisasi awal.

---

### 3\. Bagaimana Type Inference Bekerja di Dart?

Type inference di Dart berlaku di berbagai konteks:

#### a. Variabel Lokal (`var`, `final`, `const`)

Ini adalah kasus penggunaan yang paling umum.

- **`var`**: Digunakan untuk variabel yang nilainya bisa berubah setelah inisialisasi, tetapi tipenya tetap (diinferensi sekali).

  ```dart
  var name = "Alice"; // Dart menginferensi 'name' sebagai String
  print(name.runtimeType); // Output: String
  name = "Bob"; // OK, karena 'name' tetap String
  // name = 123; // ERROR: A value of type 'int' can't be assigned to a variable of type 'String'.
  ```

- **`final`**: Digunakan untuk variabel yang nilainya hanya bisa ditetapkan sekali (sekali diinisialisasi, tidak bisa diubah). Tipe diinferensi.

  ```dart
  final age = 30; // Dart menginferensi 'age' sebagai int
  print(age.runtimeType); // Output: int
  // age = 31; // ERROR: A final variable 'age' can only be set once.
  ```

- **`const`**: Digunakan untuk variabel yang nilainya adalah konstanta waktu kompilasi. Tipe diinferensi.

  ```dart
  const pi = 3.14159; // Dart menginferensi 'pi' sebagai double
  print(pi.runtimeType); // Output: double
  // const PI = getPiValue(); // ERROR: getPiValue() mungkin bukan konstanta waktu kompilasi
  ```

#### b. Initializers (Inisialisasi)

Dart menggunakan nilai inisialisasi untuk menyimpulkan tipe.

```dart
var price = 100; // Inferensi sebagai int
var temperature = 25.5; // Inferensi sebagai double
var isActive = true; // Inferensi sebagai bool
```

#### c. Generics

Type inference juga bekerja dengan koleksi generik, membuat kode lebih ringkas.

```dart
// List
var numbers = [1, 2, 3]; // Inferensi sebagai List<int>
var names = ['Alice', 'Bob']; // Inferensi sebagai List<String>
var mixed = [1, 'hello', true]; // Inferensi sebagai List<Object> karena ada tipe berbeda

// Set
var uniqueIds = {101, 102, 103}; // Inferensi sebagai Set<int>

// Map
var userData = {'name': 'Charlie', 'age': 40}; // Inferensi sebagai Map<String, Object>
                                            // Karena 'Charlie' adalah String dan 40 adalah int,
                                            // nilai disimpulkan sebagai supertipe umum: Object.

// Jika Anda ingin Map yang lebih spesifik saat nilainya campur, Anda perlu tipe eksplisit:
Map<String, dynamic> flexibleUserData = {'name': 'Charlie', 'age': 40};
```

#### d. Functions dan Lambdas

Tipe parameter dan nilai kembalian dari fungsi atau lambda juga dapat diinferensi dalam beberapa kasus, terutama jika mereka digunakan dalam konteks di mana tipenya jelas.

```dart
// Inferensi tipe parameter 'a' dan 'b', serta return type 'int'
var add = (a, b) => a + b;
print(add(5, 3).runtimeType); // Output: int

// Jika ada ambiguitas, Dart mungkin inferensi sebagai 'dynamic' atau Anda perlu eksplisit
var subtract = (a, b) {
  if (a > b) return a - b;
  return 'negative'; // Di sini return type tidak konsisten, akan inferensi dynamic atau error
};
// Dalam kasus seperti ini, lebih baik eksplisit:
// Function(int, int) subtract = (int a, int b) { ... };
// String Function(int, int) subtract = (int a, int b) { ... };
```

---

### 4\. Kapan Menggunakan `var`, `final`, `const` dengan Type Inference?

Dart memiliki panduan gaya yang kuat tentang kapan menggunakan `var`, `final`, `const` dibandingkan dengan tipe eksplisit.

#### a. Prioritas `const` \> `final` \> `var` \> Tipe Eksplisit

- Gunakan `const` jika nilai tidak akan berubah dan diketahui pada waktu kompilasi. Ini adalah yang paling _restrictive_ dan performa terbaik.
- Gunakan `final` jika nilai tidak akan berubah setelah pertama kali diinisialisasi (tidak harus pada waktu kompilasi, bisa _runtime_).
- Gunakan `var` jika nilai akan berubah, dan tipe dapat dengan jelas diinferensi dari inisialisasinya.
- Gunakan tipe eksplisit (misalnya `String name = "Alice";`) hanya jika tipe tidak jelas dari inisialisasi, atau jika Anda ingin lebih eksplisit demi keterbacaan (misalnya, di API publik).

#### b. Panduan Umum untuk Penggunaan

- **Gunakan `var`** untuk variabel lokal ketika inisialisasi membuatnya jelas apa tipenya. Ini adalah _default_ yang baik.
  ```dart
  var user = User('John Doe'); // Jelas user adalah User
  var message = 'Hello world!'; // Jelas message adalah String
  ```
- **Gunakan `final`** untuk variabel yang ditetapkan sekali.

  ```dart
  final String greeting; // Tipe eksplisit jika tidak ada inisialisasi langsung
  if (DateTime.now().hour < 12) {
    greeting = 'Good morning';
  } else {
    greeting = 'Good afternoon';
  }
  // greeting = 'Good evening'; // ERROR

  final result = calculateSomething(); // Jelas result adalah hasil dari calculateSomething()
  ```

- **Gunakan `const`** untuk konstanta waktu kompilasi.
  ```dart
  const String appName = 'My App';
  const double pi = 3.14;
  ```
- **Gunakan tipe eksplisit** ketika:
  - Menginisialisasi variabel dengan `null` atau koleksi kosong (akan dibahas di Batasan).
  - Tipe yang inferensi tidak sejelas yang Anda inginkan, atau ada ambiguitas.
  - Mendeklarasikan _field_ publik atau nilai kembalian dari fungsi publik (untuk dokumentasi dan kejelasan API).

---

### 5\. Manfaat Type Inference

#### a. Keterbacaan Kode

Kode menjadi lebih ringkas dan fokus pada nilai atau logika, bukan pada deklarasi tipe yang terkadang redundan.

```dart
// Kurang ringkas
List<String> names = ['Alice', 'Bob', 'Charlie'];
Map<String, int> ages = {'Alice': 30, 'Bob': 25};

// Lebih ringkas dengan inference
var names = ['Alice', 'Bob', 'Charlie'];
var ages = {'Alice': 30, 'Bob': 25};
```

#### b. Keringkasan Kode

Mengurangi jumlah _boilerplate_ yang perlu diketik.

#### c. Pemeliharaan Kode

Jika Anda mengubah tipe data nilai inisialisasi, kompiler akan secara otomatis menyesuaikan tipe variabel, mengurangi kebutuhan untuk mengubah deklarasi tipe di beberapa tempat.

#### d. Keamanan Tipe Tetap Terjaga

Meskipun Anda tidak secara eksplisit menulis tipe, Dart tetap melakukan pemeriksaan tipe statis pada waktu kompilasi. Ini berarti semua manfaat _statically typed_ (deteksi bug lebih awal, _autocompletion_ yang akurat) tetap Anda dapatkan.

---

### 6\. Batasan dan Kapan Tidak Menggunakan Type Inference

Ada beberapa skenario di mana type inference mungkin tidak memberikan hasil yang diinginkan, atau di mana tipe eksplisit lebih baik:

#### a. Inisialisasi `null`

Jika Anda menginisialisasi variabel dengan `null` tanpa memberikan tipe eksplisit, Dart akan menginferensinya sebagai `dynamic` atau `Object?` tergantung konteks (sebelum null safety, biasanya `dynamic`). Ini bisa menghilangkan keamanan tipe.

```dart
var name = null; // Inferensi sebagai dynamic? (atau Object? tergantung versi Dart)
// print(name.length); // Ini akan lolos compile-time jika dynamic, tapi error di runtime
String? userName = null; // Ini lebih baik: jelas nullable String
```

#### b. Koleksi Kosong

Ketika Anda menginisialisasi `List`, `Set`, atau `Map` kosong tanpa elemen awal, Dart tidak memiliki informasi yang cukup untuk menyimpulkan tipe elemennya.

```dart
var myList = []; // Inferensi sebagai List<dynamic>
myList.add(1);    // OK
myList.add('hello'); // OK (Tapi ini mungkin bukan yang Anda inginkan)

var mySet = {}; // Inferensi sebagai Map<dynamic, dynamic> (karena {} adalah literal Map kosong)

// Lebih baik eksplisit
List<int> numbers = [];
Set<String> names = {};
Map<String, int> scores = {};
```

#### c. Ketika Tipe Tidak Jelas

Jika nilai inisialisasi adalah hasil dari pemanggilan fungsi atau ekspresi kompleks yang tipenya tidak langsung jelas bagi pembaca kode, menggunakan tipe eksplisit dapat meningkatkan keterbacaan.

```dart
// var result = complexCalculation(input1, input2);
// Jika complexCalculation mengembalikan sesuatu yang tidak jelas (misalnya List<Map<String, dynamic>>),
// lebih baik eksplisit:
// List<Map<String, dynamic>> result = complexCalculation(input1, input2);
```

#### d. API Publik

Untuk _field_ kelas publik, parameter fungsi publik, dan nilai kembalian fungsi publik, sering kali disarankan untuk menggunakan tipe eksplisit. Ini berfungsi sebagai dokumentasi yang jelas bagi pengguna API Anda dan membantu IDE dalam _autocompletion_.

```dart
// Kurang jelas untuk API publik
// var getData(var id) { ... }

// Lebih baik untuk API publik
String getData(String id) { /* ... */ }
```

---

### 7\. Ringkasan

**Type Inference** adalah fitur yang kuat di Dart yang memungkinkan kompiler secara otomatis menentukan tipe data variabel, parameter, dan nilai berdasarkan konteksnya. Ini dicapai dengan menggunakan kata kunci `var`, `final`, atau `const` alih-alih mendeklarasikan tipe secara eksplisit.

Manfaat utamanya meliputi **keterbacaan, keringkasan, dan kemudahan pemeliharaan kode**, tanpa mengorbankan **keamanan tipe statis** Dart. Namun, penting untuk mengetahui batasannya, terutama saat menginisialisasi dengan `null` atau koleksi kosong, atau ketika tipe tidak langsung jelas.

Dengan memahami kapan dan bagaimana menggunakan type inference secara efektif, Anda dapat menulis kode Dart yang lebih bersih, efisien, dan robust.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-17/README.md
[selanjutnya]: ../bagian-19/README.md
[0]:../README.md