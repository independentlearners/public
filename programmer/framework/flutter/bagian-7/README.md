# [FASE 5: Asynchronous Programming & API Integration][0]

<details>
  <summary>📃 Struktur Daftar Isi</summary>

- [5.1 Asynchronous Programming in Dart](#51-asynchronous-programming-in-dart)
  - [5.1.1 Futures (`async`/`await`)](#511-futures-asyncawait)
  - [5.1.2 Streams (Basic Concepts)](#512-streams-basic-concepts)
  - [5.1.3 Error Handling (`try-catch-finally`)](#513-error-handling-try-catch-finally)
- [5.2 HTTP Requests & REST APIs](#52-http-requests--rest-apis)
  - [5.2.1 Understanding RESTful Principles](#521-understanding-restful-principles)
  - [5.2.2 Making Basic HTTP Requests (`http` package)](#522-making-basic-http-requests-http-package)
  - [5.2.3 Handling JSON (Serialization/Deserialization)](#523-handling-json-serializationdeserialization)
- [5.3 Advanced API Integration](#53-advanced-api-integration)
  - [5.3.1 Dio (Advanced HTTP Client)](#531-dio-advanced-http-client)
  - [5.3.2 Error Handling & Interceptors](#532-error-handling--interceptors)
  - [5.3.3 Working with Authentication (Tokens)](#533-working-with-authentication-tokens)
- [5.4 Local Data Persistence](#54-local-data-persistence)
  - [5.4.1 Shared Preferences (Simple Key-Value)](#541-shared-preferences-simple-key-value)
  - [5.4.2 SQLite (via `sqflite` package)](#542-sqlite-via-sqflite-package)
  - [5.4.3 Hive/Isar (NoSQL Local Database)](#543-hiveisar-nosql-local-database)

---

</details>

#

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
