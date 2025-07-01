# **[FASE 3: State Management & Data Flow][0]**

### **Struktur Daftar Isi :**

<details>
  <summary>📃 Materi</summary>

---

- **[4. State Management Architecture](#4-state-management-architecture)**
  - **[4.0. Mengapa State Management Penting? (The "Why") (Tambahan)](#40-mengapa-state-management-penting-the-why-tambahan)**
    - [4.0.1. Batasan `setState` pada Aplikasi Skala Besar](#401-batasan-setstate-pada-aplikasi-skala-besar)
    - [4.0.2. Masalah "Prop Drilling"](#402-masalah-prop-drilling)
    - [4.0.3. Prinsip Pemisahan Logika dan Tampilan (Separation of Concerns)](#403-prinsip-pemisahan-logika-dan-tampilan-separation-of-concerns)
  - **[4.1. Built-in State Management](#41-built-in-state-management)**
    - [4.1.1. `setState` dan `StatefulWidget` (Revisited)](#411-setstate-dan-statefulwidget-revisited)
    - [4.1.2. `InheritedWidget` Pattern](#412-inheritedwidget-pattern)
    - [4.1.3. `ValueNotifier` dan `ChangeNotifier`](#413-valuenotifier-dan-changenotifier)
  - **[4.2. Provider Pattern & Ecosystem](#42-provider-pattern--ecosystem)**
  - [**4.3. Advanced State Management Solutions** (BLoC, Riverpod, dll.)](#43-advanced-state-management-solutions)
- **[5. Reactive Programming & Streams](#)**
  - [5.1. Streams & Async Programming](#)

</details>

---

Mari kita mulai dengan fondasi konseptual yang saya tambahkan.

### **4. State Management Architecture**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah salah satu fase paling menentukan dalam perjalanan seorang developer Flutter. Jika Fase 2 adalah tentang membangun "tubuh" aplikasi (UI), Fase 3 adalah tentang memberikan "otak" dan "sistem saraf"-nya. _State Management_ adalah tentang bagaimana data (state) dalam aplikasi Anda disimpan, diakses, dan diperbarui secara efisien dan terprediksi. Pilihan arsitektur _state management_ akan sangat memengaruhi seberapa mudah aplikasi Anda untuk dikembangkan, diuji, dan dipelihara di masa depan.

---

#### **4.0. Mengapa State Management Penting? (The "Why") (Tambahan)**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Sebelum kita menyelami berbagai macam _tools_ dan _library_, kita harus memahami **masalah** yang coba mereka selesaikan. Bagian tambahan ini berfungsi sebagai justifikasi dan motivasi. Tujuannya adalah untuk membangun pemahaman intuitif tentang kapan `setState` sudah tidak lagi cukup dan mengapa kita perlu beralih ke pola yang lebih canggih. Ini adalah fondasi pemikiran arsitektural.

###### **4.0.1. Batasan `setState` pada Aplikasi Skala Besar**

**Konsep Kunci & Filosofi Mendalam:**
`setState` adalah alat yang sempurna untuk mengelola **state lokal (local/ephemeral state)**, yaitu state yang hanya relevan untuk satu widget atau subtree kecil di bawahnya (misalnya, status `checked` pada sebuah checkbox, atau teks yang sedang diketik di `TextField`).

Namun, pada aplikasi yang lebih besar, `setState` memiliki batasan:

1.  **Coupling (Ketergantungan Tinggi):** Logika bisnis (misalnya, apa yang terjadi saat tombol ditekan) terikat erat dengan kode UI (di dalam kelas `State`). Ini membuat logika sulit untuk diuji secara terpisah dan digunakan kembali di tempat lain.
2.  **Kesulitan Berbagi State:** `setState` tidak dirancang untuk berbagi state antar-halaman yang berbeda atau antar-widget yang tidak memiliki hubungan induk-anak secara langsung.

###### **4.0.2. Masalah "Prop Drilling"**

**Konsep Kunci & Filosofi Mendalam:**
_Prop Drilling_ (atau _Parameter Drilling_) adalah istilah untuk situasi di mana Anda harus meneruskan data dari widget tingkat tinggi ke widget tingkat rendah yang sangat dalam melalui banyak lapisan widget perantara yang sebenarnya tidak membutuhkan data tersebut.

Bayangkan Anda memiliki data _user profile_ di halaman utama (`HomeScreen`), dan sebuah widget `Avatar` di dalam `CustomAppBar` di dalam `Header` membutuhkan nama user tersebut. Alurnya akan seperti ini:
`HomeScreen` -\> `Header(user: userData)` -\> `CustomAppBar(user: userData)` -\> `Avatar(user: userData)`

Widget `Header` dan `CustomAppBar` mungkin tidak peduli tentang `userData`, tetapi mereka terpaksa menerimanya hanya untuk bisa meneruskannya ke bawah. Ini membuat kode menjadi berantakan, sulit di-refactor, dan rentan terhadap kesalahan.

**Rekomendasi Visualisasi:**
Diagram alur yang menunjukkan data `user` "menetes" ke bawah melalui beberapa widget perantara yang tidak relevan akan sangat efektif untuk mengilustrasikan "Prop Drilling".

###### **4.0.3. Prinsip Pemisahan Logika dan Tampilan (Separation of Concerns)**

**Konsep Kunci & Filosofi Mendalam:**
Ini adalah prinsip dasar rekayasa perangkat lunak. Ide utamanya adalah memisahkan kode menjadi bagian-bagian yang berbeda berdasarkan tanggung jawabnya.

- **UI Layer (Tampilan):** Bertanggung jawab hanya untuk menampilkan data dan menangkap input pengguna. Seharusnya ia "bodoh" dan tidak tahu dari mana data berasal atau bagaimana data diproses.
- **Business Logic Layer (Logika Bisnis/State):** Bertanggung jawab untuk mengelola state aplikasi, memproses data, dan berinteraksi dengan sumber eksternal (API, database).

Solusi _state management_ yang baik memfasilitasi pemisahan ini. UI hanya "mendengarkan" perubahan dari _logic layer_ dan membangun ulang dirinya sendiri saat diperlukan. Ini membuat:

- **UI lebih mudah diganti:** Anda bisa mengubah total tampilan tanpa menyentuh logika bisnis.
- **Logika lebih mudah diuji:** Anda bisa menguji logika bisnis secara terpisah tanpa perlu me-render UI sama sekali.
- **Kolaborasi tim lebih mudah:** Tim UI dan tim _backend/logic_ bisa bekerja secara paralel.

**Rekomendasi Visualisasi:**
Diagram arsitektur sederhana yang menunjukkan dua kotak: "UI Layer" dan "Business Logic/State Layer", dengan panah yang menunjukkan aliran data (State -\> UI) dan aliran event (UI -\> Logic), akan sangat membantu.

---

#### **4.1. Built-in State Management**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah "perkakas" manajemen state yang sudah disediakan langsung oleh Flutter. Mempelajarinya sangat penting karena mereka adalah blok bangunan untuk solusi yang lebih canggih, dan seringkali sudah lebih dari cukup untuk kasus-kasus sederhana.

###### **4.1.1. `setState` dan `StatefulWidget` (Revisited)**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Kita melihat kembali `setState` dari sudut pandang arsitektur. Kapan `setState` adalah pilihan yang **tepat**? Menggunakannya untuk semua hal adalah praktik yang buruk, tetapi menghindarinya sama sekali juga tidak bijaksana. Perannya adalah menetapkan `setState` sebagai alat untuk **state lokal/ephemeral**.

**Konsep Kunci & Filosofi Mendalam:**

- **Kapan Menggunakan `setState`?**
  - State yang hanya memengaruhi satu widget (misalnya, animasi internal, status _focus_ `TextField`).
  - State yang terkandung dalam satu halaman dan tidak perlu dibagikan ke halaman lain (misalnya, tab yang sedang aktif di `TabBar`).
  - State yang tidak relevan dengan sisa aplikasi.
- **Pentingnya `if (mounted)`:** Saat melakukan operasi asinkron (misalnya, panggilan API) di dalam `State`, ada kemungkinan pengguna sudah pindah ke halaman lain sebelum operasi selesai. Jika Anda memanggil `setState()` setelah itu, Flutter akan error karena mencoba memperbarui widget yang sudah tidak ada di pohon (_unmounted_). Membungkus `setState()` di dalam `if (mounted) { ... }` adalah praktik aman untuk mencegah ini.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh `State` lokal: Visibilitas sebuah `password field`.

```dart
class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  // State ini SANGAT LOKAL, hanya relevan untuk widget ini.
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscured, // Gunakan state
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            // Panggil setState untuk mengubah state lokal dan rebuild.
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ),
    );
  }
}
```

**Sumber Referensi Lengkap:**

- **Dokumentasi Resmi State Management:** [Introduction to state management - Flutter Docs](https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro)

---

###### **4.1.2. `InheritedWidget` Pattern**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah solusi bawaan pertama dari Flutter untuk mengatasi masalah _prop drilling_. `InheritedWidget` adalah widget khusus yang dapat menyebarkan data secara efisien ke semua _descendant_ (turunan) di bawahnya di dalam pohon widget. Ini adalah "nenek moyang" dari `Provider`.

**Konsep Kunci & Filosofi Mendalam:**

- **Mekanisme Kerja:** Ketika Anda menempatkan `InheritedWidget` di puncak pohon widget, setiap widget di bawahnya dapat mengakses data dari `InheritedWidget` tersebut hanya dengan menggunakan `BuildContext`-nya (misalnya, `MyInheritedWidget.of(context)`).
- **Efisiensi:** Bagian terbaiknya adalah, ketika data di `InheritedWidget` berubah, **hanya widget-widget yang "mendengarkan" data tersebut yang akan di-_rebuild_**, bukan seluruh subtree di bawahnya. Ini dikendalikan oleh metode `updateShouldNotify()`.

**Terminologi Esensial & Penjelasan Detil:**

- **`updateShouldNotify(oldWidget)`:** Metode yang harus di-override di `InheritedWidget`. Ia dipanggil setiap kali `InheritedWidget` di-rebuild. Jika Anda mengembalikan `true`, semua widget dependen akan ikut di-rebuild. Jika `false`, tidak ada yang terjadi. Ini adalah kunci optimisasi.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
// 1. Buat InheritedWidget kustom.
class FrogColor extends InheritedWidget {
  const FrogColor({
    super.key,
    required this.color,
    required super.child,
  });

  final Color color;

  // 2. Metode 'of' adalah konvensi untuk memudahkan akses dari widget anak.
  static FrogColor? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FrogColor>();
  }

  // 3. Kontrol rebuild di sini.
  @override
  bool updateShouldNotify(FrogColor oldWidget) => color != oldWidget.color;
}

// Cara Menggunakannya:
class MyPage extends StatefulWidget {
  const MyPage({super.key});
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Color _color = Colors.green;

  @override
  Widget build(BuildContext context) {
    // 4. Bungkus subtree yang membutuhkan data dengan InheritedWidget.
    return FrogColor(
      color: _color,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FrogWidget(), // Widget ini akan mendapatkan warnanya dari FrogColor
              ElevatedButton(
                child: const Text('Change Color'),
                onPressed: () => setState(() => _color = Colors.blue),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FrogWidget extends StatelessWidget {
  const FrogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. Akses data dari InheritedWidget terdekat.
    // Build method ini akan otomatis dijalankan ulang jika warna di FrogColor berubah.
    final frogColor = FrogColor.of(context)!.color;
    return Text('Hello Frog!', style: TextStyle(color: frogColor));
  }
}
```

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menggunakan `InheritedWidget` terlalu rumit dan membutuhkan banyak _boilerplate code_ (kode berulang) untuk hal-hal sederhana.
- **Solusi:** Ini memang benar. `InheritedWidget` sangat kuat tetapi tidak ramah pengguna. Inilah alasan utama mengapa `Provider` dibuat—sebagai pembungkus yang lebih sederhana di atas `InheritedWidget`.

**Sumber Referensi Lengkap:**

- **Video Resmi:** [InheritedWidget - Flutter (YouTube)](https://www.youtube.com/watch%3Fv%3Dl-YOu2_NK5c)
- **API Docs:** [InheritedWidget class - Flutter API](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html)

---

###### **4.1.3. `ValueNotifier` dan `ChangeNotifier`**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah langkah selanjutnya dalam memisahkan state dari UI. Keduanya adalah bagian dari `flutter:foundation` dan mengimplementasikan pola _Observer_ (atau _Publisher-Subscriber_). Mereka adalah kelas yang bisa "didengarkan" perubahannya.

**Konsep Kunci & Filosofi Mendalam:**

- **`ValueNotifier`:** Sangat sederhana. Ia hanya membungkus **satu nilai tunggal**. Ketika nilainya (`.value`) diubah, semua yang mendengarkan akan diberi tahu. Sangat cocok untuk state yang sangat sederhana (seperti `int`, `bool`, atau `String`).
- **`ChangeNotifier`:** Lebih kompleks dan fleksibel. Ia tidak membungkus satu nilai, tetapi merupakan sebuah kelas yang bisa Anda perluas (`extend`). Anda bisa memiliki banyak _properties_ dan _methods_ di dalamnya. Anda harus memanggil `notifyListeners()` secara manual setiap kali Anda ingin memberitahu para pendengar bahwa ada sesuatu yang berubah. Ini adalah dasar dari `Provider` dan banyak solusi lain.
- **Widget Pendengar:** Flutter menyediakan `ValueListenableBuilder` untuk mendengarkan `ValueNotifier` dan `AnimatedBuilder` (atau `ListenableBuilder`) untuk mendengarkan `ChangeNotifier`. Widget-widget ini akan secara efisien membangun ulang hanya bagian UI yang mereka bungkus, bukan seluruh halaman.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh penghitung menggunakan `ChangeNotifier`.

```dart
import 'package:flutter/material.dart';

// 1. Buat kelas yang meng-extend ChangeNotifier. Ini adalah LOGIC LAYER kita.
class CounterModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count; // Getter untuk mengakses nilai

  void increment() {
    _count++;
    notifyListeners(); // 2. Beri tahu semua pendengar bahwa state telah berubah.
  }
}


class ChangeNotifierDemo extends StatelessWidget {
  ChangeNotifierDemo({super.key});

  // 3. Buat instance dari model kita.
  // (Di aplikasi nyata, ini akan disediakan oleh Provider atau GetIt)
  final CounterModel _model = CounterModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChangeNotifier Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            // 4. Gunakan AnimatedBuilder untuk mendengarkan perubahan.
            AnimatedBuilder(
              animation: _model, // Beri tahu widget ini untuk mendengarkan _model
              builder: (context, child) {
                // 5. Builder ini akan dijalankan ulang setiap kali notifyListeners() dipanggil.
                // Ini adalah UI LAYER kita.
                return Text('${_model.count}', style: Theme.of(context).textTheme.headlineMedium);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _model.increment, // Panggil method dari model
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Hubungan dengan Modul Lain:**
Memahami `ChangeNotifier` adalah **prasyarat mutlak** untuk memahami `Provider` di bagian selanjutnya. `ChangeNotifierProvider` di dalam paket `Provider` pada dasarnya adalah cara yang lebih baik untuk menyediakan instance `ChangeNotifier` (seperti `CounterModel`) ke pohon widget.

**Sumber Referensi Lengkap:**

- **Panduan Resmi Sederhana:** [Simple state management - Flutter Docs](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple)
- **API Docs:** [ChangeNotifier class - Flutter API](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html)

---

### **4.2. Provider Pattern & Ecosystem**

**Deskripsi Konkret & Peran dalam Kurikulum:**
`Provider` adalah sebuah _library_ yang sangat populer dan pernah direkomendasikan secara resmi oleh Google sebagai titik awal untuk manajemen state. Perannya dalam kurikulum ini adalah sebagai jembatan antara state management bawaan yang agak rumit (`InheritedWidget`) dan solusi-solusi canggih yang lebih beropini (`BLoC`, `Riverpod`). `Provider` bukanlah sebuah pola _state management_ itu sendiri, melainkan sebuah _wrapper_ (pembungkus) yang canggih untuk `InheritedWidget` yang membuatnya sangat mudah untuk melakukan _Dependency Injection_ (DI) dan meneruskan state ke seluruh pohon widget.

**Konsep Kunci & Filosofi Mendalam:**

- **Dependency Injection (DI) yang Disederhanakan:** Inti dari `Provider` adalah menyediakan sebuah "dependency" (ketergantungan), seperti instance dari `CounterModel` atau `AuthService`, ke pohon widget. Setiap widget di bawah _provider_ tersebut dapat meminta (mengonsumsi) _dependency_ tersebut tanpa perlu mengenalnya secara langsung. Ini secara efektif memecahkan masalah _prop drilling_.
- **Pemisahan Tanggung Jawab:** `Provider` mendorong pemisahan yang bersih antara:
  1.  **State/Logic:** Kelas yang menyimpan data (misalnya `ChangeNotifier`).
  2.  **Providing State:** Widget `*Provider` (misalnya `ChangeNotifierProvider`) yang bertanggung jawab untuk membuat dan menyediakan state tersebut ke pohon.
  3.  **Consuming State:** Widget yang membutuhkan data tersebut, yang mengaksesnya melalui `Consumer`, `Selector`, atau `context`.
- **Lazy Loading by Default:** Secara default, `Provider` hanya akan membuat (_create_) objek state ketika objek tersebut pertama kali diminta oleh sebuah _consumer_. Ini meningkatkan efisiensi dengan tidak membuat objek yang mungkin tidak pernah digunakan.
- **Rebuild yang Terkontrol:** `Provider` memberikan beberapa cara untuk mengakses state, masing-masing dengan implikasi performa yang berbeda, memungkinkan developer untuk mengoptimalkan kapan dan bagian mana dari UI yang harus di-_rebuild_.

**Terminologi Esensial & Penjelasan Detil:**

- **`ChangeNotifierProvider`:** Varian `Provider` yang paling umum digunakan. Ia dirancang khusus untuk bekerja dengan `ChangeNotifier`. Ia akan "mendengarkan" `ChangeNotifier` tersebut dan secara otomatis memicu _rebuild_ pada _consumer_ ketika `notifyListeners()` dipanggil. Yang terpenting, ia juga secara otomatis akan memanggil `dispose()` pada `ChangeNotifier` saat provider tersebut dihapus dari pohon, mencegah _memory leak_.
- **`MultiProvider`:** Widget pembantu yang memungkinkan Anda menyediakan beberapa _provider_ berbeda di satu tempat, menjaga kebersihan pohon widget Anda.
- **Cara Mengonsumsi State:**
  - **`Consumer<T>`:** Widget yang membutuhkan _builder function_. Hanya UI di dalam _builder_ ini yang akan di-_rebuild_ saat state berubah. Ini adalah cara yang sangat efisien untuk membatasi _rebuild_.
  - **`Selector<T, S>`:** Versi `Consumer` yang lebih canggih. Ia memungkinkan Anda untuk "memilih" hanya sebagian kecil dari data state. UI hanya akan di-_rebuild_ jika nilai yang Anda pilih itu berubah, bahkan jika bagian lain dari state berubah. Sangat baik untuk optimisasi.
  - **`context.watch<T>()`:** Cara pintas untuk `Provider.of<T>(context)`. Ini akan membuat seluruh metode `build` dari widget tersebut "mendengarkan" perubahan. Gunakan ini jika seluruh widget bergantung pada state tersebut.
  - **`context.read<T>()`:** Cara pintas untuk `Provider.of<T>(context, listen: false)`. Ini hanya "membaca" nilai state saat itu juga dan **tidak** mendaftarkan widget untuk _rebuild_. Sangat cocok untuk digunakan di dalam `onPressed` atau `initState` untuk memanggil sebuah fungsi dari model.
- **`FutureProvider` & `StreamProvider`:** Varian `Provider` yang bekerja langsung dengan `Future` dan `Stream`. Mereka menangani status _loading_, _data_, dan _error_ secara otomatis, menyederhanakan penanganan data asinkron.
- **`ProxyProvider`:** `Provider` canggih yang nilainya dapat bergantung pada nilai dari _provider_ lain. Berguna untuk dependensi berantai (misalnya, `ApiService` membutuhkan `AuthToken` dari `AuthService`).

**Sintaks Dasar / Contoh Implementasi Inti:**
Kita akan mengadaptasi contoh `CounterModel` dari `ChangeNotifier` untuk digunakan dengan `Provider`.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. Logic/State Layer (Sama seperti sebelumnya)
class CounterModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

void main() {
  runApp(
    // 2. PROVIDE state di level tertinggi aplikasi.
    // Semua widget di bawah `MyApp` sekarang bisa mengakses `CounterModel`.
    ChangeNotifierProvider(
      create: (context) => CounterModel(),
      child: const MyApp(),
    ),
  );
}
// Jika ada banyak provider, gunakan MultiProvider:
/*
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterModel()),
        Provider(create: (_) => SomeOtherService()),
      ],
      child: const MyApp(),
    ),
  );
}
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CounterScreen());
  }
}


class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            // 3. CONSUME state. Ini adalah cara paling efisien.
            // Hanya widget Text ini yang akan di-rebuild saat counter berubah.
            Consumer<CounterModel>(
              builder: (context, counter, child) => Text(
                '${counter.count}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 4. READ state untuk memanggil fungsi. `listen: false` (atau context.read)
          // penting di sini agar tombol ini tidak ikut di-rebuild.
          context.read<CounterModel>().increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

**Rekomendasi Visualisasi:**
Diagram pohon widget yang menunjukkan `ChangeNotifierProvider` berada di atas `MaterialApp` atau `Scaffold`, dan kemudian dua widget anak yang berbeda di bawahnya (misalnya `CounterText` dan `SomeOtherWidget`) keduanya dapat mengakses `CounterModel` melalui `Consumer` atau `context.watch`. Ini dengan jelas mengilustrasikan DI.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menggunakan `context.watch<T>()` atau `Provider.of<T>(context)` di dalam metode `build` yang besar, menyebabkan seluruh layar di-_rebuild_ untuk perubahan kecil, yang mengakibatkan performa buruk.
- **Solusi:** **Praktek Terbaik:** Selalu coba untuk membungkus widget yang perlu di-_rebuild_ sedekat mungkin dengan `Consumer` atau `Selector`. Untuk memanggil fungsi, selalu gunakan `context.read<T>()`.
- **Kesalahan:** Mendapat `ProviderNotFoundException`.
- **Solusi:** Ini terjadi karena Anda mencoba mengakses _provider_ dari `BuildContext` yang berada di atas _provider_ itu sendiri atau di pohon yang berbeda. Pastikan `Provider` Anda ditempatkan di atas semua widget yang akan mengonsumsinya.

**Sumber Referensi Lengkap:**

- **Paket Resmi:** [provider package - pub.dev](https://pub.dev/packages/provider)
- **Dokumentasi Resmi Flutter (oleh pembuat Provider):** [provider package - flutter.dev](https://docs.flutter.dev/data-and-backend/state-mgmt/simple)
- **Video Penjelasan (Flutter Boring Show):** [Provider (The Boring Flutter Development Show)](https://www.youtube.com/watch?v=d_m5csmrf7I)

---

### **4.3. Advanced State Management Solutions**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Bagian ini adalah "program spesialisasi" dalam _state management_. Setelah memahami dasar-dasar dengan `setState`, `InheritedWidget`, dan `Provider`, di sini kita akan mempelajari solusi-solusi yang lebih "beropini" (_opinionated_). Artinya, mereka tidak hanya menyediakan alat, tetapi juga menawarkan (dan seringkali menegakkan) cara kerja atau arsitektur tertentu. Solusi-solusi ini dirancang untuk mengatasi tantangan pada aplikasi berskala besar, seperti testabilitas, skalabilitas, dan pemisahan logika yang sangat ketat.

---

#### **4.3.1. BLoC Pattern & Architecture**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**BLoC (Business Logic Component)** adalah sebuah _design pattern_ yang dipopulerkan oleh Google. Tujuannya adalah untuk memisahkan total logika bisnis dari lapisan presentasi (UI). Dalam kurikulum, BLoC merepresentasikan pendekatan yang paling formal dan terstruktur. Mempelajarinya akan memberikan Anda kemampuan untuk membangun aplikasi yang sangat mudah diuji, diprediksi, dan dikelola oleh tim besar, karena ia memberlakukan aturan komunikasi yang sangat jelas antara UI dan logika.

**Konsep Kunci & Filosofi Mendalam:**

- **Filosofi Inti:** Interaksi pengguna dan hasil dari logika bisnis diperlakukan sebagai aliran kejadian asinkron (_streams of events_).

  1.  **UI hanya mengirim `Events`:** UI tidak pernah secara langsung mengubah _state_. Tugasnya hanya memberitahu BLoC tentang apa yang terjadi (misalnya, `LoginButtonPressed`, `ItemAddedToCart`). `Event` adalah objek data biasa yang merepresentasikan sebuah aksi.
  2.  **BLoC menerima `Events` dan mengeluarkan `States`:** BLoC adalah satu-satunya yang boleh menerima `Event`. Ia memproses _event_ tersebut, mungkin berinteraksi dengan _repository_ atau API, dan kemudian mengeluarkan (_emits_) satu atau lebih `State` baru.
  3.  **UI bereaksi terhadap `States`:** UI "mendengarkan" aliran (_stream_) `State` dari BLoC. Setiap kali _state_ baru dikeluarkan, UI akan membangun ulang dirinya sendiri untuk merefleksikan _state_ tersebut. `State` adalah objek data _immutable_ yang merepresentasikan kondisi UI pada satu waktu.

  <!-- end list -->

  - Alur ini **unidireksional (satu arah)**: `UI -> Event -> BLoC -> State -> UI`. Ini membuat alur data sangat mudah dilacak dan di-debug.

- **Cubit vs. BLoC: Dua Sisi dari Satu Koin**

  - Pustaka `bloc` modern menawarkan dua varian utama. Memilih yang tepat adalah kunci produktivitas.
  - **Cubit:** Versi yang lebih sederhana dan tidak terlalu formal. Daripada mengirim _events_, UI langsung memanggil **fungsi** pada Cubit (misalnya, `counterCubit.increment()`). Di dalam fungsi tersebut, Cubit akan memanggil `emit()` untuk mengeluarkan _state_ baru. Cubit sangat cocok untuk logika yang lebih sederhana dan mengurangi _boilerplate code_. Ini adalah titik awal yang sangat baik.
  - **BLoC:** Versi yang lebih ketat dan formal. UI mengirim objek `Event` ke BLoC. BLoC memiliki _event handler_ (`on<MyEvent>`) untuk setiap tipe _event_. Keuntungannya adalah **traceability**—Anda bisa mencatat setiap _event_ yang terjadi di aplikasi, yang sangat berguna untuk _debugging_ dan analisis. BLoC lebih cocok untuk logika yang kompleks, multi-langkah, atau di mana pelacakan _event_ sangat penting.

**Terminologi Esensial & Penjelasan Detil:**

- **`Event`:** Objek data yang merepresentasikan input atau aksi dari pengguna atau sistem.
- **`State`:** Objek data _immutable_ yang merepresentasikan kondisi dari satu bagian aplikasi pada satu waktu.
- **`emit`:** Fungsi di dalam BLoC/Cubit yang digunakan untuk mengeluarkan (memancarkan) `State` baru.
- **`Stream`:** Inti dari BLoC. `Events` masuk melalui satu _stream_, dan `States` keluar melalui _stream_ lain.
- **`BlocProvider`:** Sama seperti `ChangeNotifierProvider`, ini adalah widget yang membuat dan menyediakan instance BLoC/Cubit ke pohon widget.
- **`BlocBuilder`:** Widget yang mendengarkan `State` baru dari sebuah BLoC/Cubit dan membangun ulang UI di dalam `builder`-nya setiap kali ada _state_ baru.
- **`BlocListener`:** Widget yang mendengarkan `State` baru tetapi **tidak** membangun ulang UI. Ia digunakan untuk melakukan aksi satu kali sebagai reaksi terhadap perubahan _state_, seperti menampilkan `SnackBar`, `Dialog`, atau melakukan navigasi.
- **`BlocConsumer`:** Kombinasi dari `BlocBuilder` dan `BlocListener` dalam satu widget. Berguna jika Anda perlu membangun ulang UI **dan** melakukan aksi untuk perubahan _state_ yang sama.
- **`Hydrated BLoC`:** Ekstensi untuk pustaka `bloc` yang secara otomatis menyimpan (_persist_) dan memulihkan (_restore_) _state_ dari BLoC/Cubit ke penyimpanan lokal. Sangat berguna untuk menyimpan preferensi tema, sesi login, dll.

**Sintaks Dasar / Contoh Implementasi Inti (Menggunakan BLoC):**
Kita akan membuat ulang contoh penghitung, kali ini dengan arsitektur BLoC yang formal.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart'; // Untuk perbandingan objek State yang mudah

// 1. Definisikan Events
// Semua event yang bisa dikirim oleh UI.
abstract class CounterEvent extends Equatable {
  const CounterEvent();
  @override
  List<Object> get props => [];
}

class CounterIncremented extends CounterEvent {}
class CounterDecremented extends CounterEvent {}

// 2. Definisikan State
// Kondisi yang bisa dimiliki oleh UI.
class CounterState extends Equatable {
  final int count;
  const CounterState(this.count);

  @override
  List<Object> get props => [count];
}

// 3. Buat BLoC
// Tempat logika bisnis berada.
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  // Tentukan state awal
  CounterBloc() : super(const CounterState(0)) {
    // Daftarkan event handler untuk setiap event
    on<CounterIncremented>((event, emit) {
      // Keluarkan state baru dengan data yang diperbarui
      emit(CounterState(state.count + 1));
    });

    on<CounterDecremented>((event, emit) {
      if (state.count > 0) {
        emit(CounterState(state.count - 1));
      }
    });
  }
}

// 4. Implementasi di UI
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => CounterBloc(),
        child: const CounterScreen(),
      ),
    );
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLoC Demo')),
      body: Center(
        // 5. Gunakan BlocBuilder untuk membangun UI berdasarkan state
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Text(
              '${state.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            // 6. Kirim event ke BLoC saat tombol ditekan
            onPressed: () => context.read<CounterBloc>().add(CounterIncremented()),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(CounterDecremented()),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

**Rekomendasi Visualisasi:**
Diagram alur data unidireksional adalah **wajib** untuk menjelaskan BLoC. Diagram harus menunjukkan: `UI Widgets` -\> `add(Event)` -\> `BLoC` -\> `emit(State)` -\> `BlocBuilder` -\> `UI Widgets`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Memilih antara Cubit dan BLoC. Pemula sering bingung harus menggunakan yang mana.
- **Solusi:** **Praktek Terbaik:** Mulailah dengan Cubit. Ia lebih sederhana dan seringkali cukup. Jika Anda menemukan logika Anda menjadi terlalu kompleks atau Anda membutuhkan jejak audit dari setiap aksi pengguna, maka refactor ke BLoC.
- **Kesalahan:** Membuat kelas `State` yang terlalu kompleks dan monolitik.
- **Solusi:** Pecah `State` Anda menjadi kelas-kelas yang lebih spesifik (misalnya, `PostInitial`, `PostLoadInProgress`, `PostLoadSuccess`, `PostLoadFailure`). Ini membuat kode UI Anda lebih bersih karena Anda bisa bereaksi terhadap setiap state secara eksplisit, alih-alih menggunakan banyak `if/else` untuk memeriksa properti di dalam satu kelas state besar.
- **Kesalahan:** Lupa menggunakan paket `equatable` atau meng-override `==` dan `hashCode` untuk objek `State`.
- **Solusi:** Pustaka BLoC secara default hanya akan membangun ulang UI jika objek `State` yang baru tidak sama (`!=`) dengan yang lama. Tanpa `equatable`, dua instance `CounterState(1)` akan dianggap berbeda, menyebabkan _rebuild_ yang tidak perlu. `equatable` menyederhanakan perbandingan objek ini.

**Sumber Referensi Lengkap:**

- **Dokumentasi Resmi:** [BLoC Library](https://bloclibrary.dev/)
- **Contoh & Tutorial:** [BLoC Library Examples](https://bloclibrary.dev/%23/gettingstarted)
- **Paket Persistensi:** [Hydrated BLoC](https://pub.dev/packages/hydrated_bloc)
- **Paket Testing:** [bloc_test](https://pub.dev/packages/bloc_test)

---

Kita telah mengupas tuntas pola BLoC, dari filosofi hingga implementasi praktisnya. Ini adalah pendekatan yang sangat terstruktur dan dapat diandalkan untuk aplikasi besar.

Selanjutnya dalam kurikulum, kita akan membahas "generasi penerus" dari Provider, yang bertujuan untuk memecahkan beberapa masalah `Provider` sambil tetap sederhana dan fleksibel.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
