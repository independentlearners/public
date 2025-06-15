# [Syntax Fundamentals][0]

Ini adalah bagian yang akan mengajarkan Anda bagaimana cara menulis instruksi untuk komputer menggunakan bahasa Dart.

#

Bayangkan Anda belajar bahasa manusia. Typing System dalam dunia programing adalah tentang jenis-jenis kata (kata benda, kata kerja, kata sifat, dll.). Nah, Syntax Fundamentals adalah tentang aturan tata bahasa (grammar) dan struktur kalimat yang benar agar orang lain bisa memahami apa yang Anda katakan. Dalam pemrograman, "orang lain" kita anggap sebagai kompailer Dart, dan tentu saja, hal semacam ini berlaku untuk programmer lain (atau diri Anda sendiri di masa depan\!) yang akan membaca kode tersebut.

<details>
  <summary>📃 Daftar Isi</summary>

- [Syntax Fundamentals](#syntax-fundamentals)
- [](#)
    - [1. Pendahuluan: Apa itu Syntax Fundamentals?](#1-pendahuluan-apa-itu-syntax-fundamentals)
      - [Analogi Sederhana](#analogi-sederhana)
      - [Mengapa Sintaks Penting?](#mengapa-sintaks-penting)
    - [2. Dasar-dasar Struktur Program Dart](#2-dasar-dasar-struktur-program-dart)
      - [`main()` Function: Titik Masuk Program](#main-function-titik-masuk-program)
      - [Statements dan Expressions](#statements-dan-expressions)
        - [Statement](#statement)
        - [Expression](#expression)
    - [3. Komentar (Comments)](#3-komentar-comments)
      - [Single-line Comments (`//`)](#single-line-comments-)
      - [Multi-line Comments (`/* ... */`)](#multi-line-comments---)
      - [Documentation Comments (`///` atau `/** ... */`)](#documentation-comments--atau---)
    - [4. Variabel (Variables)](#4-variabel-variables)
      - [Deklarasi Variabel](#deklarasi-variabel)
      - [Inisialisasi Variabel](#inisialisasi-variabel)
- [Poin Tambahan](#poin-tambahan)
  - [📘 Statement dan Expression dalam Dart](#-statement-dan-expression-dalam-dart)
    - [Statement](#statement-1)
    - [Expression](#expression-1)
  - [📌 Hubungan antara Deklarasi, Inisialisasi, Statement, dan Expression](#-hubungan-antara-deklarasi-inisialisasi-statement-dan-expression)
    - [1. Deklarasi](#1-deklarasi)
    - [2. Inisialisasi](#2-inisialisasi)
  - [📑 Rangkuman](#-rangkuman)
      - [Aturan Penamaan Variabel (Identifiers)](#aturan-penamaan-variabel-identifiers)
      - [Kata Kunci Variabel di Dart](#kata-kunci-variabel-di-dart)
        - [`var`](#var)
        - [`final`](#final)
        - [`const`](#const)
        - [`late`](#late)
        - [Tipe Eksplisit](#tipe-eksplisit)
      - [Null Safety pada Variabel](#null-safety-pada-variabel)
    - [5. Tipe Data Bawaan (Built-in Data Types)](#5-tipe-data-bawaan-built-in-data-types)
      - [Angka (`num`, `int`, `double`)](#angka-num-int-double)
      - [Teks (`String`)](#teks-string)
      - [Boolean (`bool`)](#boolean-bool)
      - [List (`List`)](#list-list)
      - [Set (`Set`)](#set-set)
      - [Map (`Map`)](#map-map)
      - [Runes dan Symbols](#runes-dan-symbols)
    - [6. Operator (Operators)](#6-operator-operators)
      - [Operator Aritmatika](#operator-aritmatika)
      - [Operator Kesetaraan dan Relasional](#operator-kesetaraan-dan-relasional)
      - [Operator Penugasan (Assignment Operators)](#operator-penugasan-assignment-operators)
      - [Operator Logika](#operator-logika)
      - [Operator Type Test](#operator-type-test)
      - [Operator Penugasan Null-Aware (`??=`)](#operator-penugasan-null-aware-)
      - [Cascading Operator (`..`)](#cascading-operator-)
      - [Spread Operator (`...` dan `...?`)](#spread-operator--dan-)
      - [Null-aware Access Operator (`?.`)](#null-aware-access-operator-)
      - [Null Assertion Operator (`!`)](#null-assertion-operator-)
    - [7. Kontrol Aliran (Control Flow)](#7-kontrol-aliran-control-flow)
      - [Conditional Statements (Pernyataan Bersyarat)](#conditional-statements-pernyataan-bersyarat)
        - [`if`, `else if`, `else`](#if-else-if-else)
        - [`switch` dan `case`](#switch-dan-case)
        - [Ternary Operator (`condition ? expr1 : expr2`)](#ternary-operator-condition--expr1--expr2)
      - [Looping Statements (Pernyataan Perulangan)](#looping-statements-pernyataan-perulangan)
        - [`for` loop](#for-loop)
        - [`for-in` loop](#for-in-loop)
        - [`while` loop](#while-loop)
        - [`do-while` loop](#do-while-loop)
      - [Break dan Continue](#break-dan-continue)
    - [8. Fungsi (Functions)](#8-fungsi-functions)
      - [Definisi Fungsi Dasar](#definisi-fungsi-dasar)
      - [Parameter Fungsi](#parameter-fungsi)
        - [Required Positional Parameters](#required-positional-parameters)
        - [Optional Positional Parameters (`[]`)](#optional-positional-parameters-)
        - [Named Parameters (`{}`)](#named-parameters-)
        - [Required Named Parameters (`required`)](#required-named-parameters-required)
      - [Fungsi sebagai First-Class Objects](#fungsi-sebagai-first-class-objects)
      - [Anonymous Functions (Fungsi Anonim) / Lambdas](#anonymous-functions-fungsi-anonim--lambdas)
      - [Arrow Functions (Fungsi Panah)](#arrow-functions-fungsi-panah)
      - [Return Values (Nilai Kembalian)](#return-values-nilai-kembalian)
    - [9. Impor dan Ekspor (Imports \& Exports)](#9-impor-dan-ekspor-imports--exports)
      - [`import`](#import)
      - [`export`](#export)
      - [Prefix (`as`)](#prefix-as)
      - [Show dan Hide (`show`, `hide`)](#show-dan-hide-show-hide)
    - [10. Kata Kunci (Keywords)](#10-kata-kunci-keywords)
    - [11. Terminologi Kunci](#11-terminologi-kunci)
    - [12. Ringkasan](#12-ringkasan)
    - [13. Sumber Referensi](#13-sumber-referensi)
- [](#-1)

</details>

---

### 1\. Pendahuluan: Apa itu Syntax Fundamentals?

**Syntax Fundamentals** (Dasar-dasar Sintaks) adalah sekumpulan aturan dan struktur dasar yang harus Anda ikuti saat menulis kode dalam bahasa pemrograman tertentu. Ini adalah "tata bahasa" atau "aturan main" dari bahasa tersebut. Sama seperti bahasa manusia memiliki aturan tentang bagaimana kata-kata digabungkan untuk membentuk kalimat yang bermakna, bahasa pemrograman memiliki aturan tentang bagaimana karakter dan simbol disusun untuk membentuk instruksi yang dapat dipahami oleh komputer.

#### Analogi Sederhana

Bayangkan Anda sedang belajar memasak menggunakan resep.

- **Bahan-bahan** adalah **Tipe Data** (gula, garam, tepung, telur).
- **Cara menggabungkan dan mengolah bahan-bahan** tersebut adalah **Sintaks** (misalnya, "campur tepung dan gula", "aduk rata", "panggang pada suhu 180°C selama 30 menit"). Jika Anda mencampur bahan yang salah atau mengikuti instruksi yang salah, hasilnya tidak akan seperti yang diharapkan (atau bahkan bisa jadi bencana\!).

Dalam pemrograman, jika Anda menulis kode yang tidak sesuai dengan sintaks, kompiler akan memberikan pesan kesalahan, dan program Anda tidak akan berjalan.

#### Mengapa Sintaks Penting?

1.  **Dapat Dipahami Komputer:** Kompiler atau interpreter membutuhkan sintaks yang tepat untuk mengubah kode Anda menjadi instruksi yang dapat dijalankan oleh mesin. Sedikit saja kesalahan sintaks akan membuat komputer "tidak mengerti" apa yang Anda maksud.
2.  **Dapat Dibaca Manusia:** Sintaks yang konsisten dan standar, membuat kode lebih mudah dibaca, dipahami, dan dipelihara oleh programmer lain (atau diri Anda sendiri di masa depan).
3.  **Konsistensi:** Memastikan semua orang menulis kode dengan cara yang sama, yang sangat penting dalam pengembangan tim.

---

### 2\. Dasar-dasar Struktur Program Dart

Setiap program Dart, bahkan yang paling sederhana sekalipun, memiliki struktur dasar.

#### `main()` Function: Titik Masuk Program

Setiap aplikasi Dart harus memiliki fungsi `main()`. Ini adalah **titik masuk (entry point)** di mana eksekusi program dimulai. Ketika Anda menjalankan program Dart, sistem akan mencari titk masuk tersebut lalu kemudian memulai untuk menjalankan instruksi yang ada di dalamnya dari atas ke bawah, inilah yang disebut fungsi main (main function)

- **Deskripsi:** Fungsi `main()` adalah fungsi tingkat atas (top-level function), artinya ia tidak berada di dalam kelas mana pun. Ia tidak mengembalikan nilai (atau mengembalikan `void`, yang berarti "tidak ada").
- **Sintaks Dasar:**
  ```dart
  void main() {
    // Kode program Anda akan ditulis di sini
    print("Halo, Dunia!"); // Ini adalah sebuah statement
  }
  ```
  - `void`: Kata kunci yang menunjukkan bahwa fungsi `main` tidak mengembalikan nilai apa pun.
  - `main`: Nama fungsi yang sudah ditentukan sebagai titik awal eksekusi.
  - `()`: Mengindikasikan bahwa `main` adalah sebuah fungsi dan tidak menerima parameter wajib.
  - `{}`: Tanda kurung kurawal ini mendefinisikan _body_ (badan) dari fungsi, di mana semua instruksi yang akan dijalankan fungsi tersebut ditempatkan.

#### Statements dan Expressions

Dalam sintaks Dart, ada dua konsep fundamental: **Statements** dan **Expressions**.

##### Statement

- **Deskripsi:** Sebuah _statement_ adalah instruksi lengkap yang melakukan suatu tindakan. Setiap _statement_ di Dart biasanya diakhiri dengan tanda titik koma (`;`). Ini seperti sebuah kalimat lengkap dalam bahasa manusia.
- **Contoh:**
  ```dart
  int usia = 30; // Ini adalah statement deklarasi dan inisialisasi variabel.
  print("Selamat datang!"); // Ini adalah statement untuk mencetak ke konsol.
  if (usia > 18) { // Ini adalah statement kontrol aliran.
    // ...
  }
  ```

##### Expression

- **Deskripsi:** Sebuah _expression_ adalah bagian dari kode yang **menghasilkan (mengevaluasi) sebuah nilai**. _Expression_ dapat menjadi bagian dari sebuah _statement_.
- **Contoh:**

  ```dart
  int a = 10;
  int b = 20;

  int hasilPenjumlahan = a + b; // 'a + b' adalah expression yang menghasilkan nilai 30.
                              // Keseluruhan baris adalah statement.

  print("Hasil: ${a * 2}"); // 'a * 2' adalah expression yang menghasilkan nilai 20.
                            // "${a * 2}" adalah expression string interpolation.
                            // Keseluruhan baris adalah statement.

  bool isDewasa = (usia >= 18); // '(usia >= 18)' adalah expression yang menghasilkan nilai boolean (true/false).
  ```

Singkatnya, **statements melakukan sesuatu**, sedangkan **expressions menghasilkan nilai**.

---

### 3\. Komentar (Comments)

Komentar adalah bagian dari kode yang **diabaikan oleh kompiler**. Mereka tidak mempengaruhi cara kerja program. Tujuan utama komentar adalah untuk **memberikan penjelasan** bagi programmer yang membaca kode. Ini sangat penting untuk dokumentasi, pemahaman, dan pemeliharaan kode.

Ada tiga jenis utama komentar di Dart:

#### Single-line Comments (`//`)

- **Deskripsi:** Digunakan untuk komentar singkat pada satu baris. Semua teks setelah `//` hingga akhir baris akan dianggap sebagai komentar.
- **Sintaks Dasar:**
  ```dart
  // Ini adalah komentar satu baris.
  int x = 10; // Variabel x menyimpan nilai 10.
  ```

#### Multi-line Comments (`/* ... */`)

- **Deskripsi:** Digunakan untuk komentar yang membentang lebih dari satu baris. Semua teks di antara `/*` dan `*/` akan dianggap sebagai komentar. Berguna untuk memblokir bagian kode untuk debugging.
- **Sintaks Dasar:**
  ```dart
  /*
  Ini adalah komentar multi-baris.
  Anda bisa menuliskan penjelasan panjang di sini.
  Bagian kode ini akan diabaikan oleh kompiler.
  */
  int y = 20;
  /*
  print(y); // Baris ini juga akan diabaikan
  */
  ```

#### Documentation Comments (`///` atau `/** ... */`)

- **Deskripsi:** Ini adalah jenis komentar khusus yang digunakan untuk **menghasilkan dokumentasi API** dari kode Anda secara otomatis (menggunakan tool `dart doc`). Komentar ini muncul di dokumentasi yang dihasilkan dan sering digunakan oleh IDE untuk menampilkan informasi bantuan (_hover_ atau _autocompletion_).
  - `///`: Digunakan untuk komentar dokumentasi satu baris. Lebih umum.
  - `/** ... */`: Digunakan untuk komentar dokumentasi multi-baris.
- **Sintaks Dasar:**

  ```dart
  /// Ini adalah dokumentasi untuk fungsi ini.
  /// Fungsi ini mencetak pesan salam ke konsol.
  void sapaPengguna(String nama) {
    print("Halo, $nama!");
  }

  /**
   * Kelas ini merepresentasikan sebuah buku.
   * Ini memiliki properti untuk judul, penulis, dan tahun terbit.
   */
  class Buku {
    String judul;
    String penulis;
    int tahunTerbit;

    /// Constructor untuk membuat objek Buku baru.
    /// [judul] : Judul buku.
    /// [penulis] : Nama penulis buku.
    /// [tahunTerbit] : Tahun buku diterbitkan.
    Buku(this.judul, this.penulis, this.tahunTerbit);
  }
  ```

  **Catatan:** Menggunakan `[nama_parameter]` di dalam komentar dokumentasi adalah konvensi umum untuk mereferensikan parameter fungsi. Lebih lanjut tentang [komentar][1]

---

### 4\. Variabel (Variables)

**Variabel** adalah nama simbolis untuk sebuah lokasi memori yang menyimpan nilai. Dalam pemrograman, variabel adalah tempat Anda menyimpan data sehingga Anda bisa mengakses dan memanipulasinya nanti dalam program.

#### Deklarasi Variabel

Sebelum menggunakan variabel, Anda harus **mendeklarasikannya**. Deklarasi memberitahu Dart tentang nama variabel dan tipe data yang akan disimpannya.

- **Sintaks Dasar:**
  ```dart
  DataType variableName;
  ```
  - `DataType`: Tipe data dari nilai yang akan disimpan (misalnya `int`, `String`, `bool`).
  - `variableName`: Nama yang Anda berikan untuk variabel tersebut.

#### Inisialisasi Variabel

**Inisialisasi** adalah proses memberikan nilai awal ke variabel saat Anda mendeklarasikannya.

- **Sintaks Dasar:**
  ```dart
  DataType variableName = initialValue;
  ```
  - `initialValue`: Nilai awal yang Anda ingin berikan ke variabel.

**Contoh Deklarasi dan Inisialisasi:**

**variabel non‑nullable tanpa nilai awal adalah tidak valid**, bukan menjadi nullable.

```dart
String namaDepan = "Alice";
// ✅ Deklarasi dan inisialisasi langsung (non-nullable)

// Contoh salah: variabel non-nullable tanpa nilai awal
int usia;
// ❌ Error: non-nullable harus langsung diinisialisasi saat deklarasi

// Solusi: jika nilai belum tersedia, gunakan tipe nullable
int? usia;
// ✅ Nullable: default-nya null, boleh diakses tapi harus dicek null-nya

usia = 25;
// ✅ Penugasan nilai setelah deklarasi (inisialisasi kedua)

// ———————————————————————————————————————————————

double harga;
// ❌ Error: non-nullable tanpa nilai awal tidak diizinkan
// print(harga); // ❌ Masih error jika dipanggil di sini

// Solusi 1: langsung beri nilai saat deklarasi
double harga2 = 99.99;
// ✅ Non-nullable langsung diinisialisasi

/// Solusi 2: Deklarasikan sebagai nullable jika inisialisasi ditunda
double? harga3;
// ✅ Nullable, default null
harga3 = 99.99;
// ✅ Sekarang `harga3` sudah diinisialisasi
```

---

**Ringkasan:**

- **Non‑nullable** (contoh: `int`, `double`, `String`) **harus** diinisialisasi tepat saat deklarasi.
- **Nullable** (contoh: `int?`, `double?`, `String?`) boleh ditunda, dengan default `null`, tapi aksesnya perlu pengecekan null (`if (x != null)` atau `x?.method()`).

# Poin Tambahan

Berikut adalah Statement dan expression dalam konteks Dart, beserta klasifikasi deklarasi dan inisialisasi.

## 📘 Statement dan Expression dalam Dart

### Statement

Dalam Dart, _statement_ adalah unit eksekusi program yang berdiri sendiri. Setiap statement memberi tahu Dart untuk melakukan suatu aksi, seperti mendeklarasikan variabel, membuat perulangan, atau menjalankan fungsi.

Contoh:

```dart
print("Halo, dunia!");
int x = 10;
```

> **Catatan**: Tidak semua statement menghasilkan nilai. Statement bersifat imperatif — mereka memerintahkan program untuk _melakukan sesuatu_.

---

### Expression

_Expression_ adalah kombinasi dari variabel, operator, literal, atau fungsi yang menghasilkan sebuah nilai. Expression dapat ditulis di dalam statement, atau digunakan sebagai bagian dari penugasan (assignment).

Contoh:

```dart
2 + 3
myFunction()
a == b
```

> **Catatan**: Expression selalu _menghasilkan nilai_. Dalam Dart, banyak statement dibangun dari expression.

---

## 📌 Hubungan antara Deklarasi, Inisialisasi, Statement, dan Expression

### 1. Deklarasi

Deklarasi variabel adalah sebuah **statement** yang memberi tahu kompiler tentang nama dan tipe dari variabel.

```dart
int usia;
```

- Ini adalah **declaration statement** | _deklarasi statement_.
- Tidak mengandung expression karena belum ada nilai yang diberikan.

### 2. Inisialisasi

Inisialisasi adalah proses memberi nilai awal pada variabel, biasanya bersamaan dengan deklarasi. Nilai tersebut diperoleh dari sebuah **expression**.

```dart
int usia = 20 + 5;
```

- Ini adalah **declaration + initialization statement** | _deklarasi + inisialisasi statement_.
- Bagian kanan (`20 + 5`) adalah **expression** yang menghasilkan nilai.
- Bagian kiri (`int usia`) adalah deklarasi variabel.

---

## 📑 Rangkuman

| Konsep       | Termasuk Apa              | Menghasilkan Nilai? | Contoh                            |
| ------------ | ------------------------- | ------------------- | --------------------------------- |
| Deklarasi    | Statement                 | ❌ Tidak            | `String nama;`                    |
| Inisialisasi | Statement + Expression    | ✅ Ya               | `String nama = "Alice";`          |
| Expression   | Digunakan dalam statement | ✅ Ya               | `"Alice"`, `2 + 5`, `a == b`      |
| Statement    | Unit eksekusi             | ❌ Tidak            | `if (x > 0) {...}`, `int y = 10;` |

> _Jadi kode yang sifatnya memerintah disebut statement sedangkan isi dalam perintah tersebut dikatakan sebagai expression_

---

#### Aturan Penamaan Variabel (Identifiers)

Nama variabel, fungsi, kelas, dll., disebut **Identifiers/Pengidentifikasi**. Dart memiliki aturan ketat untuk penamaan identifiers:

1.  Dapat berisi huruf, angka, dan underscore (`_`).
2.  Tidak boleh dimulai dengan angka.
3.  Tidak boleh mengandung spasi.
4.  Tidak boleh menggunakan kata kunci (keywords) Dart (seperti `if`, `for`, `class`).
5.  Sensitif terhadap huruf besar/kecil (`nama` berbeda dengan `Nama` karena ini di identifikasi sebagai bentuk yang berbeda).
6.  **Konvensi Penamaan (Code Style):**
    - **`camelCase`:** Untuk variabel, fungsi, parameter, dan nama file. Dimulai dengan huruf kecil, dan setiap kata berikutnya dimulai dengan huruf kapital.
      ```dart
      String namaLengkap;
      int jumlahPesanan;
      void hitungTotalHarga();
      ```
    - **`PascalCase`:** Untuk nama kelas dan _enum_. Setiap kata dimulai dengan huruf kapital.
      ```dart
      class Mahasiswa;
      enum StatusPembayaran;
      ```
    - **`snake_case`:** Kadang digunakan untuk nama file (misalnya `my_widget.dart`).
    - **`UPPER_CASE_SNAKE_CASE`:** Untuk konstanta global atau _enum_ nilai.
      ```dart
      const int MAX_USERS = 100;
      ```

#### Kata Kunci Variabel di Dart

Dart menyediakan beberapa kata kunci untuk mendeklarasikan variabel, masing-masing dengan karakteristik yang berbeda:

##### `var`

- **Deskripsi:** Memungkinkan Dart untuk secara otomatis menentukan tipe data variabel berdasarkan nilai yang diinisialisasikan. Setelah tipe ditentukan, variabel bersifat _statically-typed_ (tipenya tidak bisa diubah).
- **Sintaks Dasar:**

  ```dart
  var nama = "Budi";      // Dart menginferensikan String
  var angka = 123;        // Dart menginferensikan int
  var isVerified = false; // Dart menginferensikan bool

  // nama = 456; // Error: A value of type 'int' can't be assigned to a variable of type 'String'.
  ```

- **Kapan Digunakan:** Untuk variabel lokal di mana tipe sudah jelas dari inisialisasinya, atau untuk mengurangi verbositas.

##### `final`

- **Deskripsi:** Mendeklarasikan variabel yang nilainya **tidak dapat diubah (immutable)** setelah diinisialisasikan. Nilai `final` ditentukan pada **waktu eksekusi (runtime)**, artinya bisa mengambil nilai dari hasil komputasi.
- **Sintaks Dasar:**

  ```dart
  final String tanggalLahir = "1990-01-01"; // Nilai ini tidak bisa diubah
  // tanggalLahir = "1991-02-02"; // Error!

  final DateTime sekarang = DateTime.now(); // Nilai ditentukan saat runtime
  // sekarang = DateTime(2025); // Error!
  ```

- **Kapan Digunakan:** Untuk variabel yang nilainya tidak akan berubah setelah pertama kali ditetapkan, tetapi nilainya mungkin belum diketahui hingga program berjalan.

##### `const`

- **Deskripsi:** Mendeklarasikan variabel yang nilainya adalah **konstanta waktu kompilasi (compile-time constant)**. Ini berarti nilai variabel harus diketahui sepenuhnya dan tidak bisa berubah bahkan sebelum program dimulai. `const` adalah `final` yang lebih ketat.
- **Sintaks Dasar:**

  ```dart
  const double PI = 3.14159; // Nilai ini diketahui saat kompilasi
  const String API_KEY = "ini_adalah_api_key"; // Nilai ini diketahui saat kompilasi

  // const DateTime waktuMulai = DateTime.now(); // Error! DateTime.now() adalah runtime value
  ```

- **Kapan Digunakan:** Untuk nilai-nilai yang benar-benar konstan dan tidak akan pernah berubah sepanjang hidup aplikasi (misalnya, nilai matematika, konfigurasi statis).

##### `late`

- **Deskripsi:** Digunakan untuk mendeklarasikan variabel non-nullable yang **akan diinisialisasi nanti**, sebelum variabel itu digunakan pertama kali. Tanpa `late`, variabel non-nullable harus diinisialisasi saat deklarasi atau dalam konstruktor.
- **Sintaks Dasar:**

  ```dart
  late String deskripsi; // Variabel non-nullable yang akan diinisialisasi nanti

  void setup() {
    deskripsi = "Ini adalah deskripsi yang diinisialisasi nanti.";
    print(deskripsi); // OK, karena sudah diinisialisasi
  }

  // void main() {
  //   // print(deskripsi); // Ini akan crash jika deskripsi belum diinisialisasi
  //   setup();
  // }
  ```

- **Kapan Digunakan:**
  - Ketika Anda memiliki variabel yang tidak bisa diinisialisasi di awal, tetapi Anda yakin itu akan diinisialisasi sebelum digunakan (misalnya, di dalam `initState` pada widget Flutter).
  - Untuk mengatasi _circular dependencies_ (ketergantungan melingkar) antar objek.
  - Untuk variabel yang inisialisasinya mahal, dan Anda ingin menunda inisialisasi sampai benar-benar dibutuhkan (_lazy initialization_).

##### Tipe Eksplisit

- **Deskripsi:** Menuliskan tipe data secara langsung. Ini adalah cara yang paling jelas dan sering direkomendasikan untuk deklarasi variabel.
- **Sintaks Dasar:**
  ```dart
  String namaLengkap = "Fitri Rahmawati";
  int tahunLahir = 2000;
  List<String> daftarKata = ["satu", "dua"];
  ```
- **Kapan Digunakan:** Umumnya direkomendasikan untuk kejelasan kode, terutama untuk parameter fungsi dan nilai kembalian.

#### Null Safety pada Variabel

Dengan fitur **Null Safety** di Dart (sejak Dart 2.12), setiap variabel (secara _default_) adalah **non-nullable**. Artinya, mereka tidak dapat menyimpan nilai `null`.

- Untuk mengizinkan variabel menyimpan `null`, Anda harus secara eksplisit menambahkan tanda tanya `?` setelah tipe data.
- **Sintaks Dasar:**

  ```dart
  String nama = "Rina"; // Non-nullable, tidak bisa null
  // nama = null; // Error saat kompilasi

  String? alamat; // Nullable, bisa null (nilai defaultnya null jika tidak diinisialisasi)
  alamat = "Jl. Merdeka";
  alamat = null; // OK

  int jumlahPesanan = 0; // Non-nullable
  int? kodePos; // Nullable
  ```

- **Penting:** Selalu pertimbangkan apakah variabel Anda _memang_ perlu bisa `null`. Null Safety membantu mencegah banyak kesalahan umum terkait `null`.

---

### 5\. Tipe Data Bawaan (Built-in Data Types)

Kita sudah membahas ini sedikit di bagian Typing System, namun mari kita ulas kembali dengan fokus pada sintaks dan contoh praktis. Dart adalah bahasa yang berorientasi objek, jadi semua tipe data di Dart (termasuk `null`) adalah objek dari suatu kelas.

#### Angka (`num`, `int`, `double`)

- **`int`:** Bilangan bulat (tanpa desimal).
  ```dart
  int usia = 30;
  int hargaBarang = 15000;
  ```
- **`double`:** Bilangan desimal (floating-point).
  ```dart
  double diskon = 0.15;
  double beratBadan = 65.5;
  ```
- **`num`:** Superclass untuk `int` dan `double`. Dapat menyimpan bilangan bulat atau desimal.
  ```dart
  num total = 100; // Bisa int
  total = 50.75; // Bisa double
  ```

#### Teks (`String`)

- **`String`:** Urutan karakter (teks). Dapat menggunakan kutip tunggal (`'`) atau ganda (`"`). String di Dart bersifat _immutable_ (tidak bisa diubah setelah dibuat).

  ```dart
  String salam = "Halo, Dart!";
  String pesan = 'Belajar Flutter itu menyenangkan.';

  // String multi-baris
  String paragraf = '''
  Ini adalah paragraf
  yang terdiri dari
  beberapa baris.
  ''';

  // String Interpolation (menyisipkan variabel/ekspresi ke dalam string)
  String nama = "Siti";
  int tahun = 2024;
  print("Selamat datang, $nama! Tahun sekarang adalah $tahun."); // Output: Selamat datang, Siti! Tahun sekarang adalah 2024.
  print("Panjang nama: ${nama.length} karakter."); // Output: Panjang nama: 4 karakter.
  ```

#### Boolean (`bool`)

- **`bool`:** Menyimpan nilai kebenaran: `true` atau `false`.
  ```dart
  bool isAktif = true;
  bool isSelesai = false;
  ```

#### List (`List`)

- **`List`:** Koleksi yang terurut (memiliki indeks) dari objek. Mirip dengan array.

  ```dart
  List<String> daftarBuah = ["Apel", "Jeruk", "Pisang"];
  List<int> daftarAngka = [10, 20, 30, 40];

  // Mengakses elemen
  print(daftarBuah[0]); // Output: Apel (indeks dimulai dari 0)
  print(daftarAngka.length); // Output: 4

  // Menambah elemen
  daftarBuah.add("Mangga");
  print(daftarBuah); // Output: [Apel, Jeruk, Pisang, Mangga]

  // List yang berisi tipe data campuran (jarang direkomendasikan, lebih baik pakai tipe spesifik)
  List<dynamic> campuran = [1, "dua", true, 3.14];
  ```

#### Set (`Set`)

- **`Set`:** Koleksi unik dari objek (tidak ada duplikat) dan tidak memiliki urutan.

  ```dart
  Set<int> nomorUnik = {1, 2, 3, 2, 4}; // Duplikat 2 akan diabaikan
  print(nomorUnik); // Output: {1, 2, 3, 4} (urutan bisa bervariasi)

  Set<String> warna = {"Merah", "Biru", "Hijau"};
  warna.add("Kuning");
  warna.add("Merah"); // Tidak akan ditambahkan karena sudah ada
  print(warna); // Output: {Merah, Biru, Hijau, Kuning} (urutan bisa bervariasi)
  ```

#### Map (`Map`)

- **`Map`:** Koleksi pasangan kunci-nilai (key-value pairs). Setiap kunci harus unik.

  ```dart
  Map<String, String> kamus = {
    "rumah": "house",
    "mobil": "car",
    "pohon": "tree",
  };

  Map<String, dynamic> dataUser = {
    "nama": "Agus",
    "usia": 35,
    "isStudent": false,
  };

  // Mengakses nilai
  print(kamus["mobil"]); // Output: car
  print(dataUser["nama"]); // Output: Agus

  // Menambah/mengubah nilai
  dataUser["pekerjaan"] = "Programmer";
  dataUser["usia"] = 36;
  print(dataUser);
  // Output: {nama: Agus, usia: 36, isStudent: false, pekerjaan: Programmer}
  ```

#### Runes dan Symbols

- **`Runes`:** Representasi karakter Unicode dalam string. Jarang digunakan secara langsung kecuali saat Anda perlu memanipulasi karakter individual Unicode secara spesifik.
  ```dart
  String emoji = '😊';
  print(emoji.runes.length); // Output: 1 (meskipun '😊' adalah satu karakter visual,
                             //       ia mungkin terdiri dari lebih dari satu code point Unicode,
                             //       tergantung representasinya, Dart menanganinya dengan baik)
  ```
- **`Symbol`:** Objek yang merepresentasikan operator atau identifier yang dideklarasikan di library Dart. Biasanya digunakan untuk _reflection_ atau _tree shaking_. Anda tidak akan sering menggunakannya dalam kode aplikasi sehari-hari.
  ```dart
  Symbol simbolContoh = #foobar; // # adalah sintaks untuk membuat Symbol
  print(simbolContoh); // Output: Symbol("foobar")
  ```

---

### 6\. Operator (Operators)

**Operator** adalah simbol khusus yang digunakan untuk melakukan operasi pada satu atau lebih nilai (disebut _operand_).

#### Operator Aritmatika

Digunakan untuk operasi matematika.

- `+` (Penjumlahan)
- `-` (Pengurangan)
- `*` (Perkalian)
- `/` (Pembagian, menghasilkan `double`)
- `~/` (Pembagian Integer, menghasilkan `int` - membuang sisa desimal)
- `%` (Modulus/Sisa Bagi)

<!-- end list -->

```dart
int a = 10;
int b = 3;

print(a + b);  // 13
print(a - b);  // 7
print(a * b);  // 30
print(a / b);  // 3.3333333333333335 (double)
print(a ~/ b); // 3 (int, hasil pembagian bulat)
print(a % b);  // 1 (sisa bagi)
```

#### Operator Kesetaraan dan Relasional

Digunakan untuk membandingkan nilai, menghasilkan `bool`.

- `==` (Sama dengan)
- `!=` (Tidak sama dengan)
- `>` (Lebih besar dari)
- `<` (Lebih kecil dari)
- `>=` (Lebih besar dari atau sama dengan)
- `<=` (Lebih kecil dari atau sama dengan)

<!-- end list -->

```dart
int x = 10;
int y = 5;

print(x == y); // false
print(x != y); // true
print(x > y);  // true
print(x < y);  // false
print(x >= y); // true
print(x <= y); // false
```

#### Operator Penugasan (Assignment Operators)

Digunakan untuk memberikan nilai ke variabel.

- `=` (Penugasan sederhana)
- `+=`, `-=`, `*=`, `/=`, `~/=`, `%=` (Penugasan dengan operasi)

<!-- end list -->

```dart
int jumlah = 5;
jumlah += 3; // jumlah = jumlah + 3; (sekarang 8)
print(jumlah); // 8

int poin = 100;
poin -= 20; // poin = poin - 20; (sekarang 80)
print(poin); // 80

String pesan = "Halo";
pesan += " Dunia!"; // pesan = pesan + " Dunia!"; (sekarang "Halo Dunia!")
print(pesan); // Halo Dunia!
```

#### Operator Logika

Digunakan untuk menggabungkan atau memodifikasi kondisi boolean.

- `&&` (AND Logika): Keduanya harus `true`.
- `||` (OR Logika): Salah satu harus `true`.
- `!` (NOT Logika): Membalik nilai boolean.

<!-- end list -->

```dart
bool isLogin = true;
bool isAdmin = false;

print(isLogin && isAdmin); // false (karena isAdmin false)
print(isLogin || isAdmin); // true (karena isLogin true)
print(!isLogin);          // false (membalik isLogin)
```

#### Operator Type Test

Digunakan untuk memeriksa tipe suatu objek pada _runtime_.

- `is`: Mengembalikan `true` jika objek adalah instance dari tipe yang ditentukan.
- `is!`: Mengembalikan `true` jika objek **bukan** instance dari tipe yang ditentukan.
- `as`: Melakukan _type casting_ (mengubah tipe) secara eksplisit. Hati-hati, jika casting tidak valid akan menyebabkan _runtime error_.

<!-- end list -->

```dart
dynamic data = "Halo";

if (data is String) {
  print("Data adalah string."); // Output: Data adalah string.
}

if (data is! int) {
  print("Data bukan integer."); // Output: Data bukan integer.
}

// Menggunakan 'as' (hati-hati)
Object obj = "Contoh";
String str = obj as String; // Aman karena obj memang String
print(str.length); // Output: 7

// int num = obj as int; // Ini akan menyebabkan runtime error jika obj bukan int
```

#### Operator Penugasan Null-Aware (`??=`)

- **Deskripsi:** Menetapkan nilai ke variabel hanya jika variabel tersebut saat ini `null`.
- **Sintaks Dasar:** `variable ??= value;`

<!-- end list -->

```dart
String? namaPengguna; // null secara default

namaPengguna ??= "Tamu"; // Karena namaPengguna null, akan diisi "Tamu"
print(namaPengguna);    // Output: Tamu

namaPengguna ??= "Admin"; // Tidak akan diisi karena namaPengguna sudah ada nilainya ("Tamu")
print(namaPengguna);    // Output: Tamu
```

#### Cascading Operator (`..`)

- **Deskripsi:** Memungkinkan Anda melakukan serangkaian operasi pada objek yang sama tanpa perlu berulang kali menulis nama objek. Ini membuat kode lebih ringkas dan mudah dibaca (sering disebut juga _builder pattern_ atau _fluent API_).
- **Sintaks Dasar:** `object..method1()..property = value..method2();`

<!-- end list -->

```dart
class MyButton {
  String text = "Default";
  int width = 100;
  int height = 50;

  void setText(String t) {
    text = t;
  }

  void setSize(int w, int h) {
    width = w;
    height = h;
  }

  void show() {
    print("Button: $text, Size: ${width}x$height");
  }
}

void contohCascading() {
  MyButton button = MyButton();
  button
    ..setText("Klik Saya")
    ..setSize(150, 75)
    ..text = "New Click"; // Bisa juga langsung akses properti
    // ..show(); // Tidak perlu menulis button.show()

  button.show(); // Output: Button: New Click, Size: 150x75
}
```

#### Spread Operator (`...` dan `...?`)

- **Deskripsi:** Digunakan untuk "menyebar" elemen-elemen dari sebuah koleksi (List, Set, Map) ke dalam koleksi lain. Sangat berguna untuk menggabungkan koleksi.
- **Sintaks Dasar:** `...collection` atau `...?collection` (untuk null-aware)

<!-- end list -->

```dart
void contohSpreadOperator() {
  List<int> list1 = [1, 2, 3];
  List<int> list2 = [4, 5, 6];

  // Menggabungkan list menggunakan spread operator
  List<int> combinedList = [...list1, ...list2, 7, 8];
  print(combinedList); // Output: [1, 2, 3, 4, 5, 6, 7, 8]

  Set<String> set1 = {"A", "B"};
  Set<String> set2 = {"B", "C"}; // 'B' duplikat akan diabaikan

  Set<String> combinedSet = {...set1, ...set2, "D"};
  print(combinedSet); // Output: {A, B, C, D} (urutan bisa bervariasi)

  Map<String, dynamic> map1 = {"nama": "Ani", "usia": 28};
  Map<String, dynamic> map2 = {"kota": "Bandung", "usia": 29}; // 'usia' akan ditimpa

  Map<String, dynamic> combinedMap = {...map1, ...map2, "pekerjaan": "Dokter"};
  print(combinedMap); // Output: {nama: Ani, usia: 29, kota: Bandung, pekerjaan: Dokter}

  // Null-aware spread operator (`...?`)
  List<int>? mungkinListNull = null;
  List<int> amanList = [10, ...?mungkinListNull, 20];
  print(amanList); // Output: [10, 20] (mungkinListNull tidak akan menyebabkan error)
}
```

#### Null-aware Access Operator (`?.`)

- **Deskripsi:** Digunakan untuk mengakses properti atau memanggil metode pada objek yang _mungkin_ `null`. Jika objeknya `null`, seluruh ekspresi akan mengevaluasi menjadi `null` daripada menyebabkan _runtime error_.
- **Sintaks Dasar:** `object?.property` atau `object?.method()`

<!-- end list -->

```dart
String? namaLengkap = null;
print(namaLengkap?.length); // Output: null (tidak error karena namaLengkap null)

namaLengkap = "Dewi";
print(namaLengkap?.length); // Output: 4 (sekarang namaLengkap tidak null)

List<String>? daftarHobi;
print(daftarHobi?.first); // Output: null

List<String>? daftarTeman = ["Budi", "Santi"];
print(daftarTeman?.first); // Output: Budi
```

#### Null Assertion Operator (`!`)

- **Deskripsi:** Memberi tahu kompiler Dart bahwa Anda yakin bahwa nilai variabel yang _nullable_ tidak akan pernah `null` pada titik eksekusi tertentu. Ini membatalkan fitur null safety secara eksplisit, tetapi jika Anda salah, ini akan menyebabkan _runtime error_.
- **Sintaks Dasar:** `variable!`

<!-- end list -->

```dart
String? email;

void kirimEmail() {
  // email = "user@example.com"; // Anggap ini diinisialisasi dari suatu tempat

  // print(email.length); // Error compile-time (email mungkin null)

  // Gunakan ! untuk memberitahu kompiler bahwa kita yakin email tidak null
  print(email!.length); // Hati-hati! Jika email sebenarnya null, ini akan crash.
}

// void main() {
//   // Jika Anda memanggil kirimEmail() tanpa menginisialisasi email, ini akan crash.
//   // kirimEmail(); // Contoh crash

//   email = "info@mail.com";
//   kirimEmail(); // Output: 14 (aman karena email sudah ada nilainya)
// }
```

**Peringatan:** Gunakan `!` dengan sangat hati-hati dan hanya jika Anda 100% yakin bahwa nilainya tidak akan `null` di titik itu. Jika tidak, lebih baik gunakan `?.` atau `??`.

---

### 7\. Kontrol Aliran (Control Flow)

**Kontrol aliran** adalah mekanisme yang memungkinkan program untuk membuat keputusan dan mengulang instruksi, sehingga program dapat merespons berbagai kondisi dan data.

#### Conditional Statements (Pernyataan Bersyarat)

Digunakan untuk menjalankan blok kode tertentu hanya jika kondisi tertentu terpenuhi.

##### `if`, `else if`, `else`

- **Deskripsi:** Memungkinkan eksekusi kode berdasarkan kondisi `true` atau `false`.
- **Sintaks Dasar:**
  ```dart
  if (condition1) {
    // Kode dijalankan jika condition1 true
  } else if (condition2) {
    // Kode dijalankan jika condition1 false DAN condition2 true
  } else {
    // Kode dijalankan jika semua kondisi di atas false
  }
  ```
- **Contoh:**

  ```dart
  int nilai = 75;

  if (nilai >= 90) {
    print("Nilai A");
  } else if (nilai >= 80) {
    print("Nilai B");
  } else if (nilai >= 70) {
    print("Nilai C"); // Output: Nilai C
  } else {
    print("Nilai D");
  }
  ```

##### `switch` dan `case`

- **Deskripsi:** Alternatif untuk `if-else if` berantai ketika Anda memiliki banyak kondisi yang didasarkan pada satu nilai tunggal.
- **Sintaks Dasar:**
  ```dart
  switch (expression) {
    case value1:
      // Kode jika expression == value1
      break; // Penting untuk mengakhiri case
    case value2:
      // Kode jika expression == value2
      break;
    default:
      // Kode jika tidak ada case yang cocok
  }
  ```
- **Contoh:**

  ```dart
  String hari = "Senin";

  switch (hari) {
    case "Senin":
      print("Hari kerja pertama.");
      break;
    case "Sabtu":
    case "Minggu": // Bisa menggabungkan case
      print("Akhir pekan!");
      break;
    default:
      print("Hari kerja biasa."); // Output: Hari kerja pertama.
  }
  ```

  **Catatan:** `break` sangat penting di setiap `case` untuk mencegah "fall-through" (eksekusi case berikutnya secara otomatis). Dart 3 memperkenalkan _pattern matching_ yang lebih kuat, memungkinkan `switch` expressions dan `if case`, yang akan dibahas lebih lanjut di topik lanjutan.

##### Ternary Operator (`condition ? expr1 : expr2`)

- **Deskripsi:** Cara ringkas untuk menulis pernyataan `if-else` sederhana yang mengembalikan nilai.
- **Sintaks Dasar:** `kondisi ? nilaiJikaTrue : nilaiJikaFalse;`
- **Contoh:**
  ```dart
  int umur = 17;
  String status = (umur >= 18) ? "Dewasa" : "Anak-anak";
  print(status); // Output: Anak-anak
  ```

#### Looping Statements (Pernyataan Perulangan)

Digunakan untuk mengulang blok kode berkali-kali.

##### `for` loop

- **Deskripsi:** Mengulang kode sejumlah kali yang ditentukan, biasanya dengan penghitung.
- **Sintaks Dasar:**
  ```dart
  for (initialization; condition; increment/decrement) {
    // Kode yang akan diulang
  }
  ```
- **Contoh:**
  ```dart
  for (int i = 0; i < 5; i++) {
    print("Iterasi ke-$i");
  }
  // Output:
  // Iterasi ke-0
  // Iterasi ke-1
  // Iterasi ke-2
  // Iterasi ke-3
  // Iterasi ke-4
  ```

##### `for-in` loop

- **Deskripsi:** Mengulang elemen-elemen dalam sebuah koleksi (List, Set).
- **Sintaks Dasar:**
  ```dart
  for (var element in collection) {
    // Kode yang akan diulang untuk setiap element
  }
  ```
- **Contoh:**
  ```dart
  List<String> buah = ["Apel", "Mangga", "Nanas"];
  for (var itemBuah in buah) {
    print("Saya suka $itemBuah");
  }
  // Output:
  // Saya suka Apel
  // Saya suka Mangga
  // Saya suka Nanas
  ```

##### `while` loop

- **Deskripsi:** Mengulang kode selama kondisi tertentu tetap `true`. Kondisi diperiksa sebelum setiap iterasi.
- **Sintaks Dasar:**
  ```dart
  while (condition) {
    // Kode yang akan diulang selama condition true
  }
  ```
- **Contoh:**
  ```dart
  int hitung = 0;
  while (hitung < 3) {
    print("Hitungan: $hitung");
    hitung++; // Jangan lupa mengubah kondisi agar loop berhenti
  }
  // Output:
  // Hitungan: 0
  // Hitungan: 1
  // Hitungan: 2
  ```

##### `do-while` loop

- **Deskripsi:** Mirip dengan `while`, tetapi blok kode akan dijalankan setidaknya satu kali sebelum kondisi diperiksa.
- **Sintaks Dasar:**
  ```dart
  do {
    // Kode yang akan diulang
  } while (condition);
  ```
- **Contoh:**
  ```dart
  int i = 0;
  do {
    print("Do-While Iterasi: $i"); // Akan dieksekusi minimal 1 kali
    i++;
  } while (i < 0); // Kondisi false, tapi sudah dieksekusi sekali
  // Output: Do-While Iterasi: 0
  ```

#### Break dan Continue

- **`break`:** Menghentikan eksekusi loop atau `switch` statement dan keluar dari blok tersebut.
  ```dart
  for (int i = 0; i < 10; i++) {
    if (i == 5) {
      break; // Hentikan loop saat i adalah 5
    }
    print(i);
  }
  // Output: 0, 1, 2, 3, 4
  ```
- **`continue`:** Melompati sisa iterasi saat ini dari loop dan melanjutkan ke iterasi berikutnya.
  ```dart
  for (int i = 0; i < 5; i++) {
    if (i == 2) {
      continue; // Lewati iterasi saat i adalah 2
    }
    print(i);
  }
  // Output: 0, 1, 3, 4 (2 dilewati)
  ```

---

### 8\. Fungsi (Functions)

**Fungsi** adalah blok kode yang dapat digunakan kembali untuk melakukan tugas tertentu. Mereka membantu mengorganisir kode, membuatnya lebih modular, mudah dibaca, dan mudah dipelihara.

#### Definisi Fungsi Dasar

- **Sintaks Dasar:**

  ```dart
  ReturnType functionName(ParameterType parameterName, ...) {
    // Body fungsi
    return value; // Optional, jika ReturnType bukan void
  }
  ```

  - `ReturnType`: Tipe data nilai yang akan dikembalikan oleh fungsi. Jika fungsi tidak mengembalikan apa-apa, gunakan `void`.
  - `functionName`: Nama fungsi (ikuti `camelCase`).
  - `ParameterType parameterName`: Daftar parameter yang diterima fungsi (opsional).

- **Contoh:**

  ```dart
  // Fungsi tanpa parameter, mengembalikan nilai String
  String getPesanSelamatDatang() {
    return "Selamat datang di aplikasi Dart!";
  }

  // Fungsi dengan parameter, tanpa nilai kembalian (void)
  void cetakNama(String nama) {
    print("Nama Anda: $nama");
  }

  // Fungsi dengan parameter dan nilai kembalian int
  int tambahDuaAngka(int a, int b) {
    return a + b;
  }

  void main() {
    print(getPesanSelamatDatang()); // Output: Selamat datang di aplikasi Dart!
    cetakNama("Budi");            // Output: Nama Anda: Budi
    int hasil = tambahDuaAngka(5, 7);
    print("Hasil penjumlahan: $hasil"); // Output: Hasil penjumlahan: 12
  }
  ```

#### Parameter Fungsi

Dart memiliki beberapa cara untuk menentukan parameter fungsi:

##### Required Positional Parameters

- **Deskripsi:** Parameter yang harus diberikan saat memanggil fungsi, dan urutannya penting.
- **Sintaks Dasar:** Sama seperti contoh di atas (`int a, int b`).

##### Optional Positional Parameters (`[]`)

- **Deskripsi:** Parameter yang opsional dan didefinisikan dalam kurung siku `[]`. Jika tidak diberikan, mereka akan memiliki nilai `null` (jika `nullable`) atau nilai _default_ yang ditentukan.
- **Sintaks Dasar:** `ReturnType functionName(Type requiredParam, [Type? optionalParam1, Type optionalParam2 = defaultValue])`

<!-- end list -->

```dart
void sapa(String nama, [String? ucapan, String kota = "Tidak Diketahui"]) {
  String pesan = "Halo, $nama";
  if (ucapan != null) {
    pesan += ", $ucapan";
  }
  pesan += " dari $kota.";
  print(pesan);
}

void main() {
  sapa("Andi");                      // Output: Halo, Andi dari Tidak Diketahui.
  sapa("Sinta", "Apa kabar?");       // Output: Halo, Sinta, Apa kabar? dari Tidak Diketahui.
  sapa("Joko", "Selamat pagi", "Surabaya"); // Output: Halo, Joko, Selamat pagi dari Surabaya.
}
```

##### Named Parameters (`{}`)

- **Deskripsi:** Parameter yang didefinisikan dalam kurung kurawal `{}`. Mereka bersifat opsional dan harus dipanggil menggunakan nama mereka (misalnya, `parameterName: value`). Urutan tidak penting.
- **Sintaks Dasar:** `ReturnType functionName({Type? namedParam1, Type namedParam2 = defaultValue})`

<!-- end list -->

```dart
double hitungVolume({double? panjang, double? lebar, double tinggi = 1.0}) {
  panjang ??= 1.0; // Jika null, gunakan 1.0
  lebar ??= 1.0;   // Jika null, gunakan 1.0
  return panjang * lebar * tinggi;
}

void main() {
  print(hitungVolume(panjang: 5, lebar: 3, tinggi: 2)); // Output: 30.0
  print(hitungVolume(panjang: 10));                     // Output: 10.0 (lebar dan tinggi default)
  print(hitungVolume(lebar: 4));                        // Output: 4.0
  print(hitungVolume());                                // Output: 1.0
}
```

##### Required Named Parameters (`required`)

- **Deskripsi:** Dalam kombinasi dengan _named parameters_, kata kunci `required` memaksa parameter bernama tersebut harus diberikan saat memanggil fungsi. Ini sering digunakan dalam konstruktor widget Flutter.
- **Sintaks Dasar:** `ReturnType functionName({required Type namedParam1, Type? namedParam2})`

<!-- end list -->

```dart
void tampilkanDetailProduk({required String namaProduk, required double harga, int stok = 0}) {
  print("Produk: $namaProduk, Harga: \$${harga.toStringAsFixed(2)}, Stok: $stok");
}

void main() {
  tampilkanDetailProduk(namaProduk: "Laptop", harga: 1200.0); // Output: Produk: Laptop, Harga: $1200.00, Stok: 0
  // tampilkanDetailProduk(harga: 50.0); // Error: The named parameter 'namaProduk' is required.
}
```

#### Fungsi sebagai First-Class Objects

- **Deskripsi:** Dalam Dart, fungsi adalah _first-class objects_. Ini berarti Anda dapat memperlakukan fungsi seperti variabel: Anda bisa menugaskannya ke variabel, meneruskannya sebagai argumen ke fungsi lain, atau mengembalikannya dari fungsi lain.
- **Contoh:**

  ```dart
  int penjumlahan(int a, int b) {
    return a + b;
  }

  void lakukanOperasi(int angka1, int angka2, Function operasi) {
    print("Hasil operasi: ${operasi(angka1, angka2)}");
  }

  void main() {
    Function op = penjumlahan; // Menugaskan fungsi ke variabel
    print(op(10, 5));           // Output: 15

    lakukanOperasi(20, 10, penjumlahan); // Meneruskan fungsi sebagai argumen
    // Output: Hasil operasi: 30
  }
  ```

#### Anonymous Functions (Fungsi Anonim) / Lambdas

- **Deskripsi:** Fungsi tanpa nama. Mereka sering digunakan sebagai argumen untuk fungsi lain, terutama saat bekerja dengan _callbacks_ atau _event handlers_.
- **Sintaks Dasar:** `(parameters) { body; }`

<!-- end list -->

```dart
void main() {
  List<String> daftarNama = ["Ani", "Budi", "Cici"];

  // Menggunakan fungsi anonim untuk mencetak setiap elemen
  daftarNama.forEach((nama) {
    print("Nama: $nama");
  });

  // Contoh fungsi anonim sebagai callback
  Future.delayed(Duration(seconds: 2), () {
    print("Pesan muncul setelah 2 detik!");
  });
}
```

#### Arrow Functions (Fungsi Panah)

- **Deskripsi:** Sintaks singkat untuk fungsi yang hanya memiliki satu _expression_ (baris). Berguna untuk fungsi-fungsi kecil yang mengembalikan nilai tunggal.
- **Sintaks Dasar:** `ReturnType functionName(parameters) => expression;`

<!-- end list -->

```dart
int kaliDua(int angka) => angka * 2;

void main() {
  print(kaliDua(7)); // Output: 14

  List<int> angkaAsli = [1, 2, 3];
  List<int> angkaKaliDua = angkaAsli.map((e) => e * 2).toList();
  print(angkaKaliDua); // Output: [2, 4, 6]
}
```

#### Return Values (Nilai Kembalian)

- **Deskripsi:** Fungsi dapat mengembalikan nilai menggunakan kata kunci `return`. Tipe nilai yang dikembalikan harus cocok dengan `ReturnType` yang dideklarasikan fungsi. Jika fungsi tidak mengembalikan apa-apa, tipenya adalah `void`.
- **Sintaks Dasar:**

  ```dart
  int getJumlah(int a, int b) {
    return a + b; // Mengembalikan nilai int
  }

  void cetakPesan() {
    print("Ini pesan.");
    // Tidak ada return statement, secara implisit mengembalikan void
  }
  ```

---

### 9\. Impor dan Ekspor (Imports & Exports)

Dart menggunakan sistem modul untuk mengatur kode. Anda dapat mengorganisir kode Anda ke dalam beberapa file (_library_) dan kemudian mengimpor atau mengekspor fungsionalitas antar file.

#### `import`

- **Deskripsi:** Digunakan untuk membawa fungsionalitas dari satu library (file Dart atau paket) ke dalam library saat ini.
- **Sintaks Dasar:**
  ```dart
  import 'package:nama_paket/nama_file.dart'; // Untuk paket dari pub.dev
  import 'dart:math'; // Untuk library bawaan Dart (SDK)
  import 'my_local_file.dart'; // Untuk file lokal di proyek yang sama
  ```
- **Contoh:**
  Misalkan Anda punya file `utils.dart`:

  ```dart
  // utils.dart
  double hitungLuasLingkaran(double radius) {
    return 3.14 * radius * radius;
  }
  ```

  Kemudian di `main.dart`:

  ```dart
  // main.dart
  import 'utils.dart'; // Mengimpor fungsi dari utils.dart

  void main() {
    print(hitungLuasLingkaran(5)); // Output: 78.5
  }
  ```

#### `export`

- **Deskripsi:** Digunakan untuk mengekspos fungsionalitas dari satu library melalui library lain. Ini sering digunakan untuk membuat "barrel file" yang mengekspor banyak file sekaligus, memudahkan impor.
- **Sintaks Dasar:** `export 'nama_file_yang_diekspor.dart';`
- **Contoh:**
  Misalkan Anda punya `models/user.dart` dan `models/product.dart`. Anda bisa membuat `models/models.dart` yang mengekspor keduanya:

  ```dart
  // models/user.dart
  class User { String name; User(this.name); }

  // models/product.dart
  class Product { String name; double price; Product(this.name, this.price); }

  // models/models.dart (barrel file)
  export 'user.dart';
  export 'product.dart';
  ```

  Kemudian di `main.dart`, Anda hanya perlu satu import:

  ```dart
  // main.dart
  import 'package:your_app/models/models.dart';

  void main() {
    User user = User("Alice");
    Product product = Product("Laptop", 1200.0);
    print(user.name);
    print(product.name);
  }
  ```

#### Prefix (`as`)

- **Deskripsi:** Jika Anda mengimpor dua library yang memiliki nama fungsi atau kelas yang sama, Anda bisa menggunakan `as` untuk memberikan _prefix_ (awalan) pada salah satunya, menghindari konflik nama.
- **Sintaks Dasar:** `import 'package:nama_paket/file_konflik.dart' as prefix;`

<!-- end list -->

```dart
// library_a.dart
void printPesan() { print("Pesan dari Library A"); }

// library_b.dart
void printPesan() { print("Pesan dari Library B"); }

// main.dart
import 'library_a.dart';
import 'library_b.dart' as libB; // Memberi prefix 'libB' pada library_b

void main() {
  printPesan();    // Memanggil printPesan() dari library_a (tanpa prefix)
                   // Output: Pesan dari Library A

  libB.printPesan(); // Memanggil printPesan() dari library_b (dengan prefix)
                     // Output: Pesan dari Library B
}
```

#### Show dan Hide (`show`, `hide`)

- **Deskripsi:** Memberikan kontrol yang lebih halus atas apa yang Anda impor dari sebuah library.
  - `show`: Hanya mengimpor item yang disebutkan.
  - `hide`: Mengimpor semua item kecuali yang disebutkan.
- **Sintaks Dasar:**
  ```dart
  import 'dart:math' show pi; // Hanya mengimpor 'pi' dari dart:math
  import 'dart:core' hide print; // Mengimpor semua dari dart:core kecuali 'print' (jarang dilakukan)
  ```

---

### 10\. Kata Kunci (Keywords)

**Kata kunci (Keywords)** adalah kata-kata yang memiliki makna khusus dalam bahasa Dart dan tidak dapat digunakan sebagai identifiers (nama variabel, fungsi, dll.). Anda telah melihat banyak dari mereka dalam penjelasan di atas.

Berikut adalah daftar lengkap (atau hampir lengkap) kata kunci di Dart:

- `abstract`
- `as`
- `assert`
- `async`
- `await`
- `break`
- `case`
- `catch`
- `class`
- `const`
- `continue`
- `covariant`
- `default`
- `deferred`
- `do`
- `dynamic`
- `else`
- `enum`
- `export`
- `extends`
- `extension`
- `external`
- `factory`
- `false`
- `final`
- `finally`
- `for`
- `Function`
- `get`
- `hide`
- `if`
- `implements`
- `import`
- `in` (bukan keyword di Dart, digunakan di `for-in` loop)
- `interface`
- `is`
- `late`
- `library`
- `mixin`
- `new` (opsional, bisa dihilangkan)
- `null`
- `on`
- `operator`
- `part`
- `required`
- `rethrow`
- `return`
- `set`
- `show`
- `static`
- `super`
- `switch`
- `sync`
- `this`
- `throw`
- `true`
- `try`
- `typedef`
- `var`
- `void`
- `while`
- `with`
- `yield`

**Catatan:** Beberapa kata kunci seperti `abstract`, `extends`, `implements`, `mixin`, `super`, `this`, `factory`, `get`, `set` akan dijelaskan lebih detail dalam topik **Object-Oriented Programming (OOP)**.

---

### 11\. Terminologi Kunci

- **Syntax (Sintaks):** Aturan tata bahasa dan struktur yang mengatur bagaimana kode harus ditulis agar valid dalam bahasa pemrograman.
- **`main()` Function:** Fungsi khusus yang menjadi titik awal eksekusi program Dart.
- **Statement:** Instruksi lengkap yang melakukan suatu tindakan, biasanya diakhiri dengan titik koma (`;`).
- **Expression:** Bagian dari kode yang mengevaluasi dan menghasilkan sebuah nilai.
- **Comments (Komentar):** Teks dalam kode yang diabaikan oleh kompiler, digunakan untuk menjelaskan kode kepada manusia.
- **Variable:** Nama simbolis untuk lokasi memori yang menyimpan nilai; tempat menyimpan data.
- **Declaration (Deklarasi):** Proses memberitahu Dart tentang nama dan tipe data variabel.
- **Initialization (Inisialisasi):** Proses memberikan nilai awal pada variabel saat dideklarasikan.
- **Identifier:** Nama yang diberikan kepada variabel, fungsi, kelas, dll.
- **`var`:** Kata kunci untuk deklarasi variabel dengan _type inference_.
- **`final`:** Kata kunci untuk variabel yang nilainya tidak dapat diubah setelah diinisialisasi (runtime constant).
- **`const`:** Kata kunci untuk variabel yang nilainya adalah konstanta waktu kompilasi (compile-time constant).
- **`late`:** Kata kunci untuk mendeklarasikan variabel non-nullable yang akan diinisialisasi nanti, sebelum digunakan.
- **Operator:** Simbol khusus yang melakukan operasi pada nilai.
- **Operand:** Nilai yang dioperasikan oleh operator.
- **Control Flow (Kontrol Aliran):** Mekanisme yang mengendalikan urutan eksekusi instruksi dalam program.
- **Conditional Statements:** Pernyataan yang menjalankan kode berdasarkan kondisi (`if`, `else`, `switch`).
- **Looping Statements:** Pernyataan yang mengulang blok kode (`for`, `while`, `do-while`).
- **Function (Fungsi):** Blok kode yang dapat digunakan kembali untuk melakukan tugas tertentu.
- **Parameter:** Variabel yang digunakan untuk menerima input ke dalam fungsi.
- **Return Value:** Nilai yang dikembalikan oleh fungsi setelah dieksekusi.
- **Anonymous Function (Fungsi Anonim):** Fungsi tanpa nama.
- **Arrow Function:** Sintaks singkat untuk fungsi satu baris.
- **Import:** Mengimpor fungsionalitas dari library lain.
- **Export:** Mengekspos fungsionalitas dari satu library melalui library lain.
- **Keyword:** Kata-kata yang memiliki makna khusus dalam bahasa dan tidak dapat digunakan sebagai identifier.

---

### 12\. Ringkasan

**Syntax Fundamentals** adalah fondasi Anda dalam menulis kode Dart. Memahami bagaimana struktur program dibuat, cara mendeklarasikan variabel, menggunakan operator, mengontrol aliran program, dan mendefinisikan fungsi adalah langkah awal yang krusial.

Anda telah belajar tentang:

- Pentingnya `main()` sebagai titik awal program.
- Perbedaan antara `statements` (instruksi) dan `expressions` (nilai).
- Cara menggunakan komentar untuk mendokumentasikan kode Anda.
- Berbagai cara mendeklarasikan variabel (`var`, `final`, `const`, `late`, tipe eksplisit) dan bagaimana Null Safety memengaruhinya.
- Tipe data bawaan di Dart dan bagaimana menggunakannya.
- Berbagai jenis operator untuk melakukan operasi pada data.
- Bagaimana mengendalikan alur eksekusi program dengan `if/else`, `switch`, dan berbagai jenis loop.
- Cara mendefinisikan dan menggunakan fungsi, termasuk berbagai jenis parameter dan fungsi anonim.
- Bagaimana mengelola organisasi kode dengan `import` dan `export`.
- Daftar kata kunci yang dicadangkan di Dart.

Dengan bekal pemahaman ini, Anda sudah bisa mulai menulis program Dart yang sederhana. Langkah selanjutnya adalah menggabungkan pengetahuan ini dengan prinsip **Object-Oriented Programming (OOP)** untuk membangun aplikasi yang lebih terstruktur dan kompleks.

---

### 13\. Sumber Referensi

- **Dart Documentation - A tour of the Dart language (relevant sections):** [https://dart.dev/guides/language/language-tour](https://dart.dev/guides/language/language-tour)
  - Variables
  - Built-in types
  - Functions
  - Operators
  - Control flow statements
  - Classes (akan dibahas di OOP)
  - Libraries and visibility
- **Dart Documentation - Keywords:** [https://dart.dev/guides/language/language-tour\#keywords](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23keywords)
- **Dart Documentation - Effective Dart (Style Guide):** [https://dart.dev/guides/language/effective-dart/style](https://dart.dev/guides/language/effective-dart/style) (penting untuk konvensi penamaan)

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../../../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../../../dasar/comentar/README.md
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
