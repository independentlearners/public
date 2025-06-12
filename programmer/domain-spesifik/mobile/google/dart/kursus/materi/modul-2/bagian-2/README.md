# Variables dan Constants

Ini adalah konsep kunci yang memungkinkan Anda menyimpan dan mengelola data dalam program Anda. Tanpa mereka, program akan sangat statis dan tidak bisa berinteraksi dengan informasi dinamis.

<details>
  <summary>📃 Daftar Isi</summary>


- [Variables dan Constants](#variables-dan-constants)
    - [1. Pendahuluan: Apa itu Variabel dan Konstanta?](#1-pendahuluan-apa-itu-variabel-dan-konstanta)
      - [Analogi Sederhana](#analogi-sederhana)
      - [Mengapa Variabel dan Konstanta Penting?](#mengapa-variabel-dan-konstanta-penting)
    - [2. Variabel (Variables)](#2-variabel-variables)
      - [Definisi Variabel](#definisi-variabel)
      - [Deklarasi dan Inisialisasi Variabel](#deklarasi-dan-inisialisasi-variabel)
        - [Deklarasi Tipe Eksplisit](#deklarasi-tipe-eksplisit)
        - [Type Inference dengan `var`](#type-inference-dengan-var)
      - [Aturan Penamaan Variabel (Identifiers)](#aturan-penamaan-variabel-identifiers)
      - [Tipe Data Variabel](#tipe-data-variabel)
      - [Null Safety pada Variabel](#null-safety-pada-variabel)
        - [Variabel Non-Nullable (Default)](#variabel-non-nullable-default)
        - [Variabel Nullable (`?`)](#variabel-nullable-)
        - [Penggunaan Null-Aware Operators (`?.`, `??`, `??=`, `!`)](#penggunaan-null-aware-operators----)
    - [3. Konstanta (Constants)](#3-konstanta-constants)
      - [Kata Kunci `final`](#kata-kunci-final)
        - [Ciri-ciri `final`:](#ciri-ciri-final)
        - [Sintaks dan Contoh `final`:](#sintaks-dan-contoh-final)
        - [Kapan Menggunakan `final`?](#kapan-menggunakan-final)
      - [Kata Kunci `const`](#kata-kunci-const)
        - [Ciri-ciri `const`:](#ciri-ciri-const)
        - [Sintaks dan Contoh `const`:](#sintaks-dan-contoh-const)
        - [Kapan Menggunakan `const`?](#kapan-menggunakan-const)
      - [Perbedaan Utama antara `final` dan `const`](#perbedaan-utama-antara-final-dan-const)
      - [Contoh Perbandingan `final` dan `const`](#contoh-perbandingan-final-dan-const)
    - [4. Kata Kunci `late`](#4-kata-kunci-late)
      - [Definisi `late`](#definisi-late)
      - [Ciri-ciri `late`:](#ciri-ciri-late)
      - [Sintaks dan Contoh `late`:](#sintaks-dan-contoh-late)
      - [Kapan Menggunakan `late`?](#kapan-menggunakan-late)
      - [Peringatan Penggunaan `late`](#peringatan-penggunaan-late)
    - [5. Lingkup Variabel (Variable Scope)](#5-lingkup-variabel-variable-scope)
      - [Apa itu Scope?](#apa-itu-scope)
      - [Global Scope (Top-Level Variables)](#global-scope-top-level-variables)
      - [Function/Local Scope](#functionlocal-scope)
      - [Block Scope](#block-scope)
      - [Class Scope (Instance Variables)](#class-scope-instance-variables)
      - [Static Scope (Class-Level Variables)](#static-scope-class-level-variables)
    - [6. Terminologi Kunci](#6-terminologi-kunci)
    - [7. Ringkasan](#7-ringkasan)
    - [8. Sumber Referensi](#8-sumber-referensi)

</details>

---

### 1\. Pendahuluan: Apa itu Variabel dan Konstanta?

Dalam pemrograman, kita sering perlu menyimpan potongan informasi atau data untuk digunakan nanti. Di sinilah **variabel** dan **konstanta** berperan. Mereka adalah _tempat penampung_ bernama di dalam memori komputer tempat kita bisa menyimpan nilai.

#### Analogi Sederhana

Bayangkan lemari dapur Anda:

- **Variabel** itu seperti wadah penyimpanan makanan yang bisa Anda buka, ganti isinya (misalnya, dari gula ke tepung), dan kemudian ditutup kembali. Label pada wadah adalah nama variabel, dan isinya adalah nilai variabel. Anda bisa mengubah isinya kapan saja.
- **Konstanta** itu seperti kaleng makanan yang tersegel. Setelah disegel di pabrik dengan isian tertentu (misalnya, sup kalengan), Anda tidak bisa mengganti isiannya. Anda hanya bisa membukanya dan menggunakan isian aslinya. Nilai konstanta tidak bisa diubah setelah pertama kali ditetapkan.

#### Mengapa Variabel dan Konstanta Penting?

1.  **Penyimpanan Data:** Mereka memungkinkan program menyimpan dan memanipulasi data seperti angka, teks, atau objek kompleks.
2.  **Fleksibilitas:** Variabel memungkinkan program untuk menjadi dinamis, artinya dapat bekerja dengan data yang berbeda setiap kali dijalankan atau merespons input pengguna.
3.  **Keterbacaan Kode:** Menggunakan nama yang bermakna untuk variabel dan konstanta membuat kode lebih mudah dipahami daripada menggunakan nilai mentah secara langsung.
4.  **Pemeliharaan Kode:** Jika sebuah nilai yang digunakan berkali-kali perlu diubah, Anda hanya perlu mengubahnya di satu tempat (deklarasi variabel/konstanta) daripada di setiap tempat nilai itu digunakan.
5.  **Keamanan dan Keandalan:** Konstanta memastikan bahwa nilai-nilai penting tidak sengaja diubah, mengurangi potensi bug.

---

### 2\. Variabel (Variables)

#### Definisi Variabel

**Variabel** adalah lokasi memori yang diberi nama di mana Anda dapat menyimpan nilai. Nilai yang disimpan dalam variabel dapat **berubah** selama eksekusi program.

#### Deklarasi dan Inisialisasi Variabel

Sebelum Anda dapat menggunakan variabel, Anda harus **mendeklarasikannya**. Deklarasi memberitahu Dart tentang nama variabel dan tipe data yang akan disimpannya. Anda juga dapat **menginisialisasinya** (memberikan nilai awal) saat deklarasi.

##### Deklarasi Tipe Eksplisit

Ini adalah cara paling jelas untuk mendeklarasikan variabel, di mana Anda secara langsung menuliskan **tipe data** diikuti oleh **nama variabel**.

- **Sintaks Dasar:**

  ```dart
  DataType variableName; // Deklarasi saja
  DataType variableName = initialValue; // Deklarasi dan inisialisasi
  ```

  - `DataType`: Merujuk pada tipe data yang akan disimpan oleh variabel (misalnya, `int`, `String`, `double`, `bool`, `List<String>`, dll.).
  - `variableName`: Nama yang Anda berikan untuk variabel tersebut.
  - `initialValue`: Nilai awal yang Anda tetapkan.

- **Contoh:**

  ```dart
  String namaPengguna; // Deklarasi variabel 'namaPengguna' bertipe String
  namaPengguna = "Alice"; // Inisialisasi/penugasan nilai

  int usia = 30; // Deklarasi dan inisialisasi variabel 'usia' bertipe int

  double suhu = 25.5; // Deklarasi dan inisialisasi variabel 'suhu' bertipe double

  bool isAktif = true; // Deklarasi dan inisialisasi variabel 'isAktif' bertipe bool

  List<String> daftarHobi = ["membaca", "menulis", "berenang"]; // Deklarasi dan inisialisasi List
  ```

##### Type Inference dengan `var`

Dart memiliki fitur yang disebut **Type Inference**. Anda dapat menggunakan kata kunci `var` untuk mendeklarasikan variabel, dan kompiler Dart akan secara otomatis **menyimpulkan (infer)** tipe data variabel berdasarkan nilai yang Anda berikan saat inisialisasi.

- **Sintaks Dasar:**
  ```dart
  var variableName = initialValue; // Deklarasi dan inisialisasi dengan inferensi tipe
  ```
- **Contoh:**

  ```dart
  var nama = "Budi";      // Dart menginferensikan 'nama' sebagai String
  print(nama.runtimeType); // Output: String

  var jumlah = 100;       // Dart menginferensikan 'jumlah' sebagai int
  print(jumlah.runtimeType); // Output: int

  var pi = 3.14;          // Dart menginferensikan 'pi' sebagai double
  print(pi.runtimeType);  // Output: double

  // Penting: Setelah tipenya diinferensikan, tipe variabel 'var' tidak bisa diubah.
  // nama = 50; // ERROR: A value of type 'int' can't be assigned to a variable of type 'String'.
  ```

- **Kapan Menggunakan `var`:** Umumnya digunakan untuk variabel lokal di dalam fungsi di mana tipe datanya sudah sangat jelas dari nilai inisialisasinya, atau untuk mengurangi sedikit "keramaian" pada kode. Untuk parameter fungsi, nilai kembalian, dan properti kelas, deklarasi tipe eksplisit lebih disukai untuk kejelasan.

#### Aturan Penamaan Variabel (Identifiers)

Nama variabel (dan juga fungsi, kelas, dll.) disebut **identifiers**. Dart memiliki aturan dan konvensi penamaan yang harus diikuti:

1.  **Karakter yang Diizinkan:** Identifiers dapat berisi huruf (a-z, A-Z), angka (0-9), dan underscore (`_`).
2.  **Tidak Dimulai dengan Angka:** Identifier tidak boleh dimulai dengan angka.
    - ✅ `nama1`, `_hitung`
    - ❌ `1nama`
3.  **Tidak Ada Spasi:** Identifier tidak boleh mengandung spasi.
    - ✅ `jumlahBarang`
    - ❌ `jumlah barang`
4.  **Bukan Kata Kunci:** Identifier tidak boleh menggunakan kata kunci yang dicadangkan oleh Dart (misalnya, `if`, `for`, `class`).
5.  **Sensitif Terhadap Huruf Besar/Kecil:** Dart adalah bahasa yang _case-sensitive_. `namaVariabel` berbeda dengan `Namavariabel`.
6.  **Konvensi Penamaan (Disarankan):**
    - **`camelCase`:** Ini adalah konvensi standar untuk nama variabel, fungsi, dan parameter di Dart. Dimulai dengan huruf kecil, dan setiap kata berikutnya dimulai dengan huruf kapital.
      ```dart
      String namaLengkapPengguna;
      int totalPembelianHariIni;
      ```
    - **`PascalCase`:** Digunakan untuk nama kelas dan `enum`. Setiap kata dimulai dengan huruf kapital.
      ```dart
      class DataPelanggan;
      enum StatusPesanan;
      ```
    - **`snake_case`:** Kadang digunakan untuk nama file (misalnya, `user_model.dart`).

#### Tipe Data Variabel

Seperti yang sudah kita bahas di bagian **Typing System**, setiap variabel di Dart memiliki tipe data. Ini penting karena tipe data menentukan jenis nilai yang dapat disimpan oleh variabel dan operasi apa yang dapat dilakukan padanya.

```dart
int angka = 10;           // Menyimpan bilangan bulat
double desimal = 10.5;    // Menyimpan bilangan desimal
String teks = "Halo";     // Menyimpan urutan karakter
bool benarSalah = true;   // Menyimpan nilai kebenaran (true/false)
List<int> daftar = [1, 2, 3]; // Menyimpan daftar bilangan bulat
Map<String, String> kamus = {"kunci": "nilai"}; // Menyimpan pasangan kunci-nilai
```

#### Null Safety pada Variabel

Fitur **Null Safety** di Dart (mulai Dart 2.12) adalah salah satu peningkatan terbesar dalam sistem tipe. Ini dirancang untuk membantu Anda menghindari _null reference errors_ (error yang terjadi ketika Anda mencoba mengakses properti atau metode pada objek yang sebenarnya `null`).

##### Variabel Non-Nullable (Default)

- **Deskripsi:** Secara _default_, semua variabel di Dart adalah **non-nullable**. Artinya, setelah dideklarasikan, mereka harus memiliki nilai non-`null`. Anda harus menginisialisasikannya atau Dart akan memberikan _compile-time error_.
- **Sintaks dan Contoh:**

  ```dart
  String nama;
  // print(nama); // ERROR: Non-nullable variable 'nama' must be assigned before it can be used.
                 // Anda harus menginisialisasinya terlebih dahulu.

  String namaLengkap = "John Doe"; // OK, diinisialisasi
  int usia = 25; // OK, diinisialisasi
  ```

##### Variabel Nullable (`?`)

- **Deskripsi:** Jika Anda benar-benar ingin variabel Anda bisa menyimpan nilai `null`, Anda harus secara eksplisit menandainya sebagai **nullable** dengan menambahkan tanda tanya (`?`) setelah tipe datanya.
- **Sintaks dan Contoh:**

  ```dart
  String? alamat; // Variabel 'alamat' sekarang bisa berisi String atau null
  print(alamat);  // Output: null (karena belum diinisialisasi dan diizinkan null)

  alamat = "Jl. Sudirman No. 10"; // OK, diisi dengan nilai String
  print(alamat); // Output: Jl. Sudirman No. 10

  alamat = null; // OK, diisi dengan null
  print(alamat); // Output: null

  int? jumlahPengguna; // Variabel 'jumlahPengguna' bisa int atau null
  jumlahPengguna = 10;
  jumlahPengguna = null;
  ```

##### Penggunaan Null-Aware Operators (`?.`, `??`, `??=`, `!`)

Ketika Anda memiliki variabel _nullable_, Dart memaksa Anda untuk menangani kemungkinan bahwa nilainya adalah `null` sebelum Anda mencoba mengakses properti atau metode di dalamnya. Ini dilakukan menggunakan operator _null-aware_:

- **Null-aware access (`?.`)**: Mengakses properti atau metode hanya jika objeknya bukan `null`. Jika objeknya `null`, seluruh ekspresi akan mengevaluasi menjadi `null` daripada menyebabkan error.

  ```dart
  String? pesan = null;
  print(pesan?.length); // Output: null (tidak error)

  pesan = "Halo";
  print(pesan?.length); // Output: 4
  ```

- **Null-aware coalescing (`??`)**: Memberikan nilai _default_ jika ekspresi di sebelah kiri adalah `null`.

  ```dart
  String? namaDepan = null;
  String namaTampilan = namaDepan ?? "Anonim"; // Jika namaDepan null, gunakan "Anonim"
  print(namaTampilan); // Output: Anonim

  String? namaBelakang = "Wijaya";
  String namaLengkap = namaBelakang ?? "Tanpa Nama";
  print(namaLengkap); // Output: Wijaya
  ```

- **Null-aware assignment (`??=`)**: Menetapkan nilai ke variabel hanya jika variabel tersebut saat ini `null`.

  ```dart
  String? kota;
  kota ??= "Jakarta"; // kota sekarang "Jakarta"
  print(kota); // Output: Jakarta

  kota ??= "Bandung"; // kota tetap "Jakarta" karena sudah ada nilainya
  print(kota); // Output: Jakarta
  ```

- **Null assertion operator (`!`)**: Memberi tahu kompiler bahwa Anda yakin sebuah ekspresi non-`null` pada saat itu. Ini akan membuat ekspresi tersebut non-nullable. **Gunakan dengan sangat hati-hati**, karena jika Anda salah dan ekspresi itu ternyata `null`, program akan _crash_ saat runtime.

  ```dart
  String? email = "user@example.com";
  String domain = email!.split('@')[1]; // Anda yakin email tidak null, jadi bisa langsung akses
  print(domain); // Output: example.com

  String? alamatPengiriman = null;
  // String jalan = alamatPengiriman!.substring(0, 5); // Ini akan CRASH!
                                                    // Karena alamatPengiriman sebenarnya null.
  ```

  **Gambar Visual untuk Null Safety:**

  ```mermaid
  graph TD
      A[Variabel Dideklarasikan] --> B{Apakah Tipe Diikuti '?'?};
      B -- Ya --> C[Variabel adalah Nullable];
      B -- Tidak --> D[Variabel adalah Non-Nullable (Default)];
      C --> E{Apakah Variabel Null?};
      D --> F[Variabel TIDAK BOLEH Null];
      E -- Ya --> G[Anda TIDAK BISA langsung akses properti/method];
      E -- Tidak --> H[Anda BISA langsung akses properti/method];
      G -- Gunakan '?.', '??', '??=' --> I[Aman, tidak crash jika null];
      G -- Gunakan '!' (Hati-hati!) --> J[Berisiko crash jika null saat runtime];
      F --> K[Harus diinisialisasi dengan nilai non-null];
      K --> L[Program akan error jika mencoba assign null atau tidak diinisialisasi];
  ```

  _Representasi visual ini menunjukkan alur keputusan Dart terkait null safety._

---

### 3\. Konstanta (Constants)

**Konstanta** adalah variabel yang nilainya **tidak dapat diubah** setelah diinisialisasi. Setelah Anda menetapkan nilai ke konstanta, nilai itu akan tetap sama sepanjang sisa eksekusi program. Dart memiliki dua kata kunci untuk mendeklarasikan konstanta: `final` dan `const`. Meskipun keduanya membuat nilai tidak dapat diubah, ada perbedaan penting kapan nilai tersebut ditetapkan.

#### Kata Kunci `final`

`final` digunakan untuk variabel yang hanya dapat diinisialisasi **satu kali**. Nilainya ditetapkan pada **waktu eksekusi (runtime)**, artinya bisa mengambil nilai dari hasil komputasi atau kondisi yang tidak diketahui saat kompilasi.

##### Ciri-ciri `final`:

- Nilainya ditentukan pada **runtime** (saat program berjalan).
- Setelah diinisialisasi, nilainya **tidak dapat diubah** lagi.
- Digunakan ketika nilai tidak diketahui saat _compile-time_ tetapi tidak boleh berubah setelah ditetapkan.
- Bisa menjadi _instance variable_ (properti kelas) atau _local variable_.

##### Sintaks dan Contoh `final`:

```dart
final String namaAplikasi = "MyAwesomeApp";
// namaAplikasi = "NewApp"; // ERROR: A final variable can only be set once.

final DateTime waktuMulai = DateTime.now(); // Nilai ini baru diketahui saat program dijalankan
print(waktuMulai); // Akan mencetak waktu saat ini

class Pengguna {
  final String id; // ID ini akan unik untuk setiap objek Pengguna
  final String nama;

  Pengguna(this.id, this.nama);
}

void main() {
  final Pengguna user1 = Pengguna("U001", "Ani");
  // user1.id = "U002"; // ERROR: ID tidak bisa diubah karena final
  print("User: ${user1.nama}, ID: ${user1.id}");

  // Bahkan untuk list/map, objek list/map-nya itu sendiri yang final, bukan isinya:
  final List<String> daftarKata = ["satu", "dua"];
  daftarKata.add("tiga"); // OK, isi list bisa diubah
  print(daftarKata);      // Output: [satu, dua, tiga]
  // daftarKata = ["empat"]; // ERROR: Daftar kata itu sendiri tidak bisa diubah
}
```

##### Kapan Menggunakan `final`?

- Ketika Anda memiliki variabel yang nilainya tidak akan berubah setelah pertama kali ditetapkan, tetapi nilainya mungkin berasal dari sumber eksternal (misalnya, data dari API, input pengguna, atau hasil perhitungan) yang tidak diketahui saat program dikompilasi.
- Untuk properti objek yang harus diinisialisasi di konstruktor dan tidak boleh berubah setelah objek dibuat (seperti `id` pengguna).

#### Kata Kunci `const`

`const` digunakan untuk variabel yang nilainya adalah **konstanta waktu kompilasi (compile-time constant)**. Ini berarti nilai variabel harus sepenuhnya diketahui **sebelum program dimulai** (pada saat kode Anda dikompilasi).

##### Ciri-ciri `const`:

- Nilainya ditentukan pada **compile-time** (sebelum program dijalankan).
- Setelah diinisialisasi, nilainya **tidak dapat diubah** sama sekali.
- Memiliki optimasi performa karena kompiler dapat meng-cache nilai ini.
- Dapat berupa _top-level_, _static_, atau _local variable_.
- Jika sebuah objek dinyatakan sebagai `const`, maka semua propertinya juga harus `const` atau _immutable_.

##### Sintaks dan Contoh `const`:

```dart
const double PI = 3.14159; // Nilai ini diketahui saat kompilasi
const String VERSI_APP = "1.0.0"; // Nilai ini diketahui saat kompilasi

// const DateTime waktuSekarang = DateTime.now(); // ERROR: DateTime.now() adalah runtime value, bukan compile-time constant.

class Lingkaran {
  final double radius; // Radius bisa berbeda untuk setiap Lingkaran
  const Lingkaran(this.radius); // Constructor bisa const jika properti juga final dan nilainya compile-time constant.
}

void main() {
  const int MAKS_PENGGUNA = 1000;
  print(MAKS_PENGGUNA);

  // Jika Anda membuat objek dengan 'const' constructor, objek itu sendiri menjadi const.
  const Lingkaran lingkaranMerah = Lingkaran(5.0); // Objek const
  const Lingkaran lingkaranBiru = Lingkaran(5.0); // Objek const dengan nilai yang sama

  // print(lingkaranMerah == lingkaranBiru); // Output: true
  // Karena keduanya adalah const dan nilainya sama, Dart akan mengoptimasi dan mengarahkan ke objek yang sama di memori.
  // Ini adalah fitur penting dari const yang disebut "canonicalization".

  final Lingkaran lingkaranHijau = Lingkaran(5.0); // Objek final
  // print(lingkaranMerah == lingkaranHijau); // Output: false
  // Meskipun nilainya sama, lingkaranHijau dibuat pada runtime, sehingga merupakan objek yang berbeda.
}
```

##### Kapan Menggunakan `const`?

- Untuk nilai-nilai yang benar-benar tidak akan pernah berubah sepanjang hidup aplikasi, seperti konstanta matematika, _API keys_ yang _hardcoded_, atau string pesan statis.
- Ketika Anda ingin Dart melakukan optimasi performa dengan "mengkanonikalisasi" (menggunakan kembali) objek yang sama jika nilainya sama. Ini sangat penting dalam Flutter untuk _widget_ yang tidak berubah.

#### Perbedaan Utama antara `final` dan `const`

| Fitur                       | `final`                                          | `const`                                                               |
| :-------------------------- | :----------------------------------------------- | :-------------------------------------------------------------------- |
| **Kapan Ditetapkan**        | Runtime (saat program berjalan)                  | Compile-time (sebelum program dimulai)                                |
| **Nilai Bisa Berasal dari** | Perhitungan, I/O (file, network), input pengguna | Hanya nilai literal atau ekspresi yang bisa dievaluasi saat kompilasi |
| **Immutability**            | Objek tidak dapat diubah setelah diinisialisasi  | Objek dan semua propertinya juga `const` atau _immutable_             |
| **Optimasi Memori**         | Tidak ada optimasi "canonicalization"            | Ada optimasi "canonicalization" (objek yang sama jika nilai sama)     |
| **Penggunaan Umum**         | Properti objek (misal `id`), nilai yang dihitung | Konstanta global, nilai _hardcoded_, _widget_ statis di Flutter       |

#### Contoh Perbandingan `final` dan `const`

```dart
void main() {
  // Contoh dengan final (runtime constant)
  final String WAKTU_SAAT_INI = DateTime.now().toString(); // Nilai diambil saat runtime
  print("Waktu mulai aplikasi: $WAKTU_SAAT_INI");
  // WAKTU_SAAT_INI = "lain"; // Error: Cannot assign to final variable

  // Contoh dengan const (compile-time constant)
  const String NAMA_SISTEM = "Sistem Inventori V1.0"; // Nilai sudah diketahui saat kompilasi
  print("Sistem ini: $NAMA_SISTEM");
  // NAMA_SISTEM = "lain"; // Error: Cannot assign to const variable

  // Contoh dengan List
  final List<int> daftarAngkaFinal = [1, 2, 3];
  daftarAngkaFinal.add(4); // OK, karena objek list-nya itu sendiri yang final, bukan isinya
  print(daftarAngkaFinal); // Output: [1, 2, 3, 4]
  // daftarAngkaFinal = [5, 6]; // Error: Cannot assign to final variable

  const List<int> daftarAngkaConst = [10, 20, 30];
  // daftarAngkaConst.add(40); // ERROR: Cannot add to an unmodifiable list.
                               // Karena objek list-nya sendiri adalah const (immutable)
  // daftarAngkaConst = [50, 60]; // Error: Cannot assign to const variable

  // Penting untuk objek Class:
  // Class harus punya constructor 'const' agar bisa membuat objek 'const'.
  // Dan semua properti dari class tersebut harus final dan inisialisasinya harus compile-time constant.
  const Titik A = Titik(0, 0); // OK, karena constructor Titik adalah const
  const Titik B = Titik(0, 0); // Ini akan mengarah ke objek yang sama dengan A karena const
  print(A == B); // Output: true

  final Titik C = Titik(1, 1); // OK, meskipun constructor const, kita membuatnya final
  final Titik D = Titik(1, 1); // Ini akan menjadi objek yang berbeda dengan C
  print(C == D); // Output: false
}

class Titik {
  final int x;
  final int y;

  // Constructor harus const agar objek Titik bisa dibuat sebagai const
  const Titik(this.x, this.y);
}
```

---

### 4\. Kata Kunci `late`

Diperkenalkan dengan Null Safety, kata kunci `late` menambahkan fleksibilitas pada cara kita mendeklarasikan variabel non-nullable yang tidak bisa diinisialisasi di awal.

#### Definisi `late`

`late` adalah sebuah _modifier_ yang digunakan untuk mendeklarasikan variabel yang **akan diinisialisasi nanti**, tetapi sebelum variabel tersebut pertama kali digunakan. Ini mengatasi kebutuhan untuk variabel non-nullable yang tidak dapat diinisialisasi saat deklarasi atau di dalam konstruktor.

#### Ciri-ciri `late`:

- **Non-Nullable:** Digunakan untuk variabel yang Anda inginkan menjadi non-nullable, tetapi Anda tidak bisa memberinya nilai awal.
- **Lazy Initialization (Inisialisasi Malas):** Nilainya tidak diinisialisasi sampai variabel itu benar-benar diakses untuk pertama kalinya. Ini berguna untuk inisialisasi yang mahal (memakan banyak sumber daya).
- **Error Saat Akses:** Jika variabel `late` diakses sebelum diinisialisasi, program akan menyebabkan _runtime error_ (Dart `LateInitializationError`).
- Bisa digunakan pada _top-level variables_, _static variables_, dan _instance variables_.

#### Sintaks dan Contoh `late`:

```dart
// Contoh 1: Lazy initialization
late String deskripsiProduk; // Deklarasi variabel non-nullable yang akan diinisialisasi nanti

String getDeskripsi() {
  if (!this._hasFetchedDescription) { // Anggap ini sebuah flag
    print("Mengambil deskripsi dari database...");
    deskripsiProduk = "Laptop gaming terbaru dengan RTX 4090."; // Inisialisasi
    this._hasFetchedDescription = true;
  }
  return deskripsiProduk;
}
bool _hasFetchedDescription = false; // Flag bantuan

// Contoh 2: Mengatasi dependensi sirkular atau inisialisasi di luar konstruktor
class PengelolaData {
  late DataService _dataService; // DataService akan diinisialisasi nanti

  void init() {
    _dataService = DataService(); // Inisialisasi _dataService di sini
  }

  void fetchData() {
    _dataService.fetch(); // Memanggil metode setelah diinisialisasi
  }
}

class DataService {
  void fetch() {
    print("Data sedang diambil...");
  }
}

void main() {
  // Contoh 1 penggunaan
  print(getDeskripsi()); // Output: Mengambil deskripsi dari database... \n Laptop gaming terbaru dengan RTX 4090.
  print(getDeskripsi()); // Output: Laptop gaming terbaru dengan RTX 4090. (tidak fetching lagi)

  // Contoh 2 penggunaan
  PengelolaData pm = PengelolaData();
  // pm.fetchData(); // ERROR: _dataService belum diinisialisasi (LateInitializationError)
  pm.init();
  pm.fetchData(); // Output: Data sedang diambil...
}
```

#### Kapan Menggunakan `late`?

1.  **Variabel yang Dideklarasikan, tetapi Diinisialisasi di Kemudian Hari:** Terutama saat Anda perlu menginisialisasi variabel di dalam fungsi `initState` pada widget Flutter atau di dalam metode _setup_ yang terpisah.
2.  **Inisialisasi Malas (Lazy Initialization):** Ketika inisialisasi suatu variabel memerlukan komputasi yang mahal dan Anda hanya ingin melakukannya saat variabel tersebut benar-benar dibutuhkan.
3.  **Mengatasi Ketergantungan Sirkular:** Ketika dua kelas atau objek saling bergantung dalam inisialisasinya, `late` bisa menjadi solusi.

#### Peringatan Penggunaan `late`

Meskipun `late` sangat berguna, gunakan dengan hati-hati. Jika Anda mendeklarasikan variabel sebagai `late` tetapi lupa untuk menginisialisasinya sebelum pertama kali digunakan, program Anda akan mengalami _runtime error_ (`LateInitializationError`).

---

### 5\. Lingkup Variabel (Variable Scope)

**Lingkup (Scope)** sebuah variabel menentukan di mana dalam kode program variabel tersebut dapat diakses atau "terlihat". Memahami _scope_ sangat penting untuk menghindari konflik nama dan menulis kode yang terorganisir.

#### Apa itu Scope?

_Scope_ adalah area di mana suatu _identifier_ (nama variabel, fungsi, kelas) valid dan dapat digunakan.

#### Global Scope (Top-Level Variables)

- **Deskripsi:** Variabel yang dideklarasikan di luar fungsi atau kelas apa pun berada di **global scope** (atau _top-level scope_). Mereka dapat diakses dari mana saja dalam file Dart yang sama, atau jika diimpor, dari file lain juga.
- **Contoh:**

  ```dart
  String namaAplikasiGlobal = "MyGlobalApp"; // Variabel top-level

  void main() {
    print(namaAplikasiGlobal); // Bisa diakses di sini
  }

  void fungsiLain() {
    print(namaAplikasiGlobal); // Bisa diakses di sini juga
  }
  ```

#### Function/Local Scope

- **Deskripsi:** Variabel yang dideklarasikan di dalam sebuah fungsi (termasuk `main`) hanya dapat diakses di dalam fungsi tersebut. Variabel ini memiliki **function scope** atau **local scope**.
- **Contoh:**

  ```dart
  void fungsiDenganVariabelLokal() {
    int jumlahLokal = 10; // Variabel lokal untuk fungsi ini
    print(jumlahLokal);   // Bisa diakses di sini
  }

  void main() {
    // print(jumlahLokal); // ERROR: Undefined name 'jumlahLokal'. Tidak bisa diakses di luar fungsi.
    fungsiDenganVariabelLokal();
  }
  ```

#### Block Scope

- **Deskripsi:** Variabel yang dideklarasikan di dalam blok kode (misalnya, di dalam `if`, `for`, `while` loop, atau bahkan di dalam `{}` kosong) hanya dapat diakses di dalam blok tersebut. Ini adalah bentuk _local scope_ yang lebih spesifik.
- **Contoh:**

  ```dart
  void main() {
    int angka = 5;

    if (angka > 3) {
      String pesan = "Angka lebih besar dari 3"; // Variabel 'pesan' hanya ada di dalam blok if ini
      print(pesan);
    }
    // print(pesan); // ERROR: Undefined name 'pesan'. Tidak bisa diakses di luar blok if.

    for (int i = 0; i < 2; i++) {
      String iterasiPesan = "Iterasi ke-$i"; // Variabel 'iterasiPesan' hanya ada di dalam blok for ini
      print(iterasiPesan);
    }
    // print(iterasiPesan); // ERROR: Undefined name 'iterasiPesan'. Tidak bisa diakses di luar blok for.
  }
  ```

#### Class Scope (Instance Variables)

- **Deskripsi:** Variabel yang dideklarasikan di dalam sebuah kelas, tetapi di luar metode mana pun, disebut **instance variables** (variabel instansi) atau **fields**. Mereka terkait dengan setiap objek (instansi) dari kelas tersebut dan dapat diakses menggunakan objek tersebut. Lingkup mereka adalah di seluruh instansi kelas.
- **Contoh:**

  ```dart
  class Mahasiswa {
    String nama; // Instance variable
    int nim;     // Instance variable

    Mahasiswa(this.nama, this.nim); // Constructor

    void tampilkanInfo() {
      print("Nama: $nama, NIM: $nim"); // Bisa mengakses instance variables di sini
    }
  }

  void main() {
    Mahasiswa mhs = Mahasiswa("Dian", 12345);
    print(mhs.nama); // Bisa diakses melalui objek 'mhs'
    mhs.tampilkanInfo();
  }
  ```

#### Static Scope (Class-Level Variables)

- **Deskripsi:** Variabel yang dideklarasikan di dalam sebuah kelas menggunakan kata kunci `static` disebut **static variables** (variabel statis) atau **class-level variables**. Mereka bukan milik instansi objek tertentu, melainkan milik kelas itu sendiri. Mereka dapat diakses langsung melalui nama kelas tanpa perlu membuat objek.
- **Contoh:**

  ```dart
  class KonfigurasiAplikasi {
    static const String NAMA_APP = "Aplikasi Ku"; // Static const variable
    static int jumlahPenggunaAktif = 0; // Static variable

    static void tambahPengguna() {
      jumlahPenggunaAktif++;
    }
  }

  void main() {
    print(KonfigurasiAplikasi.NAMA_APP); // Akses langsung melalui nama kelas
    KonfigurasiAplikasi.tambahPengguna();
    print(KonfigurasiAplikasi.jumlahPenggunaAktif); // Output: 1
  }
  ```

  Static variables juga bisa menjadi `final` atau `const`.

---

### 6\. Terminologi Kunci

- **Variabel (Variable):** Lokasi memori bernama yang nilainya dapat diubah selama program berjalan.
- **Konstanta (Constant):** Lokasi memori bernama yang nilainya tidak dapat diubah setelah diinisialisasi.
- **Deklarasi (Declaration):** Proses memberitahu Dart tentang nama dan tipe variabel.
- **Inisialisasi (Initialization):** Proses memberikan nilai awal pada variabel saat dideklarasikan.
- **`var`:** Kata kunci untuk deklarasi variabel dengan _type inference_.
- **`final`:** Kata kunci untuk konstanta yang nilainya ditetapkan pada **runtime** dan tidak dapat diubah.
- **`const`:** Kata kunci untuk konstanta yang nilainya ditetapkan pada **compile-time** dan tidak dapat diubah (seringkali dioptimasi).
- **`late`:** Modifier untuk variabel non-nullable yang akan diinisialisasi nanti, sebelum digunakan.
- **Null Safety:** Fitur Dart yang mencegah _null reference errors_ dengan memaksa programmer untuk menangani kemungkinan nilai `null`.
- **Non-nullable:** Tipe data yang tidak diizinkan untuk menyimpan `null` (default di Dart).
- **Nullable:** Tipe data yang diizinkan untuk menyimpan `null` (ditandai dengan `?`).
- **Null-aware Operators:** Operator (`?.`, `??`, `??=`) yang membantu menangani nilai `null` dengan aman.
- **Null Assertion Operator (`!`):** Operator yang memberi tahu kompiler bahwa programmer yakin nilai bukan `null` (berisiko jika salah).
- **Lingkup (Scope):** Area dalam kode di mana sebuah variabel atau identifier dapat diakses.
- **Global Scope (Top-Level):** Variabel yang dapat diakses dari mana saja dalam file.
- **Local Scope (Function/Block):** Variabel yang hanya dapat diakses di dalam fungsi atau blok tempat mereka dideklarasikan.
- **Instance Variable (Class Scope):** Variabel milik setiap objek dari sebuah kelas.
- **Static Variable (Class-Level):** Variabel milik kelas itu sendiri, bukan instansi objek.

---

### 7\. Ringkasan

Memahami **variabel** dan **konstanta** adalah fondasi utama dalam menulis kode yang efektif di Dart. Variabel memberikan fleksibilitas untuk menyimpan data yang berubah, sementara konstanta memastikan bahwa nilai-nilai penting tetap tidak berubah, meningkatkan keandalan kode.

Dengan Dart, Anda memiliki alat yang canggih untuk mengelola data:

- Gunakan **tipe eksplisit** atau **`var`** untuk variabel yang nilainya akan berubah.
- Pilih **`final`** untuk nilai yang ditetapkan sekali saat runtime (misalnya, data yang dimuat dari API).
- Gunakan **`const`** untuk nilai yang benar-benar tidak berubah dan diketahui saat kompilasi (misalnya, konstanta matematika atau teks statis).
- Manfaatkan **`late`** untuk variabel non-nullable yang inisialisasinya tertunda.
- Selalu perhatikan **Null Safety** dengan menggunakan `?` untuk tipe nullable dan operator _null-aware_ untuk penanganan yang aman.
- Pahami **lingkup variabel** untuk memastikan kode Anda terorganisir dan bebas dari konflik nama.

Penguasaan konsep ini tidak hanya membuat Anda mahir dalam Dart, tetapi juga meningkatkan kemampuan Anda dalam menulis kode yang lebih bersih, lebih aman, dan lebih mudah dipelihara di bahasa pemrograman lain juga.

---

### 8\. Sumber Referensi

- **Dart Documentation - Variables:** [https://dart.dev/guides/language/language-tour\#variables](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23variables)
- **Dart Documentation - Final and const:** [https://dart.dev/guides/language/language-tour\#final-and-const](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23final-and-const)
- **Dart Documentation - Late variables:** [https://dart.dev/guides/language/language-tour\#late-variables](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23late-variables)
- **Dart Documentation - Sound null safety (Understanding null safety):** [https://dart.dev/null-safety/understanding-null-safety](https://dart.dev/null-safety/understanding-null-safety)
- **Effective Dart - Usage:** [https://dart.dev/guides/language/effective-dart/usage](https://dart.dev/guides/language/effective-dart/usage) (Membahas kapan menggunakan `final` dan `const` secara efektif)

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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
