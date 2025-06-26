# [FASE 6: State Management][0]

Dengan selesainya **FASE 5: Asynchronous Programming & API Integration**, kita akan melangkah ke salah satu pilar utama dalam pengembangan aplikasi Flutter: **FASE 6: State Management**.

---

Pengelolaan _state_ adalah inti dari setiap aplikasi _reactive_ modern. Ini menentukan bagaimana data aplikasi Anda mengalir, bagaimana UI Anda merespons perubahan data, dan bagaimana kompleksitas dapat dikelola seiring pertumbuhan aplikasi.

Berikut adalah struktur terperinci untuk **FASE 6: State Management**:

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- [FASE 6: State Management](#fase-6-state-management)
      - [6.1 Pengenalan Konsep State Management](#61-pengenalan-konsep-state-management)
      - [**Visualisasi Diagram Alur/Struktur:**](#visualisasi-diagram-alurstruktur)
      - [6.2 Local State Management (`setState`)](#62-local-state-management-setstate)
      - [6.2.1 Menggunakan `setState` pada `StatefulWidget`](#621-menggunakan-setstate-pada-statefulwidget)
      - [6.2.2 Keterbatasan `setState` untuk Skala Besar](#622-keterbatasan-setstate-untuk-skala-besar)
    - [6.3 Provider Package](#63-provider-package)
      - [6.3.1 Dasar-dasar `Provider`, `Consumer`, `Selector`](#631-dasar-dasar-provider-consumer-selector)
      - [6.3.2 Jenis-jenis Provider (`ChangeNotifierProvider`, `FutureProvider`, `StreamProvider`, dll.)](#632-jenis-jenis-provider-changenotifierprovider-futureprovider-streamprovider-dll)
      - [6.3.3 MultiProvider dan Best Practices](#633-multiprovider-dan-best-practices)
    - [6.4 Riverpod Package](#64-riverpod-package)
      - [6.4.1 Pengenalan Konsep Riverpod (Providers, Consumers, Scoping)](#641-pengenalan-konsep-riverpod-providers-consumers-scoping)
      - [6.4.2 StateNotifierProvider, FutureProvider, StreamProvider di Riverpod](#642-statenotifierprovider-futureprovider-streamprovider-di-riverpod)
      - [6.4.3 Menggunakan `ConsumerWidget` dan `ConsumerStatefulWidget`](#643-menggunakan-consumerwidget-dan-consumerstatefulwidget)
      - [6.4.4 Keunggulan Riverpod (Compile-time Safety, Testing)](#644-keunggulan-riverpod-compile-time-safety-testing)
    - [6.5 BLoC (Business Logic Component) / Cubit](#65-bloc-business-logic-component--cubit)
      - [6.5.1 Filosofi BLoC dan Cubit](#651-filosofi-bloc-dan-cubit)
      - [6.5.2 Events, States, dan Streams](#652-events-states-dan-streams)
- [Selamat!](#selamat)

</details>

---

#### 6.1 Pengenalan Konsep State Management

Sub-bagian ini adalah fondasi untuk memahami seluruh FASE 6. Ini akan memperkenalkan apa itu _state_, mengapa pengelolaannya penting dalam aplikasi Flutter, dan berbagai tantangan yang muncul jika tidak ditangani dengan baik.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mendapatkan pemahaman konseptual yang kuat tentang _state_ dalam konteks UI deklaratif Flutter. Mereka akan membedakan antara _state_ lokal (ephemeral) dan _state_ global (app state), serta mengidentifikasi masalah umum yang dipecahkan oleh solusi _state management_. Ini akan meletakkan dasar yang kokoh sebelum menyelami implementasi spesifik dari berbagai solusi.

**Konsep Kunci & Filosofi Mendalam:**

- **UI Deklaratif (Flutter's Philosophy):** Di Flutter, UI Anda adalah fungsi dari _state_ Anda. Ketika _state_ berubah, Flutter secara otomatis membangun ulang (re-build) bagian UI yang terpengaruh.

  - **Filosofi:** Menyederhanakan pengembangan UI dengan berfokus pada _what_ (deskripsi UI berdasarkan _state_) daripada _how_ (langkah-langkah untuk mengubah UI).

- #### **Apa itu "State"?**

  - _State_ adalah data yang dapat berubah seiring waktu dan memengaruhi tampilan atau perilaku UI Anda. Ini bisa berupa data dari _server_, input pengguna, status _loading_, _error message_, atau bahkan ukuran widget.
  - **Filosofi:** _State_ adalah "memori" aplikasi Anda. Tanpa _state_, aplikasi tidak akan interaktif atau dinamis.

- #### **Mengapa "State Management" Penting?**

  - **Kompleksitas:** Seiring pertumbuhan aplikasi, jumlah _state_ dan widget yang bergantung padanya akan meningkat. Tanpa strategi pengelolaan yang jelas, kode menjadi tidak terorganisir, sulit dipahami, dan rentan terhadap _bug_.
  - **Data Flow:** Memastikan data mengalir dengan benar antara widget, dari _parent_ ke _child_ dan sebaliknya, atau antar widget yang tidak berhubungan.
  - **Performa:** Meminimalkan pembangunan ulang widget yang tidak perlu untuk menjaga aplikasi tetap cepat dan responsif.
  - **Maintainability & Testability:** Membuat kode lebih mudah untuk dibaca, diubah, dan diuji.
  - **Filosofi:** Mengelola _state_ adalah tentang mengelola kompleksitas. Ini adalah arsitektur data aplikasi Anda.

- #### **Jenis-jenis State:**

  - **Ephemeral State (Local State / Widget-specific State):** _State_ yang hanya relevan untuk satu widget tertentu atau sebagian kecil dari UI, dan tidak perlu dipertahankan setelah widget dihancurkan atau direfresh. Contoh: status _checkbox_, nilai teks di `TextField`, status animasi.
    - **Filosofi:** _State_ ini bersifat sementara dan terlokalisasi, tidak perlu diakses oleh banyak bagian aplikasi. `setState` adalah solusi utama untuk ini.
  - **App State (Global State / Shared State):** _State_ yang perlu dibagikan di banyak bagian aplikasi, dipertahankan bahkan setelah widget dihancurkan, atau data yang berasal dari sumber eksternal (API, database). Contoh: data pengguna yang login, keranjang belanja, pengaturan tema aplikasi, hasil _fetching_ data.
    - **Filosofi:** _State_ ini merupakan "memori global" aplikasi, penting untuk konsistensi di seluruh aplikasi. Membutuhkan solusi _state management_ eksternal (Provider, Riverpod, BLoC, dll.).

- #### **Tantangan dalam State Management:**

  - **Prop Drilling:** Meneruskan data melalui banyak lapisan widget _parent-child_ yang tidak membutuhkannya, hanya agar bisa mencapai widget yang membutuhkannya di bawah.
  - **Widget Rebuilds:** Membangun ulang seluruh pohon widget meskipun hanya sebagian kecil _state_ yang berubah, mengakibatkan performa buruk.
  - **Data Synchronization:** Memastikan bahwa beberapa widget yang bergantung pada _state_ yang sama selalu menampilkan data yang konsisten.
  - **Separation of Concerns:** Memisahkan _business logic_ (bagaimana _state_ berubah) dari _UI logic_ (bagaimana _state_ ditampilkan).
  - **Filosofi:** Mengatasi tantangan ini adalah tujuan utama dari berbagai paket _state management_, yang masing-masing menawarkan pendekatan unik.

#### **Visualisasi Diagram Alur/Struktur:**

- **Deklaratif UI:** Diagram: `State` -\> (Transformasi) -\> `UI`. Panah kembali dari `User Action` -\> `Change State`.
- **Ephemeral vs App State:** Diagram hirarki widget. Ephemeral State ada di dalam satu widget. App State menyebar dan dapat diakses dari mana saja.
- **Prop Drilling:** Diagram panah data yang panjang melewati banyak kotak widget di tengah.
- **Separation of Concerns:** Diagram kotak: `UI Layer` \<-\> `State Management Layer` \<-\> `Business Logic Layer` \<-\> `Data Layer (API/DB)`.

**Hubungan dengan Modul Lain:**
Ini adalah fondasi untuk semua modul selanjutnya yang melibatkan data dan UI. Berkaitan erat dengan `5.1 Asynchronous Programming` (saat _state_ diperbarui dari operasi asinkron) dan `5.2/5.3 API Integration` (data API menjadi bagian dari _app state_). Juga relevan dengan `Fase 7: Navigation & Routing` (bagaimana _state_ dipertahankan antar halaman).

---

**Sintaks Dasar / Contoh Implementasi Inti (Konseptual):**

Tidak ada kode "implementasi" di sini karena ini adalah bagian konseptual. Fokusnya adalah pada pemahaman filosofi. Namun, kita bisa menunjukkan _placeholder_ untuk perbandingan.

```dart
// Contoh Konseptual Ephemeral State (akan dijelaskan lebih detail di 6.2)
// State hanya hidup di dalam Widget ini.
class MyCounterWidget extends StatefulWidget {
  const MyCounterWidget({super.key});

  @override
  State<MyCounterWidget> createState() => _MyCounterWidgetState();
}

class _MyCounterWidgetState extends State<MyCounterWidget> {
  int _counter = 0; // Ephemeral State

  void _incrementCounter() {
    setState(() { // Rebuilds only this widget
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $_counter'),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}

// Contoh Konseptual App State (akan dijelaskan di 6.3 dan seterusnya)
// State ini perlu diakses dan diubah oleh banyak widget di aplikasi.
// Misalnya, keranjang belanja atau status login pengguna.

// class ShoppingCartNotifier with ChangeNotifier { // Contoh dengan Provider
//   List<Item> _items = [];
//   // ... metode untuk menambah/menghapus item, notifyListeners()
// }

// class UserAuthRepository { // Contoh dengan BLoC/Cubit
//   // ... metode login/logout
// }

// Widget A
// Widget B // Keduanya perlu mengakses/mengubah data keranjang belanja
```

**Penjelasan Konteks Kode (Konseptual):**

- **`MyCounterWidget`:** Mendemonstrasikan _ephemeral state_ dengan `_counter`. Perubahan pada `_counter` hanya memengaruhi `MyCounterWidget` itu sendiri. Jika widget ini dihapus dari pohon widget, `_counter` juga akan hilang.
- **Komentar untuk `ShoppingCartNotifier` atau `UserAuthRepository`:** Ini adalah _placeholder_ untuk konsep _app state_. Data yang dipegang oleh kelas-kelas ini (misalnya, daftar item di keranjang atau status login) perlu diakses dan dimanipulasi dari berbagai bagian aplikasi, bukan hanya satu widget. Ini membenarkan penggunaan solusi _state management_ eksternal.

**Terminologi Esensial:**

- **State:** Data yang berubah dan memengaruhi UI.
- **UI Deklaratif:** Gaya pemrograman UI di mana Anda menggambarkan UI berdasarkan _state_, bukan langkah-langkah untuk mengubahnya.
- **Rebuild:** Proses di mana Flutter membangun kembali (dan mungkin menggambar ulang) bagian dari pohon widget karena perubahan _state_.
- **Ephemeral State:** _State_ lokal untuk satu widget, tidak perlu dibagikan atau dipertahankan.
- **App State / Global State:** _State_ yang perlu dibagikan di banyak widget dan dipertahankan.
- **Prop Drilling:** Mengalirkan data melalui banyak _parent_ yang tidak relevan.
- **Separation of Concerns:** Pemisahan _business logic_ dari _UI logic_.
- **Reactive Programming:** Paradigma di mana perubahan data otomatis memicu pembaruan pada entitas yang bergantung padanya (misalnya, UI).

**Sumber Referensi Lengkap:**

- [Managing State (Flutter documentation)](https://docs.flutter.dev/data-and-backend/state-mgmt/options) - Titik awal resmi Flutter.
- [Provider package (Flutter documentation)](https://www.google.com/search?q=https://docs.flutter.dev/data-and-backend/state-mgmt/options/provider) - Memperkenalkan konsep Provider sebagai solusi sederhana.
- [Ephemeral State vs App State (Flutter documentation)](https://docs.flutter.dev/data-and-backend/state-mgmt/ephemeral-vs-app) - Perbedaan kunci antara dua jenis _state_.

**Tips dan Praktik Terbaik:**

- **Pikirkan Dulu Tentang State:** Sebelum menulis kode, identifikasi _state_ apa yang Anda butuhkan dan bagaimana _state_ itu akan berubah.
- **Start Simple (`setState`):** Untuk _state_ yang sangat lokal dan sederhana, mulai dengan `setState`. Jangan terburu-buru menggunakan solusi _state management_ yang kompleks jika tidak diperlukan.
- **Definisikan Batasan State:** Tentukan dengan jelas apakah sebuah _state_ adalah _ephemeral_ atau _app state_. Ini akan memandu pilihan Anda terhadap solusi _state management_.
- **Separasi Logika:** Usahakan untuk memisahkan _business logic_ dari widget UI Anda. Ini akan membuat kode lebih mudah diuji dan dikelola.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menggunakan `setState` untuk _app state_ yang dibagikan secara luas.

  - **Penyebab:** Menyebabkan _prop drilling_, _rebuild_ yang tidak perlu, dan kesulitan dalam mengelola data yang sinkron di banyak widget.
  - **Solusi:** Identifikasi _state_ yang perlu dibagikan dan gunakan solusi _state management_ yang sesuai (Provider, Riverpod, BLoC, dll.).

- **Kesalahan:** Tidak ada _state_ sama sekali (menggunakan `StatelessWidget` untuk semuanya).

  - **Penyebab:** UI tidak dapat merespons interaksi pengguna atau perubahan data.
  - **Solusi:** Kenali kapan sebuah widget membutuhkan _state_ internal dan kapan _state_ harus dikelola secara eksternal.

- **Kesalahan:** _Rebuild_ yang tidak efisien atau _jank_ UI.

  - **Penyebab:** Banyak widget di-rebuild ulang tanpa alasan, seringkali karena _state_ berubah di level yang terlalu tinggi di pohon widget.
  - **Solusi:** Gunakan alat _debugging_ Flutter untuk menganalisis _rebuild_. Solusi _state management_ yang lebih canggih menawarkan kontrol yang lebih baik atas _rebuild_ (misalnya, `Selector` di Provider, `BlocBuilder` di BLoC).

---

#### 6.2 Local State Management (`setState`)

Sub-bagian ini akan membahas metode paling dasar dan fundamental untuk mengelola _state_ di Flutter: `setState` dalam konteks `StatefulWidget`. Ini adalah titik awal bagi setiap pengembang Flutter untuk memahami bagaimana UI merespons perubahan data secara lokal.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar kapan dan bagaimana menggunakan `StatefulWidget` dan metode `setState()` untuk memperbarui _state_ internal sebuah widget dan memicu pembangunan ulang UI yang relevan. Mereka akan memahami siklus hidup dasar `StatefulWidget` dan bagaimana `setState` cocok di dalamnya. Bagian ini juga akan menyoroti batasan pendekatan ini untuk skenario aplikasi yang lebih kompleks, menjadi jembatan menuju solusi _state management_ yang lebih canggih.

**Konsep Kunci & Filosofi Mendalam:**

- **`StatefulWidget` vs. `StatelessWidget`:**

  - **`StatelessWidget`:** Widget yang tidak memiliki _state_ yang dapat berubah seiring waktu. Propertinya `final`. UI-nya statis setelah dibangun. Contoh: `Text`, `Icon`, `AppBar`.
    - **Filosofi:** Hemat sumber daya karena tidak perlu melacak perubahan. Ideal untuk elemen UI yang hanya tergantung pada properti yang diberikan saat pembuatan.
  - **`StatefulWidget`:** Widget yang memiliki _state_ yang dapat berubah selama masa pakainya.
    - **Filosofi:** Memungkinkan UI untuk menjadi interaktif dan dinamis, merespons input pengguna atau perubahan data dari waktu ke waktu.

- **`State` Object:**

  - `StatefulWidget` itu sendiri _immutable_ (tidak dapat diubah) dan tidak memiliki _state_ yang berubah. Sebaliknya, ia membuat objek `State` yang dapat diubah. Objek `State` inilah yang menampung _state_ yang sebenarnya dan bertanggung jawab untuk membangun bagian dari pohon widget.
  - **Filosofi:** Pemisahan antara konfigurasi widget (di `StatefulWidget`) dan _state_ yang dapat diubah (di objek `State`) memungkinkan Flutter untuk mengoptimalkan pembangunan ulang dan mempertahankan _state_ antar _rebuild_.

- **Metode `setState()`:**

  - Ini adalah metode inti yang dipanggil dalam objek `State` untuk memberi tahu _framework_ Flutter bahwa _state_ telah berubah dan UI yang bergantung pada _state_ tersebut harus dibangun ulang.
  - `setState` menjadwalkan pembangunan ulang widget dengan memanggil metode `build()` dari objek `State` tersebut di _frame_ berikutnya.
  - **Filosofi:** Ini adalah mekanisme "pemicu" untuk reaktivitas UI di Flutter. Anda mengubah _state_ lalu memanggil `setState` untuk "menarik perhatian" Flutter.

- **Build Method (`Widget build(BuildContext context)`)**:

  - Dipanggil setiap kali widget perlu digambar ulang. Di sinilah Anda mendefinisikan struktur UI berdasarkan _state_ saat ini.
  - **Filosofi:** Karena Flutter bersifat deklaratif, `build()` harus menjadi _pure function_ dari _state_. Artinya, dengan _state_ yang sama, `build()` harus selalu menghasilkan UI yang sama.

- **Lifecycle of `StatefulWidget`:** Memahami urutan metode yang dipanggil selama masa pakai `StatefulWidget` (`initState`, `didChangeDependencies`, `build`, `didUpdateWidget`, `deactivate`, `dispose`). `setState` memengaruhi bagian `build`.

  - **Filosofi:** Mengelola sumber daya dengan benar dan melakukan inisialisasi/pembersihan yang tepat.

**Visualisasi Diagram Alur/Struktur:**

- **`StatefulWidget` vs `StatelessWidget`**: Dua kotak terpisah, satu dengan `final` dan satu dengan `State` objek dan `setState`.
- **`setState` Flow**: `User Action` (e.g., tap button) -\> `_incrementCounter()` -\> `setState(() { _counter++; });` -\> Flutter marks widget as dirty -\> Next frame, Flutter calls `build()` -\> UI updated.
- **Lifecycle Diagram**: Diagram lingkaran atau panah yang menunjukkan urutan `initState`, `build`, `setState` (loop ke `build`), `dispose`.

**Hubungan dengan Modul Lain:**
Ini adalah dasar dari semua _state management_ dan terkait erat dengan `6.1 Pengenalan Konsep State Management`. Konsep _rebuild_ yang dipicu oleh `setState` adalah fundamental untuk memahami performa UI di Flutter.

---

#### 6.2.1 Menggunakan `setState` pada `StatefulWidget`

```dart
import 'package:flutter/material.dart';

// Aplikasi Utama
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'setState Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

// Stateful Widget Contoh: Counter
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // Ini adalah ephemeral state dari widget ini
  String _message = "Halo, Flutter!"; // Contoh state lain

  // Metode untuk memperbarui _counter
  void _incrementCounter() {
    // setState akan memicu Flutter untuk memanggil kembali metode build()
    // sehingga UI akan diperbarui dengan nilai _counter yang baru.
    setState(() {
      _counter++;
      _message = "Counter diperbarui: $_counter";
      print('Counter diperbarui menjadi: $_counter');
    });
  }

  // Metode untuk mengubah pesan
  void _changeMessage() {
    setState(() {
      _message = "Pesan baru: ${DateTime.now().second}";
      print('Pesan diperbarui menjadi: $_message');
    });
  }

  // Lifecycle Method: Dipanggil sekali saat State object dibuat
  @override
  void initState() {
    super.initState();
    print('initState() dipanggil');
    // Ideal untuk inisialisasi data atau setup listeners
    // Jangan panggil setState di sini karena build() belum dipanggil
  }

  // Lifecycle Method: Dipanggil saat dependencies dari State object berubah
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies() dipanggil');
    // Ideal untuk mengakses InheritedWidget
  }

  // Lifecycle Method: Dipanggil setiap kali widget memerlukan re-build
  @override
  Widget build(BuildContext context) {
    print('build() dipanggil'); // Perhatikan berapa kali ini dipanggil
    return Scaffold(
      appBar: AppBar(
        title: const Text('setState Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Anda telah menekan tombol ini sebanyak:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              _message, // Teks ini juga akan diperbarui
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Text('Tambah Counter'),
                ),
                ElevatedButton(
                  onPressed: _changeMessage,
                  child: const Text('Ubah Pesan'),
                ),
              ],
            ),
          ],
        ),
      ),
      // FloatingActionButton juga memicu setState
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Lifecycle Method: Dipanggil ketika widget baru dibuat dengan runtimeType yang sama
  // dan Key yang sama seperti widget yang lama, tetapi properti widget berubah.
  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget() dipanggil');
    // Berguna untuk merespons perubahan properti dari parent widget
  }

  // Lifecycle Method: Dipanggil ketika State object dihapus dari pohon widget
  // (misalnya, widget tidak lagi terlihat atau diganti)
  @override
  void deactivate() {
    super.deactivate();
    print('deactivate() dipanggil');
  }

  // Lifecycle Method: Dipanggil ketika State object akan dihapus secara permanen.
  // Ideal untuk membersihkan sumber daya (misalnya, controllers, listeners).
  @override
  void dispose() {
    print('dispose() dipanggil');
    super.dispose();
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`MyApp` (StatelessWidget):** Ini adalah _root_ aplikasi dan tidak memiliki _state_ yang berubah. Ini hanya berfungsi sebagai wadah untuk `MyHomePage`.
2.  **`MyHomePage` (StatefulWidget):**
    - Mendeklarasikan bahwa widget ini memiliki _state_ yang dapat berubah.
    - Metode `createState()` harus di-_override_ untuk mengembalikan instance dari objek `State` yang terkait (`_MyHomePageState`).
3.  **`_MyHomePageState` (State Object):**
    - Ini adalah kelas yang menyimpan _state_ yang sebenarnya (`_counter` dan `_message`). Variabel-variabel ini **bukan `final`** karena nilainya akan berubah.
    - **`_incrementCounter()` dan `_changeMessage()`:** Metode ini mengubah nilai `_counter` dan `_message`. Yang terpenting, keduanya memanggil `setState(() { ... });`.
    - **Fungsi `setState`:** Argumen untuk `setState` adalah _callback_ (fungsi tanpa argumen dan tanpa nilai kembali). Di dalam _callback_ inilah Anda harus melakukan semua perubahan pada _state_ internal. Setelah _callback_ selesai dieksekusi, Flutter akan menandai widget sebagai "kotor" (dirty) dan menjadwalkan pembangunan ulang (re-build) untuk _frame_ berikutnya.
    - **`build(BuildContext context)`:** Metode ini dipanggil setiap kali Flutter memutuskan bahwa widget perlu digambar ulang. Di sinilah `_counter` dan `_message` yang diperbarui digunakan untuk membangun UI yang mencerminkan _state_ terbaru. Perhatikan `print('build() dipanggil');` yang akan membantu Anda melihat seberapa sering `build()` dipanggil.
    - **Lifecycle Methods:** Contoh juga menyertakan beberapa metode _lifecycle_ umum dari `State` (`initState`, `didChangeDependencies`, `didUpdateWidget`, `deactivate`, `dispose`) dengan `print` untuk membantu memahami alur hidup widget.

**Visualisasi Diagram Alur/Struktur:**

- Ketika tombol `Tambah Counter` ditekan:
  - `onPressed` memanggil `_incrementCounter()`.
  - `_incrementCounter()` memanggil `setState()`.
  - Di dalam `setState()`, `_counter` diperbarui.
  - `setState()` memberi tahu Flutter bahwa `_MyHomePageState` perlu dibangun ulang.
  - Pada _frame_ berikutnya, Flutter memanggil `build()` dari `_MyHomePageState`.
  - `Text('$_counter')` sekarang menampilkan nilai `_counter` yang baru, dan UI diperbarui di layar.

---

#### 6.2.2 Keterbatasan `setState` untuk Skala Besar

Meskipun `setState` sangat powerful dan mudah digunakan untuk _state_ lokal, ia memiliki keterbatasan signifikan saat digunakan untuk mengelola _app state_ dalam aplikasi skala besar:

- **Prop Drilling:** Jika _state_ perlu diakses oleh widget yang jauh di bawah pohon widget, Anda harus meneruskan _state_ dan _callback_ perubahan melalui banyak _constructor_ widget menengah. Ini membuat kode berantakan, sulit dibaca, dan rentan _error_.

  - **Contoh:** Jika `_counter` dari `MyHomePage` perlu diakses atau diubah oleh `AnotherDeeplyNestedWidget` yang berada di 5 tingkat di bawah.

- **Widget Rebuilds yang Tidak Efisien:** `setState` memicu pembangunan ulang seluruh `StatefulWidget` tempat ia dipanggil, beserta semua _child_ yang ada di dalam metode `build()`-nya (kecuali jika _child_ tersebut adalah `const` atau menggunakan `keys` dengan bijak, atau jika Flutter dapat mengoptimalkannya). Ini bisa menyebabkan banyak widget yang tidak perlu di-rebuild, mengurangi performa, terutama dengan pohon widget yang besar.

  - **Contoh:** Jika `MyHomePage` memiliki banyak _child_ lain yang statis dan tidak bergantung pada `_counter` atau `_message`, mereka tetap akan di-rebuild setiap kali `setState` dipanggil.

- **Keterpisahan Logika (Separation of Concerns) yang Buruk:** Logika bisnis yang mengubah _state_ (misalnya, `_incrementCounter()`) seringkali tercampur langsung di dalam kelas `State` bersama dengan logika UI. Ini menyulitkan pengujian logika bisnis secara terpisah dari UI.

  - **Contoh:** Jika `_incrementCounter` menjadi sangat kompleks (misalnya, melibatkan panggilan API, validasi), itu akan membuat kelas `_MyHomePageState` menjadi gemuk dan sulit diatur.

- **Pengelolaan State yang Kompleks:** Untuk _state_ yang memiliki banyak dependensi, atau yang perlu disinkronkan di berbagai bagian aplikasi (misalnya, _user authentication status_, _shopping cart_), `setState` menjadi tidak praktis. Tidak ada cara mudah untuk "mendapatkan" _state_ dari widget lain atau "memberi tahu" widget lain tentang perubahan.

  - **Contoh:** Bagaimana cara `LoginPage` memberi tahu `HomeScreen` bahwa pengguna sudah login tanpa menggunakan sistem `callback` yang rumit?

**Visualisasi Batasan:**

- **Prop Drilling**: Ilustrasi `Widget A` memiliki data `x`, meneruskannya ke `Widget B`, yang meneruskannya ke `Widget C`, yang akhirnya menggunakan `x`. `B` dan `C` tidak peduli dengan `x`.
- **Rebuild Scope**: Lingkaran besar `StatefulWidget` dengan `setState` di dalamnya, dan beberapa lingkaran _child_. Ketika `setState` dipanggil, seluruh lingkaran besar berkedip (re-build), meskipun hanya satu lingkaran kecil di dalamnya yang berubah.

**Terminologi Esensial (Baru):**

- **Prop Drilling:** Situasi di mana data dilewatkan melalui beberapa tingkat komponen perantara yang tidak benar-benar membutuhkan data tersebut.

**Sumber Referensi Lengkap:**

- [StatefulWidget class (api.flutter.dev)](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
- [State class (api.flutter.dev)](https://api.flutter.dev/flutter/widgets/State-class.html)
- [setState method (api.flutter.dev)](https://api.flutter.dev/flutter/widgets/State/setState.html)
- [Flutter documentation: `setState`](<https://docs.flutter.dev/data-and-backend/state-mgmt/options/setstate%5D(https://docs.flutter.dev/data-and-backend/state-mgmt/options/setstate)>)

**Tips dan Praktik Terbaik:**

- **Gunakan untuk Ephemeral State:** `setState` adalah pilihan terbaik untuk _state_ yang sangat lokal, seperti:
  - Status _checkbox_ atau _toggle_.
  - Nilai teks yang sedang diketik dalam `TextField`.
  - Status _loading_ sementara untuk operasi yang sangat lokal.
  - Animasi sederhana.
- **Minimalisir Lingkup Rebuild:** Coba letakkan `StatefulWidget` serendah mungkin di pohon widget untuk meminimalkan bagian UI yang di-rebuild.
- **Single Responsibility Principle:** Usahakan agar `State` object Anda tidak menjadi terlalu besar atau memiliki terlalu banyak tanggung jawab. Jika _business logic_ mulai menjadi kompleks, itu adalah sinyal untuk beralih ke solusi _state management_ yang lebih canggih.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mengubah _state_ di luar `setState()`.

  - **Penyebab:** Anda mengubah variabel _state_ (misalnya, `_counter++`) tetapi lupa memanggil `setState()`. UI tidak akan diperbarui.
  - **Solusi:** Selalu bungkus semua perubahan _state_ yang perlu memicu pembangunan ulang UI di dalam `setState(() { ... });`.

- **Kesalahan:** Memanggil `setState()` di `initState()` (tanpa penundaan atau _async_).

  - **Penyebab:** `setState` di `initState` bisa memicu _error_ atau perilaku tak terduga karena _framework_ masih dalam proses pembangunan widget awal.
  - **Solusi:** Jangan panggil `setState` secara langsung di `initState()`. Jika Anda perlu memperbarui _state_ setelah inisialisasi (misalnya, dari operasi asinkron), gunakan `Future.microtask(() => setState(() { ... }));` atau panggil `setState` setelah `await` sebuah `Future`.

- **Kesalahan:** Terlalu banyak _rebuild_ karena `setState` dipanggil di level tinggi.

  - **Penyebab:** Meletakkan `StatefulWidget` dan `setState` terlalu tinggi di pohon widget, menyebabkan seluruh cabang di-rebuild bahkan jika hanya _child_ di bagian bawah yang berubah.
  - **Solusi:** Strukturkan aplikasi Anda sehingga `StatefulWidget` (dan karenanya `setState`) hanya mencakup bagian UI yang benar-benar perlu bereaksi terhadap _state_ lokalnya. Untuk _app state_, beralihlah ke solusi _state management_ eksternal yang dibahas di bagian berikutnya.

---

### 6.3 Provider Package

Sub-bagian ini akan membahas `provider` package, salah satu solusi _state management_ yang paling populer dan direkomendasikan di komunitas Flutter. `provider` adalah _wrapper_ yang menyederhanakan penggunaan `InheritedWidget`, sehingga mempermudah akses _state_ di seluruh pohon widget.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bagaimana `provider` memecahkan masalah _prop drilling_ dan mengoptimalkan _rebuild_ widget. Mereka akan belajar cara menyediakan _state_ (menggunakan berbagai jenis `Provider`) dan cara mengkonsumsi _state_ (menggunakan `Consumer`, `Selector`, `context.watch`, `context.read`). Dengan ini, mereka dapat membangun aplikasi Flutter dengan _app state_ yang terorganisir dan efisien.

**Konsep Kunci & Filosofi Mendalam:**

- **Dependency Injection (DI):** `provider` menggunakan konsep DI, di mana _dependencies_ (dalam hal ini, _state_ atau objek _business logic_) disediakan dari atas pohon widget dan dapat diakses oleh widget di bawahnya tanpa harus meneruskannya secara eksplisit melalui _constructor_.

  - **Filosofi:** Membuat komponen lebih independen, mudah diuji, dan mengurangi _boilerplate_ (seperti _prop drilling_).

- **`InheritedWidget` (Under the Hood):** `provider` dibangun di atas `InheritedWidget`. `InheritedWidget` adalah _widget_ Flutter yang memungkinkan _child widget_ untuk mengakses data dari _ancestor widget_ secara efisien.

  - **Filosofi:** `InheritedWidget` adalah cara Flutter menyediakan data secara efisien ke sub-pohon. `provider` hanya membuat penggunaan `InheritedWidget` menjadi jauh lebih mudah dan ekspresif.

- **Change Notifiers:** `provider` seringkali digunakan bersama dengan `ChangeNotifier` dari Flutter. `ChangeNotifier` adalah kelas yang dapat memberi tahu _listener_-nya ketika ada perubahan.

  - **Filosofi:** Memungkinkan _observer pattern_, di mana _state_ dapat diubah di satu tempat dan semua widget yang "mendengarkan" perubahan tersebut akan diperbarui secara otomatis. Ini adalah dasar reaktivitas di Provider.

- **Separation of Concerns:** `provider` mendorong pemisahan antara _business logic_ (di dalam kelas _provider_ yang meng-extend `ChangeNotifier`) dan UI (di widget yang mengkonsumsi _state_).

  - **Filosofi:** Meningkatkan _maintainability_, _testability_, dan _readability_ kode.

- **Scoped Access:** _State_ yang disediakan oleh `provider` hanya dapat diakses oleh widget di sub-pohon di bawah `Provider` tersebut.

  - **Filosofi:** Mengontrol lingkup _state_, mencegah akses yang tidak disengaja dan mempermudah _debugging_.

**Visualisasi Diagram Alur/Struktur:**

- Diagram Pohon Widget: `Provider` di atas -\> Widget tengah (tidak peduli) -\> `Consumer` di bawah mengambil data. Panah data mengalir dari `Provider` ke `Consumer` secara "tersembunyi".
- Diagram `ChangeNotifier` Flow: `User Action` -\> `ChangeNotifier Method` -\> _State update_ -\> `notifyListeners()` -\> `Consumer`/`Selector` listens -\> UI rebuilds.

**Hubungan dengan Modul Lain:**
Sangat erat kaitannya dengan `6.1 Pengenalan Konsep State Management` (memecahkan masalah _prop drilling_, _rebuild_). Memanfaatkan `5.1 Asynchronous Programming` dan `5.2/5.3 API Integration` karena `Provider` dapat dengan mudah mengelola _state_ yang berasal dari operasi asinkron atau panggilan API (`FutureProvider`, `StreamProvider`).

---

#### 6.3.1 Dasar-dasar `Provider`, `Consumer`, `Selector`

Untuk menggunakan `provider`, tambahkan dependensi di `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2 # Periksa versi terbaru di pub.dev
```

Kemudian jalankan `flutter pub get`.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider

// --- 1. Definisi Model Data atau Business Logic (ChangeNotifier) ---
// Kelas ini akan menampung state yang dapat berubah dan memberi tahu listener.
class CounterModel extends ChangeNotifier {
  int _count = 0; // State privat

  int get count => _count; // Getter untuk mengakses state

  void increment() {
    _count++;
    notifyListeners(); // Beri tahu semua widget yang mendengarkan perubahan ini
    print('Counter incremented to: $_count');
  }

  void decrement() {
    _count--;
    notifyListeners();
    print('Counter decremented to: $_count');
  }
}

// Aplikasi Utama
void main() {
  runApp(
    // MultiProvider digunakan jika ada lebih dari satu Provider.
    // Di sini kita menyediakan instance CounterModel ke seluruh aplikasi.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterModel()),
        // ChangeNotifierProvider(create: (context) => AnotherModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

// --- 2. Widget yang Mengonsumsi State ---

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('HomeScreen built'); // Perhatikan berapa kali ini dibangun
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Basic Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Nilai Counter:',
            ),
            // Menggunakan Consumer untuk hanya merebuild bagian tertentu dari pohon widget
            // yang bergantung pada perubahan state.
            Consumer<CounterModel>(
              builder: (context, counter, child) {
                print('Consumer built (count: ${counter.count})'); // Hanya ini yang rebuild
                return Text(
                  '${counter.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 20),
            // Widget lain yang tidak bergantung pada CounterModel tidak akan direbuild
            const Text('Ini teks lain yang tidak berubah.'),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Menggunakan context.read untuk mengakses metode tanpa mendengarkan perubahan.
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterModel>().decrement();
                  },
                  child: const Text('Kurangi'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterModel>().increment();
                  },
                  child: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const SeparatedWidget(), // Widget yang menggunakan Selector
            const SizedBox(height: 30),
            // Contoh lain penggunaan context.watch (singkatan dari Consumer)
            // Text('Counter (via context.watch): ${context.watch<CounterModel>().count}'),
          ],
        ),
      ),
    );
  }
}

class SeparatedWidget extends StatelessWidget {
  const SeparatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print('SeparatedWidget built');
    return Column(
      children: [
        const Text('Nilai Ganjil/Genap (via Selector):'),
        // Menggunakan Selector untuk hanya merebuild ketika nilai tertentu berubah.
        // Dalam kasus ini, hanya saat status ganjil/genap berubah, bukan setiap kali count berubah.
        Selector<CounterModel, bool>(
          selector: (context, counter) => counter.count.isEven, // Hanya dengarkan perubahan isEven
          builder: (context, isEven, child) {
            print('Selector built (isEven: $isEven)'); // Hanya ini yang rebuild
            return Text(
              isEven ? 'Genap' : 'Ganjil',
              style: const TextStyle(fontSize: 20, color: Colors.purple),
            );
          },
        ),
      ],
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`CounterModel` (`ChangeNotifier`):**

    - Ini adalah kelas yang menampung _state_ (`_count`) dan _business logic_ (`increment`, `decrement`).
    - Meng-extend `ChangeNotifier` dari `foundation` library.
    - Memanggil `notifyListeners()` setelah setiap perubahan _state_ untuk memberi tahu semua widget yang sedang mendengarkan.

2.  **`MultiProvider` di `main()`:**

    - `Provider` perlu ditempatkan di atas pohon widget agar _child_-nya dapat mengakses _state_ yang disediakan.
    - `MultiProvider` digunakan untuk menyediakan beberapa _provider_ sekaligus, membuatnya lebih bersih daripada menumpuk `Provider` secara individual.
    - `ChangeNotifierProvider(create: (context) => CounterModel())`: Ini adalah jenis _provider_ yang paling umum. Ia membuat instance `CounterModel` dan menyediakannya ke semua _child_ di bawahnya. `create` _callback_ dipanggil sekali saat _provider_ pertama kali dibuat.

3.  **`MyApp` & `HomeScreen`:**

    - `MyApp` adalah _root_ aplikasi.
    - `HomeScreen` adalah widget yang akan menampilkan dan memanipulasi _state_ dari `CounterModel`.

4.  **Mengonsumsi State:** Ada beberapa cara untuk mengonsumsi _state_ dengan `provider`:

    - **`Consumer<T>`:**

      - Widget khusus yang secara otomatis mendengarkan perubahan pada `T` (dalam hal ini, `CounterModel`).
      - Metode `builder` dipanggil kembali setiap kali `notifyListeners()` dipanggil dari `CounterModel`.
      - Ini adalah cara yang efisien untuk merebuild hanya bagian pohon widget yang benar-benar bergantung pada _state_ tersebut, bukan seluruh `HomeScreen`.
      - `child` parameter di `Consumer` digunakan untuk mengoptimalkan _rebuild_ (widget di `child` tidak akan di-rebuild).

    - **`context.watch<T>()`:** (Cara yang direkomendasikan untuk membaca dan mendengarkan perubahan di dalam `build` method)

      - Ini adalah _extension method_ pada `BuildContext`.
      - Sama seperti `Consumer`, ia membuat widget Anda mendengarkan perubahan pada `T`. Jika `T` berubah, widget yang memanggil `context.watch<T>()` akan di-rebuild.
      - Sangat ringkas dan sering digunakan.

    - **`context.read<T>()`:** (Cara yang direkomendasikan untuk mengakses _state_ atau memanggil metode tanpa mendengarkan perubahan)

      - Digunakan ketika Anda hanya perlu mengakses instance _provider_ untuk memanggil metode (seperti `increment()` atau `decrement()`) atau membaca nilai _sekali_ (misalnya, di dalam _callback_ `onPressed`), tanpa memicu _rebuild_ widget saat _state_ berubah.
      - Jangan gunakan `context.read` di dalam `build` method jika Anda ingin UI Anda diperbarui ketika _state_ berubah.

    - **`Selector<T, S>`:** (Untuk optimasi _rebuild_ yang lebih granular)

      - Mirip dengan `Consumer`, tetapi memungkinkan Anda untuk menentukan bagian _state_ yang spesifik (`S`) yang ingin Anda dengarkan.
      - Hanya akan memicu _rebuild_ jika bagian _state_ yang Anda "pilih" (`selector` _callback_) benar-benar berubah.
      - Contoh: di `SeparatedWidget`, `Selector` hanya akan merebuild jika `counter.count.isEven` berubah, bukan setiap kali `counter.count` berubah. Ini menghemat _rebuild_ jika `count` berubah dari 0 ke 1 (genap ke ganjil), tetapi tidak akan rebuild jika berubah dari 1 ke 2 (ganjil ke genap). Oh, tunggu, itu salah. Jika dari 1 ke 2, status ganjil/genapnya berubah. Jika dari 2 ke 4, status ganjil/genapnya tidak berubah, jadi tidak akan rebuild. Ini lebih tepatnya.

**Visualisasi Diagram Alur/Struktur:**

- Pohon Widget:
  ```
  MaterialApp
    └─ MultiProvider (CounterModel)
       └─ MyApp
          └─ HomeScreen
             ├─ Text (static)
             ├─ Consumer<CounterModel> (rebuilds only Text for count)
             ├─ Text (static)
             ├─ Row (buttons using context.read to call methods)
             └─ SeparatedWidget
                └─ Selector<CounterModel, bool> (rebuilds only Text for even/odd status)
  ```

**Terminologi Esensial:**

- **`provider` package:** Sebuah paket Flutter untuk _state management_ dan _dependency injection_, dibangun di atas `InheritedWidget`.
- **`ChangeNotifier`:** Sebuah kelas di Flutter yang dapat memberi tahu _listener_ ketika _state_ telah berubah.
- **`notifyListeners()`:** Metode yang dipanggil dalam `ChangeNotifier` untuk memicu _rebuild_ pada widget yang mendengarkan.
- **`Provider` (generic):** Widget yang menyediakan _instance_ dari objek ke sub-pohon di bawahnya.
- **`ChangeNotifierProvider`:** Jenis `Provider` yang paling umum, digunakan untuk menyediakan objek yang meng-extend `ChangeNotifier`.
- **`Consumer<T>`:** Widget yang mendengarkan perubahan pada objek `T` yang disediakan oleh `Provider`, dan merebuild bagian UI yang ditentukan dalam `builder` _callback_.
- **`context.watch<T>()`:** Metode ekstensi `BuildContext` untuk membaca objek `T` yang disediakan dan secara otomatis mendengarkan perubahannya.
- **`context.read<T>()`:** Metode ekstensi `BuildContext` untuk membaca objek `T` yang disediakan _sekali_ saja, tanpa mendengarkan perubahannya. Ideal untuk memanggil metode.
- **`Selector<T, S>`:** Versi `Consumer` yang lebih teroptimasi, yang hanya merebuild jika bagian spesifik dari _state_ (`S`) yang "dipilih" berubah.

**Sumber Referensi Lengkap:**

- [Provider package (pub.dev)](https://pub.dev/packages/provider) - Dokumentasi resmi paket.
- [Flutter documentation: Simple app state management (using Provider)](https://www.google.com/search?q=https://docs.flutter.dev/data-and-backend/state-mgmt/options/provider) - Panduan resmi Flutter.

**Tips dan Praktik Terbaik:**

- **Sekopkan Provider dengan Benar:** Tempatkan `Provider` setinggi mungkin di pohon widget sehingga semua widget yang memerlukannya dapat mengaksesnya. Namun, jangan meletakkannya terlalu tinggi jika _state_ hanya relevan untuk sebagian kecil aplikasi.
- **Gunakan `Consumer` atau `context.watch` untuk Mendengarkan:** Gunakan ini di dalam `build` method ketika Anda ingin UI diperbarui secara reaktif terhadap perubahan _state_.
- **Gunakan `context.read` untuk Memanggil Metode:** Gunakan ini di dalam _callback_ seperti `onPressed`, `onChanged`, `initState`, atau _method_ lain di luar `build` method ketika Anda hanya perlu memicu perubahan _state_ tanpa mendengarkan _rebuild_.
- **Optimalkan Rebuild dengan `Selector`:** Jika sebuah widget hanya bergantung pada sebagian kecil dari objek `ChangeNotifier` yang besar, gunakan `Selector` untuk mencegah _rebuild_ yang tidak perlu ketika bagian lain dari objek berubah.
- **Hindari `context.watch` di `initState`:** Anda tidak dapat menggunakan `context.watch` atau `context.read` di `initState` secara langsung karena `context` belum sepenuhnya siap untuk diakses secara reaktif. Gunakan `Future.microtask` atau `WidgetsBinding.instance.addPostFrameCallback` jika Anda harus mengakses _provider_ setelah _frame_ pertama, atau lebih baik lagi, gunakan `context.read` di dalam metode yang dipanggil dari _callback_ atau `Future.delayed`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `ProviderNotFoundException`.

  - **Penyebab:** Anda mencoba mengakses _provider_ (misalnya, `context.watch<CounterModel>()`) dari widget yang tidak berada di bawah `Provider` tersebut di pohon widget.
  - **Solusi:** Pastikan `Provider` yang sesuai ditempatkan lebih tinggi di pohon widget dari widget yang mencoba mengaksesnya. Periksa penempatan `MultiProvider` atau `ChangeNotifierProvider`.

- **Kesalahan:** UI tidak diperbarui setelah perubahan _state_.

  - **Penyebab:** Anda lupa memanggil `notifyListeners()` setelah mengubah _state_ di dalam `ChangeNotifier`, atau Anda menggunakan `context.read` di dalam `build` method padahal Anda ingin mendengarkan perubahan.
  - **Solusi:** Pastikan `notifyListeners()` dipanggil. Gunakan `Consumer` atau `context.watch` di `build` method jika Anda ingin widget bereaksi terhadap perubahan _state_.

- **Kesalahan:** Terlalu banyak _rebuild_ dengan `Provider`.

  - **Penyebab:** Menggunakan `Consumer` atau `context.watch` pada widget yang terlalu besar, atau tidak menggunakan `Selector` saat _state_ yang relevan hanyalah bagian kecil dari objek `ChangeNotifier`.
  - **Solusi:** Minimalkan cakupan `Consumer` hanya pada bagian UI yang benar-benar berubah. Gunakan `Selector` untuk _fine-grained control_ atas _rebuild_.

---

#### 6.3.2 Jenis-jenis Provider (`ChangeNotifierProvider`, `FutureProvider`, `StreamProvider`, dll.)

Setelah memahami dasar-dasar `Provider`, `Consumer`, dan `Selector`, penting untuk mengetahui berbagai jenis `Provider` yang tersedia. Setiap jenis dirancang untuk mengelola _state_ dengan karakteristik data yang berbeda, seperti data statis, data yang berubah seiring waktu melalui notifikasi, data dari operasi asinkron satu kali (Future), atau data dari urutan peristiwa berkelanjutan (Stream).

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan diperkenalkan dengan `Provider` generik, `ValueListenableProvider`, `ListenableProvider`, `ChangeNotifierProvider` (yang sudah dibahas sekilas), `FutureProvider`, dan `StreamProvider`. Mereka akan memahami kapan dan mengapa menggunakan masing-masing jenis ini, dan bagaimana mereka mengintegrasikan konsep _asynchronous programming_ (Future dan Stream) ke dalam manajemen _state_ mereka. Ini akan memberikan kemampuan untuk menangani berbagai skenario data secara efektif dengan `provider`.

**Konsep Kunci & Filosofi Mendalam:**

- **Abstraksi Data Source:** Setiap jenis `Provider` adalah abstraksi untuk menyediakan jenis _data source_ tertentu ke pohon widget. Ini memungkinkan Flutter UI bereaksi terhadap berbagai bentuk perubahan data dengan cara yang konsisten.

  - **Filosofi:** Mengurangi _boilerplate_ dan standardisasi cara data disuntikkan ke dalam UI, terlepas dari sumbernya.

- **Reactive Data Flow:** Baik `FutureProvider` maupun `StreamProvider` memungkinkan aplikasi untuk menampilkan _state_ _loading_, _data_, atau _error_ yang berasal dari operasi asinkron secara reaktif di UI.

  - **Filosofi:** Menangani _asynchronous data_ secara elegan, memungkinkan UI untuk selalu mencerminkan status data terbaru tanpa _race conditions_ atau _UI jank_.

- **Lifecycle Management:** Beberapa `Provider` (seperti `ChangeNotifierProvider`, `StreamProvider`) secara otomatis mengelola _lifecycle_ objek yang mereka sediakan (misalnya, memanggil `dispose()` pada `ChangeNotifier` atau menutup `StreamSubscription`).

  - **Filosofi:** Mencegah kebocoran memori dan menyederhanakan pengelolaan sumber daya.

**Visualisasi Diagram Alur/Struktur:**

- **Diagram Perbandingan:** Tabel atau matriks yang membandingkan `Provider`, `ChangeNotifierProvider`, `FutureProvider`, `StreamProvider` berdasarkan: Jenis Data, Perilaku Rebuild, Kapan Digunakan.
- **FutureProvider Flow:** `Future` starts -\> `loading` state -\> `Future` completes (success/error) -\> `data`/`error` state -\> UI updates.
- **StreamProvider Flow:** `Stream` starts -\> initial `data` -\> `Stream` emits new data -\> UI updates -\> `Stream` completes/error.

**Hubungan dengan Modul Lain:**
Sangat erat kaitannya dengan `5.1 Asynchronous Programming` (Futures & Streams) dan `5.2/5.3 API Integration` (data dari API seringkali berupa Future atau Stream). Membangun di atas `6.3.1 Dasar-dasar Provider` dan mempersiapkan untuk `6.5 BLoC` yang juga sangat bergantung pada konsep Stream.

---

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Untuk Future dan Stream
import 'dart:math'; // Untuk simulasi data

// --- Model Sederhana (untuk Provider generik) ---
class AppConfig {
  final String appName;
  final String version;

  AppConfig({required this.appName, required this.version});

  @override
  String toString() => 'AppConfig(appName: $appName, version: $version)';
}

// --- ChangeNotifier (sudah dibahas, tapi ulangi untuk konteks) ---
class CounterModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

// --- Service Dummy untuk FutureProvider ---
class UserService {
  Future<String> fetchUserName() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulasi network delay
    final names = ['Alice', 'Bob', 'Charlie'];
    final random = Random();
    return names[random.nextInt(names.length)]; // Mengembalikan nama acak
  }

  Future<int> fetchUserAge(String name) async {
    await Future.delayed(const Duration(seconds: 1));
    return name.length * 5; // Simulasi umur berdasarkan panjang nama
  }
}

// --- Service Dummy untuk StreamProvider ---
class RealtimePriceService {
  Stream<double> getPriceUpdates() async* {
    final random = Random();
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield 100.0 + random.nextDouble() * 10; // Harga acak
    }
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        // 1. Provider<T>: Untuk menyediakan nilai atau objek yang tidak berubah (immutable).
        Provider<AppConfig>(
          create: (context) => AppConfig(appName: 'My Awesome App', version: '1.0.0'),
        ),
        // 2. ChangeNotifierProvider<T>: Untuk menyediakan objek yang meng-extend ChangeNotifier.
        //    Object ini bisa berubah dan memberi tahu listener.
        ChangeNotifierProvider(create: (context) => CounterModel()),
        // Menyediakan UserService sebagai singleton untuk digunakan oleh FutureProvider
        Provider<UserService>(create: (context) => UserService()),
        // 3. FutureProvider<T>: Untuk menyediakan data dari Future.
        //    Otomatis menangani status loading, data, dan error.
        FutureProvider<String>(
          initialData: 'Loading Username...', // Data awal sebelum Future selesai
          create: (context) => context.read<UserService>().fetchUserName(),
          // updateShouldNotify: (previous, current) => previous != current, // Opsional: kontrol rebuild
        ),
        // Contoh FutureProvider yang bergantung pada FutureProvider lain
        FutureProvider<int>(
          initialData: 0,
          create: (context) {
            final userNameAsyncValue = context.watch<AsyncValue<String>>(); // Dapatkan AsyncValue dari username
            if (userNameAsyncValue.hasValue) {
              return context.read<UserService>().fetchUserAge(userNameAsyncValue.value!);
            }
            return Future.value(0); // Return Future kosong jika username belum ada
          },
        ),
        // Menyediakan RealtimePriceService sebagai singleton untuk digunakan oleh StreamProvider
        Provider<RealtimePriceService>(create: (context) => RealtimePriceService()),
        // 4. StreamProvider<T>: Untuk menyediakan data dari Stream.
        //    Otomatis memperbarui UI setiap kali Stream memancarkan data baru.
        StreamProvider<double>(
          initialData: 0.0, // Data awal sebelum Stream memancarkan data pertama
          create: (context) => context.read<RealtimePriceService>().getPriceUpdates(),
        ),
        // 5. ValueListenableProvider (Kurang umum, sering digantikan oleh ChangeNotifierProvider
        //    atau langsung ValueListenableBuilder)
        // ValueListenableProvider<int>.value(
        //   value: ValueNotifier<int>(5), // Menyediakan ValueNotifier
        //   child: const MyValueListenableWidget(),
        // ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Types Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const ProviderTypesScreen(),
    );
  }
}

class ProviderTypesScreen extends StatelessWidget {
  const ProviderTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengakses AppConfig (immutable) menggunakan context.read
    final appConfig = context.read<AppConfig>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appConfig.appName), // Menggunakan data dari Provider<AppConfig>
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // --- Mengonsumsi ChangeNotifierProvider ---
            Consumer<CounterModel>(
              builder: (context, counter, child) {
                return Column(
                  children: [
                    const Text('Counter (ChangeNotifier):'),
                    Text(
                      '${counter.count}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => context.read<CounterModel>().decrement(),
                  child: const Text('Decrement'),
                ),
                ElevatedButton(
                  onPressed: () => context.read<CounterModel>().increment(),
                  child: const Text('Increment'),
                ),
              ],
            ),
            const Divider(),

            // --- Mengonsumsi FutureProvider ---
            Consumer<String>(
              builder: (context, username, child) {
                // FutureProvider mengembalikan data langsung jika Future selesai.
                // Jika masih loading, initialData akan digunakan.
                return Column(
                  children: [
                    const Text('User Name (FutureProvider):'),
                    Text(
                      username, // Menampilkan data atau initialData
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                );
              },
            ),
            // Mengakses AsyncValue untuk status loading/error
            Consumer<AsyncValue<String>>(
              builder: (context, usernameAsyncValue, child) {
                return Column(
                  children: [
                    if (usernameAsyncValue.isLoading)
                      const CircularProgressIndicator(),
                    if (usernameAsyncValue.hasError)
                      Text('Error: ${usernameAsyncValue.error}', style: const TextStyle(color: Colors.red)),
                    // Data ditampilkan oleh Consumer<String> di atas
                  ],
                );
              },
            ),
            const Divider(),

            // --- Mengonsumsi FutureProvider yang bergantung pada FutureProvider lain ---
            Consumer<int>(
              builder: (context, age, child) {
                return Column(
                  children: [
                    const Text('User Age (Dependent FutureProvider):'),
                    Text(
                      '${age}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                );
              },
            ),
            const Divider(),


            // --- Mengonsumsi StreamProvider ---
            Consumer<double>(
              builder: (context, price, child) {
                return Column(
                  children: [
                    const Text('Harga Realtime (StreamProvider):'),
                    Text(
                      'Rp ${price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            const Divider(),

            Text('App Version: ${appConfig.version}'), // Menggunakan data dari Provider<AppConfig>
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`Provider<T>` (Generic Provider):**

    - **Untuk apa:** Menyediakan nilai atau objek yang tidak akan berubah sepanjang masa pakainya. Sempurna untuk konfigurasi aplikasi, klien API, atau objek lain yang _immutable_.
    - **Contoh:** `AppConfig` yang berisi nama aplikasi dan versi.
    - **Penggunaan:** Disediakan dengan `Provider<AppConfig>(create: (context) => AppConfig(...))`. Dikonsumsi dengan `context.read<AppConfig>()` (karena tidak ada yang perlu didengarkan) atau `context.watch<AppConfig>()` jika Anda ingin widget _rebuild_ jika instance `AppConfig` itu sendiri diganti (jarang).

2.  **`ChangeNotifierProvider<T>`:**

    - **Untuk apa:** Menyediakan objek yang meng-extend `ChangeNotifier` (seperti `CounterModel` dari contoh sebelumnya). Ini adalah jenis yang paling umum untuk _state_ yang berubah dan memicu _rebuild_ di UI.
    - **Contoh:** `CounterModel` yang nilainya dapat di-_increment_ atau di-_decrement_.
    - **Penggunaan:** Disediakan dengan `ChangeNotifierProvider(create: (context) => CounterModel())`. Dikonsumsi dengan `Consumer<CounterModel>`, `context.watch<CounterModel>()`, atau `context.read<CounterModel>()`.

3.  **`FutureProvider<T>`:**

    - **Untuk apa:** Menyediakan data yang berasal dari operasi asinkron satu kali (sebuah `Future`), seperti panggilan API, pembacaan dari database lokal, atau komputasi yang memakan waktu.
    - **Fitur:** Secara otomatis menangani _state_ `loading`, `data`, dan `error`.
    - **`initialData`:** Nilai awal yang akan digunakan sebelum `Future` selesai.
    - **Bagaimana cara mengonsumsi status:** Anda bisa mengonsumsi `T` secara langsung (yang akan menjadi `initialData` saat _loading_ atau `data` saat selesai), atau Anda bisa mengonsumsi `AsyncValue<T>` untuk mengakses status `isLoading`, `hasError`, `value`, atau `error` secara eksplisit.
    - **Ketergantungan antar `FutureProvider`:** Contoh menunjukkan bagaimana `FutureProvider<int>` (umur) dapat bergantung pada `FutureProvider<String>` (nama pengguna) dengan menggunakan `context.watch<AsyncValue<String>>()` di _callback_ `create`-nya. Ini memastikan `fetchUserAge` hanya dipanggil setelah `fetchUserName` selesai.

4.  **`StreamProvider<T>`:**

    - **Untuk apa:** Menyediakan data yang berasal dari `Stream` (urutan peristiwa yang berkelanjutan), seperti _realtime updates_ dari _websocket_, _sensors_, atau _database listener_.
    - **Fitur:** Otomatis memperbarui UI setiap kali `Stream` memancarkan data baru.
    - **`initialData`:** Nilai awal yang akan digunakan sebelum `Stream` memancarkan data pertamanya.
    - **Penggunaan:** Disediakan dengan `StreamProvider<double>(create: (context) => RealtimePriceService().getPriceUpdates())`. Dikonsumsi dengan `Consumer<double>` atau `context.watch<double>()`.

5.  **`ValueListenableProvider<T>` (disebutkan dalam komentar, kurang umum):**

    - **Untuk apa:** Menyediakan objek `ValueNotifier<T>`. Mirip dengan `ChangeNotifierProvider` tetapi secara khusus untuk `ValueNotifier`.
    - **Filosofi:** Kadang digunakan untuk mengelola _state_ sederhana yang hanya memiliki satu nilai yang berubah. Namun, `ChangeNotifierProvider` jauh lebih fleksibel karena `ChangeNotifier` dapat memiliki banyak properti dan metode. `ValueListenableBuilder` seringkali lebih disukai untuk penggunaan lokal langsung dengan `ValueNotifier`.

**Visualisasi Diagram Alur/Struktur:**

- **Tree of Providers:** `MultiProvider` (Root) -\> `AppConfig`, `CounterModel`, `UserService`, `RealtimePriceService`, `FutureProvider<String>`, `FutureProvider<int>`, `StreamProvider<double>`.
- **Data Access Flow:**
  - `AppConfig`: `context.read<AppConfig>()` (akses langsung)
  - `CounterModel`: `Consumer<CounterModel>` (mendengarkan perubahan)
  - `FutureProvider`: `Consumer<String>` (data) dan `Consumer<AsyncValue<String>>` (status loading/error)
  - `StreamProvider`: `Consumer<double>` (mendengarkan setiap emit baru)

**Terminologi Esensial:**

- **`Provider<T>`:** Jenis `Provider` paling dasar untuk nilai _immutable_.
- **`ChangeNotifierProvider<T>`:** Untuk _state_ yang berubah dan memicu _rebuild_ (menggunakan `ChangeNotifier`).
- **`FutureProvider<T>`:** Untuk _state_ asinkron satu kali (`Future`).
- **`StreamProvider<T>`:** Untuk _state_ asinkron berkelanjutan (`Stream`).
- **`AsyncValue<T>`:** Objek yang digunakan oleh `FutureProvider` dan `StreamProvider` untuk merangkum status asinkron (`data`, `loading`, `error`).
- **`initialData`:** Nilai _fallback_ yang digunakan oleh `FutureProvider` atau `StreamProvider` sebelum data aktual tersedia.

**Sumber Referensi Lengkap:**

- [Flutter documentation: Async state management with Provider](https://www.google.com/search?q=https://docs.flutter.dev/data-and-backend/state-mgmt/options/provider%23async-state-management) - Panduan resmi tentang `FutureProvider` dan `StreamProvider`.
- [Provider package (pub.dev)](https://pub.dev/packages/provider) - Dokumentasi lengkap untuk semua jenis `Provider`.

**Tips dan Praktik Terbaik:**

- **Pilih Provider yang Tepat:** Gunakan jenis `Provider` yang paling sesuai dengan karakteristik _state_ Anda untuk efisiensi dan kejelasan kode.
- **Tangani Status Async:** Untuk `FutureProvider` dan `StreamProvider`, selalu pertimbangkan dan tampilkan status `loading` dan `error` kepada pengguna. `AsyncValue` sangat membantu untuk ini.
- **Gunakan `initialData`:** Berikan `initialData` yang masuk akal untuk `FutureProvider` dan `StreamProvider` agar UI tidak kosong saat data belum tersedia.
- **Dependency Chaining:** Anda dapat membuat _provider_ bergantung pada _provider_ lain dalam `create` _callback_ mereka, seperti yang ditunjukkan pada contoh `FutureProvider<int>` yang bergantung pada `FutureProvider<String>`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Lupa `initialData` untuk `FutureProvider` atau `StreamProvider`.

  - **Penyebab:** Ketika `Future` atau `Stream` belum memancarkan data, `Consumer` akan mencoba menampilkan `null` atau nilai default tipe data, yang bisa menyebabkan _error_ atau _UI jank_.
  - **Solusi:** Selalu sediakan `initialData` yang sesuai untuk `FutureProvider` dan `StreamProvider`.

- **Kesalahan:** Salah memahami kapan `FutureProvider` atau `StreamProvider` di-_recreate_.

  - **Penyebab:** Jika `FutureProvider` atau `StreamProvider` didefinisikan dalam `build` method dari `StatefulWidget` yang sering di-_rebuild_, `Future` atau `Stream` mungkin akan dibuat ulang berulang kali, menyebabkan panggilan API berulang atau masalah performa.
  - **Solusi:** Definisikan `FutureProvider` atau `StreamProvider` setinggi mungkin di pohon widget (biasanya di `MultiProvider` di `main.dart` atau di _route_ atas) agar _Future_ atau `Stream` hanya dibuat sekali.

- **Kesalahan:** Mencoba memodifikasi data dari `FutureProvider` atau `StreamProvider` secara langsung.

  - **Penyebab:** `FutureProvider` dan `StreamProvider` dirancang untuk data _read-only_. Mereka menyediakan data asinkron, bukan objek yang dapat diubah dan dimodifikasi secara langsung dari UI.
  - **Solusi:** Jika data perlu dimodifikasi, Anda mungkin perlu menggabungkan `FutureProvider`/`StreamProvider` dengan `ChangeNotifierProvider` (atau solusi _state management_ lain). Misalnya, `FutureProvider` bisa _fetch_ data awal, dan `ChangeNotifierProvider` bisa mengelola perubahan pada data itu.

---

#### 6.3.3 MultiProvider dan Best Practices

Sub-bagian ini akan mengulas penggunaan `MultiProvider` untuk mengelola beberapa `Provider` dengan cara yang rapi dan terstruktur, serta menyajikan praktik terbaik umum saat bekerja dengan `provider` package. Mengorganisir _provider_ secara efektif adalah kunci untuk menjaga aplikasi tetap _scalable_ dan mudah dipelihara.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami manfaat `MultiProvider` dibandingkan menumpuk `Provider` individual. Mereka akan diajarkan strategi penempatan _provider_ (scope) dan cara memisahkan _business logic_ secara efektif. Bagian ini juga akan merangkum panduan penting tentang penanganan _dispose_, penggunaan `read`/`watch`/`select` yang tepat, dan pentingnya modularisasi, memastikan mereka dapat menulis kode `provider` yang bersih, efisien, dan _maintainable_.

**Konsep Kunci & Filosofi Mendalam:**

- **`MultiProvider`:** Widget yang memungkinkan Anda untuk mendaftarkan banyak `Provider` secara bersamaan dalam satu daftar.
  - **Filosofi:** Meningkatkan keterbacaan kode dengan menghindari "piramida widget" (`Provider` bertumpuk), terutama saat aplikasi memiliki banyak _dependencies_.
- **Provider Scoping:** Penempatan `Provider` di pohon widget menentukan di mana _state_ tersebut dapat diakses. `Provider` hanya dapat diakses oleh _child_ di bawahnya.
  - **Filosofi:** Mengontrol visibilitas _state_ (sesuai kebutuhan), mencegah akses tidak sengaja, dan memungkinkan pengoptimalan _rebuild_.
- **Separation of Concerns (Revisited):** `Provider` sangat mendorong pemisahan antara _business logic_ (`ChangeNotifier`, _services_, dll.) dan UI.
  - **Filosofi:** Logika aplikasi harus dapat diuji secara independen dari UI. Ini membuat kode lebih bersih dan _bug_ lebih mudah ditemukan.
- **Resource Management (`dispose`):** `ChangeNotifierProvider` dan `StreamProvider` secara otomatis memanggil `dispose()` pada objek yang disediakan ketika _provider_ tidak lagi dibutuhkan, mencegah kebocoran memori.
  - **Filosofi:** Automasi pengelolaan sumber daya, mengurangi _boilerplate_ dan risiko _error_.
- **Optimizing Rebuilds:** Memilih metode konsumsi yang tepat (`read`, `watch`, `select`) adalah kunci untuk memastikan hanya bagian UI yang benar-benar membutuhkan pembaruan yang dibangun ulang.
  - **Filosofi:** Reaktivitas yang efisien, mempertahankan performa aplikasi yang mulus.

**Visualisasi Diagram Alur/Struktur:**

- **Piramida Provider vs `MultiProvider`:** Dua diagram berdampingan menunjukkan:
  - `Provider A` -\> `Provider B` -\> `Provider C` -\> `MyWidget` (piramida)
  - `MultiProvider` (daftar `A, B, C`) -\> `MyWidget` (lebih datar)
- **Scoping Visual:** Pohon widget dengan `Provider` ditempatkan di level yang berbeda, menunjukkan garis lingkup di mana _state_ dapat diakses.
- **Flow `read`/`watch`/`select`**: Diagram menunjukkan `context.read` sebagai akses satu kali, `context.watch` sebagai pemicu _rebuild_ seluruh widget, dan `Selector` sebagai pemicu _rebuild_ hanya pada bagian tertentu.

**Hubungan dengan Modul Lain:**
Melanjutkan dari `6.3.1 Dasar-dasar Provider` dan `6.3.2 Jenis-jenis Provider`. Praktik terbaik ini akan relevan untuk semua solusi _state management_ yang dibahas selanjutnya (Riverpod, BLoC) dalam hal arsitektur dan modularisasi. Berinteraksi dengan `Fase 5: Asynchronous Programming & API Integration` dalam hal bagaimana data dari _backend_ dielola dan disuntikkan ke dalam aplikasi.

---

**Sintaks Dasar / Contoh Implementasi Inti (`MultiProvider`):**

Mari kita gabungkan beberapa `Provider` yang berbeda ke dalam `MultiProvider`.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';

// --- Models & Services ---

// 1. App Configuration (Immutable)
class AppConfig {
  final String appName;
  final String apiBaseUrl;

  AppConfig({required this.appName, required this.apiBaseUrl});
}

// 2. User Authentication State (ChangeNotifier)
class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  Future<void> login(String username, String password) async {
    // Simulasi login API call
    await Future.delayed(const Duration(seconds: 1));
    if (username == 'user' && password == 'pass') {
      _isLoggedIn = true;
      _username = username;
      notifyListeners();
      print('User logged in: $_username');
    } else {
      throw Exception('Invalid credentials');
    }
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
    print('User logged out.');
  }
}

// 3. Product Data (Future-based)
class ProductService {
  Future<List<String>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    final products = ['Laptop', 'Mouse', 'Keyboard', 'Monitor'];
    if (Random().nextBool()) { // Simulasi error kadang-kadang
      return products;
    } else {
      throw Exception('Failed to fetch products!');
    }
  }
}

// 4. Notification Count (Stream-based)
class NotificationService {
  Stream<int> getNotificationCount() async* {
    int count = 0;
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      count += 1;
      yield count; // Emit new count
    }
  }
}

void main() {
  runApp(
    // Menggunakan MultiProvider untuk mendaftarkan semua Provider
    MultiProvider(
      providers: [
        // Provider untuk konfigurasi aplikasi (immutable)
        Provider<AppConfig>(
          create: (_) => AppConfig(appName: 'My Awesome App', apiBaseUrl: 'https://api.example.com'),
        ),
        // ChangeNotifierProvider untuk state otentikasi
        ChangeNotifierProvider(create: (_) => AuthState()),
        // Provider untuk service produk (singleton)
        Provider<ProductService>(create: (_) => ProductService()),
        // FutureProvider untuk daftar produk, bergantung pada ProductService
        FutureProvider<List<String>>(
          initialData: const [], // Default empty list
          create: (context) => context.read<ProductService>().fetchProducts(),
        ),
        // Provider untuk service notifikasi (singleton)
        Provider<NotificationService>(create: (_) => NotificationService()),
        // StreamProvider untuk jumlah notifikasi
        StreamProvider<int>(
          initialData: 0, // Default 0 notifications
          create: (context) => context.read<NotificationService>().getNotificationCount(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiProvider Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengakses AppConfig (read only)
    final appConfig = context.read<AppConfig>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appConfig.appName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Autentikasi ---
            Consumer<AuthState>(
              builder: (context, auth, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(auth.isLoggedIn ? 'Halo, ${auth.username}!' : 'Anda belum login.'),
                    const SizedBox(height: 10),
                    auth.isLoggedIn
                        ? ElevatedButton(
                            onPressed: auth.logout,
                            child: const Text('Logout'),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              try {
                                await auth.login('user', 'pass');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Login Failed: $e')),
                                );
                              }
                            },
                            child: const Text('Login'),
                          ),
                  ],
                );
              },
            ),
            const Divider(),

            // --- Daftar Produk (FutureProvider) ---
            const Text('Daftar Produk:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Consumer<AsyncValue<List<String>>>(
              builder: (context, productAsyncValue, child) {
                return productAsyncValue.when(
                  data: (products) => products.isEmpty
                      ? const Text('Tidak ada produk.')
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: products.map((p) => Text('- $p')).toList(),
                        ),
                  error: (error, stack) => Text('Error loading products: $error', style: const TextStyle(color: Colors.red)),
                  loading: () => const CircularProgressIndicator(),
                );
              },
            ),
            const Divider(),

            // --- Notifikasi (StreamProvider) ---
            const Text('Notifikasi Baru:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Consumer<int>(
              builder: (context, count, child) {
                return Text(
                  'Anda memiliki $count notifikasi baru.',
                  style: Theme.of(context).textTheme.headlineSmall,
                );
              },
            ),
            const Divider(),

            Text('API Base URL: ${appConfig.apiBaseUrl}'),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode (`MultiProvider`):**

- **`MultiProvider`:** Di fungsi `main()`, kita menggunakan `MultiProvider` untuk membungkus seluruh aplikasi. Di dalam properti `providers`, kita menyediakan sebuah _list_ dari berbagai jenis `Provider` yang akan tersedia di seluruh sub-pohon di bawahnya.
- **Urutan `Provider`:** Urutan `Provider` dalam daftar `MultiProvider` adalah penting jika ada _provider_ yang bergantung pada _provider_ lain. Misalnya, `FutureProvider<List<String>>` yang membuat `ProductService` harus diletakkan setelah `Provider<ProductService>` itu sendiri.
- **Akses Data:** Di `MainScreen`, kita dapat dengan mudah mengakses setiap _state_ atau _service_ menggunakan `context.read`, `context.watch`, atau `Consumer`/`Selector` tanpa perlu _prop drilling_.
  - `AppConfig` diakses dengan `context.read` karena ini adalah data statis.
  - `AuthState` diakses dengan `Consumer` karena kita ingin UI bereaksi terhadap perubahan status login.
  - `ProductService` juga diakses dengan `context.read` karena `ProductService` itu sendiri adalah objek yang tidak berubah (meskipun metode di dalamnya mengembalikan `Future`).
  - `FutureProvider` untuk produk diakses dengan `Consumer<AsyncValue<List<String>>>` untuk menangani status `loading`, `data`, dan `error` secara eksplisit menggunakan `.when()`.
  - `StreamProvider` untuk notifikasi diakses dengan `Consumer<int>` untuk menampilkan jumlah notifikasi terbaru.

**Best Practices untuk `Provider` Package:**

1.  **Gunakan `MultiProvider`:** Selalu gunakan `MultiProvider` saat Anda memiliki lebih dari satu _provider_. Ini membuat `main.dart` (atau _root_ widget) Anda tetap rapi dan mudah dibaca, daripada menumpuk `Provider` secara berlebihan.

    ```dart
    // JANGAN lakukan ini:
    // Provider(...)
    //   child: ChangeNotifierProvider(...)
    //     child: FutureProvider(...)
    //       child: MyApp()

    // Lakukan ini:
    MultiProvider(
      providers: [
        Provider(...),
        ChangeNotifierProvider(...),
        FutureProvider(...),
      ],
      child: MyApp(),
    )
    ```

2.  **Sekopkan Provider dengan Benar (Scoping):**

    - Tempatkan _provider_ setinggi mungkin di pohon widget sehingga semua widget yang memerlukannya dapat mengaksesnya.
    - Namun, jika _state_ hanya relevan untuk bagian tertentu dari aplikasi (misalnya, _state_ formulir untuk satu halaman), tempatkan _provider_ hanya di atas halaman tersebut. Ini mengurangi cakupan _state_ dan meminimalkan _rebuild_ global.
    - Contoh: `ChangeNotifierProvider` untuk `UserViewModel` mungkin ada di atas `UserDetailScreen` daripada di `main.dart`.

3.  **Pemisahan Tanggung Jawab (Separation of Concerns):**

    - Pertahankan _business logic_ (aturan, manipulasi data, panggilan API) di luar widget UI Anda. Tempatkan mereka di dalam kelas `ChangeNotifier`, _services_, atau kelas lain yang murni Dart.
    - Widget Anda seharusnya hanya bertanggung jawab untuk menampilkan UI dan memanggil metode pada _provider_ Anda.
    - Ini membuat kode lebih mudah diuji, dibaca, dan dikelola.

4.  **Manfaatkan `context.read`, `context.watch`, `Selector`:**

    - **`context.watch<T>()`:** Gunakan di dalam `build` method ketika Anda ingin widget di-rebuild setiap kali _state_ berubah. Ini adalah yang paling umum.
    - **`context.read<T>()`:** Gunakan di dalam _callback_ (misalnya `onPressed`, `initState`, `dispose`) atau di _constructor_ `Provider` lain, ketika Anda hanya perlu mengakses _provider_ sekali dan tidak ingin widget di-rebuild saat _state_ berubah.
    - **`Selector<T, S>`:** Gunakan untuk mengoptimalkan _rebuild_ jika widget Anda hanya bergantung pada sebagian kecil dari _state_ yang lebih besar. Ini mencegah _rebuild_ yang tidak perlu dari seluruh `Consumer` atau widget yang menggunakan `context.watch`.

5.  **Kelola Sumber Daya (Dispose):**

    - `ChangeNotifierProvider`, `StreamProvider`, dan `FutureProvider` akan secara otomatis memanggil `dispose()` pada objek yang mereka buat ketika _provider_ tidak lagi diperlukan. Pastikan objek yang Anda sediakan (misalnya, `ChangeNotifier`, `StreamController`) memiliki metode `dispose()` yang membersihkan sumber daya (misalnya, menutup _stream_, membatalkan _timer_).
    - Untuk `Provider` (generik) yang menyediakan objek yang memerlukan `dispose()` (misalnya, `http.Client`), gunakan `Provider.value()` dan kelola _lifecycle_-nya secara manual, atau pertimbangkan untuk menggunakan _dependency injection_ yang lebih canggih seperti `GetIt` jika objek tersebut adalah _singleton_ global. Atau, jika Anda membuat objek di `create` _callback_, `Provider` tidak secara otomatis membuangnya. Anda perlu meng-handle `dispose` secara manual jika object tersebut tidak merupakan `ChangeNotifier`, `Stream`, atau `Future`. Solusi lebih baik adalah menggunakan `DisposableProvider` atau sejenisnya, atau beralih ke Riverpod.

6.  **Immutable State dalam `ChangeNotifier`:**

    - Meskipun `ChangeNotifier` mengelola _state_ yang dapat berubah, seringkali merupakan praktik yang baik untuk menyimpan _state_ internal sebagai objek _immutable_ (misalnya, daftar yang tidak dapat diubah, objek data kelas).
    - Ketika _state_ berubah, Anda membuat instance baru dari objek _state_ tersebut dan kemudian memanggil `notifyListeners()`. Ini membuat pelacakan perubahan lebih jelas.
    - Contoh: Daripada `List<Item> _items; void addItem(Item item) { _items.add(item); notifyListeners(); }`, lebih baik `List<Item> _items; void addItem(Item item) { _items = [..._items, item]; notifyListeners(); }`.

7.  **Jangan Panggil `notifyListeners()` Terlalu Sering:**

    - Memanggil `notifyListeners()` memicu _rebuild_ pada semua _listener_. Panggil hanya ketika perubahan _state_ memang harus direfleksikan di UI.
    - Jika Anda melakukan beberapa perubahan pada _state_ secara berurutan dalam satu _tick_, panggil `notifyListeners()` hanya sekali setelah semua perubahan selesai.

**Potensi Kesalahan Umum & Solusi (Revisited dan Ditambahkan):**

- **Kesalahan:** Mengakses `Provider` sebelum inisialisasi atau di tempat yang salah.

  - **Penyebab:** Mencoba `context.watch` atau `context.read` di `initState()` sebelum `context` benar-benar siap untuk mendengarkan, atau di _callback_ yang tidak memiliki akses ke `BuildContext` yang valid.
  - **Solusi:** Untuk `initState()`, gunakan `WidgetsBinding.instance.addPostFrameCallback((_) => context.read<MyProvider>().doSomething());` atau `Future.microtask(() => context.read<MyProvider>().doSomething());` untuk memastikan _context_ sudah sepenuhnya tersedia. Untuk _callback_ di luar `build`, selalu gunakan `context.read`.

- **Kesalahan:** _Widget_ di-rebuild terlalu sering atau tidak perlu.

  - **Penyebab:** Menggunakan `Consumer` atau `context.watch` di widget yang terlalu besar, atau tidak menggunakan `Selector`.
  - **Solusi:** Minimalkan cakupan `Consumer` atau widget yang menggunakan `context.watch`. Gunakan `Selector` untuk bagian _state_ yang spesifik.

- **Kesalahan:** Kebocoran memori karena `dispose()` tidak dipanggil.

  - **Penyebab:** Menyediakan objek yang memerlukan pembersihan (misalnya `StreamController`, `TextEditingController`, _timer_) tanpa meng-extend `ChangeNotifier` atau menggunakan `StreamProvider` atau `FutureProvider` yang secara otomatis mengelola `dispose`. Atau jika Anda menggunakan `Provider` generik untuk objek yang bisa di-_dispose_ tanpa meng-handle `dispose` secara manual.
  - **Solusi:**
    - Jika objek bisa meng-extend `ChangeNotifier`, gunakan `ChangeNotifierProvider`.
    - Jika objek adalah `Stream`, gunakan `StreamProvider`.
    - Jika tidak, Anda mungkin perlu mengelola _lifecycle_ secara manual di `StatefulWidget` (menggunakan `initState` dan `dispose`) atau mempertimbangkan paket _dependency injection_ seperti `GetIt` jika objek tersebut adalah _singleton_ global yang persisten.

- **Kesalahan:** _Provider_ tidak dapat diakses atau `ProviderNotFoundException` saat berinteraksi dengan _provider_ yang saling bergantung.

  - **Penyebab:** Urutan _provider_ di `MultiProvider` salah. _Provider_ yang mencoba mengakses _provider_ lain harus diletakkan setelah _provider_ yang diakses dalam daftar `MultiProvider`.
  - **Solusi:** Susun _list_ `providers` di `MultiProvider` sehingga _dependencies_ disediakan terlebih dahulu.

---

Kita telah menyelesaikan penjelasan mendalam untuk bagian ini. Anda sekarang memiliki pemahaman yang komprehensif tentang bagaimana `provider` bekerja, berbagai jenisnya, dan praktik terbaik untuk menggunakannya secara efisien dalam aplikasi Flutter Anda.

### 6.4 Riverpod Package

Riverpod adalah _state management solution_ yang dikembangkan oleh tim yang sama di balik `provider` package. Riverpod adalah upaya untuk mengatasi beberapa batasan dan masalah `provider` dengan menambahkan _compile-time safety_, kemampuan untuk _override_ _provider_ dengan mudah (penting untuk _testing_), dan menghilangkan ketergantungan pada `BuildContext` untuk deklarasi _provider_.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami mengapa Riverpod sering dianggap sebagai "provider yang lebih baik". Mereka akan belajar konsep inti seperti `ProviderContainer`, deklarasi _provider_ global, berbagai jenis _provider_ Riverpod (`Provider`, `StateProvider`, `StateNotifierProvider`, `FutureProvider`, `StreamProvider`), dan cara mengkonsumsinya menggunakan `ConsumerWidget` atau `ref.watch`. Ini akan membekali mereka dengan alat untuk membangun aplikasi yang lebih tangguh dan mudah diuji.

**Konsep Kunci & Filosofi Mendalam:**

- **Compile-time Safety:** Salah satu keunggulan terbesar Riverpod adalah keamanan tipe di waktu kompilasi. Ini berarti Anda akan sering mendapatkan _error_ saat mengetik kode, bukan saat _runtime_, yang sangat membantu dalam _debugging_ dan mencegah `ProviderNotFoundException`.
  - **Filosofi:** Mengurangi _bug_ _runtime_ dan meningkatkan pengalaman pengembang dengan deteksi _error_ dini.
- **No `BuildContext` for Provider Declaration:** Tidak seperti `provider` yang sering memerlukan `BuildContext` untuk membuat _instance provider_, Riverpod mendeklarasikan _provider_ secara global. Ini menghilangkan masalah _scoping_ yang membingungkan dan membuat _provider_ lebih mudah diakses.
  - **Filosofi:** Penyederhanaan deklarasi dan akses _provider_, decoupling _state_ dari pohon widget.
- **Dependency Overrides (for Testing):** Riverpod memungkinkan Anda untuk dengan mudah mengganti implementasi _provider_ selama _testing_. Ini sangat mempermudah _mocking_ dan _unit testing_.
  - **Filosofi:** Mendukung _test-driven development_ (TDD) dan memastikan kualitas kode yang lebih tinggi.
- **`ProviderContainer`:** Ini adalah tempat di mana semua _provider_ Riverpod disimpan dan di-_resolve_. Mirip dengan `MultiProvider` di _root_ aplikasi, tetapi dengan kontrol yang lebih besar.
  - **Filosofi:** Memberikan lingkungan yang terisolasi untuk _provider_, yang sangat berguna untuk _testing_ atau _app environments_ yang berbeda.
- **`Ref` Object:** Alih-alih menggunakan `BuildContext` untuk mengakses _provider_, Riverpod memperkenalkan objek `Ref` (singkatan dari `ProviderRef` atau `WidgetRef`). Objek ini digunakan untuk membaca nilai _provider_ lain, mendengarkan perubahan, atau mengelola _lifecycle_.
  - **Filosofi:** Menyediakan cara yang konsisten dan _type-safe_ untuk berinteraksi dengan _provider_, tanpa ketergantungan pada _context_ Flutter yang bisa ambigu.
- **Implicit vs. Explicit Scoping (Provider vs Riverpod):**
  - `provider`: Lingkup _provider_ ditentukan oleh penempatannya di pohon widget (implisit).
  - `Riverpod`: _Provider_ dideklarasikan secara global, tetapi penggunaannya tetap _scoped_ secara implisit berdasarkan `ProviderContainer` atau `ref`. Anda juga bisa memiliki _explicit scoping_ dengan `ProviderScope`.
  - **Filosofi:** Memberikan fleksibilitas lebih besar dalam bagaimana _provider_ diatur dan diakses.

**Visualisasi Diagram Alur/Struktur:**

- **`Provider` vs `Riverpod` Comparison:** Diagram menunjukkan bagaimana `Provider` memerlukan `BuildContext` untuk deklarasi, sementara `Riverpod` mendeklarasikan _provider_ secara global, lalu diakses melalui `ref`.
- **Dependency Override:** Diagram menunjukkan `ProviderContainer` normal yang menyediakan `ProdService`, lalu `TestProviderContainer` yang _override_ dengan `MockService`.
- **`ref.watch` Flow:** `User Action` -\> `ref.read` calls method on `StateNotifier` -\> `StateNotifier` updates state -\> `ref.watch` detects state change -\> UI rebuilds.

**Hubungan dengan Modul Lain:**
Riverpod adalah evolusi dari `provider` (6.3), jadi semua konsep dasar _state management_ dan _dependency injection_ dari `provider` tetap relevan. Ini juga sangat memanfaatkan `5.1 Asynchronous Programming` (Futures & Streams) untuk `FutureProvider` dan `StreamProvider` di Riverpod. Kemampuan _testing_ yang ditingkatkan sangat penting untuk `Fase 10: Testing`.

---

#### 6.4.1 Pengenalan Konsep Riverpod (Providers, Consumers, Scoping)

Untuk menggunakan `flutter_riverpod`, tambahkan dependensi di `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1 # Periksa versi terbaru di pub.dev
  # Tambahkan dev_dependencies jika Anda ingin menggunakan code generation untuk provider:
  # dev_dependencies:
  #   flutter_lints: ^2.0.0
  #   build_runner: ^2.4.6 # Periksa versi terbaru
  #   riverpod_generator: ^2.3.9 # Periksa versi terbaru
  #   riverpod_lint: ^2.3.9 # Opsional, untuk linting Riverpod
```

Kemudian jalankan `flutter pub get`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

// --- 1. Deklarasi Provider Global ---
// Providers dideklarasikan sebagai variabel global (atau final static di kelas).
// Ini menghilangkan kebutuhan Context untuk definisi provider.

// A. Simple Provider: Untuk nilai immutable atau objek sederhana.
final helloWorldProvider = Provider<String>((ref) {
  // `ref` digunakan untuk membaca provider lain atau mengelola lifecycle
  return 'Halo, Riverpod!';
});

// B. StateProvider: Untuk state sederhana yang dapat berubah, sering digunakan untuk
//    primitive types (int, bool, String, dll.) atau objek sederhana.
//    Memberikan StateController yang dapat diubah dan juga value-nya langsung.
final counterProvider = StateProvider<int>((ref) {
  return 0; // Nilai awal
});

// C. StateNotifierProvider: Untuk state yang lebih kompleks dan logika bisnis.
//    Mirip dengan ChangeNotifierProvider tapi lebih aman karena StateNotifier
//    tidak meng-extend ChangeNotifier dan lebih eksplisit dalam manajemen state.
class Todo {
  final String id;
  final String description;
  final bool completed;

  Todo({required this.id, required this.description, this.completed = false});

  // Metode untuk membuat salinan todo dengan perubahan (immutable update)
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// StateNotifier adalah kelas yang menampung state (list of todos)
// dan memiliki metode untuk memodifikasi state tersebut.
class TodosNotifier extends StateNotifier<List<Todo>> {
  // State awal adalah list kosong
  TodosNotifier() : super([]);

  void addTodo(String description) {
    state = [...state, Todo(id: DateTime.now().toString(), description: description)];
  }

  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(completed: !todo.completed) else todo,
    ];
  }

  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

// Deklarasi StateNotifierProvider untuk TodosNotifier
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});

// Aplikasi Utama
void main() {
  runApp(
    // ProviderScope diperlukan di root aplikasi agar Riverpod berfungsi.
    // Ini adalah tempat Riverpod menyimpan state dari semua provider.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}

// --- 2. Widget yang Mengonsumsi State (ConsumerWidget/ConsumerStatefulWidget) ---

// ConsumerWidget adalah StatelessWidget yang memiliki akses ke `ref`.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Perhatikan parameter `ref`
    print('HomeScreen built'); // Perhatikan kapan ini dibangun
    // Mengonsumsi helloWorldProvider (nilai immutable)
    final helloText = ref.watch(helloWorldProvider);

    // Mengonsumsi counterProvider (StateProvider)
    // ref.watch(counterProvider) akan mengembalikan int (nilai state).
    // ref.watch(counterProvider.notifier) akan mengembalikan StateController.
    final count = ref.watch(counterProvider);
    final counterController = ref.watch(counterProvider.notifier);

    // Mengonsumsi todosProvider (StateNotifierProvider)
    final todos = ref.watch(todosProvider); // Mengembalikan List<Todo> (state)
    final todosNotifier = ref.watch(todosProvider.notifier); // Mengembalikan TodosNotifier (controller)

    return Scaffold(
      appBar: AppBar(
        title: Text(helloText), // Menggunakan nilai dari helloWorldProvider
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // --- Contoh StateProvider (Counter) ---
            const Text(
              'Counter (StateProvider):',
            ),
            Text(
              '$count', // Menggunakan nilai dari StateProvider
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Mengakses controller untuk memodifikasi state
                    counterController.state--; // Mengubah state secara langsung
                    // Atau, lebih disukai untuk state sederhana:
                    // ref.read(counterProvider.notifier).update((state) => state - 1);
                  },
                  child: const Text('Kurangi'),
                ),
                ElevatedButton(
                  onPressed: () {
                    counterController.state++; // Mengubah state secara langsung
                    // Atau:
                    // ref.read(counterProvider.notifier).update((state) => state + 1);
                  },
                  child: const Text('Tambah'),
                ),
              ],
            ),
            const Divider(),

            // --- Contoh StateNotifierProvider (Todos) ---
            const Text(
              'Todos (StateNotifierProvider):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // Memanggil method dari TodosNotifier untuk memodifikasi state
                todosNotifier.addTodo('Belajar Riverpod');
              },
              child: const Text('Tambah Todo'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(
                      todo.description,
                      style: TextStyle(
                        decoration: todo.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (val) {
                        todosNotifier.toggleTodo(todo.id);
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        todosNotifier.removeTodo(todo.id);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`ProviderScope`:**

    - Ini adalah widget yang harus diletakkan di _root_ aplikasi (biasanya di `main.dart`).
    - `ProviderScope` adalah tempat Riverpod menyimpan _state_ dari semua _provider_ Anda. Tanpa ini, tidak ada _provider_ yang dapat diakses.

2.  **Deklarasi Provider:**

    - Berbeda dengan `provider` package, semua _provider_ Riverpod dideklarasikan sebagai variabel `final` global (atau `static`).
    - `Provider<T>((ref) => value)`: Untuk nilai atau objek yang tidak berubah (immutable). Contoh: `helloWorldProvider`.
      - `ref`: Objek `ProviderRef` yang disediakan oleh Riverpod. Digunakan untuk membaca _provider_ lain (`ref.watch`, `ref.read`), atau untuk mengelola _lifecycle_ _provider_ (`ref.onDispose`).
    - `StateProvider<T>((ref) => initialValue)`: Untuk _state_ sederhana yang dapat berubah, biasanya untuk tipe primitif atau objek tunggal.
      - Anda dapat membaca nilainya dengan `ref.watch(myStateProvider)`.
      - Untuk memodifikasi nilainya, Anda bisa mengakses `StateController` dengan `ref.read(myStateProvider.notifier)` dan kemudian mengubah properti `.state`, atau menggunakan metode `.update()`: `ref.read(myStateProvider.notifier).update((state) => state + 1);`.
    - `StateNotifierProvider<Notifier, State>((ref) => Notifier())`: Digunakan untuk _state_ yang lebih kompleks dan memerlukan _business logic_ yang lebih dari sekadar mengubah nilai sederhana.
      - `Notifier`: Kelas yang meng-extend `StateNotifier` (misalnya `TodosNotifier`).
      - `State`: Tipe data _state_ yang dikelola oleh `Notifier` (misalnya `List<Todo>`).
      - `TodosNotifier`: Mengelola `List<Todo>` sebagai _state_ internalnya. Perubahan dilakukan dengan mengassign nilai baru ke properti `state` (`state = newList`).
      - `ref.watch(todosProvider)`: Akan mengembalikan _state_ saat ini (`List<Todo>`).
      - `ref.watch(todosProvider.notifier)`: Akan mengembalikan _instance_ dari `TodosNotifier`, memungkinkan Anda memanggil metodenya (misalnya `addTodo`, `toggleTodo`).

3.  **Mengonsumsi Provider:**

    - **`ConsumerWidget`:** Ini adalah `StatelessWidget` yang diperkaya dengan parameter `WidgetRef ref` di metode `build`-nya. Ini adalah cara paling umum dan direkomendasikan untuk mengonsumsi _provider_ secara reaktif di widget Anda.
      - `ref.watch(myProvider)`: Digunakan di dalam `build` method untuk mendengarkan perubahan pada _provider_. Ketika _provider_ berubah, widget akan di-rebuild. Ini adalah analog dengan `context.watch` di `provider` package.
      - `ref.read(myProvider)`: Digunakan di dalam _callback_ (misalnya `onPressed`) untuk mengakses nilai _provider_ _sekali_ tanpa mendengarkan perubahannya. Ini analog dengan `context.read` di `provider` package.
    - **`ConsumerStatefulWidget`:** Versi `StatefulWidget` yang menyediakan `WidgetRef ref` di dalam objek `State`-nya. Berguna jika Anda perlu mengelola _state_ lokal dengan `setState` bersamaan dengan mengonsumsi _provider_.
    - **`Consumer` Widget:** Meskipun `ConsumerWidget` lebih disukai, widget `Consumer` masih tersedia dan berfungsi seperti di `provider` package, berguna untuk mengoptimalkan _rebuild_ di bagian sangat spesifik dari pohon widget.

**Visualisasi Diagram Alur/Struktur:**

- **Provider Declaration:** Lingkaran `ProviderScope` di atas, dengan panah ke `helloWorldProvider`, `counterProvider`, `todosProvider` (semua global).
- **Widget Consumption:** `HomeScreen` (ConsumerWidget) dengan panah dari `ref` ke `helloWorldProvider`, `counterProvider`, `todosProvider`.
- **State Update Flow:** `User taps button` -\> `ref.read(counterProvider.notifier).state++` -\> `StateProvider` updates -\> `ref.watch(counterProvider)` in `Text` rebuilds `Text`.

---

#### 6.4.2 StateNotifierProvider, FutureProvider, StreamProvider di Riverpod

Riverpod memiliki versi yang lebih aman dan terstruktur dari `FutureProvider` dan `StreamProvider` dari paket `provider`, serta pendekatan yang lebih terdefinisi untuk _state_ yang kompleks melalui `StateNotifierProvider`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:math';

// --- Model/Service (untuk FutureProvider) ---
class UserProfile {
  final String name;
  final int age;

  UserProfile({required this.name, required this.age});

  @override
  String toString() => 'Name: $name, Age: $age';
}

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  await Future.delayed(const Duration(seconds: 2)); // Simulasi network delay
  final random = Random();
  final name = random.nextBool() ? 'John Doe' : 'Jane Smith';
  final age = 20 + random.nextInt(10); // Usia antara 20-29
  // Contoh simulasi error
  if (random.nextBool()) {
    return UserProfile(name: name, age: age);
  } else {
    throw Exception('Failed to load user profile!');
  }
});

// --- Model/Service (untuk StreamProvider) ---
final timerProvider = StreamProvider<int>((ref) {
  final StreamController<int> controller = StreamController<int>();
  int count = 0;
  Timer.periodic(const Duration(seconds: 1), (timer) {
    controller.add(count++);
  });

  // Penting: Clean up the stream when the provider is disposed
  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

// --- Model/Service (untuk StateNotifierProvider, sudah di atas, ini contoh lain) ---
// Misal, Filter untuk daftar Todo
enum TodoFilter {
  all,
  active,
  completed,
}

final todoFilterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

// Menggabungkan filter dengan daftar todo asli
// `select` di Riverpod adalah `select` di Consumer/Selector
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoFilterProvider);
  final todos = ref.watch(todosProvider); // Mengakses todosNotifier dari atas

  switch (filter) {
    case TodoFilter.active:
      return todos.where((todo) => !todo.completed).toList();
    case TodoFilter.completed:
      return todos.where((todo) => todo.completed).toList();
    case TodoFilter.all:
      return todos;
  }
});


// Main App setup (sama seperti sebelumnya)
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Advanced Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const AdvancedHomeScreen(),
    );
  }
}

class AdvancedHomeScreen extends ConsumerWidget {
  const AdvancedHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mengonsumsi FutureProvider
    final userProfileAsyncValue = ref.watch(userProfileProvider);

    // Mengonsumsi StreamProvider
    final timerValue = ref.watch(timerProvider);

    // Mengonsumsi filteredTodosProvider
    final filteredTodos = ref.watch(filteredTodosProvider);
    final currentFilter = ref.watch(todoFilterProvider); // Untuk menampilkan filter aktif
    final todoFilterController = ref.watch(todoFilterProvider.notifier); // Untuk mengubah filter


    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Advanced Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FutureProvider Example ---
            const Text(
              'Profil Pengguna (FutureProvider):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            userProfileAsyncValue.when(
              data: (user) => Text(user.toString(), style: const TextStyle(fontSize: 16)),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error', style: const TextStyle(color: Colors.red)),
            ),
            const Divider(),

            // --- StreamProvider Example ---
            const Text(
              'Timer (StreamProvider):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            timerValue.when(
              data: (value) => Text('Waktu: $value detik', style: const TextStyle(fontSize: 16)),
              loading: () => const CircularProgressIndicator(value: null), // indeterminate
              error: (error, stack) => Text('Error: $error', style: const TextStyle(color: Colors.red)),
            ),
            const Divider(),

            // --- Filtered Todos Example (StateNotifierProvider + StateProvider + Provider) ---
            const Text(
              'Daftar Todo (Filtered):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: TodoFilter.values.map((filter) {
                return ChoiceChip(
                  label: Text(filter.name.toUpperCase()),
                  selected: currentFilter == filter,
                  onSelected: (selected) {
                    if (selected) {
                      todoFilterController.state = filter; // Mengubah filter
                    }
                  },
                );
              }).toList(),
            ),
            Expanded(
              child: filteredTodos.isEmpty
                  ? const Center(child: Text('Tidak ada todo untuk filter ini.'))
                  : ListView.builder(
                      itemCount: filteredTodos.length,
                      itemBuilder: (context, index) {
                        final todo = filteredTodos[index];
                        return ListTile(
                          title: Text(
                            todo.description,
                            style: TextStyle(
                              decoration: todo.completed ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          leading: Checkbox(
                            value: todo.completed,
                            onChanged: (val) {
                              // Akses todosNotifier dari provider asli (bukan filteredTodosProvider)
                              ref.read(todosProvider.notifier).toggleTodo(todo.id);
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref.read(todosProvider.notifier).removeTodo(todo.id);
                            },
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: () {
                // Tambahkan todo ke todosNotifier asli
                ref.read(todosProvider.notifier).addTodo('Todo baru dari filter');
              },
              child: const Text('Tambah Todo ke Daftar Asli'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode (Jenis-jenis Provider Riverpod):**

1.  **`FutureProvider<T>`:**

    - **Untuk apa:** Menyediakan hasil dari sebuah `Future` (operasi asinkron tunggal).
    - **Contoh:** `userProfileProvider` yang mengambil `UserProfile`.
    - **Penggunaan:** Mirip dengan `FutureProvider` di `provider` package, tetapi lebih terintegrasi dengan ekosistem Riverpod.
    - `ref.watch(userProfileProvider)` akan mengembalikan `AsyncValue<UserProfile>`. `AsyncValue` adalah _sealed class_ (atau _union type_) yang merepresentasikan tiga status: `data`, `loading`, atau `error`.
    - Metode `.when()` pada `AsyncValue` adalah cara yang sangat rapi untuk menangani ketiga status ini secara deklaratif di UI Anda.

2.  **`StreamProvider<T>`:**

    - **Untuk apa:** Menyediakan nilai dari sebuah `Stream` (urutan peristiwa berkelanjutan).
    - **Contoh:** `timerProvider` yang memancarkan angka setiap detik.
    - **Penggunaan:** Mirip dengan `StreamProvider` di `provider` package. `ref.watch(timerProvider)` juga mengembalikan `AsyncValue<int>`.
    - **`ref.onDispose(() { ... });`:** Ini adalah fitur penting Riverpod. Ini memungkinkan Anda untuk mendaftarkan _callback_ yang akan dijalankan ketika _provider_ tidak lagi aktif (misalnya, ketika tidak ada lagi _listener_ atau ketika `ProviderScope` dihancurkan). Ini sangat penting untuk membersihkan sumber daya seperti `StreamController` atau `Timer` untuk mencegah kebocoran memori.

3.  **`StateNotifierProvider<Notifier, State>` (Contoh Lanjutan):**

    - **Untuk apa:** Tetap menjadi pilihan utama untuk _state_ kompleks dengan _business logic_.
    - **Contoh Filtered Todos:**
      - `todoFilterProvider` (sebuah `StateProvider<TodoFilter>`) mengelola _state_ filter yang dipilih pengguna.
      - `filteredTodosProvider` (sebuah `Provider<List<Todo>>`) bergantung pada `todoFilterProvider` DAN `todosProvider` (yang kita definisikan di 6.4.1). Ini menunjukkan bagaimana _provider_ dapat bergantung pada _provider_ lain secara eksplisit dengan `ref.watch()`. Setiap kali `filter` atau `todos` asli berubah, `filteredTodosProvider` akan dihitung ulang, dan UI yang mendengarkannya akan diperbarui.

**Visualisasi Diagram Alur/Struktur:**

- **AsyncValue Flow:** Kotak `FutureProvider` / `StreamProvider` -\> `AsyncValue` box (dengan 3 jalur: `loading`, `data`, `error`) -\> UI dengan `.when()`
- **Dependency Graph (Riverpod):** `todoFilterProvider` dan `todosProvider` (dua node) -\> panah ke `filteredTodosProvider` (node ketiga) -\> panah ke UI. Ini menunjukkan bagaimana _provider_ membangun grafik dependensi yang jelas.

---

#### 6.4.3 Menggunakan `ConsumerWidget` dan `ConsumerStatefulWidget`

Seperti yang telah terlihat di contoh sebelumnya:

- **`ConsumerWidget`:**

  - Adalah versi `StatelessWidget` yang mengimplementasikan antarmuka `ConsumerWidget`.
  - Metode `build` menerima `WidgetRef ref` sebagai parameter kedua.
  - Ini adalah cara yang direkomendasikan untuk membangun widget yang hanya perlu mengonsumsi _provider_ tanpa _state_ lokal yang dapat diubah (`setState`).
  - Contoh: `HomeScreen` dan `AdvancedHomeScreen` di atas.

- **`ConsumerStatefulWidget`:**

  - Adalah versi `StatefulWidget` yang mengimplementasikan antarmuka `ConsumerStatefulWidget`.
  - Objek `State` yang terkait harus meng-extend `ConsumerState<T extends ConsumerStatefulWidget>`.
  - Objek `State` ini kemudian memiliki properti `ref` yang dapat diakses di mana saja dalam objek `State` tersebut (termasuk `initState`, `didChangeDependencies`, `dispose`, dll., tidak hanya di `build`).
  - Digunakan ketika Anda membutuhkan kombinasi dari _state_ lokal (`setState`) dan kemampuan untuk mengonsumsi _provider_.

**Contoh `ConsumerStatefulWidget`:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Definisi counterProvider (dari contoh sebelumnya)
final counterProvider = StateProvider<int>((ref) => 0);

class MyConsumerStatefulWidget extends ConsumerStatefulWidget {
  const MyConsumerStatefulWidget({super.key});

  @override
  ConsumerState<MyConsumerStatefulWidget> createState() => _MyConsumerStatefulWidgetState();
}

class _MyConsumerStatefulWidgetState extends ConsumerState<MyConsumerStatefulWidget> {
  int _localCounter = 0; // State lokal dengan setState

  // Inisialisasi state atau listeners di sini, termasuk provider
  @override
  void initState() {
    super.initState();
    // Mengakses provider di initState dengan ref.read
    final initialGlobalCounter = ref.read(counterProvider);
    _localCounter = initialGlobalCounter * 10;
    print('initState: Local counter initialized to $_localCounter');
  }

  void _incrementLocal() {
    setState(() {
      _localCounter++;
      print('Local counter incremented to: $_localCounter');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mengonsumsi global counter dari Riverpod
    final globalCounter = ref.watch(counterProvider);

    return Column(
      children: [
        const Text('Global Counter (Riverpod):'),
        Text('$globalCounter', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        const Text('Local Counter (setState):'),
        Text('$_localCounter', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _incrementLocal,
          child: const Text('Increment Local Counter'),
        ),
        ElevatedButton(
          onPressed: () {
            // Mengubah global counter melalui Riverpod
            ref.read(counterProvider.notifier).state++;
          },
          child: const Text('Increment Global Counter'),
        ),
      ],
    );
  }

  // Membersihkan sumber daya
  @override
  void dispose() {
    print('dispose() called for _MyConsumerStatefulWidgetState');
    // Jika ada listeners atau controllers yang dibuat di initState
    // dan tidak dikelola oleh provider, bersihkan di sini.
    super.dispose();
  }
}
```

**Penjelasan Konteks Kode (`ConsumerStatefulWidget`):**

- `_MyConsumerStatefulWidgetState` meng-extend `ConsumerState<MyConsumerStatefulWidget>`.
- Objek `ref` tersedia di dalam `_MyConsumerStatefulWidgetState`, sehingga Anda bisa menggunakan `ref.read` di `initState` (untuk inisialisasi) dan `ref.watch` di `build` (untuk reaktivitas).
- Anda bisa menggabungkan `_localCounter` (state lokal yang dikelola `setState`) dengan `globalCounter` (state global dari Riverpod) dalam satu widget.

---

#### 6.4.4 Keunggulan Riverpod (Compile-time Safety, Testing)

- **Compile-time Safety:**

  - **Tidak ada `ProviderNotFoundException` _runtime error_:** Di `provider` package, jika Anda mencoba mengakses _provider_ yang tidak disediakan di `BuildContext` atas, Anda akan mendapatkan _runtime error_. Riverpod, dengan deklarasi _provider_ globalnya dan sistem `ref` yang kuat, memungkinkan _compiler_ untuk memverifikasi bahwa _provider_ yang Anda coba akses memang ada, mencegah jenis _error_ ini.
  - **Type Safety:** `ref.watch(someProvider)` akan secara otomatis memberikan tipe yang benar berdasarkan _provider_ yang dideklarasikan, mengurangi _error_ pengetikan.

- **Kemudahan Testing (Dependency Overrides):**

  - Ini adalah salah satu keunggulan terbesar Riverpod. Anda dapat dengan mudah mengganti (override) implementasi _provider_ apa pun untuk tujuan _testing_.
  - Ini memungkinkan Anda untuk:
    - **Mock Dependencies:** Ganti _service_ yang melakukan panggilan API dengan _mock service_ yang mengembalikan data palsu, sehingga _unit test_ Anda cepat dan tidak bergantung pada jaringan.
    - **Isolate Logic:** Uji _business logic_ di dalam `StateNotifier` atau _provider_ tanpa perlu menginisialisasi seluruh UI atau _dependencies_ yang tidak relevan.

**Contoh Testing dengan Riverpod (Konseptual):**

```dart
// Misalkan kita punya UserApiClient
class UserApiClient {
  Future<String> fetchUser(String id) async {
    // Simulasi panggilan HTTP
    await Future.delayed(const Duration(seconds: 1));
    if (id == '123') return 'John Doe';
    throw Exception('User not found');
  }
}

// Dan sebuah UserProvider yang bergantung pada UserApiClient
final userApiClientProvider = Provider((ref) => UserApiClient());

final userDetailProvider = FutureProvider.family<String, String>((ref, userId) async {
  final api = ref.watch(userApiClientProvider);
  return api.fetchUser(userId);
});

// --- UNIT TEST ---
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'; // Jika menggunakan Mockito
// import 'your_app_file.dart'; // Import file yang berisi provider di atas

// Mock UserApiClient
class MockUserApiClient extends Mock implements UserApiClient {}

void main() {
  group('userDetailProvider', () {
    test('should fetch user successfully', () async {
      final mockApiClient = MockUserApiClient();
      when(mockApiClient.fetchUser('123')).thenAnswer((_) async => 'Test User');

      // Override userApiClientProvider dengan mock kita
      final container = ProviderContainer(
        overrides: [
          userApiClientProvider.overrideWithValue(mockApiClient),
        ],
      );

      // Pastikan untuk membuang container setelah selesai
      addTearDown(container.dispose);

      // Watch provider untuk mendapatkan AsyncValue
      final userFuture = container.watch(userDetailProvider('123'));

      // Tunggu hingga Future selesai
      await container.pump(); // Menunggu Future provider selesai

      // Periksa status data
      expect(userFuture.isLoading, false);
      expect(userFuture.hasValue, true);
      expect(userFuture.value, 'Test User');
    });

    test('should handle user not found error', () async {
      final mockApiClient = MockUserApiClient();
      when(mockApiClient.fetchUser('456')).thenThrow(Exception('User not found'));

      final container = ProviderContainer(
        overrides: [
          userApiClientProvider.overrideWithValue(mockApiClient),
        ],
      );
      addTearDown(container.dispose);

      final userFuture = container.watch(userDetailProvider('456'));
      await container.pump();

      expect(userFuture.isLoading, false);
      expect(userFuture.hasError, true);
      expect(userFuture.error.toString(), contains('User not found'));
    });
  });
}
```

**Penjelasan Testing:**

- **`ProviderContainer`:** Di dalam _test_, Anda membuat instance `ProviderContainer` sendiri. Ini menyediakan lingkup isolasi untuk _provider_ Anda, yang sempurna untuk _testing_.
- **`overrides`:** Properti `overrides` pada `ProviderContainer` memungkinkan Anda untuk mengganti _provider_ asli dengan implementasi _mock_ atau palsu. Di sini, `userApiClientProvider` diganti dengan `MockUserApiClient`.
- **`addTearDown(container.dispose)`:** Penting untuk membuang `ProviderContainer` setelah setiap _test_ untuk membersihkan sumber daya dan mencegah _state_ antar _test_ bocor.
- **`container.watch` & `container.read`:** Anda dapat menggunakan `watch` dan `read` pada `ProviderContainer` di dalam _test_ Anda, sama seperti `ref` di widget.
- **`container.pump()`:** Untuk `FutureProvider` dan `StreamProvider`, Anda perlu memanggil `container.pump()` (mirip dengan `tester.pump()` di _widget test_) untuk menunggu Future/Stream selesai.

**Terminologi Esensial:**

- **`ProviderScope`:** Widget di _root_ aplikasi yang menginisialisasi Riverpod.
- **`ProviderContainer`:** Lingkungan yang menyimpan _state_ semua _provider_. Digunakan untuk _testing_ atau aplikasi multi-lingkup.
- **`ref` (ProviderRef / WidgetRef):** Objek yang digunakan untuk berinteraksi dengan _provider_ (membaca, mendengarkan, memanggil metode) di dalam _callback_ _provider_ atau metode `build` widget.
- **`StateProvider`:** Untuk _state_ sederhana yang dapat diubah (seringkali primitif).
- **`StateNotifierProvider`:** Untuk _state_ kompleks dan _business logic_ yang dienkapsulasi dalam kelas `StateNotifier`.
- **`AsyncValue<T>`:** Sebuah _union type_ (data, loading, error) yang digunakan oleh `FutureProvider` dan `StreamProvider` untuk merepresentasikan status operasi asinkron.
- **`ref.onDispose()`:** _Callback_ yang didaftarkan untuk membersihkan sumber daya saat _provider_ tidak lagi aktif.
- **Dependency Overrides:** Kemampuan untuk mengganti implementasi _provider_ dengan yang lain, sangat berguna untuk _testing_.

**Sumber Referensi Lengkap:**

- [Riverpod Official Documentation](https://riverpod.dev/) - Dokumentasi yang sangat baik dan komprehensif.
- [Why Riverpod? (Riverpod documentation)](https://www.google.com/search?q=https://riverpod.dev/docs/concepts/why_riverpod) - Penjelasan mengapa Riverpod dibuat dan keunggulannya.
- [Testing Riverpod (Riverpod documentation)](https://riverpod.dev/docs/cookbooks/testing) - Panduan mendalam tentang pengujian dengan Riverpod.

**Tips dan Praktik Terbaik:**

- **Prioritaskan Riverpod di Proyek Baru:** Jika Anda memulai proyek baru, pertimbangkan Riverpod sebagai alternatif modern dan lebih aman dari `provider`.
- **Gunakan `ConsumerWidget` / `ConsumerStatefulWidget`:** Ini adalah cara paling umum dan efisien untuk mengonsumsi _provider_.
- **Deklarasikan `Provider` di File Terpisah:** Untuk menjaga kode tetap rapi, deklarasikan _provider_ Anda di file `.dart` terpisah (misalnya `providers/counter_provider.dart`, `models/todo.dart`, `notifiers/todos_notifier.dart`).
- **Manfaatkan `AsyncValue.when()`:** Ini adalah cara yang sangat deklaratif dan bersih untuk menangani _loading_, _data_, dan _error_ _state_ dari `FutureProvider` dan `StreamProvider`.
- **Gunakan `ref.watch` di `build` method, `ref.read` di _callback_:** Ikuti pola ini untuk memastikan reaktivitas yang benar tanpa _rebuild_ yang tidak perlu.
- **Bersihkan Sumber Daya:** Selalu gunakan `ref.onDispose()` untuk membersihkan `StreamController`, `Timer`, atau sumber daya lain yang dibuat di dalam _provider_ untuk mencegah kebocoran memori.
- **Pertimbangkan `riverpod_generator`:** Untuk proyek yang lebih besar, `riverpod_generator` (dengan `build_runner`) dapat menyederhanakan deklarasi _provider_ dan menghasilkan kode _boilerplate_ secara otomatis, terutama untuk `Notifier` atau `AsyncNotifier`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Lupa membungkus aplikasi dengan `ProviderScope`.

  - **Penyebab:** Riverpod tidak dapat menemukan `ProviderContainer` untuk menyimpan _state_.
  - **Solusi:** Pastikan `ProviderScope` adalah _ancestor_ dari semua widget yang akan mengonsumsi _provider_.

- **Kesalahan:** Mencoba memanggil `ref.watch` atau `ref.read` di luar `build` method atau _callback_ _provider_.

  - **Penyebab:** Objek `ref` hanya tersedia di lingkungan tertentu (`build` method `ConsumerWidget`, `State` dari `ConsumerStatefulWidget`, atau di _callback_ `create` _provider_).
  - **Solusi:** Pastikan Anda berada di lingkungan yang tepat. Gunakan `ref.read` di _callback_ seperti `onPressed`.

- **Kesalahan:** Mengubah _state_ `StateProvider` atau `StateNotifierProvider` dengan cara yang tidak _immutable_ (misalnya, memodifikasi list yang sudah ada).

  - **Penyebab:** Riverpod mendeteksi perubahan _state_ dengan membandingkan _instance_ _state_ yang lama dengan yang baru. Jika Anda memodifikasi _instance_ yang sama, Riverpod tidak akan mendeteksi perubahan dan UI tidak akan diperbarui.
  - **Solusi:** Selalu buat _instance_ baru dari _state_ Anda saat memodifikasinya. Contoh: `state = [...state, newTodo]` (untuk list), atau `state = state.copyWith(field: newValue)` (untuk objek).

- **Kesalahan:** Kebocoran memori karena tidak membersihkan `StreamController` atau `Timer` di _provider_.

  - **Penyebab:** Anda membuat sumber daya di dalam `StreamProvider` atau `Provider` yang tidak di-_dispose_ saat _provider_ tidak lagi aktif.
  - **Solusi:** Gunakan `ref.onDispose(() { ... });` untuk membersihkan sumber daya tersebut.

---

### 6.5 BLoC (Business Logic Component) / Cubit

BLoC (Business Logic Component) adalah arsitektur _state management_ yang sangat populer dan sering digunakan dalam aplikasi Flutter skala besar atau perusahaan. BLoC didasarkan pada konsep _reactive programming_, di mana _state_ aplikasi direpresentasikan sebagai _streams_ dari _event_ dan _state_. Cubit adalah turunan yang lebih sederhana dari BLoC.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami filosofi BLoC/Cubit sebagai solusi _state management_ yang _robust_ dan _predictable_. Mereka akan belajar bagaimana memisahkan _business logic_ dari UI secara ketat menggunakan _event_ sebagai _input_ dan _state_ sebagai _output_. Konsep _streams_, _sink_, dan _bloc observer_ akan dijelaskan. Mereka akan diajarkan cara menggunakan _package_ `flutter_bloc` untuk mengintegrasikan BLoC/Cubit ke dalam UI Flutter, serta bagaimana melakukan _testing_ secara efektif. Ini akan membekali mereka dengan salah satu alat _state management_ paling kuat di ekosistem Flutter.

**Konsep Kunci & Filosofi Mendalam:**

- **Business Logic Component (BLoC):** Sebuah pola arsitektur yang mengisolasi _business logic_ dari _presentation layer_ (UI). Ia memproses _event_ (input) dan menghasilkan _state_ (output).
  - **Filosofi:** Membuat aplikasi lebih _scalable_, _testable_, dan _maintainable_ dengan pemisahan yang jelas antara "apa yang terjadi" (events), "bagaimana menanganinya" (logic), dan "apa yang ditampilkan" (state).
- **Reactive Programming / Streams:** BLoC secara inheren didasarkan pada konsep _streams_. _Events_ adalah _stream_ _input_, dan _states_ adalah _stream_ _output_.
  - **Filosofi:** Memungkinkan _flow_ data asinkron dan reaktif, di mana perubahan _state_ secara otomatis disebarkan ke UI yang mendengarkan.
- **Events:** Representasi dari semua tindakan yang dapat terjadi di aplikasi Anda yang memengaruhi _state_ (misalnya, `UserLoggedIn`, `ProductAdded`, `DataFetched`).
  - **Filosofi:** Mengubah tindakan pengguna atau sistem menjadi objek yang terdefinisi dengan baik, membuat _state transition_ lebih eksplisit dan dapat dilacak.
- **States:** Representasi dari _state_ aplikasi pada suatu waktu tertentu, sebagai respons terhadap _events_. Biasanya berupa kelas _immutable_ untuk mempermudah perbandingan dan menghindari mutasi yang tidak disengaja.
  - **Filosofi:** Memberikan _snapshot_ yang konsisten dari UI yang harus ditampilkan, memungkinkan UI untuk "bereaksi" terhadap perubahan _state_ ini.
- **Cubit:** Turunan yang lebih sederhana dari BLoC. Cubit menggunakan metode langsung untuk mengubah _state_ daripada _event_. Ini cocok untuk _state management_ yang lebih sederhana atau ketika Anda tidak memerlukan _event_ yang kompleks.
  - **Filosofi:** Menyediakan cara yang lebih ringan untuk mengimplementasikan pola BLoC tanpa _boilerplate_ _event_ jika tidak diperlukan.
- **Predictability:** Karena setiap perubahan _state_ dipicu oleh _event_ yang jelas dan menghasilkan _state_ yang terdefinisi dengan baik, aliran data di BLoC sangat _predictable_.
  - **Filosofi:** Mempermudah _debugging_, _reasoning_ tentang kode, dan _scaling_ aplikasi.

**Visualisasi Diagram Alur/Struktur:**

- **BLoC Flow Diagram:**

  ```
  +-----------------+        +---------------------+
  |      UI         |        |   Business Logic    |
  | (Widgets)       |        |      (BLoC)         |
  +-----------------+        +---------------------+
          ^                               |
          | (Build based on State)        | (Maps Events to States)
          |                               v
  +-----------------+        +---------------------+
  |     BlocBuilder | <----- |      Stream of      |
  |  BlocListener   |        |        States       |
  |    (Observes)   |        | (Stream<State>)     |
  +-----------------+        +---------------------+
          ^                               |
          | (Add Event)                   | (Processes Event)
          |                               v
  +-----------------+        +---------------------+
  |   User Input    | ---->  |      Stream of      |
  |   (Events)      |        |        Events       |
  | (BlocProvider)  |        | (Stream<Event>)     |
  +-----------------+        +---------------------+
  ```

- **Cubit Flow Diagram:**

  ```
  +-----------------+        +---------------------+
  |      UI         |        |   Business Logic    |
  | (Widgets)       |        |      (Cubit)        |
  +-----------------+        +---------------------+
          ^                               |
          | (Build based on State)        | (Emits new State)
          |                               v
  +-----------------+        +---------------------+
  |     BlocBuilder | <----- |        Stream of    |
  |  BlocListener   |        |        States       |
  |    (Observes)   |        | (Stream<State>)     |
  +-----------------+        +---------------------+
          ^                               |
          | (Call Method)                 | (Directly changes State)
          |                               v
  +-----------------+        +---------------------+
  |   User Input    | ---->  |       Method        |
  | (BlocProvider)  |        |     Call (e.g.    |
  +-----------------+        |     increment())    |
  +-----------------+        +---------------------+
  ```

**Hubungan dengan Modul Lain:**
Sangat bergantung pada `5.1 Asynchronous Programming` (Streams). Membangun di atas konsep pemisahan tanggung jawab yang diperkenalkan di `6.1 Pengenalan Konsep State Management` dan `6.3 Provider Package`. Kemampuan _testing_ BLoC yang kuat akan sangat penting di `Fase 10: Testing`. Sering digunakan bersama dengan `dependency injection` seperti `GetIt` (dibahas di `6.7`) untuk menyuntikkan _dependencies_ ke dalam BLoC/Cubit.

---

#### 6.5.1 Filosofi BLoC dan Cubit

Untuk menggunakan `flutter_bloc` dan `bloc`, tambahkan dependensi di `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.5 # Periksa versi terbaru di pub.dev
  bloc: ^8.1.4 # Periksa versi terbaru di pub.dev

dev_dependencies:
  # Untuk testing
  bloc_test: ^9.1.5 # Periksa versi terbaru
  mockito: ^5.4.4 # Periksa versi terbaru
  build_runner: ^2.4.6 # Untuk code generation (jika mockito digunakan)
```

Kemudian jalankan `flutter pub get`.

**Filosofi BLoC:**

BLoC adalah singkatan dari **Business Logic Component**. Filosofinya adalah untuk memisahkan _business logic_ dari _UI layer_. Setiap fitur atau bagian aplikasi yang kompleks akan memiliki satu atau lebih BLoC.

BLoC beroperasi pada dua konsep utama: **Events** dan **States**.

- **Events (Input):** Ini adalah masukan ke BLoC. _Events_ adalah representasi dari tindakan pengguna (misalnya, `ButtonPressed`, `TextFieldChanged`), _lifecycle events_ (`PageLoaded`), atau respons dari API (`DataReceived`). Mereka dikirim ke BLoC melalui sebuah _sink_.
- **States (Output):** Ini adalah keluaran dari BLoC. _States_ merepresentasikan _snapshot_ dari data yang relevan dan _UI state_ yang harus ditampilkan (misalnya, `LoadingState`, `LoadedState(data)`, `ErrorState`). Mereka dipancarkan oleh BLoC sebagai sebuah _stream_.

**Hubungan:** BLoC menerima _events_, memprosesnya menggunakan _business logic_, dan kemudian memancarkan _states_ baru. UI mendengarkan _stream_ _states_ ini dan membangun ulang dirinya sesuai dengan _state_ terbaru.

**Contoh Sederhana BLoC (Counter):**

```dart
// Part 1: Events
// Semua event untuk CounterBloc
abstract class CounterEvent {} // Base class untuk event

class CounterIncrement extends CounterEvent {} // Event untuk menambah counter
class CounterDecrement extends CounterEvent {} // Event untuk mengurangi counter

// Part 2: States
// Semua state untuk CounterBloc
abstract class CounterState { // Base class untuk state
  final int count;
  CounterState(this.count);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterState && runtimeType == other.runtimeType && count == other.count;

  @override
  int get hashCode => count.hashCode;
}

class CounterInitial extends CounterState {
  CounterInitial() : super(0);
}

class CounterLoaded extends CounterState {
  CounterLoaded(int count) : super(count);
}


// Part 3: BLoC
// BLoC yang memproses event dan mengeluarkan state
import 'package:bloc/bloc.dart'; // Import bloc package
import 'package:flutter/foundation.dart'; // Untuk @immutable

// Gunakan @immutable untuk menandai event/state sebagai immutable
@immutable
abstract class CounterEvent {}
class CounterIncrement extends CounterEvent {}
class CounterDecrement extends CounterEvent {}

@immutable
abstract class CounterState {
  final int count;
  const CounterState(this.count);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterState && runtimeType == other.runtimeType && count == other.count;

  @override
  int get hashCode => count.hashCode;
}

class CounterInitial extends CounterState {
  const CounterInitial() : super(0);
}

class CounterLoaded extends CounterState {
  const CounterLoaded(int count) : super(count);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // Initial state dari BLoC
  CounterBloc() : super(const CounterInitial()) {
    // Mapping Event ke State
    // on<EventType>((event, emit) { ... })
    on<CounterIncrement>((event, emit) {
      // emit adalah fungsi untuk mengeluarkan state baru
      emit(CounterLoaded(state.count + 1));
    });

    on<CounterDecrement>((event, emit) {
      if (state.count > 0) { // Contoh logic: tidak bisa kurang dari 0
        emit(CounterLoaded(state.count - 1));
      }
    });
  }
}
```

**Filosofi Cubit:**

Cubit adalah alternatif yang lebih ringan untuk BLoC. Cubit tidak menggunakan _event_. Sebaliknya, ia mengekspos metode langsung yang dapat dipanggil untuk mengubah _state_. Setiap metode ini kemudian secara langsung memanggil `emit()` untuk mengeluarkan _state_ baru.

Cubit cocok untuk _state management_ yang lebih sederhana di mana Anda tidak perlu memodelkan _input_ sebagai _event_ yang berbeda atau tidak memerlukan fitur canggih dari BLoC (seperti _debounce_ atau _throttle_ pada _event streams_).

**Hubungan:** Cubit tetap mempertahankan pemisahan _business logic_ dan _presentation_, namun dengan API yang lebih sederhana. Ini masih mengeluarkan _stream_ _states_ seperti BLoC.

**Contoh Sederhana Cubit (Counter):**

```dart
import 'package:bloc/bloc.dart'; // Import bloc package
import 'package:flutter/foundation.dart'; // Untuk @immutable

// States untuk CounterCubit (bisa sama dengan BLoC states)
@immutable
abstract class CounterState {
  final int count;
  const CounterState(this.count);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterState && runtimeType == other.runtimeType && count == other.count;

  @override
  int get hashCode => count.hashCode;
}

class CounterInitial extends CounterState {
  const CounterInitial() : super(0);
}

class CounterLoaded extends CounterState {
  const CounterLoaded(int count) : super(count);
}

class CounterCubit extends Cubit<CounterState> {
  // Initial state dari Cubit
  CounterCubit() : super(const CounterInitial());

  void increment() {
    // emit adalah fungsi untuk mengeluarkan state baru
    emit(CounterLoaded(state.count + 1));
  }

  void decrement() {
    if (state.count > 0) {
      emit(CounterLoaded(state.count - 1));
    }
  }
}
```

**Perbandingan BLoC vs Cubit:**

| Fitur                   | BLoC                                                                                                                                           | Cubit                                                                                                                                                   |
| :---------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Input**               | Events (via `add()`)                                                                                                                           | Metode langsung (e.g., `increment()`)                                                                                                                   |
| **Output**              | Stream of States (via `emit()`)                                                                                                                | Stream of States (via `emit()`)                                                                                                                         |
| **Kompleksitas**        | Lebih kompleks, cocok untuk logika kompleks                                                                                                    | Lebih sederhana, cocok untuk logika dasar                                                                                                               |
| **Boilerplate**         | Lebih banyak (Event dan State classes)                                                                                                         | Lebih sedikit (hanya State classes)                                                                                                                     |
| **Debugging**           | Sangat _predictable_ karena _event_                                                                                                            | Cukup _predictable_                                                                                                                                     |
| **Transformasi Stream** | Mendukung operator RxDart pada _events_                                                                                                        | Tidak secara langsung pada _events_                                                                                                                     |
| **Kapan Digunakan**     | Ketika logika bisnis sangat kompleks dan Anda ingin _trace_ setiap tindakan pengguna/sistem secara eksplisit. Ideal untuk aplikasi enterprise. | Ketika logika bisnis lebih sederhana dan Anda ingin mengurangi _boilerplate_. Sering digunakan sebagai pilihan _default_ sebelum beralih ke BLoC penuh. |

**Terminologi Esensial:**

- **`Bloc`:** Kelas inti yang memproses _event_ dan mengeluarkan _state_.
- **`Cubit`:** Kelas yang lebih sederhana yang langsung memodifikasi _state_ dan mengeluarkannya.
- **`Event`:** Objek yang merepresentasikan input atau tindakan yang memicu perubahan _state_.
- **`State`:** Objek yang merepresentasikan _snapshot_ dari _state_ aplikasi pada waktu tertentu.
- **`emit(newState)`:** Metode yang digunakan oleh BLoC/Cubit untuk mengeluarkan _state_ baru ke _stream_.
- **`on<EventType>((event, emit) { ... })`:** Metode yang digunakan di BLoC untuk mendaftarkan _handler_ untuk _event_ tertentu.
- **`Stream`:** Urutan data asinkron. BLoC/Cubit mengeluarkan _state_ sebagai _stream_.
- **`@immutable`:** Anotasi yang disarankan untuk kelas _event_ dan _state_ untuk menandai bahwa objek tidak boleh diubah setelah dibuat. Ini penting untuk memastikan deteksi perubahan _state_ yang benar.

**Sumber Referensi Lengkap:**

- [BLoC Library Official Documentation](https://bloclibrary.dev/) - Dokumentasi resmi yang sangat lengkap dan direkomendasikan.
- [Why BLoC? (BLoC Library)](https://www.google.com/search?q=https://bloclibrary.dev/%23/whybloc) - Penjelasan mendalam tentang filosofi BLoC.
- [Cubit Documentation (BLoC Library)](https://www.google.com/search?q=https://bloclibrary.dev/%23/cubit) - Panduan spesifik tentang Cubit.

**Tips dan Praktik Terbaik:**

- **Mulai dengan Cubit:** Jika Anda ragu, mulailah dengan Cubit. Jika logika menjadi terlalu kompleks dan Anda membutuhkan _event_ yang lebih eksplisit atau fitur _stream_ lanjutan, Anda bisa dengan mudah bermigrasi ke BLoC penuh.
- **Buat _State_ dan _Event_ _Immutable_:** Selalu pastikan kelas _state_ dan _event_ Anda _immutable_. Gunakan `copyWith` untuk membuat salinan baru dari _state_ dengan perubahan. Ini penting untuk deteksi perubahan yang benar oleh `flutter_bloc` dan untuk menghindari _bug_ yang sulit dilacak.
- **Satu BLoC per Fitur:** Hindari BLoC yang terlalu besar. Idealnya, setiap BLoC/Cubit harus bertanggung jawab atas satu bagian _state_ atau fitur yang kohesif.
- **Folder Structure:** Atur file BLoC/Cubit Anda dalam struktur folder yang rapi:
  ```
  lib/
  ├── features/
  │   ├── counter/
  │   │   ├── bloc/
  │   │   │   ├── counter_bloc.dart
  │   │   │   ├── counter_event.dart
  │   │   │   └── counter_state.dart
  │   │   └── view/
  │   │       └── counter_page.dart
  │   └── auth/
  │       ├── cubit/
  │       │   ├── auth_cubit.dart
  │       │   └── auth_state.dart
  │       └── view/
  │           └── auth_page.dart
  ```
- **Jangan `emit` Langsung dari UI:** UI tidak boleh langsung memanggil `emit()` pada BLoC/Cubit. Sebaliknya, UI harus menambahkan _event_ (untuk BLoC) atau memanggil metode (untuk Cubit), dan BLoC/Cubit yang akan bertanggung jawab untuk memancarkan _state_ baru.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** _State_ tidak berubah di UI meskipun `emit()` dipanggil.

  - **Penyebab:** _State_ Anda tidak _immutable_, dan Anda memodifikasi _instance_ _state_ yang sama daripada mengeluarkan _instance_ baru.
  - **Solusi:** Pastikan `State` Anda adalah kelas _immutable_ dan Anda selalu meng-`emit` _instance_ `State` yang baru (seringkali menggunakan `copyWith` method).

- **Kesalahan:** `BlocProvider` tidak ditemukan.

  - **Penyebab:** Anda mencoba mengakses BLoC/Cubit dari widget yang tidak berada di bawah `BlocProvider` yang sesuai di pohon widget.
  - **Solusi:** Pastikan `BlocProvider` ditempatkan setinggi mungkin di pohon widget sehingga semua widget yang memerlukannya dapat mengaksesnya. Gunakan `MultiBlocProvider` jika ada banyak BLoC/Cubit.

- **Kesalahan:** _Boilerplate_ yang terlalu banyak untuk BLoC sederhana.

  - **Penyebab:** Menggunakan BLoC untuk _state_ yang sangat sederhana yang hanya memiliki satu atau dua tindakan.
  - **Solusi:** Pertimbangkan untuk menggunakan Cubit sebagai gantinya untuk kasus-kasus yang lebih sederhana.

---

#### 6.5.2 Events, States, dan Streams

Memahami `Events`, `States`, dan `Streams` adalah inti dari penguasaan BLoC. Ketiga konsep ini bekerja sama untuk menciptakan aliran data reaktif dan _predictable_ dalam aplikasi Flutter Anda.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mendalami definisi dan tujuan setiap komponen: `Event` sebagai pemicu tindakan, `State` sebagai hasil tindakan, dan `Stream` sebagai jembatan yang menghubungkan keduanya. Mereka akan belajar bagaimana mendefinisikan kelas `Event` (input) dan `State` (output) secara _immutable_ untuk berbagai skenario (misalnya, _loading_, _data_, _error_). Penekanan akan diberikan pada penggunaan `Stream` untuk mengalirkan _event_ ke BLoC dan menerima _state_ dari BLoC, serta pentingnya _immutability_ untuk deteksi perubahan yang benar.

**Konsep Kunci & Filosofi Mendalam:**

- **Events sebagai Input (Source of Truth for Actions):**

  - **Konsep:** `Events` adalah objek yang mewakili apa yang terjadi di aplikasi Anda. Ini bisa berupa interaksi pengguna (misalnya, `ButtonPressed`), data yang diterima dari API (`DataLoaded`), atau _lifecycle events_ (misalnya, `ScreenInitialized`). Mereka adalah _input_ ke BLoC.
  - **Filosofi:** Dengan merepresentasikan setiap tindakan sebagai `Event` yang eksplisit, BLoC memastikan bahwa semua perubahan _state_ dipicu oleh alasan yang jelas. Ini meningkatkan _predictability_ dan kemampuan _debugging_. `Events` juga sering membawa _payload_ data yang diperlukan untuk memproses tindakan tersebut.

- **States sebagai Output (Representation of UI):**

  - **Konsep:** `States` adalah objek yang merepresentasikan _snapshot_ dari data dan _UI state_ pada waktu tertentu. Ini adalah _output_ dari BLoC. UI mendengarkan _stream_ `States` ini dan membangun ulang dirinya sesuai dengan `State` terbaru.
  - **Filosofi:** `States` harus sepenuhnya menggambarkan bagaimana UI harus terlihat. Dengan demikian, UI menjadi fungsi murni dari `State`. Ketika `State` berubah, UI tahu persis bagaimana harus beradaptasi. Menggunakan _immutable_ `States` sangat penting; ini berarti setiap perubahan _state_ menghasilkan _instance_ `State` yang baru, memungkinkan _framework_ untuk secara efisien mendeteksi perubahan.

- **Streams sebagai Jembatan (Reactive Data Flow):**

  - **Konsep:** `Streams` adalah urutan data asinkron. Dalam BLoC, `Events` mengalir ke BLoC melalui _input stream_ (secara internal diimplementasikan oleh _package_ BLoC), dan BLoC mengeluarkan `States` melalui _output stream_ (`Stream<State>`).
  - **Filosofi:** `Streams` memungkinkan pola _reactive programming_ di mana BLoC secara otomatis bereaksi terhadap `Events` yang masuk dan memancarkan `States` baru ke semua _listener_ (widget UI). Ini menghilangkan kebutuhan untuk _callback_ atau _manual updates_, menciptakan _flow_ data yang lebih bersih dan efisien.

**Visualisasi Diagram Alur/Struktur:**

- **Detailed BLoC Data Flow:**
  ```
  +------------------------------------------+
  |             User Interface               |
  |  (e.g., Button click, Text input)        |
  +------------------------------------------+
                |
                |  `bloc.add(Event())`
                V
  +------------------------------------------+
  |             BLoC/Cubit                   |
  |  (Maps Events to States / Emits States)  |
  |  `on<Event>((event, emit) { ... })`      |
  |  `emit(newState)`                        |
  +------------------------------------------+
                |
                |  `Stream<State>`
                V
  +------------------------------------------+
  |             UI Widgets                   |
  |  (e.g., BlocBuilder, BlocConsumer)       |
  |  (Listens to `Stream<State>`)            |
  +------------------------------------------+
  ```
- **State Classification Diagram:** Pohon klasifikasi untuk `State` (misalnya: `LoginState` -\> `LoginInitial`, `LoginLoading`, `LoginSuccess`, `LoginFailure`).
- **Event Classification Diagram:** Pohon klasifikasi untuk `Event` (misalnya: `LoginEvent` -\> `LoginRequested`, `LogoutRequested`).

**Hubungan dengan Modul Lain:**
Sangat mendalam pada `Fase 5: Asynchronous Programming` terutama bagian `5.1.2 Streams dan StreamController`. Konsep _immutability_ dari `Fase 3: Object-Oriented Programming (Dart)` juga sangat relevan.

---

**Sintaks Dasar / Contoh Implementasi Inti:**

Mari kita ambil contoh sederhana manajemen _state_ untuk autentikasi pengguna. Kita akan memiliki `AuthState` yang merepresentasikan status login pengguna, dan `AuthEvent` yang merepresentasikan tindakan login/logout.

```dart
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart'; // Untuk @immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- 1. Define Events ---
// Events merepresentasikan input ke AuthBloc.
// Semua event untuk AuthBloc. Gunakan abstract class sebagai base.
@immutable // Penting untuk menandai event sebagai immutable
abstract class AuthEvent {}

// Event ketika pengguna ingin login
class AuthLoginRequested extends AuthEvent {
  final String username;
  final String password;

  AuthLoginRequested({required this.username, required this.password});

  @override
  String toString() => 'AuthLoginRequested { username: $username }';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthLoginRequested &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          password == other.password;

  @override
  int get hashCode => username.hashCode ^ password.hashCode;
}

// Event ketika pengguna ingin logout
class AuthLogoutRequested extends AuthEvent {
  AuthLogoutRequested();

  @override
  String toString() => 'AuthLogoutRequested';
}

// --- 2. Define States ---
// States merepresentasikan output dari AuthBloc, yaitu state autentikasi saat ini.
// Semua state untuk AuthBloc. Gunakan abstract class sebagai base.
@immutable // Penting untuk menandai state sebagai immutable
abstract class AuthState {
  const AuthState(); // Constructor konstan
}

// State awal: Pengguna belum terautentikasi
class AuthInitial extends AuthState {
  const AuthInitial();
}

// State ketika sedang memproses login/logout (misalnya, menampilkan loading spinner)
class AuthLoading extends AuthState {
  const AuthLoading();
}

// State ketika pengguna berhasil terautentikasi
class AuthAuthenticated extends AuthState {
  final String userId;
  final String username;

  const AuthAuthenticated({required this.userId, required this.username});

  @override
  String toString() => 'AuthAuthenticated { userId: $userId, username: $username }';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAuthenticated &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          username == other.username;

  @override
  int get hashCode => userId.hashCode ^ username.hashCode;
}

// State ketika autentikasi gagal
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  String toString() => 'AuthError { message: $message }';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthError && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;
}

// --- 3. Implement AuthBloc ---
// Bloc yang memproses AuthEvent dan mengeluarkan AuthState.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Initial state dari AuthBloc
  AuthBloc() : super(const AuthInitial()) {
    // Mendaftarkan handler untuk AuthLoginRequested event
    on<AuthLoginRequested>(_onLoginRequested);
    // Mendaftarkan handler untuk AuthLogoutRequested event
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  // Metode untuk menangani AuthLoginRequested event
  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading()); // Emit state Loading
    try {
      // Simulasi panggilan API login
      await Future.delayed(const Duration(seconds: 2));
      if (event.username == 'user' && event.password == 'pass') {
        // Jika berhasil, emit state Authenticated
        emit(AuthAuthenticated(userId: '123', username: event.username));
      } else {
        // Jika gagal, emit state Error
        emit(const AuthError('Invalid credentials'));
      }
    } catch (e) {
      // Tangani exception lainnya
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  // Metode untuk menangani AuthLogoutRequested event
  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading()); // Emit state Loading
    try {
      // Simulasi panggilan API logout
      await Future.delayed(const Duration(seconds: 1));
      // Setelah logout, kembali ke state Initial
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }

  // --- Optional: BlocObserver untuk logging ---
  // Anda bisa membuat BlocObserver kustom untuk mengamati semua transisi state
  // dan event di seluruh aplikasi.
  @override
  void onEvent(AuthEvent event) {
    super.onEvent(event);
    print('AuthBloc - Event: $event');
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    print('AuthBloc - Transition: ${transition.currentState} -> ${transition.nextState}');
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    print('AuthBloc - Error: $error');
  }
}

// Global BlocObserver untuk seluruh aplikasi
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('${bloc.runtimeType} Event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} Transition: ${transition.currentState} -> ${transition.nextState}');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('${bloc.runtimeType} Error: $error');
  }
}


// --- Main App ---
void main() {
  // Inisialisasi global BlocObserver
  Bloc.observer = SimpleBlocObserver();

  runApp(
    // BlocProvider menyediakan instance AuthBloc ke widget di bawahnya.
    BlocProvider(
      create: (context) => AuthBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth BLoC Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BlocBuilder digunakan untuk membangun ulang UI berdasarkan state dari BLoC.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth BLoC Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          // BlocConsumer adalah kombinasi dari BlocBuilder dan BlocListener.
          // Builder untuk membangun UI, Listener untuk efek samping.
          listener: (context, state) {
            // Ini akan dipanggil sekali untuk setiap perubahan state.
            if (state is AuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selamat datang, ${state.username}!')),
              );
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            // Ini akan membangun ulang UI setiap kali state berubah.
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthAuthenticated) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Anda telah login sebagai ${state.username}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Tambahkan AuthLogoutRequested event ke AuthBloc
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            } else if (state is AuthInitial || state is AuthError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Tambahkan AuthLoginRequested event ke AuthBloc
                      context.read<AuthBloc>().add(
                            AuthLoginRequested(
                              username: _usernameController.text,
                              password: _passwordController.text,
                            ),
                          );
                    },
                    child: const Text('Login'),
                  ),
                  if (state is AuthError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              );
            }
            return const SizedBox.shrink(); // Fallback
          },
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **Events (`AuthEvent`, `AuthLoginRequested`, `AuthLogoutRequested`):**

    - Definisi `Events` seringkali menggunakan kelas dasar abstrak (`AuthEvent`) dan kelas-kelas konkret yang meng-extend-nya.
    - Setiap `Event` merepresentasikan tindakan spesifik dan dapat membawa data yang diperlukan (`username`, `password` di `AuthLoginRequested`).
    - Sangat disarankan untuk membuat kelas `Event` **immutable** (`@immutable` anotasi dan mengimplementasikan `==` dan `hashCode`). Ini memastikan bahwa _event_ tidak berubah setelah dibuat, yang penting untuk _debugging_ dan _replaying_ _event_.

2.  **States (`AuthState`, `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `AuthError`):**

    - Definisi `States` juga menggunakan kelas dasar abstrak (`AuthState`) dan kelas-kelas konkret yang merepresentasikan _state_ yang berbeda dari _UI_.
    - Setiap `State` harus sepenuhnya menggambarkan _UI_ pada _state_ itu. Misalnya, `AuthAuthenticated` memiliki `userId` dan `username` yang diperlukan untuk menampilkan info pengguna.
    - `States` juga harus **immutable** (`@immutable` anotasi dan `==`, `hashCode`). Ketika _state_ berubah, BLoC akan mengeluarkan _instance_ `State` yang _baru_, dan `flutter_bloc` akan menggunakan perbedaan _instance_ untuk memicu _rebuild_ UI.

3.  **BLoC (`AuthBloc`):**

    - `AuthBloc` meng-extend `Bloc<AuthEvent, AuthState>`. Ini berarti ia menerima `AuthEvent` sebagai _input_ dan mengeluarkan `AuthState` sebagai _output_.
    - **Constructor:** `AuthBloc() : super(const AuthInitial())` menetapkan _state_ awal dari BLoC.
    - **`on<EventType>((event, emit) { ... })`:** Ini adalah _method_ utama untuk mendaftarkan _handler_ untuk setiap jenis `Event`. Ketika `AuthLoginRequested` ditambahkan ke BLoC, _handler_ `_onLoginRequested` akan dipanggil.
    - **`emit(newState)`:** Di dalam _handler_ _event_, fungsi `emit` digunakan untuk memancarkan _state_ baru ke _stream_ _state_ BLoC. Ini adalah satu-satunya cara BLoC dapat mengubah _state_ dan memberi tahu UI.

4.  **Streams (Implisit):**

    - Di balik layar, _package_ BLoC menggunakan `Streams` untuk mengelola _flow_ `Events` ke BLoC dan `States` dari BLoC.
    - Ketika Anda memanggil `bloc.add(event)`, _event_ tersebut ditambahkan ke _input stream_ internal BLoC.
    - Ketika BLoC memanggil `emit(state)`, _state_ tersebut ditambahkan ke _output stream_ (`Stream<State>`) BLoC.
    - `BlocBuilder` dan `BlocListener` kemudian mendengarkan _output stream_ ini untuk bereaksi terhadap perubahan _state_.

**Pentingnya Immutability:**

- **Deteksi Perubahan:** `flutter_bloc` mengandalkan perbandingan _reference_ untuk menentukan apakah _state_ telah berubah dan apakah UI perlu di-_rebuild_. Jika Anda mengubah properti pada _instance_ `State` yang sama dan kemudian `emit` _instance_ tersebut, _framework_ tidak akan mendeteksi perubahan. Oleh karena itu, selalu buat _instance_ baru dari `State` dengan nilai yang diperbarui.
  - Contoh: Daripada `state.count++; emit(state);` **(SALAH)**
  - Lakukan: `emit(MyState(count: state.count + 1));` **(BENAR)**
- **Predictability:** _Immutable_ `States` memastikan bahwa _state_ aplikasi selalu konsisten dan tidak dapat diubah secara tidak sengaja oleh bagian lain dari kode. Ini membuat _reasoning_ tentang _state transition_ jauh lebih mudah.
- **Concurrency Safety:** Dalam lingkungan _multithreaded_ atau asinkron, _immutable_ objek secara inheren _thread-safe_ karena nilainya tidak dapat berubah setelah dibuat.

**Terminologi Esensial (Revisi & Tambahan):**

- **`Event`:** Objek yang mewakili input atau tindakan yang memicu perubahan _state_. Harus _immutable_.
- **`State`:** Objek yang mewakili _snapshot_ _state_ aplikasi pada suatu waktu tertentu. Harus _immutable_.
- **`Stream<State>`:** Aliran _state_ yang dipancarkan oleh BLoC/Cubit, yang didengarkan oleh UI.
- **`add(Event event)`:** Metode yang digunakan untuk mengirim _event_ ke BLoC.
- **`emit(State newState)`:** Metode yang digunakan di dalam BLoC/Cubit untuk mengeluarkan _state_ baru ke _stream_ _output_.
- **`on<EventType>((event, emit) { ... })`:** Metode yang digunakan di BLoC untuk mendaftarkan _handler_ untuk _event_ tertentu.
- **`Transition<Event, State>`:** Objek yang berisi _current state_, _event_ yang diproses, dan _next state_. Berguna untuk _logging_ dan _debugging_ (dapat diamati dengan `BlocObserver`).
- **`BlocObserver`:** Kelas yang dapat Anda buat untuk mengamati semua _event_, _transition_, dan _error_ dari semua BLoC/Cubit di aplikasi Anda untuk tujuan _logging_ dan _debugging_.

**Sumber Referensi Lengkap:**

- [Events & States in BLoC (Official Docs)](https://www.google.com/search?q=https://bloclibrary.dev/%23/eventsandstates) - Penjelasan mendalam tentang bagaimana _event_ dan _state_ bekerja di BLoC.
- [Streams in Dart (Official Docs)](https://dart.dev/tutorials/language/streams) - Dasar-dasar Stream dalam bahasa Dart.
- [BlocObserver (Official Docs)](https://www.google.com/search?q=https://bloclibrary.dev/%23/blocobserver) - Cara menggunakan `BlocObserver` untuk _logging_.

**Tips dan Praktik Terbaik:**

- **Gunakan kelas dasar untuk Event/State:** Ini membantu dalam mengelompokkan _event_ dan _state_ yang terkait dan memudahkan penanganan.
- **Pastikan Immutability:** Gunakan `@immutable` anotasi dan buat _constructor_ konstan. Pertimbangkan untuk menggunakan _package_ seperti `equatable` (atau `freezed` untuk kasus yang lebih kompleks) untuk mengimplementasikan `==` dan `hashCode` secara otomatis, yang sangat membantu dalam memastikan _immutability_ yang benar.
- **`copyWith` method:** Untuk kelas `State` yang kompleks, tambahkan _method_ `copyWith()` untuk mempermudah pembuatan _instance_ `State` yang baru dengan beberapa perubahan pada properti tertentu, sambil menjaga properti lainnya tetap sama. Ini sangat memudahkan manajemen _state_ _immutable_.
- **Definisikan semua kemungkinan _state_:** Untuk setiap BLoC, pastikan Anda telah mendefinisikan semua kemungkinan _state_ yang dapat diambil oleh _UI_ Anda (misalnya: `Initial`, `Loading`, `Loaded`, `Error`, `Empty`).

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Memodifikasi `State` objek secara langsung, bukan meng-`emit` _instance_ baru.

  - **Penyebab:** Ini adalah kesalahan paling umum. `bloc` _package_ mengandalkan perbandingan _reference_ untuk memicu _rebuild_. Jika Anda mengubah properti pada objek yang ada dan tidak `emit` objek _baru_, UI tidak akan diperbarui.
  - **Solusi:** Selalu buat _instance_ `State` yang _baru_ setiap kali Anda memanggil `emit()`. Gunakan _copy constructor_ atau _method_ `copyWith()`.

- **Kesalahan:** Kelas `Event` atau `State` tidak mengimplementasikan `==` dan `hashCode` dengan benar.

  - **Penyebab:** Jika Anda tidak mengimplementasikan `==` dan `hashCode` untuk kelas _immutable_ Anda, perbandingan objek default akan dilakukan berdasarkan _reference_ memori. Ini dapat menyebabkan _rebuild_ yang tidak perlu (jika `==` selalu `false`) atau tidak ada _rebuild_ sama sekali (jika objek berbeda tetapi dianggap sama secara logis).
  - **Solusi:** Gunakan _package_ `equatable` atau `freezed` untuk secara otomatis mengimplementasikan `==` dan `hashCode` dengan benar.

- **Kesalahan:** Logika bisnis yang terlalu banyak dalam _handler_ _event_.

  - **Penyebab:** Menempatkan terlalu banyak _logic_ (misalnya, panggilan API langsung, _database operations_) di dalam _handler_ `on<Event>`.
  - **Solusi:** Pindahkan _business logic_ yang kompleks ke kelas _repository_ atau _service_ terpisah. BLoC kemudian akan memanggil metode dari _repository_ ini. Ini menjaga BLoC tetap ramping dan fokus pada pemetaan _event_ ke _state_.

---

# Selamat!

---

Kita telah menyelesaikan FASE 6. Selanjutnya kita akan masuk pada

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md

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
