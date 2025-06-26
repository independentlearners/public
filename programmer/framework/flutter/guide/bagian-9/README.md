# [FASE 7: Routing dan Navigasi][0]

Navigasi adalah bagian fundamental dari setiap aplikasi mobile. Fase ini akan membahas bagaimana pengguna bergerak di antara berbagai layar (rute) dalam aplikasi Flutter, mulai dari dasar-dasar `Navigator` hingga solusi navigasi yang lebih canggih.

---

<details>
  <summary>📃 Struktur Daftar Isi</summary>

- [7.1 Pengenalan Konsep Routing dan Stack Navigasi](#71-pengenalan-konsep-routing-dan-stack-navigasi)
  - [7.1.1 Apa itu Route dan Stack Navigasi?](#711-apa-itu-route-dan-stack-navigasi)
  - [7.1.2 Peran `MaterialApp` dan `WidgetsApp`](#712-peran-materialapp-dan-widgetsapp)
- [7.2 Navigasi Dasar (`Navigator.push`, `Navigator.pop`)](#72-navigasi-dasar-navigatorpush-navigatorpop)
  - [7.2.1 Menggunakan `MaterialPageRoute`](#721-menggunakan-materialpageroute)
  - [7.2.2 Meneruskan Data Antar Halaman](#722-meneruskan-data-antar-halaman)
  - [7.2.3 Mengembalikan Data dari Halaman](#723-mengembalikan-data-dari-halaman)
- [7.3 Navigasi Bernama (`Named Routes`)](#73-navigasi-bernama-named-routes)
  - [7.3.1 Mendaftarkan `Named Routes` di `MaterialApp`](#731-mendaftarkan-named-routes-di-materialapp)
  - [7.3.2 Menggunakan `Navigator.pushNamed` dan `Navigator.popAndPushNamed`](#732-menggunakan-navigatorpushnamed-dan-navigatorpopandpushnamed)
  - [7.3.3 Mengakses Argumen Rute (`ModalRoute.of`)](#733-mengakses-argumen-rute-modalrouteof)
- [7.4 Mengelola Stack Navigasi (`Navigator.pushReplacement`, `Navigator.popUntil`, `Navigator.pushAndRemoveUntil`)](#74-mengelola-stack-navigasi-navigatorpushreplacement-navigatorpopuntil-navigatorpushandremoveuntil)
  - [7.4.1 Skenario Penggunaan Umum](#741-skenario-penggunaan-umum)
- [7.5 Navigasi Kompleks dan Nested Navigation](#75-navigasi-kompleks-dan-nested-navigation)
  - [7.5.1 Menggunakan `Navigator` Bersarang (`Nested Navigators`)](#751-menggunakan-navigator-bersarang-nested-navigators)
  - [7.5.2 Tab Bar dan Bottom Navigation Bar](#752-tab-bar-dan-bottom-navigation-bar)
- [7.6 Router Package (Overview)](#76-router-package-overview)
  - [7.6.1 `GoRouter`](#761-gorouter)
  - [7.6.2 `AutoRouter`](#762-autorouter)
  - [7.6.3 Kapan Menggunakan Router Package](#763-kapan-menggunakan-router-package)
- [Selamat](#selamat)

</details>

---

### 7.1 Pengenalan Konsep Routing dan Stack Navigasi

Setiap aplikasi yang lebih dari sekadar "Halo Dunia" memerlukan cara bagi pengguna untuk berpindah antar layar atau bagian aplikasi yang berbeda. Di Flutter, mekanisme ini disebut **Routing dan Navigasi**. Memahami bagaimana navigasi bekerja sangat penting untuk membangun aplikasi yang intuitif dan fungsional.

#### 7.1.1 Apa itu Route dan Stack Navigasi?

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami dua konsep fundamental dalam navigasi aplikasi Flutter: **Route** dan **Stack Navigasi**. Mereka akan mempelajari bahwa "Route" adalah representasi logis dari sebuah layar atau halaman dalam aplikasi, sementara "Stack Navigasi" adalah tumpukan di mana rute-rute ini diletakkan dan dikelola. Pemahaman ini adalah dasar untuk semua operasi navigasi selanjutnya.

**Konsep Kunci & Filosofi Mendalam:**

- **Route:**

  - **Konsep:** Dalam Flutter, **Route** secara fundamental adalah representasi "layar" atau "halaman" dalam aplikasi Anda. Setiap kali Anda melihat tampilan yang berbeda di aplikasi (misalnya, halaman beranda, halaman detail produk, halaman pengaturan), itu secara konseptual adalah sebuah _route_. Flutter menyediakan kelas abstrak `Route<T>` sebagai fondasinya.
  - **Filosofi:** Route memisahkan representasi UI dari mekanisme navigasi itu sendiri. Ini memungkinkan Anda untuk mendefinisikan sebuah layar secara independen dan kemudian "menunjukkannya" atau "menyembunyikannya" dari pengguna melalui operasi navigasi.
  - **`MaterialPageRoute`:** Ini adalah implementasi `Route` yang paling umum digunakan untuk aplikasi bergaya Material Design. Ia menciptakan transisi halaman bergaya platform (slide-in dari samping di Android, slide-in dari bawah di iOS).

- **Stack Navigasi (Navigator Stack):**

  - **Konsep:** Anggaplah **Stack Navigasi** sebagai tumpukan piring (atau tumpukan kartu). Setiap kali Anda "memuat" sebuah halaman baru, itu seperti menaruh piring baru di atas tumpukan (operasi **push**). Ketika Anda "kembali" dari sebuah halaman, itu seperti mengambil piring teratas dari tumpukan (operasi **pop**). Halaman yang paling atas di tumpukan adalah halaman yang sedang dilihat oleh pengguna.
  - **Filosofi:** Model tumpukan ini secara akurat mereplikasi perilaku navigasi umum pada aplikasi mobile:
    - Anda mulai dari satu layar (`Home`).
    - Anda pergi ke layar lain (`Details`), yang berarti `Details` ditambahkan di atas `Home`.
    - Ketika Anda menekan tombol kembali, `Details` dihapus, dan Anda kembali ke `Home`.
  - **Peran `Navigator`:** Widget `Navigator` adalah _widget_ yang mengelola _stack_ rute ini. Setiap `MaterialApp` (atau `WidgetsApp`) secara internal memiliki `Navigator` sendiri.

**Visualisasi Diagram Alur/Struktur:**

- **Stack Navigasi:**

  ```
  +-------------------+
  |    Route C        | <---- Halaman Saat Ini (Terlihat)
  +-------------------+
  |    Route B        |
  +-------------------+
  |    Route A        | <---- Halaman Asli (Root)
  +-------------------+
        (Navigator Stack)
  ```

  - **Push:** Ketika `Route D` di-_push_, ia akan berada di atas `Route C`.
  - **Pop:** Ketika `Route C` di-_pop_, `Route B` akan menjadi halaman yang terlihat.

**Hubungan dengan Modul Lain:**
Dasar dari seluruh fase 7. Konsep `BuildContext` dari Fase 2 akan sangat relevan, karena navigasi seringkali dilakukan menggunakan `BuildContext`.

---

#### 7.1.2 Peran `MaterialApp` dan `WidgetsApp`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bahwa `MaterialApp` dan `WidgetsApp` bukan hanya _widget_ _boilerplate_ di _root_ aplikasi, tetapi merupakan _entry point_ penting untuk sistem navigasi Flutter. Mereka akan belajar bahwa kedua _widget_ ini menyediakan `Navigator` yang diperlukan untuk mengelola _route stack_ dan membangun _widget tree_ yang sesuai.

**Konsep Kunci & Filosofi Mendalam:**

- **`WidgetsApp`:**

  - **Konsep:** Ini adalah _widget_ dasar yang menyediakan fungsionalitas aplikasi inti Flutter, termasuk `Navigator` (untuk manajemen rute), _bindings_, _scheduler_, dan _widget_ inti lainnya. Ini adalah fondasi minimal untuk aplikasi Flutter.
  - **Filosofi:** `WidgetsApp` adalah blok bangunan paling dasar yang memungkinkan aplikasi Flutter berfungsi. Jika Anda membuat aplikasi tanpa gaya Material Design atau Cupertino, `WidgetsApp` adalah titik awal Anda.

- **`MaterialApp`:**

  - **Konsep:** Ini adalah _widget_ yang dibangun di atas `WidgetsApp` dan mengimplementasikan Material Design. Ini menyediakan banyak _widget_ dan _utility_ khusus Material Design (seperti tema, _localization_, dan, yang terpenting untuk navigasi, `Navigator` yang sudah dikonfigurasi untuk MaterialPageRoute).
  - **Filosofi:** `MaterialApp` adalah _entry point_ standar untuk sebagian besar aplikasi Flutter, karena menyediakan kerangka kerja dan gaya yang konsisten dengan pedoman Material Design Google. Ini secara implisit menyediakan `Navigator` yang mengatur _root route_ aplikasi Anda.
  - **`home` Properti:** Properti `home` dari `MaterialApp` adalah tempat Anda mendefinisikan _route_ pertama yang akan ditampilkan saat aplikasi diluncurkan. Ini adalah _root_ dari _stack_ navigasi awal Anda.

**Visualisasi Diagram Alur/Struktur:**

```
+---------------------------+
|       runApp()            |
+---------------------------+
          |
          V
+---------------------------+
|       MaterialApp         | (or WidgetsApp)
| - Provides a Navigator    |
| - Sets up initial route   |
| - Configures app-wide stuff |
+---------------------------+
          | (Builds initial route from `home` property)
          V
+---------------------------+
|       Navigator           |
| - Manages the Route Stack |
| - Handles Push/Pop        |
+---------------------------+
          | (Initial Route pushed here)
          V
+---------------------------+
|       Route A (Home)      |
+---------------------------+
```

**Hubungan dengan Modul Lain:**
`MaterialApp` sudah diperkenalkan di Fase 1 sebagai _entry point_ aplikasi. Sekarang, kita akan memahami perannya yang lebih dalam dalam sistem navigasi.

---

**Sintaks Dasar / Contoh Implementasi Inti:**

Contoh sederhana untuk menggambarkan `MaterialApp` dan `home` sebagai _initial route_:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(), // Inilah route pertama yang ditampilkan
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Kita akan belajar tentang Navigator.push di bagian selanjutnya!
            // Untuk saat ini, bayangkan ini akan membawa ke halaman lain.
            print('Tombol "Go to Detail" ditekan');
          },
          child: const Text('Go to Detail Screen'),
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

- `runApp(const MyApp());` memulai aplikasi.
- `MaterialApp` adalah _widget_ _root_.
- Properti `home: const HomeScreen()` mendefinisikan `HomeScreen` sebagai _route_ pertama yang ditempatkan di _navigator stack_. Ini adalah satu-satunya _route_ di _stack_ saat aplikasi pertama kali diluncurkan.

**Terminologi Esensial (Revisi & Tambahan):**

- **Route:** Representasi logis sebuah layar/halaman dalam aplikasi.
- **Navigator Stack:** Struktur data tumpukan yang menyimpan urutan rute yang telah dikunjungi.
- **`Navigator`:** Widget yang mengelola _navigator stack_ (menambah, menghapus rute).
- **`MaterialPageRoute`:** Implementasi `Route` khusus Material Design yang menyediakan transisi halaman standar.
- **`WidgetsApp`:** Widget dasar untuk fungsionalitas aplikasi, menyediakan `Navigator`.
- **`MaterialApp`:** Widget yang membangun di atas `WidgetsApp` untuk aplikasi Material Design, menyediakan `Navigator` yang sudah dikonfigurasi.
- **`home` property:** Properti `MaterialApp` yang menentukan _initial route_ aplikasi.

**Sumber Referensi Lengkap:**

- [Navigator class (Flutter Docs)](https://api.flutter.dev/flutter/widgets/Navigator-class.html)
- [Route class (Flutter Docs)](https://api.flutter.dev/flutter/widgets/Route-class.html)
- [MaterialApp class (Flutter Docs)](https://api.flutter.dev/flutter/material/MaterialApp-class.html)
- [WidgetsApp class (Flutter Docs)](https://api.flutter.dev/flutter/widgets/WidgetsApp-class.html)

**Tips dan Praktik Terbaik:**

- **Pahami Fondasi:** Meskipun Anda mungkin akan sering menggunakan _package_ navigasi pihak ketiga, pemahaman yang kuat tentang `Navigator` dan `Route` asli Flutter sangat penting. Ini akan membantu Anda _debug_ masalah navigasi dan memahami bagaimana _package_ tersebut bekerja di balik layar.
- **Satu `Navigator` per `MaterialApp`:** Umumnya, Anda hanya akan memiliki satu `Navigator` utama di setiap `MaterialApp`. `Nested Navigators` akan dibahas di bagian selanjutnya untuk skenario yang lebih kompleks.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mencoba navigasi tanpa `Navigator` yang tersedia di `BuildContext`.
  - **Penyebab:** Ini terjadi jika Anda mencoba memanggil `Navigator.of(context)` dari _widget_ yang tidak memiliki `MaterialApp` (atau `WidgetsApp` atau `Navigator` lain) di atasnya di pohon _widget_.
  - **Solusi:** Pastikan `MaterialApp` adalah _ancestor_ dari _widget_ tempat Anda mencoba melakukan navigasi.

---

### 7.2 Navigasi Dasar (`Navigator.push`, `Navigator.pop`)

`Navigator.push` dan `Navigator.pop` adalah dua fungsi fundamental untuk mengelola **navigator stack** di Flutter. Ini adalah cara paling umum dan langsung untuk berpindah antar halaman dalam aplikasi Anda.

#### 7.2.1 Menggunakan `MaterialPageRoute`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar cara menggunakan **`Navigator.push()`** untuk menempatkan (menambahkan) rute baru ke atas _stack_ navigasi, yang secara efektif akan menampilkan halaman baru kepada pengguna. Mereka juga akan memahami bagaimana **`MaterialPageRoute`** digunakan untuk membungkus _widget_ halaman yang ingin ditampilkan, memberikan transisi visual yang sesuai dengan Material Design.

**Konsep Kunci & Filosofi Mendalam:**

- **`Navigator.of(context)`:**

  - **Konsep:** Ini adalah cara untuk mendapatkan _instance_ `Navigator` terdekat di pohon _widget_. `context` (yaitu `BuildContext`) adalah kunci di sini karena ia tahu posisi _widget_ Anda dalam _tree_ dan dapat menemukan `Navigator` yang relevan di atasnya.
  - **Filosofi:** Flutter menggunakan `BuildContext` secara ekstensif untuk menemukan _ancestor widgets_ dan menyediakan layanan, termasuk `Navigator`. Ini memastikan bahwa operasi navigasi terjadi pada _navigator stack_ yang benar.

- **`push()` Method:**

  - **Konsep:** Metode `push()` pada `Navigator` menambahkan _route_ baru ke bagian atas _stack_ navigasi. Ketika _route_ baru di-_push_, _route_ sebelumnya (yang ada di bawahnya) akan berhenti _render_ tetapi tetap ada di _stack_. Ini menciptakan efek "layar baru muncul di atas layar sebelumnya".
  - **Filosofi:** Mencerminkan perilaku "maju" dalam aplikasi. Pengguna maju ke detail, form, atau sub-bagian lain dari aplikasi. Halaman sebelumnya tetap "hidup" di latar belakang, siap untuk kembali.

- **`MaterialPageRoute`:**

  - **Konsep:** Ini adalah kelas _route_ spesifik Material Design yang Anda berikan sebuah `builder` (fungsi yang mengembalikan _widget_ halaman yang akan ditampilkan) dan secara opsional sebuah `settings` (untuk nama rute dan argumen). `MaterialPageRoute` secara otomatis menangani animasi transisi antar halaman (misalnya, _slide in_ dari kanan di Android, _fade in_ di iOS) dan juga menambahkan tombol kembali secara otomatis di `AppBar` jika bukan _root route_.
  - **Filosofi:** Menyediakan pengalaman pengguna yang konsisten dan sesuai dengan pedoman Material Design tanpa perlu menulis logika animasi transisi halaman secara manual.

**Visualisasi Diagram Alur/Struktur:**

```
// Sebelum push:
+-------------------+
|    HomeScreen     | <---- Terlihat
+-------------------+
      (Stack)

// Setelah Navigator.push(MaterialPageRoute(... DetailScreen())):
+-------------------+
|    DetailScreen   | <---- Terlihat
+-------------------+
|    HomeScreen     |
+-------------------+
      (Stack)
```

**Hubungan dengan Modul Lain:**
Membangun di atas konsep **Route** dan **Stack Navigasi** dari 7.1. Ini juga akan menggunakan `BuildContext` dari Fase 2.

---

#### 7.2.2 Meneruskan Data Antar Halaman

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar metode paling umum dan direkomendasikan untuk meneruskan data dari satu halaman ke halaman lain saat navigasi. Ini melibatkan penggunaan **konstruktor halaman tujuan** untuk menerima data sebagai argumen.

**Konsep Kunci & Filosofi Mendalam:**

- **Meneruskan Data via Konstruktor:**
  - **Konsep:** Cara paling bersih dan paling aman untuk meneruskan data ke halaman yang akan dibuka adalah dengan menambahkan parameter ke **konstruktor _widget_ halaman tujuan**.
  - **Filosofi:** Ini adalah praktik terbaik di Flutter karena:
    - **Tipe-Aman:** Kompiler akan memastikan Anda meneruskan tipe data yang benar.
    - **Eksplisit:** Jelas terlihat data apa yang dibutuhkan oleh halaman tersebut.
    - **Testable:** Membuat halaman lebih mudah diuji secara independen karena semua dependensinya jelas di konstruktor.
    - **Tidak Terikat Navigator:** Halaman tidak perlu tahu bagaimana ia dinavigasi, hanya perlu tahu data apa yang ia butuhkan.

**Visualisasi Diagram Alur/Struktur:**

```
[Halaman A]
  (Tombol ditekan)
    |
    | Navigator.push(
    |   MaterialPageRoute(
    |     builder: (context) => HalamanB(data: 'Halo') // Data diteruskan di konstruktor
    |   )
    | )
    V
[Halaman B]
  (Konstruktor menerima 'Halo')
  (Menampilkan data)
```

---

#### 7.2.3 Mengembalikan Data dari Halaman

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar bagaimana halaman tujuan dapat mengirim kembali data ke halaman sebelumnya di _stack_. Ini dilakukan dengan menggunakan **`Navigator.pop()`** yang menerima argumen sebagai hasil yang akan dikembalikan oleh `push()` yang asli.

**Konsep Kunci & Filosofi Mendalam:**

- **`pop()` Method dengan Hasil:**
  - **Konsep:** Metode `pop()` pada `Navigator` menghapus _route_ teratas dari _stack_ navigasi, menampilkan _route_ di bawahnya. Secara _default_, `pop()` tidak mengembalikan nilai. Namun, Anda dapat memberikan sebuah argumen ke `pop()` (misalnya `Navigator.pop(context, 'Data Kembali')`). Argumen ini akan menjadi nilai _return_ dari `Navigator.push()` yang awalnya memanggil halaman tersebut.
  - **Filosofi:** Memungkinkan komunikasi _two-way_ yang sederhana antar halaman dalam _stack_ navigasi. Sering digunakan untuk skenario seperti memilih item dari daftar, mengonfirmasi tindakan, atau memasukkan data.
- **`push()` sebagai `Future`:**
  - **Konsep:** Perlu dicatat bahwa `Navigator.push()` mengembalikan sebuah `Future<T>`. Ini berarti Anda dapat menggunakan `await` pada panggilan `push()` untuk menunggu hasil yang dikembalikan oleh `pop()`.
  - **Filosofi:** Pola `Future` adalah cara standar Dart untuk menangani operasi asinkron. Dalam konteks navigasi, ini berarti Anda dapat "menunggu" hingga halaman yang baru dibuka selesai dan mengembalikan data sebelum melanjutkan eksekusi kode di halaman sebelumnya.

**Visualisasi Diagram Alur/Struktur:**

```
[Halaman A]
  (Tombol ditekan)
    |
    | final result = await Navigator.push(...)
    | (Menunggu hasil dari Halaman B)
    V
[Halaman B]
  (Tombol "Selesai" ditekan)
    |
    | Navigator.pop(context, 'Data dari Halaman B') // Mengembalikan data
    V
[Halaman A]
  (result sekarang berisi 'Data dari Halaman B')
  (Melakukan sesuatu dengan data)
```

---

**Sintaks Dasar / Contoh Implementasi Inti (Gabungan dari 7.2.1, 7.2.2, 7.2.3):**

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(), // Halaman awal
    );
  }
}

// --- HomeScreen ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _returnedData = 'No data yet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Data from Detail Screen: $_returnedData'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // 7.2.1 Menggunakan Navigator.push dan MaterialPageRoute
                // 7.2.2 Meneruskan data via konstruktor
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      message: 'Hello from Home Screen!',
                    ),
                  ),
                );

                // 7.2.3 Mengembalikan data dari halaman
                if (result != null) {
                  setState(() {
                    _returnedData = result as String;
                  });
                }
              },
              child: const Text('Go to Detail Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- DetailScreen ---
class DetailScreen extends StatelessWidget {
  final String message; // Data diterima via konstruktor

  const DetailScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message, // Menampilkan data yang diterima
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 7.2.3 Mengembalikan data dari halaman
                Navigator.pop(
                  context,
                  'Data returned from Detail Screen!', // Data yang dikembalikan
                );
              },
              child: const Text('Go Back to Home'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Kembali tanpa mengembalikan data
              },
              child: const Text('Go Back (No Data)'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode (`HomeScreen` dan `DetailScreen`):**

- **`HomeScreen`:**

  - Memiliki `_returnedData` untuk menampilkan data yang dikembalikan dari `DetailScreen`.
  - Tombol "Go to Detail Screen" menggunakan `Navigator.push`.
  - `await Navigator.push(...)` digunakan untuk menunggu hasil dari `DetailScreen`.
  - Setelah `DetailScreen` di-_pop_ dan mengembalikan data, `result` akan berisi data tersebut, dan `setState` digunakan untuk memperbarui `_returnedData`.

- **`DetailScreen`:**

  - Menerima `message` melalui konstruktor (`final String message;`). Ini adalah cara standar dan direkomendasikan untuk meneruskan data.
  - Tombol "Go Back to Home" menggunakan `Navigator.pop(context, 'Data yang dikembalikan')`. String ini akan menjadi nilai `result` di `HomeScreen`.
  - Tombol "Go Back (No Data)" menggunakan `Navigator.pop(context)`. Ini akan mengembalikan `null` ke `HomeScreen`.

**Terminologi Esensial:**

- **`Navigator.push(context, route)`:** Menambahkan rute baru ke atas _stack_.
- **`Navigator.pop(context, [result])`:** Menghapus rute teratas dari _stack_ dan secara opsional mengembalikan `result`.
- **`await`:** Digunakan dengan `Navigator.push` untuk menunggu hasil yang dikembalikan oleh `Navigator.pop`.
- **`BuildContext context`:** Digunakan oleh `Navigator.of(context)` untuk menemukan _instance_ `Navigator`.

**Sumber Referensi Lengkap:**

- [Navigator.push method (Flutter Docs)](https://api.flutter.dev/flutter/widgets/Navigator/push.html)
- [Navigator.pop method (Flutter Docs)](https://api.flutter.dev/flutter/widgets/Navigator/pop.html)
- [MaterialPageRoute class (Flutter Docs)](https://api.flutter.dev/flutter/material/MaterialPageRoute-class.html)
- [Cookbook: Navigate with named routes](https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments) - Meskipun judulnya _named routes_, bagian "Pass arguments to a named route" juga menjelaskan konsep meneruskan data via konstruktor.

**Tips dan Praktik Terbaik:**

- **Gunakan Konstruktor untuk Meneruskan Data:** Ini adalah metode paling bersih, tipe-aman, dan mudah diuji untuk meneruskan data ke halaman baru. Hindari menggunakan argumen `settings` dari `MaterialPageRoute` untuk data yang penting untuk _widget tree_ (itu lebih untuk _named routes_ atau data yang opsional/metadata).
- **Gunakan `await` untuk Menerima Hasil:** Jika halaman yang Anda _push_ perlu mengembalikan data, selalu gunakan `await` pada panggilan `Navigator.push`.
- **Periksa `null` untuk Hasil yang Dikembalikan:** Saat menerima hasil dari `pop()`, selalu periksa apakah hasilnya `null`, karena pengguna mungkin kembali dengan tombol fisik atau gerakan _swipe_ tanpa data yang dikembalikan secara eksplisit.
- **Satu `AppBar` per Layar:** Umumnya, setiap `Scaffold` Anda akan memiliki `AppBar` sendiri. `MaterialPageRoute` akan secara otomatis menambahkan tombol kembali (panah) jika halaman tersebut bukan halaman _root_ dari `Navigator`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mengakses `message` dari `DetailScreen` di luar konstruktornya (misalnya, di `initState` atau `build` tanpa menerimanya).

  - **Penyebab:** Properti _widget_ harus diinisialisasi melalui konstruktor.
  - **Solusi:** Pastikan semua data yang dibutuhkan oleh _widget_ diterima melalui konstruktor dan disimpan sebagai `final` properti.

- **Kesalahan:** Lupa `await` pada `Navigator.push` ketika mengharapkan hasil dari `pop`.

  - **Penyebab:** Kode di `HomeScreen` akan langsung dieksekusi tanpa menunggu `DetailScreen` selesai dan mengembalikan data. `result` akan langsung `null` atau `Future<dynamic>` yang belum _resolved_.
  - **Solusi:** Tambahkan kata kunci `async` ke fungsi di mana `Navigator.push` dipanggil dan gunakan `await` pada panggilan `Navigator.push`.

---

### 7.3 Navigasi Bernama (`Named Routes`)

**Navigasi bernama** adalah cara untuk menavigasi ke halaman menggunakan nama _string_ yang unik daripada langsung memberikan _instance_ `MaterialPageRoute` atau _widget_ tujuan. Ini sangat berguna untuk aplikasi yang lebih besar, membuatnya lebih mudah untuk mengelola rute, meneruskan argumen, dan meningkatkan keterbacaan kode navigasi.

#### 7.3.1 Mendaftarkan `Named Routes` di `MaterialApp`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar bagaimana cara mendaftarkan semua _route_ bernama aplikasi mereka di dalam properti **`routes`** pada `MaterialApp`. Mereka akan memahami bagaimana setiap entri dalam `routes` memetakan nama _string_ ke fungsi _builder_ yang menghasilkan _widget_ halaman yang sesuai.

**Konsep Kunci & Filosofi Mendalam:**

- **`routes` Property:**
  - **Konsep:** Properti `routes` pada `MaterialApp` adalah sebuah `Map<String, WidgetBuilder>`. Setiap _key_ adalah nama _string_ dari rute (misalnya, `'/home'`, `'/details'`, `'/settings'`), dan _value_ adalah fungsi `WidgetBuilder` yang menerima `BuildContext` dan mengembalikan _widget_ yang akan menjadi halaman untuk rute tersebut.
  - **Filosofi:** Ini menciptakan "peta" rute yang terpusat di aplikasi. Daripada menyusun `MaterialPageRoute` secara ad-hoc di mana-mana, Anda mendefinisikan rute sekali di awal. Ini meningkatkan _maintainability_ dan konsistensi, karena semua rute dan halaman yang terkait dapat dilihat dalam satu tempat.
- **`initialRoute` Property:**
  - **Konsep:** Selain properti `home` yang kita lihat sebelumnya, `MaterialApp` juga memiliki properti `initialRoute`. Jika `initialRoute` disetel, maka rute bernama yang sesuai akan menjadi rute awal tumpukan navigasi, mengesampingkan properti `home`. Nama rute `'/` biasanya digunakan sebagai rute awal atau rute beranda.
  - **Filosofi:** Memberikan fleksibilitas lebih dalam menentukan rute pembukaan aplikasi, terutama ketika menggunakan navigasi bernama.

**Visualisasi Diagram Alur/Struktur:**

```
+---------------------------------+
|          MaterialApp            |
|---------------------------------|
| routes: {                        |
|   '/': (context) => HomeScreen(), |  <-- Map String to WidgetBuilder
|   '/detail': (context) => DetailScreen(),|
|   '/settings': (context) => SettingsScreen(),|
| }                                |
| initialRoute: '/'               | <-- Set initial route by name
+---------------------------------+
```

---

#### 7.3.2 Menggunakan `Navigator.pushNamed` dan `Navigator.popAndPushNamed`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar cara menggunakan **`Navigator.pushNamed()`** untuk menavigasi ke rute bernama, dan **`Navigator.popAndPushNamed()`** untuk mengganti rute saat ini dengan rute bernama yang baru, sambil mempertahankan posisi di _stack_ navigasi.

**Konsep Kunci & Filosofi Mendalam:**

- **`Navigator.pushNamed(context, routeName, {arguments})`:**
  - **Konsep:** Metode ini mengambil `BuildContext`, `routeName` (nama _string_ dari rute yang terdaftar di `MaterialApp.routes`), dan secara opsional objek `arguments`. Ia kemudian mencari _builder_ yang sesuai di `routes` map dan menambahkan rute baru tersebut ke _stack_.
  - **Filosofi:** Ini adalah cara yang lebih deklaratif dan terpisah dari _widget_ tujuan. Kode navigasi Anda tidak perlu tahu detail implementasi `DetailScreen`; ia hanya perlu tahu namanya (`'/detail'`). Ini mendukung pemisahan _concern_.
- **`Navigator.popAndPushNamed(context, routeName, {arguments})`:**
  - **Konsep:** Metode ini adalah kombinasi dari `pop()` dan `pushNamed()`. Ini terlebih dahulu menghapus rute teratas dari _stack_ navigasi, kemudian segera menambahkan rute bernama baru ke bagian atas _stack_.
  - **Filosofi:** Berguna untuk skenario di mana Anda ingin mengganti halaman saat ini tanpa menambahkan halaman baru ke _stack_. Contoh umumnya adalah setelah _login_ sukses, Anda ingin mengganti halaman _login_ dengan halaman _beranda_ tanpa memungkinkan pengguna kembali ke halaman _login_ dengan tombol kembali.

**Visualisasi Diagram Alur/Struktur:**

```
// Sebelum:
+-------------+
|  Screen B   | <--- Terlihat
+-------------+
|  Screen A   |
+-------------+

// pushNamed('/screenC'):
+-------------+
|  Screen C   | <--- Terlihat
+-------------+
|  Screen B   |
+-------------+
|  Screen A   |
+-------------+

// popAndPushNamed('/screenD'):
// (Screen C di-pop, Screen D di-push)
+-------------+
|  Screen D   | <--- Terlihat
+-------------+
|  Screen B   |
+-------------+
|  Screen A   |
+-------------+
```

---

#### 7.3.3 Mengakses Argumen Rute (`ModalRoute.of`)

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar cara mengirim data ke rute bernama melalui parameter `arguments` di `pushNamed` dan cara mengakses argumen ini di halaman tujuan menggunakan **`ModalRoute.of(context).settings.arguments`**.

**Konsep Kunci & Filosofi Mendalam:**

- **`arguments` Parameter:**
  - **Konsep:** Metode `pushNamed` memiliki parameter opsional `arguments` yang dapat Anda gunakan untuk meneruskan data ke rute tujuan. Parameter ini menerima objek apa pun.
  - **Filosofi:** Menyediakan mekanisme untuk mengirim data ke rute bernama. Penting untuk diingat bahwa `arguments` adalah objek generik, jadi Anda perlu melakukan _casting_ ke tipe yang benar di halaman tujuan.
- **`ModalRoute.of(context).settings.arguments`:**
  - **Konsep:** Di halaman tujuan, Anda dapat mengakses argumen yang diteruskan melalui `ModalRoute.of(context)`. Ini mengembalikan _instance_ `ModalRoute` yang saat ini aktif, dari mana Anda bisa mengakses properti `settings.arguments`.
  - **Filosofi:** `ModalRoute` adalah abstraksi untuk rute yang "modal" (yaitu, mereka menutupi konten sebelumnya). Mengakses `settings.arguments` melalui `ModalRoute.of(context)` adalah cara kanonis untuk mendapatkan argumen yang dikirim melalui `pushNamed`.

**Catatan Penting Mengenai Argumen:**
Meskipun meneruskan argumen melalui `settings.arguments` dimungkinkan, ini **kurang tipe-aman** dibandingkan meneruskan data melalui **konstruktor halaman** (seperti yang diajarkan di 7.2.2). Untuk data yang wajib dan kritis, **meneruskan via konstruktor tetap direkomendasikan** untuk alasan keamanan tipe dan kemudahan pengujian. `arguments` di `ModalRoute` lebih sering digunakan untuk data opsional atau metadata.

**Alternatif untuk Mengakses Argumen (dengan konstruktor):**
Sebenarnya, praktik terbaik saat menggunakan _named routes_ dan perlu meneruskan argumen adalah dengan tetap memanfaatkan konstruktor halaman. Anda bisa membuat _class_ argumen terpisah:

```dart
class DetailArguments {
  final String message;
  final int id;
  DetailArguments({required this.message, required this.id});
}

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail'; // Definisi nama rute

  const DetailScreen({super.key, required this.message}); // Menerima data via konstruktor
  final String message;

  @override
  Widget build(BuildContext context) {
    // Cara yang lebih baik untuk mendapatkan argumen jika menggunakan named routes
    // final args = ModalRoute.of(context)!.settings.arguments as DetailArguments;
    // return Text('Message: ${args.message}, ID: ${args.id}');

    // Atau jika hanya satu argumen:
    // final String messageFromArgs = ModalRoute.of(context)!.settings.arguments as String;

    // Untuk contoh ini, kita tetap pakai yang dari konstruktor
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Named Screen')),
      body: Center(child: Text('Message: $message')),
    );
  }
}

// Di MaterialApp.routes:
// '/detail': (context) => DetailScreen(
//    message: (ModalRoute.of(context)!.settings.arguments as String),
// ),

// Dan saat push:
// Navigator.pushNamed(context, DetailScreen.routeName, arguments: 'Hello from Home');
```

Dengan cara ini, Anda mendapatkan manfaat keamanan tipe dari konstruktor sekaligus kemudahan navigasi bernama.

---

**Sintaks Dasar / Contoh Implementasi Inti (Gabungan):**

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// --- HomeScreen ---
class HomeScreen extends StatelessWidget {
  static const routeName = '/'; // Nama rute untuk Home Screen
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen (Named Routes)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // 7.3.2 Menggunakan Navigator.pushNamed
                // 7.3.3 Meneruskan argumen (opsional)
                Navigator.pushNamed(
                  context,
                  DetailScreen.routeName,
                  arguments: 'Data ini dari Home Screen via Named Route!',
                );
              },
              child: const Text('Go to Detail Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Contoh penggunaan popAndPushNamed
                // Ini akan mengganti HomeScreen dengan SettingsScreen
                Navigator.popAndPushNamed(context, SettingsScreen.routeName);
              },
              child: const Text('Go to Settings (Replace Home)'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- DetailScreen ---
class DetailScreen extends StatelessWidget {
  static const routeName = '/detail'; // Nama rute untuk Detail Screen

  const DetailScreen({super.key}); // Perhatikan: konstruktor tidak menerima argumen langsung untuk demo ini

  @override
  Widget build(BuildContext context) {
    // 7.3.3 Mengakses argumen rute
    // Argumen bisa null jika tidak ada yang diteruskan, jadi perlu penanganan null
    final String? message = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen (Named)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message ?? 'No message received', // Tampilkan pesan atau default
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SettingsScreen ---
class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings'; // Nama rute untuk Settings Screen
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen (Named)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is the settings page!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman sebelumnya (Home Screen)
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MyApp (MaterialApp dengan Named Routes) ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // 7.3.1 Mendaftarkan Named Routes di MaterialApp
      initialRoute: HomeScreen.routeName, // Tentukan rute awal
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        DetailScreen.routeName: (context) => const DetailScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
      },
    );
  }
}
```

**Penjelasan Konteks Kode (Gabungan):**

- **Definisi `routeName`:** Setiap kelas halaman memiliki `static const routeName` untuk menyimpan nama _string_ rute, ini praktik baik untuk menghindari _magic strings_.
- **`MaterialApp` Konfigurasi:**
  - `initialRoute: HomeScreen.routeName,` : Menentukan halaman `/` (HomeScreen) sebagai titik awal navigasi.
  - `routes: { ... }` : Memetakan nama rute ke _constructor_ halaman. Perhatikan bahwa di sini, `DetailScreen` tidak menerima argumen melalui konstruktornya, melainkan akan mengambilnya dari `ModalRoute.of(context)`. Ini untuk mendemonstrasikan bagaimana `arguments` diakses.
- **`HomeScreen` Navigasi:**
  - `Navigator.pushNamed(context, DetailScreen.routeName, arguments: ...)`: Navigasi ke `DetailScreen` menggunakan nama rute dan meneruskan sebuah _string_ sebagai argumen.
  - `Navigator.popAndPushNamed(context, SettingsScreen.routeName)`: Saat tombol ini ditekan di `HomeScreen`, `HomeScreen` akan di-_pop_ dari _stack_ dan `SettingsScreen` akan di-_push_, efektif menggantikan `HomeScreen`. Jika Anda menekan tombol kembali dari `SettingsScreen`, aplikasi akan keluar karena tidak ada lagi halaman di bawahnya.
- **`DetailScreen` Mengakses Argumen:**
  - `final String? message = ModalRoute.of(context)?.settings.arguments as String?;`: Ini adalah baris kunci untuk mendapatkan argumen yang diteruskan melalui `pushNamed`. Perhatikan penggunaan `?` dan `as String?` untuk penanganan _null safety_ dan _casting_.

**Terminologi Esensial:**

- **`initialRoute`:** Properti `MaterialApp` untuk menentukan rute awal aplikasi berdasarkan nama.
- **`routes`:** `Map` di `MaterialApp` untuk mendaftarkan semua rute bernama.
- **`Navigator.pushNamed(context, routeName, {arguments})`:** Metode untuk menavigasi ke rute bernama.
- **`Navigator.popAndPushNamed(context, routeName, {arguments})`:** Metode untuk mengganti rute saat ini dengan rute bernama baru.
- **`ModalRoute.of(context).settings.arguments`:** Cara untuk mendapatkan argumen yang diteruskan ke rute bernama di halaman tujuan.

**Sumber Referensi Lengkap:**

- [Cookbook: Navigate with named routes](https://docs.flutter.dev/cookbook/navigation/named-routes)
- [Navigator.pushNamed method (Flutter Docs)](https://api.flutter.dev/flutter/widgets/Navigator/pushNamed.html)
- [Navigator.popAndPushNamed method (Flutter Docs)](https://api.flutter.dev/flutter/widgets/Navigator/popAndPushNamed.html)
- [ModalRoute class (Flutter Docs)](https://api.flutter.dev/flutter/widgets/ModalRoute-class.html)

**Tips dan Praktik Terbaik:**

- **Tetapkan Konstanta untuk Nama Rute:** Selalu definisikan nama rute sebagai konstanta `static const String routeName = '/your-route';` di dalam kelas halaman itu sendiri. Ini mengurangi kesalahan ketik dan membuat kode lebih mudah di-_refactor_.
- **Sentralisasi Rute (Opsional):** Untuk aplikasi yang sangat besar, Anda mungkin ingin membuat kelas `AppRoutes` terpisah untuk mendefinisikan semua nama rute dan bahkan menyediakan fungsi _builder_ mereka.
- **Prioritaskan Konstruktor untuk Data Kritis:** Sekali lagi, untuk data yang penting dan diperlukan oleh halaman, teruskan melalui konstruktor. Ini membuat kode Anda lebih tipe-aman dan _testable_. Gunakan `arguments` untuk data opsional atau metadata.
- **Pahami Perbedaan `home` vs `initialRoute`:** Anda hanya dapat menggunakan salah satu dari mereka. Jika Anda menggunakan `initialRoute`, pastikan rute tersebut juga terdaftar di `routes` map.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Rute bernama tidak terdaftar di `MaterialApp.routes` tetapi mencoba menavigasi ke sana.

  - **Penyebab:** `Navigator` tidak dapat menemukan definisi untuk nama rute yang diberikan.
  - **Solusi:** Pastikan setiap nama rute yang Anda gunakan dengan `pushNamed` atau `popAndPushNamed` telah terdaftar dengan benar di `routes` map.

- **Kesalahan:** Lupa melakukan _casting_ `ModalRoute.of(context).settings.arguments` ke tipe yang benar.

  - **Penyebab:** `arguments` mengembalikan `Object?`, jadi Anda perlu memberitahu Dart tipe data yang diharapkan.
  - **Solusi:** Lakukan _casting_ secara eksplisit, misalnya `as String` atau `as MyCustomArgumentClass`. Gunakan `?` untuk _null safety_ jika argumen bisa `null`.

- **Kesalahan:** Menggunakan `Navigator.popAndPushNamed` di halaman yang merupakan _root route_.

  - **Penyebab:** Ini akan mengganti _root route_, dan jika pengguna menekan tombol kembali dari rute yang baru di-_push_, aplikasi akan keluar. Ini seringkali diinginkan (misalnya, setelah _login_), tetapi penting untuk disadari.

---

### 7.4 Mengelola Stack Navigasi (`Navigator.pushReplacement`, `Navigator.popUntil`, `Navigator.pushAndRemoveUntil`)

Selain `push` dan `pop` dasar, Flutter menyediakan metode yang lebih canggih untuk memanipulasi _navigator stack_. Ini sangat penting untuk mengimplementasikan alur navigasi yang spesifik, seperti setelah _login_, atau kembali ke _root_ aplikasi.

#### 7.4.1 Skenario Penggunaan Umum

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami dan menerapkan tiga metode manipulasi _stack_ navigasi yang penting:

- **`Navigator.pushReplacement()`**: Untuk mengganti rute saat ini dengan yang baru.
- **`Navigator.popUntil()`**: Untuk menghapus rute dari _stack_ hingga rute tertentu ditemukan.
- **`Navigator.pushAndRemoveUntil()`**: Untuk menambahkan rute baru dan menghapus semua rute sebelumnya hingga kondisi tertentu terpenuhi.

Mereka akan belajar kapan dan mengapa masing-masing metode ini digunakan, terutama dalam skenario umum aplikasi mobile.

**Konsep Kunci & Filosofi Mendalam:**

1.  **`Navigator.pushReplacement(context, newRoute)`** atau **`Navigator.pushReplacementNamed(context, routeName, {arguments})`**:

    - **Konsep**: Metode ini menambahkan `newRoute` ke _stack_ navigasi, tetapi **sebelumnya menghapus rute yang saat ini berada di paling atas**. Efeknya adalah rute yang sedang aktif digantikan oleh rute baru.
    - **Filosofi**: Mencegah pengguna kembali ke halaman yang "tidak relevan" atau "tidak boleh diakses kembali" setelah tindakan tertentu. Bayangkan sebuah pintu yang mengunci di belakang Anda.
    - **Contoh Skenario**:
      - Setelah **login berhasil**: Anda ingin menavigasi dari halaman `LoginScreen` ke `HomeScreen`, tetapi tidak ingin pengguna dapat menekan tombol kembali dan kembali ke `LoginScreen`.
      - Setelah **registrasi berhasil**: Dari `RegistrationScreen` ke `SuccessScreen`, lalu tidak bisa kembali ke `RegistrationScreen`.

2.  **`Navigator.popUntil(context, predicate)`**:

    - **Konsep**: Metode ini "melepaskan" (menghapus) rute-rute dari atas _stack_ navigasi **sampai sebuah rute yang memenuhi `predicate` (kondisi boolean) ditemukan**. `predicate` adalah fungsi yang menerima sebuah `Route` dan mengembalikan `true` jika rute tersebut adalah tujuan yang diinginkan untuk berhenti _pop_.
    - **Filosofi**: Kembali ke titik tertentu di _history_ navigasi Anda. Mirip dengan "mundur melalui beberapa halaman" secara bersamaan.
    - **Contoh Skenario**:
      - Dari halaman `ProductDetail` -\> `AddToCart` -\> `Checkout` -\> `PaymentConfirmation`, dan setelah pembayaran berhasil, Anda ingin kembali langsung ke `ProductListScreen` (mungkin _root_ dari bagian belanja). Anda bisa `popUntil` ke `ProductListScreen`.
      - Ketika keluar dari sebuah alur _flow_ (misalnya, membuat postingan baru), dan ingin kembali ke halaman _feed_ utama.

3.  **`Navigator.pushAndRemoveUntil(context, newRoute, predicate)`** atau **`Navigator.pushNamedAndRemoveUntil(context, routeName, predicate, {arguments})`**:

    - **Konsep**: Metode ini adalah kombinasi dari `push` dan `popUntil`. Ia menambahkan `newRoute` ke _stack_ navigasi, tetapi **sebelumnya menghapus semua rute yang ada di bawahnya** hingga rute yang memenuhi `predicate` ditemukan. Jika `predicate` selalu mengembalikan `false` (misalnya `(route) => false`), maka semua rute di bawahnya akan dihapus, membuat `newRoute` menjadi satu-satunya rute di _stack_.
    - **Filosofi**: Mengatur ulang _stack_ navigasi untuk menciptakan alur yang benar-benar baru, seringkali dengan sebuah "titik awal" baru. Ini seperti membersihkan semua piring di meja dan hanya menyisakan satu, lalu menaruh piring baru di atasnya.
    - **Contoh Skenario**:
      - Setelah **logout**: Anda ingin menghapus semua rute terkait sesi pengguna saat ini (`HomeScreen`, `ProfileScreen`, dll.) dan menempatkan `LoginScreen` sebagai satu-satunya rute di _stack_. `Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);` adalah contoh umum untuk ini.
      - Memulai ulang aplikasi dari _root_ setelah pembaruan penting.

**Visualisasi Diagram Alur/Struktur:**

- **`pushReplacement`**:

  ```
  Stack A -> B       --pushReplacement(C)-->       Stack A -> C
  (B dihapus, C ditambahkan)
  ```

- **`popUntil`**:

  ```
  Stack A -> B -> C -> D    --popUntil((route) => route.isFirst)-->       Stack A
  (D, C, B dihapus sampai rute pertama (A) ditemukan)
  ```

  Atau:

  ```
  Stack A -> B -> C -> D    --popUntil((route) => route.settings.name == '/B')-->       Stack A -> B
  (D, C dihapus sampai rute bernama '/B' ditemukan)
  ```

- **`pushAndRemoveUntil`**:

  ```
  Stack A -> B -> C    --pushAndRemoveUntil(D, (route) => route.isFirst)-->       Stack D
  (C, B, A dihapus, D ditambahkan sebagai satu-satunya rute)
  ```

  Atau:

  ```
  Stack A -> B -> C    --pushAndRemoveUntil(D, (route) => route.settings.name == '/B')-->       Stack B -> D
  (C dihapus, D ditambahkan, B dipertahankan karena predikat)
  ```

**Hubungan dengan Modul Lain:**
Melengkapi navigasi dasar (7.2) dan navigasi bernama (7.3) dengan memberikan kontrol yang lebih granular atas _navigator stack_.

---

**Sintaks Dasar / Contoh Implementasi Inti:**

Mari kita buat contoh yang mengintegrasikan ketiga metode ini dalam skenario aplikasi sederhana.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Navigation Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

// --- HomeScreen (Halaman Awal) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Home Screen!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Skenario: Navigasi ke Dashboard.
                // Jika sudah ada halaman lain di atasnya, akan di-push di atas.
                Navigator.pushNamed(context, '/dashboard');
              },
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- DashboardScreen ---
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are on the Dashboard.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // pushReplacement: Mengganti Dashboard dengan Profile
                // Pengguna tidak bisa kembali ke Dashboard dari Profile
                Navigator.pushReplacementNamed(context, '/profile');
              },
              child: const Text('Go to Profile (Replace Dashboard)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // pushAndRemoveUntil: Pergi ke Settings dan hapus semua di bawahnya kecuali Home
                // stack: Home -> Dashboard -> Settings (setelah ini)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  (route) => route.settings.name == '/', // Hapus sampai rute Home ('/')
                );
              },
              child: const Text('Go to Settings (Remove until Home)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke Home Screen
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ProfileScreen ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is your Profile.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // popUntil: Kembali ke Home Screen dari mana saja di stack
                // Menghapus Profile dan Dashboard jika ada di bawahnya
                Navigator.popUntil(context, (route) => route.isFirst);
                // Alternatif: Navigator.popUntil(context, (route) => route.settings.name == '/');
              },
              child: const Text('Back to Home (Pop All)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Contoh: Simulate Logout - Hapus semua route dan kembali ke Login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false, // Predikat yang selalu false: hapus semua rute
                );
              },
              child: const Text('Simulate Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SettingsScreen ---
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Adjust your settings here.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke Dashboard (atau Home jika dari sana)
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- LoginScreen ---
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please log in.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Setelah login berhasil, ganti LoginScreen dengan DashboardScreen
                // dan hapus semua rute sebelumnya (misal: jika ada halaman intro)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  (route) => false, // Hapus semua rute di bawah LoginScreen
                );
              },
              child: const Text('Login (Go to Dashboard)'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

- **`MyApp`**: Mengatur `MaterialApp` dengan rute-rute bernama untuk semua halaman.
- **`HomeScreen`**:
  - Tombol "Go to Dashboard" menggunakan `Navigator.pushNamed('/dashboard')` yang akan menambah `DashboardScreen` di atas `HomeScreen`.
    - _Stack_: `[` `/`, `/dashboard` `]`
- **`DashboardScreen`**:
  - Tombol "Go to Profile (Replace Dashboard)": Menggunakan `Navigator.pushReplacementNamed('/profile')`. Ini akan menghapus `/dashboard` dan menempatkan `/profile` di tempatnya.
    - _Stack awal_: `[` `/`, `/dashboard` `]`
    - _Stack akhir_: `[` `/`, `/profile` `]`
    - Jika dari `/profile` Anda menekan tombol kembali, Anda akan kembali ke `/` (Home).
  - Tombol "Go to Settings (Remove until Home)": Menggunakan `Navigator.pushAndRemoveUntil` dengan predikat `(route) => route.settings.name == '/'`. Ini akan mencari rute bernama `/` (Home) dan menghapus semua rute di atasnya sebelum menambahkan `/settings`.
    - Misal _Stack awal_: `[` `/`, `/dashboard`, `/detail` `]` (jika ada `DetailScreen` di antara Home dan Dashboard)
    - Jika tombol ini dipencet dari Dashboard: `/dashboard` akan dihapus, lalu `/settings` akan di-_push_.
    - _Stack akhir_: `[` `/`, `/settings` `]`
  - Tombol "Go Back": Menggunakan `Navigator.pop(context)` untuk kembali ke `HomeScreen`.
- **`ProfileScreen`**:
  - Tombol "Back to Home (Pop All)": Menggunakan `Navigator.popUntil(context, (route) => route.isFirst)`. `route.isFirst` adalah _boolean_ yang `true` jika rute tersebut adalah rute pertama di _stack_ (seringkali `home` atau `initialRoute`). Ini akan menghapus semua rute hingga mencapai _root_.
    - Misal _Stack awal_: `[` `/`, `/profile` `]` (dari `pushReplacement` dari Dashboard)
    - _Stack akhir_: `[` `/` `]`
  - Tombol "Simulate Logout": Menggunakan `Navigator.pushAndRemoveUntil` dengan `(route) => false`. Ini akan menghapus **semua** rute di _stack_ saat ini dan menempatkan `LoginScreen` sebagai satu-satunya rute baru.
    - _Stack awal_: `[` `/`, `/profile` `]`
    - _Stack akhir_: `[` `/login` `]`
    - Pengguna tidak bisa kembali ke halaman yang dilindungi setelah logout.
- **`LoginScreen`**:
  - Tombol "Login (Go to Dashboard)": Menggunakan `Navigator.pushAndRemoveUntil` dengan `(route) => false`. Ini adalah pola umum untuk navigasi setelah login; menghapus riwayat login agar pengguna tidak bisa kembali ke halaman login setelah berhasil masuk.
    - _Stack awal_: `[` `/login` `]` (setelah simulasi logout)
    - _Stack akhir_: `[` `/dashboard` `]`

**Terminologi Esensial:**

- **`Navigator.pushReplacement()`**: Menambahkan rute baru dan menghapus rute yang sedang aktif.
- **`Navigator.popUntil(predicate)`**: Menghapus rute dari atas _stack_ sampai rute yang memenuhi `predicate` ditemukan.
- **`predicate`**: Fungsi `bool Function(Route<dynamic> route)` yang digunakan oleh `popUntil` dan `pushAndRemoveUntil` untuk menentukan apakah sebuah rute harus dipertahankan atau tidak.
- **`Navigator.pushAndRemoveUntil(newRoute, predicate)`**: Menambahkan rute baru dan menghapus rute sebelumnya sampai rute yang memenuhi `predicate` ditemukan.
- **`route.isFirst`**: Properti dari `Route` yang bernilai `true` jika rute tersebut adalah yang pertama di _navigator stack_.

**Sumber Referensi Lengkap:**

- [Navigator.pushReplacement method (Flutter Docs)](https://api.flutter.dev/flutter/widgets/Navigator/pushReplacement.html)
- [Navigator.popUntil method (Flutter Docs)](https://api.flutter.dev/flutter/widgets/Navigator/popUntil.html)
- [Navigator.pushAndRemoveUntil method (Flutter Docs)](https://api.flutter.dev/flutter/widgets/Navigator/pushAndRemoveUntil.html)
- [Flutter Navigation Cheatsheet](https://medium.com/flutter-community/flutter-navigation-cheatsheet-a-guide-to-all-the-navigation-options-with-examples-12fecdd433a0) - Artikel bagus yang merangkum berbagai metode navigasi.

**Tips dan Praktik Terbaik:**

- **Pahami Alur Pengguna:** Sebelum memilih metode navigasi, pikirkan bagaimana pengguna diharapkan berinteraksi dengan aplikasi. Apakah mereka harus bisa kembali ke halaman sebelumnya? Apakah mereka harus "membersihkan" riwayat navigasi setelah tindakan penting?
- **Gunakan `pushReplacement` untuk Transisi "Satu Arah":** Ideal untuk transisi seperti _splash screen_ ke _home screen_, atau _login_ ke _dashboard_, di mana Anda tidak ingin pengguna dapat kembali.
- **Gunakan `popUntil` untuk Kembali ke Poin Tertentu:** Berguna untuk skenario di mana Anda masuk ke alur yang dalam dan ingin dengan cepat kembali ke halaman _parent_ tertentu tanpa menekan tombol kembali berkali-kali.
- **Gunakan `pushAndRemoveUntil` untuk Reset Stack:** Ini adalah metode paling kuat untuk mengelola _stack_ dan sering digunakan untuk skenario _logout/login_ atau memulai ulang alur aplikasi.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Predikat `popUntil` atau `pushAndRemoveUntil` tidak pernah `true`.

  - **Penyebab:** Jika predikat selalu mengembalikan `false`, `popUntil` akan mencoba menghapus semua rute dari _stack_ (termasuk _root_), yang dapat menyebabkan kesalahan atau aplikasi keluar. Untuk `pushAndRemoveUntil` ini justru yang sering diinginkan untuk reset total.
  - **Solusi:** Pastikan predikat Anda memiliki kondisi yang dapat dipenuhi oleh setidaknya satu rute di _stack_, atau sengaja mengembalikan `false` jika Anda ingin menghapus semua rute. Gunakan `route.isFirst` untuk menargetkan rute pertama.

- **Kesalahan:** Menggunakan `pushReplacement` saat Anda sebenarnya ingin menambahkan rute baru di atas rute saat ini.

  - **Penyebab:** Kesalahpahaman fungsi `pushReplacement` yang menggantikan, bukan hanya menambahkan.
  - **Solusi:** Pastikan Anda menggunakan `pushReplacement` hanya ketika Anda memang ingin rute yang sekarang aktif dihapus dari _stack_. Jika tidak, gunakan `push` biasa.

---

### 7.5 Navigasi Kompleks dan Nested Navigation

Sejauh ini, kita telah membahas navigasi yang melibatkan satu tumpukan rute utama (seringkali dikelola oleh `Navigator` dari `MaterialApp`). Namun, banyak aplikasi modern memiliki struktur UI yang lebih kompleks, di mana bagian-bagian aplikasi memiliki _stack_ navigasi sendiri. Inilah yang disebut **Nested Navigation** atau navigasi bersarang.

#### 7.5.1 Menggunakan `Navigator` Bersarang (`Nested Navigators`)

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami konsep **`Navigator` bersarang (nested Navigator)**. Mereka akan belajar bahwa `Navigator` bisa ditempatkan di dalam _widget tree_ yang lebih dalam, menciptakan _stack_ navigasi lokal. Ini sangat berguna untuk mengelola navigasi di dalam tab, _drawer_, atau bagian aplikasi yang memiliki alur navigasi independen.

**Konsep Kunci & Filosofi Mendalam:**

- **Apa itu Nested Navigator?**

  - **Konsep:** Alih-alih hanya memiliki satu `Navigator` utama di _root_ (`MaterialApp`), Anda dapat menempatkan _widget_ `Navigator` lain di bagian mana pun dari pohon _widget_ Anda. Setiap `Navigator` ini akan mengelola _stack_ rutenya sendiri, independen dari `Navigator` _ancestor_-nya.
  - **Filosofi:** Ini memungkinkan **modularity** dalam navigasi. Misalnya, di aplikasi dengan `BottomNavigationBar`, setiap tab mungkin memiliki alur navigasinya sendiri yang tidak memengaruhi tab lain atau _navigator stack_ utama. Ketika Anda berpindah tab, _stack_ navigasi untuk tab tersebut akan dipertahankan. Ini juga penting untuk pengalaman pengguna yang intuitif: menekan tombol kembali di dalam sebuah tab harusnya hanya mengembalikan Anda di dalam tab itu, bukan keluar dari seluruh aplikasi.

- **Kapan Menggunakan Nested Navigator?**

  - **Tab-based Navigation:** Kasus penggunaan paling umum. Setiap tab memiliki _stack_ navigasinya sendiri.
  - **Drawer Navigation:** Item di _drawer_ mungkin membuka halaman baru yang memiliki _stack_ navigasi sendiri.
  - **Complex Flows:** Bagian aplikasi yang terisolasi dengan alur navigasi internal yang dalam.
  - **Persistent Tabs:** Untuk memastikan _state_ tab dipertahankan saat beralih antar tab (misalnya, posisi _scroll_ atau data di _form_).

- **Bagaimana `Navigator.of(context)` Bekerja dengan Nested Navigators:**

  - Ketika Anda memanggil `Navigator.of(context)`, ia mencari `Navigator` terdekat di pohon _widget_ ke atas dari `context` yang diberikan.
  - Jika Anda memiliki `Navigator` bersarang, `Navigator.of(context)` dari dalam _nested navigator_ akan merujuk ke _nested navigator_ tersebut. Untuk mengakses _root navigator_, Anda dapat menggunakan `Navigator.of(context, rootNavigator: true)`.

**Visualisasi Diagram Alur/Struktur:**

```
+-----------------------------------+
|            MaterialApp            |
|       (Main/Root Navigator)       |
|                                   |
|  +-----------------------------+  |
|  |           Scaffold          |  |
|  |                             |  |
|  |  +-----------------------+  |  |
|  |  | BottomNavigationBar   |  |  |
|  |  | Tab A (Home Tab)      |  |  |
|  |  |  +-------------------+|  |  |
|  |  |  | Navigator         ||  |  |  <-- Nested Navigator for Tab A
|  |  |  |  +--------------+ ||  |  |
|  |  |  |  | Route A1     | ||  |  |
|  |  |  |  +--------------+ ||  |  |
|  |  |  +-------------------+|  |  |
|  |  | Tab B (Search Tab)  |  |  |
|  |  |  +-------------------+|  |  |
|  |  |  | Navigator         ||  |  |  <-- Nested Navigator for Tab B
|  |  |  |  +--------------+ ||  |  |
|  |  |  |  | Route B1     | ||  |  |
|  |  |  |  +--------------+ ||  |  |
|  |  |  +-------------------+|  |  |
|  |  +-----------------------+  |  |
|  +-----------------------------+  |
+-----------------------------------+
```

Pada diagram di atas, jika Anda berada di `Route A1` dan memanggil `Navigator.of(context).push(...)`, Anda akan menavigasi dalam _stack_ `Navigator` Tab A. Jika Anda ingin menavigasi ke layar penuh di luar tab (misalnya, halaman profil pengguna yang tidak seharusnya berada dalam tab), Anda akan menggunakan `Navigator.of(context, rootNavigator: true).push(...)`.

---

#### 7.5.2 Tab Bar dan Bottom Navigation Bar

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari bagaimana **`BottomNavigationBar`** dan **`TabBar`** (seringkali dengan `TabBarView`) sering menjadi implementasi praktis dari navigasi bersarang. Mereka akan melihat contoh bagaimana setiap tab atau _view_ dapat memiliki `Navigator` sendiri untuk mengelola alur internalnya, dan bagaimana mempertahankan _state_ tab saat beralih.

**Konsep Kunci & Filosofi Mendalam:**

- **`BottomNavigationBar`:**

  - **Konsep:** Widget yang menampilkan baris tab di bagian bawah layar. Setiap item tab biasanya mewakili bagian utama aplikasi dan sering kali memiliki _stack_ navigasi sendiri.
  - **Filosofi:** Memberikan navigasi tingkat atas yang mudah diakses dan persistent. Pengguna mengharapkan _state_ dari setiap tab tetap sama ketika mereka beralih bolak-balik. Ini memerlukan penggunaan `Navigator` bersarang.
  - **Implementasi:** Umumnya, Anda akan menggunakan `IndexedStack` atau `PageView` (dengan `NeverScrollableScrollPhysics` jika tidak ingin _swipe_) untuk menampung _widget_ dari setiap tab, dan setiap _widget_ tab tersebut akan berisi `Navigator`-nya sendiri.

- **`TabBar` dan `TabBarView`:**

  - **Konsep:** `TabBar` digunakan untuk menampilkan serangkaian tab horizontal, dan `TabBarView` adalah _widget_ yang menampilkan konten yang sesuai dengan tab yang dipilih. Biasanya digunakan bersama dengan `DefaultTabController` atau `TabController`.
  - **Filosofi:** Mirip dengan `BottomNavigationBar` tetapi untuk navigasi sub-bagian yang lebih kecil atau di dalam satu layar. Juga sering membutuhkan `Navigator` bersarang jika setiap tab memiliki alur navigasi independen.

- **Mempertahankan State Tab:**

  - Untuk `BottomNavigationBar` dan `TabBarView`, penting untuk memastikan _state_ dari setiap tab dipertahankan saat beralih. Ini bisa dicapai dengan:
    - Menggunakan `AutomaticKeepAliveClientMixin` pada `StatefulWidget` yang menjadi root dari setiap tab.
    - Menggunakan `IndexedStack` di _parent widget_ yang membungkus semua _widget_ tab. `IndexedStack` hanya membangun _child_ yang aktif dan mempertahankan _state_ _child_ lainnya.

**Skenario Umum Penggunaan dan Implementasi:**

Misalnya, kita memiliki `HomeScreen` dengan `BottomNavigationBar` yang memiliki dua tab: `ProductsTab` dan `OrdersTab`. Setiap tab akan memiliki _stack_ navigasinya sendiri.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nested Navigation Demo',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const RootScreen(), // Root screen with Bottom Navigation
    );
  }
}

// --- RootScreen dengan Bottom Navigation Bar ---
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  // GlobalKey untuk masing-masing nested navigator
  // Ini penting jika Anda perlu mengakses navigator spesifik dari luar tab
  final Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // IndexedStack mempertahankan state dari child yang tidak aktif
        index: _currentIndex,
        children: [
          // Tab 1: Products Tab with its own Navigator
          TabNavigator(
            navigatorKey: _navigatorKeys[0]!,
            initialRoute: '/products_home',
          ),
          // Tab 2: Orders Tab with its own Navigator
          TabNavigator(
            navigatorKey: _navigatorKeys[1]!,
            initialRoute: '/orders_home',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Jika tab yang sama ditekan lagi, pop semua route di tab itu ke root
          if (index == _currentIndex) {
            _navigatorKeys[index]!.currentState?.popUntil((route) => route.isFirst);
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}

// --- Wrapper untuk Nested Navigator ---
class TabNavigator extends StatelessWidget {
  const TabNavigator({
    super.key,
    required this.navigatorKey,
    required this.initialRoute,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return Navigator( // Ini adalah Nested Navigator
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/products_home':
            page = const ProductsHomeScreen();
            break;
          case '/product_detail':
            final productId = settings.arguments as String?;
            page = ProductDetailScreen(productId: productId);
            break;
          case '/orders_home':
            page = const OrdersHomeScreen();
            break;
          case '/order_detail':
            final orderId = settings.arguments as String?;
            page = OrderDetailScreen(orderId: orderId);
            break;
          default:
            page = const Center(child: Text('Error: Unknown Route'));
        }
        return MaterialPageRoute(builder: (context) => page, settings: settings);
      },
    );
  }
}

// --- Screens untuk Products Tab ---
class ProductsHomeScreen extends StatelessWidget {
  const ProductsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Products Home!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigasi di dalam nested navigator (Products Tab)
                Navigator.of(context).pushNamed(
                  '/product_detail',
                  arguments: 'PROD123',
                );
              },
              child: const Text('View Product Detail'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke layar penuh (di luar tab) menggunakan rootNavigator
                // Misalnya, halaman Profil Pengguna yang tidak terkait dengan tab
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const FullScreenProfile()),
                );
              },
              child: const Text('Go to Full Screen Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String? productId;
  const ProductDetailScreen({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detail for Product ID: ${productId ?? "N/A"}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Kembali dalam nested navigator
              },
              child: const Text('Back to Products Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Screens untuk Orders Tab ---
class OrdersHomeScreen extends StatelessWidget {
  const OrdersHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Orders Home!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigasi di dalam nested navigator (Orders Tab)
                Navigator.of(context).pushNamed(
                  '/order_detail',
                  arguments: 'ORD456',
                );
              },
              child: const Text('View Order Detail'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  final String? orderId;
  const OrderDetailScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Detail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detail for Order ID: ${orderId ?? "N/A"}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Kembali dalam nested navigator
              },
              child: const Text('Back to Orders Home'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Full Screen Profile (di luar nested navigation) ---
class FullScreenProfile extends StatelessWidget {
  const FullScreenProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Screen Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is a full-screen profile page.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ini akan pop dari root navigator
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

- **`RootScreen`**: Ini adalah _widget_ utama yang menampung `BottomNavigationBar`.
  - Menggunakan `_currentIndex` untuk melacak tab yang aktif.
  - `_navigatorKeys` digunakan untuk menyimpan `GlobalKey` untuk setiap `Navigator` bersarang. Ini memungkinkan kita untuk mengakses _state_ `Navigator` spesifik (misalnya, untuk `popUntil` ketika tab yang sama ditekan lagi).
  - `IndexedStack` digunakan untuk menampilkan _widget_ tab. Keuntungannya adalah `IndexedStack` hanya membangun _child_ yang aktif dan mempertahankan _state_ dari _child_ lainnya, mencegah _rebuild_ yang tidak perlu dan kehilangan _state_ di setiap tab.
  - Pada `onTap` `BottomNavigationBar`, kita melakukan `popUntil((route) => route.isFirst)` jika tab yang sama ditekan lagi. Ini adalah UX umum: jika pengguna menekan tab yang sama, ia akan kembali ke _root_ dari tab tersebut.
- **`TabNavigator`**: Ini adalah _widget_ kustom yang membungkus `Navigator` bersarang.
  - Setiap `TabNavigator` memiliki `key` sendiri (`navigatorKey`) yang diberikan oleh `RootScreen`. Ini krusial agar Flutter menganggapnya sebagai `Navigator` yang berbeda.
  - Properti `initialRoute` dan `onGenerateRoute` diatur untuk mengelola rute internal untuk tab tersebut.
- **`ProductsHomeScreen` & `OrdersHomeScreen`**: Ini adalah halaman _root_ dari masing-masing tab.
  - Tombol "View Product Detail" (atau "View Order Detail") menggunakan `Navigator.of(context).pushNamed(...)`. Karena `ProductsHomeScreen` berada di bawah `Navigator` bersarang, panggilan `Navigator.of(context)` akan menemukan _nested navigator_ tersebut, dan navigasi akan terjadi di dalam tab.
  - Tombol "Go to Full Screen Profile" di `ProductsHomeScreen` menggunakan `Navigator.of(context, rootNavigator: true).push(...)`. Parameter `rootNavigator: true` secara eksplisit memberi tahu Flutter untuk mencari `Navigator` paling atas (yaitu, yang dari `MaterialApp`), memungkinkan navigasi ke layar yang berada di luar konteks tab.
- **`ProductDetailScreen` & `OrderDetailScreen`**: Halaman detail di dalam masing-masing tab. Mereka menggunakan `Navigator.pop(context)` untuk kembali ke halaman _home_ tab mereka.
- **`FullScreenProfile`**: Ini adalah contoh halaman yang di-_push_ ke _root navigator_. Ketika Anda menekan tombol kembali di sini, Anda akan kembali ke tab yang Anda kunjungi sebelumnya.

**Terminologi Esensial:**

- **`Nested Navigator`**: Sebuah `Navigator` yang ditempatkan di dalam _widget tree_ yang lebih dalam, mengelola _stack_ rute lokal.
- **`rootNavigator: true`**: Parameter opsional di `Navigator.of(context)` yang memaksa pencarian _root navigator_ (yang dari `MaterialApp`).
- **`IndexedStack`**: _Widget_ yang hanya menampilkan satu _child_ pada satu waktu, tetapi mempertahankan _state_ dari semua _child_ lainnya, cocok untuk navigasi berbasis tab agar _state_ halaman tetap ada.
- **`GlobalKey<NavigatorState>`**: Digunakan untuk mendapatkan akses ke _state_ dari `Navigator` tertentu, terutama berguna untuk `Navigator` bersarang jika Anda perlu memanipulasinya dari luar _context_-nya sendiri (misalnya, `popUntil` dari _parent_).

**Sumber Referensi Lengkap:**

- [Flutter Docs: Nested Navigators](https://docs.flutter.dev/ui/navigation/nested-navigators)
- [Flutter Cookbook: Navigating with tabs](https://docs.flutter.dev/cookbook/navigation/tabs)
- [Navigator.of method (Flutter Docs)](https://api.flutter.dev/flutter/widgets/Navigator/of.html) (perhatikan parameter `rootNavigator`)
- [IndexedStack class (Flutter Docs)](https://api.flutter.dev/flutter/widgets/IndexedStack-class.html)

**Tips dan Praktik Terbaik:**

- **Kapan Menggunakan Nested Navigators:** Gunakan ketika Anda memiliki bagian-bagian aplikasi yang memiliki alur navigasi independen dan _persistent_, seperti tab atau _drawer_.
- **Gunakan `IndexedStack` untuk Tab Persisten:** Ini adalah cara paling efisien untuk memastikan _state_ tab dipertahankan tanpa perlu _rebuild_ seluruh tab setiap kali beralih.
- **Pahami `Navigator.of(context)` vs. `Navigator.of(context, rootNavigator: true)`:** Ini adalah perbedaan paling penting. Pahami kapan Anda ingin menavigasi di dalam _stack_ lokal dan kapan Anda ingin menavigasi di _stack_ utama aplikasi.
- **GlobalKey untuk Kontrol Lanjutan:** Untuk skenario seperti "tap tab yang sama untuk kembali ke root tab," `GlobalKey<NavigatorState>` menjadi sangat berguna.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mencoba `pop()` dari _root navigator_ saat berada di dalam _nested navigator_, padahal Anda hanya ingin kembali di dalam _nested navigator_.

  - **Penyebab:** Lupa bahwa `Navigator.of(context)` secara _default_ akan menemukan _nested navigator_ terdekat.
  - **Solusi:** Gunakan `Navigator.pop(context)` untuk navigasi lokal, dan `Navigator.of(context, rootNavigator: true).pop()` jika Anda benar-benar ingin `pop` dari _root navigator_. Namun, `pop` dari _rootNavigator_ saat berada di halaman yang di-_push_ oleh _nested navigator_ umumnya bukan perilaku yang diinginkan. Sebaliknya, gunakan `Navigator.of(context).pop()` dan biarkan _nested navigator_ yang menangani.

- **Kesalahan:** Kehilangan _state_ tab saat beralih.

  - **Penyebab:** Tidak menggunakan `IndexedStack` atau `AutomaticKeepAliveClientMixin` pada _widget_ yang menampung konten tab.
  - **Solusi:** Bungkus konten tab Anda dengan `IndexedStack` (seperti di contoh) atau pastikan _widget_ root setiap tab adalah `StatefulWidget` yang menggunakan `AutomaticKeepAliveClientMixin`.

- **Kesalahan:** Animasi transisi yang aneh saat beralih antar tab atau navigasi ke layar penuh.

  - **Penyebab:** Terkadang, _rendering_ bisa menjadi rumit dengan beberapa `Navigator`.
  - **Solusi:** Pastikan struktur Anda logis. Jika sebuah halaman seharusnya menjadi "layar penuh" (misalnya, dialog atau halaman profil yang menutupi _bottom bar_), selalu _push_ ke `rootNavigator`.

---

### 7.6 Router Package (Overview)

Meskipun Flutter menyediakan API `Navigator` yang kuat untuk mengelola navigasi, aplikasi yang kompleks dengan banyak rute, navigasi bersarang yang dalam, atau kebutuhan _deep linking_ dan _web support_ dapat menjadi rumit dengan API dasar. Di sinilah **router package** pihak ketiga masuk. Mereka menyediakan abstraksi tingkat lebih tinggi dan alat yang lebih canggih untuk mengelola navigasi.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan diperkenalkan pada konsep _router package_ sebagai solusi navigasi yang lebih canggih di Flutter. Mereka akan mendapatkan gambaran singkat tentang dua _package_ paling populer, **`GoRouter`** (yang direkomendasikan Google) dan **`AutoRouter`**, memahami fitur utama dan kasus penggunaan mereka. Tujuan bagian ini adalah untuk memberikan wawasan tentang kapan dan mengapa _package_ ini mungkin lebih disukai daripada API `Navigator` bawaan.

**Konsep Kunci & Filosofi Umum Router Packages:**

- **Deklaratif vs. Imperatif:** API `Navigator` bawaan Flutter bersifat **imperatif** (Anda memberi tahu `Navigator` "push ini", "pop itu"). Router _package_ cenderung lebih **deklaratif** (Anda mendefinisikan seluruh _tree_ rute aplikasi Anda, dan _router_ yang menangani transisi).
- **Centralized Route Configuration:** Semua definisi rute, termasuk parameter dan _path_, dikelola di satu tempat.
- **Deep Linking:** Dukungan yang lebih baik untuk _deep linking_ (membuka aplikasi ke layar tertentu dari URL atau notifikasi).
- **Web Support:** Navigasi yang bekerja mulus di web, dengan URL yang sesuai dan penanganan tombol kembali _browser_.
- **Parameter Passing:** Penanganan parameter rute yang lebih mudah dan seringkali lebih tipe-aman.
- **Nested Navigation Abstraction:** Menyederhanakan pengelolaan navigasi bersarang.
- **Redirects & Guards:** Kemampuan untuk mengarahkan pengguna berdasarkan kondisi tertentu (misalnya, jika belum _login_).

---

#### 7.6.1 `GoRouter`

**Deskripsi:**
**`GoRouter`** adalah _declarative router package_ yang direkomendasikan oleh tim Flutter di Google. Ini dirancang untuk penanganan URL, _deep linking_, dan navigasi kompleks dengan cara yang mudah dipahami dan kuat. Ini adalah pilihan yang sangat baik untuk aplikasi yang menargetkan banyak platform, termasuk web.

**Fitur Utama:**

- **URL-based Routing:** Mendefinisikan rute sebagai _path_ URL (misalnya, `/home`, `/details/:id`, `/settings`).
- **Declarative API:** Anda mendefinisikan _tree_ rute statis di awal aplikasi.
- **Deep Linking & Web Support:** Secara otomatis menangani URL masuk dan memastikan navigasi web berfungsi seperti yang diharapkan (termasuk _browser history_).
- **Parameters:** Mudah untuk meneruskan dan membaca parameter dari URL (misalnya, `product/:id`).
- **Redirects:** Kemampuan untuk mengarahkan pengguna ke rute lain berdasarkan logika aplikasi (misalnya, mengarahkan ke halaman _login_ jika pengguna belum terautentikasi).
- **Nested Navigation:** Dukungan yang sangat baik untuk navigasi bersarang dengan cara yang terstruktur.
- **`GoRouterDelegate` dan `GoRouteInformationParser`:** Berintegrasi dengan `Router` API dari Flutter.

**Contoh Sintaks (Konseptual):**

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/details/123'), // Navigasi dengan GoRouter
              child: const Text('Go to Detail 123'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(
        child: Text('Product ID: $id'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'), // Kembali ke home
          child: const Text('Back to Home'),
        ),
      ),
    );
  }
}

// Router configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [ // Nested routes example for profile within home
        GoRoute(
          path: 'profile', // Full path will be /profile
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/details/:id', // Route with a parameter
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailScreen(id: id);
      },
    ),
  ],
  // Optional: Redirects for authentication etc.
  redirect: (context, state) {
    // Example: If not logged in, go to login page
    // final bool loggedIn = /* check auth state */;
    // final bool goingToLogin = state.matchedLocation == '/login';
    // if (!loggedIn && !goingToLogin) return '/login';
    // return null; // No redirect
  },
);

void main() {
  runApp(
    MaterialApp.router( // Use MaterialApp.router with GoRouter
      routerConfig: _router,
    ),
  );
}
```

**Kelebihan:**

- Sangat direkomendasikan oleh tim Flutter.
- Dukungan _deep linking_ dan web yang sangat baik.
- API deklaratif yang kuat untuk struktur rute kompleks.
- Kemampuan _redirect_ dan _guard_ yang fleksibel.

**Kekurangan:**

- Kurva pembelajaran sedikit lebih tinggi dari API dasar.
- Mungkin terasa berlebihan untuk aplikasi yang sangat sederhana.

---

#### 7.6.2 `AutoRouter`

**Deskripsi:**
**`AutoRouter`** adalah _declarative router package_ yang memanfaatkan _code generation_ untuk menyederhanakan konfigurasi rute dan memastikan keamanan tipe. Ini sangat populer di kalangan pengembang yang menginginkan solusi yang sangat tipe-aman dan otomatis untuk navigasi kompleks.

**Fitur Utama:**

- **Code Generation:** Anda menulis definisi rute menggunakan anotasi, dan `AutoRouter` menghasilkan kode navigasi yang sebenarnya. Ini mengurangi _boilerplate_ dan meningkatkan keamanan tipe.
- **Type Safety:** Karena _code generation_, parameter rute dapat diteruskan dan diterima dengan tipe yang aman (misalnya, `push(ProductRoute(id: 123))`).
- **Nested Navigation:** Dukungan yang sangat baik untuk navigasi bersarang dengan cara yang rapi.
- **Guards:** Mirip dengan `GoRouter`, Anda dapat mendefinisikan _guard_ untuk mengontrol akses ke rute tertentu.
- **Route Observer:** Kemampuan untuk memantau perubahan rute.
- **Web & Deep Linking:** Dukungan untuk skenario web dan _deep linking_.

**Contoh Sintaks (Konseptual):**

```dart
// app_router.dart (Definisi rute dengan anotasi)
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Part file yang akan digenerate
part 'app_router.gr.dart';

// Screens (harus diimpor di sini)
import 'main.dart'; // Asumsikan HomeScreen, DetailScreen, ProfileScreen ada di main.dart

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/'),
        AutoRoute(page: DetailRoute.page, path: '/details/:id'), // Parameter di path
        AutoRoute(page: ProfileRoute.page, path: '/profile'),
      ];
}

// Screens Anda harus menjadi PageRouteInfo untuk AutoRouter
// Biasanya dibuat di file terpisah atau diatur sebagai bagian dari kelas utama
// Pastikan setiap halaman memiliki @RoutePage()
@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.pushRoute(DetailRoute(id: '456')), // Tipe-aman!
              child: const Text('Go to Detail 456'),
            ),
            ElevatedButton(
              onPressed: () => context.pushRoute(const ProfileRoute()),
              child: const Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class DetailScreen extends StatelessWidget {
  final String id;
  const DetailScreen({super.key, @PathParam('id') required this.id}); // Anotasi untuk parameter
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(
        child: Text('Product ID: $id'),
      ),
    );
  }
}

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.popRoute(), // pop route
          child: const Text('Back'),
        ),
      ),
    );
  }
}

// main.dart (menggunakan AutoRouter)
// final _appRouter = AppRouter(); // Inisialisasi router

// void main() {
//   runApp(
//     MaterialApp.router(
//       routerConfig: _appRouter.config(), // Menggunakan config dari AutoRouter
//     ),
//   );
// }
// Perintah untuk generate: flutter pub run build_runner build --delete-conflicting-outputs
```

**Kelebihan:**

- Sangat tipe-aman karena _code generation_.
- Mengurangi _boilerplate_ untuk definisi rute dan _argument passing_.
- Penanganan navigasi bersarang dan _guard_ yang kuat.

**Kekurangan:**

- Membutuhkan _code generation_, yang menambah langkah _build_ dan bisa sedikit memperlambat pengembangan.
- Kurva pembelajaran yang lebih tinggi dan membutuhkan pemahaman tentang anotasi dan _generator_.

---

#### 7.6.3 Kapan Menggunakan Router Package

Memilih antara API `Navigator` bawaan dan _router package_ pihak ketiga seperti `GoRouter` atau `AutoRouter` bergantung pada kompleksitas proyek dan preferensi tim Anda.

**Gunakan API `Navigator` Bawaan (`Navigator.push`, `pushNamed`, dll.) Jika:**

- **Aplikasi Sederhana:** Proyek Anda memiliki beberapa halaman dan struktur navigasi yang linear atau hanya beberapa tingkat navigasi bersarang yang sederhana.
- **Pengembangan Cepat untuk Aplikasi Kecil:** Untuk prototipe atau aplikasi yang tidak memerlukan _deep linking_ atau dukungan web yang kompleks.
- **Minimasi Dependensi Eksternal:** Anda ingin menjaga jumlah _package_ eksternal seminimal mungkin.
- **Kontrol Penuh:** Anda ingin kontrol yang sangat granular dan eksplisit atas setiap operasi navigasi.

**Gunakan Router Package (`GoRouter`, `AutoRouter`) Jika:**

- **Aplikasi Skala Besar/Menengah:** Proyek Anda diperkirakan akan berkembang pesat dengan banyak rute, alur navigasi yang kompleks, dan _nested navigation_ yang dalam.
- **Dukungan Web & Deep Linking adalah Kunci:** Aplikasi Anda harus berfungsi dengan baik di web atau membutuhkan kemampuan _deep linking_ yang canggih (misalnya, membuka aplikasi ke layar tertentu dari URL atau notifikasi).
- **Pengelolaan State Navigasi Terpusat:** Anda ingin semua definisi rute dan logika navigasi terpusat dan terstruktur dengan baik.
- **Keamanan Tipe (Terutama `AutoRouter`):** Anda menginginkan jaminan keamanan tipe saat meneruskan argumen antar rute.
- **Redirects & Guards:** Anda memiliki kebutuhan untuk mengarahkan pengguna berdasarkan kondisi tertentu (misalnya, autentikasi, otorisasi).
- **Tim Berpengalaman:** Tim Anda nyaman dengan konsep deklaratif dan _code generation_.

**Kesimpulan Pemilihan:**

Untuk sebagian besar proyek, terutama bagi pemula, disarankan untuk memulai dengan **API `Navigator` bawaan (dengan _named routes_)**. Ini akan memberikan pemahaman yang kuat tentang dasar-dasar navigasi Flutter.

Ketika aplikasi Anda tumbuh dalam kompleksitas, dan Anda mulai merasakan kesulitan dalam mengelola _named routes_, _argument passing_, _deep linking_, atau _nested navigation_ secara manual, pertimbangkan untuk beralih ke **`GoRouter`**. `GoRouter` adalah pilihan yang solid dan direkomendasikan untuk sebagian besar aplikasi modern Flutter karena keseimbangan antara fleksibilitas dan struktur.

Jika Anda sangat menghargai keamanan tipe dan kenyamanan _code generation_ untuk manajemen rute yang sangat kompleks, **`AutoRouter`** adalah alternatif yang kuat.

---

**Kesimpulan Fase 7: Routing dan Navigasi**

Fase ini telah membekali Anda dengan pengetahuan mendalam tentang bagaimana navigasi bekerja di Flutter, dari konsep dasar _navigator stack_ hingga teknik manipulasi _stack_ yang canggih. Anda kini dapat:

- Berpindah antar halaman menggunakan `Navigator.push` dan `pop`.
- Meneruskan dan mengembalikan data antar halaman.
- Mengelola rute dengan nama menggunakan `pushNamed`.
- Mengontrol _stack_ navigasi dengan `pushReplacement`, `popUntil`, dan `pushAndRemoveUntil`.
- Memahami dan mengimplementasikan navigasi bersarang untuk UI yang kompleks.
- Mengetahui kapan harus mempertimbangkan penggunaan _router package_ seperti `GoRouter` atau `AutoRouter`.

Anda sekarang memiliki alat yang diperlukan untuk membangun alur navigasi yang intuitif dan fungsional di aplikasi Flutter Anda.

---

# Selamat!

Dengan ini, kita telah menyelesaikan seluruh **Fase 7: Routing dan Navigasi**. Selanjutnya kita akan masuk pada **Fase 8: Asynchronous Programming dan Konektivitas Jaringan**

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md

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
