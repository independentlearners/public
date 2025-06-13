# [Late Variables][0]

Kita telah menyentuh **`late`** secara sekilas di bagian **Variables & Constants** dan **Null Safety Deep Dive**. Sekarang, mari kita bedah lebih jauh mengapa `late` ada, bagaimana cara kerjanya, dan kapan Anda harus (atau tidak harus) menggunakannya dalam kode Dart Anda.

---

### 1. Apa Itu `late`?

**`late`** adalah _modifier_ (kata kunci) di Dart yang digunakan untuk mendeklarasikan variabel **non-nullable** yang nilainya **akan diinisialisasi nanti**, bukan pada saat deklarasi. Konsep utamanya adalah **inisialisasi malas (lazy initialization)** atau penundaan inisialisasi.

#### Mengapa `late` Ada?

Sebelum **Null Safety** diperkenalkan di Dart 2.12, variabel yang tidak diinisialisasi secara otomatis akan memiliki nilai `null`. Ini sering menyebabkan _runtime errors_ jika developer lupa untuk memeriksa `null`.

Dengan Null Safety, semua variabel secara _default_ adalah **non-nullable**. Artinya, jika Anda mendeklarasikan `String nama;`, Anda **wajib** menginisialisasinya. Namun, ada situasi di mana Anda tidak bisa atau tidak ingin menginisialisasi variabel segera:

1.  **Inisialisasi yang Mahal:** Variabel yang membutuhkan komputasi berat, mengakses database, atau melakukan operasi I/O yang memakan waktu. Anda ingin menunda inisialisasi ini sampai variabel benar-benar dibutuhkan.
2.  **Dependensi Siklus (Circular Dependencies):** Dua objek saling membutuhkan untuk diinisialisasi.
3.  **Inisialisasi di Kemudian Hari:** Variabel yang nilainya akan ditetapkan oleh metode lain (misalnya, `initState()` di Flutter, atau fungsi `setup()` pada aplikasi konsol).
4.  **Variabel Top-Level dan Statis:** Variabel top-level dan statis non-nullable harus diinisialisasi segera. `late` memungkinkan Anda menunda ini.

`late` hadir untuk menjembatani celah ini, memungkinkan Anda memiliki variabel non-nullable yang tidak diinisialisasi segera, namun dengan janji bahwa mereka pasti akan memiliki nilai sebelum digunakan.

---

### 2. Sintaks Dasar

Anda cukup menambahkan kata kunci `late` sebelum tipe data atau `var` saat mendeklarasikan variabel.

```dart
late DataType variableName; // Deklarasi saja, akan diinisialisasi nanti
late DataType variableName = initialValue; // Inisialisasi malas dengan ekspresi

// Contoh:
late String deskripsiProduk;
late int hitungGlobal;
```

---

### 3. Cara Kerja `late`

Ketika Anda mendeklarasikan variabel dengan `late`:

1.  **Tidak Diinisialisasi Segera:** Kompiler tidak mewajibkan Anda untuk segera memberinya nilai.
2.  **Janji untuk Diinisialisasi:** Anda berjanji kepada kompiler bahwa variabel ini akan memiliki nilai sebelum Anda mengaksesnya untuk pertama kali.
3.  **Inisialisasi Saat Akses Pertama (Lazy):** Jika Anda menginisialisasinya dengan sebuah ekspresi (`late String name = _getNameFromSomewhere();`), ekspresi tersebut hanya akan dievaluasi saat variabel `name` diakses untuk pertama kalinya.
4.  **Runtime Check:** Jika Anda mencoba mengakses variabel `late` sebelum diinisialisasi, Dart akan melemparkan `LateInitializationError` saat _runtime_. Ini adalah bentuk _fail-fast_ yang membantu Anda mendeteksi masalah lebih awal daripada menghadapi perilaku aneh di kemudian hari.

---

### 4. Penggunaan Umum `late`

#### a. Lazy Initialization (Inisialisasi Malas)

Ini adalah skenario paling umum. Jika inisialisasi suatu variabel mahal atau tidak perlu dilakukan sampai variabel tersebut benar-benar digunakan, `late` adalah pilihan yang tepat.

