> [flash][pro9]

# **[FASE 9: Testing & Quality Assurance][0]**

Fase ini akan membekali Anda dengan pengetahuan dan keterampilan untuk memastikan bahwa aplikasi Flutter yang Anda bangun stabil, berperilaku seperti yang diharapkan, dan memiliki kualitas yang tinggi.

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- **[15. Testing Architecture](#15-testing-architecture)**
  - [15.1 Unit Testing](#151-unit-testing)
    - Dart Unit Testing
    - Test framework setup
    - Arrange-Act-Assert pattern
    - Mock objects dengan Mockito
    - Test coverage analysis
    - Parameterized testing
    - Flutter Testing Guide
    - Mockito Package
    - Test Coverage
    - Advanced Unit Testing
    - Golden file testing
    - Async testing patterns
    - Stream testing
    - Timer testing
    - Fake implementations
    - Golden File Testing
    - Async Testing
  - [15.2 Widget Testing](#152-widget-testing)
    - Widget Test Framework
    - WidgetTester usage
    - Widget interaction testing
    - Gesture simulation
    - Text input testing
    - Accessibility testing
    - Widget Testing
    - Widget Test Examples
    - Integration Testing
    - End-to-end testing
    - Multi-screen workflows
    - Database integration testing
    - API integration testing
    - Performance testing
    - Integration Testing
    - Flutter Driver
  - [15.3 Test Automation & CI/CD](#153-test-automation--cicd)
    - Continuous Integration
    - GitHub Actions setup
    - GitLab CI configuration
    - Jenkins pipeline
    - Automated testing workflows
    - Code quality gates
    - CI/CD for Flutter
    - GitHub Actions Flutter
    - Code Quality Tools
    - Dart analyzer configuration
    - Linting rules setup
    - Code formatting
    - Static analysis
    - Dependency analysis
    - Analysis Options
    - Effective Dart Lints
    - Flutter Lints

</details>

---

#### **15. Testing Architecture**

- **Peran:** Arsitektur pengujian dalam pengembangan perangkat lunak adalah kerangka kerja yang terorganisir untuk merancang, mengimplementasikan, dan mengelola tes. Dalam konteks Flutter, ini melibatkan pemahaman berbagai jenis tes (Unit, Widget, Integrasi) dan bagaimana mereka saling melengkapi untuk mencapai jaminan kualitas yang komprehensif. Tujuan utamanya adalah untuk menangkap _bug_ sedini mungkin dalam siklus pengembangan, mengurangi biaya perbaikan, dan memastikan bahwa perubahan kode tidak secara tidak sengaja merusak fungsionalitas yang sudah ada (regresi).

---

##### **15.1 Unit Testing**

- **Peran:** _Unit testing_ adalah level pengujian terendah dan tercepat. Tujuannya adalah untuk menguji unit terkecil dari kode Anda secara terisolasi—yaitu, fungsi, metode, atau kelas tunggal—untuk memastikan bahwa ia berperilaku seperti yang diharapkan dalam berbagai kondisi. Ini tidak melibatkan UI, jaringan, atau interaksi _platform_ yang kompleks.

- **Dart Unit Testing:**

  - **Konsep:** Karena Flutter dibangun di atas Dart, _unit testing_ untuk logika bisnis murni atau kode non-UI ditulis dalam Dart menggunakan _package_ `test` yang disediakan oleh Dart SDK.

  - **Test Framework Setup:**

    - **Dependensi:** Tambahkan `test` ke `dev_dependencies` di `pubspec.yaml`:
      ```yaml
      dev_dependencies:
        flutter_test:
          sdk: flutter # Ini sudah menyertakan package `test` untuk unit testing Dart
      ```
    - **Struktur Folder:** Secara konvensi, berkas tes ditempatkan di folder `test/` di _root_ proyek Anda. Misalnya, jika Anda memiliki berkas `lib/my_calculator.dart`, tesnya mungkin ada di `test/my_calculator_test.dart`.

  - **Arrange-Act-Assert Pattern (AAA):**

    - Ini adalah pola umum dan direkomendasikan untuk struktur _unit test_ Anda agar mudah dibaca dan dipelihara.
    - **Arrange (Persiapan):** Siapkan data, objek, dan kondisi yang diperlukan untuk tes. Ini adalah di mana Anda menginisialisasi variabel, membuat _mock_, dll.
    - **Act (Tindakan):** Panggil metode atau fungsi yang ingin Anda uji. Ini adalah tindakan inti dari tes tersebut.
    - **Assert (Verifikasi):** Verifikasi bahwa tindakan yang dilakukan menghasilkan hasil yang diharapkan. Ini adalah di mana Anda menggunakan `expect()` untuk membandingkan hasil aktual dengan hasil yang diharapkan.

  - **Mock Objects dengan Mockito:**

    - **Peran:** Dalam _unit testing_, Anda sering perlu menguji satu "unit" kode tanpa bergantung pada dependensi eksternal yang kompleks (misalnya, _database_, API jaringan, layanan eksternal). _Mock object_ adalah objek palsu yang meniru perilaku objek nyata yang merupakan dependensi, memungkinkan Anda mengisolasi unit yang diuji.
    - **Mockito:** Adalah _package_ populer untuk membuat _mock_ dalam Dart. Ini memungkinkan Anda untuk mendeflarasikan perilaku _mock_ (misalnya, "ketika metode X dipanggil dengan argumen Y, kembalikan Z").
    - **Prasyarat:** Tambahkan `mockito` ke `dev_dependencies` di `pubspec.yaml`:
      ```yaml
      dev_dependencies:
        mockito: ^latest_version # Ganti dengan versi terbaru
        build_runner: ^latest_version # Diperlukan untuk menghasilkan mock
      ```
    - **Cara Pakai (Singkat):**
      1.  Anotasikan kelas yang ingin Anda _mock_ dengan `@GenerateMocks([YourClassToMock])`.
      2.  Jalankan `flutter pub run build_runner build` untuk menghasilkan berkas _mock_.
      3.  Gunakan _mock_ yang dihasilkan dalam tes Anda (misalnya, `when(mockObject.someMethod()).thenReturn(expectedValue)`).

  - **Test Coverage Analysis:**

    - **Peran:** Mengukur seberapa banyak kode Anda yang "dicover" atau dieksekusi oleh tes Anda. Ini adalah metrik penting untuk menilai kualitas dan kelengkapan _test suite_ Anda.
    - **Mekanisme:** Alat dapat menghasilkan laporan _coverage_ (misalnya, dalam format LCOV) yang menunjukkan baris kode mana yang diuji dan mana yang tidak. Anda dapat melihatnya di IDE atau melalui alat eksternal.
    - **Cara Pakai:** Jalankan tes dengan _flag_ _coverage_: `flutter test --coverage`. Laporan akan disimpan di `coverage/lcov.info`.

  - **Parameterized Testing:**

    - **Peran:** Menguji fungsi atau metode yang sama dengan berbagai set input dan output yang berbeda tanpa harus menulis tes terpisah untuk setiap set. Ini mengurangi duplikasi kode tes.
    - **Mekanisme:** Gunakan _package_ seperti `test_api` (yang merupakan bagian dari `test` _package_) atau _utility_ kustom untuk mengulang serangkaian kasus tes. Meskipun `test` _package_ itu sendiri tidak memiliki dukungan `ParameterizedTest` eksplisit seperti JUnit, Anda dapat mencapai fungsionalitas serupa dengan _loop_ atau fungsi bantuan.

- **Contoh Kode (Dart Unit Testing - Kalkulator Sederhana dengan Mocking):**

  Pertama, kita akan buat kelas yang akan diuji dan kelas dependensi yang akan di-_mock_.

  **1. `lib/calculator.dart` (Kelas yang akan diuji):**

  ```dart
  import 'package:flutter_app_test/my_service.dart'; // Dependensi

  class Calculator {
    final MyService _service; // Dependensi yang akan di-mock

    Calculator(this._service);

    int add(int a, int b) {
      return a + b;
    }

    int subtract(int a, int b) {
      return a - b;
    }

    // Metode yang bergantung pada MyService
    String getServiceData() {
      return 'Data from service: ${_service.fetchData()}';
    }
  }
  ```

  **2. `lib/my_service.dart` (Dependensi yang akan di-_mock_):**

  ```dart
  // Kelas ini mungkin melakukan operasi kompleks seperti panggilan jaringan
  class MyService {
    String fetchData() {
      // Anggap ini adalah panggilan jaringan yang sebenarnya
      return 'Real Data';
    }
  }
  ```

  **3. `test/calculator_test.dart` (Berkas Test):**

  ```dart
  import 'package:flutter_app_test/calculator.dart';
  import 'package:flutter_app_test/my_service.dart';
  import 'package:flutter_test/flutter_test.dart'; // Mengandung package 'test'
  import 'package:mockito/annotations.dart';
  import 'package:mockito/mockito.dart';

  // 1. Anotasikan kelas yang akan di-mock
  @GenerateMocks([MyService])
  import 'calculator_test.mocks.dart'; // Ini akan dibuat setelah menjalankan build_runner

  void main() {
    // Deklarasi mock service di luar blok group agar bisa digunakan di semua tes
    late MockMyService mockMyService;
    late Calculator calculator;

    // setUp adalah fungsi yang dijalankan sebelum setiap tes dalam group ini
    setUp(() {
      mockMyService = MockMyService(); // Inisialisasi mock
      calculator = Calculator(mockMyService); // Inisialisasi Calculator dengan mock service
    });

    group('Calculator', () { // Group tes untuk Calculator class
      test('should add two numbers correctly', () {
        // Arrange
        int a = 5;
        int b = 3;

        // Act
        int sum = calculator.add(a, b);

        // Assert
        expect(sum, 8);
      });

      test('should subtract two numbers correctly', () {
        // Arrange
        int a = 10;
        int b = 4;

        // Act
        int difference = calculator.subtract(a, b);

        // Assert
        expect(difference, 6);
      });

      test('should return data from service using mock', () {
        // Arrange
        // 2. Tentukan perilaku mock: ketika fetchData() dipanggil, kembalikan 'Mocked Data'
        when(mockMyService.fetchData()).thenReturn('Mocked Data');

        // Act
        String serviceData = calculator.getServiceData();

        // Assert
        expect(serviceData, 'Data from service: Mocked Data');
        // 3. Verifikasi bahwa fetchData() dari mock dipanggil satu kali
        verify(mockMyService.fetchData()).called(1);
        // verifyNoMoreInteractions(mockMyService); // Untuk memastikan tidak ada panggilan lain
      });

      // Contoh Parameterized Testing (secara manual dengan loop)
      test('should add numbers correctly for various inputs (Parameterized)', () {
        final testCases = [
          {'a': 1, 'b': 2, 'expected': 3},
          {'a': -1, 'b': 1, 'expected': 0},
          {'a': 0, 'b': 0, 'expected': 0},
          {'a': 100, 'b': 200, 'expected': 300},
        ];

        for (final testCase in testCases) {
          final a = testCase['a'] as int;
          final b = testCase['b'] as int;
          final expected = testCase['expected'] as int;

          // Pastikan setUp dijalankan untuk setiap iterasi jika itu mempengaruhi status global
          // Dalam kasus ini, Calculator dibuat di setUp, jadi ini sudah diisolasi

          // Act
          final result = calculator.add(a, b);

          // Assert
          expect(result, expected, reason: 'Failed for a=$a, b=$b');
        }
      });
    });
  }
  ```

  **4. Jalankan `build_runner` (setelah menambahkan `@GenerateMocks`):**

  ```bash
  flutter pub run build_runner build
  ```

  Ini akan menghasilkan berkas `calculator_test.mocks.dart` di samping `calculator_test.dart`.

  **5. Jalankan Tes:**

  ```bash
  flutter test test/calculator_test.dart
  ```

  Atau untuk semua tes:

  ```bash
  flutter test
  ```

  Untuk melihat _test coverage_:

  ```bash
  flutter test --coverage
  ```

- **Visualisasi Konseptual: Unit Testing Flow dengan Mocking**

  ```mermaid
  graph TD
      A[Test Case (Arrange)] -- Inisialisasi Objek & Mock --> B[Object Under Test (Calculator)];
      B -- Memiliki Dependensi --> C[Mock Object (MyService)];
      A -- Tentukan Perilaku Mock (when().thenReturn()) --> C;
      A -- Panggil Metode (Act) --> B;
      B -- Panggil Metode Dependensi --> C;
      C -- Kembalikan Data Mock --> B;
      B -- Kembalikan Hasil --> A[Test Case (Assert)];
      A -- Verifikasi Hasil & Interaksi Mock (expect(), verify()) --> D[Test Runner (Success/Fail)];
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana _unit test_ berinteraksi dengan objek yang diuji dan *mock object*nya. Langkah "Arrange" menyiapkan objek dan _mock_, mendefinisikan perilaku _mock_. Langkah "Act" memicu metode pada objek yang diuji. Jika objek yang diuji memanggil dependensi, ia berinteraksi dengan _mock_. Langkah "Assert" kemudian memverifikasi hasil dari objek yang diuji dan juga dapat memverifikasi bahwa _mock_ dipanggil sesuai yang diharapkan.

---

###### **Advanced Unit Testing**

- **Catatan Penting:** "Golden file testing" yang disebutkan dalam kurikulum di sini, secara teknis, lebih cocok dikategorikan di bawah "Widget Testing" karena melibatkan perbandingan _render_ UI _widget_ terhadap _baseline_ gambar. Kita akan membahasnya secara detail saat membahas _Widget Testing_. Untuk konteks _Unit Testing_, fokus kita adalah pada aspek non-UI.

- **Async Testing Patterns:**

  - **Peran:** Menguji kode asinkron (misalnya, `Future`, `async`/`await`) yang umum di Flutter.
  - **Mekanisme:** Gunakan `await` di dalam tes Anda untuk menunggu `Future` selesai. Fungsi `test()` itu sendiri dapat di-_mark_ sebagai `async`.
  - **Contoh:**
    ```dart
    test('future completes with value', () async {
      // Arrange
      Future<String> fetchData() async {
        await Future.delayed(Duration(milliseconds: 100));
        return 'Data';
      }
      // Act
      final result = await fetchData();
      // Assert
      expect(result, 'Data');
    });
    ```

- **Stream Testing:**

  - **Peran:** Menguji kode yang melibatkan `Stream` (misalnya, dari BLoC, _Provider_, atau _Event Channels_).
  - **Mekanisme:** Gunakan `expectLater()` dengan _matcher_ `emitsInOrder()`, `emitsError()`, `emitsDone()`, atau `emitsAnyOf()` dari `test` _package_ untuk memverifikasi urutan atau jenis peristiwa yang dipancarkan oleh _stream_. Anda juga dapat menggunakan `StreamMatcher` yang lebih kaya atau _package_ `bloc_test` jika Anda menggunakan BLoC.
  - **Contoh:**

    ```dart
    import 'package:flutter_test/flutter_test.dart';

    Stream<int> countStream(int max) async* {
      for (int i = 0; i < max; i++) {
        await Future.delayed(Duration(milliseconds: 10));
        yield i;
      }
    }

    test('stream emits a sequence of numbers', () {
      expectLater(
        countStream(3),
        emitsInOrder([0, 1, 2, emitsDone]), // Memastikan urutan event dan stream selesai
      );
    });
    ```

- **Timer Testing:**

  - **Peran:** Menguji kode yang melibatkan `Timer` atau penundaan waktu.
  - **Mekanisme:** Gunakan `TestWidgetsFlutterBinding.ensureInitialized().scheduleFrameCallback` atau `TestWidgetsFlutterBinding.instance.addPostFrameCallback` untuk kontrol waktu di dalam tes. Namun, untuk _unit testing_ Dart murni, Anda mungkin perlu mengabstraksi `Timer` di balik _interface_ yang dapat di-_mock_ atau menggunakan `FakeAsync` dari _package_ `fake_async`.
  - **`fake_async` (lebih disarankan untuk unit test waktu):**

    ```dart
    import 'package:fake_async/fake_async.dart';
    import 'package:flutter_test/flutter_test.dart';
    import 'dart:async';

    test('timer completes after duration', () {
      fakeAsync((async) {
        bool timerCompleted = false;
        Timer(const Duration(seconds: 5), () {
          timerCompleted = true;
        });

        expect(timerCompleted, isFalse); // Belum selesai

        async.elapse(const Duration(seconds: 4));
        expect(timerCompleted, isFalse); // Masih belum selesai

        async.elapse(const Duration(seconds: 1));
        expect(timerCompleted, isTrue); // Sekarang selesai
      });
    });
    ```

- **Fake Implementations:**

  - **Peran:** Alternatif untuk _mocking_ ketika Anda membutuhkan implementasi sederhana dari sebuah _interface_ atau kelas abstrak yang tidak perlu perilaku yang kompleks, atau ketika _mocking_ terlalu berat. _Fake_ adalah implementasi minimal yang memenuhi kontrak.
  - **Mekanisme:** Buat kelas baru yang mengimplementasikan _interface_ atau mewarisi kelas abstrak yang ingin Anda "palsukan", dan berikan implementasi yang paling sederhana untuk tujuan tes Anda.

- **Sumber Daya Tambahan:**

  - [Flutter Testing Guide](https://docs.flutter.dev/data-and-backend/testing/unit-tests) (Dokumentasi resmi Flutter tentang _Unit Testing_)
  - [Mockito Package](https://pub.dev/packages/mockito) (Dokumentasi _package_ Mockito)
  - [Test Coverage](https://docs.flutter.dev/data-and-backend/testing/tools%23code-coverage) (Cara menghasilkan laporan _coverage_ di Flutter)
  - [Async Testing](https://flutter.dev/docs/testing/debugging%23testing-futures-and-streams) (Bagian dari panduan _debugging_ dan _testing_ Flutter)

---

Dengan ini, kita telah menyelesaikan **15.1 Unit Testing** dan aspek-aspek lanjutan dari pengujian unit Dart. Anda sekarang memahami bagaimana menguji logika bisnis Anda secara terisolasi dan bagaimana menangani skenario asinkron dan penggunaan _mock_.

Selanjutnya, kita akan masuk ke **15.2 Widget Testing**, di mana kita akan belajar bagaimana menguji komponen UI Flutter Anda.

##### **15.2 Widget Testing**

- **Peran:** _Widget testing_ (juga dikenal sebagai _component testing_) adalah level pengujian di Flutter yang fokus pada pengujian satu _widget_ atau sekelompok kecil _widget_ secara terisolasi, memastikan bahwa UI mereka dirender dengan benar, berinteraksi sebagaimana mestinya, dan menampilkan data dengan tepat. Ini adalah titik tengah antara _unit testing_ (yang menguji logika non-UI) dan _integration testing_ (yang menguji alur aplikasi secara keseluruhan).

- **Perbedaan Utama dengan Unit Testing:**

  - _Unit testing_ berjalan di lingkungan Dart murni (Dart VM) dan tidak memerlukan mesin Flutter rendering.
  - _Widget testing_ memerlukan mesin Flutter _rendering_ yang terbatas, yang memungkinkan _widget_ di-_inflate_ (dirender ke dalam _test environment_) dan diuji interaksinya. Meskipun demikian, ia masih sangat cepat karena tidak memerlukan perangkat fisik atau _emulator_.

---

###### **Widget Test Framework**

- **Mekanisme:** Flutter menyediakan _framework_ pengujian _widget_ yang kaya sebagai bagian dari _package_ `flutter_test`.

- **WidgetTester Usage:**

  - **Peran:** `WidgetTester` adalah utilitas utama dalam _widget testing_. Ini memungkinkan Anda untuk berinteraksi dengan _widget_ dalam lingkungan pengujian, seperti:

    - `pumpWidget(widget)`: Merender _widget_ ke dalam lingkungan pengujian.
    - `pump()`: Memicu _frame_ ulang (rendering ulang) _widget_ (misalnya, setelah `setState`).
    - `tap(finder)`: Mensimulasikan ketukan pada _widget_ yang ditemukan oleh `finder`.
    - `enterText(finder, text)`: Mensimulasikan input teks ke dalam _widget_ `TextField`.
    - `drag(finder, offset)`: Mensimulasikan seretan pada _widget_.
    - `widget<T>(finder)`: Mengembalikan _instance_ _widget_ dari jenis `T` yang ditemukan.
    - `find` _utility_: Digunakan untuk menemukan _widget_ dalam _tree_ _widget_ (misalnya, `find.text('Hello')`, `find.byIcon(Icons.add)`, `find.byType(MyWidget)`).

  - **Finder:** Objek yang digunakan untuk mencari _widget_ dalam _tree_ _widget_ yang diuji. _Finder_ dapat mencari berdasarkan teks, jenis _widget_, kunci (_key_), ikon, dll.

- **Widget Interaction Testing:**

  - **Mekanisme:** Setelah merender _widget_, Anda dapat mensimulasikan interaksi pengguna dan kemudian memverifikasi bahwa _widget_ merespons dengan benar.
  - **Contoh:** Ketuk tombol dan periksa apakah teks diubah, atau apakah navigasi terjadi.

- **Gesture Simulation:**

  - **Mekanisme:** `WidgetTester` menyediakan metode untuk mensimulasikan berbagai gerakan sentuh (ketuk, seret, tekan lama) untuk menguji respons _gesture detector_ atau _widget_ interaktif lainnya.

- **Text Input Testing:**

  - **Mekanisme:** Mensimulasikan input teks ke dalam _widget_ seperti `TextField` atau `TextFormField` dan memverifikasi bahwa nilai _controller_ diperbarui dengan benar dan _widget_ merefleksikan perubahan.

- **Accessibility Testing:**

  - **Peran:** Memastikan bahwa _widget_ Anda dapat diakses dan digunakan oleh orang dengan disabilitas. Flutter memiliki dukungan bawaan untuk aksesibilitas dan _widget testing_ dapat membantu memverifikasi ini.
  - **Mekanisme:** `flutter_test` menyediakan `expect(find, matchesGoldenFile)` dengan _golden files_ yang dapat menyertakan pohon aksesibilitas. Juga, Anda dapat menggunakan _package_ seperti `flutter_accessibility_analyzer` atau alat pihak ketiga.

- **Golden File Testing:**

  - **Peran:** Secara visual memverifikasi tampilan _widget_ dengan membandingkan _snapshot rendering_ _widget_ saat ini (gambar) dengan _snapshot baseline_ yang "emas" (sudah disetujui). Jika ada perbedaan piksel-demi-piksel, tes akan gagal. Ini sangat kuat untuk mencegah regresi visual.
  - **Mekanisme:**
    1.  Render _widget_ dengan `tester.pumpWidget()`.
    2.  Panggil `await expectLater(find.byType(MyWidget), matchesGoldenFile('my_widget.png'))`.
    3.  Jalankan tes untuk pertama kalinya untuk "merekam" _golden file_ (`flutter test --update-goldens`).
    4.  Pada eksekusi berikutnya, tes akan membandingkan _rendering_ baru dengan _golden file_ yang disimpan.

- **Contoh Kode (Widget Testing):**

  Misalkan kita memiliki _widget_ `CounterApp` sederhana:

  **1. `lib/counter_app.dart` (Widget yang akan diuji):**

  ```dart
  import 'package:flutter/material.dart';

  class CounterApp extends StatefulWidget {
    const CounterApp({super.key});

    @override
    State<CounterApp> createState() => _CounterAppState();
  }

  class _CounterAppState extends State<CounterApp> {
    int _counter = 0;

    void _incrementCounter() {
      setState(() {
        _counter++;
      });
    }

    void _decrementCounter() {
      setState(() {
        _counter--;
      });
    }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Counter App')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  key: const Key('counterText'), // Memberikan Key untuk memudahkan pencarian
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                key: const Key('incrementButton'),
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                key: const Key('decrementButton'),
                onPressed: _decrementCounter,
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

  **2. `test/counter_app_test.dart` (Berkas Test Widget):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_app_test/counter_app.dart'; // Import widget yang akan diuji
  import 'package:flutter_test/flutter_test.dart';

  void main() {
    group('CounterApp Widget', () {
      testWidgets('Counter increments and decrements correctly', (WidgetTester tester) async {
        // Arrange: Render the widget
        await tester.pumpWidget(const CounterApp());

        // Assert initial state: Verify that the counter starts at 0.
        expect(find.text('0'), findsOneWidget);
        expect(find.text('1'), findsNothing); // Ensure 1 is not present

        // Act: Tap the '+' button
        await tester.tap(find.byKey(const Key('incrementButton')));
        // Rebuild the widget tree to reflect the state change
        await tester.pump();

        // Assert after increment: Verify that the counter has incremented to 1.
        expect(find.text('0'), findsNothing); // Ensure 0 is no longer present
        expect(find.text('1'), findsOneWidget);

        // Act: Tap the '-' button
        await tester.tap(find.byKey(const Key('decrementButton')));
        // Rebuild the widget tree
        await tester.pump();

        // Assert after decrement: Verify that the counter has decremented back to 0.
        expect(find.text('1'), findsNothing);
        expect(find.text('0'), findsOneWidget);
      });

      testWidgets('Golden file test for initial state', (WidgetTester tester) async {
        // Arrange: Render the widget
        await tester.pumpWidget(const CounterApp());

        // Act & Assert: Compare the rendered widget with the golden file
        // The first time you run this, it will create the golden file.
        // Subsequent runs will compare against it.
        // Command: flutter test --update-goldens (to create/update)
        // Command: flutter test (to run comparison)
        await expectLater(
          find.byType(CounterApp),
          matchesGoldenFile('goldens/counter_app_initial_state.png'),
        );
      });

      testWidgets('Text input simulation in a TextField', (WidgetTester tester) async {
        // Arrange: Render a simple widget with a TextField
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextField(
                key: const Key('myTextField'),
                decoration: const InputDecoration(labelText: 'Enter text'),
              ),
            ),
          ),
        );

        // Act: Enter text into the TextField
        await tester.enterText(find.byKey(const Key('myTextField')), 'Hello Widget Test!');
        await tester.pump(); // Pump to allow text change to settle

        // Assert: Verify the text in the TextField
        expect(find.text('Hello Widget Test!'), findsOneWidget);
      });
    });
  }
  ```

  **3. Jalankan Tes:**

  ```bash
  flutter test test/counter_app_test.dart
  ```

  Untuk membuat/memperbarui _golden file_ (hanya jika ada perubahan yang disengaja pada UI):

  ```bash
  flutter test --update-goldens
  ```

  _Golden files_ akan disimpan di direktori `test/goldens/` (atau lokasi lain yang Anda tentukan).

- **Visualisasi Konseptual: Widget Testing Environment**

  ```mermaid
  graph TD
      A[Flutter App (Your Widget)] -- Diberikan ke --> B[WidgetTester (Test Environment)];
      B -- Mensimulasikan --> C[Flutter Rendering Engine (Dummy)];
      C -- Merender --> D[Virtual Bitmap (Gambar/Tree Widget)];
      B -- Mencari Widget (find.text, find.byType, etc.) --> D;
      B -- Berinteraksi dengan Widget (tap, enterText, drag) --> B;
      B -- Memverifikasi State (expect()) --> E[Test Runner (Success/Fail)];
      B -- (Opsional) Membandingkan Golden File --> F[Golden File Storage];
  ```

  **Penjelasan Visual:**
  Diagram ini menggambarkan lingkungan _widget testing_. _Widget_ Anda diberikan kepada `WidgetTester`, yang merendernya menggunakan _Flutter Rendering Engine_ palsu ke dalam _virtual bitmap_. `WidgetTester` kemudian dapat mencari _widget_ dalam _bitmap_ ini, mensimulasikan interaksi pengguna, dan memverifikasi keadaan _widget_ melalui `expect()`. Untuk _golden file testing_, _rendering_ dibandingkan dengan gambar yang tersimpan.

- **Sumber Daya Tambahan:**

  - [Widget Testing](https://docs.flutter.dev/data-and-backend/testing/widget-tests) (Dokumentasi resmi Flutter tentang _Widget Testing_)
  - [Widget Test Examples](https://docs.flutter.dev/cookbook/testing/widget/tap-drag) (Contoh-contoh spesifik dari dokumentasi Flutter)

---

###### **Integration Testing**

- **Peran:** _Integration testing_ adalah level pengujian yang lebih tinggi yang memverifikasi bagaimana beberapa modul atau layanan bekerja sama sebagai satu kesatuan. Dalam konteks Flutter, ini berarti menguji alur pengguna yang melibatkan banyak layar, interaksi dengan _database_ atau API, dan seluruh sistem dari perspektif pengguna. Tes ini berjalan pada perangkat sungguhan atau _emulator_/_simulator_.

- **End-to-End Testing (E2E):**

  - **Peran:** Menguji seluruh alur aplikasi dari awal hingga akhir, mensimulasikan pengalaman pengguna secara penuh. Ini adalah bentuk _integration testing_ yang paling luas.
  - **Mekanisme:** Melibatkan peluncuran aplikasi pada perangkat, navigasi melalui berbagai layar, interaksi dengan elemen UI, dan memverifikasi bahwa hasil akhir sesuai dengan harapan.

- **Multi-Screen Workflows:**

  - **Peran:** Memastikan bahwa transisi antar layar, operasional navigasi, dan _passing_ data antar _route_ berfungsi dengan benar.
  - **Mekanisme:** Tes akan menavigasi dari satu layar ke layar lain, mengisi formulir, menekan tombol, dan memverifikasi keberadaan elemen pada layar berikutnya.

- **Database Integration Testing:**

  - **Peran:** Menguji interaksi aplikasi dengan _database_ lokal (misalnya, SQLite dengan `sqflite`, Hive, Moor/Drift) atau _cache_ data.
  - **Mekanisme:** Tes akan menulis data ke _database_, membaca kembali, memperbarui, dan menghapus, kemudian memverifikasi konsistensi data.

- **API Integration Testing:**

  - **Peran:** Menguji bagaimana aplikasi berinteraksi dengan API _backend_ eksternal. Ini sering melibatkan permintaan HTTP dan penanganan respons.
  - **Mekanisme:** Tes akan membuat panggilan API, memverifikasi status respons, dan memeriksa struktur serta konten data yang diterima. Untuk ini, Anda mungkin perlu lingkungan _backend_ khusus tes atau menggunakan _mock server_ (seperti `package:mocktail` atau `http_mock_adapter` untuk `Dio`).

- **Performance Testing:**

  - **Peran:** Mengevaluasi kinerja aplikasi dalam skenario dunia nyata, mengidentifikasi _bottleneck_ kinerja, _frame drops_, atau konsumsi memori yang berlebihan.
  - **Mekanisme:** Menggunakan alat seperti `flutter_driver` (atau `integration_test` yang lebih baru) untuk mengukur waktu _rendering_, FPS, atau konsumsi memori selama alur pengguna.

- **Flutter Driver:**

  - **Peran (Sejarah):** Dulu adalah alat utama untuk _integration testing_ dan E2E testing di Flutter. Ini memungkinkan Anda untuk menulis tes yang berjalan di perangkat fisik atau _emulator_/_simulator_ dan berinteraksi dengan aplikasi secara nyata.
  - **Status Saat Ini:** `flutter_driver` masih berfungsi, tetapi **`integration_test`** adalah penerus yang direkomendasikan dan lebih modern, yang terintegrasi lebih baik dengan _tooling_ pengujian _native_ (seperti Android Test Orchestrator, XCUITest).

- **Integration_test (Penerus yang Direkomendasikan):**

  - **Peran:** _Package_ `integration_test` memungkinkan Anda menulis tes yang menggunakan _framework_ _widget testing_ yang familiar, tetapi menjalankannya dalam mode _integration_ di perangkat nyata. Ini menyederhanakan proses pengujian E2E dan _integration_.
  - **Mekanisme:**
    1.  Tambahkan `integration_test` ke `dev_dependencies` di `pubspec.yaml`.
    2.  Buat berkas tes di `integration_test/` (misalnya, `integration_test/app_test.dart`).
    3.  Di dalam tes, gunakan `WidgetTester` sama seperti di _widget test_, tetapi tes akan berjalan di perangkat sungguhan.
    4.  Jalankan tes dengan `flutter test integration_test/app_test.dart`.

- **Contoh Kode (Integration Testing dengan `integration_test`):**

  Asumsikan kita masih memiliki `CounterApp` dari contoh _widget testing_ sebelumnya.

  **1. Tambahkan `integration_test` ke `dev_dependencies` di `pubspec.yaml`:**

  ```yaml
  dev_dependencies:
    integration_test:
      sdk: flutter
    flutter_test:
      sdk: flutter
  ```

  **2. `integration_test/app_test.dart` (Berkas Test Integrasi):**

  ```dart
  import 'package:flutter_app_test/counter_app.dart';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:integration_test/integration_test.dart';
  import 'package:flutter/material.dart'; // Penting untuk runApp()

  void main() {
    // Inisialisasi binding integration test
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    group('End-to-End Test for CounterApp', () {
      testWidgets('Verify counter increments and decrements across full app lifecycle', (WidgetTester tester) async {
        // Arrange: Start the entire application
        // runApp() diperlukan untuk integration test karena kita menguji seluruh aplikasi
        runApp(const CounterApp());
        // Pump the initial frame to render the app
        await tester.pumpAndSettle(); // pumpAndSettle waits for all animations/timers to complete

        // Assert initial state: Counter should be 0
        expect(find.text('0'), findsOneWidget);

        // Act: Tap the increment button
        await tester.tap(find.byKey(const Key('incrementButton')));
        // Pump to reflect the state change.
        // pumpAndSettle is often preferred in integration tests to ensure
        // all asynchronous operations and animations have completed.
        await tester.pumpAndSettle();

        // Assert: Counter should be 1
        expect(find.text('1'), findsOneWidget);

        // Act: Tap the increment button again
        await tester.tap(find.byKey(const Key('incrementButton')));
        await tester.pumpAndSettle();

        // Assert: Counter should be 2
        expect(find.text('2'), findsOneWidget);

        // Act: Tap the decrement button
        await tester.tap(find.byKey(const Key('decrementButton')));
        await tester.pumpAndSettle();

        // Assert: Counter should be 1 again
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsNothing); // Ensure 2 is no longer present
      });

      // Contoh simulasi input teks dalam alur integrasi
      testWidgets('Verify text input and display in a simple flow', (WidgetTester tester) async {
        // Buat aplikasi dummy yang berisi TextField dan Text
        runApp(MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Text Input Flow')),
            body: Column(
              children: [
                const TextField(
                  key: Key('inputField'),
                  decoration: InputDecoration(labelText: 'Type here'),
                ),
                Builder(
                  builder: (context) {
                    // Gunakan Builder untuk mendapatkan Context yang tepat untuk TextField
                    return ElevatedButton(
                      key: const Key('submitButton'),
                      onPressed: () {
                        // Tidak ada aksi sebenarnya, hanya untuk demonstrasi interaksi
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Text Submitted!')),
                        );
                      },
                      child: const Text('Submit'),
                    );
                  },
                ),
                const Text(
                  'Displayed Text:',
                  key: Key('displayedTextLabel'),
                ),
                // Kita tidak memiliki Text yang menampilkan input secara langsung di sini,
                // tapi kita bisa menguji interaksi TextField.
              ],
            ),
          ),
        ));

        await tester.pumpAndSettle();

        // Enter text
        await tester.enterText(find.byKey(const Key('inputField')), 'My Test Input');
        await tester.pumpAndSettle();

        // Verify the text is present in the input field
        expect(find.text('My Test Input'), findsOneWidget);

        // Tap the submit button
        await tester.tap(find.byKey(const Key('submitButton')));
        await tester.pumpAndSettle(); // Wait for SnackBar to appear

        // Verify SnackBar appears
        expect(find.text('Text Submitted!'), findsOneWidget);
      });
    });
  }
  ```

  **3. Jalankan Tes Integrasi (Memerlukan perangkat fisik atau _emulator_):**

  ```bash
  flutter test integration_test/app_test.dart
  ```

  Atau untuk menjalankan semua tes integrasi:

  ```bash
  flutter test integration_test/
  ```

- **Visualisasi Konseptual: Integration Testing Flow**

  ```mermaid
  graph TD
      A[Test Script (integration_test)] -- 1. Launches & Controls --> B[Real Flutter App (on Device/Emulator)];
      B -- 2. Interacts with UI --> C[User Interface (Widgets)];
      C -- 3. Triggers Business Logic --> D[Business Logic Layer];
      D -- 4. Interacts with Data Sources --> E[Backend API / Local DB];
      E -- 5. Returns Data --> D;
      D -- 6. Updates UI --> C;
      C -- 7. UI State Observed by Test --> A;
      A -- 8. Verifies End Result (expect()) --> F[Test Runner (Success/Fail)];
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bahwa _integration test_ meluncurkan aplikasi Flutter yang sebenarnya pada perangkat atau _emulator_. _Script_ tes berinteraksi dengan UI, yang memicu logika bisnis dan interaksi dengan sumber data. Tes kemudian mengamati perubahan UI atau status akhir sistem untuk memverifikasi fungsionalitas keseluruhan. Ini mensimulasikan alur pengguna yang lebih besar.

