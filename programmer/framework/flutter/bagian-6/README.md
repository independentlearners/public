# FASE 4: State Management Fundamentals

Dengan selesainya **Fase 3: Navigation & Routing**, kita akan melangkah ke **Fase 4: State Management Fundamentals**. Fase ini sangat krusial karena _state management_ adalah inti dari bagaimana data dan UI aplikasi Anda berinteraksi dan berubah seiring waktu.

Berikut adalah daftar isi yang diperbarui untuk kurikulum, mencakup Fase 4:

<details>
  <summary>📃 Daftar Isi</summary>

- [FASE 4: State Management Fundamentals](#fase-4-state-management-fundamentals)
  - [Overview Fase](#overview-fase)
    - [4.1 Understanding State in Flutter](#41-understanding-state-in-flutter)
      - [4.1.1 Local State (`setState`) vs. App State](#411-local-state-setstate-vs-app-state)
      - [4.1.2 Why State Management is Needed (Challenges)](#412-why-state-management-is-needed-challenges)
      - [4.1.3 InheritedWidget (Basic Concept)](#413-inheritedwidget-basic-concept)
    - [4.2 Provider Package (Simple \& Recommended)](#42-provider-package-simple--recommended)
      - [4.2.1 `Provider`, `ChangeNotifier`, `ChangeNotifierProvider`](#421-provider-changenotifier-changenotifierprovider)

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