```dart
class DatabaseConnector {
  DatabaseConnector() {
    print("Membuka koneksi database...");
    // Simulasi operasi yang berat atau lambat
    // Contoh: koneksi ke database, membaca file besar
    // Ini hanya dieksekusi sekali dan saat dibutuhkan
  }

  void queryData() {
    print("Mengambil data...");
  }
}

// Variabel 'db' akan diinisialisasi hanya saat pertama kali diakses
late DatabaseConnector db = DatabaseConnector();

void main() {
  print("Aplikasi dimulai.");

  // Pada titik ini, 'db' belum diinisialisasi.
  // Objek DatabaseConnector belum dibuat.

  print("Membutuhkan koneksi database...");
  db.queryData(); // Baris ini akan memicu inisialisasi 'db'
                  // Output: Membuka koneksi database... \n Mengambil data...

  db.queryData(); // Tidak akan membuka koneksi lagi, hanya menggunakan instance yang sudah ada
                  // Output: Mengambil data...

  print("Aplikasi selesai.");
}
```

#### b. Variabel yang Diinisialisasi di Luar Konstruktor

Seringkali di Flutter, properti kelas (terutama di `State` widget) perlu diinisialisasi di dalam metode siklus hidup seperti `initState()`, bukan di konstruktor. Tanpa `late`, Anda harus membuat properti tersebut nullable, yang tidak ideal jika Anda yakin properti itu akan selalu memiliki nilai setelah `initState()`.

```dart
import 'package:flutter/material.dart'; // Hanya untuk contoh, tidak perlu jalankan di DartPad

// Simulasikan struktur widget State
class MyComplexState extends State<MyComplexWidget> {
  // Variabel ini akan diinisialisasi di initState(), bukan di constructor
  late String _userDisplayName;
  late int _userId;

  @override
  void initState() {
    super.initState();
    // Simulasi pengambilan data dari async operation atau shared preferences
    _userDisplayName = "Budi Santoso";
    _userId = 12345;
    print("initState: _userDisplayName dan _userId sudah diinisialisasi.");
  }

  @override
  Widget build(BuildContext context) {
    // Pada titik ini, kita yakin _userDisplayName dan _userId sudah tidak null
    return Text("Selamat datang, $_userDisplayName (ID: $_userId)!");
  }
}

class MyComplexWidget extends StatefulWidget {
  @override
  State<MyComplexWidget> createState() => MyComplexState();
}

void main() {
  // Ini adalah simulasi, tidak benar-benar menjalankan UI
  MyComplexState state = MyComplexState();
  state.initState();
  // state.build(null); // Memanggil build akan aman
}
```

#### c. Mengatasi Circular Dependencies (Ketergantungan Melingkar)

Dalam beberapa desain, dua kelas mungkin saling membutuhkan untuk diinisialisasi. `late` dapat membantu memecahkan masalah ini.

```dart
class A {
  late B bInstance; // A membutuhkan B

  A() {
    print("A diinisialisasi.");
  }

  void useB() {
    print("A menggunakan B: ${bInstance.messageFromB()}");
  }
}

class B {
  late A aInstance; // B membutuhkan A

  B() {
    print("B diinisialisasi.");
  }

  String messageFromB() {
    return "Halo dari B.";
  }

  void useA() {
    print("B menggunakan A.");
    // aInstance.useB(); // Ini bisa memicu A.useB jika diperlukan
  }
}

void main() {
  A objA = A();
  B objB = B();

  // Setelah objek A dan B dibuat, kita saling referensikan mereka
  objA.bInstance = objB;
  objB.aInstance = objA;

  objA.useB(); // Output: A menggunakan B: Halo dari B.
}
```

#### d. Variabel Top-Level dan Statis Non-Nullable Tanpa Inisialisasi Awal

Secara default, variabel top-level dan statis non-nullable harus diinisialisasi di awal. `late` menghilangkan batasan ini.