- **Sumber Daya Tambahan:**

  - [Integration Testing](https://docs.flutter.dev/data-and-backend/testing/integration-tests) (Dokumentasi resmi Flutter tentang _Integration Testing_)
  - [Flutter Driver](https://docs.flutter.dev/data-and-backend/testing/integration-tests%23flutter-driver) (Informasi tentang _Flutter Driver_ dalam konteks _Integration Testing_)

---

Dengan ini, kita telah menyelesaikan **15.2 Widget Testing** yang mencakup pengujian _widget_ secara terisolasi dan juga _integration testing_ yang menguji alur aplikasi secara keseluruhan.

Selanjutnya, kita akan masuk ke bagian terakhir dari Fase 9: **15.3 Test Automation & CI/CD**, di mana kita akan membahas bagaimana mengotomatiskan proses pengujian dan mengintegrasikannya ke dalam alur kerja pengembangan berkelanjutan.

Tentu, mari kita lanjutkan ke bagian terakhir dari **Fase 9: Testing & Quality Assurance**: **15.3 Test Automation & CI/CD**. Bagian ini akan membahas bagaimana kita dapat mengotomatiskan proses pengujian dan mengintegrasikannya ke dalam alur kerja pengembangan berkelanjutan (Continuous Integration/Continuous Delivery).

---

##### **15.3 Test Automation & CI/CD**

- **Peran:** Mengotomatiskan pengujian dan mengintegrasikannya ke dalam alur _Continuous Integration/Continuous Delivery_ (CI/CD) adalah praktik terbaik dalam pengembangan perangkat lunak modern. Hal ini memastikan bahwa kode baru diuji secara otomatis setiap kali ada perubahan, sehingga mendeteksi _bug_ lebih awal, mengurangi risiko regresi, dan mempercepat siklus rilis.

---

###### **Continuous Integration (CI)**

- **Peran:** _Continuous Integration_ adalah praktik pengembangan perangkat lunak di mana pengembang mengintegrasikan perubahan kode mereka ke repositori bersama beberapa kali sehari. Setiap integrasi diverifikasi oleh _build_ otomatis dan tes otomatis untuk mendeteksi kesalahan integrasi sesegera mungkin.

- **Mekanisme Umum CI/CD:**

  1.  **Pengembang Melakukan _Commit_ Kode:** Pengembang menulis kode baru dan melakukan _commit_ ke repositori kontrol versi (misalnya, Git).
  2.  **Server CI Mendeteksi Perubahan:** Sistem CI (misalnya, GitHub Actions, GitLab CI, Jenkins) mendeteksi _commit_ baru.
  3.  **_Build_ Otomatis:** Server CI menarik kode, menginstal dependensi, dan melakukan _build_ aplikasi.
  4.  **Tes Otomatis:** Setelah _build_ berhasil, semua tes (unit, _widget_, integrasi) dijalankan secara otomatis.
  5.  **Laporan dan _Feedback_:** Hasil tes dan status _build_ dilaporkan kembali ke pengembang (misalnya, melalui email, notifikasi di Slack, atau langsung di _platform_ CI).
  6.  **Gerbang Kualitas (_Quality Gates_):** Jika semua tes lulus dan metrik kualitas lainnya (misalnya, _code coverage_, _linting_) terpenuhi, kode dianggap "lulus" gerbang kualitas dan siap untuk integrasi lebih lanjut atau _deployment_.

- **GitHub Actions Setup:**

  - **Peran:** GitHub Actions adalah _platform_ CI/CD bawaan di GitHub yang memungkinkan Anda mengotomatiskan alur kerja pengembangan perangkat lunak.
  - **Mekanisme:** Anda mendefinisikan _workflow_ dalam berkas YAML (`.github/workflows/main.yaml`) yang menentukan langkah-langkah yang harus dijalankan saat peristiwa tertentu terjadi (misalnya, _push_ ke _branch_ `main`, _pull request_ dibuka).
  - **Contoh Langkah untuk Flutter:** Mengatur lingkungan Flutter, mengambil dependensi (`flutter pub get`), menjalankan tes (`flutter test`), dan mungkin membangun APK/IPA.

- **GitLab CI Configuration:**

  - **Peran:** Mirip dengan GitHub Actions, GitLab CI adalah bagian integral dari GitLab untuk CI/CD.
  - **Mekanisme:** _Workflow_ didefinisikan dalam berkas `.gitlab-ci.yml` di _root_ repositori. Ini menggunakan konsep _jobs_, _stages_, dan _runners_.

- **Jenkins Pipeline:**

  - **Peran:** Jenkins adalah server otomasi _open-source_ yang sangat fleksibel dan dapat diperluas untuk CI/CD. Ini sering digunakan di lingkungan _on-premise_ atau yang membutuhkan kontrol kustomisasi tinggi.
  - **Mekanisme:** _Pipeline_ didefinisikan dalam Jenkinsfile (berkas Groovy DSL) yang menjelaskan serangkaian tahap (misalnya, _Build_, _Test_, _Deploy_) dan langkah-langkah di dalamnya.

- **Automated Testing Workflows:**

  - **Peran:** Konfigurasi CI/CD dirancang untuk secara otomatis menjalankan semua atau subset dari tes Anda setiap kali kode diubah.
  - **Praktik Terbaik:**
    - Jalankan _unit test_ terlebih dahulu karena paling cepat.
    - Jalankan _widget test_ berikutnya.
    - Jalankan _integration test_ terakhir karena paling lambat dan membutuhkan lingkungan yang lebih lengkap.

- **Code Quality Gates:**

  - **Peran:** Aturan atau kondisi yang harus dipenuhi oleh kode sebelum diizinkan untuk maju ke tahap berikutnya dalam _pipeline_ CI/CD. Ini memastikan bahwa hanya kode berkualitas tinggi yang diintegrasikan atau di-_deploy_.
  - **Contoh:**
    - Semua tes lulus.
    - _Code coverage_ di atas ambang batas tertentu (misalnya, 80%).
    - Tidak ada kesalahan _linting_ atau _static analysis_ yang ditemukan.
    - Tidak ada dependensi yang tidak aman.

- **Contoh Kode (GitHub Actions untuk Flutter CI):**

  Buat berkas `.github/workflows/flutter.yaml` di _root_ repositori Anda:

  ```yaml
  name: Flutter CI

  on:
    push:
      branches:
        - main # Jalankan workflow saat ada push ke branch main
    pull_request:
      branches:
        - main # Jalankan workflow saat ada pull request ke branch main

  jobs:
    build-and-test:
      runs-on: ubuntu-latest # Jalankan di virtual machine Ubuntu terbaru

      steps:
        - name: Checkout code
          uses: actions/checkout@v4 # Mengambil kode dari repositori

        - name: Setup Flutter
          uses: subosito/flutter-action@v2 # Mengatur lingkungan Flutter
          with:
            channel: "stable" # Atau 'beta', 'master'
            flutter-version: "3.x.x" # Spesifikasikan versi Flutter yang ingin Anda gunakan

        - name: Get dependencies
          run: flutter pub get # Menginstal semua dependensi proyek

        - name: Analyze code
          run: flutter analyze # Menjalankan Dart analyzer untuk menemukan potensi masalah

        - name: Run tests
          run: flutter test --no-pub # Menjalankan semua unit dan widget test tanpa pub get lagi

        # Opsi: Menghasilkan laporan code coverage
        - name: Generate coverage report
          run: |
            flutter test --coverage
            # Jika Anda menggunakan coveralls.io atau codecov.io, Anda dapat mengunggah laporan ini.
            # Misalnya: bash <(curl -s https://codecov.io/bash) -t your-codecov-token

        # Opsi: Membangun APK (hanya Android)
        - name: Build Android APK
          run: flutter build apk --release
          # Jika Anda ingin mengunggah artefak build
          # uses: actions/upload-artifact@v4
          # with:
          #   name: app-release
          #   path: build/app/outputs/flutter-apk/app-release.apk

        # Opsi: Membangun IPA (iOS) - Membutuhkan macOS runner dan sertifikat/profil provisioning
        # - name: Build iOS IPA
        #   runs-on: macos-latest
        #   steps:
        #     - uses: actions/checkout@v4
        #     - uses: subosito/flutter-action@v2
        #       with:
        #         channel: 'stable'
        #     - run: flutter pub get
        #     - run: flutter build ios --release --no-codesign # --no-codesign jika code signing dilakukan di tempat lain
        #     - uses: actions/upload-artifact@v4
        #       with:
        #         name: ios-release
        #         path: build/ios/Runner.ipa # Path bisa bervariasi
  ```

- **Visualisasi Konseptual: CI/CD Pipeline Sederhana**

  ```mermaid
  graph LR
      A[Developer Commits Code] --> B{Version Control (e.g., Git)};
      B -- Push to Main/PR --> C[CI Server (e.g., GitHub Actions)];
      C -- Checkout & Install Deps --> D[Build Application];
      D -- If Build Success --> E[Run Unit & Widget Tests];
      E -- If Tests Pass --> F[Run Integration Tests];
      F -- If Integration Tests Pass --> G[Code Quality Checks (Lint, Coverage)];
      G -- If All Quality Gates Pass --> H[Create Build Artifacts (APK/IPA)];
      H -- (Optional) Deploy to Staging/Production --> I[Deployment];
      J[Feedback/Notifications] <-- C, D, E, F, G, H;
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan alur kerja CI/CD yang umum. Setelah pengembang melakukan _commit_ dan _push_ kode, server CI secara otomatis memulai proses: melakukan _build_, menjalankan berbagai jenis tes, melakukan pemeriksaan kualitas kode, dan jika semua lulus, membuat artefak _build_ yang dapat di-_deploy_. _Feedback_ dan notifikasi diberikan di setiap tahap.

- **Sumber Daya Tambahan:**

  - [CI/CD for Flutter](https://docs.flutter.dev/deployment/cd) (Gambaran umum CI/CD di dokumentasi Flutter)
  - [GitHub Actions Flutter](https://github.com/marketplace/actions/flutter-action) (GitHub Action populer untuk mengatur Flutter)

---

###### **Code Quality Tools**

- **Peran:** Selain pengujian, alat kualitas kode sangat penting untuk menjaga _codebase_ tetap bersih, konsisten, mudah dibaca, dan bebas dari potensi masalah sebelum dieksekusi.

- **Dart Analyzer Configuration:**

  - **Peran:** Dart Analyzer adalah alat statis yang memeriksa kode Anda untuk kesalahan, peringatan, dan _lint_. Ini membantu menegakkan gaya pengkodean yang konsisten dan menemukan masalah potensial di awal siklus pengembangan.
  - **Konfigurasi:** Perilaku _analyzer_ dikendalikan oleh berkas `analysis_options.yaml` di _root_ proyek. Di sini Anda dapat mengaktifkan/menonaktifkan _linting rules_, mengabaikan peringatan untuk berkas tertentu, dll.

- **Linting Rules Setup:**

  - **Peran:** _Linting rules_ adalah pedoman gaya dan praktik terbaik yang diberlakukan oleh _analyzer_. Mereka membantu tim menjaga konsistensi dan menghindari pola kode yang umum menyebabkan masalah.
  - **Praktik Terbaik:** Gunakan _package_ `flutter_lints` sebagai dasar, dan sesuaikan atau tambahkan _lint_ tambahan sesuai kebutuhan proyek Anda.

- **Code Formatting:**

  - **Peran:** Mengatur kode Anda agar sesuai dengan standar gaya yang konsisten (misalnya, indentasi, spasi, _line breaks_). Ini meningkatkan keterbacaan kode secara signifikan.
  - **Mekanisme:** Dart memiliki _formatter_ bawaan yang dapat dijalankan dengan `flutter format .`. Ini sering diintegrasikan ke dalam IDE dan _hook_ Git _pre-commit_.

- **Static Analysis:**

  - **Peran:** Proses menganalisis kode sumber tanpa benar-benar menjalankannya. Tujuannya adalah untuk menemukan _bug_, kerentanan, atau pelanggaran standar pengkodean. Dart Analyzer adalah bentuk _static analysis_.
  - **Mekanisme:** Alat seperti Dart Analyzer memeriksa pola, potensi _null pointer_, penggunaan API yang tidak aman, dan banyak lagi.

- **Dependency Analysis:**

  - **Peran:** Memeriksa dependensi proyek Anda untuk kerentanan keamanan yang diketahui, lisensi yang tidak kompatibel, atau versi yang sudah usang.
  - **Mekanisme:** Meskipun tidak ada alat bawaan khusus di Flutter untuk ini, Anda dapat menggunakan alat eksternal atau layanan keamanan untuk memindai `pubspec.yaml` dan `pubspec.lock` Anda.

- **Contoh Konfigurasi (analysis_options.yaml):**

  ```yaml
  # analysis_options.yaml
  include: package:flutter_lints/flutter.yaml # Memulai dengan set lints default Flutter

  analyzer:
    exclude:
      - "**/*.g.dart" # Mengecualikan file yang dihasilkan secara otomatis
      - "**/*.freezed.dart"
      - "lib/generated_code/**"
    language:
      strict-casts: true # Menegakkan pengecoran tipe yang ketat
      strict-inference: true # Menegakkan inferensi tipe yang ketat
      strict-raw-types: true # Menegaskan penggunaan tipe mentah (raw types) yang ketat

  linter:
    rules:
      # Aturan linter kustom yang diaktifkan atau dinonaktifkan
      - avoid_empty_else # Hindari else kosong
      - avoid_print # Hindari penggunaan print() di kode produksi (prefer logger)
      - avoid_returning_null_for_future # Hindari mengembalikan null untuk Future
      - cancel_subscriptions # Pastikan StreamSubscription dibatalkan
      - constant_identifier_names # Nama identifier konstan harus camelCase
      - file_names # Nama file harus snake_case
      - no_leading_underscores_for_local_identifiers # Jangan gunakan underscore di awal untuk identifier lokal
      - prefer_const_constructors # Prefer const constructor
      # - prefer_relative_imports # Prefer import relatif (opsional, tergantung preferensi)
      - sized_box_for_whitespace # Gunakan SizedBox untuk spasi kosong
      - use_key_in_widget_constructors # Pastikan widget memiliki Key di constructor


      # Contoh aturan yang dinonaktifkan jika tidak sesuai dengan gaya tim Anda
      # - public_member_api_docs # Nonaktifkan jika tidak ingin mendokumentasikan setiap public member
  ```

- **Sumber Daya Tambahan:**

  - [Analysis Options](https://dart.dev/guides/language/analysis-options) (Dokumentasi Dart tentang berkas `analysis_options.yaml`)
  - [Effective Dart Lints](https://dart.dev/guides/language/effective-dart/usage) (Aturan _linting_ dari panduan Effective Dart)
  - [Flutter Lints](https://pub.dev/packages/flutter_lints) (_Package_ rekomendasi _lint_ untuk Flutter)

# Selamat!

Kita telah menyelesaikan seluruh **Fase 9: Testing & Quality Assurance**!

Anda sekarang memiliki pemahaman yang komprehensif tentang pentingnya pengujian, berbagai jenis tes (unit, _widget_, integrasi), cara mengimplementasikannya, dan bagaimana mengotomatiskan proses ini dalam alur kerja CI/CD untuk memastikan kualitas kode dan aplikasi yang berkelanjutan.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md
[pro9]: ../../pro/bagian-9/README.md

<!----------------------------------------------------->

[0]: ../../README.md
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
