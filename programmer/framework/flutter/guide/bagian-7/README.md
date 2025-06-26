# [FASE 5: Asynchronous Programming & API Integration][0]

<details>
  <summary>📃 Struktur Daftar Isi</summary>

- [FASE 5: Asynchronous Programming \& API Integration](#fase-5-asynchronous-programming--api-integration)
  - [FASE 5: Asynchronous Programming \& API Integration](#fase-5-asynchronous-programming--api-integration-1)
  - [5.1 Asynchronous Programming in Dart](#51-asynchronous-programming-in-dart)
    - [5.1.1 Futures (`async`/`await`)](#511-futures-asyncawait)
    - [5.1.2 Streams (Basic Concepts)](#512-streams-basic-concepts)
    - [5.1.3 Error Handling (`try-catch-finally`)](#513-error-handling-try-catch-finally)
  - [5.2 HTTP Requests \& REST APIs](#52-http-requests--rest-apis)
    - [5.2.1 Understanding RESTful Principles](#521-understanding-restful-principles)
    - [5.2.2 Making Basic HTTP Requests (`http` package)](#522-making-basic-http-requests-http-package)
    - [5.2.3 Handling JSON (Serialization/Deserialization)](#523-handling-json-serializationdeserialization)
  - [5.3 Advanced API Integration](#53-advanced-api-integration)
    - [5.3.1 Dio (Advanced HTTP Client)](#531-dio-advanced-http-client)
    - [5.3.2 Error Handling \& Interceptors](#532-error-handling--interceptors)
    - [5.3.3 Working with Authentication (Tokens)](#533-working-with-authentication-tokens)
  - [5.4 Local Data Persistence](#54-local-data-persistence)
    - [5.4.1 Shared Preferences (Simple Key-Value)](#541-shared-preferences-simple-key-value)
    - [5.4.2 SQLite (via `sqflite` package)](#542-sqlite-via-sqflite-package)
    - [5.4.3 Hive/Isar (NoSQL Local Database)](#543-hiveisar-nosql-local-database)
  - [Hive (Contoh Kode)](#hive-contoh-kode)
  - [Isar (Contoh Kode)](#isar-contoh-kode)
  - [Hive](#hive)
  - [Isar](#isar)
- [Selamat!](#selamat)

</details>

---

### FASE 5: Asynchronous Programming & API Integration

**Tujuan Pembelajaran Fase 5:**
Setelah menyelesaikan fase ini, pembelajar akan mampu:

- Memahami dan mengimplementasikan konsep _asynchronous programming_ di Dart (`Future`, `async/await`, `Stream`).
- Melakukan permintaan HTTP dasar dan canggih ke RESTful API.
- Menangani data JSON (serialize dan deserialize) dengan benar.
- Mengelola _error_ dan mengimplementasikan _interceptor_ dalam komunikasi jaringan.
- Memahami dasar-dasar otentikasi berbasis token.
- Mengimplementasikan berbagai strategi penyimpanan data lokal (key-value, SQL, NoSQL).

**Terminologi Esensial & Penjelasan Detail:**

- **Asynchronous Programming:** Model pemrograman yang memungkinkan eksekusi tugas tanpa memblokir _thread_ utama (UI), memastikan aplikasi tetap responsif.
- **`Future`:** Objek yang merepresentasikan nilai potensial, atau _error_, yang akan tersedia di masa depan.
- **`async` & `await`:** Kata kunci di Dart yang digunakan untuk bekerja dengan `Future` secara sinkron, membuat kode asinkron lebih mudah dibaca dan ditulis.
- **`Stream`:** Urutan kejadian asinkron. Mirip dengan `Future` (yang hanya sekali), `Stream` dapat menghasilkan banyak nilai seiring waktu.
- **HTTP (Hypertext Transfer Protocol):** Protokol dasar untuk pertukaran data di web.
- **REST (Representational State Transfer):** Gaya arsitektur untuk sistem terdistribusi, sering digunakan untuk mendesain API web.
- **API (Application Programming Interface):** Seperangkat definisi yang memungkinkan dua aplikasi berinteraksi.
- **JSON (JavaScript Object Notation):** Format standar untuk pertukaran data yang ringan dan mudah dibaca manusia serta mesin.
- **Serialization / Deserialization:** Proses mengkonversi objek Dart menjadi JSON (serialization) dan sebaliknya (deserialization).
- **Interceptor:** Sebuah mekanisme untuk mencegat permintaan HTTP dan responsnya untuk memodifikasi atau memprosesnya (misalnya, menambahkan _header_ otorisasi, _logging_).
- **Token-based Authentication:** Metode otentikasi di mana server mengeluarkan _token_ kepada klien setelah login, dan klien menggunakan _token_ tersebut untuk otorisasi pada permintaan berikutnya.
- **Local Data Persistence:** Kemampuan aplikasi untuk menyimpan data secara permanen di perangkat pengguna, bahkan setelah aplikasi ditutup.
- **Key-Value Store:** Bentuk database non-relasional paling sederhana, menyimpan data sebagai pasangan kunci-nilai.
- **SQL (Structured Query Language):** Bahasa standar untuk mengelola database relasional.
- **NoSQL (Not Only SQL):** Kategori database yang tidak mengikuti skema tabel relasional tradisional.

---

### 5.1 Asynchronous Programming in Dart

Sub-bagian ini akan mengulas konsep-konsep inti pemrograman asinkron di Dart, yang merupakan fondasi penting untuk setiap aplikasi Flutter yang berinteraksi dengan sumber data eksternal (misalnya, API, database, file system).

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami mengapa pemrograman asinkron diperlukan di Flutter (untuk menjaga UI tetap responsif) dan bagaimana mengimplementasikannya menggunakan `Future`, `async/await`, dan `Stream`. Penanganan _error_ dalam konteks asinkron juga akan dibahas. Ini adalah prasyarat mutlak untuk dapat melakukan integrasi API atau operasi I/O lainnya.

**Konsep Kunci & Filosofi Mendalam:**

- **Single-threaded nature of Dart/Flutter:** Dart (dan Flutter) berjalan pada satu _thread_ utama (UI thread). Semua operasi UI dan sebagian besar logika bisnis dieksekusi di sini.

  - **Filosofi:** Menyederhanakan konkurensi (tidak ada masalah _deadlock_), tetapi menuntut penanganan operasi yang berpotensi memakan waktu (seperti panggilan jaringan) secara asinkron agar UI tidak "membeku" (juga dikenal sebagai "jank").

- **Event Loop:** Model konkurensi Dart/Flutter menggunakan _event loop_ untuk memproses tugas-tugas secara non-blokir.

  - **Filosofi:** Memungkinkan operasi asinkron dijadwalkan dan dieksekusi di latar belakang tanpa mengganggu _event loop_ utama yang bertanggung jawab atas respons UI.

- **Non-blocking I/O:** Operasi Input/Output (seperti membaca file, membuat permintaan HTTP) secara inheren bersifat asinkron.

  - **Filosofi:** Memanfaatkan sifat alami operasi I/O untuk tidak memblokir _thread_ utama, sehingga aplikasi tetap responsif.

**Visualisasi Diagram Alur/Struktur:**

- Diagram sederhana yang menunjukkan _UI Thread_ dan _Event Loop_.
- Panah yang menunjukkan bagaimana tugas-tugas asinkron "dibuang" ke _event queue_ dan diproses nanti tanpa memblokir _main thread_.
- Visualisasi `Future` sebagai "kotak hadiah yang akan datang" atau "janji" untuk nilai di masa depan.
- Visualisasi `Stream` sebagai "pipa" tempat nilai-nilai mengalir seiring waktu.

**Hubungan dengan Modul Lain:**
Ini adalah fondasi untuk seluruh Fase 5 (API Integration, Local Data Persistence) dan bahkan Fase 6 (Arsitektur Aplikasi - karena BLoC/Cubit sering menangani operasi asinkron). Pemahaman yang solid di sini akan sangat penting untuk menghindari _bug_ terkait konkurensi dan performa.

---

#### 5.1.1 Futures (`async`/`await`)

Sub-bagian ini akan menjelaskan konsep `Future` di Dart dan bagaimana cara kerjanya dengan kata kunci `async` dan `await`.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar bahwa `Future` adalah objek yang mewakili hasil dari operasi asinkron yang akan selesai di masa mendatang (berhasil dengan nilai atau gagal dengan _error_). Kata kunci `async` digunakan untuk menandai fungsi sebagai asinkron (yang akan mengembalikan `Future`), dan `await` digunakan di dalam fungsi `async` untuk menunggu penyelesaian `Future` lain tanpa memblokir eksekusi.

**Konsep Kunci & Filosofi Mendalam:**

- **Representasi Hasil Asinkron:** `Future` adalah cara Dart untuk merepresentasikan operasi yang belum selesai.

  - **Filosofi:** Mengabstraksi kompleksitas penanganan operasi asinkron dan menjanjikan hasil yang akan datang, memungkinkan pengembang menulis kode yang lebih sekuensial meskipun eksekusinya non-sekuensial.

- **Non-blocking Execution:** Ketika `await` digunakan, eksekusi fungsi `async` akan ditangguhkan sampai `Future` yang di-_await_ selesai, tetapi _thread_ utama TIDAK diblokir. _Event loop_ akan memproses tugas lain sementara itu.

  - **Filosofi:** Menjaga responsivitas aplikasi dengan memungkinkan tugas berat berjalan tanpa menghentikan UI.

- **Chaining Futures:** Anda dapat merangkai operasi `Future` menggunakan `.then()` atau dengan serangkaian `await`.

  - **Filosofi:** Membangun alur kerja asinkron yang kompleks secara berurutan dan mudah dibaca.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'dart:io'; // Untuk simulasi delay

// --- Contoh Sederhana Future ---
Future<String> fetchDataFromNetwork() {
  // Simulasi operasi jaringan yang membutuhkan waktu
  return Future.delayed(const Duration(seconds: 2), () {
    print('Data diterima dari jaringan!');
    return 'Halo dari Server!';
  });
}

void main() async {
  print('1. Memulai aplikasi...');

  // Menggunakan .then() untuk menangani hasil Future
  fetchDataFromNetwork().then((data) {
    print('2. Data pertama: $data');
  });

  // Menggunakan async/await untuk sintaks yang lebih bersih
  print('3. Memulai pengambilan data kedua (dengan async/await)...');
  String dataKedua = await fetchDataFromNetwork(); // Menunggu tanpa memblokir main thread
  print('4. Data kedua: $dataKedua');

  print('5. Operasi aplikasi lainnya berjalan...');

  // Contoh dengan potensi error
  try {
    print('6. Memulai operasi yang mungkin gagal...');
    String result = await performRiskyOperation(true); // Ganti ke false untuk sukses
    print('7. Operasi berhasil: $result');
  } catch (e) {
    print('7. Operasi gagal: $e');
  } finally {
    print('8. Blok finally selalu dieksekusi.');
  }

  print('9. Aplikasi selesai.');
}

// Fungsi asinkron yang mungkin melempar error
Future<String> performRiskyOperation(bool shouldFail) {
  return Future.delayed(const Duration(seconds: 1), () {
    if (shouldFail) {
      throw Exception('Oops! Ada masalah dalam operasi ini.');
    }
    return 'Operasi penting selesai!';
  });
}

// --- Contoh dalam Konteks Flutter (Conceptual) ---
// Misalkan ini di dalam StatefullWidget
class MyAsyncWidget extends StatefulWidget {
  const MyAsyncWidget({super.key});

  @override
  State<MyAsyncWidget> createState() => _MyAsyncWidgetState();
}

class _MyAsyncWidgetState extends State<MyAsyncWidget> {
  String _data = 'Belum ada data';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData(); // Memicu operasi asinkron saat widget diinisialisasi
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true; // Set state loading
      _data = 'Memuat data...';
    });
    try {
      String result = await fetchDataFromNetwork(); // Menunggu Future selesai
      setState(() {
        _data = result; // Update UI dengan data yang diterima
      });
    } catch (e) {
      setState(() {
        _data = 'Gagal memuat: ${e.toString()}'; // Update UI dengan pesan error
      });
    } finally {
      setState(() {
        _isLoading = false; // Selesai loading, baik sukses atau gagal
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(_data, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadData, // Panggil kembali operasi async
              child: const Text('Refresh Data'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

- **`Future<String> fetchDataFromNetwork()`:** Fungsi ini dideklarasikan mengembalikan `Future<String>`. Ini berarti suatu saat di masa depan, fungsi ini akan menghasilkan `String`. `Future.delayed` adalah cara Dart untuk mensimulasikan operasi yang membutuhkan waktu.
- **`void main() async { ... }`:** Fungsi `main` ditandai dengan `async`. Ini memungkinkan penggunaan `await` di dalamnya.
- **`.then()`:** Ini adalah cara tradisional untuk menangani hasil `Future`. _Callback_ di dalam `.then()` akan dieksekusi setelah `Future` selesai dengan sukses. Contoh ini menunjukkan bahwa kode setelah pemanggilan `fetchDataFromNetwork().then()` akan tetap dieksekusi tanpa menunggu hasilnya.
- **`await fetchDataFromNetwork()`:** Ketika `await` digunakan, eksekusi kode di fungsi `async` tersebut akan "dijeda" sampai `fetchDataFromNetwork()` selesai dan mengembalikan nilainya. Namun, penting untuk dicatat bahwa `await` TIDAK memblokir _main thread_. Dart akan beralih untuk mengerjakan tugas lain di _event loop_ sampai `Future` ini selesai. Setelah selesai, eksekusi di fungsi `async` akan dilanjutkan dari titik di mana `await` berada.
- **`try-catch-finally`:** Blok ini sangat penting untuk penanganan _error_ dalam operasi asinkron.
  - `try`: Kode yang berpotensi melempar _error_ ditempatkan di sini.
  - `catch (e)`: Jika _error_ terjadi di blok `try`, kode di `catch` akan dieksekusi, dan _error_ dapat ditangkap dalam variabel `e`.
  - `finally`: Kode di blok `finally` akan selalu dieksekusi, terlepas dari apakah `Future` berhasil atau gagal, dan biasanya digunakan untuk membersihkan sumber daya atau mengakhiri status _loading_.
- **`_MyAsyncWidgetState` (Flutter Context):**
  - **`_loadData()` `async` function:** Ini adalah contoh bagaimana fungsi asinkron akan digunakan dalam _widget_ Flutter.
  - **`setState(() { _isLoading = true; });`:** Penting untuk memperbarui _state_ UI sebelum dan sesudah operasi asinkron untuk menunjukkan _loading state_ atau menampilkan data yang baru dimuat/pesan _error_.

**Visualisasi Diagram Alur/Struktur:**

- **Alur `async/await`:** Kotak (fungsi `async`), panah masuk ke `await`, panah keluar ke _event queue_, kemudian panah kembali setelah `Future` selesai, lalu eksekusi dilanjutkan.
- **Perbandingan `then` vs `async/await`:**
  - `then`: Fungsi A -\> Future X -\> .then(handle X) -\> Fungsi B. (Fungsi B dieksekusi sebelum handle X)
  - `async/await`: Fungsi A -\> await Future X -\> handle X -\> Fungsi B. (Fungsi B dieksekusi setelah handle X)
  - Penekanan pada `await` membuat kode terlihat sekuensial, meskipun dieksekusi secara asinkron.

**Terminologi Esensial & Penjelasan Detail:**

- **`Future<T>`:** Objek yang mewakili hasil dari operasi asinkron yang akan menghasilkan nilai bertipe `T` di masa depan.
- **`async`:** Kata kunci yang digunakan untuk menandai sebuah fungsi sebagai asinkron. Fungsi `async` selalu mengembalikan `Future`.
- **`await`:** Kata kunci yang hanya dapat digunakan di dalam fungsi `async`. Ini menjeda eksekusi fungsi `async` sampai `Future` yang di-_await_ selesai dan mengembalikan nilainya. Eksekusi _thread_ utama tidak terblokir selama penundaan ini.
- **`then()`:** Metode pada `Future` yang memungkinkan Anda mendaftarkan _callback_ untuk dieksekusi ketika `Future` selesai dengan sukses.
- **`catchError()`:** Metode pada `Future` untuk mendaftarkan _callback_ penanganan _error_ jika `Future` gagal.
- **`onComplete()` / `whenComplete()`:** Metode pada `Future` yang memungkinkan Anda mendaftarkan _callback_ untuk dieksekusi ketika `Future` selesai, baik sukses atau gagal. (Serupa dengan `finally`).
- **`try-catch-finally` block:** Struktur kontrol aliran untuk menangani _error_ secara sinkron atau asinkron.

**Sumber Referensi Lengkap:**

- [Asynchrony support (Dart documentation)](https://dart.dev/guides/language/language-tour%23asynchrony-support)
- [Futures, async, await (Flutter documentation)](https://docs.flutter.dev/data-and-backend/networking/fetch-data)
- [The Event Loop and Dart (YouTube - Flutter)](https://www.youtube.com/watch%3Fv%3DPX_w6yqQ28g)

**Tips dan Praktik Terbaik:**

- **Gunakan `async`/`await` untuk Keterbacaan:** Sebagian besar waktu, `async`/`await` akan membuat kode asinkron Anda jauh lebih mudah dibaca dan di-_maintain_ dibandingkan rantai `.then()` yang kompleks.
- **Selalu Tangani Error:** Jangan pernah meninggalkan `Future` tanpa penanganan _error_. Gunakan `try-catch-finally` atau `.catchError()` untuk memastikan aplikasi Anda tidak _crash_ jika terjadi kegagalan.
- **Pahami `await` tidak memblokir:** Ingat bahwa `await` menjeda fungsi _saat ini_ tetapi tidak memblokir seluruh aplikasi (UI tetap responsif).
- **Jangan `await` di _top-level_ `main()`:** Hindari `await` langsung di `main()` tanpa penanganan yang tepat jika aplikasi Anda tidak dirancang untuk menunggu. Di Flutter, `runApp` biasanya yang mengendalikan _lifecycle_.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** "Unhandled exception in Future" atau aplikasi _crash_ karena _error_ asinkron tidak tertangkap.

  - **Penyebab:** Lupa menggunakan `try-catch` di sekitar kode `await` yang berpotensi gagal, atau lupa menambahkan `.catchError()` pada `Future` yang tidak di-_await_.
  - **Solusi:** Selalu sertakan penanganan _error_ yang kuat untuk setiap operasi asinkron.

- **Kesalahan:** UI membeku (jank) saat melakukan operasi asinkron.

  - **Penyebab:** Anda mungkin melakukan operasi yang memakan waktu lama di _main thread_ secara sinkron, atau Anda memblokir _main thread_ secara tidak sengaja.
  - **Solusi:** Pastikan semua operasi yang berpotensi memblokir (seperti I/O, komputasi berat) dilakukan secara asinkron menggunakan `Future` dan `await`. Hindari `await` yang terlalu lama berturut-turut tanpa jeda yang memungkinkan _event loop_ bekerja.

- **Kesalahan:** Data tidak diperbarui di UI setelah operasi asinkron selesai.

  - **Penyebab:** Lupa memanggil `setState()` setelah data diterima atau _state_ diperbarui di dalam _callback_ `Future` (jika menggunakan `StatefulWidget`).
  - **Solusi:** Pastikan `setState()` dipanggil di _build method_ atau _callback_ yang relevan setelah _state_ aplikasi yang memengaruhi UI diubah.

---

#### 5.1.2 Streams (Basic Concepts)

Sub-bagian ini akan memperkenalkan konsep `Stream` di Dart, sebuah fitur penting untuk menangani urutan peristiwa atau data yang datang secara asinkron dari waktu ke waktu.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bahwa sementara `Future` mewakili satu nilai yang akan tiba di masa depan, `Stream` mewakili serangkaian nilai (atau _error_) yang dapat tiba di masa depan. Konsep ini sangat penting untuk skenario seperti menerima _update_ real-time (misalnya, dari WebSocket, Firebase), data sensor, atau _event_ dari UI (misalnya, _input_ dari `TextField` yang terus menerus).

**Konsep Kunci & Filosofi Mendalam:**

- **Urutan Asinkron dari Peristiwa/Data:** `Stream` adalah urutan asinkron dari "event" data. Setiap _event_ dapat berupa data, _error_, atau _signal_ bahwa _stream_ telah selesai.

  - **Filosofi:** Memberikan paradigma yang kuat untuk mengelola aliran data yang dinamis dan tidak dapat diprediksi secara temporal. Ini adalah dasar dari pemrograman reaktif (Reactive Programming) di Dart/Flutter.

- **Publisher-Subscriber Pattern:** `Stream` bekerja berdasarkan pola _publisher-subscriber_. _Publisher_ (sumber _stream_) menghasilkan data, dan _subscriber_ (listener) mengonsumsi data tersebut.

  - **Filosofi:** Memisahkan pihak yang menghasilkan data dari pihak yang mengonsumsinya, sehingga komponen-komponen dapat beroperasi secara independen dan responsif terhadap perubahan.

- **Single-subscription vs. Broadcast Streams:**

  - **Single-subscription:** Hanya satu _listener_ yang diizinkan pada satu waktu. Setelah _listener_ pertama mulai mendengarkan, _stream_ akan mulai mengirim _event_. Jika _listener_ baru mencoba mendengarkan, itu akan menyebabkan _error_. Umum untuk I/O (membaca file).
  - **Broadcast:** Mengizinkan banyak _listener_ sekaligus. _Event_ akan dikirim ke semua _listener_ aktif. Umum untuk _event_ UI atau _push notifications_.
  - **Filosofi:** Menyediakan fleksibilitas untuk skenario penggunaan yang berbeda, mengoptimalkan sumber daya untuk _single-subscription_ dan memungkinkan distribusi _event_ yang luas untuk _broadcast_.

- **Reactive Programming Foundations:** `Stream` adalah dasar dari paradigma pemrograman reaktif. Konsep-konsep seperti _filtering_, _mapping_, _combining streams_ akan sering digunakan.

  - **Filosofi:** Memungkinkan logika bisnis untuk berinteraksi dengan data yang terus berubah dengan cara yang deklaratif dan mudah dipahami.

**Visualisasi Diagram Alur/Struktur:**

- Diagram `Stream` sebagai pipa horizontal dengan nilai-nilai (kotak) mengalir di dalamnya seiring waktu, dan _error_ (X) serta _completion signal_ (garis vertikal).
- Perbandingan `Future` (satu kotak yang lewat) vs. `Stream` (serangkaian kotak yang lewat).
- Diagram _publisher-subscriber_ yang menunjukkan `StreamController` (publisher) mengirimkan data ke beberapa `StreamBuilder` atau `listener` (subscriber).

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'dart:async'; // Untuk StreamController

// --- Contoh Sederhana Stream: Counter Stream ---
// Menggunakan StreamController untuk mengelola stream
Stream<int> createCounterStream(int maxCount) {
  // StreamController memberikan kontrol penuh atas stream
  final controller = StreamController<int>();
  int counter = 0;

  // Timer untuk mengirim event secara berkala
  Timer.periodic(const Duration(seconds: 1), (timer) {
    if (counter < maxCount) {
      controller.sink.add(counter++); // Menambahkan data ke stream
    } else {
      controller.close(); // Menutup stream setelah selesai
      timer.cancel(); // Menghentikan timer
    }
  });

  return controller.stream; // Mengembalikan stream
}

// --- Contoh Broadcast Stream ---
// Stream yang bisa didengarkan oleh banyak listener
Stream<String> createBroadcastMessageStream() {
  final controller = StreamController<String>.broadcast(); // Penting: .broadcast()

  int messageCount = 0;
  Timer.periodic(const Duration(seconds: 1), (timer) {
    if (messageCount < 5) {
      controller.sink.add('Pesan ${messageCount++}');
    } else {
      controller.close();
      timer.cancel();
    }
  });

  return controller.stream;
}


void main() async {
  print('--- Memulai Stream Counter (Single Subscription) ---');
  final myCounterStream = createCounterStream(5);

  // Cara pertama: Mendengarkan Stream dengan listen()
  myCounterStream.listen(
    (data) {
      print('Diterima (Listener 1): $data');
    },
    onError: (error) {
      print('Error (Listener 1): $error');
    },
    onDone: () {
      print('Stream Counter Selesai (Listener 1)!');
    },
    cancelOnError: true, // Akan membatalkan langganan jika ada error
  );

  // Contoh: mencoba mendengarkan single-subscription stream lagi akan melempar error
  // try {
  //   myCounterStream.listen((data) {
  //     print('Diterima (Listener 2): $data'); // Ini akan gagal
  //   });
  // } catch (e) {
  //   print('Error mendengarkan Stream kedua kali: $e');
  // }

  print('\n--- Memulai Stream Pesan (Broadcast) ---');
  final myMessageStream = createBroadcastMessageStream();

  // Listener pertama
  myMessageStream.listen((message) {
    print('Listener A: $message');
  });

  // Listener kedua (bisa mendengarkan broadcast stream)
  Future.delayed(const Duration(milliseconds: 1500), () {
    myMessageStream.listen((message) {
      print('  Listener B: $message');
    });
  });

  print('Program utama terus berjalan...');
}

// --- Contoh dalam Konteks Flutter (Conceptual): StreamBuilder ---
import 'package:flutter/material.dart';

class StreamBuilderCounterPage extends StatelessWidget {
  const StreamBuilderCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StreamBuilder Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Counter from Stream:', style: TextStyle(fontSize: 24)),
            // StreamBuilder mendengarkan stream dan membangun ulang UI
            StreamBuilder<int>(
              stream: createCounterStream(10), // Menyediakan stream
              // builder: (context, snapshot) adalah callback yang dipanggil saat stream berubah.
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('Tidak ada Stream');
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  case ConnectionState.active:
                    // Data tersedia dan stream masih aktif
                    return Text(
                      '${snapshot.data}', // Mengakses data terbaru
                      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    );
                  case ConnectionState.done:
                    // Stream sudah selesai
                    return Text(
                      'Selesai! Nilai terakhir: ${snapshot.data}',
                      style: const TextStyle(fontSize: 30, color: Colors.green),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

- **`StreamController`:** Ini adalah kelas inti untuk membuat dan mengelola `Stream` secara manual.
  - `controller.sink.add(data)`: Digunakan untuk menambahkan data ke _stream_.
  - `controller.sink.addError(error)`: Digunakan untuk menambahkan _error_ ke _stream_.
  - `controller.close()`: Digunakan untuk memberi sinyal bahwa _stream_ telah selesai dan tidak akan ada lagi _event_. Ini penting untuk membersihkan sumber daya.
  - `.broadcast()`: Digunakan pada konstruktor `StreamController` untuk membuat _broadcast stream_ yang bisa memiliki banyak _listener_.
- **`myStream.listen(...)`:** Ini adalah cara paling dasar untuk mendengarkan _event_ dari `Stream`.
  - _Callback_ pertama dipanggil setiap kali ada data baru.
  - `onError` dipanggil jika ada _error_ di _stream_.
  - `onDone` dipanggil ketika _stream_ ditutup.
- **`StreamBuilder<T>` (Flutter Context):**
  - Ini adalah _widget_ Flutter yang dirancang khusus untuk mengkonsumsi `Stream` dan membangun ulang UI secara reaktif.
  - `stream`: Properti ini menerima `Stream` yang ingin Anda dengarkan.
  - `builder`: Properti ini adalah fungsi yang dipanggil setiap kali ada _event_ baru dari _stream_.
  - `AsyncSnapshot<T> snapshot`: Objek `snapshot` adalah sangat penting di dalam `builder`. Ini berisi status terbaru dari _stream_:
    - `snapshot.connectionState`: Menunjukkan status koneksi _stream_ (`none`, `waiting`, `active`, `done`). Ini sangat berguna untuk menampilkan indikator _loading_ atau pesan _error_.
    - `snapshot.hasData`: `true` jika _snapshot_ memiliki data terbaru.
    - `snapshot.data`: Data terbaru yang dikeluarkan oleh _stream_.
    - `snapshot.hasError`: `true` jika _snapshot_ memiliki _error_.
    - `snapshot.error`: Objek _error_ jika _stream_ mengeluarkan _error_.
  - Penggunaan `switch (snapshot.connectionState)` adalah pola umum untuk menangani berbagai status _stream_ di UI.

**Visualisasi Diagram Alur/Struktur:**

- Diagram yang menunjukkan `StreamController` sebagai sumber, kemudian panah `add` data, `addError`, `close` ke dalam pipa `Stream`.
- Dari pipa `Stream`, panah keluar ke `listen` (untuk logika non-UI) dan `StreamBuilder` (untuk pembaruan UI).
- Visualisasi `AsyncSnapshot` sebagai "penampung" yang berisi status (data/error/loading) dari _stream_ pada titik waktu tertentu.

**Terminologi Esensial & Penjelasan Detail:**

- **`Stream`:** Sebuah objek di Dart yang mewakili urutan _event_ asinkron.
- **`StreamController`:** Sebuah kelas untuk membuat dan mengelola `Stream` secara manual. Digunakan untuk `add` data/error dan `close` _stream_.
- **`sink`:** Properti dari `StreamController` yang digunakan untuk menambahkan _event_ (data atau _error_) ke _stream_.
- **`listen()`:** Metode untuk berlangganan (subscribe) ke sebuah `Stream` dan menerima _event_-nya. Mengembalikan `StreamSubscription`.
- **`StreamSubscription`:** Objek yang dikembalikan oleh `listen()`. Digunakan untuk mengelola langganan (misalnya, `cancel()`).
- **`StreamBuilder<T>`:** _Widget_ Flutter yang mengkonsumsi `Stream` dan secara otomatis membangun ulang bagian UI-nya setiap kali `Stream` mengeluarkan data baru.
- **`AsyncSnapshot<T>`:** Objek yang disediakan oleh `StreamBuilder` di fungsi `builder`-nya, yang berisi _state_ terbaru dari `Stream` (data, _error_, status koneksi).
- **`ConnectionState`:** Enum yang mendeskripsikan status koneksi asinkron (misalnya, `none`, `waiting`, `active`, `done`).

**Sumber Referensi Lengkap:**

- [Streams (Dart documentation)](https://dart.dev/guides/libraries/library-tour%23streams)
- [Streams, async, await (Flutter documentation)](https://docs.flutter.dev/data-and-backend/networking/fetch-data%23streams)
- [StreamController class (Dart API docs)](https://api.dart.dev/stable/dart-async/StreamController-class.html)
- [StreamBuilder class (Flutter API docs)](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)

**Tips dan Praktik Terbaik:**

- **Pilih `Future` atau `Stream`:** Gunakan `Future` ketika Anda hanya mengharapkan satu hasil dari operasi asinkron (misalnya, mengambil data sekali dari API). Gunakan `Stream` ketika Anda mengharapkan serangkaian hasil dari waktu ke waktu (misalnya, _update_ real-time, _event_ dari sensor).
- **Kelola `StreamSubscription`:** Jika Anda membuat _listener_ secara manual dengan `listen()`, pastikan untuk membatalkan langganan (`subscription.cancel()`) saat tidak lagi dibutuhkan (misalnya, di metode `dispose()` dari `StatefulWidget`) untuk mencegah _memory leak_. `StreamBuilder` mengelola ini secara otomatis.
- **Gunakan `StreamBuilder` untuk UI Reaktif:** Untuk pembaruan UI otomatis dari _stream_, `StreamBuilder` adalah cara yang direkomendasikan dan paling efisien.
- **Pahami `snapshot.connectionState`:** Ini adalah kunci untuk membangun UI yang kuat dan responsif terhadap berbagai _state_ dari _stream_ (loading, data, error, done).

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** "Bad state: Stream has already been listened to"

  - **Penyebab:** Anda mencoba mendengarkan _single-subscription stream_ lebih dari satu kali.
  - **Solusi:**
    - Jika Anda memang perlu beberapa _listener_, ubah _stream_ menjadi _broadcast stream_ dengan `StreamController.broadcast()`.
    - Jika Anda hanya perlu satu _listener_, pastikan Anda hanya memanggil `listen()` satu kali atau menggunakan `StreamBuilder` (yang mengelola langganan secara internal).

- **Kesalahan:** _Memory leak_ karena _stream subscription_ tidak dibatalkan.

  - **Penyebab:** Anda berlangganan _stream_ secara manual (misalnya, di `initState()`) tetapi lupa membatalkan langganan di `dispose()`.
  - **Solusi:** Selalu batalkan `StreamSubscription` di `dispose()` atau gunakan `StreamBuilder` yang mengelolanya secara otomatis.

- **Kesalahan:** UI tidak memperbarui atau menampilkan data yang salah dari _stream_.

  - **Penyebab:** Logika di `StreamBuilder` `builder` tidak menangani semua `ConnectionState` atau kondisi data/error dengan benar. Atau, _stream_ tidak mengeluarkan _event_ seperti yang diharapkan.
  - **Solusi:** Gunakan `print()` atau _debugger_ untuk memverifikasi _event_ yang dikeluarkan _stream_ dan status `snapshot` di dalam `builder`. Pastikan logika `switch` atau `if/else if` mencakup semua kasus.

---

#### 5.1.3 Error Handling (`try-catch-finally`)

Sub-bagian ini akan membahas secara komprehensif mekanisme penanganan _error_ di Dart, khususnya dalam konteks pemrograman asinkron. Memastikan aplikasi dapat pulih dengan anggun dari _error_ adalah kunci untuk membangun pengalaman pengguna yang baik dan aplikasi yang stabil.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar bagaimana menggunakan blok `try-catch-finally` untuk menangkap dan mengelola _exception_ yang terjadi selama eksekusi kode, baik sinkron maupun asinkron. Akan dijelaskan juga perbedaan antara `Error` dan `Exception` di Dart, serta pentingnya penanganan _error_ untuk operasi `Future` dan `Stream` yang aman. Ini adalah keterampilan krusial untuk membuat aplikasi yang robust dan _user-friendly_.

**Konsep Kunci & Filosofi Mendalam:**

- **Errors vs. Exceptions:**

  - **`Exception`**: Menunjukkan kondisi yang dapat diatasi dan seharusnya dapat ditangkap oleh kode aplikasi (misalnya, `FormatException`, `TimeoutException`). Ini adalah _error_ yang dapat diharapkan dan ditangani secara programatik.
  - **`Error`**: Menunjukkan _bug_ dalam program yang biasanya tidak seharusnya ditangkap, melainkan harus dicegah atau diperbaiki (misalnya, `StackOverflowError`, `OutOfMemoryError`, `NullReferenceError`). Ini menunjukkan kegagalan serius yang seringkali berarti ada kesalahan dalam logika atau asumsi kode.
  - **Filosofi:** Membedakan antara masalah yang bisa dipulihkan vs. masalah fatal, memungkinkan penanganan yang tepat. Kita cenderung `catch` `Exception` dan membiarkan `Error` mengindikasikan _bug_ yang perlu diperbaiki.

- **`try-catch-finally` Block:** Mekanisme fundamental untuk penanganan _error_.

  - **`try`**: Blok kode yang akan dieksekusi. Jika ada _exception_ terjadi di sini, eksekusi akan segera melompat ke blok `catch` yang sesuai.
  - **`catch`**: Blok kode yang dieksekusi ketika _exception_ terjadi di blok `try`. Ini menangkap _exception_ dan memungkinkan Anda untuk menanganinya (misalnya, menampilkan pesan kepada pengguna, _logging_).
  - **`on`**: Digunakan dengan `catch` untuk menangkap _exception_ dari tipe tertentu (misalnya, `on FormatException catch (e)`). Ini memungkinkan penanganan _error_ yang lebih spesifik.
  - **`stackTrace` (optional di `catch`):** Memberikan jejak tumpukan (stack trace) dari mana _exception_ itu dilempar, sangat berguna untuk _debugging_.
  - **`finally`**: Blok kode yang akan _selalu_ dieksekusi setelah `try` dan `catch` selesai, terlepas dari apakah _exception_ terjadi atau tidak. Ideal untuk membersihkan sumber daya (misalnya, menutup koneksi database, membatalkan _timer_).
  - **Filosofi:** Menyediakan struktur yang aman dan terprediksi untuk menjalankan kode yang berpotensi gagal dan memastikan pembersihan yang tepat.

- **Error Handling in Asynchronous Operations (`Future` & `Stream`):**

  - `Future` dapat gagal dan melempar _exception_. `async/await` memungkinkan penggunaan `try-catch` yang sama seperti kode sinkron.
  - `Stream` juga dapat melempar _error event_. _Listener_ dapat menyediakan _callback_ `onError`, dan `StreamBuilder` akan menangani `snapshot.hasError`.
  - **Filosofi:** Mengakui sifat ketidakpastian operasi asinkron (jaringan, I/O) dan menyediakan mekanisme untuk menanggulangi kegagalan secara anggun tanpa mengganggu pengalaman pengguna.

**Visualisasi Diagram Alur/Struktur:**

- Diagram alur `try-catch-finally`: Panah masuk ke `try`, jika sukses langsung ke `finally`, jika gagal ke `catch` lalu ke `finally`.
- Visualisasi `Future` yang "jatuh" dengan _error_ dan ditangkap oleh `try-catch`.
- Visualisasi `Stream` yang menghasilkan `data event` dan sesekali `error event`, dan bagaimana _listener_ atau `StreamBuilder` membedakannya.

**Hubungan dengan Modul Lain:**
Ini adalah fondasi yang sangat kuat untuk `5.2 HTTP Requests & REST APIs` dan `5.3 Advanced API Integration`, di mana penanganan _error_ dari panggilan jaringan akan menjadi sangat penting. Ini juga relevan untuk `5.4 Local Data Persistence` saat berinteraksi dengan penyimpanan data.

---

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'dart:async'; // Untuk Future.delayed

// --- 1. Contoh Penanganan Error Sinkron ---
void divideNumbers(int a, int b) {
  try {
    if (b == 0) {
      throw const FormatException('Pembagi tidak boleh nol!'); // Melempar custom Exception
    }
    int result = a ~/ b; // Operator integer division
    print('Hasil pembagian: $result');
  } on FormatException catch (e) {
    // Menangkap Exception spesifik
    print('Error format: ${e.message}');
  } catch (e, stackTrace) {
    // Menangkap semua Exception lain
    print('Error umum: $e');
    print('StackTrace: $stackTrace'); // Untuk debugging
  } finally {
    print('Fungsi pembagian selesai (finally block).');
  }
}

// --- 2. Contoh Penanganan Error Asinkron (Future dengan async/await) ---
Future<String> fetchDataSecurely(bool shouldFail) async {
  try {
    print('Mencoba mengambil data...');
    await Future.delayed(const Duration(seconds: 1)); // Simulasi delay

    if (shouldFail) {
      // Melempar error jaringan simulasi
      throw const SocketException('Tidak dapat terhubung ke server.');
    }
    return 'Data rahasia berhasil diambil!';
  } on SocketException catch (e) {
    // Menangkap error jaringan spesifik
    print('Error jaringan (spesifik): ${e.message}');
    return 'Gagal mengambil data: Periksa koneksi internet Anda.';
  } on TimeoutException {
    // Menangkap error timeout
    print('Permintaan ke server timeout.');
    return 'Gagal mengambil data: Server terlalu lama merespons.';
  } catch (e) {
    // Menangkap semua error lain
    print('Error tidak terduga: $e');
    return 'Terjadi kesalahan yang tidak diketahui.';
  } finally {
    print('Proses pengambilan data selesai (finally block).');
  }
}

// --- 3. Contoh Penanganan Error di Stream ---
Stream<int> getNumbersStreamWithErrors(int count) async* {
  for (int i = 0; i < count; i++) {
    await Future.delayed(const Duration(milliseconds: 500));
    if (i == 2) {
      yield* Stream.error(StateError('Terjadi kesalahan pada angka 2!')); // Melempar error ke stream
    }
    if (i == 4) {
      throw FormatException('Error format pada angka 4!'); // Ini akan menjadi unhandled error jika tidak ada catch
    }
    yield i;
  }
}

void main() async {
  print('--- Demo Pembagian ---');
  divideNumbers(10, 2);
  divideNumbers(10, 0);
  divideNumbers(10, 3); // Hasil non-integer, tapi tidak melempar error oleh ~/

  print('\n--- Demo Future Asinkron ---');
  String result1 = await fetchDataSecurely(false); // Sukses
  print('Result 1: $result1\n');

  String result2 = await fetchDataSecurely(true); // Gagal
  print('Result 2: $result2\n');

  print('\n--- Demo Stream dengan Penanganan Error ---');
  // Cara 1: Menggunakan listen() dengan onError callback
  getNumbersStreamWithErrors(5).listen(
    (data) {
      print('Stream Data: $data');
    },
    onError: (error, stackTrace) {
      print('Stream Error: $error');
      print('Stream StackTrace: $stackTrace');
    },
    onDone: () {
      print('Stream Selesai!');
    },
  );

  // Cara 2: Menggunakan async* generator dan try-catch
  // Ini lebih untuk skenario membuat stream, bukan mengkonsumsi
  // Untuk mengkonsumsi di Flutter, StreamBuilder lebih umum
  print('\n--- Demo Stream Generator dengan Internal Try-Catch (konseptual) ---');
  Stream<String> processDataStream(Stream<int> input) async* {
    await for (final value in input) {
      try {
        if (value == 3) {
          throw Exception('Gagal memproses angka 3!');
        }
        yield 'Proses: $value';
      } catch (e) {
        yield 'Error memproses $value: ${e.toString()}';
      }
    }
  }

  // Menggabungkan stream yang melempar error dengan stream yang memprosesnya
  await processDataStream(getNumbersStreamWithErrors(5)).listen(
    (data) {
      print('Processed Stream Data: $data');
    },
    onError: (error) { // Ini akan menangkap error yang tidak ditangani di dalam processDataStream
      print('Unhandled Processed Stream Error: $error');
    },
    onDone: () {
      print('Processed Stream Selesai!');
    },
  ).asFuture(); // Gunakan asFuture() agar main() menunggu stream selesai
}

// --- Contoh dalam Konteks Flutter: UI Error Handling ---
import 'package:flutter/material.dart';

class ErrorHandlingDemoPage extends StatefulWidget {
  const ErrorHandlingDemoPage({super.key});

  @override
  State<ErrorHandlingDemoPage> createState() => _ErrorHandlingDemoPageState();
}

class _ErrorHandlingDemoPageState extends State<ErrorHandlingDemoPage> {
  String _statusMessage = 'Siap.';
  bool _isLoading = false;

  Future<void> _performOperation() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Melakukan operasi...';
    });

    try {
      String data = await fetchDataSecurely(true); // Simulasi gagal
      setState(() {
        _statusMessage = data; // Data berhasil atau pesan error yang ditangani
      });
    } catch (e) {
      // Ini akan menangkap error yang tidak tertangkap di dalam fetchDataSecurely
      // Misalnya, jika fetchDataSecurely hanya melempar error tanpa catch spesifik
      setState(() {
        _statusMessage = 'Terjadi kesalahan fatal: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fatal Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error Handling Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _performOperation,
              child: const Text('Lakukan Operasi'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **Sinkron `try-catch-finally` (`divideNumbers`)**:

    - Menunjukkan cara menangkap `FormatException` secara spesifik menggunakan `on FormatException`.
    - Menunjukkan cara menangkap semua `Exception` lainnya menggunakan `catch (e, stackTrace)`. `stackTrace` sangat berguna untuk _debugging_.
    - Menunjukkan `finally` yang selalu dieksekusi.

2.  **Asinkron `try-catch-finally` (`fetchDataSecurely`)**:

    - Menunjukkan penggunaan `async`/`await` di dalam blok `try`.
    - Menunjukkan penanganan _error_ jaringan spesifik (`SocketException`) dan _timeout_ (`TimeoutException`), yang sangat umum dalam integrasi API.
    - Menangkap _error_ umum sebagai _fallback_.
    - Mengembalikan pesan _string_ yang informatif, yang bisa digunakan langsung di UI.

3.  **`Stream` Error Handling (`getNumbersStreamWithErrors`, `processDataStream`)**:

    - **`yield* Stream.error(...)`**: Cara untuk mengirimkan _error event_ ke `Stream` dari dalam fungsi _generator_ (`async*`).
    - **`listen(..., onError: ..., onDone: ...)`**: Ini adalah cara utama untuk menangani _error_ saat mengkonsumsi `Stream` secara manual. _Callback_ `onError` akan dipanggil.
    - **`async* generator` dengan internal `try-catch`**: Menunjukkan bagaimana Anda dapat mencoba memproses _event_ `Stream` di dalam sebuah `Stream` _generator_ dan menangani _error_ untuk setiap _event_ secara individual, atau bahkan mengubah _error_ menjadi _data event_ (seperti pesan _error_).
    - **Penting**: Jika sebuah `Stream` _generator_ melempar `throw` langsung tanpa `yield* Stream.error` atau tanpa `try-catch` internal, _error_ tersebut akan menjadi _unhandled error_ oleh `Stream` itu sendiri dan akan berakhir pada penanganan _error_ global jika tidak ditangkap oleh `listen()` atau `StreamBuilder`.

4.  **Flutter UI Error Handling (`_ErrorHandlingDemoPageState`)**:

    - Menunjukkan bagaimana _loading state_ dan pesan _error_ diupdate di UI setelah operasi asinkron.
    - Penggunaan `ScaffoldMessenger.of(context).showSnackBar` untuk menampilkan pesan _error_ yang tidak memblokir di UI, yang merupakan UX _pattern_ yang baik.
    - Menunjukkan bahwa bahkan jika _Future_ Anda mengembalikan pesan _error_ yang sudah ditangani, Anda masih bisa memiliki _try-catch_ _outer_ di tingkat UI untuk menangkap _error_ yang mungkin terlewat atau untuk menampilkan UX yang berbeda.

**Visualisasi Diagram Alur/Struktur:**

- Untuk `try-catch-finally`:
  - **Start** -\> **Try Block** -\> (If `Exception`? Yes -\> **Catch Block** -\>) -\> **Finally Block** -\> **End**.
- Untuk Asinkron:
  - **Call `async` function** -\> (Function `await`s a `Future` -\> **Control returned to Event Loop**) -\> (Future completes/errors -\> **Control returns to `async` function**) -\> **Inside `try-catch` -\> handle result/error**.
- Untuk Stream:
  - `Stream` (Pipa data) -\> `Event 1` (data) -\> `Event 2` (data) -\> `Event 3` (error\!) -\> `onError` callback dipicu -\> `Event 4` (data) -\> ...

**Terminologi Esensial & Penjelasan Detail:**

- **`Exception`:** Kondisi yang tidak normal tetapi dapat ditangkap dan ditangani secara programatik.
- **`Error`:** Kondisi fatal yang biasanya menunjukkan _bug_ dan tidak dimaksudkan untuk ditangkap.
- **`throw`:** Kata kunci untuk secara manual melempar `Exception` atau `Error`.
- **`rethrow`:** Digunakan di dalam blok `catch` untuk melempar kembali _exception_ yang sama, memungkinkan _catch block_ lain yang lebih tinggi di _call stack_ untuk menanganinya.
- **`StackTrace`:** Objek yang memberikan informasi tentang urutan pemanggilan fungsi yang mengarah ke _exception_. Penting untuk _debugging_.
- **`onError` (pada `Stream.listen()`):** _Callback_ yang dipicu ketika `Stream` mengeluarkan _error event_.
- **`snapshot.hasError` dan `snapshot.error` (pada `StreamBuilder`):** Properti pada `AsyncSnapshot` yang digunakan untuk mendeteksi dan mengakses _error_ dari `Stream`.

**Sumber Referensi Lengkap:**

- [Errors and exceptions (Dart language tour)](https://dart.dev/guides/language/language-tour%23errors-and-exceptions)
- [Effective Dart: Usage - DO use `rethrow`](<https://dart.dev/guides/language/effective-dart/usage%23do-use-rethrow%5D(https://dart.dev/guides/language/effective-dart/usage%23do-use-rethrow)>>)
- [Flutter Error Handling (Medium)](https://medium.com/flutter-community/flutter-error-handling-d372e9d24263)

**Tips dan Praktik Terbaik:**

- **Jangan menelan _error_ secara diam-diam:** Selalu _log_ _error_ atau tampilkan pesan _error_ yang berarti kepada pengguna. _Debugging_ akan menjadi sulit jika Anda tidak tahu mengapa sesuatu gagal.
- **Tangani _error_ sedekat mungkin dengan sumbernya:** Ini memungkinkan Anda untuk memberikan penanganan yang paling spesifik dan relevan. Namun, jangan takut untuk `rethrow` jika _error_ perlu ditangani di tingkat yang lebih tinggi.
- **Bedakan antara `Exception` dan `Error`:** Tangkap `Exception` untuk pemulihan, biarkan `Error` untuk menunjukkan _bug_ serius.
- **Gunakan `finally` untuk pembersihan:** Ini memastikan sumber daya dilepaskan terlepas dari hasil operasi.
- **Pertimbangkan `Zone` untuk _unhandled errors_:** Untuk _error_ yang tidak tertangkap di seluruh aplikasi Flutter, Anda dapat menggunakan `runZonedGuarded` di `main()` untuk menangkap semua _unhandled errors_ dan mengirimkannya ke layanan _logging_ atau _crash reporting_ (misalnya, Sentry, Firebase Crashlytics). Ini adalah tingkat penanganan _error_ global.
  ```dart
  void main() {
    runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
      // ... (your runApp code)
      runApp(const MyApp());
    }, (error, stack) {
      // Handle all unhandled errors here (e.g., log to Firebase Crashlytics)
      print('Unhandled error: $error');
      print('Stack trace: $stack');
    });
  }
  ```

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Lupa `await` sebuah `Future` di dalam `try` block, sehingga _error_ dari `Future` tersebut tidak tertangkap oleh `try-catch` di sekitarnya.

  - **Penyebab:** Jika Anda tidak `await` sebuah `Future`, _error_ yang dilempar oleh `Future` tersebut akan menjadi _unhandled exception_ yang terjadi secara asinkron.
  - **Solusi:** Selalu `await` `Future` yang berpotensi gagal di dalam blok `try`.

- **Kesalahan:** Menggunakan `catch (e)` tanpa `stackTrace`, membuat _debugging_ sulit.

  - **Penyebab:** Tidak mengetahui dari mana _exception_ itu berasal.
  - **Solusi:** Gunakan `catch (e, stackTrace)` untuk selalu mendapatkan _stack trace_ dan _log_ itu untuk _debugging_.

- **Kesalahan:** Memblokir _main thread_ saat melakukan penanganan _error_ yang berat.

  - **Penyebab:** Melakukan komputasi intensif di dalam blok `catch` atau `finally` secara sinkron.
  - **Solusi:** Pastikan operasi di `catch` dan `finally` juga ringkas atau, jika perlu, jadikan asinkron (meskipun jarang diperlukan di sana).

---

### 5.2 HTTP Requests & REST APIs

Sub-bagian ini akan membahas bagaimana aplikasi Flutter berinteraksi dengan layanan web eksternal melalui HTTP, dengan fokus pada prinsip-prinsip RESTful API dan implementasi dasar menggunakan paket `http`. Penanganan data dalam format JSON juga akan dijelaskan secara rinci.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami dasar-dasar komunikasi _client-server_ menggunakan protokol HTTP. Mereka akan belajar apa itu RESTful API, bagaimana membuat berbagai jenis permintaan HTTP (GET, POST, PUT, DELETE), dan yang paling penting, bagaimana memproses data yang diterima atau dikirim dalam format JSON. Keterampilan ini sangat penting karena sebagian besar aplikasi modern berinteraksi dengan _backend_ melalui API.

**Konsep Kunci & Filosofi Mendalam (Umum untuk Bagian Ini):**

- **Client-Server Architecture:** Memahami peran aplikasi Flutter sebagai _client_ yang meminta data dan _server_ sebagai penyedia data.

  - **Filosofi:** Pemisahan tanggung jawab antara presentasi data (client) dan logika bisnis/penyimpanan data (server), memungkinkan skalabilitas dan _maintenance_ yang lebih baik.

- **Statelessness (dalam REST):** Setiap permintaan dari klien ke server harus berisi semua informasi yang diperlukan untuk memahami permintaan tersebut. Server tidak boleh menyimpan informasi tentang status klien di antara permintaan.

  - **Filosofi:** Meningkatkan skalabilitas, keandalan, dan visibilitas. Server tidak perlu khawatir tentang status sesi, dan klien dapat beralih server dengan mudah.

- **Resource-Oriented:** REST API berpusat pada "sumber daya" (resource) yang dapat diakses melalui URI (Uniform Resource Identifier).

  - **Filosofi:** Menyediakan cara yang konsisten dan terstruktur untuk mengakses dan memanipulasi data melalui URL yang intuitif.

- **Standard HTTP Methods:** Menggunakan metode HTTP standar (GET, POST, PUT, DELETE) untuk melakukan operasi CRUD (Create, Read, Update, Delete) pada sumber daya.

  - **Filosofi:** Memanfaatkan semantik yang sudah ada dari protokol HTTP, membuat API mudah dipahami dan digunakan oleh berbagai klien.

**Visualisasi Diagram Alur/Struktur:**

- Diagram sederhana Client-Server: Panah permintaan dari Flutter App (Client) ke API Server (Server), lalu panah respons dari Server ke Client.
- Diagram siklus hidup permintaan HTTP: Request -\> Server Process -\> Response.

**Hubungan dengan Modul Lain:**
Ini adalah kelanjutan langsung dari `5.1 Asynchronous Programming in Dart`, karena semua permintaan HTTP adalah operasi asinkron. Penanganan _error_ dari `5.1.3` akan sangat relevan di sini. Ini juga menjadi dasar untuk `5.3 Advanced API Integration` dan merupakan prasyarat untuk sebagian besar proyek dunia nyata.

---

#### 5.2.1 Understanding RESTful Principles

Sub-bagian ini akan menjelaskan dasar-dasar arsitektur REST (Representational State Transfer) dan bagaimana prinsip-prinsipnya diterapkan dalam desain API.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan diperkenalkan pada konsep-konsep kunci REST seperti _resources_, URI, _statelessness_, dan penggunaan standar metode HTTP. Pemahaman ini penting bukan hanya untuk mengkonsumsi API, tetapi juga untuk berkomunikasi dengan _backend developer_ dan mendesain aplikasi yang berinteraksi dengan API secara efisien dan benar.

**Konsep Kunci & Filosofi Mendalam:**

- **Resources:** Setiap "hal" (misalnya, pengguna, produk, pesanan) yang dapat diakses melalui API disebut sebagai _resource_. _Resources_ diidentifikasi oleh URI yang unik.

  - **Filosofi:** Mengubah model data kompleks menjadi entitas-entitas yang dapat diakses dan dimanipulasi melalui URL yang sederhana.

- **URI (Uniform Resource Identifier):** Lokasi unik dari sebuah _resource_ di internet (misalnya, `https://api.example.com/users/123`).

  - **Filosofi:** Menyediakan cara yang konsisten dan dapat diidentifikasi untuk menunjuk ke setiap bagian data atau fungsionalitas yang terekspos oleh API.

- **Statelessness:** Setiap permintaan dari _client_ ke _server_ harus mandiri, artinya _server_ tidak mempertahankan informasi "session" atau "state" tentang _client_ dari satu permintaan ke permintaan berikutnya.

  - **Filosofi:** Mendorong skalabilitas dan keandalan. _Server_ dapat menangani permintaan dari _client_ manapun tanpa perlu mengingat konteks sebelumnya, dan permintaan dapat didistribusikan ke _server_ yang berbeda dalam arsitektur terdistribusi.

- **Client-Server:** Arsitektur yang memisahkan _client_ (aplikasi Flutter) dari _server_ (_backend_ API).

  - **Filosofi:** Memungkinkan _client_ dan _server_ untuk berevolusi secara independen.

- **Cacheability:** _Resources_ harus dideklarasikan sebagai _cacheable_ atau _non-cacheable_ untuk memungkinkan _client_ menyimpan respons untuk penggunaan di masa mendatang.

  - **Filosofi:** Meningkatkan performa aplikasi dengan mengurangi jumlah permintaan yang perlu dikirim ke _server_.

- **Layered System:** Sebuah _client_ tidak dapat mengetahui apakah ia terhubung langsung ke _end server_ atau ke _middleware_ (seperti _load balancer_, _proxy_).

  - **Filosofi:** Meningkatkan fleksibilitas dan skalabilitas arsitektur _server_.

- **Uniform Interface:** Set aturan yang membatasi bagaimana _client_ berinteraksi dengan _server_. Ini termasuk penggunaan URI, _standard HTTP methods_, dan representasi _resources_ yang konsisten (misalnya, JSON).

  - **Filosofi:** Menyederhanakan interaksi, karena _client_ hanya perlu memahami satu set aturan untuk berinteraksi dengan _resource_ yang berbeda.

**Sintaks Dasar / Contoh Konseptual (Tanpa Kode Flutter):**

- **Contoh URI dan Metode HTTP:**

  - **GET `/users`**: Mengambil daftar semua pengguna.
  - **GET `/users/123`**: Mengambil detail pengguna dengan ID 123.
  - **POST `/users`**: Membuat pengguna baru (data pengguna dikirim di _body_ permintaan).
  - **PUT `/users/123`**: Memperbarui semua detail pengguna dengan ID 123 (data pengguna lengkap di _body_).
  - **PATCH `/users/123`**: Memperbarui sebagian detail pengguna dengan ID 123 (hanya data yang diubah di _body_).
  - **DELETE `/users/123`**: Menghapus pengguna dengan ID 123.

- **Contoh Respons (JSON):**

  ```json
  // GET /users
  [
    {
      "id": 1,
      "name": "Alice",
      "email": "alice@example.com"
    },
    {
      "id": 2,
      "name": "Bob",
      "email": "bob@example.com"
    }
  ]

  // GET /users/1
  {
    "id": 1,
    "name": "Alice",
    "email": "alice@example.com",
    "address": {
      "street": "123 Main St",
      "city": "Anytown"
    }
  }

  // POST /users (Request Body)
  {
    "name": "Charlie",
    "email": "charlie@example.com"
  }

  // POST /users (Response Body - 201 Created)
  {
    "id": 3,
    "name": "Charlie",
    "email": "charlie@example.com"
  }
  ```

**Visualisasi Diagram Alur/Struktur:**

- Tabel Metode HTTP vs. Operasi CRUD (`GET`=Read, `POST`=Create, `PUT`=Update Full, `PATCH`=Update Partial, `DELETE`=Delete).
- Diagram sederhana URL dengan path sebagai _resource_ (misalnya, `api.com/users/1/posts/2`).

**Terminologi Esensial:**

- **REST (Representational State Transfer):** Gaya arsitektur _software_ untuk sistem _hypermedia_ terdistribusi seperti WWW.
- **RESTful API:** Sebuah API yang dirancang dengan mengikuti prinsip-prinsip arsitektur REST.
- **Resource:** Entitas apa pun yang dapat diakses melalui API, diidentifikasi oleh URI.
- **URI (Uniform Resource Identifier):** String karakter yang mengidentifikasi _resource_ di web (termasuk URL).
- **HTTP Method (Verb):** Kata kerja yang menunjukkan tindakan yang akan dilakukan pada _resource_ (GET, POST, PUT, DELETE, PATCH).
- **Stateless:** Server tidak menyimpan informasi sesi klien antar permintaan.
- **Endpoint:** URL spesifik yang mengidentifikasi sebuah _resource_ atau koleksi _resource_ tertentu.
- **Request/Response Cycle:** Aliran komunikasi di mana klien mengirim permintaan dan server merespons.
- **Status Code (HTTP Status Code):** Kode numerik yang menunjukkan hasil permintaan HTTP (misalnya, 200 OK, 404 Not Found, 500 Internal Server Error).
- **Header (HTTP Header):** Bagian dari permintaan atau respons HTTP yang berisi metadata (misalnya, `Content-Type`, `Authorization`).
- **Request Body/Response Body:** Data yang dikirim dengan permintaan POST/PUT/PATCH, atau data yang diterima dalam respons.
- **JSON (JavaScript Object Notation):** Format data ringan yang umum digunakan untuk pertukaran data di web.

**Sumber Referensi Lengkap:**

- [What is REST? (Red Hat)](https://www.redhat.com/en/topics/api/what-is-rest)
- [REST API Tutorial](https://www.restapitutorial.com/)
- [HTTP Status Codes (MDN Web Docs)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)

**Tips dan Praktik Terbaik (untuk Memahami REST):**

- **Pikirkan sebagai Kata Benda vs. Kata Kerja:** URI harus berupa kata benda (merepresentasikan _resource_), sedangkan metode HTTP adalah kata kerja (merepresentasikan tindakan). Misal: `GET /users` (bukan `GET /getUsers`).
- **Pahami Kode Status:** Selalu perhatikan kode status HTTP dari respons API. Ini adalah indikator penting keberhasilan atau kegagalan permintaan.
- **Gunakan Alat Bantu:** Gunakan alat seperti Postman, Insomnia, atau bahkan _browser developer tools_ untuk menguji API secara manual dan memahami format permintaan/respons.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menggunakan `GET` untuk mengubah data di _server_.

  - **Penyebab:** `GET` hanya untuk mengambil data. Mengubah _state_ _server_ dengan `GET` dapat memiliki konsekuensi yang tidak terduga (misalnya, _browser_ dapat _cache_ atau melakukan permintaan ulang secara otomatis).
  - **Solusi:** Selalu gunakan `POST`, `PUT`, atau `DELETE` untuk operasi yang mengubah _state_ _server_.

- **Kesalahan:** Mengirim data dalam _query parameters_ untuk `POST` atau `PUT`.

  - **Penyebab:** Data untuk `POST` atau `PUT` seharusnya dikirim dalam _request body_ (misalnya, dalam format JSON). _Query parameters_ (bagian dari URL setelah `?`) dimaksudkan untuk _filtering_ atau _pagination_ pada `GET` permintaan.
  - **Solusi:** Kirim data yang diubah atau dibuat dalam _request body_ dengan `Content-Type` yang sesuai (umumnya `application/json`).

---

#### 5.2.2 Making Basic HTTP Requests (`http` package)

Sub-bagian ini akan memandu pembelajar dalam melakukan permintaan HTTP dasar menggunakan paket `http` di Flutter. Paket `http` adalah _package_ standar dan ringan yang direkomendasikan untuk tugas-tugas HTTP dasar.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar cara menambahkan paket `http` ke proyek Flutter mereka dan menggunakannya untuk membuat permintaan `GET`, `POST`, `PUT`, dan `DELETE`. Fokus akan diberikan pada pengiriman _headers_ dan _body_ permintaan, serta penanganan respons HTTP. Ini adalah implementasi praktis pertama dari konsep RESTful yang telah dipelajari, menjadi jembatan antara teori dan praktik integrasi API.

**Konsep Kunci & Filosofi Mendalam:**

- **HTTP Package as a Simple Client:** Paket `http` menyediakan fungsi-fungsi tingkat tinggi (seperti `http.get()`, `http.post()`) yang menyederhanakan proses membuat permintaan HTTP.

  - **Filosofi:** Menyediakan API yang bersih dan mudah digunakan untuk tugas-tugas jaringan umum tanpa banyak _boilerplate_ tambahan. Ideal untuk permintaan sederhana atau sebagai dasar pemahaman sebelum beralih ke klien yang lebih kompleks.

- **`Uri` Object:** Permintaan HTTP di Dart menggunakan objek `Uri` untuk URL, bukan string mentah.

  - **Filosofi:** Memastikan URL yang valid dan aman dengan menangani _encoding_ dan _parsing_ secara otomatis, mengurangi potensi _error_.

- **`Response` Object:** Setiap permintaan HTTP mengembalikan objek `Response` yang berisi _status code_, _headers_, dan _body_ respons.

  - **Filosofi:** Mengkapsulasi semua detail respons dari _server_ dalam satu objek yang terstruktur, memudahkan pengembang untuk memeriksa hasil permintaan.

**Sintaks Dasar / Contoh Implementasi Inti:**

Pertama, tambahkan dependensi `http` di `pubspec.yaml` Anda:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.1 # Periksa versi terbaru di pub.dev
```

Kemudian jalankan `flutter pub get`.

```dart
import 'dart:convert'; // Untuk jsonEncode dan jsonDecode
import 'package:http/http.dart' as http; // Alias as http

// Contoh Model Data (sesuai dengan API dummy)
class Post {
  final int id;
  final String title;
  final String body;
  final int userId;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  // Factory constructor untuk membuat Post dari JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }

  // Method untuk mengkonversi Post menjadi JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
    };
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, body: $body, userId: $userId)';
  }
}

// URL API Dummy (JSONPlaceholder)
const String baseUrl = 'https://jsonplaceholder.typicode.com';

// --- Fungsi untuk Melakukan Permintaan HTTP ---

// GET Request: Mengambil semua post
Future<List<Post>> fetchAllPosts() async {
  final uri = Uri.parse('$baseUrl/posts');
  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Jika server mengembalikan respons OK (status code 200),
      // parse JSON.
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      // Jika respons bukan 200 OK, lempar Exception.
      throw Exception('Gagal memuat posts. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error saat fetching posts: $e');
  }
}

// GET Request: Mengambil post berdasarkan ID
Future<Post> fetchPostById(int id) async {
  final uri = Uri.parse('$baseUrl/posts/$id');
  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Post.fromJson(json);
    } else {
      throw Exception('Gagal memuat post ID $id. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error saat fetching post ID $id: $e');
  }
}

// POST Request: Membuat post baru
Future<Post> createPost(String title, String body, int userId) async {
  final uri = Uri.parse('$baseUrl/posts');
  try {
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'body': body,
        'userId': userId,
      }),
    );

    if (response.statusCode == 201) { // 201 Created
      Map<String, dynamic> json = jsonDecode(response.body);
      return Post.fromJson(json);
    } else {
      throw Exception('Gagal membuat post. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error saat membuat post: $e');
  }
}

// PUT Request: Memperbarui post yang sudah ada
Future<Post> updatePost(int id, String title, String body, int userId) async {
  final uri = Uri.parse('$baseUrl/posts/$id');
  try {
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id, // ID biasanya juga dikirim di body untuk PUT
        'title': title,
        'body': body,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) { // 200 OK
      Map<String, dynamic> json = jsonDecode(response.body);
      return Post.fromJson(json);
    } else {
      throw Exception('Gagal memperbarui post ID $id. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error saat memperbarui post: $e');
  }
}

// DELETE Request: Menghapus post
Future<void> deletePost(int id) async {
  final uri = Uri.parse('$baseUrl/posts/$id');
  try {
    final response = await http.delete(uri);

    if (response.statusCode == 200) { // 200 OK (biasanya untuk DELETE)
      print('Post ID $id berhasil dihapus.');
    } else {
      throw Exception('Gagal menghapus post ID $id. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error saat menghapus post: $e');
  }
}


void main() async {
  print('--- Mengambil Semua Posts ---');
  try {
    List<Post> posts = await fetchAllPosts();
    posts.take(2).forEach((post) => print(post)); // Cetak 2 post pertama
    print('Total posts: ${posts.length}');
  } catch (e) {
    print(e);
  }

  print('\n--- Mengambil Post ID 1 ---');
  try {
    Post post = await fetchPostById(1);
    print(post);
  } catch (e) {
    print(e);
  }

  print('\n--- Membuat Post Baru ---');
  try {
    Post newPost = await createPost('Judul Post Baru', 'Isi dari post yang baru dibuat.', 1);
    print('Post baru dibuat: $newPost');
  } catch (e) {
    print(e);
  }

  print('\n--- Memperbarui Post ID 1 ---');
  try {
    // Diasumsikan post ID 1 sudah ada
    Post updatedPost = await updatePost(1, 'Judul Diperbarui', 'Isi yang sudah direvisi.', 1);
    print('Post ID 1 diperbarui: $updatedPost');
  } catch (e) {
    print(e);
  }

  print('\n--- Menghapus Post ID 1 (Contoh) ---');
  try {
    // Perhatikan: JSONPlaceholder API dummy sebenarnya tidak menghapus data.
    // Ini hanya akan mengembalikan status 200 OK sebagai simulasi.
    await deletePost(1);
  } catch (e) {
    print(e);
  }
}

// --- Contoh Integrasi dengan Flutter UI (Conceptual) ---
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchAllPosts(); // Panggil API saat inisialisasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Posts')),
      body: FutureBuilder<List<Post>>(
        future: futurePosts, // Assign Future kita ke FutureBuilder
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Post post = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Text('User: ${post.userId}'),
                    onTap: () {
                      // Implementasi navigasi ke detail post
                      print('Tapped on post: ${post.id}');
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Tidak ada posts ditemukan.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementasi navigasi ke form tambah post
          print('Tambah Post Baru');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`Post` Model Class:**

    - Mendefinisikan struktur data untuk objek `Post`.
    - `factory Post.fromJson(Map<String, dynamic> json)`: Ini adalah _factory constructor_ yang digunakan untuk mengubah `Map<String, dynamic>` (hasil `jsonDecode`) menjadi objek `Post`. Ini penting untuk **deserialisasi** JSON.
    - `Map<String, dynamic> toJson()`: Ini adalah _method_ untuk mengubah objek `Post` menjadi `Map<String, dynamic>`, yang kemudian dapat di-_encode_ menjadi JSON. Ini penting untuk **serialisasi** JSON.

2.  **`http.get(uri)`:**

    - Digunakan untuk permintaan `GET`. Tidak memerlukan `body`.
    - Responsnya adalah `http.Response` object.
    - `response.statusCode == 200`: Mengindikasikan permintaan sukses. Selalu periksa kode status.
    - `jsonDecode(response.body)`: Mengubah string JSON dari respons menjadi objek Dart (`Map` atau `List`).
    - `List<dynamic> jsonList.map((json) => Post.fromJson(json)).toList()`: Mengubah daftar JSON `Map` menjadi daftar objek `Post`.

3.  **`http.post(uri, headers: ..., body: ...)`:**

    - Digunakan untuk permintaan `POST` (membuat _resource_ baru).
    - `headers`: Objek `Map` untuk mengatur _request headers_. `Content-Type: application/json` sangat penting saat mengirim JSON.
    - `body`: Data yang akan dikirim, harus berupa `String`. `jsonEncode()` digunakan untuk mengkonversi `Map` Dart menjadi string JSON.
    - `response.statusCode == 201`: Kode status 201 (Created) adalah respons umum untuk `POST` yang sukses.

4.  **`http.put(uri, headers: ..., body: ...)`:**

    - Digunakan untuk permintaan `PUT` (memperbarui _resource_ secara keseluruhan).
    - Mirip dengan `POST`, membutuhkan `headers` dan `body`.
    - `response.statusCode == 200`: Kode status 200 (OK) adalah respons umum untuk `PUT` yang sukses.

5.  **`http.delete(uri)`:**

    - Digunakan untuk permintaan `DELETE`. Biasanya tidak memerlukan `body`.
    - `response.statusCode == 200`: Kode status 200 (OK) adalah respons umum untuk `DELETE` yang sukses.

6.  **`try-catch` Blocks:** Setiap fungsi API dibungkus dalam `try-catch` untuk menangani _error_ jaringan atau _server_ yang mungkin terjadi, seperti yang diajarkan di **5.1.3 Error Handling**.

7.  **`PostsScreen` (Flutter UI Integration):**

    - Menggunakan `FutureBuilder<List<Post>>` untuk menampilkan data dari `Future<List<Post>>` yang dihasilkan oleh `fetchAllPosts()`. Ini adalah cara yang sangat umum dan efisien untuk menampilkan data asinkron di Flutter.
    - `snapshot.connectionState`: Digunakan untuk menampilkan indikator _loading_ (`ConnectionState.waiting`) atau data (`ConnectionState.done`/`ConnectionState.active`).
    - `snapshot.hasError` dan `snapshot.error`: Digunakan untuk menampilkan pesan _error_ jika terjadi kegagalan.
    - `ListView.builder`: Untuk menampilkan daftar _posts_ secara efisien.

**Visualisasi Diagram Alur/Struktur:**

- Diagram sederhana siklus permintaan HTTP dengan `http` package:
  - `Uri.parse(url)` -\> `http.get/post/put/delete()` -\> `await` Response -\> `check statusCode` -\> `jsonDecode(response.body)` -\> Convert to Dart Object.

**Terminologi Esensial:**

- **`http` package:** Paket Dart/Flutter untuk melakukan permintaan HTTP.
- **`Uri.parse()`:** Fungsi untuk mengurai string URL menjadi objek `Uri`.
- **`http.Response`:** Objek yang berisi semua detail respons dari server (statusCode, headers, body).
- **`response.statusCode`:** Kode status HTTP (misalnya, 200 OK, 201 Created, 400 Bad Request, 404 Not Found, 500 Internal Server Error).
- **`response.body`:** Isi (payload) dari respons HTTP, biasanya berupa string JSON.
- **`headers`:** `Map<String, String>` yang berisi _HTTP headers_ untuk dikirim bersama permintaan (misalnya, `Content-Type`, `Authorization`).
- **`body` (request):** String data yang dikirim dalam _payload_ permintaan POST/PUT/PATCH.
- **`jsonDecode()`:** Fungsi dari `dart:convert` untuk mengubah string JSON menjadi objek Dart (Map atau List).
- **`jsonEncode()`:** Fungsi dari `dart:convert` untuk mengubah objek Dart (Map atau List) menjadi string JSON.
- **`FutureBuilder`:** Widget Flutter untuk membangun UI berdasarkan hasil dari `Future`.

**Sumber Referensi Lengkap:**

- [http package (pub.dev)](https://pub.dev/packages/http) - Dokumentasi resmi paket `http`.
- [Fetch data from the internet (Flutter documentation)](https://docs.flutter.dev/data-and-backend/networking/fetch-data) - Panduan resmi Flutter tentang fetching data.
- [JSONPlaceholder](https://jsonplaceholder.typicode.com/) - API dummy gratis untuk pengujian.

**Tips dan Praktik Terbaik:**

- **Selalu Tangani Error:** Jangan pernah berasumsi permintaan akan selalu berhasil. Gunakan `try-catch` dan periksa `response.statusCode`.
- **Model Data (POJO/POCO):** Selalu buat _model class_ Dart yang sesuai dengan struktur JSON dari API Anda. Ini meningkatkan keamanan tipe (type-safety) dan keterbacaan kode.
- **Gunakan `Uri`:** Selalu gunakan `Uri.parse()` atau `Uri.https()`/`Uri.http()` untuk membuat objek `Uri`, jangan hanya menggunakan string mentah di dalam `http.get()` dll., terutama jika ada _query parameters_ atau _path segments_ yang dinamis.
- **`Content-Type` Header:** Pastikan Anda mengatur `Content-Type` _header_ yang benar saat mengirim _body_ permintaan, terutama untuk `application/json`.
- **`FutureBuilder` untuk UI:** Manfaatkan `FutureBuilder` untuk secara elegan menampilkan _loading states_, data, dan _error_ di UI Anda saat menunggu hasil `Future`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** "FormatException: Unexpected character" atau "Invalid argument: The provided string is not valid JSON."

  - **Penyebab:** Upaya untuk mengurai respons yang bukan JSON, atau respons JSON yang tidak valid (misalnya, _server_ mengembalikan HTML _error_ page).
  - **Solusi:** Periksa `response.statusCode` terlebih dahulu. Jika bukan 200 OK, jangan mencoba mengurai `response.body` sebagai JSON. Pastikan juga _server_ Anda memang mengirim JSON yang valid.

- **Kesalahan:** `HttpException: Connection closed before full header was received`.

  - **Penyebab:** Masalah jaringan, _server_ tidak merespons, atau _server_ menutup koneksi terlalu cepat.
  - **Solusi:** Pastikan perangkat memiliki koneksi internet, API _endpoint_ sudah benar, dan _server_ sedang berjalan. Tangani dengan `try-catch` untuk `SocketException` atau `HttpException`.

- **Kesalahan:** Data tidak dikirim atau diterima dengan benar (misalnya, _server_ tidak menerima data POST).

  - **Penyebab:** `Content-Type` _header_ salah atau `body` permintaan tidak di-_encode_ dengan benar (`jsonEncode`).
  - **Solusi:** Pastikan `Content-Type: application/json` diatur dan `body` di-_encode_ dengan `jsonEncode(<String, dynamic>{...})`.

- **Kesalahan:** `Null safety` _error_ saat mengakses `snapshot.data`.

  - **Penyebab:** Mencoba mengakses `snapshot.data` tanpa memeriksa `snapshot.hasData` atau `snapshot.connectionState`.
  - **Solusi:** Selalu periksa `if (snapshot.hasData)` sebelum mengakses `snapshot.data!` di `FutureBuilder`.

---

#### 5.2.3 Handling JSON (Serialization/Deserialization)

Sub-bagian ini akan membahas secara mendalam bagaimana mengelola data JSON di Dart/Flutter, yang merupakan format pertukaran data paling umum dalam integrasi API. Ini akan mencakup parsing manual, penggunaan `dart:convert`, dan memperkenalkan pendekatan berbasis _code generation_ untuk kasus yang lebih kompleks.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami dua proses kunci: **Deserialization** (mengubah string JSON menjadi objek Dart) dan **Serialization** (mengubah objek Dart menjadi string JSON). Mereka akan belajar cara melakukan ini secara manual untuk struktur JSON sederhana dan kapan harus mempertimbangkan _code generation_ untuk struktur yang lebih kompleks. Kemampuan ini adalah inti dari setiap interaksi dengan RESTful API yang menghasilkan atau menerima data JSON.

**Konsep Kunci & Filosofi Mendalam:**

- **JSON sebagai Universal Data Format:** JSON (JavaScript Object Notation) adalah format ringan, mudah dibaca manusia, dan mudah diurai oleh mesin, menjadikannya pilihan universal untuk pertukaran data di web.

  - **Filosofi:** Menyediakan representasi data yang standar dan dapat dioperasikan secara lintas platform dan bahasa pemrograman.

- **Serialization (Dart Object -\> JSON String):** Proses mengonversi instance kelas Dart menjadi string JSON yang dapat dikirim melalui jaringan atau disimpan.

  - **Filosofi:** Memastikan bahwa data yang diorganisir dalam logika aplikasi dapat dengan mudah dikemas untuk komunikasi eksternal.

- **Deserialization (JSON String -\> Dart Object):** Proses mengonversi string JSON yang diterima dari jaringan atau penyimpanan menjadi instance kelas Dart.

  - **Filosofi:** Mengubah data mentah dari dunia luar menjadi objek yang terstruktur dan aman tipe yang dapat langsung digunakan dalam logika aplikasi.

- **Dynamic vs. Static Typing:**

  - **Manual Parsing (`dart:convert`):** Mengembalikan `Map<String, dynamic>` atau `List<dynamic>`. Membutuhkan _type casting_ manual yang berpotensi menyebabkan `RuntimeError` jika struktur JSON tidak sesuai ekspektasi.
  - **Model Class (POJO/POCO):** Membuat kelas Dart yang merepresentasikan struktur JSON, memberikan _type safety_ saat deserialisasi/serialisasi.
  - **Code Generation (`json_serializable`):** Mengotomatiskan pembuatan kode `fromJson` dan `toJson` berdasarkan anotasi, mengurangi _boilerplate_ dan _error_ manusiawi untuk model data yang kompleks.
  - **Filosofi:** Menyeimbangkan kecepatan pengembangan untuk kasus sederhana dengan keamanan tipe dan skalabilitas untuk kasus yang lebih kompleks.

**Sintaks Dasar / Contoh Implementasi Inti:**

Kita akan menggunakan kembali `Post` model dari bagian 5.2.2, lalu menunjukkan dua pendekatan:

1.  **Manual JSON Parsing (`dart:convert`)** - Sudah sedikit diperkenalkan, kita akan elaborasi.
2.  **Automated JSON Parsing (`json_serializable`)** - Pendekatan yang direkomendasikan untuk proyek skala besar.

---

**Pendekatan 1: Manual JSON Parsing (`dart:convert`)**

Ini cocok untuk struktur JSON sederhana atau ketika Anda hanya perlu membaca beberapa nilai.

```dart
import 'dart:convert'; // Import untuk jsonEncode dan jsonDecode

// Contoh JSON String yang akan di-deserialize
const String jsonStringSingle = '''
{
  "id": 1,
  "title": "Dart is awesome",
  "author": "Alice"
}
''';

const String jsonStringList = '''
[
  {
    "id": 1,
    "title": "Flutter Basics",
    "author": "Alice"
  },
  {
    "id": 2,
    "title": "State Management with Provider",
    "author": "Bob"
  }
]
''';

// --- Model Dart (POJO/POCO) ---
// Model ini akan digunakan untuk representasi data JSON
class Article {
  final int id;
  final String title;
  final String author;
  final int? views; // Properti opsional, bisa null

  Article({
    required this.id,
    required this.title,
    required this.author,
    this.views, // Tidak required
  });

  // Factory Constructor untuk Deserialization (JSON String -> Article object)
  // Menerima Map<String, dynamic> dari jsonDecode
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int, // Casting eksplisit disarankan
      title: json['title'] as String,
      author: json['author'] as String,
      // Menggunakan operator null-aware ?? untuk default value atau casting yang aman
      views: json['views'] as int?, // Jika 'views' tidak ada atau null, maka views akan null
    );
  }

  // Method untuk Serialization (Article object -> Map<String, dynamic>)
  // Map ini akan di-jsonEncode untuk menjadi JSON String
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'author': author,
    };
    if (views != null) { // Hanya tambahkan jika views tidak null
      data['views'] = views;
    }
    return data;
  }

  @override
  String toString() {
    return 'Article(id: $id, title: "$title", author: "$author", views: $views)';
  }
}


void main() {
  print('--- Manual JSON Deserialization ---');
  // Deserialisasi satu objek
  Map<String, dynamic> articleMap = jsonDecode(jsonStringSingle);
  Article article1 = Article.fromJson(articleMap);
  print('Deserialized Article 1: $article1');

  // Deserialisasi daftar objek
  List<dynamic> jsonListMap = jsonDecode(jsonStringList);
  List<Article> articles = jsonListMap
      .map((item) => Article.fromJson(item as Map<String, dynamic>))
      .toList();
  print('Deserialized Articles List:');
  articles.forEach(print);

  print('\n--- Manual JSON Serialization ---');
  // Serialisasi satu objek
  Article newArticle = Article(id: 3, title: 'Flutter Widgets', author: 'Charlie', views: 1500);
  Map<String, dynamic> newArticleMap = newArticle.toJson();
  String newArticleJson = jsonEncode(newArticleMap);
  print('Serialized New Article: $newArticleJson');

  // Serialisasi daftar objek
  List<Article> articlesToSave = [
    Article(id: 4, title: 'Dart Fundamentals', author: 'David'),
    Article(id: 5, title: 'API Integration Best Practices', author: 'Eve', views: 800),
  ];
  List<Map<String, dynamic>> articlesMapList = articlesToSave.map((a) => a.toJson()).toList();
  String articlesListJson = jsonEncode(articlesMapList);
  print('Serialized Articles List: $articlesListJson');
}
```

---

**Pendekatan 2: Automated JSON Parsing (`json_serializable`)**

Untuk proyek yang lebih besar dengan banyak model data dan struktur JSON yang kompleks, menulis `fromJson` dan `toJson` secara manual bisa menjadi membosankan dan rawan kesalahan. `json_serializable` adalah paket populer yang menggunakan _code generation_ untuk mengotomatiskan proses ini.

**Langkah-langkah Penggunaan `json_serializable`:**

1.  **Tambahkan Dependensi di `pubspec.yaml`:**

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      json_annotation: ^4.8.1 # Periksa versi terbaru

    dev_dependencies:
      flutter_test:
        sdk: flutter
      build_runner: ^2.4.6 # Periksa versi terbaru
      json_serializable: ^6.7.1 # Periksa versi terbaru
    ```

    - `json_annotation`: Berisi anotasi yang Anda gunakan untuk menandai kelas model Anda.
    - `build_runner`: Alat yang menjalankan _code generators_.
    - `json_serializable`: Generator kode yang sebenarnya.

2.  **Buat Model Data Anda (dengan Anotasi):**
    Buat file Dart baru, misalnya `lib/models/user.dart`.

    ```dart
    // lib/models/user.dart
    import 'package:json_annotation/json_annotation.dart';

    // Perhatikan bagian ini:
    // Mengharuskan "user.g.dart" yang akan dihasilkan secara otomatis
    part 'user.g.dart';

    @JsonSerializable() // Anotasi ini memberitahu json_serializable untuk membuat kode
    class User {
      final int id;
      final String name;
      final String email;

      @JsonKey(name: 'phone_number') // Untuk mapping nama field JSON yang berbeda
      final String? phoneNumber;

      // Konstruktor standar
      User({required this.id, required this.name, required this.email, this.phoneNumber});

      // Factory constructor yang diperlukan untuk deserialization
      // Ini akan menunjuk ke fungsi yang dihasilkan secara otomatis
      factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

      // Method yang diperlukan untuk serialization
      // Ini akan menunjuk ke fungsi yang dihasilkan secara otomatis
      Map<String, dynamic> toJson() => _$UserToJson(this);

      @override
      String toString() {
        return 'User(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber)';
      }
    }
    ```

3.  **Jalankan Code Generator:**

    Buka terminal di root proyek Flutter Anda dan jalankan:

    ```bash
    flutter pub get
    flutter pub run build_runner build
    ```

    Atau untuk mode _watch_ (akan otomatis menghasilkan kode setiap kali Anda menyimpan perubahan pada file model):

    ```bash
    flutter pub run build_runner watch
    ```

    Setelah perintah ini selesai, sebuah file baru bernama `user.g.dart` akan dibuat di folder yang sama dengan `user.dart`. File ini berisi implementasi `_$UserFromJson` dan `_$UserToJson`.

4.  **Gunakan Model Anda:**

    ```dart
    import 'dart:convert';
    import 'package:your_app_name/models/user.dart'; // Sesuaikan path

    void main() {
      print('\n--- Automated JSON Deserialization (json_serializable) ---');
      const String userJsonString = '''
      {
        "id": 101,
        "name": "Sarah Connor",
        "email": "sarah.c@example.com",
        "phone_number": "123-456-7890"
      }
      ''';

      Map<String, dynamic> userMap = jsonDecode(userJsonString);
      User user = User.fromJson(userMap); // Menggunakan fungsi yang dihasilkan
      print('Deserialized User: $user');

      print('\n--- Automated JSON Serialization (json_serializable) ---');
      User newUser = User(id: 102, name: 'John Doe', email: 'john.doe@example.com');
      Map<String, dynamic> newUserMap = newUser.toJson(); // Menggunakan fungsi yang dihasilkan
      String newUserJson = jsonEncode(newUserMap);
      print('Serialized New User: $newUserJson');
    }
    ```

**Penjelasan Konteks Kode:**

- **`dart:convert`:**

  - `jsonDecode(jsonString)`: Mengambil string JSON dan mengonversinya menjadi objek Dart (`Map<String, dynamic>` atau `List<dynamic>`). Ini adalah langkah pertama dalam deserialisasi.
  - `jsonEncode(dartObject)`: Mengambil objek Dart (`Map<String, dynamic>` atau `List<dynamic>`) dan mengonversinya menjadi string JSON. Ini adalah langkah terakhir dalam serialisasi.

- **`Article` Model (Manual):**

  - `factory Article.fromJson(Map<String, dynamic> json)`: Ini adalah _factory constructor_ yang menerima `Map` dari `jsonDecode` dan secara manual memetakan nilai-nilai dari _map_ ke properti objek `Article`. Perhatikan penggunaan _casting_ eksplisit (`as int`, `as String`, `as int?`) untuk keamanan tipe.
  - `Map<String, dynamic> toJson()`: Ini adalah _method_ yang mengonversi objek `Article` kembali ke `Map` yang dapat di-_encode_ menjadi JSON.

- **`User` Model (`json_serializable`):**

  - `part 'user.g.dart';`: Ini adalah deklarasi penting yang memberitahu Dart bahwa sebagian kode untuk kelas `User` akan berada di file `user.g.dart` yang dihasilkan otomatis.
  - `@JsonSerializable()`: Anotasi ini dari `json_annotation` memberi tahu `json_serializable` _package_ untuk menghasilkan kode serialisasi/deserialisasi untuk kelas ini.
  - `@JsonKey(name: 'phone_number')`: Digunakan ketika nama kunci di JSON berbeda dari nama properti di kelas Dart.
  - `factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);` dan `Map<String, dynamic> toJson() => _$UserToJson(this);`: Ini adalah _boilerplate_ yang harus Anda tulis. `_$UserFromJson` dan `_$UserToJson` adalah fungsi yang akan dihasilkan oleh `json_serializable` di file `user.g.dart`.

**Visualisasi Diagram Alur/Struktur:**

- **Deserialization:** JSON String -\> `jsonDecode` -\> `Map<String, dynamic>` (or `List<dynamic>`) -\> `Model.fromJson(map)` -\> Dart Object.
- **Serialization:** Dart Object -\> `model.toJson()` -\> `Map<String, dynamic>` -\> `jsonEncode` -\> JSON String.
- Untuk `json_serializable`: Kelas Dart dengan Anotasi -\> `build_runner` -\> File `.g.dart` (dengan fungsi `_$...FromJson`, `_$...ToJson`).

**Terminologi Esensial:**

- **JSON (JavaScript Object Notation):** Format data standar.
- **Serialization:** Proses mengonversi objek ke format yang dapat ditransmisikan atau disimpan (misalnya, Dart Object ke JSON String).
- **Deserialization:** Proses mengonversi format yang disimpan atau ditransmisikan kembali ke objek (misalnya, JSON String ke Dart Object).
- **`dart:convert`:** Library bawaan Dart untuk _encoding_ dan _decoding_ JSON.
- **`jsonDecode()`:** Fungsi untuk deserialisasi JSON.
- **`jsonEncode()`:** Fungsi untuk serialisasi JSON.
- **Model Class (POJO/POCO):** Kelas Dart yang dirancang untuk merepresentasikan struktur data dari API.
- **`factory` constructor:** Jenis konstruktor yang tidak selalu membuat instance baru dari kelasnya. Sering digunakan untuk deserialisasi.
- **`json_serializable`:** Paket Dart untuk menghasilkan kode serialisasi/deserialisasi JSON secara otomatis.
- **`json_annotation`:** Paket yang menyediakan anotasi untuk `json_serializable`.
- **`build_runner`:** Alat yang menjalankan _code generators_ di proyek Dart/Flutter.
- **`part` directive:** Sintaks Dart yang memungkinkan satu file untuk memasukkan sebagian kode dari file lain, sering digunakan dengan _code generation_.

**Sumber Referensi Lengkap:**

- [JSON and serialization (Flutter documentation)](https://docs.flutter.dev/data-and-backend/json) - Panduan resmi Flutter tentang JSON.
- [json_serializable (pub.dev)](https://pub.dev/packages/json_serializable) - Halaman resmi paket `json_serializable`.
- [Effective Dart: Usage - DO use `json_serializable`](<%5Bhttps://dart.dev/guides/language/effective-dart/usage%23do-use-json_serializable%5D(https://dart.dev/guides/language/effective-dart/usage%23do-use-json_serializable)>)
- [The `dart:convert` library](<%5Bhttps://dart.dev/guides/libraries/library-tour%23dartconvert---decoding-and-encoding-json-utf-8-etc%5D(https://dart.dev/guides/libraries/library-tour%23dartconvert---decoding-and-encoding-json-utf-8-etc)>)

**Tips dan Praktik Terbaik:**

- **Pilih Pendekatan yang Tepat:**
  - **Manual Parsing:** Untuk respons API yang sangat sederhana (misalnya, hanya mengembalikan string atau angka), atau ketika Anda hanya perlu mengakses satu atau dua nilai dari JSON tanpa membuat _full model_.
  - **Model Classes (`fromJson`/`toJson` manual):** Untuk respons yang lebih kompleks namun masih bisa dikelola, dan ketika Anda ingin kontrol penuh atas logika parsing. Baik untuk mempelajari dasar-dasarnya.
  - **`json_serializable`:** Sangat direkomendasikan untuk proyek skala menengah hingga besar dengan banyak model data, model bersarang, atau ketika struktur JSON cenderung berubah. Ini mengurangi _boilerplate_, mencegah _error_ manusiawi, dan meningkatkan _maintainability_.
- **Error Handling saat Parsing:** Selalu bungkus operasi `jsonDecode` dan `fromJson` di blok `try-catch` karena format JSON bisa saja tidak valid atau tidak sesuai dengan model Anda (misalnya, _field_ hilang atau tipe data salah).
- **Gunakan Tipe Data yang Aman Null (`?`):** Jika sebuah _field_ JSON mungkin tidak ada atau bernilai `null`, deklarasikan properti di model Anda sebagai _nullable_ (misalnya, `String? phoneNumber`).
- **Pahami Struktur JSON Anda:** Sebelum menulis kode, selalu periksa respons JSON dari API menggunakan alat seperti Postman atau _browser developer tools_ untuk memahami strukturnya dengan baik.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `_CastError` atau `type 'String' is not a subtype of type 'int'` saat deserialisasi.

  - **Penyebab:** Upaya untuk mengakses nilai JSON dengan tipe data yang salah atau lupa melakukan _casting_ yang benar.
  - **Solusi:** Periksa kembali struktur JSON dan pastikan _factory constructor_ `fromJson` Anda menggunakan _casting_ yang benar (misalnya, `json['id'] as int`) dan menangani nilai `null` dengan tepat (`as String?`).

- **Kesalahan:** `MissingPluginException` atau masalah _build_runner_ saat menggunakan `json_serializable`.

  - **Penyebab:** Lupa menjalankan `flutter pub get` setelah menambahkan dependensi, atau lupa menjalankan `flutter pub run build_runner build/watch`.
  - **Solusi:** Pastikan semua dependensi terinstal dan `build_runner` dijalankan dengan benar. Periksa output konsol untuk _error_ dari `build_runner`.

- **Kesalahan:** File `.g.dart` tidak terbuat atau tidak terbarui.

  - **Penyebab:** Lupa menyertakan `part 'your_model.g.dart';` di bagian atas file model Anda, atau ada _error_ sintaksis di file model yang mencegah _code generator_ berjalan.
  - **Solusi:** Periksa `part` directive. Pastikan tidak ada _error_ di file model Anda. Jalankan `flutter pub run build_runner build --delete-conflicting-outputs` untuk membersihkan _output_ yang bermasalah.

---

### 5.3 Advanced API Integration

Sub-bagian ini akan membawa pemahaman integrasi API ke tingkat selanjutnya, memperkenalkan alat dan teknik yang lebih canggih untuk mengelola permintaan jaringan yang kompleks, penanganan _error_ yang lebih terpusat, dan strategi otentikasi.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan diperkenalkan dengan paket `dio`, sebuah klien HTTP yang lebih kaya fitur dibandingkan `http` standar, yang menawarkan kemampuan seperti _interceptors_, _caching_, dan penanganan _error_ yang lebih baik. Mereka juga akan mempelajari bagaimana mengimplementasikan otentikasi berbasis token, sebuah praktik standar dalam aplikasi modern. Keterampilan ini penting untuk membangun aplikasi yang kuat, aman, dan mudah di-_maintain_ saat berinteraksi dengan API di dunia nyata.

**Konsep Kunci & Filosofi Mendalam (Umum untuk Bagian Ini):**

- **Robustness & Maintainability:** Menggunakan _client_ HTTP yang lebih canggih dan pola desain yang baik untuk _error handling_ dan otentikasi bertujuan untuk membuat kode jaringan lebih tangguh terhadap kegagalan dan lebih mudah untuk dikembangkan serta diperbaiki.

  - **Filosofi:** Membangun fondasi yang kuat untuk komunikasi jaringan yang berkelanjutan dan kompleks, mengurangi _boilerplate_ dan meningkatkan kualitas kode.

- **Separation of Concerns:** Memisahkan logika otentikasi dan penanganan _error_ dari permintaan API inti.

  - **Filosofi:** Mempromosikan kode yang lebih modular dan mudah diuji, di mana setiap bagian memiliki tanggung jawab yang jelas.

- **Security Best Practices:** Memahami cara yang benar untuk mengirimkan kredensial dan mengelola token otentikasi.

  - **Filosofi:** Mengamankan komunikasi _client-server_ untuk melindungi data pengguna dan integritas sistem.

**Visualisasi Diagram Alur/Struktur:**

- Diagram `Dio`: Permintaan -\> Interceptor (Request) -\> HTTP Request -\> Server Response -\> Interceptor (Response) -\> Client.
- Alur Otentikasi Token: Login Request -\> Token Response -\> Token Storage -\> Subsequent Requests (with Token Header).

**Hubungan dengan Modul Lain:**
Ini adalah kelanjutan logis dari `5.2 HTTP Requests & REST APIs`. Pemahaman `5.1 Asynchronous Programming` dan `5.1.3 Error Handling` adalah prasyarat. Penanganan _state_ aplikasi (misalnya, _user authentication state_) yang diperoleh dari sini akan menjadi input penting untuk `Fase 6: State Management`.

---

#### 5.3.1 Dio (Advanced HTTP Client)

Sub-bagian ini akan memperkenalkan paket `dio`, sebuah _HTTP client_ yang kuat dan populer di Flutter, yang menawarkan lebih banyak fitur dan fleksibilitas dibandingkan paket `http` standar.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar mengapa dan kapan harus menggunakan `dio` sebagai pengganti `http`. Mereka akan mengimplementasikan permintaan `GET`, `POST`, `PUT`, dan `DELETE` menggunakan `dio`, serta memanfaatkan fitur-fitur dasar seperti _base URL_, _query parameters_, dan _request options_. Ini akan menjadi alat utama mereka untuk komunikasi jaringan di proyek-proyek yang lebih besar.

**Konsep Kunci & Filosofi Mendalam:**

- **Feature-Rich Client:** `Dio` menyediakan fitur yang tidak ada di `http` standar, seperti:

  - **Interceptors:** Untuk mencegat dan memodifikasi permintaan/respons (misalnya, menambahkan _header_, _logging_, _refresh token_).
  - **Global Configuration:** Mengatur _base URL_, _headers_, _timeout_ di satu tempat untuk semua permintaan.
  - **Form Data Support:** Penanganan yang lebih mudah untuk _multipart/form-data_ (untuk _upload file_).
  - **Request Cancellation:** Kemampuan untuk membatalkan permintaan yang sedang berjalan.
  - **Download/Upload Progress:** Callback untuk melacak progres.
  - **Custom Adapters:** Fleksibilitas untuk mengintegrasikan _http client_ lainnya.
  - **Filosofi:** Menyederhanakan tugas-tugas jaringan yang kompleks dan mengurangi _boilerplate_, memungkinkan pengembang fokus pada logika bisnis daripada detail implementasi HTTP.

- **Singleton/Dependency Injection:** Seringkali `Dio` diinisialisasi sebagai _singleton_ atau dikelola melalui _dependency injection_ untuk memastikan konfigurasi yang konsisten dan pengelolaan sumber daya yang efisien.

  - **Filosofi:** Mendorong praktik arsitektur yang baik, seperti _loose coupling_ dan kemudahan pengujian.

**Sintaks Dasar / Contoh Implementasi Inti:**

Pertama, tambahkan dependensi `dio` di `pubspec.yaml` Anda:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.3 # Periksa versi terbaru di pub.dev
  json_annotation: ^4.8.1 # Tetap pakai jika Anda menggunakan json_serializable

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
```

Kemudian jalankan `flutter pub get`.

```dart
import 'package:dio/dio.dart'; // Import dio
import 'dart:convert'; // Untuk jsonEncode (jika masih diperlukan)

// Re-use the Post model from 5.2.2 or adapt with json_serializable if desired
// Assuming Post model is defined as in 5.2.2 or with json_serializable
class Post {
  final int id;
  final String title;
  final String body;
  final int userId;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
    };
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, body: $body, userId: $userId)';
  }
}

// --- Inisialisasi Dio Client (Global/Singleton) ---
final Dio dio = Dio(BaseOptions(
  baseUrl: 'https://jsonplaceholder.typicode.com',
  connectTimeout: const Duration(seconds: 5), // 5 detik
  receiveTimeout: const Duration(seconds: 3), // 3 detik
  headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json', // Opsional: Beritahu server format yang diharapkan
  },
));

// --- Fungsi untuk Melakukan Permintaan HTTP dengan Dio ---

// GET Request: Mengambil semua post
Future<List<Post>> fetchAllPostsDio() async {
  try {
    final response = await dio.get('/posts'); // Path relatif
    if (response.statusCode == 200) {
      List<dynamic> jsonList = response.data; // Dio otomatis mengurai JSON ke Map/List
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat posts. Status Code: ${response.statusCode}');
    }
  } on DioException catch (e) { // Menangkap DioException
    if (e.response != null) {
      print('Dio error (Response): Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
      throw Exception('Server error: ${e.response?.statusCode}');
    } else {
      print('Dio error (Request): ${e.message}');
      throw Exception('Jaringan error: ${e.message}');
    }
  } catch (e) {
    throw Exception('Error saat fetching posts: $e');
  }
}

// GET Request: Mengambil post berdasarkan ID
Future<Post> fetchPostByIdDio(int id) async {
  try {
    final response = await dio.get('/posts/$id');
    if (response.statusCode == 200) {
      Map<String, dynamic> json = response.data;
      return Post.fromJson(json);
    } else {
      throw Exception('Gagal memuat post ID $id. Status Code: ${response.statusCode}');
    }
  } on DioException catch (e) {
     if (e.response != null) {
      print('Dio error (Response): Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
      throw Exception('Server error: ${e.response?.statusCode}');
    } else {
      print('Dio error (Request): ${e.message}');
      throw Exception('Jaringan error: ${e.message}');
    }
  } catch (e) {
    throw Exception('Error saat fetching post ID $id: $e');
  }
}

// POST Request: Membuat post baru
Future<Post> createPostDio(String title, String body, int userId) async {
  try {
    final response = await dio.post(
      '/posts',
      data: { // Dio menerima Map langsung, tidak perlu jsonEncode
        'title': title,
        'body': body,
        'userId': userId,
      },
      // Headers sudah diset di BaseOptions, tapi bisa di-override di sini jika perlu
      // options: Options(headers: {'Authorization': 'Bearer YOUR_TOKEN'}),
    );

    if (response.statusCode == 201) { // 201 Created
      Map<String, dynamic> json = response.data;
      return Post.fromJson(json);
    } else {
      throw Exception('Gagal membuat post. Status Code: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print('Dio error (Response): Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
      throw Exception('Server error: ${e.response?.statusCode}');
    } else {
      print('Dio error (Request): ${e.message}');
      throw Exception('Jaringan error: ${e.message}');
    }
  } catch (e) {
    throw Exception('Error saat membuat post: $e');
  }
}

// PUT Request: Memperbarui post yang sudah ada
Future<Post> updatePostDio(int id, String title, String body, int userId) async {
  try {
    final response = await dio.put(
      '/posts/$id',
      data: {
        'id': id,
        'title': title,
        'body': body,
        'userId': userId,
      },
    );

    if (response.statusCode == 200) { // 200 OK
      Map<String, dynamic> json = response.data;
      return Post.fromJson(json);
    } else {
      throw Exception('Gagal memperbarui post ID $id. Status Code: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print('Dio error (Response): Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
      throw Exception('Server error: ${e.response?.statusCode}');
    } else {
      print('Dio error (Request): ${e.message}');
      throw Exception('Jaringan error: ${e.message}');
    }
  } catch (e) {
    throw Exception('Error saat memperbarui post: $e');
  }
}

// DELETE Request: Menghapus post
Future<void> deletePostDio(int id) async {
  try {
    final response = await dio.delete('/posts/$id');
    if (response.statusCode == 200) { // 200 OK
      print('Post ID $id berhasil dihapus.');
    } else {
      throw Exception('Gagal menghapus post ID $id. Status Code: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print('Dio error (Response): Status: ${e.response?.statusCode}, Data: ${e.response?.data}');
      throw Exception('Server error: ${e.response?.statusCode}');
    } else {
      print('Dio error (Request): ${e.message}');
      throw Exception('Jaringan error: ${e.message}');
    }
  } catch (e) {
    throw Exception('Error saat menghapus post: $e');
  }
}

void main() async {
  print('--- Mengambil Semua Posts dengan Dio ---');
  try {
    List<Post> posts = await fetchAllPostsDio();
    posts.take(2).forEach((post) => print(post));
    print('Total posts: ${posts.length}');
  } catch (e) {
    print(e);
  }

  print('\n--- Membuat Post Baru dengan Dio ---');
  try {
    Post newPost = await createPostDio('Judul Dio Baru', 'Isi dari post Dio yang baru.', 10);
    print('Post baru dibuat dengan Dio: $newPost');
  } catch (e) {
    print(e);
  }

  print('\n--- Mengambil Post ID 1 dengan Dio ---');
  try {
    Post post = await fetchPostByIdDio(1);
    print(post);
  } catch (e) {
    print(e);
  }

  print('\n--- Memperbarui Post ID 1 dengan Dio ---');
  try {
    Post updatedPost = await updatePostDio(1, 'Judul Dio Diperbarui', 'Isi yang sudah direvisi Dio.', 1);
    print('Post ID 1 diperbarui dengan Dio: $updatedPost');
  } catch (e) {
    print(e);
  }

  print('\n--- Menghapus Post ID 1 dengan Dio (Contoh) ---');
  try {
    await deletePostDio(1);
  } catch (e) {
    print(e);
  }
}
```

**Penjelasan Konteks Kode:**

1.  **Inisialisasi `Dio`:**

    - `final Dio dio = Dio(BaseOptions(...));`: Ini adalah cara untuk menginisialisasi instance `Dio`. `BaseOptions` memungkinkan Anda untuk mengatur konfigurasi global seperti `baseUrl`, `connectTimeout`, `receiveTimeout`, dan `headers`. Ini sangat berguna karena Anda tidak perlu mengulang pengaturan ini untuk setiap permintaan.
    - `baseUrl`: Path dasar untuk semua permintaan Anda. Ini memungkinkan Anda hanya menyediakan path relatif (`/posts`, `/posts/$id`) di setiap panggilan.
    - `connectTimeout`: Waktu maksimum untuk membangun koneksi ke server.
    - `receiveTimeout`: Waktu maksimum untuk menerima data dari server setelah koneksi berhasil.
    - `headers`: _Headers_ yang akan dikirim dengan setiap permintaan secara default.

2.  **`dio.get()`, `dio.post()`, `dio.put()`, `dio.delete()`:**

    - Metode-metode ini mirip dengan paket `http` tetapi langsung disediakan oleh instance `Dio`.
    - **`response.data`:** Ini adalah perbedaan besar dari `http`. `Dio` secara otomatis mencoba mengurai _body_ respons JSON menjadi objek Dart (`Map` atau `List`). Anda tidak perlu lagi memanggil `jsonDecode()` secara manual.
    - **`data` parameter (untuk POST/PUT):** `Dio` menerima `Map<String, dynamic>` atau objek Dart lainnya langsung sebagai `data` untuk _body_ permintaan. Anda tidak perlu memanggil `jsonEncode()` secara manual karena `Dio` akan menanganinya.

3.  **`DioException`:**

    - `Dio` memiliki sistem penanganan _error_ sendiri melalui `DioException` (sebelumnya `DioError`).
    - Anda dapat menangkap `DioException` dan memeriksa properti seperti `e.response` (untuk _error_ dari _server_ seperti 404, 500) atau `e.type` (untuk _error_ jaringan, _timeout_). Ini memungkinkan penanganan _error_ yang lebih granular.

**Visualisasi Diagram Alur/Struktur:**

- Diagram mirip dengan `http` package, namun dengan `Dio` instance di tengah yang mengelola konfigurasi dasar.
- Penekanan pada `response.data` sebagai JSON yang sudah di-_parse_ dan `data` parameter untuk _body_ yang tidak perlu di-_encode_ manual.
- Diagram `DioException` cabang untuk respons dan _error_ jaringan.

**Terminologi Esensial:**

- **Dio:** Klien HTTP pihak ketiga yang kuat untuk Dart/Flutter.
- **`Dio` instance:** Objek utama untuk melakukan permintaan HTTP dengan konfigurasi spesifik.
- **`BaseOptions`:** Objek untuk mengkonfigurasi pengaturan default untuk `Dio` instance (baseUrl, timeout, headers).
- **`response.data`:** Properti pada objek `Response` dari Dio yang berisi _body_ respons yang sudah diurai (biasanya `Map` atau `List`).
- **`data` parameter (di `post`, `put`):** Argumen untuk menyediakan _body_ permintaan. Dio akan otomatis menserialisasi Map ini ke JSON.
- **`DioException`:** Tipe _exception_ khusus yang dilempar oleh Dio ketika terjadi _error_ dalam permintaan HTTP.
- **`DioExceptionType`:** Enum dalam `DioException` yang menjelaskan jenis _error_ (misalnya, `connectTimeout`, `receiveTimeout`, `badResponse`, `cancel`).

**Sumber Referensi Lengkap:**

- [Dio (pub.dev)](https://pub.dev/packages/dio) - Dokumentasi resmi paket Dio.
- [Dio Wiki (GitHub)](https://github.com/cfug/dio/wiki) - Wiki Dio untuk panduan dan contoh yang lebih mendalam.

**Tips dan Praktik Terbaik:**

- **Inisialisasi sebagai Singleton:** Buat satu instance `Dio` global atau melalui _dependency injection_ untuk seluruh aplikasi Anda. Ini memastikan konsistensi konfigurasi dan efisiensi sumber daya.
- **Gunakan `BaseOptions`:** Manfaatkan `BaseOptions` untuk mengatur konfigurasi umum seperti `baseUrl` dan `headers` agar kode lebih rapi dan mudah di-_maintain_.
- **Tangani `DioException`:** Selalu tangani `DioException` secara spesifik, memeriksa `e.response` untuk _error_ dari _server_ dan `e.type` untuk _error_ jaringan/timeout.
- **Integrasi dengan `json_serializable`:** `Dio` bekerja sangat baik dengan model yang dihasilkan oleh `json_serializable` karena keduanya beroperasi dengan `Map<String, dynamic>`. Anda hanya perlu memanggil `MyModel.fromJson(response.data)` dan `myModel.toJson()`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `DioException` tidak tertangkap.

  - **Penyebab:** Hanya menggunakan `catch (e)` tanpa spesifik `on DioException catch (e)`. Atau, _error_ terjadi di luar cakupan `try-catch`.
  - **Solusi:** Selalu tambahkan `on DioException catch (e)` untuk penanganan _error_ khusus Dio. Pastikan _async_ function Anda di-_await_ di dalam `try-catch`.

- **Kesalahan:** Data POST/PUT tidak diterima oleh _server_.

  - **Penyebab:** Lupa mengatur `Content-Type` _header_ di `BaseOptions` atau di `Options` spesifik untuk permintaan tersebut. Meskipun Dio otomatis meng-_encode_ `Map` menjadi JSON, _server_ tetap perlu tahu _Content-Type_ dari _body_ yang diterima.
  - **Solusi:** Pastikan `headers: {'Content-Type': 'application/json'}` sudah diatur dengan benar.

- **Kesalahan:** `Timeout` terjadi terlalu cepat/lambat.

  - **Penyebab:** `connectTimeout` atau `receiveTimeout` diatur tidak sesuai dengan kebutuhan _server_ atau koneksi jaringan yang diharapkan.
  - **Solusi:** Sesuaikan nilai `connectTimeout` dan `receiveTimeout` berdasarkan pengalaman dan persyaratan API.

---

#### 5.3.2 Error Handling & Interceptors

Sub-bagian ini akan memperdalam strategi penanganan _error_ dalam konteks integrasi API tingkat lanjut, khususnya dengan memanfaatkan fitur `Interceptors` yang disediakan oleh `Dio`. Ini adalah kunci untuk membangun lapisan jaringan yang kokoh dan mudah di-_maintain_.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bagaimana menggunakan `DioException` untuk menangani berbagai jenis _error_ yang mungkin terjadi selama permintaan jaringan (jaringan putus, _timeout_, respons _server_ dengan _error status code_). Yang terpenting, mereka akan belajar tentang `Interceptors` sebagai cara terpusat untuk memodifikasi permintaan dan respons, melakukan _logging_, menambahkan _headers_ otentikasi secara otomatis, dan bahkan melakukan _retries_ atau _token refresh_ secara transparan.

**Konsep Kunci & Filosofi Mendalam:**

- **Centralized Error Handling:** Daripada menulis blok `try-catch` yang sama di setiap panggilan API, kita bisa memusatkan logika penanganan _error_ umum.

  - **Filosofi:** Mengurangi _boilerplate_, meningkatkan konsistensi penanganan _error_, dan membuat _maintenance_ lebih mudah. Perubahan pada cara _error_ ditangani hanya perlu dilakukan di satu tempat.

- **Interceptors in Dio:** `Interceptors` adalah _middleware_ yang dapat mencegat, memodifikasi, atau bahkan membatalkan permintaan dan respons HTTP sebelum mereka dikirim atau setelah mereka diterima.

  - **Filosofi:** Menyediakan "hook" yang kuat dalam siklus hidup permintaan HTTP, memungkinkan pengembang untuk menyuntikkan logika kustom untuk _logging_, otentikasi, _caching_, penanganan _error_ umum, dll., tanpa mengotori kode aplikasi inti.

- **Types of Interceptors:**

  - **`RequestInterceptor`**: Dieksekusi sebelum permintaan dikirim. Ideal untuk menambahkan _headers_ (misalnya, token otentikasi), _logging_ permintaan, atau memodifikasi URL.
  - **`ResponseInterceptor`**: Dieksekusi setelah respons diterima dari _server_. Ideal untuk _logging_ respons, memvalidasi data, atau melakukan pra-pemrosesan respons.
  - **`ErrorInterceptor`**: Dieksekusi ketika ada `DioException`. Ideal untuk _logging_ _error_, menampilkan pesan _error_ global, melakukan _retries_, atau _token refresh_.
  - **Filosofi:** Membagi tanggung jawab _interceptor_ berdasarkan fase siklus permintaan, meningkatkan modularitas dan kejelasan.

- **Chaining Interceptors:** Beberapa _interceptor_ dapat ditambahkan ke `Dio` instance, dan mereka akan dieksekusi secara berurutan.

  - **Filosofi:** Membangun alur pemrosesan modular di mana setiap _interceptor_ menangani satu aspek tertentu dari permintaan atau respons.

**Visualisasi Diagram Alur/Struktur:**

- Diagram `Dio` dengan panah masuk ke `Interceptors`: `Request` -\> `RequestInterceptor` -\> `HTTP Request` -\> `Server Response` -\> `ResponseInterceptor` -\> (If Error -\> `ErrorInterceptor`) -\> `Client`.
- Visualisasi `ErrorInterceptor` yang menangkap `DioException` dan kemudian memutuskan apakah akan `handler.next(e)` (melanjutkan _error_), `handler.resolve(response)` (mengubah _error_ menjadi sukses), atau `handler.reject(error)` (menolak _error_).

**Hubungan dengan Modul Lain:**
Ini secara langsung membangun di atas `5.3.1 Dio (Advanced HTTP Client)` dan `5.1.3 Error Handling`. Konsep ini sangat relevan untuk `5.3.3 Working with Authentication (Tokens)` di mana _interceptor_ akan digunakan untuk menambahkan _token_ secara otomatis.

---

**Sintaks Dasar / Contoh Implementasi Inti:**

Mari kita buat contoh `Dio` client dengan _custom interceptors_ untuk _logging_ dan penanganan _error_ dasar.

Pertama, pastikan Anda telah menambahkan `dio` ke `pubspec.yaml` seperti di 5.3.1.

```dart
import 'package:dio/dio.dart';

// Asumsi Post model sudah ada seperti di 5.3.1

// --- 1. Custom Interceptor untuk Logging ---
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('HEADERS: ${options.headers}');
    print('DATA: ${options.data}');
    super.onRequest(options, handler); // Lanjutkan permintaan
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('DATA: ${response.data}');
    super.onResponse(response, handler); // Lanjutkan respons
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('MESSAGE: ${err.message}');
    if (err.response != null) {
      print('RESPONSE DATA: ${err.response?.data}');
    }
    super.onError(err, handler); // Lanjutkan error
  }
}

// --- 2. Custom Interceptor untuk Error Handling Otomatis (Contoh Sederhana) ---
class ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = 'Terjadi kesalahan tidak diketahui.';

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.unknown) { // 'unknown' seringkali berarti masalah jaringan
      errorMessage = 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    } else if (err.type == DioExceptionType.badResponse) {
      // Tangani status code spesifik
      switch (err.response?.statusCode) {
        case 400:
          errorMessage = 'Bad Request: ${err.response?.data['message'] ?? 'Data tidak valid.'}';
          break;
        case 401:
          errorMessage = 'Unauthorized: Silakan login kembali.';
          // Di sini Anda bisa menambahkan logika untuk refresh token atau logout otomatis
          break;
        case 404:
          errorMessage = 'Resource tidak ditemukan.';
          break;
        case 500:
          errorMessage = 'Internal Server Error: Ada masalah di server.';
          break;
        default:
          errorMessage = 'Server error: Status ${err.response?.statusCode ?? ''}';
          break;
      }
    } else if (err.type == DioExceptionType.cancel) {
      errorMessage = 'Permintaan dibatalkan.';
    }

    // Anda bisa melemparkan Exception kustom di sini
    // throw CustomAppException(errorMessage);

    // Atau, cukup cetak dan lanjutkan error agar tertangkap di try-catch di caller
    print('Handled by ErrorHandlingInterceptor: $errorMessage');

    // Penting: Anda harus memanggil handler.next(err) untuk meneruskan error
    // atau handler.resolve(response) jika Anda ingin mengubah error menjadi respons sukses
    handler.next(err);
  }
}


// --- Inisialisasi Dio Client dengan Interceptors ---
final Dio apiDio = Dio(BaseOptions(
  baseUrl: 'https://jsonplaceholder.typicode.com',
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 3),
  headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  },
));

// Tambahkan interceptor ke Dio instance
void setupDioInterceptors() {
  apiDio.interceptors.add(LoggingInterceptor());
  apiDio.interceptors.add(ErrorHandlingInterceptor());
  // Anda bisa menambahkan interceptor lain di sini (misalnya, AuthInterceptor)
}


// --- Fungsi API yang sama, kini menggunakan `apiDio` dengan interceptor ---
Future<List<Post>> fetchAllPostsDio() async {
  try {
    final response = await apiDio.get('/posts'); // Menggunakan apiDio
    if (response.statusCode == 200) {
      List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      // Ini jarang tercapai jika ErrorHandlingInterceptor melakukan throw sendiri
      throw Exception('Gagal memuat posts. Status Code: ${response.statusCode}');
    }
  } on DioException catch (e) {
    // Error sudah ditangani sebagian di interceptor, tapi Anda bisa menambahkan
    // logika spesifik untuk komponen UI di sini (misalnya, menampilkan SnackBar)
    print('Error caught in fetchAllPostsDio: ${e.message}');
    rethrow; // Melempar kembali error agar dapat ditangkap di tingkat UI jika diperlukan
  } catch (e) {
    print('Unexpected error in fetchAllPostsDio: $e');
    rethrow;
  }
}

// Untuk demonstasi, kita akan sengaja memicu error 404
Future<Post> fetchNonExistentPostDio() async {
  try {
    // Meminta ID yang tidak ada untuk memicu 404
    final response = await apiDio.get('/posts/999999999');
    if (response.statusCode == 200) {
      Map<String, dynamic> json = response.data;
      return Post.fromJson(json);
    } else {
      throw Exception('Gagal memuat post. Status Code: ${response.statusCode}');
    }
  } on DioException catch (e) {
    print('Error caught in fetchNonExistentPostDio: ${e.message}');
    rethrow;
  } catch (e) {
    print('Unexpected error in fetchNonExistentPostDio: $e');
    rethrow;
  }
}


void main() async {
  setupDioInterceptors(); // Panggil ini sekali saat aplikasi dimulai

  print('--- Mengambil Semua Posts (dengan Interceptors) ---');
  try {
    List<Post> posts = await fetchAllPostsDio();
    posts.take(1).forEach((post) => print(post)); // Cetak 1 post pertama
  } catch (e) {
    print('Main caught error: $e');
  }

  print('\n--- Mencoba Mengambil Post yang Tidak Ada (untuk memicu 404) ---');
  try {
    await fetchNonExistentPostDio();
  } catch (e) {
    print('Main caught error for non-existent post: $e');
  }

  // Contoh lain: Memicu Timeout (jika server lambat atau tidak merespons)
  // Untuk tujuan demo ini, sulit disimulasikan tanpa server sungguhan
  // Jika `connectTimeout` terlalu kecil, Anda mungkin melihat error jenis ini.
  // try {
  //   await dio.get('http://slowwly.robertomurray.co.uk/delay/10000/url/http://www.google.com'); // Simulasi delay 10 detik
  // } on DioException catch (e) {
  //   print('Timeout Error: ${e.message}');
  // }
}
```

**Penjelasan Konteks Kode:**

1.  **`LoggingInterceptor`:**

    - Meng-override `onRequest`, `onResponse`, dan `onError`.
    - Di setiap _method_, ia mencetak informasi relevan tentang permintaan, respons, atau _error_ ke konsol. Ini sangat berguna untuk _debugging_ selama pengembangan.
    - Panggilan `super.onRequest(options, handler)`, `super.onResponse(response, handler)`, dan `super.onError(err, handler)` adalah kunci untuk memastikan permintaan/respons/error terus diproses oleh _interceptor_ berikutnya dalam rantai atau oleh kode aplikasi itu sendiri.

2.  **`ErrorHandlingInterceptor`:**

    - Meng-override hanya `onError`.
    - Menganalisis `DioException` (berdasarkan `err.type` dan `err.response?.statusCode`) untuk menentukan jenis _error_ dan membuat pesan _error_ yang lebih mudah dipahami.
    - Anda bisa menambahkan logika di sini untuk:
      - Menampilkan `SnackBar` atau `Dialog` global.
      - Melakukan _logging_ _error_ ke layanan eksternal (misalnya, Firebase Crashlytics).
      - Memicu alur _refresh token_ otomatis (akan dibahas di 5.3.3).
      - Mengubah _error_ menjadi respons sukses jika Anda bisa memulihkan (jarang, tapi mungkin untuk _caching_).
    - `handler.next(err)`: Meneruskan _error_ ke _catch block_ berikutnya atau ke pemanggil API. Ini adalah yang paling umum.
    - `handler.resolve(response)`: Mengubah _error_ menjadi respons sukses. Misalnya, jika _server_ merespons 404, tetapi Anda memiliki data _cache_ lokal, Anda bisa mengembalikan data _cache_ tersebut sebagai respons sukses.
    - `handler.reject(error)`: Menolak _error_ sepenuhnya, mencegahnya mencapai pemanggil. (Jarang digunakan secara langsung kecuali Anda ingin menekan _error_).

3.  **Inisialisasi `Dio` dengan Interceptor:**

    - `apiDio.interceptors.add(...)`: Ini adalah cara untuk mendaftarkan _interceptor_ Anda ke instance `Dio`. Urutan penambahan _interceptor_ penting karena mereka akan dieksekusi secara berurutan.

4.  **Penggunaan di Fungsi API:**

    - Fungsi seperti `fetchAllPostsDio()` sekarang menggunakan `apiDio` yang sudah dikonfigurasi dengan _interceptors_.
    - Blok `try-catch` di fungsi-fungsi API menjadi lebih ringkas karena banyak _error_ umum sudah ditangani oleh `ErrorHandlingInterceptor`. Anda mungkin masih ingin memiliki `try-catch` di sini untuk logika spesifik UI atau untuk menangkap _error_ yang mungkin dilempar oleh _interceptor_ (`rethrow`).

**Visualisasi Diagram Alur/Struktur:**

- Diagram yang menunjukkan `Dio` object dengan daftar `interceptors` yang diatur.
- Panah yang menunjukkan `Request`, `Response`, dan `Error` melewati setiap _interceptor_ satu per satu.
- Detail tentang bagaimana `handler.next()`, `handler.resolve()`, dan `handler.reject()` memengaruhi alur di dalam _interceptor_.

**Terminologi Esensial:**

- **Interceptor:** _Middleware_ dalam `Dio` yang dapat mencegat dan memproses permintaan, respons, atau _error_.
- **`RequestInterceptorHandler`:** Objek yang digunakan di `onRequest` untuk melanjutkan, membatalkan, atau mengulang permintaan.
- **`ResponseInterceptorHandler`:** Objek yang digunakan di `onResponse` untuk melanjutkan atau mengubah respons.
- **`ErrorInterceptorHandler`:** Objek yang digunakan di `onError` untuk melanjutkan _error_, mengubah _error_ menjadi respons sukses, atau menolak _error_.
- **`DioException`:** Kelas dasar untuk semua _error_ yang dilempar oleh `Dio`.
- **`DioExceptionType`:** Enum yang mengklasifikasikan jenis `DioException` (misalnya, `connectionTimeout`, `badResponse`).

**Sumber Referensi Lengkap:**

- [Dio Interceptors (Dio Wiki)](https://github.com/cfug/dio/wiki/Interceptors)
- [Dio Exception Handling (Dio Wiki)](https://github.com/cfug/dio/wiki/Handling-Errors)

**Tips dan Praktik Terbaik:**

- **Modularitas Interceptor:** Buat setiap _interceptor_ memiliki satu tanggung jawab (misalnya, satu untuk _logging_, satu untuk otentikasi, satu untuk _error_). Ini membuat mereka lebih mudah untuk dikelola dan diuji.
- **Urutan Penting:** Urutan _interceptor_ ditambahkan penting. Misalnya, _logging interceptor_ harus ditambahkan sebelum _auth interceptor_ jika Anda ingin _log_ permintaan sebelum _token_ ditambahkan, atau setelahnya jika Anda ingin melihat _token_ yang ditambahkan.
- **Jangan Menelan Error:** Selalu _log_ _error_ atau tampilkan di UI. _Interceptors_ adalah tempat yang bagus untuk _logging_ _error_ secara global. Jika Anda menangani _error_ di _interceptor_ tetapi ingin komponen UI tertentu juga bereaksi, pastikan Anda `handler.next(err)` atau `rethrow` di `catch` block Anda.
- **Global vs. Local Handling:** Gunakan _interceptors_ untuk penanganan _error_ yang bersifat global (berlaku untuk semua atau sebagian besar permintaan). Tetap gunakan `try-catch` di tempat panggilan API jika ada logika penanganan _error_ yang sangat spesifik untuk satu fungsionalitas tertentu di UI.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Permintaan tidak pernah mencapai _server_ atau tidak ada respons yang dicetak.

  - **Penyebab:** Lupa memanggil `super.onRequest/onResponse/onError(handler)` di _custom interceptor_ Anda, sehingga rantai _interceptor_ atau alur permintaan/respons terputus.
  - **Solusi:** Pastikan Anda selalu memanggil `super` _method_ yang sesuai di dalam _custom interceptor_ Anda, atau gunakan `handler.next()`, `handler.resolve()`, atau `handler.reject()` secara eksplisit.

- **Kesalahan:** _Error_ ditangani oleh _interceptor_ tetapi UI tidak tahu bahwa ada _error_.

  - **Penyebab:** _Interceptor_ menangkap _error_ dan tidak meneruskannya (`handler.next(err)`) atau mengubahnya menjadi respons sukses (`handler.resolve(response)`).
  - **Solusi:** Jika Anda ingin _error_ tetap menyebar ke pemanggil, pastikan `handler.next(err)` dipanggil di `ErrorInterceptor`. Di tingkat aplikasi, Anda masih bisa memiliki `try-catch` di sekitar panggilan Dio untuk menampilkan pesan kepada pengguna.

- **Kesalahan:** _Interceptor_ tidak dieksekusi.

  - **Penyebab:** Lupa menambahkan _interceptor_ ke `dio.interceptors.add()` atau menambahkannya setelah permintaan pertama sudah dilakukan.
  - **Solusi:** Pastikan `setupDioInterceptors()` (atau metode inisialisasi _interceptor_ Anda) dipanggil sekali di awal aplikasi (misalnya, di `main()` sebelum `runApp()`).

---

#### 5.3.3 Working with Authentication (Tokens)

Sub-bagian ini akan membahas salah satu aspek terpenting dalam integrasi API dunia nyata: otentikasi. Fokusnya adalah pada otentikasi berbasis token (misalnya, JWT - JSON Web Tokens), yang merupakan metode paling umum untuk mengamankan komunikasi API di aplikasi seluler.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar konsep di balik token otentikasi, bagaimana cara memperolehnya dari _server_, cara menyimpannya dengan aman di perangkat, dan yang paling penting, bagaimana cara mengirimkannya secara otomatis dengan setiap permintaan API yang memerlukan otentikasi menggunakan `Dio` _interceptors_. Mereka juga akan mempelajari dasar-dasar _token refresh_ untuk menjaga sesi pengguna tetap aktif.

**Konsep Kunci & Filosofi Mendalam:**

- **Token-Based Authentication:** Sebuah metode di mana _server_ mengeluarkan token (string kriptografi) setelah pengguna berhasil login. Token ini kemudian digunakan oleh _client_ untuk membuktikan identitas mereka dalam permintaan API berikutnya.

  - **Filosofi:** **Statelessness** di sisi _server_. _Server_ tidak perlu menyimpan "session" pengguna; setiap token berisi semua informasi yang diperlukan untuk memverifikasi pengguna. Ini meningkatkan skalabilitas dan fleksibilitas.

- **JWT (JSON Web Tokens):** Format token yang umum digunakan, terdiri dari tiga bagian (Header, Payload, Signature) yang di-_encode_ dan dipisahkan oleh titik.

  - **Filosofi:** Memberikan cara yang standar dan _self-contained_ untuk transmisi informasi yang aman antara pihak-pihak. Informasi di dalam token (misalnya, ID pengguna, peran, waktu kedaluwarsa) dapat diverifikasi oleh _server_ tanpa perlu melakukan _lookup_ database.

- **Access Token vs. Refresh Token:**

  - **Access Token:** Token berumur pendek (misalnya, 15 menit, 1 jam) yang digunakan untuk mengamankan permintaan API yang terautentikasi.
  - **Refresh Token:** Token berumur panjang yang digunakan untuk mendapatkan _access token_ baru ketika _access token_ yang lama kedaluwarsa, tanpa mengharuskan pengguna untuk login ulang.
  - **Filosofi:** Meningkatkan keamanan dengan membatasi masa pakai _access token_ (jika dicuri, dampaknya terbatas), sementara tetap memberikan pengalaman pengguna yang mulus melalui _refresh token_.

- **Penyimpanan Token yang Aman:** Token harus disimpan dengan aman di perangkat agar tidak mudah diakses oleh aplikasi lain atau pihak jahat. `shared_preferences` dapat digunakan untuk demo atau kasus sederhana, tetapi untuk keamanan yang lebih tinggi, _secure storage_ (misalnya, `flutter_secure_storage`) harus dipertimbangkan.

  - **Filosofi:** Melindungi kredensial pengguna dan menjaga integritas sesi.

- **`AuthInterceptor` (Dio Interceptor):** Menggunakan _interceptor_ untuk secara otomatis menambahkan _access token_ ke _header_ `Authorization` dari setiap permintaan API yang keluar.

  - **Filosofi:** Mengotomatiskan tugas berulang, mengurangi _boilerplate_ di setiap panggilan API, dan memastikan token selalu disertakan jika tersedia.

- **Token Refresh Logic:** Mengimplementasikan logika untuk mendeteksi _access token_ yang kedaluwarsa (misalnya, melalui kode status 401 Unauthorized dari _server_) dan kemudian menggunakan _refresh token_ untuk mendapatkan _access token_ baru secara transparan sebelum mengulang permintaan awal.

  - **Filosofi:** Memastikan sesi pengguna tetap aktif dan terautentikasi tanpa gangguan, bahkan ketika _access token_ kedaluwarsa.

**Visualisasi Diagram Alur/Struktur:**

- **Login Flow:** User Input -\> Login Request (username/password) -\> Server Authenticates -\> Server Returns Access Token + Refresh Token -\> Save Tokens to Local Storage.
- **Authenticated Request Flow:** UI Action -\> API Call (via Dio) -\> `AuthInterceptor` intercepts -\> Checks for Access Token -\> Adds Token to Header -\> HTTP Request -\> Server Validates Token -\> Server Responds -\> UI Updates.
- **Token Refresh Flow:**
  - `AuthInterceptor` detects 401 Unauthorized.
  - Checks if Refresh Token exists.
  - Sends Refresh Token to Server to get new Access Token.
  - Saves new Access Token.
  - Retries original failed request with new Access Token.

---

**Sintaks Dasar / Contoh Implementasi Inti:**

Untuk demo ini, kita akan membutuhkan `shared_preferences` untuk penyimpanan token sederhana. Untuk produksi, pertimbangkan `flutter_secure_storage`.

Tambahkan dependensi di `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.3
  shared_preferences: ^2.2.3 # Untuk penyimpanan token sederhana
  # flutter_secure_storage: ^9.0.0 # Pertimbangkan untuk produksi

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
```

Kemudian jalankan `flutter pub get`.

```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Asumsi Model untuk Token Response ---
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn; // Contoh: durasi Access Token dalam detik

  AuthResponse({required this.accessToken, required this.refreshToken, required this.expiresIn});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }
}

// --- Kelas untuk Mengelola Token (Simulasi) ---
class AuthManager {
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  // Simpan token
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    print('Tokens saved: Access: $accessToken, Refresh: $refreshToken');
  }

  // Dapatkan access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Dapatkan refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Hapus token (logout)
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    print('Tokens cleared.');
  }

  // Simulasi API Login - Mengembalikan Access Token & Refresh Token
  static Future<AuthResponse> login(String username, String password) async {
    print('Attempting login for $username...');
    await Future.delayed(const Duration(seconds: 1)); // Simulasi delay

    if (username == 'user' && password == 'pass') {
      final String accessToken = 'fake_access_token_${DateTime.now().millisecondsSinceEpoch}';
      const String refreshToken = 'fake_refresh_token_123';
      const int expiresIn = 3600; // 1 jam
      await saveTokens(accessToken, refreshToken);
      return AuthResponse(accessToken: accessToken, refreshToken: refreshToken, expiresIn: expiresIn);
    } else {
      throw Exception('Invalid username or password');
    }
  }

  // Simulasi API Refresh Token - Mengembalikan Access Token Baru
  static Future<String> refreshAccessToken(String refreshToken) async {
    print('Refreshing token using: $refreshToken...');
    await Future.delayed(const Duration(seconds: 1)); // Simulasi delay

    if (refreshToken == 'fake_refresh_token_123') {
      final String newAccessToken = 'new_fake_access_token_${DateTime.now().millisecondsSinceEpoch}';
      await saveTokens(newAccessToken, refreshToken); // Simpan access token baru
      return newAccessToken;
    } else {
      await clearTokens(); // Refresh token tidak valid, paksa logout
      throw Exception('Invalid refresh token. Please login again.');
    }
  }
}

// --- Auth Interceptor untuk Dio ---
class AuthInterceptor extends Interceptor {
  final Dio dio; // Menerima Dio instance yang sama untuk permintaan refresh

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await AuthManager.getAccessToken();
    if (accessToken != null) {
      // Tambahkan Authorization header ke setiap permintaan
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    print('REQUEST[${options.method}] => PATH: ${options.path} with Auth: ${accessToken != null}');
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Tangani 401 Unauthorized - Token kedaluwarsa
    if (err.response?.statusCode == 401) {
      print('401 Unauthorized detected. Attempting to refresh token...');
      final refreshToken = await AuthManager.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Lakukan permintaan refresh token
          final newAccessToken = await AuthManager.refreshAccessToken(refreshToken);

          // Perbarui access token di Dio instance untuk permintaan selanjutnya (jika perlu)
          // dio.options.headers['Authorization'] = 'Bearer $newAccessToken'; // Jika Dio dipakai global

          // Buat ulang permintaan asli dengan token baru
          final RequestOptions originalRequest = err.requestOptions;
          originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';

          // Ulangi permintaan asli
          final response = await dio.fetch(originalRequest);
          print('Original request retried successfully with new token.');
          return handler.resolve(response); // Resolusi error dengan respons yang berhasil
        } on DioException catch (refreshError) {
          print('Token refresh failed: $refreshError');
          await AuthManager.clearTokens(); // Gagal refresh, hapus token dan paksa login
          // Arahkan ke halaman login atau tampilkan pesan error
          return handler.next(refreshError); // Teruskan error refresh
        } catch (e) {
          print('Unexpected error during token refresh: $e');
          await AuthManager.clearTokens();
          return handler.next(err); // Teruskan error asli jika ada masalah lain
        }
      } else {
        print('No refresh token available. User must log in.');
        await AuthManager.clearTokens(); // Tidak ada refresh token, paksa login
        return handler.next(err); // Teruskan 401 asli
      }
    }
    super.onError(err, handler); // Untuk error lain, teruskan
  }
}

// --- Dio Instance dengan Auth Interceptor ---
final Dio authDio = Dio(BaseOptions(
  baseUrl: 'https://jsonplaceholder.typicode.com', // Ganti dengan URL API yang sesungguhnya
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 3),
));

void setupAuthDio() {
  authDio.interceptors.add(AuthInterceptor(authDio)); // Tambahkan AuthInterceptor
  // Anda bisa menambahkan LoggingInterceptor atau ErrorHandlingInterceptor di sini juga
  // authDio.interceptors.add(LoggingInterceptor());
  // authDio.interceptors.add(ErrorHandlingInterceptor());
}

// --- Fungsi API Terautentikasi (Simulasi) ---
Future<Map<String, dynamic>> fetchProtectedData() async {
  print('Fetching protected data...');
  try {
    // Simulasi permintaan yang memerlukan token valid
    // Kita akan sengaja memicu 401 setelah token kedaluwarsa
    final response = await authDio.get('/posts/1'); // Contoh endpoint yang dilindungi
    print('Protected data response: ${response.statusCode}');
    return response.data;
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      print('API Error: Unauthorized. Token might be invalid or expired.');
      // Tidak perlu refresh manual di sini, interceptor sudah mencoba
    } else {
      print('API Error: ${e.message}');
    }
    rethrow;
  }
}

void main() async {
  setupAuthDio(); // Inisialisasi Dio dengan interceptor

  // Bersihkan token dari sesi sebelumnya
  await AuthManager.clearTokens();

  print('--- Skenario 1: Login Sukses & Ambil Data ---');
  try {
    // 1. Login
    await AuthManager.login('user', 'pass');

    // 2. Ambil data terproteksi (access token harusnya dikirim otomatis)
    final data = await fetchProtectedData();
    print('Fetched protected data (Skenario 1): ${data['title']}');
  } catch (e) {
    print('Skenario 1 Error: $e');
  }

  print('\n--- Skenario 2: Token Kedaluwarsa (Simulasi) dan Refresh Otomatis ---');
  try {
    // 1. Login lagi untuk mendapatkan token baru
    await AuthManager.login('user', 'pass');

    // 2. Simulasikan token kedaluwarsa dengan mengganti access token menjadi 'expired'
    // DI SINI ADALAH TRICKNYA UNTUK DEMO 401
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', 'EXPIRED_TOKEN'); // Set token kedaluwarsa secara paksa

    // 3. Coba ambil data terproteksi (akan menghasilkan 401, interceptor akan mencoba refresh)
    final data = await fetchProtectedData();
    print('Fetched protected data (Skenario 2 - After Refresh): ${data['title']}');
  } on DioException catch (e) {
    print('Skenario 2 Dio Error: ${e.response?.statusCode ?? e.message}');
  } catch (e) {
    print('Skenario 2 General Error: $e');
  }

  print('\n--- Skenario 3: Refresh Token Tidak Valid / Tidak Ada ---');
  try {
    await AuthManager.clearTokens(); // Pastikan tidak ada token
    await AuthManager.saveTokens('initial_token', 'INVALID_REFRESH'); // Simpan access token & refresh token tidak valid

    // Pemicu 401 pertama (simulasi)
    // Kemudian refresh token akan gagal karena 'INVALID_REFRESH'
    await fetchProtectedData();
  } on DioException catch (e) {
    print('Skenario 3 Dio Error (expected): ${e.response?.statusCode ?? e.message}');
    print('User should be logged out and redirected to login screen.');
  } catch (e) {
    print('Skenario 3 General Error: $e');
  }

  await AuthManager.clearTokens(); // Bersihkan token setelah demo
}
```

**Penjelasan Konteks Kode:**

1.  **`AuthResponse` Model:** Sebuah model sederhana untuk mengurai respons dari API login/refresh, yang biasanya berisi `accessToken`, `refreshToken`, dan `expiresIn`.

2.  **`AuthManager`:**

    - Mengelola penyimpanan token (`accessToken` dan `refreshToken`) menggunakan `shared_preferences`. Dalam aplikasi produksi, `flutter_secure_storage` lebih disarankan untuk keamanan yang lebih baik karena `shared_preferences` dapat diakses di beberapa platform (misalnya, Android SharedPreferences XML file).
    - `login()`: Mensimulasikan panggilan API login. Setelah sukses, ia menyimpan token yang diterima.
    - `refreshAccessToken()`: Mensimulasikan panggilan API untuk mendapatkan _access token_ baru menggunakan _refresh token_. Penting untuk memperbarui _access token_ yang disimpan setelah berhasil.

3.  **`AuthInterceptor`:**

    - **`onRequest(RequestOptions options, RequestInterceptorHandler handler)`:**
      - Sebelum setiap permintaan, ia mencoba mengambil `accessToken` dari `AuthManager`.
      - Jika _access token_ ada, ia menambahkannya ke `Authorization` _header_ dalam format `Bearer <token>`. Ini adalah standar untuk otentikasi Bearer Token.
      - Kemudian, ia meneruskan permintaan (`super.onRequest` atau `handler.next`).
    - **`onError(DioException err, ErrorInterceptorHandler handler)`:**
      - Ini adalah bagian paling kompleks dan krusial.
      - Jika _error_ adalah 401 Unauthorized (`err.response?.statusCode == 401`), ini menandakan bahwa _access token_ mungkin kedaluwarsa atau tidak valid.
      - Interceptor kemudian mencoba mendapatkan `refreshToken`.
      - Jika `refreshToken` ada, ia memanggil `AuthManager.refreshAccessToken()` untuk mendapatkan _access token_ baru.
      - Setelah _access token_ baru diperoleh, _header_ `Authorization` dari `originalRequest` (permintaan yang gagal) diperbarui dengan token baru.
      - `dio.fetch(originalRequest)`: Permintaan asli diulang dengan _access token_ yang baru.
      - `handler.resolve(response)`: Jika permintaan ulang berhasil, _interceptor_ "menyelesaikan" _error_ ini dengan respons yang berhasil dari permintaan ulang. Ini berarti pemanggil asli dari `fetchProtectedData()` tidak akan melihat _error_ 401; mereka akan melihat respons yang berhasil setelah refresh token. Ini menciptakan pengalaman pengguna yang mulus.
      - Jika _token refresh_ gagal (misalnya, _refresh token_ tidak valid), `AuthManager.clearTokens()` dipanggil untuk memaksa logout pengguna, dan _error_ diteruskan.

4.  **`setupAuthDio()`:** Menginisialisasi `Dio` instance dan menambahkan `AuthInterceptor` ke dalamnya.

5.  **`fetchProtectedData()`:** Sebuah fungsi simulasi untuk mengambil data yang memerlukan otentikasi. Ini akan memicu alur _interceptor_ dan _token refresh_ jika token kedaluwarsa.

**Visualisasi Diagram Alur/Struktur:**

- **Otentikasi Login:** UI (Username/Password) -\> `AuthManager.login()` -\> `Dio.post(/login)` -\> Server -\> Respon (Access/Refresh Tokens) -\> `AuthManager.saveTokens()` -\> UI (Dashboard).
- **Permintaan Terautentikasi:** UI (Tombol) -\> `fetchProtectedData()` -\> `AuthDio.get(/protected)`
  - `-> AuthInterceptor.onRequest` (Adds Token) -\> `Dio Request` -\> Server.
  - Server Respon (200 OK) -\> `AuthInterceptor.onResponse` -\> UI.
- **Token Refresh Otomatis:** UI (Tombol) -\> `fetchProtectedData()` -\> `AuthDio.get(/protected)`
  - `-> AuthInterceptor.onRequest` (Adds Expired Token) -\> `Dio Request` -\> Server Respon (401 Unauthorized)
  - `-> AuthInterceptor.onError` (Detects 401) -\> `AuthManager.refreshAccessToken()` -\> `Dio.post(/refresh)` -\> Server Respon (New Access Token) -\> `AuthManager.saveTokens()` -\> `AuthInterceptor` retries `originalRequest` with new token.
  - `-> AuthInterceptor.resolve(retryResponse)` -\> UI.

**Terminologi Esensial:**

- **Authentication (Otentikasi):** Proses memverifikasi identitas pengguna (siapa Anda?).
- **Authorization (Otorisasi):** Proses menentukan izin pengguna (apa yang bisa Anda lakukan?).
- **Token:** String kriptografi yang mewakili identitas atau izin pengguna.
- **JWT (JSON Web Token):** Format token populer yang _self-contained_ dan dapat diverifikasi.
- **Access Token:** Token berumur pendek untuk mengakses _protected resources_.
- **Refresh Token:** Token berumur panjang untuk mendapatkan _access token_ baru.
- **`Authorization` header:** _Header_ HTTP standar yang digunakan untuk mengirimkan kredensial otentikasi (misalnya, `Authorization: Bearer <token>`).
- **Bearer Token:** Jenis _access token_ di mana klien "membawa" token ini sebagai "pembawa" otorisasi.
- **`flutter_secure_storage`:** Paket untuk menyimpan data sensitif dengan aman di _keychain_ iOS atau _Keystore_ Android.
- **`Dio.fetch(requestOptions)`:** Metode dalam `Dio` untuk mengulang permintaan yang sudah ada atau membuat permintaan baru dari `RequestOptions`.

**Sumber Referensi Lengkap:**

- [JWT Introduction](https://jwt.io/introduction)
- [The OAuth 2.0 Authorization Framework](https://datatracker.ietf.org/doc/html/rfc6749) (spesifikasi OAuth 2.0 yang sering melibatkan Access/Refresh Tokens)
- [flutter_secure_storage (pub.dev)](https://pub.dev/packages/flutter_secure_storage)
- [Dio Wiki - Refresh Token](https://github.com/cfug/dio/wiki/Interceptors%23refresh-token)

**Tips dan Praktik Terbaik:**

- **Gunakan Secure Storage:** Untuk token sensitif, selalu gunakan `flutter_secure_storage` di lingkungan produksi, bukan `shared_preferences`.
- **Pisahkan Logika Otentikasi:** Buat kelas terpisah (seperti `AuthManager` di contoh) untuk mengelola login, logout, penyimpanan/pengambilan token, dan _token refresh_. Ini menjaga kode tetap rapi dan _maintainable_.
- **Modularisasi Interceptor:** Gabungkan _logging_, _error handling_, dan _authentication_ ke dalam _interceptor_ yang berbeda untuk menjaga modularitas.
- **Retry Logic Hati-hati:** Pastikan logika _retry_ (di dalam `AuthInterceptor`) tidak membuat _loop_ tak terbatas jika _token refresh_ terus gagal. Batasi jumlah _retry_ atau berikan _fallback_ (misalnya, paksa logout).
- **Handle Logout:** Pastikan Anda membersihkan semua token (access dan refresh) dari penyimpanan lokal saat pengguna logout.
- **Perhatikan Security Headings:** Pastikan Anda memahami `Authorization` _header_ dan tidak secara tidak sengaja mengekspos token di URL atau _request body_ yang tidak terenkripsi.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Token tidak ditambahkan ke permintaan.

  - **Penyebab:** Lupa menambahkan `AuthInterceptor` ke `Dio` instance, atau _logic_ di `onRequest` _interceptor_ tidak benar.
  - **Solusi:** Periksa kembali `authDio.interceptors.add(AuthInterceptor(authDio));` dan pastikan `options.headers['Authorization']` diatur dengan benar.

- **Kesalahan:** Aplikasi terus menampilkan "Unauthorized" atau meminta login berulang kali.

  - **Penyebab:**
    1.  _Access token_ tidak diperbarui di penyimpanan setelah _refresh_.
    2.  _Refresh token_ itu sendiri kedaluwarsa atau tidak valid, dan tidak ada penanganan untuk memaksa logout.
    3.  API _refresh token_ salah atau tidak bekerja.
  - **Solusi:**
    1.  Pastikan `AuthManager.saveTokens()` dipanggil dengan _access token_ yang baru setelah _refresh_.
    2.  Implementasikan logika untuk membersihkan token dan mengarahkan pengguna ke layar login jika _refresh token_ gagal.
    3.  Uji API _refresh token_ Anda secara terpisah menggunakan Postman atau alat lain.

- **Kesalahan:** Lingkaran permintaan tak terbatas saat _token refresh_ gagal.

  - **Penyebab:** `AuthInterceptor` terus mencoba _refresh_ token yang tidak valid atau _server_ terus merespons 401 meskipun dengan token yang seharusnya valid.
  - **Solusi:** Tambahkan mekanisme pencegahan _loop_ dalam `AuthInterceptor`, seperti batas _retry_ atau bendera untuk mencegah _refresh_ berulang kali dalam waktu singkat. Jika _refresh_ gagal dalam beberapa percobaan, paksa logout.

---

### 5.4 Local Data Persistence

Sub-bagian ini akan membahas berbagai metode untuk menyimpan data secara lokal di perangkat, memungkinkan aplikasi berfungsi _offline_ atau menyimpan konfigurasi pengguna.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari perbedaan antara `shared_preferences` (untuk data sederhana), `sqflite` (untuk data relasional terstruktur), dan `Hive`/`Isar` (untuk NoSQL yang lebih cepat). Mereka akan memahami kapan harus menggunakan setiap teknologi berdasarkan kebutuhan aplikasi dan jenis data. Keterampilan ini penting untuk membangun aplikasi yang _robust_, memberikan pengalaman pengguna yang lebih baik, dan mengelola data _offline_ secara efektif.

**Konsep Kunci & Filosofi Mendalam (Umum untuk Bagian Ini):**

- **Offline First / Caching:** Kemampuan aplikasi untuk berfungsi tanpa koneksi internet penuh atau memuat data lebih cepat dari penyimpanan lokal.

  - **Filosofi:** Meningkatkan _user experience_ dan keandalan aplikasi, terutama di lingkungan dengan koneksi tidak stabil.

- **Data Consistency:** Memastikan data yang disimpan secara lokal tetap sinkron dengan data di _server_ (jika ada).

  - **Filosofi:** Menjaga integritas data dan menghindari konflik antara versi _offline_ dan _online_.

- **Choosing the Right Tool:** Pemahaman tentang berbagai solusi penyimpanan data lokal dan kapan menggunakan masing-masing.

  - **Filosofi:** Mengoptimalkan performa, skalabilitas, dan kemudahan pengembangan dengan memilih alat yang paling sesuai untuk tugas yang diberikan.

**Visualisasi Diagram Alur/Struktur:**

- Diagram Pohon Keputusan: Kapan menggunakan SharedPreferences vs. SQLite vs. Hive/Isar berdasarkan kompleksitas data, kebutuhan relasional, dan kecepatan.
- Diagram umum alur penyimpanan data: Aplikasi -\> Penyimpanan Lokal -\> Perangkat.

**Hubungan dengan Modul Lain:**
Ini melengkapi topik integrasi API (`5.2`, `5.3`) dengan menyediakan cara untuk menyimpan data yang diperoleh dari API atau data yang dihasilkan secara lokal. Konsep ini juga dapat berhubungan dengan `Fase 6: State Management` untuk persistensi _state_ aplikasi.

---

#### 5.4.1 Shared Preferences (Simple Key-Value)

Sub-bagian ini akan memperkenalkan `shared_preferences`, solusi penyimpanan data yang paling sederhana di Flutter, ideal untuk menyimpan pasangan kunci-nilai sederhana seperti pengaturan pengguna atau _flags_.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar cara menggunakan `shared_preferences` untuk menyimpan dan membaca tipe data primitif (string, int, bool, double, List\<String\>). Mereka akan memahami batasan dan kasus penggunaan terbaiknya. Ini adalah titik awal yang mudah untuk memahami persistensi data lokal di Flutter.

**Konsep Kunci & Filosofi Mendalam:**

- **Key-Value Store:** Data disimpan dalam bentuk pasangan kunci-nilai, mirip dengan `Map`.

  - **Filosofi:** Simplicity dan kecepatan akses untuk data non-kompleks. Cocok untuk preferensi pengguna, _flag_ aplikasi (misalnya, `isLoggedIn`, `hasSeenOnboarding`), atau nilai-nilai konfigurasi kecil.

- **Asynchronous API:** Semua operasi `shared_preferences` adalah asinkron, mengembalikan `Future`.

  - **Filosofi:** Mencegah pemblokiran UI (juga disebut _jank_) selama operasi I/O, menjaga aplikasi tetap responsif.

- **Platform-Specific Implementation:** `shared_preferences` adalah _wrapper_ di atas mekanisme penyimpanan preferensi asli platform (misalnya, `SharedPreferences` di Android, `NSUserDefaults` di iOS).

  - **Filosofi:** Memanfaatkan solusi penyimpanan bawaan OS yang sudah dioptimalkan dan teruji untuk data preferensi.

**Sintaks Dasar / Contoh Implementasi Inti:**

Pertama, tambahkan dependensi `shared_preferences` di `pubspec.yaml` Anda:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.3 # Periksa versi terbaru di pub.dev
```

Kemudian jalankan `flutter pub get`.

```dart
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _preferences;

  // Inisialisasi SharedPreferences. Harus dipanggil sekali di awal aplikasi (misalnya di main()).
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // --- Metode untuk Menyimpan Data ---

  // Menyimpan String
  static Future<bool> setUserName(String name) async {
    return await _preferences.setString('username', name);
  }

  // Menyimpan Boolean
  static Future<bool> setDarkMode(bool isDarkMode) async {
    return await _preferences.setBool('isDarkMode', isDarkMode);
  }

  // Menyimpan Integer
  static Future<bool> setUserAge(int age) async {
    return await _preferences.setInt('userAge', age);
  }

  // Menyimpan Double
  static Future<bool> setUserHeight(double height) async {
    return await _preferences.setDouble('userHeight', height);
  }

  // Menyimpan List of Strings
  static Future<bool> setRecentSearches(List<String> searches) async {
    return await _preferences.setStringList('recentSearches', searches);
  }

  // --- Metode untuk Mengambil Data ---

  // Mengambil String
  static String? getUserName() {
    return _preferences.getString('username');
  }

  // Mengambil Boolean
  static bool getDarkMode() {
    return _preferences.getBool('isDarkMode') ?? false; // Default value if not found
  }

  // Mengambil Integer
  static int getUserAge() {
    return _preferences.getInt('userAge') ?? 0; // Default value if not found
  }

  // Mengambil Double
  static double getUserHeight() {
    return _preferences.getDouble('userHeight') ?? 0.0; // Default value if not found
  }

  // Mengambil List of Strings
  static List<String>? getRecentSearches() {
    return _preferences.getStringList('recentSearches');
  }

  // --- Metode Lain-lain ---

  // Memeriksa apakah kunci ada
  static bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  // Menghapus satu kunci
  static Future<bool> removeKey(String key) async {
    return await _preferences.remove(key);
  }

  // Menghapus semua data
  static Future<bool> clearAll() async {
    return await _preferences.clear();
  }
}

void main() async {
  // PENTING: Panggil ini di awal aplikasi Anda (misalnya di main() atau runApp())
  // WidgetsFlutterBinding.ensureInitialized(); jika dijalankan di main() tanpa runApp()
  // Di Flutter app, ini akan otomatis dipanggil saat runApp()
  // Untuk contoh CLI, kita panggil manual:
  await UserPreferences.init();
  print('SharedPreferences initialized.');

  print('\n--- Menyimpan Data ---');
  await UserPreferences.setUserName('Alice Smith');
  await UserPreferences.setDarkMode(true);
  await UserPreferences.setUserAge(30);
  await UserPreferences.setUserHeight(175.5);
  await UserPreferences.setRecentSearches(['Flutter', 'Dart', 'API']);
  print('Data disimpan.');

  print('\n--- Mengambil Data ---');
  print('Username: ${UserPreferences.getUserName()}');
  print('Dark Mode: ${UserPreferences.getDarkMode()}');
  print('User Age: ${UserPreferences.getUserAge()}');
  print('User Height: ${UserPreferences.getUserHeight()} cm');
  print('Recent Searches: ${UserPreferences.getRecentSearches()}');

  print('\n--- Memeriksa Data ---');
  print('Contains key "username": ${UserPreferences.containsKey('username')}');
  print('Contains key "nonExistentKey": ${UserPreferences.containsKey('nonExistentKey')}');

  print('\n--- Mengubah Data ---');
  await UserPreferences.setUserName('Bob Johnson');
  print('Updated Username: ${UserPreferences.getUserName()}');

  print('\n--- Menghapus Data ---');
  await UserPreferences.removeKey('userAge');
  print('User Age after removal: ${UserPreferences.getUserAge()} (default value)');
  print('Contains key "userAge": ${UserPreferences.containsKey('userAge')}');

  print('\n--- Menghapus Semua Data ---');
  await UserPreferences.clearAll();
  print('Username after clear: ${UserPreferences.getUserName()} (null)');
  print('Contains key "username" after clear: ${UserPreferences.containsKey('username')}');
}

// --- Contoh Integrasi dengan Flutter UI (Conceptual) ---
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    await UserPreferences.init(); // Pastikan init dipanggil sebelum runApp()
    setState(() {
      _isDarkMode = UserPreferences.getDarkMode();
      _username = UserPreferences.getUserName();
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    await UserPreferences.setDarkMode(value);
  }

  Future<void> _saveUsername(String? value) async {
    if (value != null && value.isNotEmpty) {
      setState(() {
        _username = value;
      });
      await UserPreferences.setUserName(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Aplikasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Mode Gelap'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: _toggleDarkMode,
              ),
            ),
            ListTile(
              title: const Text('Nama Pengguna'),
              subtitle: Text(_username ?? 'Belum diatur'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final TextEditingController controller = TextEditingController(text: _username);
                    return AlertDialog(
                      title: const Text('Ubah Nama Pengguna'),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(hintText: 'Masukkan nama'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            _saveUsername(controller.text);
                            Navigator.pop(context);
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            // Tombol untuk clear all data
            ElevatedButton(
              onPressed: () async {
                await UserPreferences.clearAll();
                _loadPreferences(); // Muat ulang preferensi setelah dihapus
              },
              child: const Text('Hapus Semua Pengaturan'),
            ),
          ],
        ),
      ),
    );
  }
}

// Untuk menjalankan contoh UI ini, bungkus dalam StatelessWidget/MaterialApp
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter engine siap
  await UserPreferences.init(); // Inisialisasi SharedPreferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: UserPreferences.getDarkMode() ? Brightness.dark : Brightness.light,
      ),
      home: const SettingsScreen(),
    );
  }
}
*/
```

**Penjelasan Konteks Kode:**

1.  **`UserPreferences` Class:** Sebuah _wrapper_ statis yang disarankan untuk mengelola semua operasi `shared_preferences`. Ini membantu menjaga kode tetap terorganisir.
2.  **`static late SharedPreferences _preferences;`:** Deklarasi _late_ dan _static_ untuk menyimpan satu instance `SharedPreferences` yang akan digunakan di seluruh aplikasi.
3.  **`static Future<void> init() async { _preferences = await SharedPreferences.getInstance(); }`:** Metode inisialisasi yang **harus** dipanggil sekali sebelum Anda mencoba membaca atau menulis data. Idealnya, panggil ini di `main()` sebelum `runApp()`, setelah `WidgetsFlutterBinding.ensureInitialized()`.
4.  **`set...()` Methods:** Menggunakan `_preferences.setString()`, `setBool()`, `setInt()`, `setDouble()`, `setStringList()` untuk menyimpan berbagai tipe data primitif. Metode ini mengembalikan `Future<bool>` yang menunjukkan apakah operasi berhasil.
5.  **`get...()` Methods:** Menggunakan `_preferences.getString()`, `getBool()`, dll. untuk mengambil data. Penting untuk dicatat bahwa metode `get` mengembalikan nilai _nullable_ (misalnya `String?`) jika kunci tidak ditemukan. Gunakan operator `??` untuk menyediakan nilai _default_ jika diinginkan.
6.  **`removeKey()` dan `clearAll()`:** Untuk menghapus data secara spesifik berdasarkan kunci atau menghapus semua data yang disimpan oleh aplikasi.
7.  **`main()` Function (CLI Demo):** Menunjukkan alur penggunaan `UserPreferences` secara sekuensial. Perhatikan `await UserPreferences.init();` di awal.
8.  **`SettingsScreen` (Flutter UI Integration):**
    - `initState()`: Memanggil `_loadPreferences()` saat widget diinisialisasi untuk mengambil data preferensi yang sudah ada.
    - `_loadPreferences()`: Metode asinkron untuk memuat semua preferensi dan kemudian memperbarui _state_ UI (`setState`).
    - `_toggleDarkMode()` dan `_saveUsername()`: Metode yang memanggil fungsi `UserPreferences` untuk menyimpan data, lalu memperbarui _state_ UI.
    - `Switch` dan `TextField` digunakan untuk mengikat UI ke data preferensi.

**Visualisasi Diagram Alur/Struktur:**

- Diagram sederhana `Key-Value Pair`: `Key "username"` -\> `Value "Alice"`.
- Alur penyimpanan: UI `Switch` -\> `onChanged` -\> `UserPreferences.setBool()` -\> `SharedPreferences` (Disk).
- Alur pengambilan: `initState()` -\> `UserPreferences.getBool()` -\> `_isDarkMode` (State UI).

**Terminologi Esensial:**

- **`shared_preferences`:** Paket Flutter untuk penyimpanan data key-value sederhana.
- **Key-Value Store:** Model penyimpanan data di mana setiap data diidentifikasi oleh kunci unik.
- **Persistent Storage:** Data yang tetap ada bahkan setelah aplikasi ditutup dan dibuka kembali.
- **`SharedPreferences.getInstance()`:** Metode asinkron untuk mendapatkan satu instance `SharedPreferences`.
- **`setString()`, `getBool()`, etc.:** Metode untuk menyimpan dan mengambil data berdasarkan tipe.
- **`WidgetsFlutterBinding.ensureInitialized()`:** Harus dipanggil di `main()` jika Anda ingin menggunakan plugin Flutter (termasuk `shared_preferences`) sebelum `runApp()`.

**Sumber Referensi Lengkap:**

- [shared_preferences package (pub.dev)](https://pub.dev/packages/shared_preferences) - Dokumentasi resmi paket.
- [Persist data with `shared_preferences` (Flutter documentation)](<https://www.google.com/search?q=%5Bhttps://docs.flutter.dev/data-and-backend/local-data/shared-preferences%5D(https://docs.flutter.dev/data-and-backend/local-data/shared-preferences)>) - Panduan resmi Flutter.

**Tips dan Praktik Terbaik:**

- **Inisialisasi Awal:** Selalu inisialisasi `shared_preferences` (`await SharedPreferences.getInstance();`) sekali di awal aplikasi, biasanya di `main()` sebelum `runApp()`.
- **Gunakan Wrapper Class:** Buat kelas _wrapper_ (seperti `UserPreferences` di contoh) untuk mengabstraksi detail `shared_preferences` dan membuat kode lebih bersih, mudah diuji, dan aman tipe.
- **Default Values:** Selalu sediakan nilai _default_ saat mengambil data (misalnya, `getBool('key') ?? false`) untuk menghindari `null` dan _error_.
- **Jangan untuk Data Kompleks:** Jangan gunakan `shared_preferences` untuk menyimpan data yang sangat besar, kompleks, atau relasional. Ini bukan database dan tidak dioptimalkan untuk skenario tersebut.
- **Hindari Data Sensitif:** Untuk data yang sangat sensitif seperti token otentikasi atau informasi pribadi, pertimbangkan menggunakan solusi penyimpanan yang lebih aman seperti `flutter_secure_storage` atau `keychain_storage` karena `shared_preferences` tidak terenkripsi secara default. (Sudah dibahas sedikit di 5.3.3)

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `LateInitializationError: Field '_preferences@..._' has not been initialized.`

  - **Penyebab:** Anda mencoba mengakses `_preferences` sebelum `UserPreferences.init()` (atau `SharedPreferences.getInstance()`) selesai dipanggil.
  - **Solusi:** Pastikan `init()` dipanggil dan selesai sebelum ada operasi baca/tulis `shared_preferences` lainnya. Idealnya, panggil di `main()` dengan `await`.

- **Kesalahan:** `PlatformException` (misalnya, _Error writing to preferences_).

  - **Penyebab:** Masalah izin (jarang untuk `shared_preferences`), atau masalah ruang penyimpanan di perangkat.
  - **Solusi:** Periksa _logcat_ (Android) atau _Xcode console_ (iOS) untuk detail _exception_ lebih lanjut. Pastikan ada ruang yang cukup di perangkat.

- **Kesalahan:** Data tidak persisten setelah aplikasi di-_uninstall_ atau _data_ aplikasi dihapus.

  - **Penyebab:** Ini adalah perilaku normal. `shared_preferences` menyimpan data yang terkait dengan instalasi aplikasi tertentu. Jika aplikasi di-_uninstall_ atau data dihapus, preferensi juga akan hilang.
  - **Solusi:** Ini bukan _error_, melainkan perilaku yang diharapkan. Untuk data yang perlu bertahan dari _uninstall_, pertimbangkan layanan _cloud_ atau sinkronisasi dengan _server_.

---

#### 5.4.2 SQLite (via `sqflite` package)

Sub-bagian ini akan membahas penggunaan SQLite, sebuah _relational database_ ringan yang sangat populer untuk aplikasi seluler, melalui paket `sqflite` di Flutter. Ini adalah pilihan yang sangat baik untuk menyimpan data terstruktur dan relasional secara lokal.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar konsep dasar database relasional, cara menginisialisasi database SQLite di Flutter, membuat tabel, serta melakukan operasi CRUD (Create, Read, Update, Delete) menggunakan SQL mentah dan metode _helper_ `sqflite`. Mereka akan memahami kapan `sqflite` lebih unggul dari `shared_preferences` dan mempersiapkan mereka untuk skenario data yang lebih kompleks.

**Konsep Kunci & Filosofi Mendalam:**

- **Relational Database:** Data diorganisir dalam tabel dengan baris dan kolom, dan hubungan antar tabel dapat didefinisikan (misalnya, _one-to-many_, _many-to-many_).

  - **Filosofi:** Menyediakan struktur yang kuat dan terdefinisi dengan baik untuk mengelola data yang kompleks dan saling terkait, memastikan integritas data melalui skema.

- **SQLite:** Sebuah mesin _database_ SQL yang ringkas, tanpa server, mandiri, berkonfigurasi nol, transaksional yang umum digunakan di perangkat seluler.

  - **Filosofi:** Memberikan kemampuan _database_ penuh tanpa _overhead_ server, ideal untuk penyimpanan data lokal yang andal dan berkinerja tinggi.

- **`sqflite` package:** _Plugin_ Flutter resmi untuk SQLite, menyediakan API Dart untuk berinteraksi dengan database SQLite di Android, iOS, dan desktop.

  - **Filosofi:** Mengintegrasikan SQLite secara mulus dengan Dart/Flutter, memungkinkan pengembang untuk memanfaatkan kekuatan SQL dari dalam aplikasi mereka.

- **CRUD Operations:** Singkatan dari Create, Read, Update, Delete. Ini adalah empat operasi dasar yang dilakukan pada data di _database_.

  - **Filosofi:** Menyediakan standar universal untuk interaksi data, membuat pengelolaan data dapat diprediksi dan terstruktur.

- **Database Schema & Migrations:** Mendefinisikan struktur tabel dan kolom, serta mengelola perubahan pada struktur _database_ seiring waktu.

  - **Filosofi:** Memastikan konsistensi data dan memungkinkan evolusi aplikasi tanpa kehilangan data pengguna yang sudah ada.

- **`Batch` Operations:** Mengelompokkan beberapa operasi _database_ menjadi satu transaksi, yang dapat meningkatkan performa.

  - **Filosofi:** Mengoptimalkan operasi I/O dan menjaga konsistensi data dengan memastikan semua operasi dalam batch berhasil atau tidak sama sekali (atomicity).

**Visualisasi Diagram Alur/Struktur:**

- Diagram `Database Lifecycle`: `openDatabase` -\> `onCreate`/`onUpgrade` -\> `Database` instance -\> `CRUD operations`.
- Tabel Contoh: `id | name | description | isCompleted`.
- SQL Query Flow: Flutter Code -\> `sqflite` API -\> SQLite Engine -\> Disk.

**Hubungan dengan Modul Lain:**
Melengkapi `5.2 HTTP Requests & REST APIs` dan `5.3 Advanced API Integration` dengan menyediakan cara untuk _cache_ atau menyimpan data yang diambil dari API. Juga berhubungan dengan `5.2.3 Handling JSON` karena data yang diambil dari API (JSON) sering disimpan sebagai objek Dart di SQLite.

---

**Sintaks Dasar / Contoh Implementasi Inti:**

Pertama, tambahkan dependensi `sqflite` dan `path_provider` (untuk mendapatkan jalur database yang benar) di `pubspec.yaml` Anda:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.3 # Periksa versi terbaru di pub.dev
  path_provider: ^2.1.3 # Untuk menemukan lokasi penyimpanan database
  path: ^1.9.0 # Untuk join path
```

Kemudian jalankan `flutter pub get`.

```dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Untuk join path database

// --- 1. Model Data (POJO) ---
// Merepresentasikan sebuah item To-Do
class Todo {
  final int? id; // id bisa null saat membuat item baru
  final String title;
  final String description;
  final bool isCompleted;

  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false, // Default value
  });

  // Konversi Todo object menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0, // SQLite menyimpan boolean sebagai INT
    };
  }

  // Konversi Map menjadi Todo object
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: (map['isCompleted'] as int) == 1,
    );
  }

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, description: $description, isCompleted: $isCompleted}';
  }
}

// --- 2. Database Helper Class ---
class TodoDatabaseHelper {
  static Database? _database;
  static const String tableName = 'todos'; // Nama tabel

  // Getter untuk mendapatkan instance database (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Menginisialisasi database
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, 'todo_app.db'); // Nama file database

    return await openDatabase(
      path,
      version: 1, // Versi database
      onCreate: _onCreate, // Dipanggil saat database pertama kali dibuat
      onUpgrade: _onUpgrade, // Dipanggil saat versi database berubah
    );
  }

  // Metode untuk membuat tabel
  Future _onCreate(Database db, int version) async {
    print('Creating table: $tableName');
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
    print('Table $tableName created.');
  }

  // Metode untuk meng-upgrade database (contoh)
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion');
    // Contoh: Jika ada perubahan skema di versi mendatang
    if (oldVersion < 2) {
      // Tambahkan kolom baru misalnya
      // await db.execute("ALTER TABLE $tableName ADD COLUMN new_column TEXT;");
    }
    print('Database upgraded.');
  }

  // --- Operasi CRUD ---

  // Create: Menambahkan item Todo baru
  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    // `insert` akan mengembalikan ID dari baris yang baru dimasukkan
    final id = await db.insert(
      tableName,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Ganti jika ID sudah ada
    );
    print('Inserted Todo with ID: $id');
    return id;
  }

  // Read: Mendapatkan semua item Todo
  Future<List<Todo>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    print('Fetched ${maps.length} todos.');
    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  // Read: Mendapatkan item Todo berdasarkan ID
  Future<Todo?> getTodoById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first);
    }
    print('Todo with ID $id not found.');
    return null;
  }

  // Update: Memperbarui item Todo
  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    final rowsAffected = await db.update(
      tableName,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Updated Todo with ID: ${todo.id}. Rows affected: $rowsAffected');
    return rowsAffected;
  }

  // Delete: Menghapus item Todo
  Future<int> deleteTodo(int id) async {
    final db = await database;
    final rowsAffected = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Deleted Todo with ID: $id. Rows affected: $rowsAffected');
    return rowsAffected;
  }

  // --- Operasi Lanjutan: Batch Operations ---
  Future<void> bulkInsert(List<Todo> todos) async {
    final db = await database;
    // Memulai transaksi batch
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var todo in todos) {
        batch.insert(tableName, todo.toMap());
      }
      await batch.commit(noResult: true); // noResult: true jika tidak butuh ID dari setiap insert
    });
    print('Bulk insert of ${todos.length} todos completed.');
  }

  // Menutup koneksi database (opsional, biasanya tidak perlu di app berjalan)
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      print('Database closed.');
    }
  }

  // Menghapus database (untuk pengujian atau reset)
  static Future<void> deleteDatabaseFile() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, 'todo_app.db');
    await deleteDatabase(path);
    print('Database file deleted: $path');
    _database = null; // Reset instance
  }
}

void main() async {
  // PENTING: Untuk menjalankan sqflite di main() tanpa Flutter UI,
  // perlu inisialisasi binding.
  // Di aplikasi Flutter normal, ini otomatis oleh runApp().
  // Untuk contoh CLI, kita panggil manual:
  // import 'package:flutter/widgets.dart';
  // WidgetsFlutterBinding.ensureInitialized();
  // Untuk demo langsung, kita akan simulasi tanpa Flutter binding lengkap
  // Ini mungkin tidak bekerja persis di environment CLI Dart
  // Untuk hasil terbaik, jalankan ini di proyek Flutter yang sebenarnya.

  // NOTE: Jika menjalankan ini sebagai Dart CLI, Anda mungkin perlu mengadaptasi
  // atau menjalankan di lingkungan Flutter test/main app.
  // Untuk demonstasi, kita asumsikan init berhasil.
  print('--- SQLite `sqflite` Demo ---');

  final dbHelper = TodoDatabaseHelper();

  // Hapus database lama jika ada (untuk demo bersih)
  await TodoDatabaseHelper.deleteDatabaseFile(); // Reset database
  await dbHelper.database; // Ini akan memicu _initDatabase dan _onCreate

  print('\n--- Create (Insert) ---');
  final todo1 = Todo(title: 'Belajar Flutter', description: 'Selesaikan modul persistensi data.');
  final id1 = await dbHelper.insertTodo(todo1);

  final todo2 = Todo(title: 'Buat Aplikasi To-Do', description: 'Dengan SQLite dan Dio.', isCompleted: false);
  final id2 = await dbHelper.insertTodo(todo2);

  final todo3 = Todo(title: 'Baca Dokumentasi Sqflite', description: 'Pahami fitur-fitur lanjutan.', isCompleted: true);
  final id3 = await dbHelper.insertTodo(todo3);

  print('\n--- Read All ---');
  List<Todo> todos = await dbHelper.getTodos();
  todos.forEach(print);

  print('\n--- Read by ID (ID $id1) ---');
  Todo? fetchedTodo = await dbHelper.getTodoById(id1);
  print(fetchedTodo);

  print('\n--- Update (ID $id1) ---');
  final updatedTodo1 = Todo(id: id1, title: 'Belajar Flutter Dasar', description: 'Selesaikan modul persistensi data.', isCompleted: true);
  await dbHelper.updateTodo(updatedTodo1);
  fetchedTodo = await dbHelper.getTodoById(id1);
  print('Updated: $fetchedTodo');

  print('\n--- Delete (ID $id2) ---');
  await dbHelper.deleteTodo(id2);
  todos = await dbHelper.getTodos();
  print('Todos after deletion:');
  todos.forEach(print);

  print('\n--- Bulk Insert ---');
  final newTodos = [
    Todo(title: 'Membeli susu', description: 'Di supermarket dekat rumah.'),
    Todo(title: 'Membayar tagihan', description: 'Listrik dan internet.'),
    Todo(title: 'Olahraga pagi', description: 'Lari 30 menit.', isCompleted: true),
  ];
  await dbHelper.bulkInsert(newTodos);
  todos = await dbHelper.getTodos();
  print('Todos after bulk insert:');
  todos.forEach(print);

  await dbHelper.close(); // Tutup database
}
```

**Penjelasan Konteks Kode:**

1.  **`Todo` Model:**

    - Kelas Dart yang merepresentasikan satu baris dalam tabel `todos`. Ini adalah POJO (Plain Old Java Object) atau POCO (Plain Old C\# Object) versi Dart.
    - **`toMap()`:** Mengonversi objek `Todo` menjadi `Map<String, dynamic>`, format yang dibutuhkan `sqflite` untuk operasi `insert` dan `update`. Perhatikan konversi `bool` menjadi `int` (0 atau 1) karena SQLite tidak memiliki tipe data boolean natif.
    - **`fromMap()`:** `factory constructor` yang mengonversi `Map<String, dynamic>` yang diterima dari `sqflite` menjadi objek `Todo`. Perhatikan konversi `int` kembali menjadi `bool`.

2.  **`TodoDatabaseHelper` Class:**

    - Mengimplementasikan pola **Singleton** (`static Database? _database;`) untuk memastikan hanya ada satu instance database di seluruh aplikasi, menghindari masalah konkurensi.
    - **`_initDatabase()`:** Fungsi asinkron yang membuka atau membuat database.
      - `getDatabasesPath()` dari `path_provider`: Mendapatkan jalur standar untuk menyimpan database di perangkat.
      - `join()` dari `path`: Menggabungkan jalur direktori dengan nama file database.
      - `openDatabase()`: Fungsi inti dari `sqflite`.
        - `version`: Nomor versi database. Penting untuk migrasi.
        - `onCreate`: Fungsi _callback_ yang dipanggil saat database baru pertama kali dibuat. Di sinilah Anda membuat tabel awal dengan pernyataan SQL `CREATE TABLE`.
        - `onUpgrade`: Fungsi _callback_ yang dipanggil saat `openDatabase` dengan `version` yang lebih tinggi dari yang sudah ada. Di sinilah Anda menangani migrasi skema database (misalnya, menambahkan kolom baru, mengubah tabel).

3.  **CRUD Operations:**

    - **`insertTodo()`:** Menggunakan `db.insert()`. Mengembalikan ID dari baris yang baru dibuat. `ConflictAlgorithm.replace` berarti jika Anda mencoba memasukkan dengan ID yang sudah ada, baris lama akan diganti.
    - **`getTodos()`:** Menggunakan `db.query()` untuk mengambil semua baris dari tabel. Mengembalikan `List<Map<String, dynamic>>`. Kemudian, di-_map_ ke `List<Todo>` menggunakan `Todo.fromMap()`.
    - **`getTodoById()`:** Menggunakan `db.query()` dengan klausa `where` dan `whereArgs` untuk mengambil baris spesifik. Ini adalah praktik terbaik untuk mencegah SQL Injection dengan menggunakan _prepared statements_ (`?` sebagai _placeholder_).
    - **`updateTodo()`:** Menggunakan `db.update()`. Membutuhkan `where` dan `whereArgs` untuk menentukan baris mana yang akan diperbarui.
    - **`deleteTodo()`:** Menggunakan `db.delete()`. Membutuhkan `where` dan `whereArgs` untuk menentukan baris mana yang akan dihapus.

4.  **`bulkInsert()` (Batch Operations):**

    - Menggunakan `db.transaction()` dan `db.batch()` untuk mengelompokkan banyak operasi `insert` (atau `update`, `delete`) ke dalam satu transaksi atomik. Ini secara signifikan meningkatkan performa untuk operasi massal.

5.  **`main()` Function:**

    - Menunjukkan alur penggunaan `TodoDatabaseHelper`.
    - `WidgetsFlutterBinding.ensureInitialized();` **penting** jika Anda menjalankan kode `sqflite` di luar konteks widget Flutter (`runApp()`). Ini memastikan _binding_ Flutter diinisialisasi sebelum plugin digunakan. (Di contoh CLI, ini dikomentari karena mungkin tidak sepenuhnya berfungsi tanpa _full Flutter environment_, tetapi konsepnya penting).
    - `await TodoDatabaseHelper.deleteDatabaseFile();` digunakan di demo untuk memastikan awal yang bersih setiap kali kode dijalankan.

**Visualisasi Diagram Alur/Struktur:**

- **Database Schema:** Diagram tabel `todos` dengan kolom `id`, `title`, `description`, `isCompleted` dan tipe datanya.
- **SQL Query Mapping:** Menunjukkan bagaimana `Todo` object diubah menjadi `Map` untuk `INSERT/UPDATE` dan bagaimana `Map` dari `SELECT` diubah menjadi `Todo` object.
- **Database Helper:** Representasi `TodoDatabaseHelper` sebagai jembatan antara aplikasi Flutter dan SQLite database.

**Terminologi Esensial:**

- **SQLite:** Mesin _database_ relasional lokal.
- **`sqflite`:** Paket Flutter untuk berinteraksi dengan SQLite.
- **CRUD:** Create, Read, Update, Delete (operasi dasar _database_).
- **SQL (Structured Query Language):** Bahasa untuk mengelola dan memanipulasi _database_ relasional.
- **Schema:** Struktur _database_, termasuk nama tabel, kolom, tipe data, dan hubungan.
- **Migration:** Proses memperbarui _schema database_ dari satu versi ke versi berikutnya tanpa kehilangan data yang ada.
- **`openDatabase()`:** Fungsi untuk membuka atau membuat file _database_.
- **`onCreate`:** _Callback_ saat _database_ pertama kali dibuat.
- **`onUpgrade`:** _Callback_ saat _database_ di-_upgrade_ ke versi baru.
- **`insert()`, `query()`, `update()`, `delete()`:** Metode `sqflite` untuk operasi CRUD.
- **`where`, `whereArgs`:** Parameter untuk memfilter hasil query dan mencegah SQL Injection.
- **Batch:** Sekumpulan operasi _database_ yang dieksekusi sebagai satu transaksi.
- **Transaction:** Urutan operasi _database_ yang diperlakukan sebagai satu unit kerja logis dan atomik.

**Sumber Referensi Lengkap:**

- [sqflite package (pub.dev)](https://pub.dev/packages/sqflite) - Dokumentasi resmi paket.
- [Flutter Cookbook: Persist data with SQLite](https://www.google.com/search?q=https://docs.flutter.dev/data-and-backend/local-data/sqlite) - Panduan resmi Flutter.
- [SQLite Tutorial](https://www.sqlitetutorial.net/) - Sumber daya umum untuk belajar SQL dasar SQLite.

**Tips dan Praktik Terbaik:**

- **Model-View-Controller (MVC) / Repository Pattern:** Untuk aplikasi yang lebih besar, pisahkan logika _database_ dari logika UI. Gunakan _repository pattern_ di mana `TodoDatabaseHelper` akan menjadi bagian dari _repository_ yang berinteraksi dengan _database_.
- **`PRIMARY KEY AUTOINCREMENT`:** Gunakan ini untuk kolom ID untuk secara otomatis menghasilkan ID unik untuk setiap baris baru.
- **Hindari SQL Injection:** Selalu gunakan `whereArgs` dengan `?` sebagai _placeholder_ dalam query `where`, bukan menyisipkan nilai langsung ke string SQL.
- **Asynchronous Operations:** Ingatlah bahwa semua operasi _database_ adalah asinkron dan memerlukan `async`/`await`.
- **Error Handling:** Bungkus operasi _database_ dengan blok `try-catch` untuk menangani _error_ (misalnya, _database_ tidak tersedia, _query_ tidak valid).
- **Database Versioning & Migrations:** Rencanakan versi _database_ Anda dengan hati-hati. Setiap kali Anda mengubah skema, tingkatkan nomor versi dan implementasikan logika migrasi di `onUpgrade`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `DatabaseException(database is closed) `

  - **Penyebab:** Anda mencoba melakukan operasi pada _database_ setelah Anda memanggil `db.close()`.
  - **Solusi:** Pastikan Anda hanya memanggil `db.close()` ketika Anda yakin tidak ada lagi operasi _database_ yang akan dilakukan (misalnya, saat aplikasi dimatikan), atau pastikan untuk membuka kembali database jika diperlukan. Dalam sebagian besar aplikasi, database tetap terbuka selama aplikasi berjalan.

- **Kesalahan:** Tabel tidak ditemukan atau kolom tidak ada.

  - **Penyebab:** Kesalahan penulisan nama tabel/kolom dalam SQL, atau `onCreate` belum dipicu karena database sudah ada dengan versi lama.
  - **Solusi:** Periksa kembali nama tabel dan kolom. Pastikan Anda telah meningkatkan `version` database di `openDatabase` jika Anda mengubah skema dan menjalankan kembali aplikasi (atau hapus file database untuk memaksa `onCreate`).

- **Kesalahan:** Data tidak konsisten setelah pembaruan skema.

  - **Penyebab:** Logika di `onUpgrade` tidak menangani migrasi dari versi lama ke versi baru dengan benar.
  - **Solusi:** Uji migrasi secara menyeluruh. Pastikan setiap `onUpgrade` dapat mengelola transisi dari versi `oldVersion` apa pun ke `newVersion`. Seringkali, Anda akan memiliki blok `if (oldVersion < X)` untuk menjalankan skrip migrasi yang diperlukan.

- **Kesalahan:** Performa lambat saat menyisipkan/memperbarui banyak data.

  - **Penyebab:** Melakukan banyak operasi `insert`/`update` satu per satu tanpa menggunakan `Batch`.
  - **Solusi:** Gunakan `db.transaction()` dan `batch` untuk operasi massal.

---

#### 5.4.3 Hive/Isar (NoSQL Local Database)

Sub-bagian ini akan memperkenalkan dua solusi _NoSQL local database_ yang populer dan sangat berkinerja tinggi di ekosistem Flutter: Hive dan Isar. Keduanya menawarkan alternatif yang menarik untuk SQLite, terutama untuk data yang tidak memerlukan struktur relasional yang ketat.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami perbedaan mendasar antara _relational_ dan _NoSQL database_. Mereka akan mempelajari konsep "boxes" di Hive dan "collections" di Isar, serta cara menyimpan, membaca, memperbarui, dan menghapus objek Dart secara langsung tanpa perlu konversi `toMap()`/`fromMap()` manual seperti di `sqflite`. Ini akan memberikan gambaran lengkap tentang opsi persistensi data lokal di Flutter, memungkinkan mereka memilih alat yang paling tepat untuk skenario yang berbeda.

**Konsep Kunci & Filosofi Mendalam:**

- **NoSQL Database:** Menyimpan data dalam format yang tidak terstruktur atau semi-terstruktur, tidak memerlukan skema yang tetap, dan tidak menggunakan tabel, baris, dan kolom tradisional. Umumnya, data disimpan sebagai dokumen (JSON-like), pasangan kunci-nilai, atau grafik.

  - **Filosofi:** Fleksibilitas, skalabilitas horizontal (terutama di server-side NoSQL), dan kecepatan untuk data yang tidak kaku secara skema atau saat relasi data tidak menjadi fokus utama.

- **Hive:** _NoSQL database_ yang sangat cepat dan ringan, cocok untuk aplikasi seluler. Ini menyimpan data dalam "boxes" (mirip tabel di SQL atau koleksi di MongoDB) dan mendukung penyimpanan objek Dart langsung menggunakan _TypeAdapters_.

  - **Filosofi:** Kemudahan penggunaan, performa tinggi, dan jejak memori yang kecil. Ideal untuk _caching_, data pengaturan, dan data yang tidak terlalu kompleks.

- **Isar:** _NoSQL database_ yang lebih baru dan berkinerja lebih tinggi, merupakan generasi penerus dari Hive. Isar menawarkan _query_ yang kuat, dukungan transaksi, dan kemampuan _listening_ terhadap perubahan data (`Stream`).

  - **Filosofi:** Kombinasi performa ekstrim, _query_ yang kaya fitur, dan API yang mudah digunakan, menjadikannya pilihan solid untuk sebagian besar kebutuhan _local database_ di Flutter, terutama untuk data yang lebih besar dan _query_ yang lebih canggih daripada yang bisa ditawarkan Hive.

- **TypeAdapters (Hive) / @Collection & @Id (Isar):** Mekanisme untuk menginstruksikan _database_ cara menserialisasi dan deserialisasi objek Dart kustom.

  - **Filosofi:** Menghilangkan _boilerplate_ konversi data, memungkinkan pengembang untuk bekerja langsung dengan objek Dart native.

- **Reactive Programming with Databases:** Isar secara khusus menawarkan _stream_ dari _query_ yang memungkinkan UI Anda bereaksi secara otomatis terhadap perubahan data di _database_.

  - **Filosofi:** Mempermudah membangun UI yang dinamis dan _real-time_ yang selalu sinkron dengan data yang mendasarinya.

**Visualisasi Diagram Alur/Struktur:**

- **Perbandingan Database:** Diagram Venn atau tabel perbandingan: `SharedPreferences` (Simple KV) vs `sqflite` (Relational SQL) vs `Hive/Isar` (NoSQL Object/Document).
- **Hive Architecture:** Aplikasi -\> Hive -\> Boxes -\> Data (Objects).
- **Isar Architecture:** Aplikasi -\> Isar Instance -\> Collections -\> Objects -\> Query Engine.
- Flow **`@HiveType`/`@IsarCollection`** -\> `build_runner` -\> Generated Code -\> Database.

**Hubungan dengan Modul Lain:**
Melengkapi `5.2 HTTP Requests & REST APIs` dan `5.3 Advanced API Integration` untuk _caching_ data API secara efisien. Dapat berinteraksi dengan `Fase 6: State Management` karena perubahan pada _local database_ dapat memicu pembaruan _state_ UI, terutama dengan fitur _stream_ di Isar.

---

**Sintaks Dasar / Contoh Implementasi Inti (Hive dan Isar):**

Untuk mendemonstrasikan kedua database, kita akan menggunakan contoh data `Task` sederhana.

### Hive (Contoh Kode)

Tambahkan dependensi di `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3 # Periksa versi terbaru di pub.dev
  hive_flutter: ^1.1.0 # Untuk integrasi Flutter
  path_provider: ^2.1.3

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

Kemudian jalankan `flutter pub get`. Setelah itu, Anda perlu menjalankan `flutter pub run build_runner build` untuk menghasilkan _TypeAdapter_.

```dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Untuk initFlutter
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// --- 1. Model Data dengan @HiveType ---
// Untuk Hive, kita perlu mendeklarasikan TypeAdapter dan menjalankan build_runner
part 'hive_isar_demo.g.dart'; // File yang akan di-generate oleh build_runner

@HiveType(typeId: 0) // typeId harus unik untuk setiap model Hive
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  @override
  String toString() {
    return 'Task(key: $key, title: $title, description: $description, isCompleted: $isCompleted)';
  }
}

// --- 2. Database Helper untuk Hive ---
class HiveDatabaseHelper {
  static const String taskBoxName = 'tasks'; // Nama box

  // Inisialisasi Hive
  static Future<void> init() async {
    // Di Flutter, gunakan Hive.initFlutter()
    await Hive.initFlutter();

    // Pastikan path untuk desktop/CLI
    if (kIsWeb) {
      // Tidak mendukung path di web
    } else if (defaultTargetPlatform == TargetPlatform.android ||
               defaultTargetPlatform == TargetPlatform.iOS ||
               defaultTargetPlatform == TargetPlatform.macOS ||
               defaultTargetPlatform == TargetPlatform.windows ||
               defaultTargetPlatform == TargetPlatform.linux) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(p.join(appDocumentDir.path, 'hive_data'));
    } else {
      // Fallback untuk platform lain atau CLI jika diperlukan
      Hive.init(''); // Menggunakan direktori saat ini jika tidak ada path tertentu
    }

    Hive.registerAdapter(TaskAdapter()); // Daftarkan TypeAdapter yang di-generate
    print('Hive initialized and TaskAdapter registered.');
  }

  // Buka Box
  static Future<Box<Task>> openTaskBox() async {
    return await Hive.openBox<Task>(taskBoxName);
  }

  // --- Operasi CRUD Hive ---

  // Create/Update: Menambahkan atau memperbarui Task
  static Future<void> addTask(Task task) async {
    final box = await openTaskBox();
    await box.add(task); // Menambahkan item baru, Hive akan memberikan key otomatis
    // Atau: await box.put(task.key, task); untuk update/insert dengan key spesifik
    print('Added task: $task');
  }

  // Read: Mendapatkan semua Task
  static Future<List<Task>> getTasks() async {
    final box = await openTaskBox();
    return box.values.toList();
  }

  // Read: Mendapatkan Task berdasarkan key
  static Future<Task?> getTaskByKey(dynamic key) async {
    final box = await openTaskBox();
    return box.get(key);
  }

  // Update: Memperbarui Task yang sudah ada
  static Future<void> updateTask(Task task) async {
    final box = await openTaskBox();
    if (task.key != null) {
      await box.put(task.key, task); // HiveObject memiliki properti key
      print('Updated task with key ${task.key}: $task');
    } else {
      print('Error: Task has no key, cannot update. Use addTask() for new tasks.');
    }
  }

  // Delete: Menghapus Task berdasarkan key
  static Future<void> deleteTask(dynamic key) async {
    final box = await openTaskBox();
    await box.delete(key);
    print('Deleted task with key: $key');
  }

  // Clear Box
  static Future<void> clearAllTasks() async {
    final box = await openTaskBox();
    await box.clear();
    print('All tasks cleared from Hive.');
  }

  // Close Box (optional, Hive mengelola sendiri sebagian besar)
  static Future<void> closeHive() async {
    await Hive.close();
    print('Hive boxes closed.');
  }
}
```

### Isar (Contoh Kode)

Tambahkan dependensi di `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  isar: ^3.1.0+1 # Periksa versi terbaru di pub.dev
  isar_flutter_libs: ^3.1.0+1 # Untuk library platform spesifik
  path_provider: ^2.1.3

dev_dependencies:
  isar_generator: ^3.1.0+1
  build_runner: ^2.4.6
```

Kemudian jalankan `flutter pub get`. Setelah itu, Anda perlu menjalankan `flutter pub run build_runner build` untuk menghasilkan _Isar schema files_.

```dart
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// --- 1. Model Data dengan @Collection ---
// Untuk Isar, kita perlu mendeklarasikan @collection dan @Id, lalu menjalankan build_runner
part 'hive_isar_demo.g.dart'; // File yang akan di-generate oleh build_runner

@collection // Mendeklarasikan ini sebagai Isar collection
class TaskIsar {
  Id id = Isar.autoIncrement; // ID unik, Isar akan otomatis mengisi

  @Index(type: IndexType.hash) // Contoh: Index untuk query yang lebih cepat berdasarkan title
  String title;

  String description;
  bool isCompleted;

  TaskIsar({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  @override
  String toString() {
    return 'TaskIsar(id: $id, title: $title, description: $description, isCompleted: $isCompleted)';
  }
}

// --- 2. Database Helper untuk Isar ---
class IsarDatabaseHelper {
  static late Isar _isar;

  // Inisialisasi Isar
  static Future<void> init() async {
    if (kIsWeb) {
      // Isar tidak mendukung persistence di web secara default
      _isar = await Isar.open(
        [TaskIsarSchema],
        directory: '', // Di web, path kosong
        inspector: true, // Untuk menggunakan Isar Inspector
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [TaskIsarSchema],
        directory: p.join(dir.path, 'isar_data'),
        inspector: true, // Aktifkan Isar Inspector untuk debugging
      );
    }
    print('Isar initialized.');
  }

  // Getter Isar instance
  static Isar get isar => _isar;

  // --- Operasi CRUD Isar ---

  // Create: Menambahkan Task baru
  static Future<int> addTask(TaskIsar task) async {
    int id = -1;
    await _isar.writeTxn(() async { // Semua operasi write harus dalam transaksi
      id = await _isar.taskIsars.put(task); // Menyimpan objek TaskIsar
    });
    print('Added task: $task with ID: $id');
    return id;
  }

  // Read: Mendapatkan semua Task
  static Future<List<TaskIsar>> getTasks() async {
    return await _isar.taskIsars.where().findAll(); // Query semua objek
  }

  // Read: Mendapatkan Task berdasarkan ID
  static Future<TaskIsar?> getTaskById(int id) async {
    return await _isar.taskIsars.get(id);
  }

  // Update: Memperbarui Task yang sudah ada
  static Future<bool> updateTask(TaskIsar task) async {
    bool success = false;
    await _isar.writeTxn(() async {
      success = await _isar.taskIsars.put(task); // put akan update jika ID ada
    });
    print('Updated task with ID ${task.id}: $task');
    return success;
  }

  // Delete: Menghapus Task berdasarkan ID
  static Future<bool> deleteTask(int id) async {
    bool deleted = false;
    await _isar.writeTxn(() async {
      deleted = await _isar.taskIsars.delete(id);
    });
    print('Deleted task with ID: $id. Success: $deleted');
    return deleted;
  }

  // Delete All (Clear Collection)
  static Future<int> clearAllTasks() async {
    int count = 0;
    await _isar.writeTxn(() async {
      count = await _isar.taskIsars.clear();
    });
    print('Cleared $count tasks from Isar.');
    return count;
  }

  // --- Query Lanjutan (Contoh) ---
  static Future<List<TaskIsar>> getCompletedTasks() async {
    return await _isar.taskIsars.filter().isCompletedEqualTo(true).findAll();
  }

  static Future<List<TaskIsar>> searchTasksByTitle(String query) async {
    return await _isar.taskIsars.filter().titleContains(query, caseSensitive: false).findAll();
  }

  // Close Isar instance
  static Future<void> closeIsar() async {
    await _isar.close();
    print('Isar instance closed.');
  }

  // Clean Isar files (for testing or reset)
  static Future<void> cleanIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    final isarDir = p.join(dir.path, 'isar_data');
    if (await Isar.instanceNames.contains('isar_data')) { // Check if the instance exists
      await Isar.open([TaskIsarSchema], directory: isarDir).then((value) => value.close(deleteFromDisk: true));
    }
    print('Isar database files cleaned.');
  }
}
```

**Main Demo Function (Untuk menjalankan kedua contoh)**

```dart
// Untuk running di main() tanpa Flutter UI, perlu import ini
// import 'package:flutter/widgets.dart';

void main() async {
  // PENTING: Jika menjalankan di Dart CLI, ini diperlukan
  // Jika di proyek Flutter, ini otomatis oleh runApp()
  // WidgetsFlutterBinding.ensureInitialized(); // uncomment di proyek Flutter

  print('--- Hive Demo ---');
  await HiveDatabaseHelper.init();
  await HiveDatabaseHelper.clearAllTasks(); // Bersihkan data lama

  final hiveTask1 = Task(title: 'Belajar Hive', description: 'Pahami cara kerja TypeAdapter.', isCompleted: false);
  await HiveDatabaseHelper.addTask(hiveTask1);

  final hiveTask2 = Task(title: 'Buat Demo Hive', description: 'Implementasikan CRUD.', isCompleted: true);
  await HiveDatabaseHelper.addTask(hiveTask2);

  List<Task> hiveTasks = await HiveDatabaseHelper.getTasks();
  print('All Hive Tasks:');
  hiveTasks.forEach(print);

  if (hiveTasks.isNotEmpty) {
    hiveTasks[0].isCompleted = true;
    await HiveDatabaseHelper.updateTask(hiveTasks[0]);
    print('Updated Hive Task 0: ${await HiveDatabaseHelper.getTaskByKey(hiveTasks[0].key)}');

    await HiveDatabaseHelper.deleteTask(hiveTasks[1].key);
    print('Hive Tasks after delete: ${await HiveDatabaseHelper.getTasks()}');
  }
  await HiveDatabaseHelper.closeHive(); // Tutup box setelah selesai


  print('\n--- Isar Demo ---');
  await IsarDatabaseHelper.cleanIsar(); // Bersihkan data lama
  await IsarDatabaseHelper.init();

  final isarTask1 = TaskIsar(title: 'Pelajari Isar', description: 'Pahami Collection dan Query.', isCompleted: false);
  await IsarDatabaseHelper.addTask(isarTask1);

  final isarTask2 = TaskIsar(title: 'Buat Aplikasi Isar', description: 'Dengan Reactive Query.', isCompleted: false);
  await IsarDatabaseHelper.addTask(isarTask2);

  final isarTask3 = TaskIsar(title: 'Integrasi Isar dengan Provider', description: 'Untuk State Management.', isCompleted: true);
  await IsarDatabaseHelper.addTask(isarTask3);


  List<TaskIsar> isarTasks = await IsarDatabaseHelper.getTasks();
  print('All Isar Tasks:');
  isarTasks.forEach(print);

  if (isarTasks.isNotEmpty) {
    // Update Isar Task (gunakan ID dari TaskIsar yang sudah ada)
    isarTasks[0].isCompleted = true;
    await IsarDatabaseHelper.updateTask(isarTasks[0]);
    print('Updated Isar Task 0: ${await IsarDatabaseHelper.getTaskById(isarTasks[0].id)}');

    print('Completed Isar Tasks: ${await IsarDatabaseHelper.getCompletedTasks()}');
    print('Search "Aplikasi": ${await IsarDatabaseHelper.searchTasksByTitle('Aplikasi')}');

    await IsarDatabaseHelper.deleteTask(isarTasks[1].id);
    print('Isar Tasks after delete: ${await IsarDatabaseHelper.getTasks()}');
  }

  await IsarDatabaseHelper.closeIsar(); // Tutup instance Isar
}
```

**Penjelasan Konteks Kode:**

### Hive

1.  **Dependencies:** `hive`, `hive_flutter`, `path_provider`, `hive_generator`, `build_runner`.
2.  **Model (`Task`)**:
    - Meng-extend `HiveObject` (opsional, tetapi memudahkan update/delete).
    - Anotasi `@HiveType(typeId: 0)`: Memberi tahu Hive bahwa kelas ini adalah tipe yang dapat disimpan. `typeId` harus unik untuk setiap model.
    - Anotasi `@HiveField(0)`: Menandai properti sebagai field yang akan disimpan di Hive, dengan nomor field unik.
    - **PENTING:** Setelah membuat atau mengubah model dengan `@HiveType` dan `@HiveField`, Anda harus menjalankan `flutter pub run build_runner build` di terminal untuk menghasilkan file `hive_isar_demo.g.dart` yang berisi `TypeAdapter` untuk `Task`.
3.  **`HiveDatabaseHelper`:**
    - **`init()`:** Menginisialisasi Hive (gunakan `Hive.initFlutter()` untuk Flutter), mendaftarkan `TaskAdapter()` (yang di-_generate_), dan secara opsional mengatur path untuk penyimpanan data.
    - **`openTaskBox()`:** Membuka "box" bernama `tasks`. Sebuah box adalah unit penyimpanan utama di Hive, mirip dengan tabel di SQL atau koleksi di NoSQL.
    - **CRUD:**
      - `box.add(task)`: Untuk menambahkan objek baru, Hive akan memberikan kunci otomatis (integritas melalui `HiveObject.key`).
      - `box.put(key, task)`: Untuk menyimpan objek dengan kunci spesifik (insert atau update).
      - `box.get(key)`: Mengambil objek berdasarkan kuncinya.
      - `box.values.toList()`: Mengambil semua objek dalam box.
      - `box.delete(key)`: Menghapus objek berdasarkan kuncinya.
      - `box.clear()`: Menghapus semua objek dalam box.
    - `HiveObject`: Jika model Anda meng-extend `HiveObject`, Anda mendapatkan properti `key` dan metode `save()` serta `delete()` langsung pada objek itu sendiri, menyederhanakan operasi update/delete.

### Isar

1.  **Dependencies:** `isar`, `isar_flutter_libs`, `path_provider`, `isar_generator`, `build_runner`.
2.  **Model (`TaskIsar`)**:
    - Anotasi `@collection`: Memberi tahu Isar bahwa kelas ini adalah _collection_ yang dapat disimpan.
    - `Id id = Isar.autoIncrement;`: Mendeklarasikan properti ID yang akan diatur secara otomatis oleh Isar.
    - Anotasi `@Index(type: IndexType.hash)`: Menginstruksikan Isar untuk membuat indeks pada field `title`, yang akan mempercepat _query_ berdasarkan `title`.
    - **PENTING:** Setelah membuat atau mengubah model dengan `@collection`, Anda harus menjalankan `flutter pub run build_runner build` di terminal untuk menghasilkan file `hive_isar_demo.g.dart` yang berisi skema Isar.
3.  **`IsarDatabaseHelper`:**
    - **`init()`:** Menginisialisasi Isar dengan membuka _database_. Anda perlu menyediakan daftar `Schema` (misalnya `[TaskIsarSchema]`) yang di-_generate_ oleh `isar_generator`. `inspector: true` mengaktifkan Isar Inspector untuk _debugging_ visual.
    - **Transaksi Penulisan (`_isar.writeTxn(() async { ... });`)**: Semua operasi yang mengubah data (insert, update, delete, clear) **harus** dilakukan di dalam transaksi penulisan. Ini memastikan integritas data dan performa.
    - **CRUD:**
      - `_isar.taskIsars.put(task)`: Menyimpan objek `TaskIsar`. Jika objek memiliki `id` yang sudah ada, itu akan diperbarui; jika tidak, itu akan disisipkan. Mengembalikan ID dari objek yang disimpan.
      - `_isar.taskIsars.where().findAll()`: Mengambil semua objek dalam _collection_.
      - `_isar.taskIsars.get(id)`: Mengambil objek berdasarkan ID-nya.
      - `_isar.taskIsars.delete(id)`: Menghapus objek berdasarkan ID-nya.
      - `_isar.taskIsars.clear()`: Menghapus semua objek dalam _collection_.
    - **Query Lanjutan:** Isar menawarkan API _query_ yang sangat kuat dan fasih (fluent API), seperti `filter().isCompletedEqualTo(true)` atau `filter().titleContains(query)`.
    - **`closeIsar()`:** Menutup instance Isar.
    - **`cleanIsar()`:** Metode _utility_ untuk menghapus file database Isar dari disk (berguna untuk _testing_).

**Visualisasi Diagram Alur/Struktur:**

- **Hive Model Binding:** Kelas Dart `Task` -\> `@HiveType`, `@HiveField` -\> `hive_generator` -\> `TaskAdapter` -\> Hive Box.
- **Isar Model Binding:** Kelas Dart `TaskIsar` -\> `@collection`, `@Id`, `@Index` -\> `isar_generator` -\> `TaskIsarSchema` -\> Isar Collection.
- **Write Transactions:** Diagram kotak yang menunjukkan operasi tulis (put, delete, clear) harus berada di dalam blok transaksi `writeTxn`.
- **Query Flow:** `Isar.instance.collection.filter().someCondition().findAll()`

**Terminologi Esensial:**

- **NoSQL:** _Database_ non-relasional, tidak memerlukan skema tetap.
- **Hive:** _NoSQL key-value database_ yang ringan dan cepat untuk Flutter.
- **Box (Hive):** Unit penyimpanan data di Hive, mirip dengan tabel.
- **`TypeAdapter` (Hive):** Kelas yang dihasilkan untuk mengonversi objek Dart ke format yang dapat disimpan Hive dan sebaliknya.
- **Isar:** _NoSQL database_ yang sangat cepat dengan _querying_ yang kuat untuk Flutter, pengganti yang disarankan untuk Hive di banyak kasus.
- **Collection (Isar):** Unit penyimpanan data di Isar, mirip dengan tabel.
- **`@collection` (Isar):** Anotasi untuk menandai kelas model sebagai Isar _collection_.
- **`Id` (Isar):** Properti ID unik untuk objek di Isar.
- **`@Index` (Isar):** Anotasi untuk membuat indeks pada field, mempercepat _query_.
- **`writeTxn` (Isar):** Transaksi penulisan yang wajib untuk semua operasi modifikasi data.
- **`filter()` (Isar):** Metode untuk memulai pembangunan _query_ yang kompleks.
- **`build_runner`:** Alat Dart yang menjalankan _code generators_ (seperti `hive_generator` dan `isar_generator`).

**Sumber Referensi Lengkap:**

- [Hive (pub.dev)](https://www.google.com/search?q=https://pub.dev/packages/hive)
- [tautan mencurigakan telah dihapus]
- [Isar (pub.dev)](https://www.google.com/search?q=https://pub.dev/packages/isar)
- [Isar Documentation](https://www.google.com/search?q=https://isar.dev/docs/introduction.html)

**Tips dan Praktik Terbaik:**

- **Pilih Alat yang Tepat:**

  - **`shared_preferences`:** Untuk pengaturan aplikasi sederhana, _flag_, atau data yang sangat kecil.
  - **`Hive`:** Untuk _caching_ cepat, data yang tidak relasional, atau aplikasi yang sangat ringan yang membutuhkan performa tinggi tanpa _overhead_ SQL.
  - **`Isar`:** Untuk sebagian besar kasus penggunaan _local database_ di aplikasi Flutter modern. Menawarkan performa ekstrem, _query_ yang kuat, dan API yang reaktif. Lebih disarankan daripada `sqflite` jika Anda tidak membutuhkan relasi kompleks atau migrasi skema SQL.
  - **`sqflite`:** Jika Anda secara khusus membutuhkan _database_ relasional dengan _full SQL power_ (join, foreign keys, complex transactions) dan terbiasa dengan SQL.

- **Jalankan Code Generator:** Selalu ingat untuk menjalankan `flutter pub run build_runner build` setiap kali Anda membuat atau mengubah model data untuk Hive atau Isar. Gunakan `flutter pub run build_runner watch` untuk otomatisasi selama pengembangan.

- **Error Handling:** Meskipun Hive dan Isar lebih _robust_, tetap gunakan `try-catch` di sekitar operasi _database_ Anda untuk menangani potensi _error_ seperti masalah I/O atau _database_ yang tidak tersedia.

- **Isar Inspector:** Manfaatkan Isar Inspector (tersedia saat `inspector: true` di `Isar.open()`) untuk memvisualisasikan data Anda, menjalankan _query_, dan _debugging_.

- **Transaksi Isar:** Jangan pernah lupa untuk membungkus operasi penulisan Isar di dalam `_isar.writeTxn(() async { ... });`. Ini krusial untuk integritas data.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `MissingPluginException` atau `No generator found for collection.`

  - **Penyebab:** Lupa menjalankan `flutter pub run build_runner build` setelah membuat atau memodifikasi model Hive (`@HiveType`) atau Isar (`@collection`).
  - **Solusi:** Jalankan perintah `build_runner` dan pastikan file `.g.dart` ter-_generate_ dan di-_import_ (`part 'your_file.g.dart';`).

- **Kesalahan (Hive):** `HiveError: Hive not initialized.`

  - **Penyebab:** Anda mencoba menggunakan Hive (misalnya, membuka box) sebelum memanggil `Hive.initFlutter()` atau `Hive.init()`.
  - **Solusi:** Pastikan `Hive.initFlutter()` dipanggil di `main()` sebelum `runApp()`, atau di `init` method dari helper class Anda.

- **Kesalahan (Isar):** `IsarError: Database has already been opened.`

  - **Penyebab:** Anda mencoba memanggil `Isar.open()` lebih dari sekali. Isar dirancang sebagai _singleton_.
  - **Solusi:** Implementasikan pola _singleton_ atau pastikan `Isar.open()` hanya dipanggil sekali di seluruh siklus hidup aplikasi Anda. Periksa `Isar.instanceNames.isNotEmpty` sebelum membuka Isar lagi.

- **Kesalahan (Isar):** `IsarError: All database operations must be performed inside a transaction.`

  - **Penyebab:** Anda mencoba memanggil operasi penulisan Isar (misalnya `put`, `delete`, `clear`) di luar blok `_isar.writeTxn(() async { ... });`.
  - **Solusi:** Pastikan semua operasi penulisan dibungkus dalam `_isar.writeTxn()`.

---

Dengan ini, kita telah menyelesaikan penjelasan mendalam yang menandai selesainya seluruh bagian **FASE 5: Asynchronous Programming & API Integration**.

# Selamat!

Anda sekarang memiliki pemahaman yang kuat tentang bagaimana menangani operasi asinkron, berinteraksi dengan API eksternal, dan menyimpan data secara lokal di Flutter. Ini adalah fondasi penting untuk membangun aplikasi yang kuat dan responsif.

---

Kita telah menyelesaikan FASE 5. Selanjutnya kita akan masuk pada **FASE 6: State Management**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

<!----------------------------------------------------->

[0]: ../README.md#fase-5-forms--input-handling
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
