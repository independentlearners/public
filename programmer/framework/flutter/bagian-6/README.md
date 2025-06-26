# FASE 4: State Management Fundamentals

Dengan selesainya **Fase 3: Navigation & Routing**, kita akan melangkah ke **Fase 4: State Management Fundamentals**. Fase ini sangat krusial karena _state management_ adalah inti dari bagaimana data dan UI aplikasi Anda berinteraksi dan berubah seiring waktu.

Berikut adalah daftar isi yang diperbarui untuk kurikulum, mencakup Fase 4:

<details>
  <summary>📃 Daftar Isi</summary>

- [4.1 Understanding State in Flutter](#41-understanding-state-in-flutter)
  - [4.1.1 Local State (`setState`) vs. App State](#411-local-state-setstate-vs-app-state)
  - [4.1.2 Why State Management is Needed (Challenges)](#412-why-state-management-is-needed-challenges)
  - [4.1.3 InheritedWidget (Basic Concept)](#413-inheritedwidget-basic-concept)
- [4.2 Provider Package (Simple & Recommended)](#42-provider-package-simple-recommended)
  - [4.2.1 `Provider`, `ChangeNotifier`, `ChangeNotifierProvider`](#421-provider-changenotifier-changenotifierprovider)
  - [4.2.2 `Consumer` and `Selector`](#422-consumer-and-selector)
  - [4.2.3 MultiProvider](#423-multiprovider)
- [4.3 BLoC/Cubit (Introduction)](#43-bloccubit-introduction)
  - [4.3.1 Core Concepts of BLoC/Cubit](#431-core-concepts-of-bloccubit)
  - [4.3.2 Basic Implementation with `flutter_bloc`](#432-basic-implementation-with-flutter_bloc)
- [4.4 Other State Management Approaches (Overview)](#44-other-state-management-approaches-overview)
  - [4.4.1 GetX (Brief Mention)](#441-getx-brief-mention)
  - [4.4.2 Riverpod (Brief Mention)](#442-riverpod-brief-mention)
  - [4.4.3 MobX (Brief Mention)](#443-mobx-brief-mention)

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

- [Managing state in Flutter (Official Docs)](https://www.google.com/search?q=https://docs.flutter.dev/data/state-management/options)
- [What is state? (Official Docs)](https://www.google.com/search?q=https://docs.flutter.dev/data/state-management/declarative)
- [setState (Official Docs)](https://www.google.com/search?q=https://docs.flutter.dev/data/state-management/declarative%23setstate)

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

#

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