```dart
// Variabel top-level yang akan diinisialisasi nanti
late String CONFIG_DIR;

class AppSettings {
  // Variabel statis yang akan diinisialisasi nanti
  static late String API_KEY;
}

void initializeApp() {
  CONFIG_DIR = "/app/config";
  AppSettings.API_KEY = "xyz123abc";
  print("Aplikasi berhasil diinisialisasi.");
}

void main() {
  // print(CONFIG_DIR); // ERROR: LateInitializationError (belum diinisialisasi)
  initializeApp();
  print("Config Directory: $CONFIG_DIR"); // Output: Config Directory: /app/config
  print("API Key: ${AppSettings.API_KEY}"); // Output: API Key: xyz123abc
}
```

---

### 5. Peringatan dan Risiko Menggunakan `late`

Meskipun `late` sangat berguna, ada risiko yang perlu Anda pahami:

1.  **`LateInitializationError`:** Jika Anda mendeklarasikan variabel `late` tetapi lupa menginisialisasinya sebelum pertama kali diakses, program Anda akan _crash_ saat _runtime_. Ini adalah kesalahan yang tidak akan terdeteksi oleh kompiler.

    ```dart
    late String myVariable; // Lupa inisialisasi

    void main() {
      // print(myVariable); // CRASH: LateInitializationError: Field 'myVariable' has not been initialized.
    }
    ```

    Oleh karena itu, gunakan `late` hanya ketika Anda **sangat yakin** bahwa inisialisasi akan terjadi sebelum penggunaan.

2.  **Tidak Berguna untuk Variabel yang Memang Bisa `null`:** Jika suatu variabel memang secara logis bisa `null` sebagai nilai yang valid (misalnya, `String? emailPengguna`), maka gunakan tipe nullable (`String?`) daripada memaksakan `late`. `late` menyiratkan bahwa nilai _akan_ ada, hanya saja tertunda.

3.  **Tidak Bisa untuk Variabel Lokal yang Tidak Diinisialisasi:** `late` tidak berlaku untuk variabel lokal yang tidak diinisialisasi di awal (tanpa ekspresi). Variabel lokal Dart tanpa inisialisasi awal haruslah _nullable_.

    ```dart
    // late int count; // ERROR: A late local variable must be initialized.
                      // Anda harus inisialisasi: late int count = 0; atau late int count = someFunction();
    ```

---

### 6. Perbandingan dengan Alternatif

| Fitur/Skenario              | `DataType` (Non-nullable)       | `DataType?` (Nullable)               | `late DataType`                                            |
| :-------------------------- | :------------------------------ | :----------------------------------- | :--------------------------------------------------------- |
| **Boleh `null`?**           | Tidak (`null` tidak valid)      | Ya                                   | Tidak (`null` tidak valid)                                 |
| **Kapan Diinisialisasi?**   | Saat deklarasi atau konstruktor | Saat deklarasi (defaultnya `null`)   | Saat pertama kali diakses                                  |
| **Risiko _Runtime Error_?** | Rendah (Dicegah oleh kompiler)  | Rendah (dengan pengecekan null)      | **Tinggi** (jika diakses sebelum inisialisasi)             |
| **Kapan Digunakan?**        | Default, nilai selalu ada       | Nilai bisa tidak ada/opsional        | Inisialisasi mahal/tertunda; mengatasi dependensi          |
| **Performa**                | Optimal                         | Sedikit _overhead_ (pengecekan null) | Optimal setelah inisialisasi; _overhead_ inisialisasi awal |

---

### 7. Ringkasan `late`

`late` adalah fitur yang kuat di Dart yang memberikan Anda kontrol lebih besar terhadap inisialisasi variabel non-nullable. Ini memungkinkan inisialisasi malas dan membantu dalam skenario di mana inisialisasi segera tidak mungkin atau tidak diinginkan. Namun, kekuatan ini datang dengan tanggung jawab: Anda harus memastikan bahwa variabel `late` selalu diinisialisasi sebelum digunakan untuk menghindari `LateInitializationError` saat _runtime_.

Gunakan `late` secara bijak untuk:

- Inisialisasi yang mahal.
- Properti kelas yang bergantung pada `initState` atau metode _setup_ lainnya.
- Situasi ketergantungan melingkar.
- Variabel top-level atau statis yang inisialisasinya tertunda.

Hindari `late` jika variabel tersebut memang secara logis bisa `null`, atau jika Anda bisa menginisialisasinya segera.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

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
