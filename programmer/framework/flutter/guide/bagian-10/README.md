# [FASE 8: Asynchronous Programming dan Konektivitas Jaringan][0]

Dengan rampungnya **Fase 7: Routing dan Navigasi**, Anda kini memiliki pemahaman yang solid tentang cara pengguna bergerak di aplikasi Anda. Sekarang saatnya melangkah lebih jauh dan mempelajari bagaimana aplikasi dapat berinteraksi dengan dunia luar. Fase 8 ini adalah bagian krusial untuk membangun aplikasi modern yang dinamis dan terhubung.

---

Di dunia aplikasi modern, jarang sekali sebuah aplikasi yang sepenuhnya berdiri sendiri. Kebanyakan aplikasi perlu mengambil data dari internet (misalnya, API REST), menyimpan data secara lokal tanpa memblokir UI, atau melakukan operasi yang memakan waktu. Fase ini akan membekali Anda dengan keterampilan yang diperlukan untuk menangani operasi-operasi tersebut tanpa membuat aplikasi Anda "beku" atau tidak responsif.

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- [8.1 Konsep Dasar Asynchronous Programming di Dart](#81-konsep-dasar-asynchronous-programming-di-dart)
  - [8.1.1 Mengapa Asynchronous Penting? (Main Thread Blocking)](#811-mengapa-asynchronous-penting-main-thread-blocking)
  - [8.1.2 `Future` dan `async`/`await`](#812-future-dan-asyncawait)
  - [8.1.3 Error Handling dengan `try-catch`](#813-error-handling-dengan-try-catch)
- [8.2 Menggunakan `FutureBuilder` untuk UI Asinkron](#82-menggunakan-futurebuilder-untuk-ui-asinkron)
  - [8.2.1 Membangun UI Berdasarkan State `Future`](#821-membangun-ui-berdasarkan-state-future)
  - [8.2.2 Menangani Berbagai State Koneksi (`ConnectionState`)](#822-menangani-berbagai-state-koneksi-connectionstate)
- [8.3 Menggunakan `Stream` dan `StreamBuilder` untuk Data Real-time](#83-menggunakan-stream-dan-streambuilder-untuk-data-real-time)
  - [8.3.1 Apa itu `Stream`?](#831-apa-itu-stream)
  - [8.3.2 Membangun UI Berdasarkan State `Stream`](#832-membangun-ui-berdasarkan-state-stream)
  - [8.3.3 Skenario Penggunaan `Stream`](#833-skenario-penggunaan-stream)
- [8.4 Konektivitas Jaringan (HTTP Requests)](#84-konektivitas-jaringan-http-requests)
  - [8.4.1 Menggunakan Package `http`](#841-menggunakan-package-http)
  - [8.4.2 Melakukan GET Request dan Parsing JSON](#842-melakukan-get-request-dan-parsing-json)
  - [8.4.3 Melakukan POST, PUT, DELETE Request](#843-melakukan-post-put-delete-request)
  - [8.4.4 Error Handling Jaringan](#844-error-handling-jaringan)
- [8.5 Pemodelan Data (Serialization/Deserialization)](#85-pemodelan-data-serializationdeserialization)
  - [8.5.1 Konsep JSON dan Data Pemodelan](#851-konsep-json-dan-data-pemodelan)
  - [8.5.2 Manual JSON Parsing](#852-manual-json-parsing)
  - [8.5.3 Menggunakan Package `json_serializable`](#853-menggunakan-package-json_serializable)

</details>

---

### 8.1 Konsep Dasar Asynchronous Programming di Dart

Setiap aplikasi mobile modern, terutama yang berinteraksi dengan jaringan, perlu melakukan pekerjaan tanpa mengunci antarmuka penggunanya. Di sinilah **asynchronous programming** menjadi sangat penting.

#### 8.1.1 Mengapa Asynchronous Penting? (Main Thread Blocking)

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami masalah **"Main Thread Blocking"** (juga dikenal sebagai UI freezing atau ANR - Application Not Responding) dan mengapa **asynchronous programming** adalah solusi krusial untuk masalah ini. Mereka akan belajar bahwa operasi yang memakan waktu (seperti panggilan jaringan, pembacaan file besar, atau komputasi intensif) harus dieksekusi secara asinkron agar antarmuka pengguna tetap responsif.

**Konsep Kunci & Filosofi Mendalam:**

- **Main Thread (UI Thread):**

  - **Konsep:** Setiap aplikasi (baik Android, iOS, atau Flutter) memiliki **Main Thread** (atau UI Thread). Ini adalah satu-satunya _thread_ yang bertanggung jawab untuk menggambar UI, memproses _event_ sentuhan/klik, dan menjalankan sebagian besar kode aplikasi Anda.
  - **Filosofi:** Ini adalah desain yang disengaja. Dengan memiliki satu _thread_ untuk UI, kompleksitas sinkronisasi dan potensi masalah _thread-safety_ berkurang. Semua pembaruan UI harus terjadi pada _Main Thread_ untuk menjaga konsistensi.

- **Blocking (Main Thread Blocking/UI Freezing/ANR):**

  - **Konsep:** Jika Anda menjalankan operasi yang memakan waktu (misalnya, mengambil data dari internet yang butuh 5 detik) langsung di **Main Thread**, maka _thread_ tersebut akan "terblokir" atau "terjebak" selama 5 detik tersebut. Selama waktu itu, aplikasi tidak dapat menggambar ulang UI, memproses input pengguna (ketukan tombol), atau melakukan hal lain. Aplikasi akan terlihat "beku" atau "macet." Di Android, ini bisa memicu dialog **ANR (Application Not Responding)**.
  - **Filosofi:** Pengalaman pengguna yang buruk. Pengguna mengharapkan aplikasi merespons secara instan. Memblokir UI _thread_ merusak harapan ini dan membuat aplikasi terasa lambat dan tidak profesional.

- **Asynchronous Programming (Non-Blocking):**

  - **Konsep:** Asynchronous programming adalah paradigma di mana operasi yang memakan waktu dimulai di latar belakang, dan **Main Thread** tidak menunggu hasilnya. Sebaliknya, _Main Thread_ melanjutkan pekerjaannya (misalnya, terus menggambar UI). Ketika operasi di latar belakang selesai, ia memberi tahu _Main Thread_ hasilnya (atau kesalahannya).
  - **Filosofi:** Memastikan **responsivitas UI**. Ini adalah kunci untuk membangun aplikasi yang terasa mulus dan profesional, bahkan saat melakukan pekerjaan berat. Dart, seperti banyak bahasa modern, memiliki dukungan bawaan yang kuat untuk pemrograman asinkron.

**Analogi:**
Bayangkan Anda seorang koki (`Main Thread`) di restoran. Anda menerima pesanan (`UI events`) dan menyiapkan makanan (`rendering UI`).

- **Synchronous (Blocking):** Ada pesanan yang membutuhkan waktu lama (misalnya, memanggang kue selama 1 jam). Jika Anda memanggang kue sendiri dari awal sampai akhir, Anda tidak bisa menerima pesanan lain atau menyiapkan hidangan lain sampai kue itu selesai. Pelanggan lain akan menunggu dan marah.
- **Asynchronous (Non-Blocking):** Anda mulai memanggang kue, tetapi segera setelah kue masuk oven, Anda tidak menunggu di depan oven. Anda melanjutkan menerima pesanan lain, menyiapkan hidangan lain, dll. Ketika _timer_ kue berbunyi (`operasi asinkron selesai`), Anda akan tahu bahwa kue sudah siap dan Anda bisa mengeluarkannya. Anda selalu sibuk dan efisien.

**Hubungan dengan Modul Lain:**
Ini adalah fondasi untuk semua bagian selanjutnya dalam Fase 8, terutama konektivitas jaringan (8.4) dan pemodelan data (8.5), karena semua operasi ini bersifat asinkron.

---

#### 8.1.2 `Future` dan `async`/`await`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan diperkenalkan pada konsep **`Future`** sebagai representasi nilai yang akan tersedia di masa depan. Mereka akan belajar menggunakan kata kunci **`async`** untuk menandai fungsi sebagai asinkron, dan **`await`** untuk menunggu hasil dari `Future` tanpa memblokir _Main Thread_. Ini adalah inti dari cara Dart menangani operasi asinkron.

**Konsep Kunci & Filosofi Mendalam:**

- **`Future<T>`:**

  - **Konsep:** Sebuah objek `Future<T>` merepresentasikan hasil dari operasi asinkron. `T` adalah tipe data yang diharapkan akan dikembalikan oleh operasi tersebut di masa depan. Sebuah `Future` bisa berada dalam salah satu dari tiga _state_:
    - **Uncompleted:** Operasi belum selesai.
    - **Completed with a value:** Operasi selesai dengan sukses dan menghasilkan nilai.
    - **Completed with an error:** Operasi selesai dengan kesalahan.
  - **Filosofi:** Daripada mengembalikan nilai secara langsung (yang akan memblokir), sebuah `Future` segera dikembalikan. Ini adalah "janji" bahwa nilai akan tersedia (atau kesalahan akan terjadi) di masa depan. Ini memungkinkan _Main Thread_ untuk melanjutkan, dan kode yang bergantung pada `Future` tersebut dapat "mengunci" ke janji itu dan bereaksi ketika selesai.

- **`async` Keyword:**

  - **Konsep:** Digunakan untuk menandai sebuah fungsi bahwa ia akan melakukan pekerjaan asinkron dan/atau akan menggunakan kata kunci `await` di dalamnya. Fungsi `async` selalu mengembalikan `Future`.
  - **Filosofi:** Ini adalah sinyal ke Dart _runtime_ bahwa fungsi ini tidak akan selesai secara instan. Ketika Dart melihat `async`, ia tahu bahwa _return value_ fungsi ini harus dibungkus dalam `Future`.

- **`await` Keyword:**

  - **Konsep:** Digunakan di dalam fungsi `async` untuk "menunggu" sebuah `Future` selesai. Ketika Dart melihat `await`, ia akan **menangguhkan eksekusi** fungsi `async` tersebut hingga `Future` yang di-_await_ selesai. **Penting:** Penangguhan ini **tidak memblokir Main Thread**. Sebaliknya, _Main Thread_ bebas untuk melakukan pekerjaan lain selama penangguhan. Setelah `Future` selesai, eksekusi fungsi `async` dilanjutkan dari titik `await`.
  - **Filosofi:** Membuat kode asinkron terlihat dan terasa seperti kode sinkron, sehingga lebih mudah dibaca dan ditulis, tanpa mengorbankan responsivitas. Ini adalah "syntactic sugar" yang sangat kuat di atas `Future` dan _callbacks_.

**Visualisasi Diagram Alur/Struktur (`async`/`await`):**

```
// Main Thread
Start app
Call `fetchData()` (an async function)
  |
  V
  `fetchData()` function starts
    Performs `await fetch_from_network()`
      | (Execution of `fetchData` pauses here)
      |   Main Thread is now FREE to do other things (redraw UI, process clicks)
      V
    (Network request happens in background)
      |
      V
    (Network request finishes)
      | (Result is ready, `fetchData` resumes)
      V
    Process data
    Return data (wrapped in a Future)
  | (Result from `fetchData` is now available)
  V
Continue Main Thread operations
```

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'dart:io'; // Untuk simulasi delay

// Fungsi yang mengembalikan Future (simulasi operasi jaringan)
Future<String> fetchUserData() async {
  print('Fetching user data...');
  // Simulasi penundaan jaringan 2 detik
  await Future.delayed(const Duration(seconds: 2));
  print('User data fetched!');
  return '{"name": "Alice", "age": 30}'; // Contoh data JSON
}

// Fungsi utama aplikasi
void main() async { // Tandai main sebagai async karena akan menggunakan await
  print('App started.');

  // Memanggil fungsi asinkron dan menunggu hasilnya
  String userData = await fetchUserData(); // await menangguhkan eksekusi di sini
  print('Received data: $userData');

  print('App finished.');

  // Contoh tanpa await (akan mencetak "Future: Instance of 'Future<String>'"
  // karena tidak menunggu hasilnya)
  // Future<String> dataFuture = fetchUserData();
  // print('Received Future: $dataFuture');
}
```

**Penjelasan Konteks Kode:**

- `fetchUserData()`: Ditandai `async`, sehingga mengembalikan `Future<String>`. Di dalamnya, `await Future.delayed(...)` mensimulasikan operasi yang memakan waktu. Selama 2 detik ini, _Main Thread_ tidak diblokir.
- `main()`: Juga ditandai `async` karena ia memanggil `fetchUserData()` dengan `await`.
- `String userData = await fetchUserData();`: Baris ini akan menangguhkan eksekusi `main()` selama `fetchUserData()` berjalan. Namun, karena `main()` sendiri bersifat asinkron, _runtime_ Dart akan mengizinkan kode lain untuk dieksekusi (misalnya, pembaruan UI jika ini di dalam _widget tree_). Setelah `fetchUserData()` selesai, nilai yang dikembalikan akan diberikan ke `userData`, dan `main()` akan melanjutkan.
- Output akan menunjukkan:
  ```
  App started.
  Fetching user data...
  (2 detik jeda)
  User data fetched!
  Received data: {"name": "Alice", "age": 30}
  App finished.
  ```
  Ini menunjukkan bahwa `App finished.` tidak akan dicetak sampai `fetchUserData()` selesai.

---

#### 8.1.3 Error Handling dengan `try-catch`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar bagaimana menangani kesalahan yang terjadi selama eksekusi operasi asinkron menggunakan blok **`try-catch`** di dalam fungsi `async`. Ini sangat penting untuk membuat aplikasi yang tangguh dan memberikan umpan balik yang tepat kepada pengguna saat terjadi masalah (misalnya, kegagalan jaringan).

**Konsep Kunci & Filosofi Mendalam:**

- **Exception in Futures:** Sama seperti kode sinkron, operasi asinkron dapat melempar _exception_ (kesalahan). Jika `Future` selesai dengan kesalahan dan tidak ditangani, aplikasi dapat _crash_ atau menampilkan pesan kesalahan yang tidak ramah.
- **`try-catch` with `async`/`await`:** Salah satu keuntungan besar dari `async`/`await` adalah kemampuannya untuk menggunakan mekanisme penanganan kesalahan sinkron (`try-catch`) untuk kode asinkron. Ini membuat penanganan kesalahan jauh lebih mudah dibaca dan ditulis dibandingkan dengan menggunakan _callbacks_ (`.catchError()` pada `Future`).
- **Syntax:**
  ```dart
  try {
    // Kode asinkron yang mungkin melempar exception
    await someAsyncOperation();
  } catch (e) {
    // Tangani exception di sini
    print('An error occurred: $e');
  }
  ```
  - `e` adalah objek _exception_.
  - Anda juga bisa menambahkan `finally` untuk kode yang selalu dijalankan, terlepas dari apakah ada _exception_ atau tidak.

**Contoh Sintaks (Error Handling):**

```dart
import 'dart:io'; // Untuk simulasi delay

// Fungsi yang mungkin melempar error
Future<String> riskyOperation() async {
  print('Starting risky operation...');
  await Future.delayed(const Duration(seconds: 1)); // Simulasi delay
  final random = (DateTime.now().microsecondsSinceEpoch % 2 == 0); // Random success/fail
  if (random) {
    throw Exception('Failed to fetch data: Network unavailable!'); // Melempar exception
  }
  print('Risky operation completed successfully!');
  return 'Data from risky operation';
}

void main() async {
  print('App started.');

  try {
    String data = await riskyOperation();
    print('Successfully got data: $data');
  } catch (e) {
    // Menangkap dan menangani exception
    print('Caught an error: $e');
    // Anda bisa memberikan feedback ke UI di sini, log error, dll.
  } finally {
    print('Risky operation attempt finished.');
  }

  print('App finished.');
}
```

**Penjelasan Konteks Kode:**

- `riskyOperation()`: Fungsi ini secara acak akan melempar `Exception` atau mengembalikan _string_.
- `try-catch` di `main()`:
  - Blok `try` berisi panggilan ke `riskyOperation()`. Jika `riskyOperation()` melempar _exception_, eksekusi akan langsung melompat ke blok `catch`.
  - Blok `catch (e)` menangkap _exception_ yang dilempar. Di sini, kita hanya mencetaknya, tetapi dalam aplikasi nyata, Anda akan melakukan hal-hal seperti menampilkan pesan kesalahan kepada pengguna, mencatat kesalahan, atau mencoba kembali operasi.
  - Blok `finally` selalu dieksekusi, tidak peduli apakah `try` berhasil atau melempar _exception_.

**Terminologi Esensial:**

- **Main Thread (UI Thread):** _Thread_ utama yang bertanggung jawab atas UI dan _event_.
- **Blocking:** Menghentikan eksekusi _thread_ sampai operasi selesai.
- **Asynchronous Programming:** Memulai operasi tanpa memblokir, memungkinkan _thread_ untuk melanjutkan pekerjaan lain.
- **`Future<T>`:** Objek yang merepresentasikan nilai yang akan tersedia di masa depan.
- **`async`:** Kata kunci untuk menandai fungsi yang akan melakukan pekerjaan asinkron dan mengembalikan `Future`.
- **`await`:** Kata kunci yang digunakan dalam fungsi `async` untuk menunggu `Future` selesai tanpa memblokir _Main Thread_.
- **`try`:** Blok kode di mana _exception_ mungkin terjadi.
- **`catch`:** Blok kode untuk menangani _exception_ yang terjadi di blok `try`.
- **`Exception`:** Sebuah objek yang dilemparkan ketika terjadi kesalahan.

**Sumber Referensi Lengkap:**

- [Asynchrony support (Dart Language Tour)](https://dart.dev/language/async)
- [Futures, async, await (Flutter Docs)](https://docs.flutter.dev/data/network/fetch-data)
- [Control flow statements (Dart Language Tour - for try-catch)](https://dart.dev/language/control-flow%23try-catch-finally)

**Tips dan Praktik Terbaik:**

- **Jangan Blokir Main Thread:** Ini adalah aturan emas dalam pengembangan UI. Selalu gunakan `async`/`await` untuk operasi yang memakan waktu.
- **Selalu Tangani Error Asinkron:** Operasi jaringan, file, atau komputasi sering gagal. Gunakan `try-catch` untuk menangani kegagalan ini dengan anggun dan memberikan umpan balik yang baik kepada pengguna.
- **Pahami Alur `async`/`await`:** Visualisasikan bagaimana `await` menangguhkan eksekusi fungsi `async` yang sedang berjalan, tetapi membebaskan _Main Thread_.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Lupa menggunakan `await` pada panggilan fungsi `async`.

  - **Penyebab:** Fungsi `async` akan mengembalikan `Future` secara instan, dan kode Anda akan mencoba bekerja dengan `Future` yang belum selesai, bukan nilai yang sebenarnya.
  - **Solusi:** Pastikan Anda menggunakan `await` di depan setiap panggilan `Future` jika Anda ingin menunggu hasilnya sebelum melanjutkan.

- **Kesalahan:** Lupa menandai fungsi sebagai `async` saat mencoba menggunakan `await` di dalamnya.

  - **Penyebab:** Kompiler Dart akan memberikan kesalahan karena `await` hanya dapat digunakan di dalam fungsi `async`.
  - **Solusi:** Tambahkan kata kunci `async` sebelum badan fungsi (misalnya, `Future<void> myFunction() async { ... }`).

- **Kesalahan:** Tidak menangani _exception_ dari `Future`.

  - **Penyebab:** Jika `Future` selesai dengan kesalahan dan tidak ada blok `catch` yang menanganinya, itu dapat menyebabkan _crash_ aplikasi.
  - **Solusi:** Selalu bungkus operasi asinkron yang berpotensi gagal dengan `try-catch` atau gunakan metode `.catchError()` pada `Future` (meskipun `try-catch` lebih disukai dengan `async`/`await`).

---

Setelah memahami fondasi **Asynchronous Programming** di Dart, sekarang saatnya melihat bagaimana kita dapat mengintegrasikan operasi asinkron ini langsung ke dalam antarmuka pengguna Flutter.

### 8.2 Menggunakan `FutureBuilder` untuk UI Asinkron

Aplikasi sering kali perlu menampilkan data yang berasal dari operasi asinkron, seperti pengambilan data dari server. Selama operasi ini berlangsung, UI harus dapat menunjukkan status (misalnya, _loading_), dan setelah operasi selesai, UI harus memperbarui dirinya untuk menampilkan data atau pesan kesalahan. Di sinilah **`FutureBuilder`** berperan.

#### 8.2.1 Membangun UI Berdasarkan State `Future`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar bagaimana **`FutureBuilder<T>`** adalah _widget_ Flutter yang dirancang khusus untuk membangun UI berdasarkan hasil dari sebuah `Future`. Mereka akan memahami properti kuncinya: `future` (yang menerima `Future` yang akan diawasi) dan `builder` (fungsi yang akan membangun _widget_ berdasarkan _state_ `Future` tersebut).

**Konsep Kunci & Filosofi Mendalam:**

- **`FutureBuilder<T>` Widget:**

  - **Konsep:** `FutureBuilder` adalah _widget_ **`StatefulWidget`** yang secara internal memantau `Future` yang diberikan kepadanya. Setiap kali _state_ `Future` berubah (dari _uncompleted_ ke _completed with data_ atau _completed with error_), `FutureBuilder` akan me-_rebuild_ dirinya sendiri dengan `snapshot` data terbaru. `T` adalah tipe data yang diharapkan dari `Future`.
  - **Filosofi:** Ini adalah pola desain yang umum dalam Flutter untuk menangani data asinkron secara **deklaratif**. Daripada secara manual memanggil `setState` setelah `Future` selesai (yang bisa jadi rumit di banyak tempat), `FutureBuilder` mengotomatiskan pembaruan UI saat data asinkron siap. Ini memisahkan logika pengambilan data dari logika presentasi UI.

- **Properti `future`:**

  - **Konsep:** Anda memberikan _instance_ `Future` ke properti ini. `FutureBuilder` akan "mendengarkan" `Future` ini. Penting: `Future` yang diberikan haruslah _instance_ yang sama selama _lifecycle_ `FutureBuilder` jika Anda ingin menghindari _re-fetch_ yang tidak perlu. Seringkali, `Future` dibuat sekali di `initState` atau sebagai _variable_ final di `StatefulWidget`.
  - **Filosofi:** Menghubungkan _widget_ UI dengan operasi asinkron. Ini adalah "kontrak" yang memberi tahu `FutureBuilder` apa yang harus dipantau.

- **Properti `builder`:**

  - **Konsep:** Sebuah fungsi `Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)` yang dipanggil setiap kali `FutureBuilder` perlu membangun ulang UI. Fungsi ini menerima `BuildContext` dan `AsyncSnapshot<T>`.
  - **Filosofi:** Ini adalah tempat di mana Anda mendefinisikan bagaimana UI akan terlihat di berbagai _state_ `Future` (loading, sukses, error). `AsyncSnapshot` adalah objek yang berisi semua informasi tentang _state_ `Future` saat ini.

**Visualisasi Diagram Alur/Struktur:**

```
[FutureBuilder Widget]
      |
      | Properti `future` (misal: fetchData())
      V
  [Future starts]
      | (Uncompleted state)
      V
[Builder Function]
  |  snapshot.connectionState == ConnectionState.waiting
  |  -> Tampilkan `CircularProgressIndicator`
  |
  V
[Future completes]
      | (Completed with data/error)
      V
[Builder Function]
  |  snapshot.hasData == true
  |  -> Tampilkan data: `snapshot.data`
  |
  V
[Builder Function]
  |  snapshot.hasError == true
  |  -> Tampilkan pesan error: `snapshot.error`
```

---

#### 8.2.2 Menangani Berbagai State Koneksi (`ConnectionState`)

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mendalami bagaimana objek **`AsyncSnapshot`** (yang diberikan ke fungsi `builder`) memungkinkan mereka memeriksa _state_ saat ini dari `Future` melalui properti `connectionState`, `hasData`, `hasError`, `data`, dan `error`. Mereka akan belajar cara membangun UI yang berbeda untuk setiap _state_ ini (misalnya, _loading spinner_, data yang ditampilkan, atau pesan kesalahan).

**Konsep Kunci & Filosofi Mendalam:**

- **`AsyncSnapshot<T> snapshot`:**

  - **Konsep:** Ini adalah objek yang berisi informasi tentang interaksi terbaru dengan `Future` atau `Stream` (dalam kasus `StreamBuilder`). Properti utamanya meliputi:
    - `snapshot.connectionState`: Enum `ConnectionState` yang menunjukkan _state_ saat ini.
    - `snapshot.hasData`: `true` jika `Future` telah selesai dengan data.
    - `snapshot.data`: Data yang dihasilkan oleh `Future` jika `hasData` adalah `true`.
    - `snapshot.hasError`: `true` jika `Future` telah selesai dengan kesalahan.
    - `snapshot.error`: Objek kesalahan jika `hasError` adalah `true`.
  - **Filosofi:** Memberikan semua informasi yang diperlukan untuk membuat keputusan rendering secara deklaratif. Dengan memeriksa properti ini, Anda dapat membangun UI yang adaptif dan informatif.

- **`ConnectionState` Enum:**

  - **`ConnectionState.none`**: `Future` belum dimulai (ini adalah _state_ awal sebelum `Future` diberikan ke `FutureBuilder` atau setelah `Future` berubah menjadi `null`).
  - **`ConnectionState.waiting`**: `Future` sedang berjalan dan belum selesai. Ini adalah tempat untuk menampilkan indikator _loading_.
  - **`ConnectionState.active`**: (Hanya relevan untuk `StreamBuilder`, di mana _stream_ aktif dan menghasilkan data secara berkala).
  - **`ConnectionState.done`**: `Future` telah selesai, baik dengan data maupun dengan kesalahan.

**Sintaks Dasar / Contoh Implementasi Inti (Gabungan 8.2.1 dan 8.2.2):**

```dart
import 'package:flutter/material.dart';
import 'dart:async'; // Untuk Future.delayed

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FutureBuilder Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const DataDisplayScreen(),
    );
  }
}

class DataDisplayScreen extends StatefulWidget {
  const DataDisplayScreen({super.key});

  @override
  State<DataDisplayScreen> createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  // 1. Deklarasikan Future sebagai field di State
  // Ini penting agar Future tidak dibuat ulang setiap kali build() dipanggil
  late Future<String> _dataFuture;

  @override
  void initState() {
    super.initState();
    // 2. Inisialisasi Future di initState
    _dataFuture = _fetchSomeData();
  }

  // Fungsi asinkron yang mengembalikan Future<String>
  Future<String> _fetchSomeData() async {
    print('Fetching data...');
    await Future.delayed(const Duration(seconds: 3)); // Simulasi penundaan
    // return 'Data berhasil diambil dari server!'; // Skenario sukses

    // Skenario error: Uncomment baris di bawah untuk mencoba penanganan error
    // throw Exception('Gagal mengambil data: Terjadi kesalahan jaringan!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FutureBuilder Example'),
      ),
      body: Center(
        // Menggunakan FutureBuilder
        child: FutureBuilder<String>( // Tipe T adalah String karena _dataFuture mengembalikan String
          future: _dataFuture, // Berikan Future yang akan diawasi
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            // 8.2.2 Menangani Berbagai State Koneksi
            if (snapshot.connectionState == ConnectionState.none) {
              // Future belum dimulai atau tidak ada Future yang diberikan
              return const Text('Tekan tombol untuk mengambil data.');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              // Future sedang berjalan (loading state)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(), // Indikator loading
                  SizedBox(height: 16),
                  Text('Memuat data...'),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              // Future telah selesai
              if (snapshot.hasError) {
                // Future selesai dengan error
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}', // Menampilkan pesan error
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _dataFuture = _fetchSomeData(); // Coba lagi
                        });
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                );
              } else if (snapshot.hasData) {
                // Future selesai dengan data sukses
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Data berhasil: ${snapshot.data!}', // Menampilkan data
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _dataFuture = _fetchSomeData(); // Muat ulang data
                        });
                      },
                      child: const Text('Muat Ulang Data'),
                    ),
                  ],
                );
              }
            }
            // Fallback: Jika tidak ada state yang cocok (jarang terjadi)
            return const Text('State tidak diketahui.');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _dataFuture = _fetchSomeData(); // Memulai ulang pengambilan data
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`_dataFuture` sebagai Field:** Variabel `_dataFuture` dideklarasikan di `_DataDisplayScreenState` dan diinisialisasi di `initState`. Ini penting\! Jika Anda menginisialisasi `_dataFuture` langsung di dalam `build` method, maka setiap kali `build` dipanggil (misalnya, karena _rebuild_ UI lainnya), `_fetchSomeData()` akan dipanggil lagi dan lagi, yang menyebabkan _infinite loop_ atau pengambilan data berulang yang tidak efisien.
2.  **`_fetchSomeData()`:** Fungsi asinkron ini mensimulasikan pengambilan data. Anda bisa mengomentari salah satu baris `return` atau `throw` untuk menguji skenario sukses atau kesalahan.
3.  **`FutureBuilder<String>`:**
    - `future: _dataFuture`: `FutureBuilder` akan mengawasi `_dataFuture`.
    - `builder: (BuildContext context, AsyncSnapshot<String> snapshot)`: Ini adalah fungsi yang membangun UI.
4.  **Penanganan `ConnectionState`:**
    - **`ConnectionState.none`**: Jika `_dataFuture` belum ada atau `null`.
    - **`ConnectionState.waiting`**: Menampilkan `CircularProgressIndicator` dan pesan _loading_.
    - **`ConnectionState.done`**: Setelah `Future` selesai, kita cek `snapshot.hasError` dan `snapshot.hasData`.
      - **`snapshot.hasError`**: Menampilkan ikon kesalahan, pesan kesalahan dari `snapshot.error`, dan tombol "Coba Lagi" yang akan memicu `_fetchSomeData()` lagi.
      - **`snapshot.hasData`**: Menampilkan ikon sukses, data dari `snapshot.data!`, dan tombol "Muat Ulang Data" untuk memicu pengambilan ulang.

**Terminologi Esensial:**

- **`FutureBuilder<T>`**: _Widget_ yang membangun UI berdasarkan _state_ `Future`.
- **`AsyncSnapshot<T>`**: Objek yang berisi _state_ dan data dari `Future` atau `Stream`.
- **`ConnectionState`**: Enum yang menunjukkan _state_ saat ini dari koneksi asinkron (none, waiting, active, done).
- **`snapshot.hasData`**: Properti boolean yang menunjukkan apakah `Future` telah selesai dengan data.
- **`snapshot.data`**: Properti yang berisi data hasil dari `Future` setelah selesai.
- **`snapshot.hasError`**: Properti boolean yang menunjukkan apakah `Future` telah selesai dengan kesalahan.
- **`snapshot.error`**: Properti yang berisi objek kesalahan jika terjadi.

**Sumber Referensi Lengkap:**

- [FutureBuilder class (Flutter Docs)](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html)
- [Cookbook: Fetch data from the internet](https://docs.flutter.dev/data/network/fetch-data) - Bagian tentang `FutureBuilder` sangat relevan.

**Tips dan Praktik Terbaik:**

- **Inisialisasi `Future` di `initState`:** Ini adalah praktik terbaik yang sangat penting. Membangun `Future` di `build` method akan menyebabkan `Future` dibuat ulang dan dieksekusi setiap kali _widget_ di-_rebuild_, yang hampir selalu bukan yang Anda inginkan.
- **Tangani Semua `ConnectionState`:** Pastikan UI Anda dapat menampilkan _state_ `loading`, `data`, dan `error` dengan jelas kepada pengguna.
- **Gunakan Tipe Generik yang Tepat:** Tentukan tipe `T` di `FutureBuilder<T>` (misalnya, `FutureBuilder<String>`) agar `snapshot.data` memiliki tipe yang benar dan Anda mendapatkan keamanan tipe.
- **Indikator Loading:** Selalu berikan indikator _loading_ (misalnya, `CircularProgressIndicator`) untuk menunjukkan bahwa aplikasi sedang memproses sesuatu.
- **Pesan Error yang Ramah Pengguna:** Jangan hanya menampilkan kesalahan teknis. Sampaikan pesan error yang mudah dimengerti pengguna dan berikan opsi untuk mencoba lagi jika relevan.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `Future` berulang kali di-_fetch_ atau di-_rebuild_.

  - **Penyebab:** `Future` diinisialisasi di dalam `build` method, sehingga setiap _rebuild_ (misalnya, karena `setState` di _ancestor_ _widget_) akan memicu panggilan ulang `Future`.
  - **Solusi:** Inisialisasi `Future` di `initState()` atau sebagai _variable_ `final` jika _widget_ tidak memiliki _state_ dan `Future` tidak perlu diubah.

- **Kesalahan:** `snapshot.data` atau `snapshot.error` adalah `null` ketika diakses tanpa memeriksa `hasData` atau `hasError`.

  - **Penyebab:** Anda mencoba mengakses data atau error padahal `Future` belum selesai atau selesai dengan _state_ yang berbeda.
  - **Solusi:** Selalu periksa `snapshot.hasData` dan `snapshot.hasError` sebelum mengakses `snapshot.data` atau `snapshot.error`. Gunakan _null-aware operators_ (`?` atau `!`) dengan bijak.

- **Kesalahan:** UI tidak memperbarui setelah `Future` selesai.

  - **Penyebab:** `FutureBuilder` mungkin tidak mendeteksi perubahan pada `Future` jika `Future` baru tidak diberikan ke properti `future`-nya, atau jika `Future` diubah tanpa `setState` di _parent_ `StatefulWidget`.
  - **Solusi:** Pastikan `Future` yang baru (jika Anda ingin memicu _re-fetch_) diberikan ke properti `future` dari `FutureBuilder` melalui `setState` di _parent widget_.

---

Setelah menguasai cara menampilkan data yang akan datang sekali di masa depan dengan `FutureBuilder`, sekarang saatnya mempelajari bagaimana menangani data yang datang secara berkelanjutan atau _real-time_.

### 8.3 Menggunakan `Stream` dan `StreamBuilder` untuk Data Real-time

Dalam banyak aplikasi modern, data tidak hanya diambil sekali, tetapi dapat berubah seiring waktu atau datang dalam serangkaian peristiwa. Contohnya termasuk pembaruan _feed_ sosial, notifikasi _push_, data sensor, atau _chat messages_. Di sinilah konsep **`Stream`** menjadi sangat berguna, dan **`StreamBuilder`** adalah _widget_ yang dirancang untuk membangun UI berdasarkan data dari `Stream`.

#### 8.3.1 Apa itu `Stream`?

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami konsep **`Stream`** sebagai urutan peristiwa asinkron. Mereka akan belajar bahwa berbeda dengan `Future` yang hanya menghasilkan satu nilai (atau kesalahan) di masa depan, `Stream` dapat menghasilkan **nol atau lebih** peristiwa (data atau kesalahan) secara berurutan dari waktu ke waktu.

**Konsep Kunci & Filosofi Mendalam:**

- **`Stream<T>`:**

  - **Konsep:** Sebuah `Stream<T>` adalah urutan peristiwa asinkron yang dapat menghasilkan data dari waktu ke waktu. `T` adalah tipe data dari peristiwa yang akan dihasilkan. Ini adalah representasi "aliran" data.
  - **Filosofi:** `Future` adalah seperti satu pengiriman paket: Anda menunggu satu paket, lalu selesai. `Stream` adalah seperti langganan koran: Anda terus menerima koran baru secara teratur, sampai Anda membatalkan langganan. Ini memungkinkan penanganan data _real-time_ atau data berbasis _event_.

- **Penerbit (`Stream Producer`) dan Pelanggan (`Stream Consumer`):**

  - **Penerbit:** Sumber yang menghasilkan peristiwa ke dalam `Stream`. Ini bisa berupa:
    - Fungsi `async*` (async generator functions) di Dart.
    - `StreamController` (untuk membuat _stream_ secara manual dan menambahkan peristiwa).
    - API yang sudah ada (misalnya, _package_ Firebase Firestore, WebSockets, data sensor).
  - **Pelanggan:** Kode yang "mendengarkan" `Stream` untuk menerima peristiwa yang dipancarkan.
    - Menggunakan metode seperti `listen()`, `forEach()`, `where()`, `map()`, dll.
    - Menggunakan `StreamBuilder` di Flutter (yang secara internal adalah pelanggan).
  - **Filosofi:** Konsep pub-sub (publish-subscribe) memungkinkan pemisahan antara sumber data dan konsumen data, meningkatkan modularitas dan reusabilitas.

- **Dua Jenis `Stream`:**

  - **Single-subscription streams:** _Stream_ ini hanya dapat memiliki satu pendengar (`listener`) selama _lifetimenya_. Jika Anda mencoba mendengarkannya lebih dari sekali, Anda akan mendapatkan kesalahan. Ini umum untuk operasi yang menghasilkan data secara berurutan dan tidak dapat diulang (misalnya, mengunduh file besar).
  - **Broadcast streams:** _Stream_ ini dapat memiliki nol atau lebih pendengar, dan Anda dapat mendengarkannya beberapa kali. Ini umum untuk peristiwa yang ingin didengarkan oleh beberapa bagian aplikasi (misalnya, notifikasi, perubahan status autentikasi). Anda bisa mengubah _single-subscription stream_ menjadi _broadcast stream_ dengan `.asBroadcastStream()`.
  - **Filosofi:** Memberikan fleksibilitas dalam cara data aliran dikonsumsi, sesuai dengan kebutuhan aplikasi.

**Analogi:**

- **Future:** Meminta kopi di kafe. Anda meminta satu kali, menunggu satu kopi, lalu selesai.
- **Stream:** Berlangganan layanan pengiriman kopi. Anda berlangganan sekali, lalu Anda akan terus menerima kopi setiap pagi sampai Anda membatalkan langganan.

---

#### 8.3.2 Membangun UI Berdasarkan State `Stream`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar bagaimana **`StreamBuilder<T>`** adalah _widget_ Flutter yang sangat mirip dengan `FutureBuilder`, tetapi dirancang untuk mendengarkan `Stream` dan membangun UI yang reaktif terhadap setiap peristiwa baru dari `Stream` tersebut. Mereka akan memahami bagaimana `builder` menerima `AsyncSnapshot` yang diperbarui setiap kali ada data baru.

**Konsep Kunci & Filosofi Mendalam:**

- **`StreamBuilder<T>` Widget:**

  - **Konsep:** Mirip dengan `FutureBuilder`, `StreamBuilder` adalah `StatefulWidget` yang memantau sebuah `Stream`. Setiap kali `Stream` menghasilkan data baru, `StreamBuilder` akan me-_rebuild_ bagian UI-nya yang ditentukan dalam fungsi `builder` dengan data terbaru.
  - **Filosofi:** Membuat UI _live_ dan responsif terhadap perubahan data. Ini adalah cara deklaratif dan efisien untuk memperbarui UI tanpa perlu manajemen `setState` manual yang kompleks setiap kali ada data baru dari _stream_.

- **Properti `stream`:**

  - **Konsep:** Anda memberikan _instance_ `Stream` ke properti ini. `StreamBuilder` akan mulai "mendengarkan" _stream_ ini. Penting untuk memastikan _stream_ Anda tidak dibuat ulang terlalu sering (misalnya, di setiap `build()`), atau itu dapat menyebabkan _re-subscription_ yang tidak efisien.
  - **Filosofi:** Mengaitkan UI dengan aliran data berkelanjutan.

- **Properti `initialData` (Opsional):**

  - **Konsep:** Nilai awal yang akan diberikan ke `snapshot.data` sebelum `Stream` menghasilkan peristiwa pertamanya.
  - **Filosofi:** Memberikan nilai _placeholder_ yang segera tersedia untuk ditampilkan oleh UI, sehingga pengguna tidak melihat _loading state_ yang berkepanjangan jika data awal cepat tersedia atau dapat diperkirakan.

- **`AsyncSnapshot<T> snapshot` pada `builder`:**

  - **Konsep:** Sama seperti di `FutureBuilder`, `snapshot` berisi informasi tentang _state_ `Stream` saat ini. Namun, untuk `StreamBuilder`, `connectionState` juga bisa menjadi `ConnectionState.active` (menunjukkan bahwa _stream_ aktif dan menghasilkan data) selain `none`, `waiting`, dan `done`. `snapshot.data` akan terus diperbarui dengan nilai terbaru dari _stream_.
  - **Filosofi:** Memberikan _state_ _real-time_ dari _stream_ ke UI, memungkinkan _rendering_ adaptif.

- **`ConnectionState` untuk `StreamBuilder`:**

  - **`ConnectionState.none`**: Tidak ada _stream_ yang diberikan atau _stream_ adalah `null`.
  - **`ConnectionState.waiting`**: _Stream_ telah diberikan tetapi belum menghasilkan data pertama.
  - **`ConnectionState.active`**: _Stream_ telah menghasilkan setidaknya satu data dan masih aktif menghasilkan data baru. Ini adalah _state_ yang paling sering Anda temui saat menampilkan data _real-time_.
  - **`ConnectionState.done`**: _Stream_ telah selesai (misalnya, sumber data ditutup, seperti koneksi WebSocket terputus atau _stream_ yang hanya memiliki jumlah peristiwa terbatas).

---

#### 8.3.3 Skenario Penggunaan `Stream`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan diberikan contoh-contoh praktis tentang kapan `Stream` dan `StreamBuilder` paling tepat digunakan, seperti:

- Mendengarkan perubahan data dari _database_ _real-time_ (misalnya, Firebase Firestore).
- Mendapatkan pembaruan lokasi secara berkelanjutan.
- Membangun _chat application_ dengan pesan yang datang secara _real-time_.
- Menangani _event_ input pengguna yang berkelanjutan (misalnya, _typing indicator_).

**Sintaks Dasar / Contoh Implementasi Inti (Gabungan 8.3.1, 8.3.2, 8.3.3):**

```dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamBuilder Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  // 1. Deklarasikan StreamController
  // Ini adalah cara umum untuk membuat Stream secara manual
  late StreamController<int> _counterController;
  late Stream<int> _counterStream;
  int _currentCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _counterController = StreamController<int>();
    // Untuk contoh ini, kita ingin Stream bisa memiliki banyak listener (misal: jika ada widget lain yang juga mendengarkan)
    // _counterStream = _counterController.stream.asBroadcastStream();
    _counterStream = _counterController.stream; // Single-subscription default

    // Mulai memancarkan angka setiap detik
    _startCounter();
  }

  void _startCounter() {
    _timer?.cancel(); // Pastikan timer sebelumnya dihentikan jika ada
    _currentCount = 0; // Reset counter
    _counterController.add(_currentCount); // Emit initial value
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentCount++;
      _counterController.add(_currentCount); // Menambahkan data ke stream
      if (_currentCount >= 10) {
        _timer?.cancel();
        _counterController.close(); // Tutup stream setelah mencapai batas
      }
    });
  }

  // Fungsi untuk simulasi Stream error
  void _simulateError() {
    _timer?.cancel();
    _counterController.addError('Stream Error: Something went wrong!');
    // _counterController.close(); // Bisa juga ditutup setelah error, tergantung kebutuhan
  }

  @override
  void dispose() {
    _timer?.cancel();
    _counterController.close(); // Penting: Tutup StreamController saat State dibuang
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamBuilder Example'),
      ),
      body: Center(
        // Menggunakan StreamBuilder
        child: StreamBuilder<int>( // Tipe T adalah int
          stream: _counterStream, // Berikan Stream yang akan diawasi
          initialData: 0, // Nilai awal sebelum Stream menghasilkan data pertama
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return const Text('Tidak ada koneksi ke stream.');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Menunggu data dari stream...'),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              // Stream aktif dan menghasilkan data
              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Stream Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.orange),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _startCounter(); // Coba lagi
                        });
                      },
                      child: const Text('Mulai Ulang Stream'),
                    ),
                  ],
                );
              } else if (snapshot.hasData) {
                // Stream menghasilkan data baru
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Current Count:',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      '${snapshot.data}', // Menampilkan data terbaru
                      style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _startCounter(); // Reset dan mulai ulang
                        });
                      },
                      child: const Text('Reset Counter'),
                    ),
                  ],
                );
              }
            } else if (snapshot.connectionState == ConnectionState.done) {
              // Stream telah selesai
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Stream Selesai!',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Final Count: ${snapshot.data ?? "N/A"}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _startCounter(); // Mulai ulang stream
                      });
                    },
                    child: const Text('Mulai Ulang Stream'),
                  ),
                ],
              );
            }
            // Fallback (seharusnya tidak tercapai)
            return const Text('State tidak diketahui.');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _simulateError,
        child: const Icon(Icons.bug_report),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`_counterController` dan `_counterStream`:**
    - `StreamController<int>()`: Digunakan untuk membuat `Stream` dan mengelola penambahan data (`add`), error (`addError`), dan penutupan _stream_ (`close`).
    - `_counterController.stream`: Mendapatkan _stream_ dari _controller_.
    - _Penting_: `_counterController.close()` harus dipanggil di `dispose()` untuk mencegah _memory leak_.
2.  **`_startCounter()`:**
    - Menggunakan `Timer.periodic` untuk secara berkala menambahkan angka ke `_counterController` (`_counterController.add(_currentCount)`). Ini mensimulasikan data yang datang secara _real-time_.
    - Ketika `_currentCount` mencapai 10, `_timer` dibatalkan dan `_counterController.close()` dipanggil, yang akan mengubah `snapshot.connectionState` menjadi `ConnectionState.done`.
3.  **`_simulateError()`:**
    - Menambahkan kesalahan ke _stream_ menggunakan `_counterController.addError()`. Ini akan memicu `snapshot.hasError` menjadi `true` di `StreamBuilder`.
4.  **`StreamBuilder<int>`:**
    - `stream: _counterStream`: `StreamBuilder` akan mendengarkan `_counterStream`.
    - `initialData: 0`: Sebelum `_counterStream` menghasilkan angka pertama, `snapshot.data` akan berisi `0`.
    - `builder: (BuildContext context, AsyncSnapshot<int> snapshot)`: Fungsi pembangun UI.
5.  **Penanganan `ConnectionState` dan Data:**
    - **`ConnectionState.none`**: Mirip dengan `FutureBuilder`, menunjukkan tidak ada _stream_ atau `null`.
    - **`ConnectionState.waiting`**: Tampil saat _stream_ belum memancarkan data pertama.
    - **`ConnectionState.active`**: Ini adalah _state_ di mana _stream_ aktif memancarkan data. Di sini, kita memeriksa `snapshot.hasError` dan `snapshot.hasData`.
      - Jika `snapshot.hasError`, tampilkan pesan kesalahan.
      - Jika `snapshot.hasData`, tampilkan `snapshot.data` (angka terbaru).
    - **`ConnectionState.done`**: Tampil ketika _stream_ telah ditutup (`_counterController.close()`). Ini menandakan tidak akan ada data lagi.

**Terminologi Esensial:**

- **`Stream<T>`:** Urutan peristiwa asinkron yang dapat menghasilkan nol atau lebih nilai atau kesalahan.
- **`StreamController<T>`:** Sebuah kelas untuk membuat dan mengelola `Stream` secara manual (menambahkan data, error, menutup _stream_).
- **`StreamBuilder<T>`:** _Widget_ yang membangun UI berdasarkan _state_ dan peristiwa dari sebuah `Stream`.
- **`initialData`:** Properti `StreamBuilder` yang menyediakan data awal sebelum _stream_ memancarkan data pertamanya.
- **`ConnectionState.active`:** _State_ dari `AsyncSnapshot` yang menunjukkan bahwa `Stream` aktif dan memancarkan data.
- **`ConnectionState.done`:** _State_ dari `AsyncSnapshot` yang menunjukkan bahwa `Stream` telah selesai dan tidak akan memancarkan data lagi.

**Sumber Referensi Lengkap:**

- [Streams (Dart Language Tour)](https://dart.dev/language/streams)
- [StreamBuilder class (Flutter Docs)](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)
- [StreamController class (Flutter Docs)](https://api.flutter.dev/flutter/dart-async/StreamController-class.html)

**Tips dan Praktik Terbaik:**

- **Tutup `StreamController`:** Selalu pastikan `StreamController` Anda ditutup (`_controller.close()`) saat tidak lagi dibutuhkan, biasanya di metode `dispose()` dari `StatefulWidget`, untuk mencegah _memory leak_.
- **Pilih Jenis `Stream` yang Tepat:** Gunakan _single-subscription_ secara _default_ kecuali Anda benar-benar membutuhkan _broadcast stream_ (misalnya, beberapa _widget_ mendengarkan _stream_ yang sama).
- **`initialData`:** Gunakan `initialData` untuk memberikan pengalaman pengguna yang lebih mulus dengan menampilkan _placeholder_ sebelum data pertama dari _stream_ tiba.
- **Tangani Semua `ConnectionState`:** Sama seperti `FutureBuilder`, pastikan UI Anda menangani semua _state_ `ConnectionState` (none, waiting, active, done) dan kasus _error_ dengan baik.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** "Bad state: Stream has already been listened to."

  - **Penyebab:** Anda mencoba mendengarkan _single-subscription stream_ lebih dari satu kali (misalnya, ada dua `StreamBuilder` yang mencoba mendengarkan `Stream` yang sama tanpa mengubahnya menjadi _broadcast stream_).
  - **Solusi:** Jika Anda memang perlu beberapa pendengar, ubah _stream_ menjadi _broadcast stream_ menggunakan `.asBroadcastStream()`. `_controller.stream.asBroadcastStream();`.

- **Kesalahan:** _Memory leak_ atau _stream_ terus memancarkan data setelah _widget_ dibuang.

  - **Penyebab:** Lupa memanggil `_controller.close()` di `dispose()`.
  - **Solusi:** Pastikan `StreamController` ditutup di `dispose()` untuk membersihkan sumber daya.

- **Kesalahan:** UI tidak memperbarui dengan data baru dari _stream_.

  - **Penyebab:**
    - `Stream` yang diberikan ke `StreamBuilder` diubah terlalu sering atau `StreamBuilder` tidak mendengarkan _stream_ yang benar.
    - Ada masalah dengan bagaimana data ditambahkan ke `StreamController`.
  - **Solusi:** Pastikan _stream_ yang diberikan ke `StreamBuilder` adalah _instance_ yang stabil. Pastikan `_controller.add()` dipanggil dengan benar.

---

Setelah memahami konsep dasar **Asynchronous Programming** dan cara menampilkannya di UI menggunakan `FutureBuilder` dan `StreamBuilder`, kini saatnya kita masuk ke inti dari aplikasi modern: **Konektivitas Jaringan**. Kita akan melanjutkan pada bagian di mana Anda akan belajar bagaimana aplikasi Flutter Anda bisa "berbicara" dengan server di internet, mengambil, mengirim, dan memodifikasi data.

### 8.4 Konektivitas Jaringan (HTTP Requests)

Konektivitas jaringan adalah tulang punggung sebagian besar aplikasi modern, memungkinkan mereka untuk berinteraksi dengan layanan _backend_, mengambil data, dan mengirim informasi. HTTP (Hypertext Transfer Protocol) adalah protokol yang paling umum digunakan untuk komunikasi ini. Flutter, melalui Dart, menyediakan cara yang efisien untuk melakukan HTTP _requests_.

#### 8.4.1 Menggunakan Package `http`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan diperkenalkan pada **package `http`** dari Dart, yang merupakan klien HTTP ringan dan sangat direkomendasikan untuk melakukan _requests_ jaringan di Flutter. Mereka akan belajar cara menambahkannya ke proyek Flutter dan memahami objek dasar yang akan digunakan (`Response`).

**Konsep Kunci & Filosofi Mendalam:**

- **HTTP Protocol:**

  - **Konsep:** Sebuah protokol aplikasi untuk sistem informasi terdistribusi, kolaboratif, dan _hypermedia_. Ini adalah dasar dari komunikasi data untuk World Wide Web. Ketika Anda "mengakses sebuah situs web" atau "mengambil data dari API", Anda sedang melakukan _request_ HTTP.
  - **Filosofi:** Menyediakan standar yang jelas untuk klien (aplikasi Anda) dan server berkomunikasi.

- **Package `http`:**

  - **Konsep:** `package:http` adalah perpustakaan klien HTTP yang mudah digunakan untuk Dart. Ini menyediakan fungsi tingkat tinggi (`get`, `post`, `put`, `delete`) untuk melakukan _request_ dan objek `Response` untuk menangani balasan.
  - **Filosofi:** Menyederhanakan kompleksitas di balik _socket_ jaringan dan protokol HTTP, memungkinkan pengembang untuk fokus pada logika aplikasi dan data, bukan detail implementasi jaringan tingkat rendah.

- **`Response` Object:**

  - **Konsep:** Ketika Anda melakukan _request_ HTTP, server akan mengirimkan balasan. Package `http` membungkus balasan ini dalam objek `Response`. Properti penting dari `Response` termasuk:
    - `statusCode`: Kode status HTTP (misalnya, `200 OK`, `404 Not Found`, `500 Internal Server Error`).
    - `body`: Isi balasan dari server, biasanya dalam bentuk _string_ (seringkali JSON).
    - `headers`: _Header_ HTTP dari balasan.
  - **Filosofi:** Menyediakan cara terstruktur untuk mengakses semua informasi relevan dari balasan server, memungkinkan aplikasi untuk mengambil keputusan berdasarkan status dan data yang diterima.

**Cara Menambahkan Package:**

Untuk menggunakan `package:http`, Anda perlu menambahkannya ke file `pubspec.yaml` proyek Flutter Anda:

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0 # Gunakan versi terbaru yang tersedia
```

Setelah menambahkan, jalankan `flutter pub get` di terminal Anda.

---

#### 8.4.2 Melakukan GET Request dan Parsing JSON

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari cara melakukan **HTTP GET _request_** untuk mengambil data dari API publik. Mereka akan belajar bagaimana menggunakan fungsi `http.get()` dan kemudian bagaimana **mengurai (parse) balasan JSON** menjadi struktur data Dart yang dapat digunakan.

**Konsep Kunci & Filosofi Mendalam:**

- **GET Request:**

  - **Konsep:** Metode HTTP yang digunakan untuk **mengambil data** dari server. _GET requests_ tidak boleh memiliki _side effects_ (tidak mengubah data di server).
  - **Filosofi:** Sebuah operasi "baca-saja" yang aman dan idempoten (melakukan _request_ yang sama berkali-kali akan menghasilkan hasil yang sama).

- **URL (`Uri`):**

  - **Konsep:** Uniform Resource Locator. Ini adalah alamat sumber daya yang ingin Anda akses di internet. Di Dart, URL direpresentasikan oleh objek `Uri`. Anda perlu mengonversi _string_ URL menjadi `Uri` menggunakan `Uri.parse()`.
  - **Filosofi:** Mengidentifikasi secara unik di mana data berada dan bagaimana mengaksesnya.

- **JSON (JavaScript Object Notation):**

  - **Konsep:** Format pertukaran data yang ringan dan mudah dibaca manusia serta mudah diurai oleh mesin. Ini adalah format standar untuk API REST. Data JSON seringkali berupa objek (`{}`) atau _array_ (`[]`) dari nilai-nilai.
  - **Filosofi:** Memberikan standar universal untuk merepresentasikan data terstruktur yang dapat dipahami oleh berbagai bahasa pemrograman dan platform.

- **JSON Parsing:**

  - **Konsep:** Proses mengonversi _string_ JSON yang diterima dari server menjadi struktur data Dart (seperti `Map<String, dynamic>` atau `List<dynamic>`). Dart memiliki pustaka `dart:convert` yang menyediakan fungsi `jsonDecode()` untuk tujuan ini.
  - **Filosofi:** Mengubah data yang tidak terstruktur (raw _string_) menjadi objek yang dapat dimanipulasi dengan mudah oleh kode Dart Anda.

**Sintaks Dasar / Contoh Implementasi Inti (GET Request dan Parsing JSON):**

Kita akan menggunakan JSONPlaceholder ([`https://jsonplaceholder.typicode.com/`](<%5Bhttps://jsonplaceholder.typicode.com/%5D(https://jsonplaceholder.typicode.com/)>)) sebagai API _dummy_ untuk contoh ini. Ini menyediakan data _fake_ REST API gratis untuk pengujian.

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import package http
import 'dart:convert'; // Untuk jsonDecode

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP GET Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const PostsScreen(),
    );
  }
}

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // Factory constructor untuk membuat Post dari JSON Map
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      // Jika server mengembalikan status OK (200), parse JSON.
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      // Jika server tidak mengembalikan status OK (200), lempar exception.
      throw Exception('Failed to load posts (Status: ${response.statusCode})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Postingan'),
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Post post = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(post.body),
                          const SizedBox(height: 8),
                          Text(
                            'User ID: ${post.userId}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Text('Tidak ada data.');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _postsFuture = fetchPosts(); // Muat ulang data
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`Post` Model:**
    - Kelas `Post` merepresentasikan struktur data dari sebuah postingan. Ini adalah contoh **pemodelan data** yang akan kita bahas lebih lanjut di 8.5.
    - `factory Post.fromJson(Map<String, dynamic> json)`: Ini adalah _constructor_ khusus yang digunakan untuk membuat _instance_ `Post` dari sebuah `Map` (hasil dari _parsing_ JSON). Ini penting untuk mengonversi data JSON mentah menjadi objek Dart yang aman secara tipe.
2.  **`fetchPosts()` Function:**
    - `final response = await http.get(Uri.parse('...'))`: Ini adalah baris kunci untuk melakukan GET _request_.
      - `http.get()` adalah fungsi asinkron, jadi kita gunakan `await`.
      - `Uri.parse()` mengonversi _string_ URL menjadi objek `Uri` yang diperlukan.
    - `if (response.statusCode == 200)`: Ini adalah cara standar untuk memeriksa apakah _request_ berhasil. Kode status `200 OK` berarti _request_ berhasil dan server mengembalikan data yang diminta.
    - `List<dynamic> jsonList = jsonDecode(response.body);`: `jsonDecode()` dari `dart:convert` mengurai _string_ JSON (`response.body`) menjadi `List<dynamic>` (karena balasan dari `/posts` adalah _array_ JSON).
    - `return jsonList.map((json) => Post.fromJson(json)).toList();`: Mengiterasi setiap objek JSON dalam daftar dan mengonversinya menjadi objek `Post` menggunakan _factory constructor_ `Post.fromJson`.
    - `throw Exception(...)`: Jika status kode bukan 200, kita melempar _exception_ yang akan ditangkap oleh `FutureBuilder`.
3.  **`PostsScreen` (`StatefulWidget`):**
    - `_postsFuture` diinisialisasi di `initState()` untuk memastikan data hanya di-_fetch_ sekali saat _widget_ pertama kali dibuat.
    - `FutureBuilder<List<Post>>`: Digunakan untuk menampilkan UI berdasarkan _state_ `_postsFuture`.
      - Menampilkan `CircularProgressIndicator` saat `waiting`.
      - Menampilkan `Text` error jika `hasError`.
      - Jika `hasData`, data ditampilkan dalam `ListView.builder` dengan setiap item adalah sebuah `Card` yang menampilkan detail `Post`.

---

#### 8.4.3 Melakukan POST, PUT, DELETE Request

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar cara melakukan **HTTP POST, PUT, dan DELETE _requests_**. Ini adalah metode yang digunakan untuk mengubah data di server (membuat baru, memperbarui, atau menghapus). Mereka akan memahami pentingnya _body_ _request_ (untuk POST/PUT) dan _headers_ (seperti `Content-Type`).

**Konsep Kunci & Filosofi Mendalam:**

- **POST Request:**

  - **Konsep:** Digunakan untuk **mengirimkan data baru** ke server untuk dibuat sebagai sumber daya baru.
  - **Filosofi:** "Buat" atau "Kirim". Misalnya, mengirimkan data formulir pendaftaran, membuat postingan baru.
  - **Karakteristik:** Data dikirimkan dalam _body_ _request_.

- **PUT Request:**

  - **Konsep:** Digunakan untuk **memperbarui** sumber daya yang sudah ada di server, atau membuatnya jika belum ada di lokasi yang ditentukan. _PUT requests_ bersifat idempoten (melakukan _request_ yang sama berkali-kali akan menghasilkan _state_ akhir yang sama).
  - **Filosofi:** "Perbarui" atau "Ganti Sepenuhnya". Misalnya, memperbarui seluruh profil pengguna.
  - **Karakteristik:** Data dikirimkan dalam _body_ _request_.

- **DELETE Request:**

  - **Konsep:** Digunakan untuk **menghapus** sumber daya tertentu dari server.
  - **Filosofi:** "Hapus". Misalnya, menghapus postingan, menghapus item dari keranjang belanja.
  - **Karakteristik:** Biasanya tidak memiliki _body_ _request_, sumber daya yang akan dihapus ditentukan di URL.

- **Request Body (`body` parameter):**

  - **Konsep:** Data yang dikirimkan bersama _request_ HTTP, terutama untuk POST dan PUT. Biasanya dalam format JSON. Anda perlu mengonversi objek Dart ke _string_ JSON menggunakan `jsonEncode()`.
  - **Filosofi:** Mekanisme untuk mengirimkan informasi yang akan digunakan server untuk membuat atau memperbarui sumber daya.

- **Request Headers (`headers` parameter):**

  - **Konsep:** Pasangan kunci-nilai yang menyediakan metadata tentang _request_ HTTP (misalnya, `Content-Type`, `Authorization`). _Header_ `Content-Type: application/json` sangat penting untuk memberitahu server bahwa _body_ _request_ adalah JSON.
  - **Filosofi:** Menyediakan informasi kontekstual yang diperlukan server untuk memproses _request_ dengan benar.

**Sintaks Dasar / Contoh Implementasi Inti (POST, PUT, DELETE):**

Lanjutan dari contoh `PostsScreen`. Kita akan menambahkan fungsi untuk membuat dan menghapus _post_.

```dart
// Lanjutan dari file posts_screen.dart (bagian ini bisa ditambahkan di dalam _PostsScreenState atau sebagai fungsi terpisah)

// Fungsi untuk membuat Post baru (POST Request)
Future<Post> createPost(String title, String body) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'body': body,
      'userId': '1', // Contoh: user ID
    }),
  );

  if (response.statusCode == 201) { // 201 Created adalah status untuk POST berhasil
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create post (Status: ${response.statusCode})');
  }
}

// Fungsi untuk memperbarui Post (PUT Request)
Future<Post> updatePost(int id, String title, String body) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'id': id.toString(), // Biasanya disertakan untuk PUT
      'title': title,
      'body': body,
      'userId': '1',
    }),
  );

  if (response.statusCode == 200) { // 200 OK adalah status untuk PUT berhasil
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update post (Status: ${response.statusCode})');
  }
}

// Fungsi untuk menghapus Post (DELETE Request)
Future<void> deletePost(int id) async {
  final response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  // Status 200 OK atau 204 No Content untuk DELETE berhasil
  if (response.statusCode == 200 || response.statusCode == 204) {
    print('Post $id deleted successfully.');
  } else {
    throw Exception('Failed to delete post $id (Status: ${response.statusCode})');
  }
}

// Untuk mengintegrasikannya ke UI, Anda bisa menambahkan tombol di PostsScreen
// Misalnya, di FloatingActionButton atau sebagai ListTile trailing:

/*
// Contoh penggunaan di dalam PostsScreen
// Di dalam _PostsScreenState, tambahkan:

void _showCreatePostDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String title = '';
      String body = '';
      return AlertDialog(
        title: const Text('Buat Post Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Judul'),
              onChanged: (value) => title = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Isi Post'),
              onChanged: (value) => body = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (title.isNotEmpty && body.isNotEmpty) {
                try {
                  await createPost(title, body);
                  if (mounted) {
                    Navigator.pop(context); // Tutup dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post berhasil dibuat!')),
                    );
                    setState(() {
                      _postsFuture = fetchPosts(); // Muat ulang daftar post
                    });
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal membuat post: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Buat'),
          ),
        ],
      );
    },
  );
}

// Anda bisa memanggil _showCreatePostDialog dari FloatingActionButton
// floatingActionButton: FloatingActionButton(
//   onPressed: _showCreatePostDialog,
//   child: const Icon(Icons.add),
// ),

// Untuk delete, bisa ditambahkan di ListTile sebagai Trailing:
// ListTile(
//   // ... title, subtitle
//   trailing: IconButton(
//     icon: const Icon(Icons.delete, color: Colors.red),
//     onPressed: () async {
//       try {
//         await deletePost(post.id);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Post berhasil dihapus!')),
//           );
//           setState(() {
//             _postsFuture = fetchPosts(); // Muat ulang daftar post
//           });
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Gagal menghapus post: $e')),
//           );
//         }
//       }
//     },
//   ),
// );
*/
```

**Penjelasan Konteks Kode Tambahan:**

- **`createPost()` (POST):**
  - Menggunakan `http.post()`.
  - `headers`: Penting untuk menyertakan `Content-Type: application/json` agar server tahu format data yang dikirim.
  - `body`: Data yang ingin Anda kirimkan, di-_encode_ sebagai JSON _string_ menggunakan `jsonEncode()`.
  - `statusCode == 201`: Kode status `201 Created` adalah indikasi sukses untuk _request_ POST yang membuat sumber daya baru.
- **`updatePost()` (PUT):**
  - Menggunakan `http.put()`.
  - URL menyertakan `id` dari _post_ yang akan diperbarui (`/posts/$id`).
  - `body`: Berisi data lengkap untuk memperbarui _post_.
  - `statusCode == 200`: Kode status `200 OK` adalah indikasi sukses untuk _request_ PUT.
- **`deletePost()` (DELETE):**
  - Menggunakan `http.delete()`.
  - URL menyertakan `id` dari _post_ yang akan dihapus.
  - `statusCode == 200` atau `204`: Kode status `204 No Content` juga merupakan indikasi sukses untuk DELETE jika server tidak mengembalikan _body_.

---

#### 8.4.4 Error Handling Jaringan

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memperdalam penanganan kesalahan yang spesifik untuk operasi jaringan. Ini termasuk menangani **kesalahan status HTTP** (misalnya, `404 Not Found`, `500 Internal Server Error`) dan **kesalahan jaringan** itu sendiri (misalnya, tidak ada koneksi internet, _timeout_). Mereka akan belajar bagaimana menggunakan blok `try-catch` secara efektif untuk mencatat kesalahan dan memberikan umpan balik yang relevan kepada pengguna.

**Konsep Kunci & Filosofi Mendalam:**

- **HTTP Status Codes:**
  - **Konsep:** Angka tiga digit yang dikembalikan oleh server sebagai bagian dari balasan HTTP untuk menunjukkan status _request_.
  - **Filosofi:** Standardisasi cara server mengomunikasikan keberhasilan atau kegagalan operasi. Klien dapat membuat keputusan logis berdasarkan kode status ini.
    - **2xx (Success):** `200 OK`, `201 Created`, `204 No Content`.
    - **4xx (Client Error):** `400 Bad Request`, `401 Unauthorized`, `403 Forbidden`, `404 Not Found`.
    - **5xx (Server Error):** `500 Internal Server Error`, `502 Bad Gateway`, `503 Service Unavailable`.
- **Jenis Kesalahan Jaringan Lainnya:**
  - **`SocketException`:** Terjadi ketika ada masalah koneksi jaringan di sisi klien (misalnya, tidak ada internet, _hostname_ tidak dapat dijangkau).
  - **`TimeoutException`:** Terjadi jika server tidak merespons dalam waktu yang ditentukan.
- **`try-catch` pada Operasi Jaringan:**
  - **Konsep:** Menggunakan blok `try-catch` di sekitar panggilan HTTP asinkron untuk menangani _exception_ yang mungkin terjadi selama operasi jaringan.
  - **Filosofi:** Membangun aplikasi yang tangguh yang tidak _crash_ karena masalah jaringan yang tidak terduga. Memberikan pengalaman pengguna yang lebih baik dengan menunjukkan apa yang salah dan mungkin menawarkan solusi (misalnya, "Periksa koneksi internet Anda").

**Contoh Sintaks (Error Handling Jaringan):**

```dart
// Lanjutan dari fungsi fetchPosts() di PostsScreen

Future<List<Post>> fetchPosts() async {
  try {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      // Menangani error status HTTP (misal: 404, 500)
      throw Exception('Failed to load posts with status code: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    // Menangani error HTTP client secara spesifik (misal: DNS lookup failed)
    throw Exception('Network error: ${e.message}');
  } on SocketException {
    // Menangani error koneksi jaringan (misal: tidak ada internet)
    throw Exception('No internet connection. Please check your network.');
  } on TimeoutException {
    // Menangani timeout (jika Anda menggunakan timeout pada http request)
    throw Exception('Connection timed out. Please try again.');
  } catch (e) {
    // Menangkap semua error lainnya yang tidak terduga
    throw Exception('An unexpected error occurred: $e');
  }
}

// Di dalam FutureBuilder, Anda bisa menampilkan error yang lebih spesifik berdasarkan jenis Exception
/*
builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const CircularProgressIndicator();
  } else if (snapshot.hasError) {
    // Di sini, snapshot.error akan berisi Exception yang kita lempar
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_off, color: Colors.grey, size: 60),
        const SizedBox(height: 16),
        Text(
          'Gagal memuat data: ${snapshot.error}', // Menampilkan pesan error
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _postsFuture = fetchPosts(); // Coba lagi
            });
          },
          child: const Text('Coba Lagi'),
        ),
      ],
    );
  }
  // ... bagian hasData
}
*/
```

**Penjelasan Konteks Kode Error Handling:**

- **Berbagai Blok `catch`:** Contoh `fetchPosts()` sekarang memiliki beberapa blok `catch` untuk menangani jenis _exception_ yang berbeda secara spesifik:
  - `on http.ClientException`: Menangkap _exception_ yang dilempar oleh _package_ `http` itu sendiri (misalnya, URL tidak valid, masalah _DNS_).
  - `on SocketException`: Menangkap masalah terkait koneksi jaringan dasar (misalnya, perangkat tidak terhubung ke internet).
  - `on TimeoutException`: Akan menangkap _exception_ jika _request_ melebihi batas waktu (Anda dapat menambahkan `timeout` ke _request_ HTTP, contoh: `await http.get(...).timeout(Duration(seconds: 10));`).
  - `catch (e)`: Ini adalah _catch-all_ untuk _exception_ lain yang tidak terduga.
- **Pesan Error yang Jelas:** Setiap blok `catch` melempar `Exception` baru dengan pesan yang lebih informatif dan ramah pengguna, yang kemudian akan ditampilkan oleh `FutureBuilder`.

**Terminologi Esensial:**

- **HTTP Methods:** `GET`, `POST`, `PUT`, `DELETE` (dan lainnya seperti `PATCH`, `HEAD`).
- **HTTP Status Codes:** `200`, `201`, `204`, `400`, `401`, `403`, `404`, `500`, dll.
- **Request Body:** Data yang dikirim dengan _request_ HTTP (untuk POST, PUT, PATCH).
- **Request Headers:** Metadata tentang _request_ HTTP (misalnya, `Content-Type`, `Authorization`).
- **`jsonEncode()`:** Fungsi dari `dart:convert` untuk mengubah objek Dart menjadi _string_ JSON.
- **`SocketException`**: _Exception_ yang menunjukkan masalah koneksi jaringan.
- **`TimeoutException`**: _Exception_ yang menunjukkan _request_ melebihi batas waktu.

**Sumber Referensi Lengkap:**

- [http package (pub.dev)](https://pub.dev/packages/http)
- [Dart http client (Flutter Docs)](https://docs.flutter.dev/data/network/fetch-data)
- [MDN Web Docs: HTTP Methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods)
- [MDN Web Docs: HTTP Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

**Tips dan Praktik Terbaik:**

- **Selalu Periksa `response.statusCode`:** Jangan berasumsi _request_ berhasil hanya karena tidak ada _exception_. Periksa kode status untuk memastikan balasan yang diharapkan.
- **Gunakan `try-catch`:** Wajib untuk operasi jaringan. Internet tidak selalu stabil.
- **Pesan Error yang Bermakna:** Sampaikan pesan kesalahan yang jelas kepada pengguna. Jangan tampilkan kesalahan teknis mentah.
- **Pisahkan Logika Jaringan:** Pertimbangkan untuk menempatkan semua fungsi _request_ HTTP Anda dalam kelas terpisah (misalnya, `ApiService` atau `Repository`) untuk menjaga kode Anda tetap bersih dan mudah dikelola.
- **Gunakan `Uri.parse()`:** Selalu konversi _string_ URL Anda menjadi objek `Uri` sebelum melakukan _request_.
- **Manfaatkan `jsonEncode()` dan `jsonDecode()`:** Ini adalah alat dasar Anda untuk bekerja dengan data JSON di Dart.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Aplikasi _crash_ karena `SocketException` atau `HttpException`.

  - **Penyebab:** Tidak ada koneksi internet, URL salah, atau server tidak dapat dijangkau.
  - **Solusi:** Bungkus panggilan HTTP Anda dalam blok `try-catch` dan tangani `SocketException` secara spesifik.

- **Kesalahan:** Data tidak ditampilkan atau ditampilkan dengan format yang salah setelah _fetch_.

  - **Penyebab:** Kesalahan dalam _parsing_ JSON (`jsonDecode()`) atau kesalahan dalam mengonversi `Map` JSON ke objek Dart Anda (`Post.fromJson`). Periksa struktur JSON dari API Anda.
  - **Solusi:** Gunakan alat _debugger_ atau `print()` untuk memeriksa `response.body` mentah dan memverifikasi bahwa struktur JSON sesuai dengan model Dart Anda.

- **Kesalahan:** Request `POST/PUT` gagal dengan status `400 Bad Request` atau `415 Unsupported Media Type`.

  - **Penyebab:** Anda lupa mengatur _header_ `Content-Type: application/json` atau _body_ tidak di-_encode_ sebagai JSON _string_ (`jsonEncode()`).
  - **Solusi:** Pastikan _header_ `Content-Type` disetel dengan benar dan `body` di-_encode_ dengan `jsonEncode()`.

---

---

Bagus sekali\! Setelah menguasai cara melakukan _request_ jaringan, langkah selanjutnya yang tak kalah penting adalah bagaimana mengelola data yang Anda terima atau kirim. Inilah yang akan kita pelajari di **8.5 Pemodelan Data (Serialization/Deserialization)**.

Bagian ini akan mengajarkan Anda cara mengubah data JSON mentah menjadi objek Dart yang terstruktur dan aman tipe, serta sebaliknya. Ini adalah praktik terbaik untuk membangun aplikasi yang kuat dan mudah dipelihara.

---

### 8.5 Pemodelan Data (Serialization/Deserialization)

Ketika Anda berinteraksi dengan API, data seringkali datang atau dikirim dalam format JSON. Mengubah _string_ JSON menjadi objek Dart (deserialisasi) dan objek Dart kembali menjadi _string_ JSON (serialisasi) adalah tugas umum. Pemodelan data yang tepat akan membuat kode Anda lebih bersih, lebih aman tipe, dan lebih mudah untuk dikelola.

#### 8.5.1 Konsep JSON dan Data Pemodelan

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memperdalam pemahaman mereka tentang **JSON** sebagai format pertukaran data yang dominan di web. Mereka akan belajar pentingnya **pemodelan data** di Dart, yaitu merepresentasikan struktur data JSON sebagai kelas-kelas Dart yang spesifik (misalnya, kelas `User`, `Product`, `Order`).

**Konsep Kunci & Filosofi Mendalam:**

- **JSON (JavaScript Object Notation):**

  - **Konsep:** Sebuah format data berbasis teks yang ringan dan mudah dibaca manusia serta mudah diurai oleh mesin. JSON dibangun di atas dua struktur dasar:
    1.  **Objek:** Kumpulan pasangan nama/nilai tidak berurutan (misalnya, `{"name": "Alice", "age": 30}`). Di Dart, ini dipetakan ke `Map<String, dynamic>`.
    2.  **Array:** Daftar nilai yang berurutan (misalnya, `["apple", "banana", "cherry"]`). Di Dart, ini dipetakan ke `List<dynamic>`.
  - **Filosofi:** Menjadi "lingua franca" untuk komunikasi data antar sistem yang berbeda, memastikan interoperabilitas.

- **Serialization (Serialisasi):**

  - **Konsep:** Proses mengubah **objek Dart** (misalnya, _instance_ kelas `User`) menjadi representasi yang dapat disimpan atau ditransfer, paling umum menjadi **_string_ JSON**.
  - **Filosofi:** Mengubah data yang terstruktur dalam memori aplikasi Anda menjadi format yang dapat dikirim melalui jaringan atau disimpan dalam basis data.

- **Deserialization (Deserialisasi):**

  - **Konsep:** Proses mengubah **representasi data** (paling umum **_string_ JSON**) menjadi **objek Dart** yang dapat digunakan dalam aplikasi Anda.
  - **Filosofi:** Mengambil data mentah dari luar aplikasi dan mengubahnya menjadi objek Dart yang aman tipe, sehingga Anda bisa mengakses properti dengan titik (`.`) daripada kunci _string_ (`[]`), mengurangi kesalahan penulisan (typos) dan membuat kode lebih mudah dibaca.

- **Data Pemodelan (Modeling Data):**

  - **Konsep:** Membuat kelas-kelas Dart yang mereplikasi struktur data JSON yang diharapkan dari API Anda. Setiap properti di kelas Dart akan sesuai dengan kunci dalam objek JSON.
  - **Filosofi:**
    - **Keamanan Tipe (Type Safety):** Setelah data di-_deserialize_ menjadi objek, Dart _compiler_ akan membantu Anda memastikan bahwa Anda mengakses properti yang benar dengan tipe data yang benar. Ini mengurangi _runtime errors_.
    - **Keterbacaan Kode:** Mengakses `user.name` jauh lebih bersih dan jelas daripada `userMap['name']`.
    - **Refaktor yang Mudah:** Jika struktur API berubah, Anda hanya perlu memodifikasi model kelas Dart Anda.
    - **Otomatisasi:** Membuka jalan untuk alat otomatisasi (seperti `json_serializable`) yang dapat menghasilkan kode _parsing_ untuk Anda.

**Contoh Perbandingan (Tanpa Model vs. Dengan Model):**

**Tanpa Model (Raw JSON `Map<String, dynamic>`):**

```dart
String jsonData = '{"name": "Budi", "email": "budi@example.com"}';
Map<String, dynamic> userMap = jsonDecode(jsonData);

print(userMap['name']); // Akses dengan string key, rawan typo dan runtime error
print(userMap['age']); // Tidak ada 'age' di JSON, akan null atau error jika diakses tanpa cek

// Mengirim data:
Map<String, dynamic> newUser = {'username': 'newuser123', 'password': 'securepassword'};
String jsonToSend = jsonEncode(newUser); // encode manual
```

**Dengan Model (Menggunakan Kelas `User`):**

```dart
// app_models.dart
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Deserialization (from JSON Map to User object)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  // Serialization (from User object to JSON Map)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}

// main.dart atau service_layer.dart
String jsonData = '{"name": "Budi", "email": "budi@example.com"}';
User user = User.fromJson(jsonDecode(jsonData)); // Deserialisasi

print(user.name); // Akses dengan titik, aman tipe, autocompletion
// print(user.age); // ERROR: Properti 'age' tidak ada di kelas User, terdeteksi saat compile

// Mengirim data:
User newUser = User(name: 'Siti', email: 'siti@example.com');
String jsonToSend = jsonEncode(newUser.toJson()); // Serialisasi otomatis via toJson()
```

Jelas bahwa pendekatan dengan model jauh lebih kuat, aman, dan mudah dikelola.

---

#### 8.5.2 Manual JSON Parsing

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar cara melakukan **deserialisasi JSON secara manual** dengan menulis _factory constructor_ `fromJson()` dan metode `toJson()` untuk setiap kelas model mereka. Ini adalah metode fundamental yang membangun pemahaman tentang bagaimana proses _parsing_ bekerja.

**Konsep Kunci & Filosofi Mendalam:**

- **`factory` Constructor `fromJson(Map<String, dynamic> json)`:**

  - **Konsep:** Sebuah _factory constructor_ tidak harus membuat _instance_ baru dari kelasnya sendiri. Ini sangat cocok untuk deserialisasi karena Anda mengambil `Map<String, dynamic>` (hasil dari `jsonDecode()`) dan menggunakannya untuk membuat _instance_ objek Dart Anda.
  - **Filosofi:** Memberikan cara standar dan konvensi untuk mengubah data mentah JSON menjadi objek Dart yang aman tipe.

- **Type Casting (`as String`, `as int`, dll.):**

  - **Konsep:** Saat mengambil nilai dari `Map<String, dynamic>`, nilai tersebut secara _default_ akan memiliki tipe `dynamic`. Anda perlu melakukan _type casting_ secara eksplisit (misalnya, `json['name'] as String`) untuk memastikan tipe yang benar dan mendapatkan keamanan tipe. Jika _type_ tidak cocok, ini akan melempar _runtime error_.
  - **Filosofi:** Memaksa pengecekan tipe pada saat _runtime_ untuk memastikan data yang di-_parse_ sesuai dengan struktur model Anda.

- **Null Safety (`?`, `??`):**

  - **Konsep:** Jika kunci JSON mungkin tidak ada atau nilainya `null`, Anda harus menanganinya dengan benar menggunakan fitur _null safety_ Dart (misalnya, `json['optional_field'] as String?` atau `json['count'] ?? 0`).
  - **Filosofi:** Mencegah `null pointer exceptions` dan membuat kode Anda lebih tangguh terhadap data yang tidak lengkap atau tidak konsisten.

- **`Map<String, dynamic> toJson()` Method:**

  - **Konsep:** Sebuah metode di kelas model Anda yang mengonversi properti-properti objek Dart kembali menjadi `Map<String, dynamic>`, yang kemudian dapat di-_encode_ menjadi _string_ JSON menggunakan `jsonEncode()`.
  - **Filosofi:** Menyediakan cara standar untuk mengubah objek Dart menjadi format yang siap untuk dikirimkan ke API.

**Sintaks Dasar / Contoh Implementasi Inti (Manual JSON Parsing):**

Lanjutan dari contoh `Post` sebelumnya.

```dart
import 'dart:convert'; // Untuk jsonDecode dan jsonEncode

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // DESERIALISASI: Factory constructor untuk membuat Post dari JSON Map
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,          // Casting to int
      userId: json['userId'] as int,  // Casting to int
      title: json['title'] as String, // Casting to String
      body: json['body'] as String,   // Casting to String
    );
  }

  // SERIALISASI: Metode untuk mengubah Post menjadi JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  // Tambahan: Contoh properti opsional
  // Misalnya, jika API mengembalikan "views" yang opsional
  // class Post {
  //   final int? views; // Nullable type
  //   Post({..., this.views});
  //   factory Post.fromJson(Map<String, dynamic> json) {
  //     return Post(
  //       ...,
  //       views: json['views'] as int?, // Casting to nullable int
  //     );
  //   }
  //   Map<String, dynamic> toJson() {
  //     return {
  //       ...,
  //       'views': views, // akan menjadi null di JSON jika views adalah null
  //     };
  //   }
  // }
}

void main() {
  // Contoh Deserialisasi
  String jsonString = '''
    {
      "id": 1,
      "userId": 10,
      "title": "Dart is Awesome",
      "body": "Learning Flutter with Dart is a great experience!"
    }
  ''';

  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  Post post = Post.fromJson(jsonMap);

  print('Deserialized Post:');
  print('ID: ${post.id}');
  print('User ID: ${post.userId}');
  print('Title: ${post.title}');
  print('Body: ${post.body}');

  // Contoh Serialisasi
  Post newPost = Post(
    id: 2,
    userId: 20,
    title: 'Hello World',
    body: 'This is my first post with Dart objects.',
  );

  Map<String, dynamic> postMap = newPost.toJson();
  String jsonOutput = jsonEncode(postMap);

  print('\nSerialized Post:');
  print(jsonOutput); // {"id":2,"userId":20,"title":"Hello World","body":"This is my first post with Dart objects."}

  // Contoh deserialisasi list
  String jsonListString = '''
    [
      {"id": 1, "userId": 10, "title": "Post 1", "body": "Body 1"},
      {"id": 2, "userId": 20, "title": "Post 2", "body": "Body 2"}
    ]
  ''';
  List<dynamic> rawList = jsonDecode(jsonListString);
  List<Post> posts = rawList.map((item) => Post.fromJson(item)).toList();
  print('\nDeserialized List of Posts:');
  posts.forEach((p) => print('${p.id}: ${p.title}'));
}
```

**Penjelasan Konteks Kode:**

- `Post.fromJson(Map<String, dynamic> json)`: Ini adalah _factory constructor_ yang menerima `Map<String, dynamic>` (yang dihasilkan oleh `jsonDecode`). Di dalamnya, kita mengambil nilai untuk setiap properti menggunakan kunci _string_ (misalnya, `json['id']`) dan melakukan _type casting_ eksplisit (`as int`, `as String`) untuk memastikan keamanan tipe dan memungkinkan Dart mengidentifikasi kesalahan jika ada _mismatch_.
- `Post.toJson()`: Ini adalah metode _instance_ yang mengonversi objek `Post` kembali menjadi `Map<String, dynamic>`. Map ini kemudian bisa di-_encode_ menjadi _string_ JSON.
- `main()`: Menunjukkan bagaimana `jsonDecode` digunakan untuk mengurai _string_ JSON menjadi `Map` atau `List` dinamis, dan bagaimana `Post.fromJson` mengonversi `Map` tersebut menjadi objek `Post`. Demikian pula, menunjukkan bagaimana `newPost.toJson()` digunakan untuk menghasilkan `Map` yang kemudian di-_encode_ oleh `jsonEncode` menjadi _string_ JSON.

---

#### 8.5.3 Menggunakan Package `json_serializable`

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar tentang **`json_serializable`**, sebuah _package_ yang memanfaatkan **_code generation_** untuk secara otomatis membuat kode `fromJson()` dan `toJson()` untuk kelas model. Ini mengurangi _boilerplate_ secara signifikan dan membantu menjaga konsistensi dan keamanan tipe dalam proyek besar.

**Konsep Kunci & Filosofi Mendalam:**

- **Boilerplate Code:** Kode berulang dan standar yang harus ditulis untuk tugas-tugas umum (seperti _parsing_ JSON) yang tidak menambahkan logika bisnis baru. Menulis `fromJson()` dan `toJson()` secara manual untuk banyak kelas model bisa sangat memakan waktu dan rentan kesalahan.

- **Code Generation:** Proses di mana kode Anda sendiri (model Dart Anda) digunakan sebagai input untuk menghasilkan kode lain secara otomatis (misalnya, fungsi _parsing_ JSON). Ini dilakukan oleh alat _build runner_ khusus.

- **Package `json_serializable`:**

  - **Konsep:** Sebuah _package_ yang menyediakan anotasi (`@JsonSerializable()`) yang Anda tambahkan ke kelas model Dart Anda. Bersama dengan `build_runner` dan `json_annotation`, ia menghasilkan kode _parsing_ JSON yang diperlukan.
  - **Filosofi:** Mengotomatiskan tugas-tugas berulang, mengurangi _boilerplate_, meningkatkan produktivitas, dan memastikan keamanan tipe dengan kode yang dihasilkan secara otomatis yang sudah diuji. Ini juga membantu menjaga konsistensi dalam _parsing_ JSON di seluruh aplikasi.

- **Package yang Dibutuhkan:**

  - `json_annotation`: Berisi anotasi yang digunakan untuk menandai kelas model.
  - `json_serializable`: Generator kode yang sebenarnya.
  - `build_runner`: Alat yang menjalankan generator kode.

**Cara Menambahkan Package:**

Tambahkan ke `pubspec.yaml`:

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  json_annotation: ^4.8.1 # Gunakan versi terbaru

dev_dependencies: # Ini adalah dependency hanya untuk pengembangan
  build_runner: ^2.4.6 # Gunakan versi terbaru
  json_serializable: ^6.7.1 # Gunakan versi terbaru
```

Setelah menambahkan, jalankan `flutter pub get`.

**Sintaks Dasar / Contoh Implementasi Inti (`json_serializable`):**

Mari kita konversi kelas `Post` kita untuk menggunakan `json_serializable`.

```dart
// post_model.dart (Buat file baru untuk model)
import 'package:json_annotation/json_annotation.dart';

// Bagian ini memberi tahu build_runner untuk menghasilkan file `post_model.g.dart`
part 'post_model.g.dart';

@JsonSerializable() // Anotasi yang penting!
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // Factory constructor yang akan menggunakan kode yang digenerate
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  // Metode untuk serialisasi yang akan menggunakan kode yang digenerate
  Map<String, dynamic> toJson() => _$PostToJson(this);

  // Opsional: properti tambahan yang mungkin memiliki nama berbeda di JSON
  // @JsonKey(name: 'user_id_from_api')
  // final int actualUserId;
}
```

**Langkah-langkah untuk _Generate_ Kode:**

Setelah Anda mendefinisikan kelas model dengan anotasi `@JsonSerializable()` dan _factory_ serta metode `toJson` seperti di atas, Anda perlu menjalankan perintah berikut di terminal proyek Anda:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

- `flutter pub run build_runner build`: Perintah ini menjalankan `build_runner` untuk mencari generator kode (seperti `json_serializable`) dan menghasilkan file-file yang diperlukan.
- `--delete-conflicting-outputs`: Opsi ini berguna untuk menghapus file yang digenerate sebelumnya jika ada konflik, memastikan bahwa kode Anda selalu baru.

Setelah perintah ini berhasil dijalankan, Anda akan melihat file `post_model.g.dart` baru yang dibuat di samping `post_model.dart`. File inilah yang berisi implementasi `_$PostFromJson` dan `_$PostToJson` yang dibutuhkan.

Sekarang, di mana pun Anda perlu menggunakan model `Post` (misalnya, di `fetchPosts()` Anda), Anda cukup mengimpor `post_model.dart`:

```dart
// Di file service Anda (misal: api_service.dart atau main.dart)
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:your_app_name/post_model.dart'; // Import model yang baru

// ... (lanjutan fungsi fetchPosts)
Future<List<Post>> fetchPosts() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);
    // Menggunakan kode yang digenerate untuk deserialisasi
    return jsonList.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception('Failed to load posts (Status: ${response.statusCode})');
  }
}
```

**Kelebihan `json_serializable`:**

- **Mengurangi Boilerplate:** Tidak perlu menulis kode _parsing_ `fromJson()` dan `toJson()` secara manual.
- **Keamanan Tipe:** Kode yang digenerate otomatis aman tipe, mengurangi kesalahan _runtime_.
- **Konsistensi:** Memastikan semua model di-_parse_ dengan cara yang sama.
- **Fleksibilitas:** Mendukung penyesuaian (misalnya, `@JsonKey` untuk memetakan nama kunci JSON yang berbeda).

**Kekurangan `json_serializable`:**

- **Ketergantungan pada Code Generation:** Membutuhkan `build_runner` untuk dijalankan, yang menambah langkah dalam alur kerja pengembangan dan bisa memakan waktu untuk proyek besar.
- **Kurva Pembelajaran Awal:** Membutuhkan pemahaman tentang anotasi dan cara kerja _code generation_.

**Terminologi Esensial:**

- **Serialization:** Mengubah objek Dart menjadi format yang dapat ditransfer (misalnya, JSON _string_).
- **Deserialization:** Mengubah format yang ditransfer (misalnya, JSON _string_) menjadi objek Dart.
- **`factory` Constructor:** Constructor khusus yang tidak selalu membuat _instance_ baru, cocok untuk deserialisasi.
- **`json_annotation`:** Package yang menyediakan anotasi.
- **`json_serializable`:** Package generator kode untuk _parsing_ JSON otomatis.
- **`build_runner`:** Alat yang menjalankan _code generator_.
- **`part` directive:** Digunakan untuk memisahkan bagian dari sebuah _library_ ke file lain, penting untuk _code generation_.
- **`@JsonSerializable()`:** Anotasi untuk menandai kelas model yang akan digenerate kode _parsing_-nya.
- **`@JsonKey(name: '...')`:** Anotasi untuk memetakan properti Dart ke nama kunci JSON yang berbeda.

**Sumber Referensi Lengkap:**

- [Working with JSON (Flutter Docs)](https://docs.flutter.dev/data/json/overview)
- [json_serializable package (pub.dev)](https://pub.dev/packages/json_serializable)
- [json_annotation package (pub.dev)](https://pub.dev/packages/json_annotation)
- [build_runner package (pub.dev)](https://pub.dev/packages/build_runner)

**Tips dan Praktik Terbaik:**

- **Mulai dengan Manual:** Bagi pemula, berlatihlah _parsing_ JSON secara manual terlebih dahulu untuk memahami konsep dasarnya sebelum beralih ke `json_serializable`.
- **Gunakan `json_serializable` untuk Proyek Nyata:** Untuk sebagian besar aplikasi yang akan berinteraksi dengan API, `json_serializable` adalah pilihan yang sangat direkomendasikan karena menghemat waktu dan mengurangi kesalahan.
- **Pemisahan File Model:** Selalu pisahkan definisi kelas model Anda ke dalam file terpisah (misalnya, `models/user.dart`, `models/product.dart`).
- **Konsisten dalam Pemodelan:** Pastikan model Anda secara akurat mencerminkan struktur JSON dari API yang Anda gunakan.
- **Tangani Nullability:** Pertimbangkan dengan cermat apakah suatu properti bisa `null` dan gunakan _null safety_ Dart (`?`) dengan tepat.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Kesalahan `type '...' is not a subtype of type 'String'` atau serupa saat _parsing_.

  - **Penyebab:** JSON mengembalikan tipe data yang berbeda dari yang Anda harapkan di model Dart Anda, atau Anda lupa melakukan _type casting_ secara eksplisit (saat _parsing_ manual).
  - **Solusi:** Periksa kembali struktur JSON yang sebenarnya dan sesuaikan tipe data di kelas model Anda. Dengan _manual parsing_, pastikan Anda melakukan _casting_ yang benar (misalnya, `as String`, `as int`). Dengan `json_serializable`, pastikan anotasi dan tipe properti Anda cocok.

- **Kesalahan:** File `.g.dart` tidak ditemukan atau tidak digenerate.

  - **Penyebab:** Lupa menjalankan `flutter pub run build_runner build` atau ada kesalahan sintaksis di kelas model yang mencegah generator berjalan.
  - **Solusi:** Pastikan Anda telah menambahkan semua _dev dependencies_ yang diperlukan (`build_runner`, `json_serializable`) di `pubspec.yaml`, jalankan `flutter pub get`, dan kemudian jalankan perintah `build_runner`. Periksa _output_ terminal untuk pesan kesalahan.

- **Kesalahan:** Properti tidak di-_parse_ dengan benar (misalnya, `null` padahal seharusnya ada nilai).

  - **Penyebab:** Nama kunci JSON tidak cocok dengan nama properti di kelas Dart Anda.
  - **Solusi:** Jika nama kunci JSON berbeda dari nama properti Dart Anda, gunakan `@JsonKey(name: 'json_key_name')` di atas properti di kelas model Anda.

# Selamat!

Dengan ini, Anda telah menyelesaikan seluruh **Fase 8: Asynchronous Programming dan Konektivitas Jaringan**! Anda sekarang memiliki pemahaman yang komprehensif tentang bagaimana aplikasi Flutter Anda dapat berinteraksi dengan data eksternal secara efisien dan aman.

Anda kini dapat:

- Menulis kode asinkron menggunakan `Future`, `async`, dan `await`.
- Membangun UI yang reaktif terhadap data asinkron dengan `FutureBuilder` dan `StreamBuilder`.
- Melakukan berbagai jenis _request_ HTTP (`GET`, `POST`, `PUT`, `DELETE`) menggunakan `package:http`.
- Mengelola data JSON dengan pemodelan data, baik secara manual maupun otomatis dengan `json_serializable`.
- Menangani berbagai skenario kesalahan jaringan dengan tangkas.

kita telah berhasil menyelesaikan seluruh **Fase 8: Asynchronous Programming dan Konektivitas Jaringan** Selanjutnya kita akan masuk pada **Fase 9: Manajemen State Lanjutan**

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md

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
