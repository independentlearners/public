# [Typing System][0]

Ini adalah konsep fundamental yang sangat penting untuk dipahami, tidak hanya dalam Dart, tetapi juga dalam banyak bahasa pemrograman modern lainnya.

<details>
  <summary>📃 Daftar Isi</summary>

- [Typing System](#typing-system)
    - [1. Pendahuluan: Apa itu Typing System?](#1-pendahuluan-apa-itu-typing-system)
      - [Analogi Sederhana](#analogi-sederhana)
      - [Mengapa Penting dalam Pemrograman?](#mengapa-penting-dalam-pemrograman)
    - [2. Tipe Data (Data Types)](#2-tipe-data-data-types)
      - [Apa itu Tipe Data?](#apa-itu-tipe-data)
      - [Kategori Tipe Data](#kategori-tipe-data)
        - [Tipe Data Primitif (Primitive Data Types)](#tipe-data-primitif-primitive-data-types)
          - [Contoh dalam Dart:](#contoh-dalam-dart)
        - [Tipe Data Koleksi (Collection Data Types)](#tipe-data-koleksi-collection-data-types)
          - [Contoh dalam Dart:](#contoh-dalam-dart-1)
        - [Tipe Data Khusus (Special Data Types)](#tipe-data-khusus-special-data-types)
          - [Contoh dalam Dart:](#contoh-dalam-dart-2)
        - [Tipe Data Didefinisikan Pengguna (User-Defined Data Types)](#tipe-data-didefinisikan-pengguna-user-defined-data-types)
          - [Contoh dalam Dart:](#contoh-dalam-dart-3)
    - [3. Kategori Typing System](#3-kategori-typing-system)
      - [Strong vs. Weak Typing](#strong-vs-weak-typing)
        - [Strong Typing](#strong-typing)
        - [Weak Typing](#weak-typing)
          - [Perbandingan Contoh:](#perbandingan-contoh)
        - [Dart: Bahasa dengan Strong Typing](#dart-bahasa-dengan-strong-typing)
      - [Static vs. Dynamic Typing](#static-vs-dynamic-typing)
        - [Static Typing](#static-typing)
        - [Dynamic Typing](#dynamic-typing)
          - [Perbandingan Contoh:](#perbandingan-contoh-1)
        - [Dart: Kombinasi Static dan Dynamic Typing](#dart-kombinasi-static-dan-dynamic-typing)
      - [Explicit vs. Implicit Typing](#explicit-vs-implicit-typing)
        - [Explicit Typing](#explicit-typing)
        - [Implicit Typing (Type Inference)](#implicit-typing-type-inference)
          - [Dart: Mendukung Keduanya](#dart-mendukung-keduanya)
    - [4. Keuntungan Menggunakan Typing System yang Kuat (Strong \& Static)](#4-keuntungan-menggunakan-typing-system-yang-kuat-strong--static)
      - [Meningkatkan Keandalan Kode (Reliability)](#meningkatkan-keandalan-kode-reliability)
      - [Deteksi Kesalahan Lebih Awal](#deteksi-kesalahan-lebih-awal)
      - [Memudahkan Pemeliharaan dan Refactoring](#memudahkan-pemeliharaan-dan-refactoring)
      - [Dokumentasi Kode yang Lebih Jelas](#dokumentasi-kode-yang-lebih-jelas)
      - [Peningkatan Performa (Potensial)](#peningkatan-performa-potensial)
      - [Dukungan Tooling yang Lebih Baik](#dukungan-tooling-yang-lebih-baik)
    - [5. Tantangan dan Pertimbangan](#5-tantangan-dan-pertimbangan)
    - [6. Studi Kasus: Typing System dalam Dart](#6-studi-kasus-typing-system-dalam-dart)
      - [Type Safety dalam Dart](#type-safety-dalam-dart)
      - [`dynamic` Keyword](#dynamic-keyword)
      - [`var` Keyword (Type Inference)](#var-keyword-type-inference)
      - [`Object` Class](#object-class)
      - [Null Safety](#null-safety)
      - [Generics](#generics)
    - [7. Terminologi Kunci](#7-terminologi-kunci)
    - [8. Ringkasan](#8-ringkasan)
    - [9. Sumber Referensi](#9-sumber-referensi)

</details>

---

### 1\. Pendahuluan: Apa itu Typing System?

Dalam pemrograman, **Typing System** (Sistem Tipe Penulisan) adalah satu set aturan yang digunakan oleh sebuah bahasa pemrograman untuk **mengklasifikasikan berbagai jenis nilai (data)** yang dapat digunakan dalam program, seperti angka, teks, daftar, dan sebagainya. Sistem ini juga mengatur bagaimana nilai-nilai dari tipe yang berbeda dapat berinteraksi satu sama lain.

Bayangkan setiap informasi yang kita gunakan dalam hidup memiliki "jenis" atau "kategori"nya sendiri. Misalnya, angka adalah satu jenis, teks adalah jenis lain, tanggal adalah jenis lain lagi. Typing system dalam pemrograman melakukan hal yang sama: ia memberikan label atau "tipe" pada setiap data yang kita gunakan.

#### Analogi Sederhana

Bayangkan Anda memiliki beberapa wadah di dapur Anda:

- Wadah untuk **garam** (tipe: Padatan, Rasa: Asin)
- Wadah untuk **minyak** (tipe: Cairan, Konsistensi: Kental)
- Wadah untuk **gula** (tipe: Padatan, Rasa: Manis)

Setiap wadah dirancang untuk jenis isian tertentu, dan Anda tahu apa yang bisa Anda lakukan dengan setiap isian (misalnya, Anda tidak akan mencoba minum garam seperti minyak).

Dalam pemrograman:

- **Wadah** = Variabel
- **Isian** = Nilai (data)
- **Jenis isian** = Tipe Data (misalnya, `int` untuk bilangan bulat, `String` untuk teks, `double` untuk bilangan desimal).

Typing system adalah aturan yang memastikan Anda menaruh jenis isian yang benar di wadah yang benar, dan hanya melakukan operasi yang masuk akal dengan jenis isian tersebut (misalnya, Anda tidak bisa "menambahkan" teks dengan angka secara langsung seperti `"hello" + 5` tanpa konversi khusus).

#### Mengapa Penting dalam Pemrograman?

Typing system membantu **mencegah kesalahan**, **meningkatkan keandalan kode**, dan **membuat kode lebih mudah dibaca serta dipelihara**. Tanpa typing system, program akan sangat rentan terhadap kesalahan yang sulit dideteksi dan diperbaiki.

---

### 2\. Tipe Data (Data Types)

Sebelum membahas sistemnya, mari kita pahami blok bangunan utamanya: **Tipe Data**.

#### Apa itu Tipe Data?

**Tipe Data** adalah klasifikasi yang memberi tahu komputer jenis nilai apa yang akan disimpan dan bagaimana nilai tersebut harus ditafsirkan. Setiap nilai dalam program komputer memiliki tipe data tertentu.

Misalnya:

- Angka `5` adalah bilangan bulat (integer).
- Teks `"Halo dunia"` adalah string.
- Nilai `true` atau `false` adalah boolean.

Pentingnya tipe data adalah karena komputer menyimpan setiap jenis informasi secara berbeda di dalam memori sistem. Sebuah angka disimpan secara berbeda dari sebuah teks, meskipun keduanya mungkin terlihat serupa bagi kita. Tipe data memberitahu komputer berapa banyak ruang memori yang dibutuhkan dan bagaimana menafsirkan bit-bit di dalam memori tersebut.

#### Kategori Tipe Data

Tipe data dapat dikategorikan menjadi beberapa jenis utama:

##### Tipe Data Primitif (Primitive Data Types)

Ini adalah tipe data dasar yang menjadi fondasi dalam sebuah bahasa pemrograman. Mereka biasanya menyimpan nilai tunggal dan tidak dapat dipecah menjadi tipe yang lebih kecil.

###### Contoh dalam Dart:

- **`int` (Integer):** Digunakan untuk menyimpan bilangan bulat (tanpa desimal).
  - **Deskripsi:** Merepresentasikan bilangan bulat 64-bit.
  - **Sintaks Dasar:**
    ```dart
    int usia = 30;
    int jumlahApel = -5;
    ```
- **`double` (Floating-Point Number):** Digunakan untuk menyimpan bilangan desimal.
  - **Deskripsi:** Merepresentasikan bilangan desimal 64-bit (double-precision floating-point numbers).
  - **Sintaks Dasar:**
    ```dart
    double harga = 19.99;
    double pi = 3.14159;
    ```
- **`String` (Text):** Digunakan untuk menyimpan urutan karakter (teks).
  - **Deskripsi:** Merepresentasikan urutan karakter Unicode. String di Dart adalah objek yang tidak dapat diubah (immutable).
  - **Sintaks Dasar:**
    ```dart
    String nama = "Budi";
    String salam = 'Halo dunia!'; // Bisa pakai kutip tunggal atau ganda
    String multiLine = '''
    Ini adalah
    string multi-baris.
    ''';
    ```
- **`bool` (Boolean):** Digunakan untuk menyimpan nilai kebenaran: `true` (benar) atau `false` (salah).
  - **Deskripsi:** Merepresentasikan nilai boolean.
  - **Sintaks Dasar:**
    ```dart
    bool isAktif = true;
    bool isSelesai = false;
    ```
- **`num` (Number):** Ini adalah superclass untuk `int` dan `double`. Anda bisa menggunakan `num` jika Anda tidak peduli apakah itu integer atau double, asalkan itu adalah angka.
  - **Deskripsi:** Kelas abstrak untuk semua tipe numerik.
  - **Sintaks Dasar:**
    ```dart
    num angka = 10; // Bisa int
    angka = 10.5; // Bisa double
    ```

##### Tipe Data Koleksi (Collection Data Types)

Digunakan untuk menyimpan banyak nilai dalam satu variabel. Mereka adalah struktur data yang memungkinkan pengorganisasian dan manipulasi kumpulan data.

###### Contoh dalam Dart:

- **`List`** Dalam bahasa pemrogramana lain disebut: **(Array):** Koleksi yang terurut dari objek. Setiap elemen memiliki indeks (posisi) yang unik.
  - **Deskripsi:** Mirip dengan array dalam bahasa lain. Mendukung elemen duplikat.
  - **Sintaks Dasar:**
    ```dart
    List<String> namaMahasiswa = ["Andi", "Budi", "Cici"];
    List<int> angkaGenap = [2, 4, 6, 8];
    List<dynamic> campuran = [1, "dua", true]; // List yang bisa berisi tipe data berbeda
    ```
- **`Set`:** Koleksi unik dari objek. Tidak ada urutan dan tidak ada elemen duplikat.
  - **Deskripsi:** Berguna ketika Anda perlu memastikan setiap elemen dalam koleksi unik.
  - **Sintaks Dasar:**
    ```dart
    Set<int> nomorUnik = {1, 2, 3, 2}; // Akan disimpan sebagai {1, 2, 3}
    Set<String> buah = {"Apel", "Jeruk", "Apel"}; // Akan disimpan sebagai {"Apel", "Jeruk"}
    ```
- **`Map` (Dictionary/Hash Map):** Koleksi pasangan kunci-nilai (key-value pairs). Setiap kunci harus unik.
  - **Deskripsi:** Mirip dengan dictionary di Python atau objek di JavaScript.
  - **Sintaks Dasar:**
    ```dart
    Map<String, String> kamus = {
      "apel": "buah",
      "kucing": "hewan",
    };
    Map<String, dynamic> user = {
      "nama": "Dina",
      "usia": 25,
      "isMahasiswa": true,
    };
    ```
- **`Iterable`:** Kelas abstrak yang merepresentasikan urutan elemen yang dapat diiterasi (dilalui). `List` dan `Set` adalah contoh `Iterable`.
  - **Deskripsi:** Ini bukan tipe data yang langsung Anda instansiasi, melainkan sebuah antarmuka yang diimplementasikan oleh koleksi yang bisa dilalui elemennya.
  - **Sintaks Dasar:**
    ```dart
    Iterable<int> angka = [1, 2, 3, 4].where((e) => e.isEven); // Hasilnya Iterable
    print(angka); // (2, 4)
    ```

##### Tipe Data Khusus (Special Data Types)

Tipe data yang memiliki fungsi atau representasi khusus dalam bahasa.

###### Contoh dalam Dart:

- **`null`:** Merepresentasikan ketiadaan nilai (tidak ada nilai).
  - **Deskripsi:** Di Dart, `null` adalah objek. Dengan _Null Safety_ (akan dijelaskan nanti), tipe data secara default tidak bisa `null` kecuali Anda secara eksplisit mengizinkannya dengan `?`.
  - **Sintaks Dasar:**
    ```dart
    String? namaDepan = null; // String yang bisa null
    int? nomorRumah;         // Secara default null jika tidak diinisialisasi dan diizinkan null
    ```
- **`dynamic`:** Tipe yang sangat fleksibel. Variabel dengan tipe `dynamic` dapat menyimpan nilai apa pun, dan tipe aslinya tidak diperiksa saat kompilasi.
  - **Deskripsi:** Memberikan fleksibilitas seperti bahasa _dynamically-typed_, tetapi mengorbankan _type safety_ saat kompilasi.
  - **Sintaks Dasar:**
    ```dart
    dynamic x = "Halo";
    x = 123;
    x = true;
    ```
- **`Object`:** Ini adalah superclass dari semua tipe data di Dart (kecuali `null` yang memiliki tipe `Null`). Artinya, setiap nilai di Dart adalah objek.
  - **Deskripsi:** Jika Anda mendeklarasikan variabel sebagai `Object`, ia bisa menyimpan nilai apa pun. Mirip dengan `dynamic` tetapi dengan beberapa perbedaan dalam perilaku _runtime_.
  - **Sintaks Dasar:**
    ```dart
    Object obj1 = 10;
    Object obj2 = "Dart";
    Object obj3 = [1, 2, 3];
    ```

##### Tipe Data Didefinisikan Pengguna (User-Defined Data Types)

Tipe data ini dibuat oleh programmer berdasarkan kebutuhan aplikasi, biasanya dengan menggabungkan tipe data primitif atau tipe data lain.

###### Contoh dalam Dart:

- **`class` (Kelas):** Blueprint (cetak biru) untuk membuat objek. Mendefinisikan struktur dan perilaku objek.

  - **Deskripsi:** Dasar dari pemrograman berorientasi objek (OOP) di Dart.
  - **Sintaks Dasar:**

    ```dart
    class Mobil {
      String merek;
      int tahun;

      Mobil(this.merek, this.tahun); // Constructor

      void nyalakanMesin() {
        print("$merek mesin menyala!");
      }
    }

    // Penggunaan:
    Mobil mobilSaya = Mobil("Toyota", 2020);
    print(mobilSaya.merek); // Toyota
    mobilSaya.nyalakanMesin(); // Toyota mesin menyala!
    ```

- **`enum` (Enumerasi):** Tipe data khusus yang memungkinkan Anda menentukan daftar nilai konstanta yang diberi nama.

  - **Deskripsi:** Berguna untuk merepresentasikan pilihan terbatas.
  - **Sintaks Dasar:**

    ```dart
    enum Hari {
      senin,
      selasa,
      rabu,
      kamis,
      jumat,
      sabtu,
      minggu,
    }

    // Penggunaan:
    Hari hariIni = Hari.senin;
    print(hariIni); // Hari.senin
    ```

- **`typedef` (Type Alias):** Memberikan nama alias untuk tipe fungsi atau tipe lain yang kompleks.

  - **Deskripsi:** Berguna untuk membuat kode lebih mudah dibaca dan dipelihara ketika berurusan dengan tipe yang panjang atau kompleks.
  - **Sintaks Dasar:**

    ```dart
    // Mendefinisikan alias untuk tipe fungsi yang mengembalikan String dan menerima int
    typedef String PengolahAngka(int angka);

    String ubahKeString(int a) {
      return a.toString();
    }

    void cetakHasil(PengolahAngka proses, int nilai) {
      print("Hasil: ${proses(nilai)}");
    }

    // Penggunaan:
    cetakHasil(ubahKeString, 10); // Hasil: 10
    ```

- **`extension` (Ekstensi):** Memungkinkan Anda menambahkan fungsionalitas ke tipe data yang sudah ada (bahkan yang bukan milik Anda) tanpa perlu mewarisinya atau memodifikasi kode sumber aslinya.

  - **Deskripsi:** Fitur yang sangat berguna untuk memperluas fungsionalitas tipe data standar.
  - **Sintaks Dasar:**

    ```dart
    extension StringExtensions on String {
      String capitalize() {
        if (this.isEmpty) return this;
        return this[0].toUpperCase() + this.substring(1);
      }
    }

    // Penggunaan:
    String nama = "budi";
    print(nama.capitalize()); // Budi
    ```

---

### 3\. Kategori Typing System

Typing system dapat dikategorikan berdasarkan beberapa dimensi utama:

#### Strong vs. Weak Typing

Kategori ini berkaitan dengan **seberapa ketat bahasa memaksakan aturan tipe** dan **seberapa mudah sebuah nilai dapat diubah dari satu tipe ke tipe lain** (konversi tipe atau _type coercion_).

##### Strong Typing

- **Deskripsi:** Bahasa dengan _strong typing_ lebih ketat dalam penegakan aturan tipe. Ini berarti konversi tipe data (misalnya, mengubah angka menjadi string) harus dilakukan secara eksplisit oleh programmer. Bahasa tidak akan secara otomatis mencoba mengonversi tipe data secara implisit jika ada potensi kehilangan data atau kebingungan.
- **Manfaat:** Membantu mencegah banyak kesalahan umum (misalnya, mencoba melakukan operasi matematika pada string) karena programmer dipaksa untuk sadar akan tipe data dan melakukan konversi dengan sengaja. Ini meningkatkan keandalan kode.
- **Contoh Bahasa:** Dart, Java, C\#, Python (meskipun Python memiliki beberapa fleksibilitas).

##### Weak Typing

- **Deskripsi:** Bahasa dengan _weak typing_ lebih longgar dalam penegakan aturan tipe. Bahasa ini akan sering mencoba melakukan konversi tipe data secara otomatis (implisit) untuk mengakomodasi operasi tertentu.
- **Risiko:** Potensi untuk bug yang sulit dideteksi karena konversi implisit bisa menghasilkan hasil yang tidak terduga.
- **Contoh Bahasa:** JavaScript, PHP, VBScript.

###### Perbandingan Contoh:

Misalkan Anda memiliki sebuah angka `5` dan sebuah string `"10"`.

**Dengan Strong Typing (misalnya, Dart):**

```dart
int angka = 5;
String teks = "10";

// print(angka + teks); // Ini akan error saat kompilasi!
// Operator '+' tidak bisa digunakan untuk 'int' dan 'String'.

// Anda harus mengonversi secara eksplisit:
print(angka + int.parse(teks)); // Output: 15 (string "10" diubah jadi int 10)
print(angka.toString() + teks); // Output: "510" (int 5 diubah jadi string "5")
```

Dart akan memberitahu Anda dengan jelas bahwa Anda tidak dapat menjumlahkan `int` dan `String`. Anda harus secara eksplisit mengonversi salah satu tipe agar operasi dapat dilakukan.

**Dengan Weak Typing (misalnya, JavaScript):**

```javascript
let angka = 5;
let teks = "10";

console.log(angka + teks); // Output: "510" (angka 5 diubah jadi string "5" secara implisit)
console.log(angka - teks); // Output: -5 (string "10" diubah jadi angka 10 secara implisit)
```

JavaScript secara otomatis mencoba menebak apa yang Anda inginkan. Untuk `+`, ia melihat salah satu operan adalah string, jadi ia mengonversi angka menjadi string dan melakukan konkatenasi. Untuk `-`, ia melihatnya sebagai operasi matematika, jadi ia mengonversi string menjadi angka. Ini bisa menyebabkan perilaku tak terduga jika Anda tidak memahami aturan konversi implisit bahasa tersebut.

##### Dart: Bahasa dengan Strong Typing

Dart adalah bahasa dengan **Strong Typing**. Ini berarti Dart sangat peduli dengan tipe data. Anda tidak bisa begitu saja melakukan operasi antar tipe yang tidak kompatibel tanpa konversi eksplisit. Ini adalah salah satu alasan mengapa Dart (dan Flutter) terkenal dengan stabilitas dan kemudahan dalam deteksi bug.

#### Static vs. Dynamic Typing

Kategori ini berkaitan dengan **kapan pemeriksaan tipe dilakukan**: saat program ditulis/dikompilasi (_compile-time_) atau saat program berjalan (_runtime_).

##### Static Typing

- **Deskripsi:** Dalam bahasa dengan _static typing_, tipe dari setiap variabel ditentukan dan diperiksa pada waktu kompilasi (sebelum program dijalankan). Jika ada ketidakcocokan tipe, kompiler akan langsung memberikan error, dan program tidak akan bisa dikompilasi atau dijalankan.
- **Manfaat:**
  - **Deteksi Kesalahan Awal:** Banyak bug terkait tipe dapat ditemukan sebelum program dijalankan, menghemat waktu debugging.
  - **Keandalan Kode:** Meningkatkan keandalan karena Anda yakin tipe data akan konsisten selama eksekusi.
  - **Dukungan Tooling:** IDE (Integrated Development Environment) dapat memberikan _autocompletion_ yang lebih baik, _refactoring_ yang lebih aman, dan navigasi kode yang lebih mudah karena mereka tahu tipe setiap variabel.
  - **Potensi Performa:** Kompiler bisa mengoptimalkan kode lebih baik karena sudah tahu tipe data yang akan diproses.
- **Contoh Bahasa:** Java, C\#, C++, Go, Swift.

##### Dynamic Typing

- **Deskripsi:** Dalam bahasa dengan _dynamic typing_, tipe dari variabel tidak diperiksa sampai program dijalankan (_runtime_). Variabel dapat menyimpan nilai dari tipe apa pun, dan tipenya dapat berubah selama eksekusi program. Jika ada ketidakcocokan tipe, error akan terjadi saat program mencoba menjalankan baris kode tersebut.
- **Manfaat:**
  - **Fleksibilitas:** Lebih cepat untuk prototyping dan penulisan kode karena tidak perlu mendeklarasikan tipe eksplisit.
  - **Kode yang Lebih Ringkas:** Mengurangi _boilerplate_ kode (kode standar yang harus ditulis berulang kali).
- **Risiko:**
  - **Deteksi Kesalahan Lambat:** Bug terkait tipe hanya akan muncul saat runtime, yang bisa berarti setelah program diserahkan ke pengguna.
  - **Debugging Lebih Sulit:** Kesalahan tipe bisa muncul di bagian yang tidak terduga.
- **Contoh Bahasa:** Python, JavaScript, Ruby, PHP.

###### Perbandingan Contoh:

**Dengan Static Typing (misalnya, Dart dengan tipe eksplisit):**

```dart
void main() {
  String nama = "Alice";
  // nama = 123; // Error saat kompilasi! A value of type 'int' can't be assigned to a variable of type 'String'.
  print(nama);
}
```

Kompiler Dart akan langsung memberi tahu Anda bahwa Anda mencoba menugaskan `int` ke `String`.

**Dengan Dynamic Typing (misalnya, Python):**

```python
nama = "Alice"
nama = 123 # Ini tidak akan error
print(nama) # Output: 123
```

Python (secara dinamis) tidak akan keberatan. Variabel `nama` akan berubah tipe dari string menjadi integer saat runtime. Jika ada bagian kode lain yang mengharapkan `nama` selalu string, bug akan terjadi di sana.

##### Dart: Kombinasi Static dan Dynamic Typing

Dart adalah bahasa yang **statically-typed**, tetapi memiliki fleksibilitas **dynamic typing** melalui beberapa fitur:

- **Defaultnya Static-Typed:** Ketika Anda mendeklarasikan variabel dengan tipe eksplisit (`String nama;`, `int usia;`), Dart akan memeriksa tipe saat kompilasi. Ini adalah praktik terbaik dan paling umum di Dart.
- **Type Inference (`var`):** Dart juga memiliki fitur _type inference_ menggunakan kata kunci `var`. Ketika Anda menggunakan `var`, Dart akan secara otomatis menentukan tipe data variabel berdasarkan nilai awal yang Anda berikan. Setelah tipenya ditentukan, variabel itu bersifat _statically-typed_.
  ```dart
  var pesan = "Halo"; // Dart menginferensikan 'pesan' sebagai String
  // pesan = 123; // Error saat kompilasi! 'int' cannot be assigned to 'String'.
  ```
- **`dynamic` Keyword:** Untuk kasus di mana Anda benar-benar membutuhkan fleksibilitas _dynamic typing_, Dart menyediakan kata kunci `dynamic`. Variabel yang dideklarasikan sebagai `dynamic` akan melewatkan pemeriksaan tipe saat kompilasi dan hanya diperiksa saat runtime.
  ```dart
  dynamic nilai = "abc";
  print(nilai.length); // OK, runtime check. Output: 3
  nilai = 123;
  // print(nilai.length); // Error saat runtime! int tidak punya properti length
  ```
  Meskipun `dynamic` menawarkan fleksibilitas, penggunaannya harus hati-hati karena dapat menunda deteksi bug hingga runtime.

#### Explicit vs. Implicit Typing

Kategori ini berkaitan dengan **bagaimana tipe data dideklarasikan** dalam kode.

##### Explicit Typing

- **Deskripsi:** Programmer secara _eksplisit_ (langsung) menuliskan tipe data untuk setiap variabel, parameter fungsi, atau nilai yang dikembalikan.
- **Manfaat:** Kode menjadi lebih jelas, mudah dibaca, dan memberikan dokumentasi yang jelas tentang tipe data yang diharapkan.
- **Sintaks Dasar di Dart:**

  ```dart
  String namaLengkap = "John Doe"; // Tipe String ditulis eksplisit
  int hitungan = 0;              // Tipe int ditulis eksplisit

  double hitungDiskon(double hargaAsli, double persentase) { // Tipe parameter dan return ditulis eksplisit
    return hargaAsli * (persentase / 100);
  }
  ```

##### Implicit Typing (Type Inference)

- **Deskripsi:** Programmer tidak secara eksplisit menuliskan tipe data. Bahasa pemrograman secara _implisit_ (otomatis) menentukan atau "menginferensikan" tipe data berdasarkan nilai yang ditugaskan ke variabel.
- **Manfaat:** Kode bisa menjadi lebih ringkas dan cepat ditulis.
- **Sintaks Dasar di Dart:**
  - Menggunakan `var`:
    ```dart
    var nama = "Alice";    // Dart menginferensikan 'nama' sebagai String
    var umur = 25;         // Dart menginferensikan 'umur' sebagai int
    var isReady = true;    // Dart menginferensikan 'isReady' sebagai bool
    ```
    **Penting:** Setelah diinferensikan, tipe variabel `var` tidak dapat diubah. `var nama;` tanpa inisialisasi akan inferensi `dynamic` (sejak Dart 2.12 dengan Null Safety).
  - Menggunakan `final` dan `const`: Keduanya juga mendukung _type inference_ dan biasanya lebih disukai daripada `var` untuk variabel yang tidak akan berubah.
    ```dart
    final kota = "Jakarta"; // Dart menginferensikan 'kota' sebagai String
    const PI = 3.14;        // Dart menginferensikan 'PI' sebagai double
    ```

###### Dart: Mendukung Keduanya

Dart mendukung **Explicit Typing** dan **Implicit Typing**. Meskipun `var` (implicit typing) dapat membuat kode lebih ringkas, praktik terbaik dalam Dart adalah sering menggunakan **explicit typing** untuk variabel lokal jika itu meningkatkan keterbacaan dan kejelasan, atau menggunakan `final`/`const` dengan _type inference_ untuk nilai yang tidak akan berubah. Untuk parameter fungsi dan nilai kembalian fungsi, **explicit typing** hampir selalu digunakan.

---

### 4\. Keuntungan Menggunakan Typing System yang Kuat (Strong & Static)

Seperti yang dimiliki Dart, memiliki typing system yang kuat (strong dan statis, dengan opsi fleksibilitas) membawa banyak manfaat:

#### Meningkatkan Keandalan Kode (Reliability)

- Dengan aturan tipe yang ketat, program cenderung lebih stabil. Kesalahan tipe yang umum, seperti mencoba memanggil metode string pada angka, akan dicegah.

#### Deteksi Kesalahan Lebih Awal

- Kesalahan tipe terdeteksi saat waktu kompilasi, bukan saat program berjalan. Ini berarti bug ditemukan dan diperbaiki jauh lebih cepat dalam siklus pengembangan. Bayangkan menemukan masalah saat Anda pertama kali mengetik kode, bukan setelah pengguna mengeluh bahwa aplikasi Anda crash.

#### Memudahkan Pemeliharaan dan Refactoring

- Ketika Anda mengubah struktur kode, typing system yang kuat membantu memastikan bahwa perubahan Anda tidak merusak bagian lain dari program. Kompiler akan memberi tahu Anda di mana saja Anda perlu menyesuaikan kode karena perubahan tipe. Ini sangat berharga dalam proyek besar atau tim yang bekerja sama.

#### Dokumentasi Kode yang Lebih Jelas

- Deklarasi tipe data yang eksplisit berfungsi sebagai bentuk dokumentasi mandiri. Ketika Anda melihat `String namaPengguna;` atau `int hitungTotal(List<int> item)`, Anda langsung tahu apa yang diharapkan dan apa yang akan dikembalikan oleh fungsi tersebut, tanpa perlu membaca komentar tambahan.

#### Peningkatan Performa (Potensial)

- Karena kompiler sudah mengetahui tipe data pada waktu kompilasi, ia dapat melakukan optimasi yang lebih baik. Ini bisa berarti kode yang dihasilkan lebih efisien dan berjalan lebih cepat karena tidak perlu melakukan pemeriksaan tipe saat runtime sesering mungkin.

#### Dukungan Tooling yang Lebih Baik

- IDE (seperti VS Code atau Android Studio dengan plugin Dart/Flutter) dapat memanfaatkan informasi tipe ini untuk memberikan fitur canggih:
  - **Autocompletion:** Menyarankan metode atau properti yang relevan untuk objek tertentu.
  - **Error Highlighting:** Menandai kesalahan sintaksis atau tipe saat Anda mengetik.
  - **Refactoring:** Membantu Anda mengubah nama variabel, mengekstrak metode, atau melakukan operasi refactoring lainnya dengan lebih aman.
  - **Navigasi Kode:** Melompat ke definisi variabel atau fungsi dengan mudah.

---

### 5\. Tantangan dan Pertimbangan

Meskipun banyak keuntungannya, typing system yang kuat juga memiliki beberapa pertimbangan:

- **Verbositas (Kejelasan yang Terkadang Berlebihan):** Terkadang, Anda mungkin merasa harus menulis lebih banyak kode (deklarasi tipe eksplisit) dibandingkan dengan bahasa yang _dynamically-typed_. Namun, manfaat jangka panjangnya biasanya jauh melebihi ini.
- **Kurva Pembelajaran Awal:** Bagi programmer yang terbiasa dengan bahasa _dynamically-typed_ (seperti JavaScript tanpa TypeScript), transisi ke bahasa _statically-typed_ mungkin memerlukan penyesuaian karena Anda harus lebih sadar akan tipe data sejak awal.
- **Fleksibilitas Terbatas (jika tidak ditangani dengan baik):** Dalam beberapa kasus, terutama saat bekerja dengan data yang strukturnya tidak dapat diketahui sebelumnya (misalnya, data JSON dari API), typing system yang sangat kaku bisa menjadi tantangan. Namun, Dart mengatasi ini dengan baik melalui fitur seperti `dynamic`, `Object`, dan _generics_.

---

### 6\. Studi Kasus: Typing System dalam Dart

Mari kita lihat lebih dekat bagaimana Dart mengimplementasikan dan memanfaatkan typing system-nya.

#### Type Safety dalam Dart

Dart adalah bahasa yang **type-safe**. Ini berarti bahwa sebagian besar kesalahan terkait tipe akan terdeteksi pada waktu kompilasi (_compile-time_) oleh _analyzer_ Dart atau saat kompilasi JIT/AOT. Jika sebuah program tidak _type-safe_, itu tidak akan dapat berjalan. Ini adalah fondasi yang kokoh untuk membangun aplikasi yang andal.

#### `dynamic` Keyword

Seperti yang dijelaskan sebelumnya, `dynamic` adalah "jalan keluar" dari _type safety_ yang ketat. Jika Anda mendeklarasikan variabel sebagai `dynamic`, pemeriksaan tipe untuk variabel itu akan ditunda hingga _runtime_.

```dart
void contohDynamic() {
  dynamic nilai = "Ini adalah string";
  print(nilai.length); // OK, karena String punya properti length. Output: 17

  nilai = 123;
  // print(nilai.length); // Ini akan error saat runtime!
                        // Karena int tidak punya properti length.
                        // Kompiler tidak akan protes.

  print("Tipe nilai saat ini: ${nilai.runtimeType}"); // Output: Tipe nilai saat ini: int
}
```

**Kapan Menggunakan `dynamic`?**

- Ketika berinteraksi dengan data eksternal yang strukturnya tidak pasti (misalnya, parsing JSON yang sangat bervariasi).
- Saat melakukan prototyping cepat dan Anda tidak ingin terlalu memikirkan tipe.
- **Peringatan:** Gunakan `dynamic` dengan bijak. Terlalu banyak penggunaan `dynamic` akan mengurangi manfaat _type safety_ Dart dan dapat menyebabkan bug yang sulit dilacak.

#### `var` Keyword (Type Inference)

`var` adalah fitur kenyamanan yang memungkinkan Dart untuk secara otomatis menentukan tipe variabel berdasarkan nilai yang diinisialisasi.

```dart
void contohVar() {
  var pesan = "Halo dunia"; // Dart menginferensikan pesan sebagai String
  print(pesan.runtimeType); // Output: String

  var jumlah = 100;        // Dart menginferensikan jumlah sebagai int
  print(jumlah.runtimeType); // Output: int

  // pesan = 50; // Error: A value of type 'int' can't be assigned to a variable of type 'String'.
                  // Karena Dart sudah menentukan 'pesan' sebagai String.
}
```

`var` masih menghasilkan variabel _statically-typed_. Setelah tipenya diinferensikan, ia tetap dengan tipe tersebut. Ini berbeda dengan `dynamic` yang bisa berubah tipe.

#### `Object` Class

Setiap tipe data di Dart (kecuali `Null`) secara implisit mewarisi dari kelas `Object`. Ini berarti Anda bisa mendeklarasikan variabel sebagai `Object` dan ia bisa menampung nilai apa pun.

```dart
void contohObject() {
  Object item = "Buku";
  print(item.runtimeType); // Output: String

  item = 123.45;
  print(item.runtimeType); // Output: double

  // item.length; // Error: The getter 'length' isn't defined for the type 'Object'.
                 // Karena kompiler hanya tahu 'item' adalah Object,
                 // dan Object tidak punya properti 'length'.
                 // Anda harus melakukan type casting atau check terlebih dahulu.

  if (item is double) {
    print("Item adalah double: $item");
  }

  // Type casting:
  String nama = "Alice";
  Object objNama = nama;
  String namaDariObj = objNama as String; // Melakukan casting eksplisit
  print(namaDariObj.length); // Output: 5
}
```

**Perbedaan `Object` vs `dynamic`:**

- Ketika Anda menggunakan `Object`, Dart masih melakukan pemeriksaan tipe _compile-time_. Anda hanya dapat memanggil metode atau mengakses properti yang tersedia pada kelas `Object` (seperti `toString()`, `hashCode`, `runtimeType`). Untuk mengakses metode yang spesifik untuk tipe asli objek, Anda perlu melakukan _type casting_ atau _type checking_ (seperti `item is double` atau `item as String`).
- Ketika Anda menggunakan `dynamic`, Dart tidak melakukan pemeriksaan tipe _compile-time_ untuk operasi apa pun. Pemeriksaan ditunda sampai _runtime_. Ini memberikan lebih banyak fleksibilitas tetapi dengan risiko bug _runtime_.

#### Null Safety

**Null Safety** adalah fitur kunci dalam Dart (dimulai dari Dart 2.12) yang sangat meningkatkan _type safety_. Ini memastikan bahwa variabel tidak dapat berisi nilai `null` secara tidak sengaja, yang merupakan penyebab umum dari _runtime errors_ (dikenal sebagai _NullPointerException_ atau _null reference errors_ di bahasa lain).

- **Secara default, variabel non-nullable:** Artinya, sebuah variabel yang dideklarasikan dengan tipe tertentu (misalnya `String`, `int`) **tidak boleh** berisi `null` kecuali Anda secara eksplisit mengizinkannya.
- **Mengizinkan Null (`?`):** Untuk mengizinkan variabel berisi `null`, Anda harus menambahkan tanda tanya (`?`) setelah tipe data.

<!-- end list -->

```dart
void contohNullSafety() {
  String nama = "Andi";
  // nama = null; // Error saat kompilasi! A value of type 'Null' can't be assigned to a variable of type 'String'.

  String? alamat = "Jakarta"; // Variabel ini bisa null
  alamat = null; // OK

  int usia = 30;
  // int? tinggi; // Variabel ini bisa null, jika tidak diinisialisasi akan jadi null

  String? pesan;
  // print(pesan.length); // Error saat kompilasi! Karena 'pesan' mungkin null.
                         // Harus dicek dulu atau menggunakan operator null-aware.

  // Operator null-aware:
  print(pesan?.length); // Output: null (jika pesan null, ekspresi jadi null)
  print(pesan ?? "Tidak ada pesan"); // Output: Tidak ada pesan (jika pesan null, gunakan nilai default)

  // ! (Bang operator / null assertion operator): Memberitahu Dart bahwa Anda yakin nilai tidak null
  String? mungkinNama = "Budi";
  String wajibNama = mungkinNama!; // Hati-hati! Jika mungkinNama null, ini akan crash di runtime.
}
```

**Manfaat Null Safety:**

- **Menghilangkan Null Reference Error:** Mengurangi secara drastis salah satu jenis bug _runtime_ yang paling umum.
- **Meningkatkan Kejelasan Kode:** Programmer lebih jelas tentang apakah sebuah variabel bisa `null` atau tidak.
- **Dukungan Tooling yang Lebih Baik:** Analisis statis dapat membantu mendeteksi potensi masalah `null` bahkan sebelum kode dijalankan.

#### Generics

**Generics** adalah fitur dalam typing system yang memungkinkan Anda menulis kode yang dapat bekerja dengan berbagai tipe data tanpa kehilangan _type safety_. Mereka memungkinkan Anda mendefinisikan kelas, fungsi, atau antarmuka yang dapat bekerja dengan tipe data umum, lalu Anda menentukan tipe data spesifik saat menggunakan kelas/fungsi tersebut.

- **Deskripsi:** Bayangkan sebuah cetakan kue. Cetakan itu bisa digunakan untuk membuat kue cokelat, kue vanila, atau kue stroberi. Cetakan itu generik; Anda menentukan rasa kue saat Anda menggunakannya. Dalam kode, generics memungkinkan Anda membuat "cetakan" untuk kelas atau fungsi yang dapat beroperasi pada tipe data yang berbeda.
- **Sintaks Dasar:** Menggunakan kurung sudut (`<T>`) untuk mendefinisikan parameter tipe. `T` adalah konvensi untuk "Type".

<!-- end list -->

```dart
// Contoh List: List<E> di mana E adalah tipe elemen
List<String> daftarNama = ["Alice", "Bob"];
List<int> daftarAngka = [1, 2, 3];

// Contoh fungsi generik
T getFirstElement<T>(List<T> list) {
  return list[0];
}

void contohGenerics() {
  print(getFirstElement<String>(["Apel", "Jeruk"])); // Output: Apel
  print(getFirstElement<int>([10, 20, 30]));      // Output: 10

  // Anda juga bisa membuat kelas generik
  Kotak<String> stringKotak = Kotak("Halo");
  print(stringKotak.ambilIsi()); // Output: Halo

  Kotak<int> intKotak = Kotak(123);
  print(intKotak.ambilIsi()); // Output: 123
}

class Kotak<T> {
  T _isi;

  Kotak(this._isi);

  T ambilIsi() {
    return _isi;
  }
}
```

**Manfaat Generics:**

- **Type Safety:** Memungkinkan Anda menggunakan koleksi atau fungsi dengan tipe data yang berbeda tanpa harus menggunakan `dynamic` atau `Object`, sehingga mempertahankan _type safety_ saat kompilasi.
- **Reusabilitas Kode:** Anda dapat menulis kode yang lebih umum dan dapat digunakan kembali untuk berbagai tipe.
- **Meningkatkan Keterbacaan:** Kode lebih jelas tentang tipe data apa yang diharapkan dan diproses.

---

### 7\. Terminologi Kunci

- **Tipe Data (Data Type):** Klasifikasi yang memberi tahu komputer jenis nilai apa yang akan disimpan dan bagaimana menafsirkan nilai tersebut.
- **Strong Typing:** Bahasa yang ketat dalam penegakan aturan tipe; konversi tipe harus eksplisit.
- **Weak Typing:** Bahasa yang longgar dalam penegakan aturan tipe; sering melakukan konversi tipe implisit.
- **Static Typing:** Pemeriksaan tipe dilakukan saat kompilasi (sebelum program dijalankan).
- **Dynamic Typing:** Pemeriksaan tipe dilakukan saat runtime (saat program berjalan).
- **Explicit Typing:** Programmer secara langsung menuliskan tipe data.
- **Implicit Typing (Type Inference):** Bahasa secara otomatis menentukan tipe data berdasarkan nilai.
- **Compile-time:** Tahap di mana kode sumber diubah menjadi kode yang dapat dieksekusi oleh komputer. Pemeriksaan tipe statis terjadi di sini.
- **Runtime:** Tahap di mana program sedang dieksekusi. Pemeriksaan tipe dinamis terjadi di sini.
- **Type Safety:** Properti sebuah bahasa pemrograman yang mencegah kesalahan tipe atau perilaku tak terduga yang disebabkan oleh ketidakcocokan tipe.
- **Null Safety:** Fitur dalam Dart yang memastikan variabel tidak secara tidak sengaja berisi nilai `null`, mencegah _null reference errors_.
- **Generics:** Fitur yang memungkinkan kode (kelas, fungsi, antarmuka) untuk beroperasi dengan berbagai tipe data sambil mempertahankan _type safety_.
- **Type Casting (Type Conversion):** Proses mengubah nilai dari satu tipe data ke tipe data lain secara eksplisit.
- **Type Coercion:** Proses mengubah nilai dari satu tipe data ke tipe data lain secara implisit (otomatis oleh bahasa).

---

### 8\. Ringkasan

Typing system adalah tulang punggung keandalan dan pemeliharaan kode dalam banyak bahasa pemrograman modern, termasuk Dart. Dengan memahami perbedaan antara _strong_ vs _weak_, _static_ vs _dynamic_, dan _explicit_ vs _implicit_ typing, Anda akan memiliki fondasi yang kuat untuk menulis kode Dart yang efektif, aman, dan mudah dipelihara.

Dart secara alami adalah bahasa yang **statically-typed** dan **strongly-typed**, yang berarti ia memprioritaskan deteksi kesalahan awal dan keandalan. Namun, ia juga menawarkan fleksibilitas melalui _type inference_ (`var`, `final`, `const`) dan kata kunci `dynamic` untuk kasus-kasus khusus. Fitur-fitur seperti **Null Safety** dan **Generics** lebih lanjut memperkuat _type safety_ Dart, menjadikannya pilihan yang sangat baik untuk membangun aplikasi skala besar yang stabil, terutama dengan Flutter.

Penguasaan konsep-konsep ini akan memungkinkan Anda untuk tidak hanya menggunakan Dart, tetapi juga memahami mengapa dan bagaimana Dart dirancang, membantu Anda membuat keputusan desain yang lebih baik dalam proyek Anda.

---

### 9\. Sumber Referensi

- **Dart Documentation - A tour of the Dart language:** [https://dart.dev/guides/language/language-tour](https://dart.dev/guides/language/language-tour) (Lihat bagian "Built-in types", "Variables", "Sound null safety", "Generics")
- **Dart Documentation - Understanding null safety:** [https://dart.dev/null-safety/understanding-null-safety](https://dart.dev/null-safety/understanding-null-safety)
- **Wikipedia - Type system:** [https://en.wikipedia.org/wiki/Type_system](https://en.wikipedia.org/wiki/Type_system)
- **Wikipedia - Type safety:** [https://en.wikipedia.org/wiki/Type_safety](https://en.wikipedia.org/wiki/Type_safety)

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
