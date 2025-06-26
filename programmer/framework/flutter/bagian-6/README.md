# FASE 4: State Management Fundamentals

Dengan selesainya **Fase 3: Navigation & Routing**, kita akan melangkah ke **Fase 4: State Management Fundamentals**. Fase ini sangat krusial karena _state management_ adalah inti dari bagaimana data dan UI aplikasi Anda berinteraksi dan berubah seiring waktu.

Berikut adalah daftar isi yang diperbarui untuk kurikulum, mencakup Fase 4:

<details>
  <summary>📃 Struktur Daftar Isi</summary>

- [FASE 4: State Management Fundamentals](#fase-4-state-management-fundamentals)
  - [Overview Fase](#overview-fase)
    - [4.1 Understanding State in Flutter](#41-understanding-state-in-flutter)
      - [4.1.1 Local State (`setState`) vs. App State](#411-local-state-setstate-vs-app-state)
      - [4.1.2 Why State Management is Needed (Challenges)](#412-why-state-management-is-needed-challenges)
      - [4.1.3 InheritedWidget (Basic Concept)](#413-inheritedwidget-basic-concept)
    - [4.2 Provider Package (Simple \& Recommended)](#42-provider-package-simple--recommended)
      - [4.2.1 `Provider`, `ChangeNotifier`, `ChangeNotifierProvider`](#421-provider-changenotifier-changenotifierprovider)
      - [4.2.2 `Consumer` and `Selector`](#422-consumer-and-selector)
      - [4.2.3 MultiProvider](#423-multiprovider)
    - [4.3 BLoC/Cubit (Introduction)](#43-bloccubit-introduction)
      - [4.3.1 Core Concepts of BLoC/Cubit](#431-core-concepts-of-bloccubit)
      - [4.3.2 Basic Implementation with `flutter_bloc`](#432-basic-implementation-with-flutter_bloc)
    - [4.4 Other State Management Approaches (Overview)](#44-other-state-management-approaches-overview)
      - [4.4.1 GetX (Brief Mention)](#441-getx-brief-mention)

</details>

## Overview Fase

**Deskripsi Fase:**
Fase ini akan memperkenalkan pembelajar pada konsep fundamental _state management_ di Flutter. Membangun aplikasi yang kompleks membutuhkan strategi yang jelas untuk mengelola data yang berubah dan bagaimana perubahan tersebut tercermin di UI. Pembelajar akan memahami berbagai jenis _state_, mengapa _state management_ yang terstruktur itu penting, dan akan mulai mendalami solusi populer seperti _Provider_ dan BLoC/Cubit, serta mengenal pendekatan lainnya. Penguasaan _state management_ adalah langkah besar menuju pengembangan aplikasi Flutter yang _scalable_, _maintainable_, dan berperforma tinggi.

**Tujuan Pembelajaran Fase:**
Setelah menyelesaikan fase ini, peserta akan mampu:

- Membedakan antara _local state_ dan _app state_ serta kapan harus menggunakan masing-masing.
- Memahami tantangan yang timbul dari _state_ yang tidak terkelola dengan baik.
- Menggunakan paket _Provider_ untuk mengelola _state_ di seluruh aplikasi.
- Memahami prinsip dasar _Business Logic Component_ (BLoC) atau Cubit.
- Mengimplementasikan solusi _state management_ dasar menggunakan _Provider_ dan BLoC/Cubit.
- Mengenali kapan dan mengapa pendekatan _state management_ yang berbeda digunakan.

**Hubungan dengan Fase Sebelumnya:**
Fase ini adalah kelanjutan logis dari Fase 2 (Widget System) dan Fase 3 (Navigation). Pemahaman tentang _StatelessWidget_ vs _StatefulWidget_ dan _Widget Tree_ adalah prasyarat mutlak. Navigasi seringkali melibatkan pengiriman data atau pemicuan perubahan _state_ antar layar, sehingga _state management_ akan mengikat semua konsep ini bersama-sama untuk menciptakan aplikasi yang dinamis dan kohesif.

**Durasi Estimasi:** 3-4 minggu

---

### 4.1 Understanding State in Flutter

Sub-bagian ini akan mengklarifikasi apa itu _state_ dalam konteks aplikasi Flutter dan mengapa pengelolaannya menjadi perhatian utama.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bahwa "state" adalah data yang dapat berubah selama aplikasi berjalan dan memengaruhi UI. Ini adalah fondasi untuk semua _state management_. Kami akan membedakan antara _state_ yang hanya relevan untuk satu _widget_ (`local state`) dan _state_ yang perlu dibagikan di berbagai bagian aplikasi (`app state`). Pemahaman yang kuat tentang konsep dasar ini sangat penting sebelum mendalami berbagai solusi _state management_.

**Konsep Kunci & Filosofi Mendalam:**

- **State as "Anything that can change over time":** Ini adalah definisi paling dasar dan luas dari _state_. Ini bisa berupa data pengguna, status _loading_, hasil panggilan API, nilai _checkbox_, dll.

  - **Filosofi:** Menekankan bahwa _state_ bukanlah konsep statis, melainkan representasi dinamis dari kondisi aplikasi pada waktu tertentu.

- **Reactive UI:** Flutter adalah kerangka kerja UI reaktif. Ini berarti UI secara otomatis diperbarui sebagai respons terhadap perubahan _state_.

  - **Filosofi:** Mengurangi _boilerplate_ manipulasi DOM/UI manual, memungkinkan pengembang untuk fokus pada _state_ dan bukan pada detail _rendering_. "UI adalah fungsi dari state."

- **Single Source of Truth:** Idealnya, untuk setiap bagian data, harus ada satu sumber kebenaran yang jelas. Ini mencegah _bug_ dan kebingungan data.

  - **Filosofi:** Prinsip ini adalah pendorong utama di balik kebutuhan akan solusi _state management_ yang terpusat untuk _app state_.

**Visualisasi Diagram Alur/Struktur:**

- Diagram sederhana yang menunjukkan _event_ (misalnya, klik tombol) -\> perubahan _state_ -\> _rebuild_ UI.
- Ilustrasi "lingkaran tertutup" dari data yang berubah, mempengaruhi tampilan, yang pada gilirannya dapat memicu perubahan data lagi.

**Hubungan dengan Modul Lain:**
Konsep ini adalah inti dari bagaimana `setState()` bekerja (dari Fase 2), dan juga bagaimana `TextEditingController` memengaruhi `TextField`. Ini akan menjadi dasar untuk memahami semua solusi _state management_ berikutnya.

---

#### 4.1.1 Local State (`setState`) vs. App State

Sub-bagian ini akan menjelaskan perbedaan fundamental antara _local state_ dan _app state_ serta kapan masing-masing digunakan.

**Deskripsi Konkret & Peran dalam Kurikulum:**

- **Local State**: Data yang dikelola dan diakses hanya di dalam satu `StatefulWidget` dan _sub-widget_ langsungnya. Perubahan pada _local state_ ditangani dengan memanggil `setState()`, yang kemudian memicu _rebuild_ pada _widget_ tersebut dan turunannya. Contoh: nilai _checkbox_, status _loading_ tombol, visibilitas _widget_ tertentu.
- **App State (Shared State/Global State)**: Data yang perlu dibagikan dan diakses oleh beberapa _widget_ yang mungkin berada di lokasi yang berbeda di _widget tree_, atau data yang perlu bertahan lintas navigasi. Contoh: status login pengguna, data keranjang belanja, tema aplikasi, daftar item dari API.

Pembelajar akan memahami bahwa sementara `setState()` sangat baik untuk _local state_, itu tidak _scalable_ untuk _app state_, yang menjadi alasan utama mengapa solusi _state management_ eksternal diperlukan.

**Konsep Kunci & Filosofi Mendalam:**

- **Encapsulation (Local State):** _Local state_ meng-enkapsulasi perubahan dalam lingkup _widget_ itu sendiri, menjaga kompleksitas tetap lokal.

  - **Filosofi:** Sesuai dengan prinsip pemisahan perhatian. Sebuah _widget_ hanya perlu tahu tentang _state_ yang menjadi tanggung jawabnya.

- **Prop Drilling / Callback Hell (Problem of App State without proper management):** Upaya untuk meneruskan _app state_ melalui banyak _widget_ perantara (`prop drilling`) atau mengelola banyak _callback_ untuk memperbarui _state_ di _ancestor_ (`callback hell`) akan menyebabkan kode yang tidak rapi dan sulit di-_maintain_.

  - **Filosofi:** Menyoroti masalah yang dipecahkan oleh solusi _state management_ yang lebih maju – yaitu, menyediakan cara yang lebih bersih untuk mengakses dan memperbarui _state_ di mana pun di _widget tree_ tanpa harus melewati setiap _widget_ perantara.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

// --- Contoh Local State (Menggunakan setState) ---
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  // Local state: Hanya relevan untuk CounterWidget ini
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('CounterWidget rebuilt: _counter = $_counter'); // Untuk melihat kapan widget di-rebuild
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Local Counter:',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          '$_counter',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

// --- Contoh App State (Skenario Problematic tanpa State Management) ---
// Ini adalah ilustrasi masalah "prop drilling"
class MyAppProblematicAppState extends StatelessWidget {
  const MyAppProblematicAppState({super.key});

  @override
  Widget build(BuildContext context) {
    // Anggap ini adalah root widget yang memegang 'app state'
    // Untuk demo, kita akan simulasikan passing state dari atas ke bawah
    final String appUser = 'Alice';
    final int appThemeId = 1; // 1=Light, 2=Dark

    return MaterialApp(
      title: 'Problematic App State Demo',
      theme: ThemeData(
        brightness: appThemeId == 1 ? Brightness.light : Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('App State (Problematic Demo)')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CounterWidget(), // Local state di sini
              const SizedBox(height: 50),
              // Meneruskan 'app state' secara manual ke bawah
              MiddleWidget(
                user: appUser,
                themeId: appThemeId,
                // Jika MiddleWidget perlu mengubah themeId,
                // kita perlu callback yang diteruskan dari atas
                onThemeChanged: (newThemeId) {
                  // Di sini akan jadi masalah karena MyAppProblematicAppState
                  // adalah StatelessWidget dan tidak bisa setState.
                  // Ini akan memerlukan MyAppProblematicAppState menjadi StatefulWidget
                  // dan meneruskan callback ke bawah, dst. => prop drilling / callback hell.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MiddleWidget extends StatelessWidget {
  final String user;
  final int themeId;
  final ValueChanged<int> onThemeChanged; // Callback untuk mengubah theme

  const MiddleWidget({
    super.key,
    required this.user,
    required this.themeId,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    print('MiddleWidget rebuilt: user=$user, themeId=$themeId');
    return Column(
      children: [
        Text(
          'User from App State: $user',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
        Text(
          'Theme ID from App State: $themeId',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        // Meneruskan state dan callback lebih jauh ke bawah
        DeepChildWidget(
          currentThemeId: themeId,
          onThemeChangeRequest: onThemeChanged, // Meneruskan callback
        ),
      ],
    );
  }
}

class DeepChildWidget extends StatelessWidget {
  final int currentThemeId;
  final ValueChanged<int> onThemeChangeRequest;

  const DeepChildWidget({
    super.key,
    required this.currentThemeId,
    required this.onThemeChangeRequest,
  });

  @override
  Widget build(BuildContext context) {
    print('DeepChildWidget rebuilt: currentThemeId=$currentThemeId');
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Mengubah theme id melalui callback
            final newThemeId = currentThemeId == 1 ? 2 : 1;
            onThemeChangeRequest(newThemeId); // Memicu callback ke atas
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Mengubah tema ke ID: $newThemeId')),
            );
          },
          child: const Text('Toggle Theme (via callback)'),
        ),
        const SizedBox(height: 20),
        const Text(
          'Lihat konsol untuk rebuild log saat counter atau theme berubah.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MyAppProblematicAppState()); // Jalankan contoh app state problematic
  // runApp(const CounterWidget()); // Jalankan contoh local state saja
}
```

**Penjelasan Konteks Kode:**

- **`CounterWidget` (Local State):**

  - Memiliki _state_ `_counter` yang hanya relevan untuk dirinya sendiri.
  - Metode `_incrementCounter()` memanggil `setState()` untuk memperbarui `_counter`, yang kemudian memicu `build()` metode `CounterWidget` untuk dipanggil ulang.
  - `print` _statement_ di `build` menunjukkan bahwa hanya `CounterWidget` yang dibangun ulang saat `_counter` berubah.

- **`MyAppProblematicAppState`, `MiddleWidget`, `DeepChildWidget` (App State Problematic):**

  - Ini adalah ilustrasi konsep _prop drilling_ dan _callback hell_.
  - Data _app state_ (`appUser`, `appThemeId`) awalnya ada di `MyAppProblematicAppState` (yang seharusnya adalah `StatefulWidget` agar bisa diubah, tetapi dibuat `StatelessWidget` untuk menyoroti masalahnya).
  - Data ini harus "dibor" (diteruskan sebagai properti) melalui `MiddleWidget` ke `DeepChildWidget` bahkan jika `MiddleWidget` tidak langsung menggunakan `themeId`.
  - Jika `DeepChildWidget` perlu _mengubah_ `appThemeId`, ia harus memanggil _callback_ (`onThemeChangeRequest`) yang diteruskan dari `MiddleWidget`, yang kemudian diteruskan dari `MyAppProblematicAppState` (jika `MyAppProblematicAppState` adalah `StatefulWidget` dan memiliki _state_ `themeId` yang bisa diubah).
  - Ini akan membuat kode sangat bertele-tele dan sulit dilacak, terutama jika ada banyak _widget_ di antara sumber _state_ dan konsumennya. `print` _statement_ akan menunjukkan bahwa `MiddleWidget` dan `DeepChildWidget` juga dibangun ulang setiap kali `themeId` berubah, bahkan jika mereka tidak selalu perlu di-_rebuild_ penuh.

**Visualisasi Diagram Alur/Struktur:**

- Diagram `CounterWidget`: Lingkaran tertutup kecil di dalam satu _widget_.
- Diagram `MyAppProblematicAppState`: Pohon _widget_ yang tinggi dengan data `appUser` dan `appThemeId` mengalir ke bawah dari _root_ melalui banyak _branch_ ke daun _widget_. Panah _callback_ yang "naik" ke atas juga akan ditunjukkan. Ini akan secara visual menunjukkan betapa rumitnya jalur data.

**Terminologi Esensial & Penjelasan Detail:**

- **State:** Data yang berubah selama _lifetime_ aplikasi dan memengaruhi UI.
- **Local State:** _State_ yang dikelola di dalam satu `StatefulWidget` dan hanya relevan untuk _widget_ itu. Diperbarui dengan `setState()`.
- **App State / Shared State / Global State:** _State_ yang perlu dibagikan di antara banyak _widget_ di berbagai lokasi di _widget tree_, atau _state_ yang perlu bertahan melintasi siklus hidup _widget_ atau navigasi.
- **`setState()`:** Metode di `State<T>` untuk memberi tahu Flutter bahwa _state_ telah berubah dan _widget_ perlu dibangun ulang.
- **Prop Drilling:** Fenomena meneruskan data dari _parent_ ke _child_ melalui beberapa tingkat _widget_ perantara yang sebenarnya tidak memerlukan data tersebut.
- **Callback Hell:** Situasi di mana banyak _callback_ berlapis-lapis diperlukan untuk mengkomunikasikan perubahan _state_ dari _child_ ke _ancestor_.

**Sumber Referensi Lengkap:**

- [Managing state in Flutter (Official Docs)](https://docs.flutter.dev/data/state-management/options)
- [What is state? (Official Docs)](https://docs.flutter.dev/data/state-management/declarative)
- [setState (Official Docs)](https://docs.flutter.dev/data/state-management/declarative%23setstate)

**Tips dan Praktik Terbaik:**

- **Mulai dengan `setState()`:** Untuk _state_ yang sederhana dan lokal, `setState()` adalah pilihan terbaik dan paling efisien. Jangan berlebihan menggunakan solusi _state management_ yang lebih kompleks jika tidak diperlukan.
- **Identifikasi Kebutuhan _App State_:** Ketika data perlu diakses oleh beberapa _widget_ atau bertahan di seluruh aplikasi, itu adalah indikasi kuat bahwa Anda memerlukan solusi _state management_ yang lebih canggih.
- **Hindari _Prop Drilling_ & _Callback Hell_:** Jika Anda menemukan diri Anda meneruskan properti atau _callback_ melalui 3+ tingkat _widget_, itu adalah tanda bahwa Anda mungkin memerlukan solusi _state management_.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mencoba memanggil `setState()` pada `StatelessWidget`.

  - **Penyebab:** `StatelessWidget` tidak memiliki _state_ internal yang dapat berubah.
  - **Solusi:** Ubah _widget_ menjadi `StatefulWidget` jika ia perlu mengelola _state_ yang berubah.

- **Kesalahan:** UI tidak diperbarui meskipun data telah berubah.

  - **Penyebab:** Lupa memanggil `setState()` setelah mengubah _state_ lokal, atau mengubah _state_ di luar `setState()` (misalnya, `_counter++;` tanpa `setState(() { ... });`).
  - **Solusi:** Pastikan semua perubahan _state_ yang harus memicu _rebuild_ dibungkus dalam panggilan `setState(() { ... });`.

- **Kesalahan:** Data _app state_ tidak sinkron antar _widget_.

  - **Penyebab:** Data yang sama dikelola secara terpisah oleh beberapa _widget_, atau tidak ada "sumber kebenaran tunggal".
  - **Solusi:** Ini adalah masalah yang akan dipecahkan oleh solusi _state management_ yang akan datang, seperti _Provider_ atau BLoC.

---

#### 4.1.2 Why State Management is Needed (Challenges)

Sub-bagian ini akan menguraikan masalah dan tantangan yang muncul saat membangun aplikasi Flutter yang kompleks tanpa strategi _state management_ yang tepat, menjelaskan mengapa solusi eksternal menjadi krusial.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan diperkenalkan pada masalah umum yang dihadapi pengembang ketika aplikasi tumbuh dan _state_ menjadi lebih kompleks. Ini akan memperkuat argumen mengapa solusi _state management_ yang terstruktur diperlukan. Tantangan-tantangan utama meliputi:

1.  **Prop Drilling / Boilerplate Code:** Meneruskan data melalui banyak tingkat _widget_ perantara yang tidak benar-benar menggunakan data tersebut.
2.  **Callback Hell:** Pengelolaan banyak _callback_ yang kompleks untuk mengkomunikasikan _event_ atau perubahan _state_ dari _child widget_ kembali ke _ancestor_.
3.  **Data Inconsistency / Single Source of Truth Problem:** Sulitnya memastikan semua bagian aplikasi memiliki versi _state_ yang sama dan terbaru.
4.  **Performance Issues (Unnecessary Rebuilds):** Seluruh sub-pohon _widget_ di-_rebuild_ meskipun hanya sebagian kecil _state_ yang berubah, menyebabkan kinerja yang buruk.
5.  **Testability:** Kesulitan dalam mengisolasi dan menguji logika bisnis karena terlalu terkait erat dengan _widget_ UI.
6.  **Maintainability & Scalability:** Kode menjadi sulit dipahami, diubah, dan diperluas seiring bertambahnya fitur.

**Konsep Kunci & Filosofi Mendalam:**

- **Separation of Concerns:** Memisahkan logika bisnis (bagaimana _state_ berubah) dari logika UI (bagaimana _state_ ditampilkan). Solusi _state management_ membantu mencapai pemisahan ini.

  - **Filosofi:** Mengurangi _coupling_ antara komponen, membuat kode lebih modular, mudah diuji, dan _maintainable_.

- **Efficiency in Rebuilding:** Mengurangi jumlah _widget_ yang di-_rebuild_ secara tidak perlu adalah kunci untuk kinerja aplikasi yang baik.

  - **Filosofi:** Memastikan bahwa hanya bagian UI yang benar-benar terpengaruh oleh perubahan _state_ yang dibangun ulang, mengoptimalkan penggunaan CPU dan memori.

**Visualisasi Diagram Alur/Struktur:**

- Diagram `Widget Tree` yang kompleks, dengan panah yang menunjukkan `prop drilling` dari atas ke bawah dan `callback hell` dari bawah ke atas.
- Ilustrasi "gelembung" data yang tersebar di banyak _widget_ tanpa kontrol terpusat, menyebabkan inkonsistensi.
- Diagram yang menunjukkan bagian besar dari _widget tree_ di-render ulang meskipun hanya satu _widget_ kecil yang perlu diperbarui.

**Hubungan dengan Modul Lain:**
Ini adalah motivasi langsung untuk seluruh pembahasan _state management_ di sisa Fase 4. Ini juga berhubungan erat dengan konsep _Widget Tree_ (Fase 2) dan bagaimana _rebuild_ bekerja.

---

**Contoh Ilustrasi Tantangan (Konseptual, Bukan Kode Implementasi Penuh):**

Bayangkan aplikasi e-commerce sederhana:

- **Layar A (Daftar Produk):** Menampilkan daftar produk dengan tombol "Tambahkan ke Keranjang".
- **Layar B (Detail Produk):** Menampilkan detail satu produk dengan tombol "Tambahkan ke Keranjang".
- **Layar C (Keranjang Belanja):** Menampilkan item di keranjang dan total harga.
- **Ikon Keranjang di `AppBar`:** Menampilkan jumlah item di keranjang.

**Tantangan Tanpa State Management yang Tepat:**

1.  **Prop Drilling & Callback Hell:**

    - `itemCount` di `AppBar` perlu diperbarui ketika item ditambahkan di Layar A atau Layar B.
    - Jika `AppBar` adalah _widget_ terpisah di `Scaffold`, bagaimana ia tahu perubahan?
    - Solusi primitif: Anda harus meneruskan _callback_ dari `main.dart` (tempat `itemCount` mungkin disimpan) ke `Scaffold`, lalu ke `AppBar` sebagai properti. Dan dari `Scaffold` utama, Anda harus meneruskan _callback_ ke Layar A, dan dari Layar A ke setiap `ProductCard`, dan dari `ProductCard` ke tombol "Tambahkan ke Keranjang".
    - Setiap kali tombol ditekan, ia memicu _callback_ yang memicu _callback_ lain yang akhirnya mencapai _root widget_ untuk memperbarui _state_. Ini akan menjadi sangat berantakan dan sulit dikelola seiring bertambahnya fitur (misalnya, menghapus item, mengubah kuantitas).

2.  **Data Inconsistency:**

    - Jika `itemCount` disimpan secara terpisah di Layar A dan Layar B, dan keduanya memiliki salinan data keranjang yang berbeda, maka ketika item ditambahkan di Layar A, Layar B tidak akan otomatis tahu. Jumlah di ikon keranjang bisa jadi salah.
    - Sulit untuk memastikan semua komponen UI yang menampilkan data keranjang selalu menampilkan data yang _terbaru_.

3.  **Performance Issues (Unnecessary Rebuilds):**

    - Jika `itemCount` keranjang disimpan di `StatefulWidget` di tingkat atas `MaterialApp`, maka setiap kali `itemCount` berubah (misalnya, ketika Anda menambahkan item ke keranjang), seluruh `MaterialApp` (dan semua layar di dalamnya) mungkin akan di-_rebuild_.
    - Ini jelas tidak efisien karena hanya ikon keranjang dan Layar C (Keranjang Belanja) yang perlu diperbarui.

4.  **Testability:**

    - Bayangkan Anda ingin menguji logika penambahan item ke keranjang. Jika logika itu tersebar di berbagai _widget_ UI dan bergantung pada _callback_ yang kompleks, akan sangat sulit untuk mengisolasi dan menguji logika bisnis tersebut tanpa harus merender seluruh UI.

5.  **Maintainability & Scalability:**

    - Menambahkan fitur baru (misalnya, menyimpan keranjang ke penyimpanan lokal, atau sinkronisasi dengan _backend_) akan menjadi mimpi buruk. Anda harus melacak semua tempat di mana data keranjang digunakan dan diperbarui, dan memastikan semua jalur _callback_ masih berfungsi.
    - Tim yang lebih besar akan kesulitan berkolaborasi karena perubahan di satu tempat dapat memiliki dampak yang tidak terduga di tempat lain.

**Kesimpulan Konseptual:**
Masalah-masalah di atas tidak dapat dipecahkan secara efisien hanya dengan `setState()`. `setState()` bekerja dengan baik untuk _state_ lokal yang terisolasi. Namun, untuk _state_ yang dibagi di antara banyak _widget_ atau yang perlu dipertahankan di seluruh aplikasi, diperlukan mekanisme yang lebih canggih untuk menyediakan _state_ tersebut ke _widget_ yang relevan dan untuk memperbarui _widget_ tersebut secara efisien ketika _state_ berubah, tanpa harus "mengebor" properti atau "neraka _callback_". Inilah peran dari solusi _state management_.

---

**Terminologi Esensial & Penjelasan Detail:**

- **Prop Drilling:** Meneruskan data atau _callback_ melalui beberapa tingkatan _widget_ perantara yang tidak relevan, dari _ancestor_ ke _descendant_ yang jauh.
- **Callback Hell:** Pola pemrograman yang rumit dan sulit dibaca di mana banyak _callback_ bersarang atau di-chain untuk menangani urutan operasi asinkron atau komunikasi _child-to-parent_.
- **Data Inconsistency:** Situasi di mana beberapa bagian aplikasi menampilkan data yang berbeda untuk objek yang seharusnya sama, karena tidak ada "sumber kebenaran tunggal" atau karena pembaruan tidak disinkronkan dengan benar.
- **Unnecessary Rebuilds:** Situasi di mana _widget_ atau sub-pohon _widget_ dibangun ulang (di-_render_ ulang) meskipun _state_ yang mereka tampilkan tidak berubah, menyebabkan pemborosan sumber daya dan potensi _lag_.
- **Separation of Concerns:** Prinsip desain perangkat lunak yang menganjurkan pemisahan aplikasi menjadi bagian-bagian yang berbeda, masing-masing dengan tanggung jawab yang unik. Dalam konteks Flutter, ini berarti memisahkan logika bisnis dari UI.

**Sumber Referensi Lengkap:**

- [Flutter state management for dummies](https://www.freecodecamp.org/news/flutter-state-management-for-dummies/) - Bagian yang bagus tentang mengapa _state management_ itu penting.
- [Managing state in Flutter (Official Docs)](https://docs.flutter.dev/data/state-management/options) - Bagian pengantar yang membahas mengapa kita butuh _state management_.
- [Provider package documentation](https://pub.dev/packages/provider) - Meskipun ini adalah solusi, bagian awalnya sering menjelaskan masalah yang dipecahkan oleh _Provider_.

**Tips dan Praktik Terbaik:**

- **Identifikasi Masalah Lebih Awal:** Jika Anda mulai merasa kode navigasi atau pembaruan UI Anda menjadi berantakan karena data yang harus dilewatkan ke mana-mana, itu adalah tanda pasti Anda memerlukan solusi _state management_.
- **Jangan Terburu-buru Memilih Solusi:** Pahami masalahnya terlebih dahulu sebelum melompat ke solusi tertentu. Memahami tantangannya akan membantu Anda memilih alat yang tepat.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menganggap `setState()` cukup untuk semua skenario.

  - **Penyebab:** Tidak memahami batasan `setState()` dalam konteks _app state_.
  - **Solusi:** Pahami perbedaan antara _local state_ dan _app state_ seperti yang dijelaskan di 4.1.1.

- **Kesalahan:** Mengimplementasikan solusi _state management_ yang kompleks untuk _local state_ sederhana.

  - **Penyebab:** _Over-engineering_ atau tidak membedakan jenis _state_.
  - **Solusi:** Selalu mulai dengan `setState()` untuk _state_ lokal. Jika masalah _prop drilling_, inkonsistensi data, atau kinerja muncul, barulah pertimbangkan solusi _state management_ eksternal.

---

#### 4.1.3 InheritedWidget (Basic Concept)

Sub-bagian ini akan memperkenalkan `InheritedWidget`, sebuah _widget_ fundamental di Flutter yang menjadi dasar bagi sebagian besar solusi _state management_ modern. Meskipun jarang digunakan secara langsung untuk _state management_ yang kompleks, memahami prinsip kerjanya sangat penting.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bahwa `InheritedWidget` adalah _widget_ khusus yang memungkinkan _widget_ anak dan _descendant_ (keturunan) di _widget tree_ untuk mengakses data yang disediakan oleh `InheritedWidget` tersebut tanpa perlu meneruskan data secara eksplisit melalui konstruktor (mengatasi _prop drilling_). Ketika data di `InheritedWidget` berubah, ia dapat memberi tahu _descendant_ yang bergantung padanya untuk di-_rebuild_. Ini adalah mekanisme bawaan Flutter untuk _dependency injection_ dan _state propagation_ dari atas ke bawah di _widget tree_.

**Konsep Kunci & Filosofi Mendalam:**

- **Implicit Data Flow (Context Access):** `InheritedWidget` memungkinkan _widget_ untuk "menarik" data dari _ancestor_ mereka menggunakan `BuildContext`. Ini kebalikan dari "mendorong" data ke bawah melalui konstruktor.

  - **Filosofi:** Mengurangi _boilerplate_ dan _coupling_ antar _widget_ dengan menyediakan mekanisme yang lebih bersih untuk akses data global atau _scoped_.

- **Efficient Rebuilding with `didChangeDependencies`:** Flutter secara cerdas mengoptimalkan _rebuild_ ketika `InheritedWidget` berubah. Hanya _descendant_ yang benar-benar memanggil `context.dependOnInheritedWidgetOfExactType<T>()` yang akan dibangun ulang.

  - **Filosofi:** Menggabungkan kemudahan akses data dengan kinerja yang optimal, hanya membangun ulang bagian UI yang benar-benar perlu diperbarui.

- **Foundation for State Management Packages:** Banyak paket _state management_ populer (seperti _Provider_, BLoC/Cubit dengan `BlocProvider`, dll.) menggunakan `InheritedWidget` di bawah kap mesin mereka untuk menyediakan _state_ atau _logic_ ke _widget tree_.

  - **Filosofi:** Memahami `InheritedWidget` memberikan wawasan tentang bagaimana alat-alat ini bekerja, bukan hanya bagaimana menggunakannya. Ini adalah fondasi yang kokoh untuk pemahaman lanjutan.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

// --- 1. Buat InheritedWidget Kustom ---
// Ini akan menyediakan 'data' (misalnya, counter) ke bawah widget tree.
class MyInheritedData extends InheritedWidget {
  final int counter; // Data yang akan diwariskan
  final Widget child; // Widget di bawah InheritedWidget ini

  // Konstruktor wajib InheritedWidget
  const MyInheritedData({
    super.key,
    required this.counter,
    required this.child,
  }) : super(child: child);

  // Metode statis untuk mengakses instance MyInheritedData terdekat dari context.
  // 'listen: true' (default) berarti widget yang memanggil ini akan di-rebuild
  // jika InheritedWidget ini berubah.
  // 'listen: false' berarti hanya akses data tanpa langganan perubahan (jarang digunakan untuk ini).
  static MyInheritedData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedData>();
  }

  // Metode ini dipanggil ketika InheritedWidget ini di-rebuild
  // dan memutuskan apakah descendant yang bergantung padanya perlu di-rebuild juga.
  @override
  bool updateShouldNotify(MyInheritedData oldWidget) {
    // Kembalikan true jika widget-dependent perlu di-rebuild
    // karena 'counter' berubah.
    return counter != oldWidget.counter;
  }
}

// --- 2. Widget yang Mengelola State dan Menempatkan InheritedWidget ---
// Ini adalah StatefulWidget karena ia memegang state 'counter' yang berubah.
class CounterManager extends StatefulWidget {
  final Widget child; // Anak dari CounterManager (misalnya, seluruh aplikasi)

  const CounterManager({super.key, required this.child});

  @override
  State<CounterManager> createState() => _CounterManagerState();
}

class _CounterManagerState extends State<CounterManager> {
  int _appCounter = 0; // App State yang dikelola

  void incrementCounter() {
    setState(() {
      _appCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menempatkan MyInheritedData di atas widget tree
    // sehingga _appCounter dapat diakses oleh descendant.
    return MyInheritedData(
      counter: _appCounter,
      child: widget.child, // Meneruskan anak yang sebenarnya
    );
  }
}

// --- 3. Widget yang Mengkonsumsi Data dari InheritedWidget (Deep in Tree) ---
// Ini bisa menjadi StatelessWidget atau StatefulWidget,
// karena ia tidak mengelola state-nya sendiri, hanya mengkonsumsi.
class CounterDisplayWidget extends StatelessWidget {
  const CounterDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengakses data 'counter' dari MyInheritedData terdekat di atasnya.
    // Ketika MyInheritedData berubah dan updateShouldNotify mengembalikan true,
    // CounterDisplayWidget ini akan otomatis di-rebuild.
    final MyInheritedData? inheritedData = MyInheritedData.of(context);
    final int? currentCounter = inheritedData?.counter;

    // Jika ingin mengakses fungsi, kita bisa mendapatkan referensi ke CounterManagerState
    // (lebih kompleks, tapi ini konsep dasar InheritedWidget saja)
    // Untuk memanggil increment, kita perlu context dari CounterManager.
    // Ini mengapa solusi seperti Provider lebih populer.

    return Column(
      children: [
        const Text(
          'App-Wide Counter (via InheritedWidget):',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          '${currentCounter ?? 'Tidak ada data'}', // Menampilkan counter
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// --- 4. Tombol untuk Memodifikasi Data (Membutuhkan akses ke CounterManager) ---
// Widget ini perlu cara untuk memanggil incrementCounter() dari CounterManager.
// Ini adalah salah satu keterbatasan InheritedWidget sendiri untuk 'aksi'.
// Kita bisa menggunakan 'of' method pada CounterManager jika CounterManager juga InheritedWidget,
// atau meneruskan callback (kembali ke masalah callback hell jika terlalu jauh).
// Ini akan dibahas lebih elegan dengan Provider.
class IncrementButton extends StatelessWidget {
  final VoidCallback onPressed; // Menerima callback dari parent

  const IncrementButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Panggil callback yang diteruskan dari CounterManager
      child: const Icon(Icons.add),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // CounterManager diletakkan di atas MaterialApp/Scaffold
    // sehingga CounterDisplayWidget dan IncrementButton (melalui callback)
    // dapat mengakses/memodifikasi state global.
    return CounterManager(
      child: MaterialApp(
        title: 'InheritedWidget Demo',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: Scaffold(
          appBar: AppBar(title: const Text('InheritedWidget Basic')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CounterDisplayWidget(), // Mengkonsumsi data
                const SizedBox(height: 30),
                // IncrementButton perlu memanggil fungsi dari CounterManager
                // Di sini, kita akan meneruskan fungsi dari CounterManagerState
                // (Ini menunjukkan bahwa InheritedWidget sendiri kurang cocok untuk fungsi,
                // lebih cocok untuk data read-only. Provider mengatasi ini.)
                Builder( // Builder untuk mendapatkan context yang tepat di bawah CounterManager
                  builder: (context) {
                    // Mengakses instance State dari CounterManager
                    // Ini adalah cara yang tidak ideal untuk memanggil fungsi
                    // dan justru diselesaikan oleh Provider.
                    // For demo purposes only:
                    final _CounterManagerState? managerState = context.findAncestorStateOfType<_CounterManagerState>();
                    return IncrementButton(
                      onPressed: () {
                        managerState?.incrementCounter();
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Lihat konsol untuk rebuild log. Hanya CounterDisplayWidget yang rebuilt.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`MyInheritedData` (`InheritedWidget` Kustom):**

    - Ini adalah `InheritedWidget` yang sebenarnya. Ia memiliki satu properti (`counter`) yang akan kita wariskan.
    - Properti `child` adalah _widget_ yang berada di bawah `InheritedWidget` ini di _widget tree_.
    - **`static MyInheritedData? of(BuildContext context)`**: Ini adalah _pattern_ umum untuk mengakses `InheritedWidget`. `context.dependOnInheritedWidgetOfExactType<T>()` adalah metode inti yang memungkinkan _widget_ untuk "mendengarkan" perubahan pada `InheritedWidget` dan di-_rebuild_ jika `updateShouldNotify` mengembalikan `true`.
    - **`updateShouldNotify(MyInheritedData oldWidget)`**: Metode ini sangat penting. Flutter memanggilnya ketika instance baru dari `MyInheritedData` dibuat. Anda harus mengembalikan `true` jika data yang diwariskan telah berubah dan _descendant_ yang bergantung padanya perlu di-_rebuild_. Dalam kasus ini, kita mengembalikan `true` jika `counter` berbeda dari `oldWidget.counter`.

2.  **`CounterManager` (`StatefulWidget` yang Mengelola State dan Menempatkan `InheritedWidget`):**

    - Ini adalah `StatefulWidget` karena ia memegang `_appCounter` yang merupakan _state_ yang dapat berubah.
    - Di dalam `build` metode `_CounterManagerState`, kita membungkus `widget.child` dengan `MyInheritedData`, meneruskan `_appCounter` sebagai data yang diwariskan.
    - Metode `incrementCounter()` di `_CounterManagerState` memanggil `setState()` untuk memperbarui `_appCounter`. Ketika `_appCounter` berubah, `_CounterManagerState` akan di-_rebuild_, yang pada gilirannya akan membuat instance `MyInheritedData` yang baru. Ini akan memicu `updateShouldNotify`.

3.  **`CounterDisplayWidget` (Mengkonsumsi Data):**

    - Ini adalah `StatelessWidget` (bisa juga `StatefulWidget`). Ia tidak memiliki _state_ sendiri.
    - Ia menggunakan `MyInheritedData.of(context)` untuk mengakses `counter` yang disediakan oleh `MyInheritedData` yang berada di atasnya.
    - Karena ia memanggil `dependOnInheritedWidgetOfExactType`, ia akan otomatis di-_rebuild_ setiap kali `MyInheritedData` di atasnya memberi tahu bahwa datanya telah berubah (yaitu, ketika `_appCounter` di `CounterManager` berubah).

4.  **`IncrementButton` (Memicu Perubahan State):**

    - Dalam contoh ini, `IncrementButton` menerima `VoidCallback onPressed` dari _parent_-nya (`MyApp`).
    - `MyApp` menggunakan `Builder` untuk mendapatkan `BuildContext` yang merupakan anak dari `CounterManager`, kemudian menggunakan `findAncestorStateOfType` untuk mengakses _state_ `_CounterManagerState` dan memanggil `incrementCounter()`.
    - **Catatan Penting**: Menggunakan `findAncestorStateOfType` untuk memanggil fungsi dari _state_ `ancestor` secara langsung adalah pola yang tidak disarankan untuk aplikasi besar, karena ini masih merupakan bentuk _coupling_ dan dapat sulit di-_maintain_. Ini diperkenalkan di sini hanya untuk menunjukkan bagaimana _state_ _bisa_ diubah dari bawah. **Solusi _state management_ seperti _Provider_ menyediakan cara yang jauh lebih elegan untuk melakukan ini.**

**Visualisasi Diagram Alur/Struktur:**

- Diagram _Widget Tree_: `CounterManager` (di paling atas) -\> `MyInheritedData` (membungkus) -\> `MaterialApp` -\> `Scaffold` -\> `CounterDisplayWidget` dan `IncrementButton`.
- Panah tebal yang menunjukkan bahwa `CounterDisplayWidget` "melihat ke atas" `widget tree` untuk mendapatkan data dari `MyInheritedData`.
- Lingkaran `_appCounter` di `CounterManager` yang berubah, memicu `MyInheritedData` untuk memperbarui, dan kemudian panah yang hanya mengarah ke `CounterDisplayWidget` untuk _rebuild_ (bukan seluruh _tree_).

**Terminologi Esensial & Penjelasan Detail:**

- **`InheritedWidget`:** Sebuah jenis `Widget` khusus yang dapat menyediakan data ke semua _descendant_ di bawahnya di _widget tree_.
- **`context.dependOnInheritedWidgetOfExactType<T>()`:** Metode `BuildContext` yang digunakan oleh _descendant_ untuk mencari `InheritedWidget` dari tipe `T` yang terdekat di _ancestor tree_ dan berlangganan perubahannya. Jika `InheritedWidget` berubah, _widget_ yang memanggil metode ini akan di-_rebuild_.
- **`updateShouldNotify(covariant InheritedWidget oldWidget)`:** Metode yang harus diimplementasikan oleh `InheritedWidget` untuk menentukan apakah _descendant_ yang bergantung padanya perlu dibangun ulang ketika `InheritedWidget` itu sendiri dibangun ulang dengan data yang berbeda. Mengembalikan `true` memicu _rebuild_ pada _descendant_ yang bergantung.
- **Ancestor/Descendant:** Hubungan antara _widget_ di _widget tree_. `Ancestor` berada di atas, `Descendant` berada di bawah.

**Sumber Referensi Lengkap:**

- [InheritedWidget Class (API Docs)](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html)
- [Flutter Internals: How does InheritedWidget work?](https://medium.com/%40didier.bolfs/flutter-internals-how-does-inheritedwidget-work-a6acb7f7301c)
- [Provider's Ancestor: InheritedWidget](https://medium.com/flutter-community/provider-s-ancestor-inheritedwidget-65121404c062)

**Tips dan Praktik Terbaik:**

- **Pahami Konsep, Jangan Langsung Implementasi Kompleks:** Untuk sebagian besar kasus _state management_ aplikasi, Anda tidak akan membuat `InheritedWidget` kustom dari awal. Sebaliknya, Anda akan menggunakan paket seperti _Provider_ yang sudah mengimplementasikan `InheritedWidget` secara internal untuk Anda. Fokus pada pemahaman cara kerjanya.
- **`of` Method adalah Pola Standar:** Pola `static T? of(BuildContext context)` adalah cara standar dan direkomendasikan untuk mengakses data dari `InheritedWidget`.
- **`updateShouldNotify` Penting untuk Performa:** Implementasikan `updateShouldNotify` dengan benar agar hanya _widget_ yang benar-benar membutuhkan data yang diperbarui yang di-_rebuild_, menghindari _unnecessary rebuilds_.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** "No InheritedWidget of type 'MyInheritedData' found in the context."

  - **Penyebab:** Anda mencoba mengakses `MyInheritedData.of(context)` dari `context` yang _tidak memiliki_ `MyInheritedData` sebagai _ancestor_. Ini berarti `MyInheritedData` belum ditempatkan di atas _widget_ yang mencoba mengaksesnya.
  - **Solusi:** Pastikan `InheritedWidget` (atau _widget_ seperti `ChangeNotifierProvider` dari _Provider_ yang menggunakan `InheritedWidget`) ditempatkan di atas _widget tree_ yang cukup tinggi sehingga semua _descendant_ yang memerlukannya dapat mengaksesnya.

- **Kesalahan:** UI tidak diperbarui meskipun data di `InheritedWidget` telah berubah.

  - **Penyebab:**
    - `updateShouldNotify` di `InheritedWidget` selalu mengembalikan `false`.
    - _Widget_ konsumen tidak memanggil `context.dependOnInheritedWidgetOfExactType<T>()` (atau setara, seperti `Provider.of(context)` tanpa `listen: false`).
    - Data di `InheritedWidget` sebenarnya tidak berubah (misalnya, memperbarui properti dari objek yang sama tanpa membuat objek baru).
  - **Solusi:**
    - Pastikan `updateShouldNotify` memiliki logika yang benar untuk mendeteksi perubahan data.
    - Pastikan _widget_ yang mengkonsumsi data berlangganan perubahan.
    - Jika data adalah objek, pastikan Anda membuat instance objek baru jika Anda ingin `updateShouldNotify` mendeteksinya (atau implementasikan kesetaraan secara manual jika Anda membandingkan isi objek).

---

### 4.2 Provider Package (Simple & Recommended)

Sub-bagian ini akan memperkenalkan paket _Provider_, salah satu solusi _state management_ yang paling populer dan direkomendasikan di komunitas Flutter, terutama untuk pemula hingga proyek menengah. Ini membangun di atas pemahaman `InheritedWidget` yang telah kita bahas.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bahwa _Provider_ adalah sebuah _wrapper_ di atas `InheritedWidget` yang menyederhanakan penggunaan dan pengelolaan _app state_. Ini menyediakan cara yang elegan dan efisien untuk mengekspos _state_ atau objek apa pun ke bawah _widget tree_ dan memungkinkan _widget_ untuk "mendengarkan" perubahan _state_ tersebut dan memperbarui UI secara selektif. _Provider_ adalah titik awal yang sangat baik untuk belajar _state management_ karena kemudahan penggunaannya dan skalabilitasnya untuk banyak kasus penggunaan.

**Konsep Kunci & Filosofi Mendalam:**

- **Simplicity and Composability:** _Provider_ dirancang agar sederhana dan mudah digunakan, memungkinkan pengembang untuk membuat _providers_ kecil yang dapat digabungkan (komposisi) untuk mengelola _state_ yang lebih besar.

  - **Filosofi:** Mengurangi _boilerplate_ dan kompleksitas, memungkinkan pengembang untuk fokus pada logika bisnis.

- **Based on InheritedWidget:** _Provider_ tidak menciptakan konsep baru, melainkan mengoptimalkan dan menyederhanakan penggunaan `InheritedWidget` yang sudah ada di Flutter.

  - **Filosofi:** Mengandalkan fondasi inti Flutter untuk memastikan kinerja dan kompatibilitas yang baik.

- **Type Safety:** _Provider_ memanfaatkan kemampuan _type system_ Dart, mengurangi _bug_ runtime karena kesalahan _type casting_.

  - **Filosofi:** Meningkatkan _robustness_ kode dengan bantuan Dart analyzer.

- **Scoped Access:** _Provider_ memungkinkan Anda untuk menyediakan _state_ dalam "lingkup" tertentu di _widget tree_. Hanya _widget_ di bawah _provider_ yang dapat mengakses _state_ tersebut.

  - **Filosofi:** Mencegah akses yang tidak perlu ke _state_ dan membatasi _rebuild_ hanya pada bagian _widget tree_ yang terpengaruh.

**Visualisasi Diagram Alur/Struktur:**

- Diagram yang menunjukkan `ChangeNotifierProvider` di atas beberapa _widget_ di _widget tree_. Panah dari `ChangeNotifierProvider` menunjuk ke bawah ke _widget_ `Consumer` atau _widget_ lain yang memanggil `Provider.of()`, menunjukkan aliran data.
- Ilustrasi "gelembung" _state_ yang terpusat di `ChangeNotifier` dan `ChangeNotifierProvider`, kemudian dipancarkan ke _widget_ yang tertarik.

**Hubungan dengan Modul Lain:**
_Provider_ akan menjadi solusi utama untuk mengelola _app state_ di seluruh aplikasi dari titik ini. Ini akan digunakan bersama dengan navigasi (untuk memperbarui _state_ dari layar lain) dan juga mempengaruhi bagaimana data diambil dari API (Fase 5) dan bagaimana interaksi pengguna memodifikasi _state_.

---

#### 4.2.1 `Provider`, `ChangeNotifier`, `ChangeNotifierProvider`

Sub-bagian ini akan memperkenalkan tiga komponen inti dari paket _Provider_ yang sering digunakan bersama untuk mengelola _state_ yang dapat berubah.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari bagaimana `ChangeNotifier` digunakan sebagai kelas yang memegang _state_ dan memberitahu "pendengar" ketika _state_ berubah. `ChangeNotifierProvider` adalah _widget_ yang menempatkan instance `ChangeNotifier` ini di _widget tree_ sehingga _descendant_ dapat mengaksesnya. `Provider` itu sendiri adalah _widget_ tingkat rendah yang menyediakan nilai apa pun, tetapi seringkali digunakan secara implisit melalui `ChangeNotifierProvider` untuk _state_ yang dinamis.

**Konsep Kunci & Filosofi Mendalam:**

- **Observable Pattern (`ChangeNotifier`):** `ChangeNotifier` adalah implementasi dari _observable pattern_ (atau _Observer pattern_). Objek yang _observable_ (dalam hal ini, `ChangeNotifier`) memberitahu semua _observers_ (pendengar) ketika terjadi perubahan.

  - **Filosofi:** Memisahkan _state_ yang dapat berubah dari _widget_ yang menampilkannya, memungkinkan _state_ untuk diubah di satu tempat dan secara otomatis diperbarui di banyak tempat yang berbeda.

- **Dependency Injection (via `Provider`):** `ChangeNotifierProvider` (dan _providers_ lainnya) bertindak sebagai _dependency injector_, menyediakan instance `ChangeNotifier` ke _widget tree_ di bawahnya.

  - **Filosofi:** Mengurangi _coupling_ antar komponen dengan menyediakan dependensi (objek `ChangeNotifier`) secara implisit, daripada membuat _widget_ secara langsung membuat atau mencari dependensi tersebut.

**Sintaks Dasar / Contoh Implementasi Inti:**

Pertama, tambahkan _dependency_ `provider` ke `pubspec.yaml` Anda:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5 # Gunakan versi terbaru yang stabil
```

Kemudian jalankan `flutter pub get`.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- 1. Model / State Class (ChangeNotifier) ---
// Ini adalah kelas yang akan memegang state yang ingin Anda bagikan
// dan memberi tahu listener saat state berubah.
class CounterModel extends ChangeNotifier {
  int _counter = 0; // State pribadi

  int get counter => _counter; // Getter untuk mengakses state

  void increment() {
    _counter++;
    // Memanggil notifyListeners() adalah PENTING!
    // Ini memberi tahu semua widget yang mendengarkan (via Provider)
    // bahwa state telah berubah dan mereka mungkin perlu di-rebuild.
    notifyListeners();
    print('Counter incremented to $_counter'); // Untuk debugging
  }

  void decrement() {
    _counter--;
    notifyListeners();
    print('Counter decremented to $_counter'); // Untuk debugging
  }
}

// --- 2. Widget Utama Aplikasi dengan ChangeNotifierProvider ---
// ChangeNotifierProvider diletakkan di atas widget tree
// sehingga CounterModel dapat diakses oleh descendant-nya.
void main() {
  runApp(
    // ChangeNotifierProvider menyediakan instance CounterModel ke bawah tree.
    // create: (context) => CounterModel() adalah cara kita membuat instance baru.
    ChangeNotifierProvider(
      create: (context) => CounterModel(),
      child: const MyApp(), // MyApp dan semua descendant-nya sekarang bisa mengakses CounterModel
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Counter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterScreen(),
    );
  }
}

// --- 3. Consumer Widget (Membaca State & Memicu Aksi) ---
// Widget ini akan membaca state dari CounterModel dan memanggil metode untuk mengubahnya.
class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: Digunakan di dalam build method untuk membaca state
    // dan menyebabkan widget di-rebuild ketika state berubah.
    // Setara dengan Provider.of<CounterModel>(context, listen: true).
    final counterModel = context.watch<CounterModel>();

    // read: Digunakan untuk memanggil metode (aksi) pada model
    // atau untuk membaca state di luar build method (misalnya di onPressed).
    // Ini tidak akan menyebabkan widget di-rebuild.
    // Setara dengan Provider.of<CounterModel>(context, listen: false).
    final counterActions = context.read<CounterModel>();

    print('CounterScreen rebuilt'); // Untuk melihat kapan widget di-rebuild

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Counter'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Nilai Counter:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${counterModel.counter}', // Mengakses state dari model
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'decrementBtn', // Penting jika ada banyak FAB
                  onPressed: counterActions.decrement, // Memanggil aksi
                  tooltip: 'Decrement',
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'incrementBtn', // Penting jika ada banyak FAB
                  onPressed: counterActions.increment, // Memanggil aksi
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Hanya widget yang mendengarkan perubahan CounterModel yang akan rebuilt.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`CounterModel` (`ChangeNotifier`):**

    - Ini adalah kelas Dart biasa yang _extends_ `ChangeNotifier`.
    - Ia memegang _state_ (`_counter`) sebagai properti privat.
    - Ia memiliki _getter_ publik (`counter`) untuk membaca _state_.
    - Metode `increment()` dan `decrement()` mengubah `_counter`. **Yang paling penting adalah panggilan `notifyListeners()` setelah _state_ berubah.** Ini memberi tahu semua _widget_ yang sedang "mendengarkan" perubahan pada `CounterModel` bahwa mereka mungkin perlu di-_rebuild_.

2.  **`main()` function (`ChangeNotifierProvider`):**

    - Di sinilah kita "menyediakan" `CounterModel` ke _widget tree_.
    - `ChangeNotifierProvider<CounterModel>` adalah _widget_ yang mengambil `CounterModel` dan membuatnya tersedia untuk semua _descendant_ di bawahnya.
    - `create: (context) => CounterModel()` adalah _callback_ yang dipanggil sekali untuk membuat instance `CounterModel` yang akan digunakan oleh _provider_. Ini memastikan bahwa instance `CounterModel` hanya dibuat ketika dibutuhkan dan dapat di-_dispose_ secara otomatis ketika tidak lagi digunakan.

3.  **`CounterScreen` (Mengonsumsi `Provider`):**

    - `CounterScreen` adalah `StatelessWidget`. Ia tidak memiliki _state_ lokal yang perlu dikelola dengan `setState()`. Ia bergantung sepenuhnya pada _state_ yang disediakan oleh `CounterModel` melalui _Provider_.
    - **`context.watch<CounterModel>()`**: Ini adalah ekstensi praktis dari `BuildContext` (dari paket _Provider_) yang setara dengan `Provider.of<CounterModel>(context, listen: true)`. Ini membaca instance `CounterModel` dari _widget tree_ dan membuat `CounterScreen` ini "mendengarkan" perubahan. Artinya, setiap kali `notifyListeners()` dipanggil di `CounterModel`, `CounterScreen` akan di-_rebuild_. Gunakan ini di dalam `build` method ketika Anda ingin UI memperbarui secara otomatis.
    - **`context.read<CounterModel>()`**: Ini juga ekstensi dari `BuildContext` yang setara dengan `Provider.of<CounterModel>(context, listen: false)`. Ini membaca instance `CounterModel` dari _widget tree_ tetapi **tidak** membuat `CounterScreen` ini mendengarkan perubahan. Ini sangat berguna untuk memanggil metode (aksi) pada model (misalnya, `increment()`, `decrement()`) di dalam _callback_ seperti `onPressed`, di mana Anda tidak ingin _widget_ di-_rebuild_ hanya karena aksi dipicu.
    - _Print_ _statement_ di `build` menunjukkan bahwa `CounterScreen` hanya di-_rebuild_ ketika `_counter` di `CounterModel` berubah, bukan pada setiap _rebuild_ dari _parent_ yang tidak terkait.

**Visualisasi Diagram Alur/Struktur:**

- Diagram yang menunjukkan `ChangeNotifierProvider` di atas `MyApp` di _widget tree_.
- Panah dari `ChangeNotifierProvider` ke bawah, menunjukkan `CounterModel` tersedia.
- Di dalam `CounterScreen`, panah dari `context.watch<CounterModel>()` menuju ke `ChangeNotifierProvider` untuk mengambil data dan mengatur _listener_.
- Panah dari `onPressed` tombol ke `context.read<CounterModel>()` lalu ke `CounterModel.increment()`/`decrement()`, menunjukkan pemanggilan aksi.
- Panah dari `CounterModel.notifyListeners()` kembali ke `CounterScreen` (melalui `context.watch`), memicu _rebuild_.

**Terminologi Esensial & Penjelasan Detail:**

- **`provider` (Package):** Sebuah paket _state management_ populer di Flutter yang menyederhanakan `InheritedWidget`.
- **`ChangeNotifier`:** Sebuah kelas dari Flutter SDK (`foundation.dart`) yang dapat _extend_ oleh kelas _model_ Anda. Ia memiliki metode `notifyListeners()` yang memberi tahu semua objek yang terdaftar sebagai pendengar (biasanya `Provider` di _widget tree_) bahwa _state_ telah berubah.
- **`ChangeNotifierProvider`:** Sebuah _widget_ dari paket `provider` yang menyediakan instance `ChangeNotifier` ke _widget tree_ di bawahnya. Ini adalah _provider_ yang paling umum digunakan untuk _state_ yang dapat berubah.
- **`Provider.of<T>(BuildContext context, {listen: true/false})`:** Metode inti untuk mengakses _provider_.
  - `listen: true` (default): _Widget_ yang memanggilnya akan di-_rebuild_ ketika _state_ berubah. Digunakan di `build` method.
  - `listen: false`: _Widget_ hanya mengakses data/metode dan _tidak_ akan di-_rebuild_ ketika _state_ berubah. Digunakan di _callback_ seperti `onPressed`.
- **`context.watch<T>()`:** Ekstensi `BuildContext` yang praktis, setara dengan `Provider.of<T>(context, listen: true)`.
- **`context.read<T>()`:** Ekstensi `BuildContext` yang praktis, setara dengan `Provider.of<T>(context, listen: false)`.
- **`notifyListeners()`:** Metode yang harus dipanggil di dalam kelas `ChangeNotifier` setelah _state_ berubah untuk memberi tahu semua pendengar.

**Sumber Referensi Lengkap:**

- [Provider package (pub.dev)](https://pub.dev/packages/provider) - Dokumentasi resmi paket `provider`. Sangat direkomendasikan.
- [Simple app state management (Official Flutter Docs)](https://docs.flutter.dev/data/state-management/options/provider) - Panduan resmi Flutter tentang _Provider_.
- [ChangeNotifier Class (API Docs)](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html)

**Tips dan Praktik Terbaik:**

- **Pemisahan Tanggung Jawab:** Jaga agar kelas `ChangeNotifier` Anda bersih, hanya berisi logika bisnis dan _state_ terkait. Hindari logika UI atau _widget_ di dalamnya.
- **`notifyListeners()` di Akhir:** Panggil `notifyListeners()` setelah semua perubahan _state_ yang relevan telah selesai dalam suatu metode, untuk menghindari _rebuild_ yang tidak perlu di tengah perubahan.
- **`watch` vs `read`:** Pahami perbedaan dan gunakan dengan bijak. `watch` di `build` untuk perubahan UI, `read` di _callback_ untuk memicu aksi.
- **Scoped Providers:** Tempatkan `ChangeNotifierProvider` serendah mungkin di _widget tree_ tempat _state_ benar-benar dibutuhkan untuk membatasi ruang lingkup _rebuild_. Namun, untuk _state_ global (seperti tema, otentikasi), tempatkan di atas `MaterialApp`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** UI tidak diperbarui meskipun `ChangeNotifier` telah diubah.

  - **Penyebab:** Lupa memanggil `notifyListeners()` di kelas `ChangeNotifier` setelah mengubah _state_, atau _widget_ konsumen tidak "mendengarkan" (menggunakan `read` di `build` atau tidak menggunakan `Provider.of` sama sekali).
  - **Solusi:** Pastikan `notifyListeners()` dipanggil di semua metode yang mengubah _state_. Pastikan _widget_ konsumen menggunakan `context.watch<T>()` atau `Provider.of<T>(context, listen: true)`.

- **Kesalahan:** "No provider found for type 'X'\!"

  - **Penyebab:** Anda mencoba mengakses _provider_ (misalnya, `context.watch<CounterModel>()`) tetapi `ChangeNotifierProvider` untuk `CounterModel` tidak ditempatkan di atas _widget_ Anda di _widget tree_.
  - **Solusi:** Pastikan `ChangeNotifierProvider` (atau `Provider` lainnya) ditempatkan di atas _widget_ yang mencoba mengaksesnya. Seringkali, _provider_ global ditempatkan di atas `MaterialApp` di `main.dart`.

- **Kesalahan:** Terjadi _infinite loop_ `rebuild`.

  - **Penyebab:** Terjadi `notifyListeners()` yang memicu `rebuild`, yang pada gilirannya memicu `notifyListeners()` lagi. Ini bisa terjadi jika Anda memanggil metode yang mengubah _state_ secara langsung di dalam `build` method (tanpa `listen: false` atau `Consumer` yang tepat).
  - **Solusi:** Jangan panggil metode yang memodifikasi _state_ secara langsung di dalam `build` method. Gunakan _callback_ seperti `onPressed` atau `init` (untuk `StatefulWidget`) atau gunakan `read` jika Anda perlu mengakses _provider_ di luar `build` dan tidak ingin _rebuild_.

---

#### 4.2.2 `Consumer` and `Selector`

Sub-bagian ini akan memperkenalkan dua _widget_ penting dari paket _Provider_ (`Consumer` dan `Selector`) yang dirancang untuk mengoptimalkan _rebuild_ UI dan membuat kode lebih bersih, terutama ketika hanya sebagian kecil dari _widget tree_ yang perlu bereaksi terhadap perubahan _state_.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar bahwa `Consumer` adalah _widget_ yang digunakan untuk mendengarkan perubahan pada `ChangeNotifier` dan membangun ulang _widget_ anakannya secara selektif. Ini adalah alternatif untuk `context.watch()` yang lebih spesifik dalam lingkup _rebuild_. `Selector` adalah varian yang lebih canggih dari `Consumer` yang memungkinkan Anda untuk "memilih" hanya bagian tertentu dari _state_ dari `ChangeNotifier` Anda, dan hanya akan memicu _rebuild_ jika bagian _state_ yang _dipilih_ tersebut berubah. Ini adalah alat yang sangat kuat untuk mengoptimalkan kinerja aplikasi dengan menghindari _rebuild_ yang tidak perlu.

**Konsep Kunci & Filosofi Mendalam:**

- **Scoped Rebuilding (`Consumer`):** Berbeda dengan `context.watch()` yang dapat me-_rebuild_ seluruh _build_ method dari _widget_ yang memanggilnya, `Consumer` hanya akan me-_rebuild_ bagian dari _widget tree_ yang berada di dalam _builder_ function-nya.

  - **Filosofi:** Mengurangi ukuran area yang perlu dibangun ulang, sehingga meningkatkan efisiensi _rendering_ dan kinerja aplikasi. "Only rebuild what you need."

- **Fine-grained Control (`Selector`):** `Selector` memungkinkan Anda untuk menentukan secara eksplisit bagian mana dari _state_ yang ingin Anda pantau. Ini sangat penting ketika _ChangeNotifier_ Anda memegang _state_ yang kompleks dengan banyak properti.

  - **Filosofi:** Mencegah _rebuild_ yang tidak perlu. Jika sebuah _widget_ hanya peduli dengan properti `namaPengguna` dari objek `UserProfile`, ia tidak perlu di-_rebuild_ ketika properti `alamat` berubah.

- **Equality Check:** `Selector` menggunakan fungsi perbandingan (`shouldRebuild` atau `equals` jika disediakan) untuk menentukan apakah _widget_ perlu di-_rebuild_. Secara _default_, ia menggunakan operator `==` pada nilai yang _dipilih_.

  - **Filosofi:** Memberikan kontrol presisi atas kapan _rebuild_ terjadi, mengoptimalkan kinerja dengan meminimalkan pekerjaan yang tidak perlu.

**Sintaks Dasar / Contoh Implementasi Inti:**

Mari kita lanjutkan dari contoh `CounterModel` sebelumnya dan tambahkan fitur _user profile_ untuk menunjukkan penggunaan `Consumer` dan `Selector`.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- 1. Model / State Class (ChangeNotifier) ---
class CounterModel extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  void decrement() {
    _counter--;
    notifyListeners();
  }
}

// Model baru untuk profil pengguna
class UserProfileModel extends ChangeNotifier {
  String _userName = 'Guest';
  int _loginCount = 0;
  bool _isPremium = false;

  String get userName => _userName;
  int get loginCount => _loginCount;
  bool get isPremium => _isPremium;

  void login(String name) {
    _userName = name;
    _loginCount++;
    notifyListeners();
  }

  void togglePremiumStatus() {
    _isPremium = !_isPremium;
    notifyListeners();
  }
}

// --- 2. Widget Utama Aplikasi dengan MultiProvider ---
// Karena kita punya lebih dari satu model, kita akan gunakan MultiProvider.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterModel()),
        ChangeNotifierProvider(create: (_) => UserProfileModel()),
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
      title: 'Provider Consumer/Selector Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomeScreen(),
    );
  }
}

// --- 3. Home Screen ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Consumer & Selector'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // --- Menggunakan Consumer untuk CounterModel ---
            // Consumer<T> hanya akan me-rebuild widget anaknya (di dalam builder)
            // ketika ChangeNotifier<T> yang di-listen memanggil notifyListeners().
            // Ini lebih spesifik daripada context.watch().
            Consumer<CounterModel>(
              builder: (context, counterModel, child) {
                print('Consumer<CounterModel> rebuilt'); // Lihat kapan ini di-rebuild
                return Column(
                  children: [
                    const Text(
                      'Counter (from Consumer):',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${counterModel.counter}',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: counterModel.decrement, // Aksi langsung dari model
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: counterModel.increment, // Aksi langsung dari model
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 50),

            // --- Menggunakan Selector untuk UserProfileModel ---
            // Selector<T, R> hanya me-rebuild jika bagian 'R' dari state 'T' berubah.
            // Di sini, kita hanya peduli pada 'userName'.
            Selector<UserProfileModel, String>(
              selector: (context, userProfileModel) => userProfileModel.userName,
              // shouldRebuild: (previous, next) => previous != next, // Opsional: defaultnya sudah memeriksa kesamaan
              builder: (context, userName, child) {
                print('Selector<UserProfileModel, String> (userName) rebuilt'); // Lihat kapan ini di-rebuild
                return Text(
                  'Halo, $userName!', // Hanya menampilkan userName
                  style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                );
              },
            ),
            const SizedBox(height: 20),
            // Selector lain untuk 'isPremium'
            Selector<UserProfileModel, bool>(
              selector: (context, userProfileModel) => userProfileModel.isPremium,
              builder: (context, isPremium, child) {
                print('Selector<UserProfileModel, bool> (isPremium) rebuilt'); // Lihat kapan ini di-rebuild
                return Text(
                  isPremium ? 'Anda adalah Pengguna Premium!' : 'Anda adalah Pengguna Standar.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPremium ? Colors.amber[800] : Colors.grey[700],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Tombol untuk memicu perubahan pada UserProfileModel
            ElevatedButton(
              onPressed: () {
                // Memanggil read karena kita hanya ingin memicu aksi, tidak perlu rebuild widget ini.
                final userProfileModel = context.read<UserProfileModel>();
                if (userProfileModel.userName == 'Guest') {
                  userProfileModel.login('Alice');
                } else {
                  userProfileModel.login('Guest'); // Kembali ke Guest
                }
              },
              child: const Text('Toggle User / Login'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<UserProfileModel>().togglePremiumStatus();
              },
              child: const Text('Toggle Premium Status'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`CounterModel` & `UserProfileModel` (`ChangeNotifier`):**

    - Kita memiliki dua model `ChangeNotifier` terpisah untuk mengelola _state_ yang berbeda: `CounterModel` untuk hitungan, dan `UserProfileModel` untuk data pengguna. Masing-masing memiliki properti dan metode yang relevan, dan memanggil `notifyListeners()` saat _state_ berubah.

2.  **`MultiProvider` di `main()`:**

    - Karena kita sekarang memiliki lebih dari satu `ChangeNotifier`, kita menggunakan `MultiProvider` untuk menyediakan semuanya di satu tempat di atas _widget tree_. Ini lebih rapi daripada menumpuk banyak `ChangeNotifierProvider`.

3.  **`HomeScreen`:**

    - **`Consumer<CounterModel>`:**
      - `Consumer` adalah _widget_ yang menerima _builder_ function. _Builder_ function ini menerima tiga argumen: `context`, instance dari _provider_ yang di-_listen_ (`counterModel` dalam kasus ini), dan `child` (opsional, untuk _widget_ yang tidak perlu di-_rebuild_).
      - Seluruh `Column` yang berisi teks counter dan tombol `+`/`-` akan di-_rebuild_ hanya ketika `CounterModel` memanggil `notifyListeners()`. Perhatikan `print('Consumer<CounterModel> rebuilt');` di konsol. Ini menunjukkan lingkup _rebuild_ yang spesifik.
      - Anda dapat langsung memanggil metode seperti `counterModel.increment` karena `counterModel` adalah instance dari `CounterModel` yang sudah di-_watch_ oleh `Consumer`.
    - **`Selector<UserProfileModel, String>` (untuk `userName`):**
      - `Selector` membutuhkan dua _generic type_: `T` (tipe _provider_, `UserProfileModel`) dan `R` (tipe nilai yang _dipilih_, `String` untuk `userName`).
      - **`selector: (context, userProfileModel) => userProfileModel.userName`**: Ini adalah fungsi yang "memilih" bagian _state_ dari _provider_ Anda. `Selector` akan memanggil fungsi ini setiap kali `UserProfileModel` memanggil `notifyListeners()`.
      - **`builder: (context, userName, child)`**: Fungsi ini hanya akan dipanggil (dan bagian UI ini di-_rebuild_) jika nilai `userName` yang _dipilih_ berbeda dari nilai sebelumnya. Jika properti lain di `UserProfileModel` berubah (misalnya, `loginCount` atau `isPremium`), _selector_ ini tidak akan di-_rebuild_. Ini adalah optimasi performa yang sangat penting.
    - **`Selector<UserProfileModel, bool>` (untuk `isPremium`):**
      - Contoh lain dari `Selector` yang hanya mendengarkan perubahan pada properti `isPremium`. Jika `userName` atau `loginCount` berubah, _selector_ ini tidak akan di-_rebuild_ karena `isPremium` tidak berubah.

**Visualisasi Diagram Alur/Struktur:**

- Diagram `Widget Tree` dengan `MultiProvider` di atas.
- Panah dari `MultiProvider` ke `CounterModel` dan `UserProfileModel`.
- Di dalam `HomeScreen`, area kecil yang dibatasi oleh `Consumer<CounterModel>`, dengan panah `notifyListeners` hanya memicu _rebuild_ di dalam area tersebut.
- Area kecil lain yang dibatasi oleh `Selector<UserProfileModel, String>` dan `Selector<UserProfileModel, bool>`, dengan panah `notifyListeners` hanya memicu _rebuild_ jika properti spesifik yang _dipilih_ berubah. Ini akan menunjukkan bahwa _rebuild_ menjadi lebih "lokal" dan efisien.

**Terminologi Esensial & Penjelasan Detail:**

- **`Consumer<T>`:** Sebuah _widget_ dari paket _Provider_ yang memungkinkan Anda untuk mendengarkan perubahan pada `ChangeNotifier` dari tipe `T` dan membangun ulang _widget_ anakannya secara selektif.
- **`Selector<T, R>`:** Sebuah _widget_ dari paket _Provider_ yang memungkinkan Anda untuk mendengarkan perubahan pada `ChangeNotifier` dari tipe `T`, tetapi hanya membangun ulang _widget_ anaknya jika nilai `R` yang _dipilih_ dari `ChangeNotifier` tersebut berubah.
- **`selector` (Properti `Selector`):** Sebuah fungsi yang mengambil instance _provider_ dan mengembalikan bagian _state_ yang ingin Anda pantau.
- **`shouldRebuild` (Properti `Selector` opsional):** Sebuah fungsi opsional yang memungkinkan Anda untuk menentukan logika perbandingan kustom untuk menentukan apakah _widget_ perlu di-_rebuild_. Defaultnya adalah `(previous, next) => previous != next`.
- **`MultiProvider`:** Sebuah _widget_ dari paket _Provider_ yang memungkinkan Anda untuk menyediakan beberapa _provider_ sekaligus di satu lokasi, lebih rapi daripada menumpuknya.

**Sumber Referensi Lengkap:**

- [Consumer widget (Provider Documentation)](https://www.google.com/search?q=https://pub.dev/packages/provider%23consumer)
- [Selector widget (Provider Documentation)](https://www.google.com/search?q=https://pub.dev/packages/provider%23selector)
- [MultiProvider widget (Provider Documentation)](https://www.google.com/search?q=https://pub.dev/packages/provider%23multiprovider)
- [Performance considerations (Provider Documentation)](https://www.google.com/search?q=https://pub.dev/packages/provider%23performance-considerations) - Bagian ini menjelaskan secara detail mengapa `Consumer` dan `Selector` penting.

**Tips dan Praktik Terbaik:**

- **Gunakan `Consumer` atau `Selector` untuk Optimalisasi Rebuild:** Di mana pun memungkinkan, gunakan `Consumer` atau `Selector` di bagian terkecil dari _widget tree_ yang benar-benar perlu bereaksi terhadap perubahan _state_. Hindari menggunakan `context.watch()` di `build` method dari _widget_ yang besar jika hanya sebagian kecil dari UI yang berubah.
- **Pilih `Selector` untuk Spesifisitas:** Jika `ChangeNotifier` Anda memiliki banyak properti dan _widget_ Anda hanya peduli dengan satu atau dua di antaranya, `Selector` adalah pilihan terbaik untuk mencegah _rebuild_ yang tidak perlu.
- **Hindari Logic di Builder:** Jaga agar _builder_ function dari `Consumer` dan `Selector` sesederhana mungkin, fokus pada pembangunan UI. Pindahkan logika kompleks ke dalam `ChangeNotifier` atau metode terpisah.
- **`child` Argument di `Consumer`/`Selector`:** Gunakan argumen `child` jika Anda memiliki bagian dari _widget tree_ di dalam `Consumer`/`Selector` yang tidak bergantung pada _state_ yang sedang di-_listen_. Ini akan mencegah bagian tersebut dari _rebuild_ yang tidak perlu.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `Selector` tidak me-_rebuild_ meskipun data yang dipilih berubah.

  - **Penyebab:**
    - `notifyListeners()` tidak dipanggil di `ChangeNotifier`.
    - Nilai yang dikembalikan oleh fungsi `selector` adalah objek yang sama secara referensi (bukan nilai baru), padahal isinya telah berubah (misalnya, memodifikasi properti di dalam `List` atau `Map` tanpa membuat `List` atau `Map` baru). `Selector` secara default membandingkan objek dengan `==`.
  - **Solusi:**
    - Pastikan `notifyListeners()` dipanggil.
    - Jika nilai yang dipilih adalah koleksi (List, Map) atau objek kustom, pastikan Anda membuat instance baru dari koleksi/objek tersebut ketika kontennya berubah, agar operator `==` dapat mendeteksi perubahan. Atau, berikan `shouldRebuild` kustom untuk melakukan perbandingan mendalam.

- **Kesalahan:** Menggunakan `context.read()` di dalam `builder` function dari `Consumer`/`Selector` untuk membaca state yang seharusnya di-_watch_.

  - **Penyebab:** `context.read()` tidak akan membuat _widget_ di-_rebuild_ saat _state_ berubah.
  - **Solusi:** Gunakan `context.watch()` atau argumen _provider_ yang diteruskan ke _builder_ (`counterModel` di contoh `Consumer`, `userName` di contoh `Selector`) untuk membaca _state_ yang akan menyebabkan _rebuild_. `context.read()` hanya untuk memicu aksi.

---

#### 4.2.3 MultiProvider

Sub-bagian ini akan menjelaskan mengapa dan bagaimana menggunakan `MultiProvider` untuk menyediakan beberapa instance _provider_ ke dalam _widget tree_ secara bersih dan terorganisir.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bahwa dalam aplikasi yang lebih kompleks, seringkali ada kebutuhan untuk menyediakan lebih dari satu jenis _state_ (misalnya, `CounterModel` dan `UserProfileModel` dari contoh sebelumnya) ke _widget tree_. Jika kita menyediakan _provider_ satu per satu secara berurutan, kode akan terlihat sangat bersarang (nesting) dan sulit dibaca. `MultiProvider` adalah _widget_ dari paket _Provider_ yang dirancang untuk mengatasi masalah ini dengan memungkinkan Anda mendaftarkan daftar _provider_ secara horizontal, menjaga keterbacaan kode.

**Konsep Kunci & Filosofi Mendalam:**

- **Code Readability and Maintainability:** Tujuan utama `MultiProvider` adalah membuat _widget tree_ lebih rapi dan mudah dibaca ketika ada banyak _provider_.

  - **Filosofi:** Mengikuti prinsip "Clean Code" dan meningkatkan pengalaman pengembang (DX) dengan mengurangi _nesting_ yang berlebihan.

- **Dependency Order:** Meskipun `MultiProvider` tampak menyediakan _provider_ secara paralel, _provider_ di dalam daftar `providers` sebenarnya diproses secara berurutan. Ini penting jika satu _provider_ bergantung pada _provider_ lain (misalnya, `AuthService` yang memerlukan `HttpClient`). _Provider_ yang dibutuhkan harus didefinisikan _sebelum_ _provider_ yang membutuhkannya.

  - **Filosofi:** Memberikan fleksibilitas dalam mengatur dependensi antar _state_ atau layanan.

- **Scoped Availability:** Sama seperti _provider_ tunggal, _provider_ yang disediakan oleh `MultiProvider` hanya tersedia untuk _widget tree_ di bawah `MultiProvider` tersebut.

  - **Filosofi:** Menjaga _scope_ _state_ tetap terdefinisi dengan jelas, sehingga tidak semua _state_ tersedia di setiap bagian aplikasi jika tidak diperlukan.

**Visualisasi Diagram Alur/Struktur:**

- Diagram yang membandingkan:
  - **Nesting (`ChangeNotifierProvider` bersarang):** Menunjukkan banyak `ChangeNotifierProvider` yang bersarang satu sama lain, membentuk segitiga ke dalam.
  - **`MultiProvider`:** Menunjukkan `MultiProvider` di satu tingkat, dengan panah-panah yang menunjuk ke berbagai _provider_ (misalnya, `CounterModel`, `UserProfileModel`) yang disediakan ke _widget tree_ di bawahnya. Ini menunjukkan struktur yang lebih datar dan rapi.

**Hubungan dengan Modul Lain:**
`MultiProvider` adalah alat organisasional untuk _Provider_ secara keseluruhan. Ini akan menjadi bagian integral dari pengaturan aplikasi Flutter yang menggunakan _Provider_ sebagai solusi _state management_, terutama ketika aplikasi tumbuh dan memiliki berbagai jenis _state_ yang berbeda. Ini akan sering ditempatkan di tingkat atas aplikasi, seperti di atas `MaterialApp`.

---

**Sintaks Dasar / Contoh Implementasi Inti:**

Kita akan menggunakan kembali contoh `CounterModel` dan `UserProfileModel` dari sub-bagian sebelumnya untuk mendemonstrasikan `MultiProvider`.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- Models (ChangeNotifier) ---
// Model 1: CounterModel
class CounterModel extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  void decrement() {
    _counter--;
    notifyListeners();
  }
}

// Model 2: UserProfileModel
class UserProfileModel extends ChangeNotifier {
  String _userName = 'Guest';
  int _loginCount = 0;
  bool _isPremium = false;

  String get userName => _userName;
  int get loginCount => _loginCount;
  bool get isPremium => _isPremium;

  void login(String name) {
    _userName = name;
    _loginCount++;
    notifyListeners();
  }

  void togglePremiumStatus() {
    _isPremium = !_isPremium;
    notifyListeners();
  }
}

// --- Main Application with MultiProvider ---
void main() {
  runApp(
    // MultiProvider digunakan untuk menyediakan beberapa provider sekaligus.
    MultiProvider(
      providers: [
        // Daftar semua provider yang ingin Anda sediakan.
        // Urutan penting jika ada dependensi antar provider.
        ChangeNotifierProvider(create: (_) => CounterModel()),
        ChangeNotifierProvider(create: (_) => UserProfileModel()),
        // Contoh provider yang bergantung pada yang lain (misalnya, AuthService bergantung pada HttpClient)
        // Provider<HttpClient>(create: (_) => HttpClient()),
        // ChangeNotifierProvider<AuthService>(
        //   create: (context) => AuthService(context.read<HttpClient>()),
        // ),
      ],
      child: const MyApp(), // Anak dari MultiProvider, yang bisa mengakses semua provider di atas.
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiProvider Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomeScreen(),
    );
  }
}

// --- HomeScreen - Mengkonsumsi kedua model ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiProvider Example'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Mengkonsumsi CounterModel menggunakan Consumer
            Consumer<CounterModel>(
              builder: (context, counterModel, child) {
                print('Consumer<CounterModel> rebuilt');
                return Column(
                  children: [
                    const Text(
                      'Counter:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '${counterModel.counter}',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: counterModel.decrement,
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: counterModel.increment,
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 50),

            // Mengkonsumsi UserProfileModel menggunakan Selector untuk userName
            Selector<UserProfileModel, String>(
              selector: (context, userProfileModel) => userProfileModel.userName,
              builder: (context, userName, child) {
                print('Selector<UserProfileModel, String> rebuilt');
                return Text(
                  'Halo, $userName!',
                  style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                );
              },
            ),
            const SizedBox(height: 20),
            // Mengkonsumsi UserProfileModel menggunakan Selector untuk isPremium
            Selector<UserProfileModel, bool>(
              selector: (context, userProfileModel) => userProfileModel.isPremium,
              builder: (context, isPremium, child) {
                print('Selector<UserProfileModel, bool> (isPremium) rebuilt');
                return Text(
                  isPremium ? 'Anda adalah Pengguna Premium!' : 'Anda adalah Pengguna Standar.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPremium ? Colors.amber[800] : Colors.grey[700],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Tombol untuk memicu perubahan pada UserProfileModel
            ElevatedButton(
              onPressed: () {
                final userProfileModel = context.read<UserProfileModel>();
                if (userProfileModel.userName == 'Guest') {
                  userProfileModel.login('Alice');
                } else {
                  userProfileModel.login('Guest');
                }
              },
              child: const Text('Toggle User / Login'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<UserProfileModel>().togglePremiumStatus();
              },
              child: const Text('Toggle Premium Status'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

- **`MultiProvider` Structure:**
  - `MultiProvider` adalah _widget_ yang menerima properti `providers`, yang merupakan `List<SingleChildWidget>`. `ChangeNotifierProvider` (dan banyak _provider_ lainnya dari paket _Provider_) adalah `SingleChildWidget`, jadi mereka dapat ditempatkan dalam daftar ini.
  - Setiap _provider_ dalam daftar `providers` akan tersedia untuk `child` dari `MultiProvider` dan semua *descendant*nya.
- **Benefits:**
  - **Keterbacaan:** Bandingkan dengan menumpuk `ChangeNotifierProvider` satu per satu:
    ```dart
    ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: ChangeNotifierProvider(
        create: (_) => UserProfileModel(),
        child: const MyApp(),
      ),
    );
    ```
    `MultiProvider` menghindari _nesting_ yang mendalam ini, membuat struktur _widget tree_ di `main()` jauh lebih datar dan mudah dibaca, terutama saat jumlah _provider_ bertambah.
  - **Manajemen Dependensi (Urutan):** Anda bisa melihat baris yang dikomentari di `providers` list:
    ```dart
    // Provider<HttpClient>(create: (_) => HttpClient()),
    // ChangeNotifierProvider<AuthService>(
    //   create: (context) => AuthService(context.read<HttpClient>()),
    // ),
    ```
    Ini mengilustrasikan bagaimana Anda dapat menyediakan `HttpClient` terlebih dahulu, dan kemudian `AuthService` dapat mengakses `HttpClient` tersebut menggunakan `context.read<HttpClient>()` di dalam _builder_ `create`-nya. Ini menunjukkan bahwa urutan _provider_ dalam daftar `providers` itu penting jika ada dependensi antar _provider_.
- **Consumption:** Konsumsi _provider_ di _widget_ anak (seperti `HomeScreen`) tidak berubah. Anda tetap menggunakan `context.watch<T>()`, `context.read<T>()`, `Consumer<T>`, atau `Selector<T, R>` seperti biasa, seolah-olah mereka disediakan oleh `ChangeNotifierProvider` tunggal.

**Visualisasi Diagram Alur/Struktur:**

- Ilustrasi perbandingan `nesting` _provider_ vs `MultiProvider`.
  - **Nesting:** Gambar `MyApp` dibungkus oleh `Provider B`, yang dibungkus oleh `Provider A`. Terlihat seperti piramida terbalik.
  - **MultiProvider:** Gambar `MyApp` dibungkus oleh `MultiProvider`, yang memiliki garis-garis yang menunjuk ke `Provider A` dan `Provider B` di sampingnya, semua di tingkat yang sama. Ini lebih datar.
- Diagram yang menunjukkan `MultiProvider` di _root_ aplikasi, dengan panah yang menyebar ke berbagai `ChangeNotifierModel` (`CounterModel`, `UserProfileModel`, dll.) yang kemudian tersedia di seluruh _widget tree_ di bawahnya.

**Terminologi Esensial & Penjelasan Detail:**

- **`MultiProvider`:** Sebuah _widget_ dari paket `provider` yang memungkinkan Anda untuk mendaftarkan dan menyediakan beberapa _provider_ ke _widget tree_ secara efisien, menghindari _nesting_ yang berlebihan.
- **`providers` (Properti `MultiProvider`):** Sebuah `List<SingleChildWidget>` yang berisi semua _provider_ (seperti `ChangeNotifierProvider`, `Provider`, `StreamProvider`, dll.) yang ingin Anda sediakan.
- **`SingleChildWidget`:** Kelas dasar untuk _widget_ yang hanya memiliki satu anak, dan banyak _provider_ (termasuk `ChangeNotifierProvider`) mengimplementasikannya.

**Sumber Referensi Lengkap:**

- [MultiProvider widget (Provider Documentation)](https://www.google.com/search?q=https://pub.dev/packages/provider%23multiprovider)
- [Provider Types (Provider Documentation)](https://www.google.com/search?q=https://pub.dev/packages/provider%23provider-types) - Berguna untuk memahami berbagai jenis _provider_ yang dapat digunakan dalam `MultiProvider`.

**Tips dan Praktik Terbaik:**

- **Tempatkan di Tingkat yang Tepat:** Untuk _state_ global (seperti tema, otentikasi, keranjang belanja), tempatkan `MultiProvider` di atas `MaterialApp` Anda (biasanya di fungsi `main`). Untuk _state_ yang hanya relevan untuk bagian aplikasi tertentu, tempatkan `MultiProvider` serendah mungkin di _widget tree_.
- **Urutan Penting untuk Dependensi:** Selalu ingat bahwa urutan _provider_ dalam daftar `providers` penting jika ada _provider_ yang bergantung pada yang lain. _Provider_ yang diperlukan harus muncul terlebih dahulu.
- **Jangan Berlebihan:** Meskipun `MultiProvider` memudahkan penambahan _provider_, hindari membuat terlalu banyak _provider_ kecil yang tidak perlu. Kelompokkan _state_ yang terkait secara logis ke dalam satu `ChangeNotifier` jika memungkinkan.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** "No provider found for type 'X'\!" meskipun `MultiProvider` sudah digunakan.

  - **Penyebab:**
    - Anda lupa mendaftarkan _provider_ yang diperlukan di daftar `providers` dalam `MultiProvider`.
    - Urutan _provider_ salah, dan _provider_ yang bergantung diakses sebelum _provider_ yang dibutuhkan tersedia.
    - _Widget_ yang mencoba mengakses _provider_ berada di atas `MultiProvider` di _widget tree_.
  - **Solusi:**
    - Periksa kembali daftar `providers` untuk memastikan semua _provider_ yang dibutuhkan sudah ada.
    - Pastikan _provider_ yang memiliki dependensi didefinisikan setelah dependensinya.
    - Pastikan `MultiProvider` ditempatkan di atas semua _widget_ yang akan mengkonsumsi _provider_ tersebut.

- **Kesalahan:** Error _runtime_ terkait dengan _type mismatch_ saat mengakses _provider_.

  - **Penyebab:** Anda mencoba mengakses _provider_ dengan _type_ yang salah (misalnya, `context.watch<AnotherModel>()` padahal Anda menyediakan `MyModel`).
  - **Solusi:** Pastikan _generic type_ yang Anda gunakan dengan `watch`, `read`, `Consumer`, atau `Selector` cocok dengan _type_ `ChangeNotifier` yang disediakan oleh `ChangeNotifierProvider`.

---

### 4.3 BLoC/Cubit (Introduction)

Sub-bagian ini akan memperkenalkan _Business Logic Component_ (BLoC) dan Cubit sebagai pendekatan _state management_ yang lebih terstruktur dan _event-driven_. BLoC/Cubit adalah pilihan populer untuk aplikasi skala menengah hingga besar karena memberikan pemisahan yang jelas antara logika bisnis dan UI, serta meningkatkan _testability_ dan _scalability_.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bahwa BLoC (atau Cubit, sebagai varian yang lebih sederhana) berfokus pada aliran data yang _unidirectional_ (satu arah) menggunakan _event_ sebagai input dan _state_ sebagai output. Ini membantu mengelola _state_ yang kompleks dan _asynchronous_ dengan cara yang dapat diprediksi dan mudah diuji. Meskipun mungkin terasa lebih _boilerplate_ di awal dibandingkan _Provider_, manfaatnya akan terlihat jelas di proyek yang lebih besar. Bagian ini akan menjadi dasar sebelum melangkah lebih jauh ke arsitektur aplikasi (Fase 6).

**Konsep Kunci & Filosofi Mendalam:**

- **Business Logic Component (BLoC):** BLoC adalah _pattern_ untuk memisahkan logika bisnis dari UI. Ini berpusat pada pemrosesan **Events** untuk menghasilkan **States**.

  - **Filosofi:** Logika bisnis harus independen dari UI, sehingga dapat digunakan kembali, diuji secara terpisah, dan tidak bergantung pada kerangka kerja UI.

- **Event-Driven:** BLoC bereaksi terhadap _event_. Alih-alih memanggil metode langsung pada _state manager_, _widget_ mengirimkan _event_ ke BLoC, dan BLoC memproses _event_ tersebut untuk menghasilkan _state_ baru.

  - **Filosofi:** Membuat aliran data lebih mudah diprediksi dan di-_debug_, karena semua perubahan _state_ dipicu oleh _event_ yang jelas. Ini juga mendukung _undo/redo_ dan _logging_ aksi pengguna.

- **Stream-based (BLoC Klasik):** BLoC klasik sangat bergantung pada `Stream` dari Dart. _Events_ adalah `Stream` input, dan _States_ adalah `Stream` output.

  - **Filosofi:** Memanfaatkan kekuatan Reactive Programming untuk menangani operasi asinkron dan aliran data seiring waktu.

- **Cubit (Simplified BLoC):** Cubit adalah alternatif yang lebih sederhana dari BLoC. Alih-alih _event_, Cubit memiliki metode langsung yang memicu perubahan _state_ menggunakan `emit`. Ini lebih cocok untuk skenario yang lebih sederhana tanpa perlu abstraksi _event_.

  - **Filosofi:** Menurunkan _learning curve_ BLoC dengan menghilangkan konsep _event_ saat tidak diperlukan, tetap mempertahankan manfaat pemisahan logika dan _testability_.

- **Predictable State:** Karena _state_ hanya berubah sebagai respons terhadap _event_ (atau metode di Cubit) dan menghasilkan _state_ baru, perilaku aplikasi menjadi lebih dapat diprediksi.

  - **Filosofi:** Mengurangi _bug_ yang terkait dengan _state_ yang tidak terduga dan meningkatkan keandalan aplikasi.

- **Testability:** Dengan memisahkan logika bisnis dari UI, BLoC/Cubit sangat mudah diuji secara unit, tanpa perlu menguji komponen UI.

  - **Filosofi:** Mendukung pengembangan _test-driven_ dan meningkatkan kualitas kode.

**Visualisasi Diagram Alur/Struktur:**

- **BLoC Flow Diagram:** Ilustrasi sederhana: UI -\> Events -\> BLoC -\> States -\> UI. Tunjukkan panah `Stream` untuk input `Event` dan output `State`.
- **Cubit Flow Diagram:** Ilustrasi sederhana: UI -\> Method Call -\> Cubit -\> States -\> UI. Ini menunjukkan jalur yang lebih langsung dibandingkan BLoC.
- Diagram yang menunjukkan `BlocProvider`/`BlocBuilder`/`BlocListener` di _widget tree_ dan bagaimana mereka berinteraksi dengan BLoC/Cubit yang ditempatkan di atasnya.

**Hubungan dengan Modul Lain:**
BLoC/Cubit adalah evolusi dari pemahaman _state management_ dari `setState()` dan _Provider_. Ini akan menjadi fondasi untuk pembahasan arsitektur di Fase 6, di mana konsep _Clean Architecture_ dan _Layered Architecture_ akan diintegrasikan dengan BLoC/Cubit. Penanganan operasi asinkron (Fase 5) sangat relevan karena BLoC/Cubit sangat baik dalam mengelola _state_ yang berubah akibat operasi I/O (seperti panggilan API).

---

#### 4.3.1 Core Concepts of BLoC/Cubit

Sub-bagian ini akan menguraikan komponen-komponen dasar yang membentuk BLoC dan Cubit, serta bagaimana mereka berinteraksi.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami elemen kunci dari _pattern_ BLoC/Cubit:

- **`Bloc` (`package:bloc`)**: Kelas inti yang memproses `Events` dan memetakan menjadi `States`.
- **`Cubit` (`package:bloc`)**: Varian yang lebih sederhana dari `Bloc` yang tidak menggunakan _event_, melainkan metode langsung yang memanggil `emit` untuk mengubah _state_.
- **`Event` (hanya untuk BLoC):** Representasi dari apa yang terjadi di aplikasi (misalnya, `UserLoggedInEvent`, `ProductAddedEvent`). Ini adalah input ke BLoC.
- **`State`:** Representasi dari kondisi aplikasi pada suatu waktu tertentu (misalnya, `UserState.loading`, `UserState.loaded(user)`, `CartState.empty`). Ini adalah output dari BLoC/Cubit.
- **`flutter_bloc` (Package):** Paket yang menyediakan _widget_ integrasi Flutter untuk BLoC/Cubit seperti `BlocProvider`, `BlocBuilder`, dan `BlocListener`.

**Konsep Kunci & Filosofi Mendalam:**

- **Sealed Classes/Discriminated Unions for States and Events (recommended):** Menggunakan kelas abstrak dengan _subclass_ (seringkali dengan `freezed` atau `equatable`) untuk merepresentasikan semua kemungkinan _event_ dan _state_.

  - **Filosofi:** Memastikan bahwa semua _event_ dan _state_ ditangani secara eksplisit, meningkatkan keamanan _type_ dan mengurangi _bug_ yang tidak terduga. Ini juga membuat kode lebih mudah dibaca dan di-_maintain_.

- **Immutability of States and Events:** _States_ dan _Events_ harus bersifat _immutable_. Ketika _state_ berubah, objek _state_ baru yang dihasilkan.

  - **Filosofi:** Mencegah modifikasi _state_ secara tidak langsung atau dari berbagai tempat, yang dapat menyebabkan _bug_ yang sulit dilacak. Ini juga membantu dalam perbandingan _state_ yang efisien.

- **BlocObserver (Debugging):** Sebuah alat untuk mengamati semua transisi _state_ dan _event_ di seluruh aplikasi.

  - **Filosofi:** Membantu dalam _debugging_ dan memahami aliran _state_ di aplikasi yang kompleks.

**Sintaks Dasar / Contoh Implementasi Inti:**

Pertama, tambahkan _dependencies_ `flutter_bloc` dan `equatable` (untuk membandingkan _state_ dan _event_ secara mudah) ke `pubspec.yaml` Anda:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.5 # Gunakan versi terbaru yang stabil
  equatable: ^2.0.5 # Untuk membandingkan objek secara mudah
```

Kemudian jalankan `flutter pub get`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Impor paket flutter_bloc
import 'package:equatable/equatable.dart';      // Impor equatable

// --- A. Cubit Example (Sederhana, tanpa Event) ---

// 1. Definisikan State (immutable!)
// State ini merepresentasikan kondisi CounterCubit.
class CounterState extends Equatable {
  final int value;

  const CounterState(this.value);

  // Equatable memungkinkan perbandingan objek berdasarkan nilai propertinya.
  // Ini penting agar BlocBuilder hanya rebuilt ketika state benar-benar berubah.
  @override
  List<Object> get props => [value];
}

// 2. Buat Cubit
class CounterCubit extends Cubit<CounterState> {
  // Inisialisasi Cubit dengan state awal
  CounterCubit() : super(const CounterState(0));

  // Metode untuk mengubah state
  void increment() {
    // emit() adalah cara Cubit untuk mengeluarkan state baru.
    emit(CounterState(state.value + 1));
  }

  void decrement() {
    emit(CounterState(state.value - 1));
  }
}

// --- B. BLoC Example (dengan Event, untuk skenario lebih kompleks) ---

// 1. Definisikan Events (immutable!)
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

// 2. Definisikan State (immutable!)
// Bisa sama dengan Cubit, atau lebih kompleks sesuai kebutuhan.
// Kita gunakan yang sama untuk konsistensi.
// class CounterState extends Equatable { ... (sudah didefinisikan di atas)
// Contoh state yang lebih kompleks:
// class CounterState extends Equatable {
//   final int value;
//   final bool isLoading;
//   final String? error;
//   const CounterState({required this.value, this.isLoading = false, this.error});
//   @override List<Object?> get props => [value, isLoading, error];
//   CounterState copyWith({int? value, bool? isLoading, String? error}) { /* ... */ }
// }


// 3. Buat BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // Inisialisasi Bloc dengan state awal
  CounterBloc() : super(const CounterState(0)) {
    // Daftarkan handler untuk setiap Event.
    // on<EventType>((event, emit) => { ... logika ... emit(newState); });
    on<IncrementEvent>((event, emit) {
      emit(CounterState(state.value + 1));
    });

    on<DecrementEvent>((event, emit) {
      emit(CounterState(state.value - 1));
    });
  }
}

// --- C. BlocObserver (untuk Debugging) ---
// Untuk melihat semua transisi state dan event di aplikasi
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError: $error');
    super.onError(bloc, error, stackTrace);
  }
}

// --- D. Main Application (Menggunakan BlocProvider dan BlocBuilder) ---
void main() {
  // Daftarkan BlocObserver
  Bloc.observer = SimpleBlocObserver();

  runApp(
    // BlocProvider menyediakan instance BLoC/Cubit ke bawah widget tree.
    // Untuk Cubit:
    // BlocProvider<CounterCubit>(
    //   create: (context) => CounterCubit(),
    //   child: const CubitCounterApp(),
    // ),
    // Untuk BLoC:
    BlocProvider<CounterBloc>(
      create: (context) => CounterBloc(),
      child: const BlocCounterApp(),
    ),
  );
}

// --- E. Widget Konsumen untuk Cubit ---
class CubitCounterApp extends StatelessWidget {
  const CubitCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubit Counter Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(title: const Text('Cubit Counter')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Cubit Counter Value:', style: TextStyle(fontSize: 24)),
              // BlocBuilder mendengarkan state dari Cubit dan membangun ulang hanya bagian ini.
              BlocBuilder<CounterCubit, CounterState>(
                builder: (context, state) {
                  print('Cubit CounterBuilder rebuilt: ${state.value}'); // Log rebuild
                  return Text(
                    '${state.value}',
                    style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'cubitDecrement',
                    onPressed: () => context.read<CounterCubit>().decrement(), // Panggil metode langsung
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    heroTag: 'cubitIncrement',
                    onPressed: () => context.read<CounterCubit>().increment(), // Panggil metode langsung
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- F. Widget Konsumen untuk BLoC ---
class BlocCounterApp extends StatelessWidget {
  const BlocCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Counter Demo',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Scaffold(
        appBar: AppBar(title: const Text('BLoC Counter')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('BLoC Counter Value:', style: TextStyle(fontSize: 24)),
              // BlocBuilder mendengarkan state dari BLoC dan membangun ulang hanya bagian ini.
              BlocBuilder<CounterBloc, CounterState>(
                builder: (context, state) {
                  print('BLoC CounterBuilder rebuilt: ${state.value}'); // Log rebuild
                  return Text(
                    '${state.value}',
                    style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'blocDecrement',
                    onPressed: () => context.read<CounterBloc>().add(DecrementEvent()), // Kirim Event
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    heroTag: 'blocIncrement',
                    onPressed: () => context.read<CounterBloc>().add(IncrementEvent()), // Kirim Event
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Lihat log konsol untuk Event, Transition, dan Rebuilds.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Penjelasan Konteks Kode:**

- **`equatable` Package:** Digunakan untuk membuat _state_ dan _event_ Anda mudah dibandingkan. Dengan meng-_extend_ `Equatable` dan meng-_override_ `props`, Anda memberitahu Dart untuk membandingkan objek berdasarkan nilai propertinya, bukan referensi memori. Ini sangat penting untuk `BlocBuilder` agar tahu kapan harus di-_rebuild_.
- **A. Cubit Example:**
  - **`CounterState`:** Kelas yang merepresentasikan _state_. Dibuat _immutable_ (`final` properti) dan _extends_ `Equatable`.
  - **`CounterCubit`:** _Extends_ `Cubit<CounterState>`. Konstruktor memanggil `super()` dengan _state_ awal.
  - Metode `increment()` dan `decrement()` memanggil `emit(newState)`. `emit()` adalah cara Cubit untuk "mengeluarkan" _state_ baru, yang kemudian akan didengarkan oleh `BlocBuilder` di UI.
- **B. BLoC Example:**
  - **`CounterEvent` (`abstract`):** Kelas dasar abstrak untuk semua _event_.
  - **`IncrementEvent`, `DecrementEvent`:** Kelas-kelas _event_ konkret. Mereka adalah _immutable_ dan _extends_ `Equatable`.
  - **`CounterBloc`:** _Extends_ `Bloc<CounterEvent, CounterState>`. Konstruktor memanggil `super()` dengan _state_ awal.
  - **`on<EventType>((event, emit) { ... })`:** Ini adalah _event handler_ di dalam BLoC. Untuk setiap `EventType` yang ingin Anda tangani, Anda mendaftarkan sebuah _callback_. _Callback_ ini menerima `event` dan fungsi `emit` yang digunakan untuk mengeluarkan _state_ baru. Logika bisnis Anda berada di sini.
- **C. `BlocObserver`:**
  - Sebuah kelas yang _extends_ `BlocObserver` memungkinkan Anda untuk mencegat setiap `event`, `transition` (perubahan _state_ yang berhasil), dan `error` di semua BLoC/Cubit di aplikasi Anda. Sangat berguna untuk _debugging_. Anda harus mendaftarkannya di `main()` dengan `Bloc.observer = SimpleBlocObserver();`.
- **D. Main Application (`BlocProvider`):**
  - `BlocProvider<T>`: Mirip dengan `ChangeNotifierProvider`, ini adalah _widget_ yang menyediakan instance BLoC/Cubit dari _type_ `T` ke _widget tree_ di bawahnya.
  - `create: (context) => CounterBloc()`: _Callback_ untuk membuat instance BLoC/Cubit.
- **E. Widget Konsumen untuk Cubit (`CubitCounterApp`):**
  - **`BlocBuilder<CounterCubit, CounterState>`:** Ini adalah _widget_ kunci untuk mengkonsumsi _state_ dari Cubit (atau BLoC). Ia menerima dua _generic type_: _tipe Cubit/BLoC_ dan _tipe State_.
    - Properti `builder` adalah fungsi yang dipanggil setiap kali _state_ dari `CounterCubit` berubah (yaitu, ketika `emit()` dipanggil). Ia menerima `context` dan `state` saat ini.
    - Hanya _widget_ di dalam _builder_ ini yang akan di-_rebuild_ ketika _state_ berubah, mirip dengan `Consumer`.
  - **`context.read<CounterCubit>().decrement()`:** Untuk memicu perubahan _state_ di Cubit, Anda memanggil metode langsung pada instance Cubit. Gunakan `context.read()` karena Anda tidak ingin _widget_ yang memicu aksi di-_rebuild_ hanya karena aksi itu terjadi.
- **F. Widget Konsumen untuk BLoC (`BlocCounterApp`):**
  - **`BlocBuilder<CounterBloc, CounterState>`:** Mirip dengan Cubit, ia mendengarkan _state_ dari `CounterBloc`.
  - **`context.read<CounterBloc>().add(DecrementEvent())`:** Untuk memicu perubahan _state_ di BLoC, Anda mengirimkan (`add`) sebuah `Event` ke BLoC. BLoC kemudian akan memproses _event_ tersebut melalui _event handler_ yang sesuai.

**Visualisasi Diagram Alur/Struktur:**

- Diagram BLoC/Cubit yang ditempatkan oleh `BlocProvider` di atas _widget tree_.
- `BlocBuilder` di bawahnya "mendengarkan" perubahan _state_ dari BLoC/Cubit.
- Tombol-tombol di UI "mengirimkan" _Event_ ke BLoC (untuk BLoC) atau "memanggil metode" pada Cubit (untuk Cubit) melalui `context.read()`.
- BLoC/Cubit memprosesnya dan "mengeluarkan" _state_ baru yang kembali ke `BlocBuilder`, memicu _rebuild_ pada bagian UI tersebut.

**Terminologi Esensial & Penjelasan Detail:**

- **BLoC (Business Logic Component):** Sebuah _pattern_ dan juga kelas dasar dari paket `bloc` yang memetakan `Event` menjadi `State`.
- **Cubit:** Varian yang lebih sederhana dari BLoC yang memetakan pemanggilan metode langsung menjadi `State`.
- **`Event`:** Objek yang merepresentasikan aksi atau input dari UI/layanan lain ke BLoC. Harus _immutable_.
- **`State`:** Objek yang merepresentasikan kondisi data saat ini yang dikeluarkan oleh BLoC/Cubit. Harus _immutable_.
- **`emit()`:** Metode di Cubit (dan di dalam _event handler_ BLoC) yang digunakan untuk mengeluarkan _state_ baru, yang kemudian akan diperhatikan oleh `BlocBuilder` atau `BlocListener`.
- **`on<EventType>()`:** Metode yang digunakan di BLoC untuk mendaftarkan _event handler_ untuk `EventType` tertentu.
- **`add()`:** Metode pada instance BLoC yang digunakan oleh UI untuk mengirimkan `Event` ke BLoC.
- **`flutter_bloc`:** Paket integrasi Flutter yang menyediakan _widget_ seperti `BlocProvider`, `BlocBuilder`, `BlocListener`, dll.
- **`BlocProvider<T>`:** _Widget_ yang menyediakan instance BLoC/Cubit dari tipe `T` ke _widget tree_ di bawahnya (mirip dengan `ChangeNotifierProvider`).
- **`BlocBuilder<B, S>`:** _Widget_ yang mendengarkan _state_ dari BLoC/Cubit (`B`) dan membangun ulang bagian UI-nya setiap kali _state_ (`S`) berubah.
- **`BlocObserver`:** Sebuah kelas yang memungkinkan Anda mengamati semua transisi _state_ dan _event_ di seluruh aplikasi Anda untuk _debugging_.
- **`equatable`:** Sebuah paket yang membantu dalam membandingkan objek Dart berdasarkan nilai propertinya, bukan referensi memori, yang penting untuk performa `BlocBuilder` dan menghindari _rebuild_ yang tidak perlu.

**Sumber Referensi Lengkap:**

- [Bloc Library Documentation (Website Resmi)](https://bloclibrary.dev/) - Sumber terbaik dan terlengkap.
- [Cubit Documentation (Bloc Library)](https://www.google.com/search?q=https://bloclibrary.dev/%23/cubit)
- [flutter_bloc Documentation (Bloc Library)](https://www.google.com/search?q=https://bloclibrary.dev/%23/flutterbloc)
- [Equatable Package (pub.dev)](https://pub.dev/packages/equatable)
- [Bloc vs Cubit (Bloc Library)](https://www.google.com/search?q=https://bloclibrary.dev/%23/bloc-vs-cubit)

**Tips dan Praktik Terbaik:**

- **Pilih BLoC atau Cubit dengan Bijak:**
  - Gunakan **Cubit** untuk _state management_ sederhana di mana Anda hanya perlu memanggil metode untuk mengubah _state_. Ideal untuk fitur-fitur yang tidak memiliki banyak _event_ atau logika kompleks.
  - Gunakan **BLoC** ketika Anda memiliki logika bisnis yang lebih kompleks yang melibatkan banyak _event_ yang berbeda atau memerlukan pemrosesan yang lebih terstruktur (misalnya, _debounce_, _throttling_, _cancellation_).
- **Immutability:** Selalu pastikan _state_ dan _event_ Anda bersifat _immutable_. Gunakan `const` konstruktor dan `copyWith` jika perlu. `equatable` sangat membantu di sini.
- **Desain State yang Jelas:** Definisikan _state_ Anda dengan jelas untuk mencakup semua kemungkinan kondisi UI (loading, loaded, error, empty, etc.).
- **Pemisahan Tanggung Jawab:** Pastikan logika bisnis hanya ada di BLoC/Cubit, dan UI hanya bertanggung jawab untuk mengirim _event_ (atau memanggil metode Cubit) dan menampilkan _state_.
- **Gunakan `BlocObserver`:** Selalu aktifkan `BlocObserver` selama pengembangan untuk memahami aliran _state_ dan _event_ di aplikasi Anda.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** UI tidak diperbarui ketika _state_ BLoC/Cubit berubah.

  - **Penyebab:**
    - Lupa memanggil `emit(newState)` di BLoC/Cubit setelah logika selesai.
    - Objek _state_ tidak berubah secara referensi (misalnya, memodifikasi properti pada objek _state_ yang sama daripada mengeluarkan objek _state_ baru yang _immutable_).
    - Tidak menggunakan `Equatable` (atau `copyWith` yang benar) untuk perbandingan _state_ yang efisien, sehingga `BlocBuilder` tidak mendeteksi perubahan.
  - **Solusi:** Pastikan Anda `emit` _state_ baru. Pastikan _state_ Anda _immutable_ dan gunakan `Equatable` (atau `copyWith`) dengan benar.

- **Kesalahan:** "No BlocProvider found for type 'X'\!"

  - **Penyebab:** Anda mencoba mengakses BLoC/Cubit (misalnya, `context.read<CounterBloc>()`) dari `context` yang _tidak memiliki_ `BlocProvider` untuk BLoC/Cubit tersebut sebagai _ancestor_.
  - **Solusi:** Pastikan `BlocProvider` (atau `MultiBlocProvider` untuk beberapa BLoC/Cubit) ditempatkan di atas _widget tree_ yang cukup tinggi sehingga semua _descendant_ yang memerlukannya dapat mengaksesnya.

- **Kesalahan:** Terlalu banyak _boilerplate_ atau kode yang berulang.

  - **Penyebab:** Terlalu sering membuat kelas `Event` atau `State` yang sangat sederhana, atau tidak memanfaatkan fitur seperti `freezed` atau `bloc_test`.
  - **Solusi:** Pertimbangkan untuk menggunakan Cubit jika _event_ Anda terlalu sederhana. Pelajari tentang `freezed` untuk membuat _immutable_ _data class_ dengan mudah. Ini akan sangat mengurangi _boilerplate_.

---

#### 4.3.2 Basic Implementation with `flutter_bloc`

Sub-bagian ini akan berfokus pada penggunaan praktis dari _widget_-_widget_ yang disediakan oleh paket `flutter_bloc` untuk mengintegrasikan BLoC/Cubit dengan UI Flutter.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari bagaimana menggunakan `BlocProvider`, `BlocBuilder`, `BlocListener`, dan `BlocConsumer` untuk menyuntikkan (inject) BLoC/Cubit ke _widget tree_, membangun UI berdasarkan _state_ BLoC/Cubit, dan melakukan aksi sampingan (side effects) sebagai respons terhadap perubahan _state_. Selain itu, akan diperkenalkan `RepositoryProvider` sebagai cara untuk menyediakan dependensi (seperti layanan API) ke BLoC/Cubit. Ini adalah implementasi inti dari _pattern_ BLoC/Cubit di UI Flutter.

**Konsep Kunci & Filosofi Mendalam:**

- **`BlocProvider` (Dependency Injection):** Mirip dengan `ChangeNotifierProvider`, `BlocProvider` adalah cara untuk membuat BLoC/Cubit tersedia di _widget tree_.

  - **Filosofi:** Mengurangi _coupling_ antara UI dan logika bisnis. UI tidak perlu tahu bagaimana BLoC/Cubit dibuat, hanya perlu tahu bagaimana mengaksesnya.

- **`BlocBuilder` (Rebuild UI on State Change):** `BlocBuilder` bertanggung jawab untuk membangun ulang bagian dari UI ketika _state_ BLoC/Cubit berubah. Ini sangat mirip dengan `Consumer` di _Provider_.

  - **Filosofi:** Memastikan bahwa hanya bagian UI yang relevan yang di-_rebuild_, mengoptimalkan kinerja _rendering_.

- **`BlocListener` (Side Effects on State Change):** `BlocListener` digunakan untuk melakukan aksi sampingan yang tidak melibatkan _rebuild_ UI (misalnya, menampilkan `SnackBar`, navigasi, menampilkan dialog) sebagai respons terhadap perubahan _state_.

  - **Filosofi:** Memisahkan logika _rendering_ UI dari logika aksi sampingan, menjaga _widget_ tetap fokus pada tugas utamanya.

- **`BlocConsumer` (Combine Builder & Listener):** `BlocConsumer` adalah kombinasi dari `BlocBuilder` dan `BlocListener`, berguna ketika Anda ingin membangun UI _dan_ melakukan aksi sampingan berdasarkan _state_ yang sama.

  - **Filosofi:** Menyediakan _utility_ yang nyaman untuk skenario umum tanpa perlu menumpuk `BlocBuilder` dan `BlocListener`.

- **`RepositoryProvider` (Providing Dependencies):** Digunakan untuk menyediakan objek atau layanan yang tidak mengelola _state_ (misalnya, `UserRepository`, `ApiServiceClient`) ke BLoC/Cubit atau _widget_ lain.

  - **Filosofi:** Mendorong pemisahan tanggung jawab yang lebih lanjut, di mana BLoC/Cubit berinteraksi dengan repositori untuk mendapatkan data, bukan langsung dengan layanan API. Ini sangat penting untuk _testability_.

**Visualisasi Diagram Alur/Struktur:**

- Diagram `BlocProvider` di bagian atas _widget tree_, menyediakan `Bloc` ke bawah.
- Panah dari `Bloc` ke `BlocBuilder` (memicu _rebuild_ UI).
- Panah dari `Bloc` ke `BlocListener` (memicu aksi sampingan seperti `SnackBar`).
- Diagram `BlocConsumer` yang menunjukkan kedua panah (rebuild dan side effect) dari satu _widget_.
- Diagram yang menunjukkan `RepositoryProvider` di atas `BlocProvider`, dan `BlocProvider` mengakses `Repository` yang disediakan. Ini mengilustrasikan alur dependensi.

**Hubungan dengan Modul Lain:**
Ini adalah langkah praktis dalam mengimplementasikan BLoC/Cubit yang telah dibahas konsepnya. `RepositoryProvider` secara langsung berhubungan dengan konsep Lapisan Data dan Repositori yang akan dibahas lebih lanjut di Fase 6 (Arsitektur Aplikasi), serta integrasi API (Fase 5).

---

**Sintaks Dasar / Contoh Implementasi Inti:**

Mari kita kembangkan contoh counter dengan menambahkan fitur "loading" dan "error" untuk demonstrasi `BlocListener` dan juga sebuah "Repository" sederhana.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// --- 1. Repository/Service (Contoh: untuk simulasi operasi asinkron) ---
// Ini adalah kelas yang akan diinjeksi ke BLoC/Cubit.
// Tidak menggunakan ChangeNotifier, ini adalah kelas Dart biasa.
class CounterRepository {
  Future<int> fetchInitialCounterValue() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi network delay
    return 10; // Nilai awal dari "server"
  }

  Future<int> incrementRemote(int currentValue) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulasi error sesekali
    if (currentValue >= 12) { // Contoh: tidak bisa increment di atas 12
      throw Exception('Cannot increment above 12!');
    }
    return currentValue + 1;
  }
}

// --- 2. BLoC Events ---
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class LoadCounterEvent extends CounterEvent {} // Untuk memuat nilai awal
class IncrementCounterEvent extends CounterEvent {}
class DecrementCounterEvent extends CounterEvent {}

// --- 3. BLoC States ---
abstract class CounterState extends Equatable {
  const CounterState();

  @override
  List<Object> get props => [];
}

class CounterInitial extends CounterState {}

class CounterLoading extends CounterState {}

class CounterLoaded extends CounterState {
  final int value;
  const CounterLoaded(this.value);

  @override
  List<Object> get props => [value];
}

class CounterError extends CounterState {
  final String message;
  const CounterError(this.message);

  @override
  List<Object> get props => [message];
}

// --- 4. BLoC ---
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // BLoC sekarang menerima CounterRepository sebagai dependensi
  final CounterRepository _counterRepository;

  CounterBloc(this._counterRepository) : super(CounterInitial()) {
    on<LoadCounterEvent>(_onLoadCounter);
    on<IncrementCounterEvent>(_onIncrementCounter);
    on<DecrementCounterEvent>(_onDecrementCounter);
  }

  Future<void> _onLoadCounter(
      LoadCounterEvent event, Emitter<CounterState> emit) async {
    emit(CounterLoading()); // Mengeluarkan state loading
    try {
      final value = await _counterRepository.fetchInitialCounterValue();
      emit(CounterLoaded(value)); // Mengeluarkan state loaded
    } catch (e) {
      emit(CounterError(e.toString())); // Mengeluarkan state error
    }
  }

  Future<void> _onIncrementCounter(
      IncrementCounterEvent event, Emitter<CounterState> emit) async {
    if (state is CounterLoaded) {
      final currentValue = (state as CounterLoaded).value;
      try {
        final newValue = await _counterRepository.incrementRemote(currentValue);
        emit(CounterLoaded(newValue));
      } catch (e) {
        emit(CounterError(e.toString())); // Mengeluarkan state error
      }
    }
  }

  Future<void> _onDecrementCounter(
      DecrementCounterEvent event, Emitter<CounterState> emit) async {
    if (state is CounterLoaded) {
      final currentValue = (state as CounterLoaded).value;
      if (currentValue > 0) { // Contoh: tidak bisa decrement di bawah 0
        emit(CounterLoaded(currentValue - 1));
      } else {
        emit(const CounterError('Cannot decrement below zero!'));
      }
    }
  }
}

// --- 5. Main Application ---
void main() {
  runApp(
    // MultiRepositoryProvider / RepositoryProvider untuk menyediakan dependensi
    RepositoryProvider(
      create: (context) => CounterRepository(), // Menyediakan instance CounterRepository
      child: BlocProvider(
        // BlocProvider untuk menyediakan CounterBloc
        // CounterBloc sekarang memerlukan CounterRepository, yang diakses via context.read
        create: (context) => CounterBloc(context.read<CounterRepository>())
          ..add(LoadCounterEvent()), // Memicu load data awal
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Implementation Demo',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const CounterPage(),
    );
  }
}

// --- 6. UI: CounterPage ---
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Counter App'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Counter Value:',
              style: TextStyle(fontSize: 24),
            ),
            // BlocBuilder untuk membangun UI berdasarkan state
            BlocBuilder<CounterBloc, CounterState>(
              builder: (context, state) {
                print('BlocBuilder rebuilt: $state'); // Log untuk melihat rebuild
                if (state is CounterInitial) {
                  return const CircularProgressIndicator();
                } else if (state is CounterLoading) {
                  return const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Loading...', style: TextStyle(fontSize: 20)),
                    ],
                  );
                } else if (state is CounterLoaded) {
                  return Text(
                    '${state.value}',
                    style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                  );
                } else if (state is CounterError) {
                  return Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 20, color: Colors.red),
                    textAlign: TextAlign.center,
                  );
                }
                return const Text('Unknown State'); // Fallback
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'decrementBtn',
                  onPressed: () => context.read<CounterBloc>().add(DecrementCounterEvent()),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'incrementBtn',
                  onPressed: () => context.read<CounterBloc>().add(IncrementCounterEvent()),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
      // BlocListener untuk side effects (misalnya, menampilkan SnackBar pada Error)
      // Perhatikan bahwa BlocListener tidak me-rebuild UI.
      // listener: (context, state) adalah callback yang dipanggil saat state berubah.
      // listenWhen: (previousState, currentState) adalah opsional, untuk filter kapan listener dipanggil.
      bottomNavigationBar: BlocListener<CounterBloc, CounterState>(
        listener: (context, state) {
          if (state is CounterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CounterLoaded && state.value == 10) {
            // Contoh lain: Aksi ketika counter mencapai 10
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Counter is back to 10!'),
                backgroundColor: Colors.blue,
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        // Anda bisa menyertakan child jika ingin BlocListener "membungkus" sesuatu
        child: const SizedBox.shrink(), // Biasanya tidak ada UI di sini
      ),
    );
  }
}

// --- Tambahan: BlocConsumer ---
// Menggabungkan BlocBuilder dan BlocListener
class CounterDisplayAndNotifier extends StatelessWidget {
  const CounterDisplayAndNotifier({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CounterBloc, CounterState>(
      // listener sama seperti BlocListener
      listener: (context, state) {
        if (state is CounterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Consumer Error: ${state.message}')),
          );
        }
      },
      // builder sama seperti BlocBuilder
      builder: (context, state) {
        if (state is CounterLoaded) {
          return Text('Consumer Value: ${state.value}', style: const TextStyle(fontSize: 30));
        }
        return const CircularProgressIndicator();
      },
      // listenWhen dan buildWhen juga tersedia di BlocConsumer
      // listenWhen: (previous, current) => current is CounterError,
      // buildWhen: (previous, current) => current is CounterLoaded,
    );
  }
}
```

**Penjelasan Konteks Kode:**

1.  **`CounterRepository`:** Sebuah kelas Dart biasa yang mensimulasikan sumber data (misalnya, API _backend_). Ini tidak _extend_ `ChangeNotifier` atau BLoC. Fungsinya adalah untuk menyediakan data atau memproses logika terkait data yang tidak secara langsung merupakan _state_ aplikasi. Ini penting untuk pemisahan tanggung jawab.
2.  **`CounterEvent` & `CounterState`:** Kita mendefinisikan _event_ dan _state_ yang lebih beragam untuk mencakup kasus `Loading`, `Loaded`, dan `Error`.
    - Setiap _state_ adalah kelas terpisah yang _extends_ `CounterState` dan `Equatable`, memungkinkan kita untuk membedakan kondisi aplikasi dengan jelas.
3.  **`CounterBloc`:**
    - Konstruktornya sekarang menerima `CounterRepository`. Ini adalah pola umum di BLoC/Cubit: BLoC/Cubit mendapatkan dependensinya melalui konstruktor.
    - Kita memiliki _event handler_ `_onLoadCounter` yang disiapkan untuk `LoadCounterEvent`. Di sini, kita menunjukkan bagaimana BLoC dapat mengeluarkan berbagai _state_ (misalnya, `CounterLoading`, `CounterLoaded`, `CounterError`) secara berurutan sebagai respons terhadap operasi asinkron.
    - Metode `incrementRemote` di `CounterRepository` sekarang dapat melempar `Exception`, dan BLoC menanganinya dengan mengeluarkan `CounterError` _state_.
4.  **`main()` function (`RepositoryProvider` & `BlocProvider`):**
    - **`RepositoryProvider<CounterRepository>`:** Ini adalah _widget_ yang menyediakan instance `CounterRepository` ke _widget tree_. Ini sering ditempatkan di atas `BlocProvider` jika BLoC/Cubit memerlukan repositori.
    - **`BlocProvider<CounterBloc>`:** Ini menyediakan `CounterBloc`. Perhatikan bagaimana instance `CounterBloc` dibuat: `create: (context) => CounterBloc(context.read<CounterRepository>())`. Ini berarti `CounterBloc` mendapatkan `CounterRepository`-nya dari _widget tree_ melalui `context.read()`. Ini adalah contoh _Dependency Injection_ yang jelas.
    - `..add(LoadCounterEvent())`: Setelah `CounterBloc` dibuat, kita langsung mengirimkan `LoadCounterEvent` untuk memicu pemuatan data awal.
5.  **`CounterPage` (UI):**
    - **`BlocBuilder<CounterBloc, CounterState>`:** Digunakan di tengah halaman untuk menampilkan nilai counter atau indikator _loading_ atau pesan _error_.
      - Di dalam _builder_, kita melakukan pengecekan tipe _state_ (`if (state is CounterLoading)`, `if (state is CounterLoaded)`, dll.) untuk menampilkan UI yang berbeda sesuai kondisi _state_ saat ini. Ini adalah pola umum.
    - **`BlocListener<CounterBloc, CounterState>`:** Ditempatkan di properti `bottomNavigationBar` dari `Scaffold`. Ini menunjukkan bahwa `BlocListener` dapat ditempatkan di mana saja di _widget tree_ yang memiliki akses ke BLoC, dan tidak harus menjadi bagian dari area `body` yang di-_rebuild_.
      - Properti `listener` adalah _callback_ yang dipicu setiap kali _state_ BLoC berubah. Di sini, kita menggunakannya untuk menampilkan `SnackBar` ketika _error state_ atau _state_ tertentu tercapai.
      - Perhatikan bahwa `BlocListener` memiliki properti `child` opsional. Jika Anda tidak memiliki _widget_ yang perlu di-_listen_ tetapi tidak di-_rebuild_, Anda bisa gunakan `SizedBox.shrink()` atau `Container()`.
      - `listenWhen` (opsional): Anda dapat memberikan _callback_ ke `listenWhen` untuk menentukan kapan `listener` harus dipicu. Misalnya, `listenWhen: (previous, current) => current is CounterError` akan memastikan `listener` hanya dipanggil saat _state_ saat ini adalah `CounterError`. Ini sangat berguna untuk mencegah _listener_ bereaksi pada setiap perubahan _state_ yang tidak relevan.
6.  **`CounterDisplayAndNotifier` (`BlocConsumer`):**
    - `BlocConsumer<B, S>`: Menggabungkan fungsionalitas `BlocBuilder` (`builder` property) dan `BlocListener` (`listener` property) ke dalam satu _widget_.
    - Sangat berguna ketika Anda ingin membangun ulang bagian UI _dan_ memicu aksi sampingan sebagai respons terhadap _state_ yang sama.
    - Juga mendukung `listenWhen` dan `buildWhen` untuk kontrol yang lebih halus.

**Visualisasi Diagram Alur/Struktur:**

- **Aplikasi Umum:**
  - `RepositoryProvider` (menyediakan `CounterRepository`)
  - `BlocProvider` (mengambil `CounterRepository` dan menyediakan `CounterBloc`)
  - `CounterPage` (memiliki `Scaffold`)
  - Di `body` `Scaffold`: `BlocBuilder` (menerima _state_, membangun UI)
  - Di `bottomNavigationBar` `Scaffold`: `BlocListener` (menerima _state_, memicu `SnackBar`)
- Panah `context.read` dari `BlocProvider` ke `RepositoryProvider`.
- Panah `add` _event_ dari FloatingActionButtons ke `CounterBloc`.
- Panah `state` dari `CounterBloc` ke `BlocBuilder` dan `BlocListener`.

**Terminologi Esensial & Penjelasan Detail:**

- **`BlocProvider<T>`:** _Widget_ yang menyediakan BLoC/Cubit dari tipe `T` ke _widget tree_ di bawahnya.
- **`BlocBuilder<B, S>`:** _Widget_ yang mendengarkan perubahan _state_ `S` dari BLoC/Cubit `B` dan membangun ulang bagian UI-nya di dalam fungsi `builder`.
  - `buildWhen` (opsional): Sebuah _callback_ yang dapat digunakan untuk menentukan kapan `BlocBuilder` harus di-_rebuild_. `buildWhen: (previousState, currentState) => true/false`. Jika `false`, `builder` tidak akan dipanggil ulang. Sangat berguna untuk optimasi.
- **`BlocListener<B, S>`:** _Widget_ yang mendengarkan perubahan _state_ `S` dari BLoC/Cubit `B` dan memicu _callback_ `listener` untuk efek samping (navigasi, `SnackBar`, dialog), tanpa membangun ulang UI.
  - `listenWhen` (opsional): Mirip dengan `buildWhen`, ini menentukan kapan `listener` harus dipicu.
- **`BlocConsumer<B, S>`:** Gabungan dari `BlocBuilder` dan `BlocListener`. Memiliki properti `builder` dan `listener`, serta `buildWhen` dan `listenWhen`.
- **`RepositoryProvider<T>`:** _Widget_ dari `flutter_bloc` yang digunakan untuk menyediakan instance kelas (seringkali kelas `Repository` atau `Service`) yang tidak mengelola _state_ yang dapat berubah, tetapi berfungsi sebagai dependensi untuk BLoC/Cubit. Ini meningkatkan _testability_ karena repositori dapat di-_mock_.
- **`MultiBlocProvider` / `MultiRepositoryProvider`:** Mirip dengan `MultiProvider`, ini digunakan untuk menyediakan beberapa BLoC/Cubit atau beberapa Repositori sekaligus tanpa _nesting_ yang dalam.

**Sumber Referensi Lengkap:**

- [BlocProvider (Bloc Library)](https://www.google.com/search?q=https://bloclibrary.dev/%23/flutterbloc%3Fid%3Dblocprovider)
- [BlocBuilder (Bloc Library)](https://www.google.com/search?q=https://bloclibrary.dev/%23/flutterbloc%3Fid%3Dblocbuilder)
- [BlocListener (Bloc Library)](https://www.google.com/search?q=https://bloclibrary.dev/%23/flutterbloc%3Fid%3Dbloclistener)
- [BlocConsumer (Bloc Library)](https://www.google.com/search?q=https://bloclibrary.dev/%23/flutterbloc%3Fid%3Dblocconsumer)
- [RepositoryProvider (Bloc Library)](https://www.google.com/search?q=https://bloclibrary.dev/%23/flutterbloc%3Fid%3Drepositoryprovider)
- [Bloc vs Cubit vs ChangeNotifier (Medium)](https://www.google.com/search?q=https://medium.com/flutter-community/bloc-vs-cubit-vs-changenotifier-128a30646197) - Perbandingan yang membantu memahami kapan menggunakan masing-masing.

**Tips dan Praktik Terbaik:**

- **Satu BLoC per Fitur/Domain:** Umumnya, desain satu BLoC/Cubit per fitur atau domain logis (misalnya, `AuthBloc`, `ProductBloc`, `CartBloc`).
- **Gunakan `BlocBuilder` Secara Selektif:** Bungkus bagian terkecil dari _widget tree_ yang perlu di-_rebuild_ dengan `BlocBuilder` untuk performa terbaik. Manfaatkan `buildWhen` untuk kontrol yang lebih halus.
- **`BlocListener` untuk Side Effects:** Selalu gunakan `BlocListener` (atau `BlocConsumer` dengan `listener`) untuk aksi sampingan seperti navigasi, dialog, atau `SnackBar`. Jangan melakukan aksi sampingan di dalam `BlocBuilder` karena itu bisa terpicu pada setiap _rebuild_.
- **Injeksi Dependensi dengan Providers:** Gunakan `RepositoryProvider` (atau `Provider` biasa jika Anda nyaman dengan itu) untuk menyediakan dependensi seperti _API services_ atau _databases_ ke BLoC/Cubit Anda. Ini membuat BLoC/Cubit lebih mudah diuji dan kode lebih bersih.
- **`context.read()` untuk Mengirim Event/Memanggil Metode:** Selalu gunakan `context.read<BlocOrCubit>().add(Event())` atau `context.read<BlocOrCubit>().method()` untuk memicu perubahan _state_ dari _callback_ (misalnya `onPressed`), karena ini tidak akan membuat _widget_ Anda di-_rebuild_ saat BLoC/Cubit mengeluarkan _state_ baru.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menggunakan `context.watch<BlocOrCubit>()` di dalam `build` method untuk mengakses BLoC/Cubit dan memicu `add(Event())` atau `method()`.

  - **Penyebab:** Ini akan membuat _widget_ di-_rebuild_ pada setiap perubahan _state_, dan jika `add` dipanggil di `build` tanpa kondisi yang tepat, bisa menyebabkan _infinite loop_.
  - **Solusi:** Gunakan `BlocBuilder` untuk membaca _state_ dan membangun UI. Gunakan `context.read()` saat mengirim _event_ atau memanggil metode Cubit dari _callback_ (`onPressed`).

- **Kesalahan:** `BlocListener` tidak memicu aksi sampingan.

  - **Penyebab:** `listenWhen` mengembalikan `false` secara tidak sengaja, atau `BlocListener` ditempatkan terlalu rendah di _widget tree_ sehingga tidak memiliki akses ke BLoC/Cubit yang benar, atau _state_ yang diharapkan tidak pernah benar-benar dikeluarkan oleh BLoC/Cubit.
  - **Solusi:** Periksa logika `listenWhen`. Pastikan _state_ yang Anda harapkan benar-benar dikeluarkan oleh BLoC/Cubit. Pastikan `BlocListener` berada di bawah `BlocProvider` yang sesuai.

- **Kesalahan:** Error _runtime_ seperti "Looking up a `BlocProvider` isn't supported outside of the `build` method".

  - **Penyebab:** Anda mencoba mengakses `context.read()` atau `context.watch()` di luar `build` method atau _callback_ yang memiliki `BuildContext` yang valid (misalnya, di dalam metode `initState` tanpa `Provider.of` yang tepat).
  - **Solusi:** Pastikan Anda memiliki `BuildContext` yang valid. Untuk `initState`, gunakan `Provider.of<BlocOrCubit>(context, listen: false)` setelah `super.initState()` jika perlu. Atau, lebih baik lagi, BLoC/Cubit harus memuat data awalnya sendiri sebagai respons terhadap `Event` (seperti `LoadCounterEvent` di contoh).

---

### 4.4 Other State Management Approaches (Overview)

Sub-bagian ini akan memberikan gambaran singkat tentang beberapa opsi _state management_ populer lainnya di ekosistem Flutter selain _Provider_ dan BLoC/Cubit. Tujuan utamanya adalah untuk memperkenalkan keberadaan alternatif-alternatif ini dan membantu pembelajar memahami bahwa ada berbagai alat dengan filosofi yang berbeda. **Tidak akan ada contoh kode mendalam di bagian ini**, karena fokus utama kurikulum ini adalah pada _Provider_ dan BLoC/Cubit.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan menyadari bahwa komunitas Flutter memiliki berbagai pendekatan untuk _state management_, masing-masing dengan kelebihan dan kekurangannya. Memahami adanya opsi-opsi ini akan membantu pembelajar membuat keputusan yang tepat di masa depan saat memilih alat yang sesuai untuk proyek mereka. Ini juga menekankan bahwa tidak ada "satu ukuran cocok untuk semua" dalam _state management_.

**Konsep Kunci & Filosofi Mendalam (Umum untuk Bagian Ini):**

- **Diversity in State Management:** Menunjukkan kekayaan dan keanekaragaman solusi yang tersedia di Flutter.

  - **Filosofi:** Memberikan fleksibilitas kepada pengembang untuk memilih alat yang paling sesuai dengan preferensi tim, skala proyek, dan kompleksitas _state_.

- **Trade-offs:** Setiap pendekatan memiliki _trade-off_ antara kemudahan penggunaan, performa, _boilerplate_, skalabilitas, dan _testability_.

  - **Filosofi:** Mendorong pemikiran kritis dalam pemilihan teknologi, bukan sekadar mengikuti tren.

- **Community Support:** Pentingnya komunitas aktif dan dokumentasi yang baik dalam pemilihan _package_.

  - **Filosofi:** Memastikan keberlanjutan dan dukungan saat menghadapi masalah.

**Visualisasi Diagram Alur/Struktur:**

- Diagram sederhana berbentuk piramida (atau spektrum) yang menempatkan berbagai solusi _state management_ berdasarkan kompleksitas/skalabilitas (misalnya, `setState` di bawah, lalu `Provider`, lalu BLoC/Cubit, Riverpod, GetX di berbagai posisi relatif).

**Hubungan dengan Modul Lain:**
Bagian ini melengkapi pembahasan _state management_ di Fase 4. Meskipun tidak mendalam, pengetahuan ini akan menjadi latar belakang berharga saat pembelajar melihat proyek lain atau mencari solusi untuk masalah spesifik di masa depan. Ini juga menegaskan bahwa _Provider_ dan BLoC/Cubit adalah pilihan yang sangat solid dan umum di industri.

---

#### 4.4.1 GetX (Brief Mention)

Sub-bagian ini akan memperkenalkan GetX, sebuah kerangka kerja mikro yang populer di Flutter yang menawarkan solusi _state management_ (dan banyak fitur lainnya) dengan sintaks yang sangat ringkas.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bahwa GetX adalah paket multifungsi yang menyediakan _state management_, _dependency injection_, _routing_, dan banyak lagi dalam satu _package_. Ia dikenal karena minimnya _boilerplate_ dan performa yang tinggi. Metode _state management_-nya seringkali terasa sangat "langsung" dan mudah untuk dipelajari di awal.

**Konsep Kunci & Filosofi Mendalam:**

- **All-in-one Solution:** GetX bukan hanya _state management_, tetapi juga menyediakan solusi untuk navigasi, manajemen dependensi, internasionalisasi, dan banyak lagi.

  - **Filosofi:** Meminimalkan kebutuhan untuk mengimpor banyak _package_ terpisah untuk berbagai fungsionalitas, menawarkan ekosistem yang terintegrasi.

- **Reactive Programming (Simplified):** GetX memperkenalkan konsep `Obx` (Observable Builder) dan `GetXController` yang memungkinkan _state_ reaktif dengan sedikit kode.

  - **Filosofi:** Menyederhanakan pola reaktif untuk pengembang, menghilangkan _boilerplate_ yang sering ditemukan di pendekatan reaktif lainnya.

- **No BuildContext for Many Operations:** Salah satu ciri khas GetX adalah kemampuannya untuk melakukan operasi seperti navigasi atau menampilkan `SnackBar` tanpa memerlukan `BuildContext`.

  - **Filosofi:** Menyederhanakan penulisan kode dengan mengurangi ketergantungan pada `BuildContext`, yang dapat menjadi tantangan bagi pemula.

**Terminologi Esensial (GetX):**

- **`GetXController`:** Kelas dasar untuk _controller_ yang memegang _state_ dan logika bisnis.
- **`Obx`:** _Widget_ yang secara reaktif mendengarkan perubahan pada variabel _observable_ (misalnya, `RxInt`, `RxString`, `RxList`) di dalam `GetXController` dan membangun ulang hanya bagian UI yang terpengaruh.
- **`Get.put()`:** Digunakan untuk menempatkan instance `GetXController` (atau dependensi lain) ke dalam _memory_ dan membuatnya tersedia secara global.
- **`.obs`:** Ekstensi `.obs` yang digunakan pada variabel untuk menjadikannya _observable_ (misalnya, `var count = 0.obs;`).

**Sumber Referensi Lengkap:**

- [GetX package (pub.dev)](https://pub.dev/packages/get) - Halaman pub.dev GetX.
- [GetX Documentation (GitHub)](https://www.google.com/search?q=https://github.com/jonataslaw/getx/blob/master/documentation/en_US/README.md) - Dokumentasi resmi GetX.

**Tips dan Praktik Terbaik (Umum untuk Pemahaman GetX):**

- **Perdebatan di Komunitas:** Pembelajar harus menyadari bahwa GetX memiliki reputasi yang campur aduk di komunitas Flutter. Meskipun disukai karena kemudahan dan kecepatannya, ada kekhawatiran tentang pemisahan kekhawatiran, ketergantungan yang kuat pada kerangka kerja, dan kurangnya _type safety_ di beberapa area.
- **Sangat Cepat untuk Prototipe:** GetX sering direkomendasikan untuk proyek-proyek kecil atau prototipe di mana kecepatan pengembangan adalah prioritas utama.
- **Komitmen pada Ekosistem GetX:** Jika Anda memilih GetX, Anda cenderung akan menggunakan banyak fitur lain yang disediakannya (routing, dependency management, dll.), yang berarti Anda akan sangat "terikat" pada ekosistem GetX.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
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
