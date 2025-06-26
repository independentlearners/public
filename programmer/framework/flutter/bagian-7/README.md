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
- [Fetch data from the internet (Flutter documentation)](https://www.google.com/search?q=https://docs.flutter.dev/data-and-backend/networking/fetch-data) - Panduan resmi Flutter tentang fetching data.
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
