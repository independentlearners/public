# [FASE 2: Widget System & UI Foundation][0]

Fase ini adalah inti dari pengembangan UI di Flutter. Setelah memahami dasar-dasar Flutter dan Dart di Fase 1, pembelajar akan mulai menyelami dunia _widget_, yang merupakan blok bangunan fundamental dari setiap antarmuka pengguna di Flutter.

<details>
  <summary>📃 Daftar Struktur Pembelajaran Internal</summary>

- [FASE 2: Widget System \& UI Foundation](#fase-2-widget-system--ui-foundation)
- [](#)
  - [2. Widget System \& UI Foundation](#2-widget-system--ui-foundation)
    - [2.1 The "Everything is a Widget" Principle in Practice](#21-the-everything-is-a-widget-principle-in-practice)
      - [2.1.1 Stateless vs Stateful Widgets](#211-stateless-vs-stateful-widgets)
      - [2.1.2 Widget Tree and BuildContext](#212-widget-tree-and-buildcontext)
      - [2.1.3 Understanding the Widget Lifecycle](#213-understanding-the-widget-lifecycle)
    - [2.2 Essential Layout Widgets](#22-essential-layout-widgets)
      - [2.2.1 Container and Padding](#221-container-and-padding)
      - [2.2.2 Row and Column (Flexbox Concepts)](#222-row-and-column-flexbox-concepts)
      - [2.2.3 Stack, Expanded, and Flexible](#223-stack-expanded-and-flexible)
      - [2.2.4 Centering and Alignment](#224-centering-and-alignment)
    - [2.3 Basic Interactive Widgets](#23-basic-interactive-widgets)
      - [2.3.1 Text, Image, Icon](#231-text-image-icon)
      - [2.3.2 Buttons (ElevatedButton, TextButton, IconButton)](#232-buttons-elevatedbutton-textbutton-iconbutton)
      - [2.3.3 Input Fields (TextField)](#233-input-fields-textfield)
  - [Selamat!](#selamat)

 </details>

#

**Tujuan Pembelajaran Fase 2:**

- Memahami konsep "Everything is a Widget" secara mendalam dan bagaimana _widget_ membentuk struktur UI.
- Membedakan antara _StatelessWidget_ dan _StatefulWidget_ serta kapan harus menggunakannya.
- Menguasai _layout_ dasar menggunakan _widget_ seperti `Row`, `Column`, `Container`, dan lainnya.
- Memahami siklus hidup _widget_ dan bagaimana mengelola _state_ dasar.
- Mampu membuat UI yang responsif dan menarik secara visual.

**Terminologi Esensial & Penjelasan Detail:**

- **Widget:** Sebuah deskripsi deklaratif dari bagian antarmuka pengguna. Di Flutter, hampir semua yang terlihat atau memengaruhi tata letak adalah _widget_.
- **StatelessWidget:** Sebuah _widget_ yang tidak memiliki _state_ yang dapat berubah seiring waktu. Propertinya bersifat _immutable_.
- **StatefulWidget:** Sebuah _widget_ yang memiliki _state_ yang dapat berubah selama masa hidupnya.
- **State:** Data yang dapat berubah dan memengaruhi tampilan atau perilaku _widget_.
- **BuildContext:** Sebuah handle ke lokasi _widget_ dalam _widget tree_. Ini memungkinkan _widget_ untuk menemukan _widget_ lain dalam pohon.
- **Hot Reload:** Fitur pengembangan Flutter yang memungkinkan perubahan kode langsung terlihat di aplikasi yang sedang berjalan tanpa kehilangan _state_.
- **Layout:** Proses penentuan ukuran dan posisi _widget_ di layar.
- **Parent Widget:** _Widget_ yang menampung _widget_ lain (anak-anaknya).
- **Child Widget:** _Widget_ yang terkandung di dalam _widget_ lain.
- **Tree (Widget Tree, Element Tree, RenderObject Tree):** Struktur hierarkis yang digunakan Flutter untuk mengelola _widget_ dan _rendering_.
- **Declarative UI:** Pendekatan pembangunan UI di mana Anda menggambarkan bagaimana UI Anda harus terlihat untuk _state_ tertentu, dan sistem secara otomatis memperbarui UI ketika _state_ berubah.
- **Imperative UI:** Pendekatan tradisional di mana Anda secara manual memanipulasi elemen UI setelah perubahan data.

---

## 2. Widget System & UI Foundation

Modul ini adalah jantung dari pengembangan UI di Flutter. Ini akan membawa pembelajar dari pemahaman konseptual tentang _widget_ di Fase 1 ke implementasi praktisnya, membentuk fondasi yang kuat untuk membangun antarmuka pengguna yang kompleks.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Bagian ini adalah tempat pembelajar akan mulai menulis kode UI yang sesungguhnya. Mereka akan mempelajari anatomi _widget_, perbedaan kritis antara _StatelessWidget_ dan _StatefulWidget_ beserta siklus hidupnya, dan bagaimana menggunakan _widget layout_ dasar untuk mengatur elemen di layar. Pemahaman mendalam tentang bagaimana _widget_ berinteraksi dan membentuk sebuah pohon hierarkis adalah inti dari modul ini. Ini adalah dasar mutlak untuk membangun UI apa pun di Flutter, yang akan menjadi prasyarat untuk semua topik UI yang lebih canggih di fase-fase berikutnya.

### 2.1 The "Everything is a Widget" Principle in Practice

Sub-bagian ini akan mengaplikasikan konsep filosofis "Everything is a Widget" yang telah dibahas di Fase 1 ke dalam praktik nyata. Pembelajar akan memahami secara konkret bagaimana _widget_ bekerja, perbedaan fundamental antara jenis _widget_ utama, dan bagaimana mereka membentuk struktur hierarkis dalam aplikasi Flutter.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah langkah penting dari teori ke praktik. Pembelajar akan melihat bagaimana elemen UI yang mereka bayangkan dapat dipecah menjadi _widget_-_widget_ yang lebih kecil, bagaimana _state_ dikelola, dan bagaimana _widget_ berkomunikasi melalui `BuildContext`. Pemahaman tentang siklus hidup _widget_ juga krusial untuk mengelola sumber daya dan perilaku aplikasi. Bagian ini membentuk dasar untuk semua pembangunan UI selanjutnya, memastikan pembelajar memiliki kerangka kerja mental yang benar untuk mendekati desain dan implementasi UI di Flutter.

**Konsep Kunci & Filosofi Mendalam:**

- **Widget as Blueprints:** _Widget_ bukanlah elemen UI yang digambar langsung ke layar; mereka adalah deskripsi ringan dari konfigurasi UI Anda. Flutter kemudian menggunakan deskripsi ini untuk membuat _Element_ dan _RenderObject_ yang sebenarnya melakukan pekerjaan _layout_ dan _painting_.

  - **Filosofi:** Pendekatan deklaratif ini berarti Anda hanya perlu memberitahu Flutter "apa" yang Anda inginkan di layar, bukan "bagaimana" cara menggambarnya. Flutter akan mengurus optimasi dan efisiensi _rendering_ di balik layar. Ini juga mendukung fitur _Hot Reload_ yang cepat.

- **Immutability for Performance:** Banyak _widget_ (terutama `StatelessWidget`) bersifat _immutable_ (tidak dapat diubah setelah dibuat). Ketika _state_ berubah, Flutter membangun kembali _widget tree_ yang baru, lalu membandingkannya dengan yang lama secara efisien untuk hanya memperbarui bagian yang benar-benar berubah.

  - **Filosofi:** Imutabilitas membantu Flutter dalam melakukan rekonsiliasi (_reconciliation_) _tree_ yang cepat. Karena _widget_ tidak berubah, Flutter dapat dengan mudah mengetahui apakah suatu _widget_ perlu diperbarui atau tidak, sehingga meningkatkan kinerja _rendering_.

- **BuildContext as Location:** `BuildContext` adalah referensi ke lokasi _widget_ dalam _widget tree_. Ini adalah apa yang memungkinkan _widget_ untuk menemukan _widget_ "tetangga" (parent atau ancestor) atau data yang disediakan oleh _ancestor widget_ (misalnya, tema aplikasi).

  - **Filosofi:** Membangun _widget tree_ yang fleksibel di mana _widget_ dapat berinteraksi secara lokal tanpa perlu pengetahuan global tentang seluruh aplikasi. Ini juga merupakan fondasi untuk pola _InheritedWidget_ yang akan dibahas nanti dalam manajemen _state_.

**Visualisasi Diagram Alur/Struktur:**

- Diagram pohon _widget_ yang menunjukkan hubungan _parent-child_ dan bagaimana `BuildContext` mereferensikan lokasi _widget_.
- Diagram alur sederhana yang membandingkan bagaimana `StatelessWidget` dan `StatefulWidget` bereaksi terhadap perubahan data.

**Hubungan dengan Modul Lain:**
Prinsip-prinsip yang dibahas di sini adalah inti dari semua pembangunan UI di Flutter. Pemahaman tentang _Stateless_ vs _Stateful_ akan menjadi dasar untuk memilih _widget_ yang tepat di setiap skenario. `BuildContext` akan sering muncul di seluruh kode Flutter, terutama saat mengakses tema, media _query_, atau penyedia _state_. Pemahaman siklus hidup akan krusial untuk manajemen _state_ yang lebih kompleks, _networking_, dan integrasi layanan di fase-fase selanjutnya.

---

#### 2.1.1 Stateless vs Stateful Widgets

Sub-bagian ini adalah inti dari pemahaman bagaimana _widget_ di Flutter bereaksi terhadap perubahan data dan bagaimana _state_ dikelola pada tingkat dasar.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari dua jenis _widget_ paling fundamental di Flutter: `StatelessWidget` dan `StatefulWidget`. Perbedaan antara keduanya sangat krusial karena menentukan bagaimana _widget_ dapat berubah tampilan atau perilakunya. `StatelessWidget` cocok untuk UI statis yang tidak berubah setelah dibangun, sedangkan `StatefulWidget` digunakan untuk UI dinamis yang perlu diperbarui berdasarkan interaksi pengguna atau perubahan data. Memahami kapan dan bagaimana menggunakan masing-masing adalah kunci untuk membangun UI yang efisien dan responsif.

**Konsep Kunci & Filosofi Mendalam:**

- **StatelessWidget (Widget Tanpa State):**

  - **Konsep:** Sebuah _widget_ yang tidak memiliki _state_ yang dapat berubah selama masa hidupnya. Propertinya bersifat _immutable_ (tidak dapat diubah setelah _widget_ dibuat). `build` method hanya dipanggil sekali ketika _widget_ pertama kali dibangun.
  - **Kapan Digunakan:** Untuk menampilkan informasi statis, seperti `Text`, `Icon`, atau `Image` sederhana. Juga cocok untuk _layout widget_ seperti `Padding` atau `Row` yang propertinya tidak perlu berubah setelah dibuat.
  - **Contoh Implementasi Inti:**

    ```dart
    import 'package:flutter/material.dart';

    // Widget yang menampilkan teks statis
    class MyStatelessWidget extends StatelessWidget {
      final String title;

      const MyStatelessWidget({Key? key, required this.title}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        // Context: Konteks dari widget dalam widget tree.
        // Text: Sebuah widget yang menampilkan string teks. Sintaks dasarnya adalah
        //      Text(String data, {TextStyle? style, TextAlign? textAlign, ...})
        //      Ini adalah bagian dari library Material Design atau Cupertino.
        return Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      }
    }

    // Penggunaan di aplikasi:
    void main() {
      runApp(const MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Stateless Widget Example')),
          body: MyStatelessWidget(title: 'Hello from Stateless!'),
        ),
      ));
    }
    ```

  - **Penjelasan Konteks Kode:**
    - `import 'package:flutter/material.dart';`: Mengimpor pustaka Material Design Flutter yang berisi banyak _widget_ UI siap pakai.
    - `class MyStatelessWidget extends StatelessWidget`: Mendefinisikan kelas _widget_ yang mewarisi dari `StatelessWidget`, menandakan bahwa _widget_ ini tidak akan memiliki _state_ yang berubah.
    - `final String title;`: Properti `title` dideklarasikan sebagai `final`, menegaskan bahwa nilainya tidak akan berubah setelah _widget_ dibuat.
    - `const MyStatelessWidget({Key? key, required this.title}) : super(key: key);`: Konstruktor _const_ untuk `MyStatelessWidget`. `Key` digunakan oleh Flutter untuk mengidentifikasi _widget_ secara unik, dan `required this.title` memastikan `title` harus disediakan saat membuat _widget_ ini.
    - `@override Widget build(BuildContext context)`: Ini adalah metode yang harus di-override oleh setiap _widget_. Metode ini bertanggung jawab untuk menjelaskan bagian UI yang direpresentasikan oleh _widget_ ini. `BuildContext` adalah lokasi _widget_ dalam _widget tree_.
    - `Center`: Sebuah _widget_ yang menempatkan anaknya di tengah.
    - `Text`: Sebuah _widget_ dasar untuk menampilkan teks. Properti `style` mengambil objek `TextStyle` untuk memformat teks.

- **StatefulWidget (Widget dengan State):**

  - **Konsep:** Sebuah _widget_ yang dapat berubah tampilan atau perilakunya sebagai respons terhadap interaksi pengguna atau perubahan data. `StatefulWidget` memiliki objek `State` terkait yang memegang _state_ yang dapat dimutasi dan dapat diubah sepanjang masa hidup _widget_.
  - **Kapan Digunakan:** Untuk UI yang perlu diperbarui secara dinamis, seperti _counter_, _checkbox_, _text input_, atau _widget_ yang menampilkan data dari jaringan.
  - **Contoh Implementasi Inti:**

    ```dart
    import 'package:flutter/material.dart';

    // Widget yang memiliki state yang dapat berubah (sebuah counter)
    class MyStatefulWidget extends StatefulWidget {
      const MyStatefulWidget({Key? key}) : super(key: key);

      @override
      State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
    }

    // Objek State yang terkait dengan MyStatefulWidget
    class _MyStatefulWidgetState extends State<MyStatefulWidget> {
      int _counter = 0; // State yang dapat berubah

      void _incrementCounter() {
        // setState: Memberitahu Flutter bahwa state telah berubah
        //      dan widget ini (atau bagiannya) perlu dibangun ulang.
        //      Ini adalah bagian fundamental dari reactive programming di Flutter.
        setState(() {
          _counter++; // Mengubah state
        });
      }

      @override
      Widget build(BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
                textAlign: TextAlign.center, // Konteks: Properti TextAlign
              ),
              Text(
                '$_counter', // Menampilkan state _counter
                style: Theme.of(context).textTheme.headlineMedium, // Konteks: Mengakses tema aplikasi melalui BuildContext
              ),
              const SizedBox(height: 20), // Memberi jarak vertikal
              ElevatedButton(
                onPressed: _incrementCounter, // Panggil fungsi saat tombol ditekan
                child: const Text('Increment'),
              ),
            ],
          ),
        );
      }
    }

    // Penggunaan di aplikasi:
    void main() {
      runApp(const MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Stateful Widget Example')),
          body: MyStatefulWidget(),
        ),
      ));
    }
    ```

  - **Penjelasan Konteks Kode:**
    - `class MyStatefulWidget extends StatefulWidget`: Mendefinisikan kelas _widget_ yang mewarisi dari `StatefulWidget`. Ini adalah _widget_ itu sendiri, yang bersifat _immutable_.
    - `State<MyStatefulWidget> createState() => _MyStatefulWidgetState();`: Metode ini harus di-override dan bertanggung jawab untuk membuat objek `State` yang terkait dengan `StatefulWidget` ini.
    - `class _MyStatefulWidgetState extends State<MyStatefulWidget>`: Ini adalah kelas `State` yang sebenarnya menyimpan _state_ yang dapat berubah (`_counter`). Ini memiliki akses ke _widget_ terkait (`widget` properti).
    - `int _counter = 0;`: Variabel `_counter` adalah _state_ yang akan berubah. Penting untuk dideklarasikan di dalam kelas `_MyStatefulWidgetState`.
    - `void _incrementCounter() { setState(() { _counter++; }); }`: Metode ini mengubah _state_. Panggilan `setState()` adalah _penting_ karena memberitahu Flutter bahwa _state_ telah berubah dan bahwa metode `build` dari `StatefulWidget` perlu dipanggil ulang untuk memperbarui UI. Tanpa `setState()`, UI tidak akan merefleksikan perubahan `_counter`.
    - `Column`: Sebuah _widget layout_ yang menata anak-anaknya secara vertikal.
    - `ElevatedButton`: Sebuah _widget_ tombol dengan elevasi (bayangan). Properti `onPressed` menerima fungsi yang akan dipanggil saat tombol ditekan.
    - `Theme.of(context).textTheme.headlineMedium`: Contoh penggunaan `BuildContext` untuk mengakses tema aplikasi secara hirarkis dari _widget tree_, sehingga Anda dapat mengambil _style_ teks yang telah ditentukan dalam tema. Ini menunjukkan bagaimana `BuildContext` memungkinkan _widget_ mengakses data dari _ancestor_ di pohon.

**Visualisasi Diagram Alur/Struktur:**

- Diagram sederhana yang menunjukkan siklus hidup `StatelessWidget` (built once) vs `StatefulWidget` (built, `setState` triggers rebuild).
- Diagram yang menjelaskan hubungan antara `StatefulWidget` dan objek `State` yang terpisah.

**Terminologi Esensial & Penjelasan Detail:**

- **StatelessWidget:** Widget tanpa _state_ yang berubah.
- **StatefulWidget:** Widget dengan _state_ yang dapat berubah.
- **State:** Data yang dapat berubah dan memengaruhi tampilan _widget_.
- **Immutable:** Tidak dapat diubah setelah dibuat.
- **Mutable:** Dapat diubah setelah dibuat.
- **`build` method:** Metode yang harus diimplementasikan oleh setiap _widget_ untuk mendeskripsikan bagian UI-nya.
- **`setState()`:** Fungsi yang dipanggil di dalam `StatefulWidget` untuk memberi tahu Flutter bahwa _state_ telah berubah dan UI perlu dibangun ulang.
- **`BuildContext`:** Referensi ke lokasi _widget_ dalam _widget tree_.

**Sumber Referensi Lengkap:**

- [Stateless vs Stateful Widgets (Flutter Official Docs)](https://flutter.dev/docs/development/ui/widgets-intro%23stateless-vs-stateful)
- [Introduction to Widgets (Flutter Official Docs)](https://flutter.dev/docs/development/ui/widgets-intro)
- [StatefulWidget Class](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
- [StatelessWidget Class](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)
- [Understanding StatelessWidget and StatefulWidget in Flutter](https://medium.com/flutter-community/understanding-statelesswidget-and-statefulwidget-in-flutter-43dd59d297a7)

**Tips dan Praktik Terbaik:**

- **Mulailah dengan StatelessWidget:** Selalu usahakan untuk menggunakan `StatelessWidget` jika memungkinkan. Ini membuat kode lebih sederhana, lebih mudah di-_test_, dan lebih performa. Konversikan ke `StatefulWidget` hanya jika Anda benar-benar membutuhkan _state_ yang dapat berubah.
- **Isolasi State:** Usahakan untuk menjaga _state_ seramping dan terlokalisasi mungkin. Jangan membuat seluruh layar menjadi `StatefulWidget` jika hanya sebagian kecil yang perlu berubah.
- **Pahami `setState()`:** Ini adalah mekanisme utama untuk memperbarui UI. Perubahan apa pun pada _state_ dalam `StatefulWidget` harus dibungkus dalam panggilan `setState()` agar Flutter tahu untuk membangun ulang _widget_.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mengubah _state_ dalam `StatefulWidget` tetapi UI tidak diperbarui.

  - **Penyebab:** Lupa memanggil `setState()` setelah mengubah _state_.
  - **Solusi:** Pastikan semua perubahan pada variabel _state_ dibungkus di dalam `setState(() { ... });`.

- **Kesalahan:** Mencoba mengubah properti `final` dari `StatelessWidget`.

  - **Penyebab:** `StatelessWidget` bersifat _immutable_. Propertinya tidak dapat diubah setelah _widget_ dibangun.
  - **Solusi:** Jika Anda perlu properti yang berubah, Anda perlu membuat _widget_ baru dengan properti yang berbeda atau menggunakan `StatefulWidget` jika perubahan terjadi di dalam _widget_ itu sendiri.

- **Kesalahan:** Menempatkan logika bisnis yang kompleks di dalam metode `build()`.

  - **Penyebab:** Metode `build()` dapat dipanggil berkali-kali. Menempatkan operasi berat di sana dapat menyebabkan masalah kinerja.
  - **Solusi:** Pisahkan logika bisnis ke metode atau kelas terpisah. `build()` method hanya boleh fokus pada mengembalikan struktur _widget_.

---

#### 2.1.2 Widget Tree and BuildContext

Sub-bagian ini akan menjelaskan bagaimana _widget_ disusun secara hierarkis dalam Flutter dan peran kunci dari `BuildContext` dalam interaksi antar _widget_. Pemahaman ini esensial untuk navigasi, mengakses data tema, atau berkomunikasi dengan _ancestor widget_ lainnya.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bahwa aplikasi Flutter bukan sekadar kumpulan _widget_ yang terpisah, melainkan sebuah struktur pohon yang kompleks dan terorganisir, di mana setiap _widget_ adalah "simpul" dalam pohon tersebut. Konsep `BuildContext` akan dijelaskan sebagai semacam "alamat" atau "lokasi" dari _widget_ di dalam pohon, yang memungkinkan _widget_ untuk menemukan _ancestor_ (leluhur) atau _descendant_ (turunan) tertentu, atau untuk mengakses layanan yang disediakan oleh pohon. Pemahaman ini sangat penting untuk men-debug masalah _layout_, memahami _state management_ (terutama _InheritedWidget_), dan berinteraksi dengan API yang memerlukan `BuildContext`.

**Konsep Kunci & Filosofi Mendalam:**

- **Widget Tree (Pohon Widget):**

  - **Konsep:** Setiap aplikasi Flutter pada dasarnya adalah sebuah pohon _widget_. Dimulai dari _root widget_ (biasanya `MaterialApp` atau `CupertinoApp`), setiap _widget_ dapat memiliki nol atau lebih _child widget_. Hubungan ini membentuk hierarki, di mana _widget_ bertindak sebagai _parent_ untuk _child_-nya.
  - **Filosofi:** Pendekatan pohon ini memungkinkan Flutter untuk secara efisien mengelola dan membangun ulang UI. Ketika _state_ berubah, Flutter tidak perlu membangun ulang seluruh pohon, melainkan hanya bagian-bagian yang terpengaruh, melalui proses yang disebut rekonsiliasi. Ini mirip dengan cara DOM bekerja di web, tetapi dioptimalkan untuk _rendering_ berkinerja tinggi.
  - **Contoh Struktural (Pseudo-Code):**
    ```dart
    // Root Widget
    MaterialApp(
      home: Scaffold( // Child of MaterialApp
        appBar: AppBar( // Child of Scaffold
          title: Text('My App'), // Child of AppBar
        ),
        body: Center( // Another child of Scaffold
          child: Column( // Child of Center
            children: <Widget>[ // Children of Column
              Text('Hello'), // Child of Column
              ElevatedButton( // Another child of Column
                child: Text('Press Me'), // Child of ElevatedButton
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    )
    ```
  - Visualisasi struktur pohon _widget_ sangat dianjurkan di sini.

- **BuildContext:**

  - **Konsep:** Setiap metode `build` di setiap _widget_ menerima `BuildContext` sebagai argumen. `BuildContext` adalah _handle_ ke lokasi _widget_ tersebut dalam _widget tree_. Ini adalah referensi konkret yang memungkinkan _widget_ untuk:
    - Mencari _ancestor widget_ (misalnya, mencari `Scaffold` terdekat untuk menampilkan `SnackBar`).
    - Mengakses properti dari _ancestor widget_ (misalnya, tema aplikasi melalui `Theme.of(context)` atau ukuran layar melalui `MediaQuery.of(context)`).
    - Menentukan lokasi relatif _widget_ untuk _layout_ dan _rendering_.
    - Berinteraksi dengan _Element Tree_ yang mendasarinya.
  - **Filosofi:** `BuildContext` memastikan bahwa _widget_ hanya memiliki pengetahuan yang diperlukan tentang lingkungannya tanpa perlu pengetahuan global tentang seluruh aplikasi. Ini mendorong _loose coupling_ dan modularitas, serta memungkinkan _widget_ untuk digunakan kembali di berbagai bagian aplikasi.
  - **Contoh Implementasi Inti:**

    ```dart
    import 'package:flutter/material.dart';

    class MyApp extends StatelessWidget {
      const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        // BuildContext di sini adalah untuk MaterialApp
        return MaterialApp(
          title: 'Widget Tree & BuildContext Demo',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const MyHomePage(),
        );
      }
    }

    class MyHomePage extends StatelessWidget {
      const MyHomePage({super.key});

      @override
      Widget build(BuildContext context) {
        // BuildContext di sini adalah untuk MyHomePage.
        // Bisa digunakan untuk mengakses Theme yang didefinisikan di MaterialApp.
        // Sintaks: Theme.of(BuildContext context) adalah cara untuk mencari ancestor widget Theme.
        // Ini adalah bagian dari library Material Design yang mengelola tema aplikasi.
        final Color primaryColor = Theme.of(context).primaryColor;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Widget Tree Demo'),
            backgroundColor: primaryColor, // Menggunakan warna dari tema
          ),
          body: Builder( // Menggunakan Builder untuk mendapatkan BuildContext dari anaknya
            builder: (BuildContext innerContext) {
              // innerContext adalah BuildContext dari Builder, yang merupakan anak dari Scaffold.
              // Ini penting jika kita ingin mengakses Scaffold yang merupakan ancestor terdekat.
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Primary Color from Theme: ${primaryColor.value.toRadixString(16).substring(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Mencari Scaffold.of(context) untuk menampilkan SnackBar.
                        // Sintaks: ScaffoldMessenger.of(BuildContext context).showSnackBar()
                        // Ini adalah bagian dari library Material Design untuk menampilkan pesan sementara.
                        // Perhatikan bahwa kita tidak bisa langsung menggunakan 'context' dari MyHomePage
                        // karena context tersebut *di atas* Scaffold. Kita butuh context *di bawah* Scaffold.
                        ScaffoldMessenger.of(innerContext).showSnackBar(
                          const SnackBar(content: Text('Hello from SnackBar!')),
                        );
                      },
                      child: const Text('Show SnackBar'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    }

    void main() {
      runApp(const MyApp());
    }
    ```

  - **Penjelasan Konteks Kode:**
    - `MaterialApp`: _Root widget_ aplikasi Material Design. `BuildContext` untuk `MaterialApp` adalah yang paling atas.
    - `Scaffold`: Sebuah _widget_ dasar yang menyediakan struktur visual aplikasi Material Design (seperti `AppBar`, `body`, `floatingActionButton`). `BuildContext` untuk `Scaffold` adalah anak dari `MaterialApp`.
    - `Theme.of(context)`: Sintaks ini digunakan untuk mencari objek `ThemeData` terdekat di _widget tree_ dari `BuildContext` yang diberikan. Ini adalah contoh klasik bagaimana `BuildContext` digunakan untuk mengakses data dari _ancestor widget_.
    - `ScaffoldMessenger.of(innerContext).showSnackBar(...)`: Ini adalah contoh lain yang sangat penting. Untuk menampilkan `SnackBar` (pesan singkat di bagian bawah layar), kita perlu mengakses `ScaffoldMessenger` terdekat. Jika kita menggunakan `context` dari `MyHomePage` (yang _parent_ dari `Scaffold`), `ScaffoldMessenger.of(context)` akan gagal karena tidak ada `ScaffoldMessenger` yang merupakan _ancestor_ dari `MyHomePage` di `BuildContext` tersebut. Kita memerlukan `BuildContext` yang merupakan _descendant_ dari `ScaffoldMessenger` (yang disediakan oleh `Scaffold`). Oleh karena itu, kita menggunakan `Builder` _widget_ yang menyediakan `innerContext` yang berada pada level yang tepat di dalam _widget tree_.

**Visualisasi Diagram Alur/Struktur:**

- Diagram pohon _widget_ yang lebih kompleks, menunjukkan hubungan _parent-child_ dan panah yang merepresentasikan jalur `BuildContext` dari _child_ ke _ancestor_.
- Ilustrasi bagaimana `Theme.of(context)` "naik" ke atas pohon untuk menemukan `ThemeData`.

**Terminologi Esensial & Penjelasan Detail:**

- **Widget Tree:** Struktur hierarkis dari _widget_ yang membentuk UI aplikasi.
- **Root Widget:** _Widget_ paling atas di _widget tree_ (misalnya, `MaterialApp`).
- **Parent Widget:** _Widget_ yang berisi _child widget_.
- **Child Widget:** _Widget_ yang terkandung dalam _parent widget_.
- **Ancestor Widget:** _Widget_ mana pun yang berada di atas _widget_ saat ini di _widget tree_.
- **Descendant Widget:** _Widget_ mana pun yang berada di bawah _widget_ saat ini di _widget tree_.
- **BuildContext:** Referensi ke lokasi _widget_ di dalam _widget tree_.
- **Traversal:** Proses "berjalan" melalui _widget tree_ (biasanya dari _child_ ke _parent_) untuk menemukan _ancestor_ tertentu.

**Sumber Referensi Lengkap:**

- [Understanding Keys and BuildContext (Flutter Official Docs)](https://flutter.dev/docs/development/data-and-backend/state-mgmt/keys)
- [BuildContext (Flutter API Docs)](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)
- [The Widget Tree in Flutter](https://flutter.dev/docs/development/ui/widgets-intro%23the-widget-tree)
- [Demystifying the BuildContext in Flutter](https://medium.com/flutter-community/demystifying-the-buildcontext-in-flutter-b26a61b8c049)
- [When to use Builder in Flutter](https://resocoder.com/2019/04/10/flutter-builder-explained-when-to-use-it/)

**Tips dan Praktik Terbaik:**

- **Pahami Lokasi `BuildContext` Anda:** Selalu perhatikan di mana `BuildContext` yang Anda gunakan berada di _widget tree_. Ini sangat penting ketika Anda mencoba mengakses data dari _ancestor widget_ atau menampilkan elemen yang membutuhkan _ancestor_ tertentu (seperti `ScaffoldMessenger`).
- **Jangan Gunakan `BuildContext` Lintas `async` Boundary:** `BuildContext` bisa menjadi tidak valid jika _widget_ telah dilepaskan dari pohon sebelum operasi _asynchronous_ selesai. Hindari menggunakan `context` di dalam `Future.then()` atau setelah `await` tanpa pemeriksaan `mounted`.
- **Minimalisir Pembuatan Ulang Widget:** Karena `build` method dapat dipanggil berkali-kali, hindari melakukan operasi berat di dalamnya. Fokuskan `build` method untuk hanya mengembalikan struktur _widget_.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Error "No Scaffold found as an ancestor" atau "inheritFromWidgetOfExactType was called on a null BuildContext".

  - **Penyebab:** Anda mencoba mengakses layanan seperti `Scaffold.of(context)` atau `Theme.of(context)` dari `BuildContext` yang tidak memiliki _ancestor widget_ yang diperlukan di atasnya. Ini sering terjadi ketika `BuildContext` yang digunakan adalah _parent_ dari `Scaffold` atau `Theme`.
  - **Solusi:** Pastikan `BuildContext` yang Anda gunakan adalah _descendant_ dari _widget_ yang ingin Anda akses. Seringkali, ini bisa diselesaikan dengan membungkus bagian kode Anda dalam `Builder` _widget_ (seperti contoh `SnackBar`) atau memisahkan _widget_ menjadi _widget_ baru yang memiliki `BuildContext` yang berbeda.

- **Kesalahan:** UI tidak memperbarui data yang berasal dari _ancestor_ setelah _ancestor_ tersebut berubah.

  - **Penyebab:** `BuildContext` tidak secara otomatis "mendengarkan" perubahan di _ancestor_ kecuali _ancestor_ tersebut adalah `InheritedWidget` atau pola manajemen _state_ lainnya yang memanfaatkan `InheritedWidget`.
  - **Solusi:** Untuk data yang dinamis dan perlu diperbarui oleh _ancestor_, gunakan `InheritedWidget` atau solusi manajemen _state_ lainnya yang memanfaatkan `InheritedWidget` (seperti Provider, BLoC, Riverpod) yang akan dibahas di fase selanjutnya. Ini akan memungkinkan _descendant widget_ untuk "berlangganan" perubahan di _ancestor_ mereka.

---

#### 2.1.3 Understanding the Widget Lifecycle

Sub-bagian ini akan menguraikan siklus hidup _widget_ di Flutter, khususnya untuk `StatefulWidget` yang memiliki _state_ dinamis. Memahami kapan dan bagaimana metode-metode tertentu dipanggil adalah kunci untuk mengelola _state_, sumber daya, dan interaksi dengan sistem eksternal secara efektif.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan diperkenalkan pada urutan metode yang dipanggil oleh Flutter selama masa hidup `StatefulWidget`, mulai dari inisialisasi hingga penghancuran. Ini mencakup metode seperti `initState()`, `didChangeDependencies()`, `build()`, `didUpdateWidget()`, dan `dispose()`. Penjelasan akan mencakup tujuan masing-masing metode dan kapan harus mengimplementasikannya. Pemahaman ini sangat krusial untuk:

- Melakukan inisialisasi _state_ awal.
- Mengambil data dari sumber eksternal (misalnya API) saat _widget_ pertama kali dibuat.
- Membersihkan sumber daya (misalnya _listener_, _timer_, _controller_) saat _widget_ dihapus dari pohon untuk mencegah _memory leak_.
- Bereaksi terhadap perubahan konfigurasi _widget_ dari _parent_.

**Konsep Kunci & Filosofi Mendalam:**

- **Life Cycle Methods:** Serangkaian metode _callback_ yang dipanggil oleh Flutter pada tahap-tahap tertentu dalam masa hidup `StatefulWidget`. Ini memungkinkan pengembang untuk "mengaitkan" (_hook into_) alur kerja Flutter dan menjalankan logika khusus pada momen-momen penting.

  - **Filosofi:** Memberikan kontrol yang tepat kepada pengembang atas _widget_ dinamis, memungkinkan manajemen _state_ dan sumber daya yang efisien. Ini adalah pola umum dalam pengembangan UI yang reaktif, di mana komponen perlu bereaksi terhadap inisialisasi, perubahan, dan penghancuran.

- **Reactive Update:** Siklus hidup `StatefulWidget` terintegrasi erat dengan paradigma pemrograman reaktif Flutter. Perubahan _state_ memicu panggilan metode `build()` yang efisien, sementara metode siklus hidup lainnya menangani inisialisasi, pembaruan konfigurasi, dan pembersihan.

**Visualisasi Diagram Alur/Struktur:**
Visualisasi diagram alur _lifecycle_ `StatefulWidget` yang menunjukkan urutan panggilan metode dan kapan mereka digunakan (misalnya, `initState` -\> `didChangeDependencies` -\> `build` -\> `didUpdateWidget` -\> `build` -\> `deactivate` -\> `dispose`).

**Sintaks Dasar / Contoh Implementasi Inti:**

Mari kita gunakan contoh sederhana yang mencetak log ke konsol pada setiap tahapan siklus hidup untuk `StatefulWidget` kita.

```dart
import 'package:flutter/material.dart';

class LifecycleExample extends StatefulWidget {
  final Color backgroundColor;
  final String label;

  const LifecycleExample({
    Key? key,
    required this.backgroundColor,
    required this.label,
  }) : super(key: key);

  @override
  State<LifecycleExample> createState() => _LifecycleExampleState();
}

class _LifecycleExampleState extends State<LifecycleExample> {
  int _counter = 0; // State internal

  // 1. initState()
  // Konteks: Dipanggil satu kali saat State objek pertama kali dibuat.
  // Sintaks: @override void initState() { super.initState(); ... }
  // Digunakan untuk inisialisasi state, subscription ke Streams, atau One-time setup.
  // Tidak bisa menggunakan BuildContext di sini (kecuali untuk InheritedWidget).
  @override
  void initState() {
    super.initState(); // Selalu panggil super.initState()
    _counter = 0; // Inisialisasi state
    print('LifecycleExample: initState() - Counter initialized to $_counter');
    // Contoh: Menginisialisasi controller, menambahkan listener, dll.
  }

  // 2. didChangeDependencies()
  // Konteks: Dipanggil segera setelah initState() dan setiap kali dependensi
  //          BuildContext dari State objek berubah.
  // Sintaks: @override void didChangeDependencies() { super.didChangeDependencies(); ... }
  // Digunakan ketika widget Anda perlu bereaksi terhadap perubahan InheritedWidget
  // yang diakses melalui BuildContext (misalnya Theme.of(context), MediaQuery.of(context)).
  // Anda dapat menggunakan BuildContext di sini.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); // Selalu panggil super.didChangeDependencies()
    print('LifecycleExample: didChangeDependencies() - Theme primary color: ${Theme.of(context).primaryColor}');
    // Contoh: Mengambil data berdasarkan tema atau ukuran layar.
  }

  // 3. build()
  // Konteks: Dipanggil setiap kali widget perlu dibangun ulang (misalnya setelah setState()).
  // Sintaks: @override Widget build(BuildContext context) { ... return Widget; }
  // Mengembalikan struktur UI. Ini adalah metode yang paling sering dipanggil.
  @override
  Widget build(BuildContext context) {
    print('LifecycleExample: build() - Counter: $_counter, Label: ${widget.label}, Color: ${widget.backgroundColor}');
    // Contoh: Membangun UI berdasarkan state dan properti widget.
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: widget.backgroundColor, // Menggunakan properti dari widget
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${widget.label}: $_counter',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            child: const Text('Increment Counter'),
          ),
        ],
      ),
    );
  }

  // 4. didUpdateWidget(covariant T oldWidget)
  // Konteks: Dipanggil ketika widget parent mengubah konfigurasi widget ini
  //          (misalnya, properti 'backgroundColor' atau 'label' berubah),
  //          tetapi State objek tetap ada di pohon.
  // Sintaks: @override void didUpdateWidget(covariant LifecycleExample oldWidget) { super.didUpdateWidget(oldWidget); ... }
  // Digunakan untuk bereaksi terhadap perubahan properti dari parent,
  // membandingkan oldWidget dengan widget yang baru.
  @override
  void didUpdateWidget(covariant LifecycleExample oldWidget) {
    super.didUpdateWidget(oldWidget); // Selalu panggil super.didUpdateWidget()
    if (widget.backgroundColor != oldWidget.backgroundColor) {
      print('LifecycleExample: didUpdateWidget() - Background color changed from ${oldWidget.backgroundColor} to ${widget.backgroundColor}');
      // Contoh: Mengubah logika berdasarkan properti baru.
    }
    if (widget.label != oldWidget.label) {
      print('LifecycleExample: didUpdateWidget() - Label changed from ${oldWidget.label} to ${widget.label}');
    }
  }

  // 5. deactivate()
  // Konteks: Dipanggil ketika State objek dihapus dari widget tree,
  //          misalnya, karena digantikan oleh widget lain dengan Key yang berbeda,
  //          atau dipindahkan ke posisi lain dalam pohon.
  // Sintaks: @override void deactivate() { super.deactivate(); ... }
  // Jarang digunakan secara langsung, tetapi penting untuk dipahami urutannya.
  // Jika widget kemudian dimasukkan kembali ke pohon, initState() tidak akan dipanggil lagi.
  @override
  void deactivate() {
    print('LifecycleExample: deactivate()');
    super.deactivate(); // Selalu panggil super.deactivate()
  }

  // 6. dispose()
  // Konteks: Dipanggil ketika State objek akan dihapus secara permanen dari pohon
  //          dan tidak akan pernah dibangun lagi.
  // Sintaks: @override void dispose() { ... super.dispose(); }
  // Digunakan untuk membersihkan sumber daya (misalnya controller, listener, timer)
  // untuk mencegah memory leak. Ini adalah bagian yang sangat penting.
  @override
  void dispose() {
    print('LifecycleExample: dispose()');
    // Contoh: controller.dispose(); listener.cancel(); timer.cancel();
    super.dispose(); // Selalu panggil super.dispose() di akhir
  }
}

// Aplikasi utama untuk mendemonstrasikan siklus hidup
class LifecycleDemoApp extends StatefulWidget {
  const LifecycleDemoApp({super.key});

  @override
  State<LifecycleDemoApp> createState() => _LifecycleDemoAppState();
}

class _LifecycleDemoAppState extends State<LifecycleDemoApp> {
  Color _currentColor = Colors.blue;
  String _currentLabel = 'Initial Label';
  bool _showWidget = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Widget Lifecycle Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_showWidget) // Menampilkan/menyembunyikan widget untuk melihat deactivate/dispose
                LifecycleExample(
                  backgroundColor: _currentColor,
                  label: _currentLabel,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentColor = _currentColor == Colors.blue ? Colors.red : Colors.blue;
                  });
                },
                child: const Text('Change Background Color'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentLabel = _currentLabel == 'Initial Label' ? 'Updated Label' : 'Initial Label';
                  });
                },
                child: const Text('Change Label'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showWidget = !_showWidget; // Menghapus/menambahkan widget dari pohon
                  });
                },
                child: Text(_showWidget ? 'Hide Widget' : 'Show Widget'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const LifecycleDemoApp());
}
```

**Penjelasan Konteks Kode:**

- **`import 'package:flutter/material.dart';`**: Mengimpor _library_ Material Design untuk _widget_ UI dasar.
- **`LifecycleExample extends StatefulWidget`**: Mendefinisikan _widget_ yang memiliki _state_ dinamis, yang akan kita pantau siklus hidupnya. Propertinya (`backgroundColor`, `label`) dideklarasikan sebagai `final` karena _widget_ itu sendiri _immutable_.
- **`_LifecycleExampleState extends State<LifecycleExample>`**: Ini adalah objek `State` yang terkait dengan `LifecycleExample`. Semua _state_ yang dapat berubah (`_counter`) dan metode siklus hidup diimplementasikan di sini.
- **`@override`**: Anotasi ini menandakan bahwa metode tersebut menggantikan metode dari kelas _parent_. Ini adalah praktik terbaik yang direkomendasikan dalam Dart.
- **`super.initState()` / `super.didUpdateWidget()` dll.**: Sangat penting untuk selalu memanggil implementasi metode _parent_ (_super_) di awal setiap metode siklus hidup, kecuali untuk `dispose()` yang harus dipanggil di akhir. Ini memastikan bahwa perilaku dasar Flutter tetap dipertahankan.
- **`_counter = 0;`**: Inisialisasi _state_ di `initState()`.
- **`setState(() { _counter++; });`**: Ini memicu pembangunan ulang (`build()` method akan dipanggil lagi) _widget_ setelah `_counter` diperbarui.
- **`Theme.of(context).primaryColor`**: Contoh penggunaan `BuildContext` di `didChangeDependencies()` untuk mengakses data tema. Jika tema aplikasi berubah (misalnya, di `MaterialApp`), `didChangeDependencies()` akan dipanggil.
- **`widget.backgroundColor` / `widget.label`**: Di dalam objek `State`, Anda dapat mengakses properti _widget_ yang terkait melalui properti `widget`.
- **`didUpdateWidget(covariant LifecycleExample oldWidget)`**: Contoh penggunaan `oldWidget` untuk membandingkan properti _widget_ yang lama dengan yang baru. Ini berguna untuk memicu logika tertentu hanya ketika properti tertentu berubah.
- **`_showWidget` dalam `LifecycleDemoApp`**: Digunakan untuk secara sengaja menghapus atau menambahkan `LifecycleExample` dari _widget tree_ untuk mendemonstrasikan panggilan `deactivate()` dan `dispose()`. Ketika `_showWidget` menjadi `false`, `LifecycleExample` akan dilepaskan dari pohon, memicu `deactivate()` lalu `dispose()`.

**Terminologi Esensial & Penjelasan Detail:**

- **Lifecycle:** Serangkaian tahapan yang dilalui sebuah _widget_ dari pembuatan hingga penghancuran.
- **`initState()`:** Metode pertama yang dipanggil setelah objek `State` dibuat. Ideal untuk inisialisasi satu kali.
- **`didChangeDependencies()`:** Dipanggil setelah `initState()` dan setiap kali objek dependensi (`InheritedWidget`) berubah.
- **`build()`:** Dipanggil setiap kali _widget_ perlu dibangun atau dibangun ulang. Ini adalah tempat Anda mendefinisikan UI.
- **`didUpdateWidget()`:** Dipanggil ketika _parent widget_ membangun ulang _widget_ ini dengan konfigurasi baru yang sama tipenya, tetapi dengan properti yang mungkin berbeda.
- **`deactivate()`:** Dipanggil ketika _widget_ dihapus dari _widget tree_ sementara (misalnya, dipindahkan ke posisi lain atau dihapus secara kondisional). Jika _widget_ dimasukkan kembali, `initState()` tidak dipanggil lagi.
- **`dispose()`:** Dipanggil ketika _widget_ dihapus secara permanen dari _widget tree_. Ini adalah tempat penting untuk membersihkan sumber daya.
- **`covariant`:** Kata kunci Dart yang digunakan dalam _override_ untuk memungkinkan argumen memiliki tipe yang lebih spesifik daripada tipe dalam kelas _parent_.

**Sumber Referensi Lengkap:**

- [StatefulWidget lifecycle (Flutter Official Docs)](https://flutter.dev/docs/development/ui/advanced/building-layouts%23statefulwidget-lifecycle)
- [StatefulWidget Class (API Docs)](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
- [State Class (API Docs)](https://api.flutter.dev/flutter/widgets/State-class.html)
- [Flutter Widget Lifecycle Explained](https://medium.com/flutter-community/flutter-widget-lifecycle-explained-bd46440c4a45)

**Tips dan Praktik Terbaik:**

- **Pembersihan di `dispose()`:** Ini adalah _best practice_ yang paling penting. Selalu bersihkan _controller_, _listener_, _timer_, atau sumber daya lain yang Anda buat di `initState()` (atau di tempat lain) di dalam metode `dispose()`. Kegagalan melakukan ini akan menyebabkan _memory leak_ dan performa aplikasi yang buruk.
- **Hanya Gunakan `setState()` untuk Memperbarui UI:** Jangan gunakan `setState()` untuk mengubah _state_ yang tidak memengaruhi UI.
- **`initState()` untuk Inisialisasi Sekali Saja:** Logika yang hanya perlu dijalankan sekali saat _widget_ dibuat harus ada di `initState()`.
- **`didUpdateWidget()` untuk Reaksi Properti Parent:** Gunakan `didUpdateWidget()` jika _widget_ Anda perlu bereaksi terhadap perubahan properti yang datang dari _parent widget_ dan melakukan sesuatu (misalnya, memperbarui _controller_ atau membatalkan langganan lama).
- **Hindari Operasi Berat di `build()`:** Karena `build()` dipanggil sangat sering, hindari operasi jaringan, _database_, atau komputasi yang berat di dalamnya. Delegasikan operasi ini ke _future_, _stream_, atau metode lain yang dipanggil dari `initState()` atau _state management_ Anda.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** _Memory leak_ karena _controller_ atau _listener_ tidak dibersihkan.

  - **Penyebab:** Lupa memanggil `dispose()` pada objek yang memerlukan pembersihan, seperti `TextEditingController`, `StreamSubscription`, `AnimationController`, dll.
  - **Solusi:** Pastikan setiap objek yang memiliki metode `dispose()` atau `cancel()` dipanggil di dalam metode `dispose()` dari `StatefulWidget` Anda.

- **Kesalahan:** Mengakses `widget` dari dalam `initState()` untuk logika yang berubah-ubah.

  - **Penyebab:** Properti `widget` belum sepenuhnya diinisialisasi atau belum tentu sama dengan yang akan Anda dapatkan setelah `didUpdateWidget()`.
  - **Solusi:** Untuk hal-hal yang tergantung pada `InheritedWidget` atau _state_ dari _parent_, pertimbangkan `didChangeDependencies()`. Untuk properti `widget` yang diberikan saat konstruksi, akses langsung `widget.propertyName`.

- **Kesalahan:** Metode siklus hidup tidak dipanggil seperti yang diharapkan (misalnya `initState()` tidak dipanggil lagi setelah _widget_ diganti).

  - **Penyebab:** Mungkin _widget_ yang baru memiliki `Key` yang sama dengan _widget_ yang lama, atau _widget_ hanya dipindahkan di _widget tree_ (sehingga `deactivate()` dipanggil, tetapi `dispose()` tidak, dan objek `State` yang sama digunakan kembali).
  - **Solusi:** Pahami peran `Key` dalam identifikasi _widget_ dan bagaimana mereka memengaruhi rekonsiliasi. Jika Anda ingin `State` baru setiap kali _widget_ diganti, pastikan `Key` berubah, atau hindari penggunaan `Key` jika tidak diperlukan dan biarkan Flutter mengelola identifikasi secara default.

---

### 2.2 Essential Layout Widgets

Sub-bagian ini berfokus pada _widget_ yang digunakan untuk mengatur tata letak elemen UI di layar. Ini adalah aspek fundamental dalam pembangunan UI yang menarik dan fungsional di Flutter.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari _widget_ dasar namun sangat kuat yang Flutter sediakan untuk mengelola _layout_. Ini termasuk `Container` untuk dekorasi dan _spacing_, `Row` dan `Column` untuk pengaturan linear (mirip Flexbox), serta `Stack` untuk menumpuk _widget_. Konsep-konsep seperti _main axis alignment_, _cross axis alignment_, dan bagaimana _widget_ mengonsumsi ruang akan dijelaskan secara praktis. Penguasaan _widget layout_ ini adalah prasyarat untuk membuat UI yang lebih kompleks dan responsif di masa depan.

**Konsep Kunci & Filosofi Mendalam:**

- **Constraints Go Down, Sizes Go Up, Parent Sets Position:** Ini adalah aturan dasar _layout_ di Flutter.

  1.  **Constraints Go Down:** Sebuah _widget_ _parent_ memberitahu _child_-nya batas ukuran maksimum dan minimum yang bisa diambil oleh _child_ tersebut.
  2.  **Sizes Go Up:** _Child widget_ kemudian memilih ukurannya sendiri (sesuai dengan batasan yang diberikan _parent_) dan memberitahukannya kembali ke _parent_.
  3.  **Parent Sets Position:** Setelah _parent_ mengetahui ukuran _child_, _parent_ kemudian menentukan posisi _child_ di layar.

  <!-- end list -->

  - **Filosofi:** Aturan ini memastikan proses _layout_ yang efisien dan dapat diprediksi. Setiap _widget_ bertanggung jawab atas ukurannya sendiri dalam batasan yang diberikan, yang mendorong modularitas dan kinerja.

- **Declarative Layout:** Di Flutter, Anda menjelaskan bagaimana UI Anda harus disusun menggunakan komposisi _widget_. Anda tidak secara manual memanipulasi posisi atau ukuran piksel seperti di pendekatan imperatif.

  - **Filosofi:** Ini menyederhanakan proses desain UI, membuatnya lebih mudah untuk melihat dan memodifikasi struktur, serta secara otomatis beradaptasi dengan berbagai ukuran layar.

- **Composition over Inheritance:** Flutter sangat mendorong komposisi _widget_ (menggabungkan _widget_ kecil untuk membentuk _widget_ yang lebih besar) daripada menggunakan hierarki kelas yang dalam (warisan).

  - **Filosofi:** Membuat kode lebih fleksibel, mudah dibaca, dan dapat digunakan kembali.

**Visualisasi Diagram Alur/Struktur:**

- Diagram alur "Constraints Go Down, Sizes Go Up, Parent Sets Position".
- Visualisasi kotak untuk `Container` yang menunjukkan _padding_, _margin_, dan _border_.
- Ilustrasi `Row` dan `Column` dengan sumbu utama dan sumbu silang serta berbagai opsi _alignment_.

**Hubungan dengan Modul Lain:**
_Widget layout_ adalah fondasi visual untuk semua UI. Mereka akan digunakan di setiap modul yang melibatkan pembangunan antarmuka pengguna, mulai dari _basic interactive widgets_ hingga _advanced UI_, _custom painting_, dan _responsive design_. Pemahaman yang kuat di sini akan mempercepat proses _debugging_ masalah _layout_ di kemudian hari.

---

#### 2.2.1 Container and Padding

Sub-bagian ini akan memperkenalkan dua _widget_ dasar yang sering digunakan untuk memberikan ruang, _styling_, dan menampung _widget_ lain.

**Deskripsi Konkret & Peran dalam Kurikulum:**

- **`Container`**: Sebuah _widget_ serbaguna yang dapat digunakan untuk menggambar, memposisikan, dan mengukur _widget_. Ini adalah _widget_ "kotak" yang dapat memiliki warna latar belakang, gambar latar belakang, _border_, _shadow_, _margin_, _padding_, dan transformasi. Ini adalah _widget_ yang sangat sering digunakan karena kemampuannya yang luas untuk _styling_ dan _layout_.
- **`Padding`**: Sebuah _widget_ yang memberikan ruang kosong di sekitar anaknya. Ini adalah cara spesifik untuk menambahkan _padding_ tanpa semua kemampuan lain dari `Container`.

**Konsep Kunci & Filosofi Mendalam:**

- **Box Model:** Konsep bahwa setiap elemen UI adalah kotak yang dapat memiliki _content_, _padding_, _border_, dan _margin_. Ini adalah konsep dasar dalam desain UI web (CSS Box Model) dan juga relevan di Flutter.
- **Separation of Concerns:** `Padding` dan `Container` sering digunakan untuk memisahkan masalah _layout_ (_spacing_) dari masalah _content_ itu sendiri.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

class ContainerPaddingExample extends StatelessWidget {
  const ContainerPaddingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Container & Padding Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 1. Contoh Padding Widget Sederhana
            // Sintaks: Padding({Key? key, required EdgeInsetsGeometry padding, Widget? child})
            // EdgeInsets.all: Padding yang sama di semua sisi.
            // EdgeInsets.symmetric: Padding horizontal dan vertikal yang berbeda.
            // EdgeInsets.only: Padding hanya di sisi tertentu (left, top, right, bottom).
            // Ini adalah bagian dari library Material Design, sering digunakan untuk memberi ruang antar widget.
            Padding(
              padding: const EdgeInsets.all(20.0), // Padding 20 unit di semua sisi
              child: Container(
                color: Colors.blue[100], // Warna latar belakang container
                child: const Text(
                  'Ini adalah teks di dalam Padding.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30), // Memberi jarak antar contoh

            // 2. Contoh Container dengan Padding, Margin, Dekorasi, dan Alignment
            // Sintaks: Container({Key? key, AlignmentGeometry? alignment, EdgeInsetsGeometry? padding,
            //                   Color? color, Decoration? decoration, double? width, double? height,
            //                   BoxConstraints? constraints, EdgeInsetsGeometry? margin, Matrix4? transform, Widget? child})
            // Ini adalah widget serbaguna yang menggabungkan banyak properti styling dan layout.
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20), // Margin di luar container
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Padding di dalam container
              decoration: BoxDecoration(
                color: Colors.deepPurple, // Warna latar belakang
                borderRadius: BorderRadius.circular(15), // Sudut membulat
                border: Border.all(color: Colors.yellow, width: 3), // Border
                boxShadow: const [ // Bayangan
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(5, 5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Text(
                'Container Serbaguna',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),

            // 3. Container sebagai pembungkus dengan lebar dan tinggi tetap
            Container(
              width: 150, // Lebar tetap
              height: 100, // Tinggi tetap
              color: Colors.green,
              alignment: Alignment.center, // Menempatkan child di tengah container
              child: const Text(
                'Kotak Hijau',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ContainerPaddingExample(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **`Padding` Widget**:
  - `padding: const EdgeInsets.all(20.0)`: Properti `padding` menerima objek `EdgeInsetsGeometry`. `EdgeInsets.all(20.0)` berarti memberikan _padding_ 20 unit logis di semua sisi (atas, bawah, kiri, kanan).
  - Objek `EdgeInsets` adalah cara Flutter mendefinisikan _inset_ dari suatu kotak. Ada juga `EdgeInsets.only(left: 10, top: 20)`, `EdgeInsets.symmetric(horizontal: 10, vertical: 20)`.
- **`Container` Widget**:
  - `margin`: Memberikan ruang kosong di _luar_ _border_ `Container`. Mirip dengan CSS `margin`.
  - `padding`: Memberikan ruang kosong di _dalam_ _border_ `Container`, antara _border_ dan kontennya. Mirip dengan CSS `padding`.
  - `decoration`: Properti ini mengambil objek `Decoration` (biasanya `BoxDecoration`) yang memungkinkan Anda untuk:
    - `color`: Warna latar belakang `Container`. Jika `decoration` digunakan, properti `color` langsung di `Container` harus dihilangkan untuk menghindari konflik.
    - `borderRadius`: Membuat sudut membulat.
    - `border`: Menambahkan _border_ di sekitar `Container`.
    - `boxShadow`: Menambahkan bayangan ke `Container`.
  - `width`, `height`: Menentukan ukuran `Container`. Jika tidak ditentukan, `Container` akan mencoba mengambil ukuran sebanyak mungkin atau sekecil yang dibutuhkan anaknya, tergantung pada _parent_ yang membungkusnya.
  - `alignment`: Jika `Container` memiliki ukuran yang lebih besar dari anaknya, properti ini mengontrol bagaimana anak diposisikan di dalam `Container`.

**Visualisasi Diagram Alur/Struktur:**

- Gambaran visual dari Box Model yang diterapkan pada `Container`, menunjukkan area _margin_, _border_, _padding_, dan _content_.
- Contoh _screenshot_ aplikasi yang menunjukkan perbedaan antara _padding_ dan _margin_ secara visual.

**Terminologi Esensial & Penjelasan Detail:**

- **Container:** _Widget_ serbaguna untuk _styling_ dan _layout_.
- **Padding:** Ruang kosong di antara batas _widget_ dan konten anaknya.
- **Margin:** Ruang kosong di antara batas _widget_ dan _widget_ tetangga.
- **BoxDecoration:** Kelas yang digunakan dengan `Container` untuk menambahkan dekorasi seperti warna, _border_, _borderRadius_, dan _boxShadow_.
- **EdgeInsets:** Kelas untuk menentukan _inset_ (jarak) di berbagai sisi.
  - `EdgeInsets.all()`: Sama di semua sisi.
  - `EdgeInsets.symmetric()`: Sama secara horizontal/vertikal.
  - `EdgeInsets.only()`: Spesifik untuk satu atau lebih sisi.

**Sumber Referensi Lengkap:**

- [Container Class (API Docs)](https://api.flutter.dev/flutter/widgets/Container-class.html)
- [Padding Class (API Docs)](https://api.flutter.dev/flutter/widgets/Padding-class.html)
- [BoxDecoration Class (API Docs)](https://api.flutter.dev/flutter/painting/BoxDecoration-class.html)
- [Mastering Container Widget in Flutter](https://medium.com/flutter-community/mastering-container-widget-in-flutter-b27cf17b96)
- [Flutter Widgets: Container and Padding](https://www.youtube.com/watch%3Fv%3DR9C5J2P22vQ)

**Tips dan Praktik Terbaik:**

- **Jangan Tumpang Tindih `color` dan `decoration.color`:** Jika Anda menggunakan `decoration` di `Container`, tentukan warna di dalam `decoration` (misalnya `BoxDecoration(color: Colors.blue)`) dan jangan setel properti `color` langsung di `Container` untuk menghindari _runtime error_.
- **Gunakan `Padding` untuk Padding Sederhana:** Jika Anda hanya butuh _padding_ tanpa _styling_ lain, `Padding` _widget_ lebih efisien daripada `Container` karena lebih ringan.
- **Pahami Batasan `Container`:** `Container` akan mencoba menyesuaikan ukurannya dengan anaknya jika tidak ada batasan yang diberikan. Jika Anda ingin `Container` mengisi ruang kosong, bungkuslah dengan `Expanded` (akan dibahas nanti) atau berikan `width`/`height` eksplisit.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `color` dan `decoration` keduanya disetel di `Container`.

  - **Penyebab:** Ini menyebabkan konflik karena `decoration` sudah bertanggung jawab untuk melukis latar belakang.
  - **Solusi:** Hapus properti `color` langsung dari `Container` jika Anda menggunakan `decoration`. Setel warna di dalam `BoxDecoration` sebagai gantinya.

- **Kesalahan:** `Container` tidak memenuhi ruang yang diharapkan atau terlalu kecil/besar.

  - **Penyebab:** Konsep _constraints go down, sizes go up_ belum sepenuhnya dipahami. `Container` tanpa `width`/`height` atau `constraints` akan mencoba beradaptasi dengan anaknya atau _parent_-nya.
  - **Solusi:** Periksa _parent widget_ yang membungkus `Container`. Jika Anda ingin `Container` mengisi semua ruang yang tersedia, bungkuslah dengan `Expanded` (jika di dalam `Row`/`Column`) atau setel `width: double.infinity` dan `height: double.infinity` (jika _parent_ mengizinkannya, misalnya `Center`). Jika Anda ingin ukuran spesifik, setel `width` dan `height` secara eksplisit.

---

#### 2.2.2 Row and Column (Flexbox Concepts)

Sub-bagian ini adalah tentang mengatur _widget_ secara linear, baik horizontal maupun vertikal. Ini adalah salah satu _widget layout_ paling sering digunakan dan mendasari banyak desain UI.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan diperkenalkan pada `Row` dan `Column`, dua _widget_ yang dirancang untuk menata banyak anak (_children_) dalam satu dimensi (horizontal untuk `Row`, vertikal untuk `Column`). Konsep-konsep dari Flexbox (seperti yang ditemukan di CSS) akan sangat relevan di sini, termasuk bagaimana mengontrol penyelarasan (_alignment_) anak-anak di sepanjang sumbu utama (`mainAxisAlignment`) dan sumbu silang (`crossAxisAlignment`), serta bagaimana mendistribusikan ruang kosong. Penguasaan `Row` dan `Column` sangat penting karena hampir setiap UI melibatkan pengaturan linear dari elemen-elemen.

**Konsep Kunci & Filosofi Mendalam:**

- **Sumbu Utama (Main Axis) & Sumbu Silang (Cross Axis):**

  - **Row:** Sumbu utama adalah horizontal, sumbu silang adalah vertikal.
  - **Column:** Sumbu utama adalah vertikal, sumbu silang adalah horizontal.
  - **Filosofi:** Pemisahan sumbu ini memungkinkan kontrol granular atas _layout_ dalam dua dimensi yang berbeda. Ini adalah konsep dasar dalam Flexbox yang diadopsi Flutter.

- **MainAxisAlignment & CrossAxisAlignment:** Properti ini mengontrol bagaimana anak-anak dalam `Row` atau `Column` diposisikan dan didistribusikan di sepanjang sumbu utama dan sumbu silang.

  - **Filosofi:** Memberikan fleksibilitas dalam menata _widget_ tanpa harus menghitung posisi piksel secara manual, memungkinkan desain responsif yang mudah beradaptasi.

- **MainAxisSize & CrossAxisSize:** Properti ini mengontrol seberapa banyak ruang yang akan diambil oleh `Row` atau `Column` itu sendiri di sepanjang sumbu utama dan sumbu silang.

  - **Filosofi:** Memberikan kontrol atas ukuran _widget container_ itu sendiri, bukan hanya posisi anak-anaknya.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

class RowColumnExample extends StatelessWidget {
  const RowColumnExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row & Column Demo')),
      body: SingleChildScrollView( // Agar konten bisa discroll jika melebihi layar
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Column mengambil lebar penuh
            children: <Widget>[
              // 1. Contoh Row
              // Sintaks: Row({Key? key, MainAxisAlignment mainAxisAlignment,
              //                MainAxisSize mainAxisSize, CrossAxisAlignment crossAxisAlignment,
              //                TextDirection? textDirection, VerticalDirection verticalDirection,
              //                Clip clipBehavior, List<Widget> children = const []})
              // Digunakan untuk menata widget secara horizontal.
              const Text('Contoh Row:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                color: Colors.blue[100],
                padding: const EdgeInsets.all(8.0),
                height: 100, // Memberi tinggi agar efek alignment terlihat
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround, // Meratakan anak-anak di sumbu utama dengan ruang di antara dan di sekitar
                  crossAxisAlignment: CrossAxisAlignment.center,    // Meratakan anak-anak di tengah sumbu silang
                  children: <Widget>[
                    Container(width: 50, height: 50, color: Colors.red, child: const Center(child: Text('A'))),
                    Container(width: 50, height: 30, color: Colors.green, child: const Center(child: Text('B'))),
                    Container(width: 50, height: 70, color: Colors.purple, child: const Center(child: Text('C'))),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Contoh Column
              // Sintaks: Column({Key? key, MainAxisAlignment mainAxisAlignment,
              //                 MainAxisSize mainAxisSize, CrossAxisAlignment crossAxisAlignment,
              //                 TextDirection? textDirection, VerticalDirection verticalDirection,
              //                 Clip clipBehavior, List<Widget> children = const []})
              // Digunakan untuk menata widget secara vertikal.
              const Text('Contoh Column:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                color: Colors.orange[100],
                padding: const EdgeInsets.all(8.0),
                width: 200, // Memberi lebar agar efek alignment terlihat
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Meratakan anak-anak di sumbu utama dengan ruang di antara
                  crossAxisAlignment: CrossAxisAlignment.start,     // Meratakan anak-anak di awal sumbu silang
                  children: <Widget>[
                    Container(width: 70, height: 50, color: Colors.yellow, child: const Center(child: Text('1'))),
                    Container(width: 90, height: 50, color: Colors.brown, child: const Center(child: Text('2'))),
                    Container(width: 60, height: 50, color: Colors.teal, child: const Center(child: Text('3'))),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. MainAxisSize
              const Text('Contoh MainAxisSize:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Row mengambil ruang sesedikit mungkin di sumbu utama
                  children: <Widget>[
                    Container(width: 40, height: 40, color: Colors.cyan, child: const Center(child: Text('X'))),
                    Container(width: 40, height: 40, color: Colors.pink, child: const Center(child: Text('Y'))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(8.0),
                width: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.max, // Column mengambil ruang sebanyak mungkin di sumbu utama (default)
                  children: <Widget>[
                    Container(width: 40, height: 40, color: Colors.deepOrange, child: const Center(child: Text('P'))),
                    Container(width: 40, height: 40, color: Colors.indigo, child: const Center(child: Text('Q'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RowColumnExample(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **`Row` dan `Column`**: Keduanya adalah _widget_ yang menerima daftar `children` (`List<Widget>`).
- **`mainAxisAlignment`**: Mengatur bagaimana anak-anak diposisikan sepanjang sumbu utama.
  - `MainAxisAlignment.start`: Anak-anak di awal sumbu.
  - `MainAxisAlignment.end`: Anak-anak di akhir sumbu.
  - `MainAxisAlignment.center`: Anak-anak di tengah sumbu.
  - `MainAxisAlignment.spaceBetween`: Anak-anak didistribusikan secara merata di sepanjang sumbu, dengan ruang kosong di antara mereka.
  - `MainAxisAlignment.spaceAround`: Anak-anak didistribusikan secara merata di sepanjang sumbu, dengan ruang kosong yang sama di sekitar mereka.
  - `MainAxisAlignment.spaceEvenly`: Anak-anak didistribusikan secara merata di sepanjang sumbu, dengan ruang kosong yang sama di antara mereka dan juga di awal serta akhir.
- **`crossAxisAlignment`**: Mengatur bagaimana anak-anak diposisikan sepanjang sumbu silang.
  - `CrossAxisAlignment.start`: Anak-anak di awal sumbu silang.
  - `CrossAxisAlignment.end`: Anak-anak di akhir sumbu silang.
  - `CrossAxisAlignment.center`: Anak-anak di tengah sumbu silang (default).
  - `CrossAxisAlignment.stretch`: Anak-anak membentang untuk mengisi sumbu silang jika memungkinkan (membutuhkan batasan yang fleksibel pada anak).
- **`mainAxisSize`**: Mengatur seberapa banyak ruang yang akan diambil oleh `Row` atau `Column` di sepanjang sumbu utamanya.
  - `MainAxisSize.max`: Mengambil ruang sebanyak mungkin di sepanjang sumbu utama (default untuk `Column`).
  - `MainAxisSize.min`: Mengambil ruang sesedikit mungkin di sepanjang sumbu utama, hanya cukup untuk menampung anak-anaknya (default untuk `Row` jika tidak ada batasan `width` atau `height` yang lebih besar dari _parent_).
- **`SingleChildScrollView`**: Digunakan untuk memastikan seluruh konten dapat di-scroll jika melebihi ukuran layar, sangat membantu saat bereksperimen dengan _layout_ yang tinggi atau lebar.
- **`CrossAxisAlignment.stretch`**: Perhatikan bahwa jika Anda menggunakan `CrossAxisAlignment.stretch` pada `Column`, anak-anaknya akan mencoba mengisi lebar penuh dari `Column` tersebut. Demikian pula untuk `Row`, anak-anak akan mencoba mengisi tinggi penuh `Row`. Namun, anak-anak harus memiliki batasan fleksibel (misalnya, tanpa `width` atau `height` tetap) agar _stretch_ ini berfungsi.

**Visualisasi Diagram Alur/Struktur:**

- Ilustrasi grafis dari `Row` dengan panah yang menunjukkan sumbu utama (horizontal) dan sumbu silang (vertikal). Ulangi untuk `Column` (sumbu utama vertikal, sumbu silang horizontal).
- Visualisasi setiap opsi `MainAxisAlignment` (start, end, center, spaceAround, spaceBetween, spaceEvenly) dengan beberapa kotak di dalamnya.
- Visualisasi setiap opsi `CrossAxisAlignment` (start, end, center, stretch) dengan beberapa kotak di dalamnya.

**Terminologi Esensial & Penjelasan Detail:**

- **Row:** Widget yang menata anak-anaknya dalam satu baris horizontal.
- **Column:** Widget yang menata anak-anaknya dalam satu kolom vertikal.
- **Main Axis:** Sumbu utama di mana anak-anak diatur (horizontal untuk `Row`, vertikal untuk `Column`).
- **Cross Axis:** Sumbu tegak lurus terhadap sumbu utama (vertikal untuk `Row`, horizontal untuk `Column`).
- **MainAxisAlignment:** Kontrol penempatan anak di sepanjang sumbu utama.
- **CrossAxisAlignment:** Kontrol penempatan anak di sepanjang sumbu silang.
- **MainAxisSize:** Kontrol seberapa banyak ruang yang diambil oleh `Row`/`Column` itu sendiri di sepanjang sumbu utama.

**Sumber Referensi Lengkap:**

- [Row Class (API Docs)](https://api.flutter.dev/flutter/widgets/Row-class.html)
- [Column Class (API Docs)](https://api.flutter.dev/flutter/widgets/Column-class.html)
- [Flex Widget (Underlying Row/Column, API Docs)](https://api.flutter.dev/flutter/widgets/Flex-class.html)
- [Flexbox: The Ultimate Guide (CSS-Tricks, konsepnya sama)](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)
- [Flutter Layout Cheat Sheet](https://docs.flutter.dev/ui/layout/layout-cheat-sheet)

**Tips dan Praktik Terbaik:**

- **Nested Rows/Columns:** Ini sangat umum. Anda akan sering memiliki `Column` yang berisi `Row`, yang pada gilirannya berisi `Column` lagi, dan seterusnya. Pahami bagaimana _constraints_ mengalir di setiap level.
- **Gunakan Visual Debugger:** Gunakan Flutter DevTools (Widget Inspector dan Layout Explorer) untuk memvisualisasikan bagaimana `Row` dan `Column` bekerja secara _real-time_ dan men-debug masalah _layout_. Ini adalah alat yang sangat ampuh.
- **Perhatikan Overflow:** Jika total lebar atau tinggi anak-anak dalam `Row` atau `Column` melebihi ruang yang tersedia, Anda akan mendapatkan _overflow error_ (garis kuning-hitam). Gunakan `Expanded` atau `Flexible` (akan dibahas di sub-bagian selanjutnya) untuk mengatasi ini.
- **Jangan Berikan Ukuran Tidak Terbatas:** `Row` tidak dapat memiliki anak `Column` yang tingginya tak terbatas (misalnya, `ListView` langsung di dalam `Column` tanpa `Expanded`), karena `Row` tidak memberikan batasan tinggi pada anak-anaknya. Demikian pula untuk `Column` dan lebar tak terbatas. Dalam kasus ini, Anda perlu `Expanded` atau ukuran eksplisit.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** _Overflow error_ (garis kuning-hitam) di `Row` atau `Column`.

  - **Penyebab:** Anak-anak dalam `Row` atau `Column` mencoba mengambil lebih banyak ruang daripada yang tersedia di sumbu utama mereka.
  - **Solusi:** Gunakan `Expanded` atau `Flexible` pada anak-anak yang harus mengambil sisa ruang. Atau, pastikan Anda memberikan batasan yang memadai pada _parent_ dari `Row`/`Column` itu sendiri.

- **Kesalahan:** Anak-anak dalam `Row` atau `Column` tidak terdistribusi atau tidak sejajar seperti yang diharapkan.

  - **Penyebab:** Salah pemahaman `mainAxisAlignment` atau `crossAxisAlignment`, atau `mainAxisSize` diatur ke `min` ketika seharusnya `max` (atau sebaliknya).
  - **Solusi:** Eksperimen dengan berbagai nilai `mainAxisAlignment` dan `crossAxisAlignment`. Pastikan `mainAxisSize` diatur dengan benar. Ingat bahwa `MainAxisAlignment` bekerja di sepanjang sumbu utama, dan `CrossAxisAlignment` di sepanjang sumbu silang.

- **Kesalahan:** `Column` mengambil lebar penuh layar meskipun anak-anaknya sempit, atau `Row` mengambil tinggi penuh layar meskipun anak-anaknya pendek.

  - **Penyebab:** Secara _default_, `Column` akan mencoba memperluas dirinya di sepanjang sumbu silang (lebar) sejauh _constraints_ mengizinkan, dan `Row` akan memperluas dirinya di sepanjang sumbu silang (tinggi) sejauh _constraints_ mengizinkan.
  - **Solusi:** Setel `crossAxisAlignment` ke `CrossAxisAlignment.start` atau `CrossAxisAlignment.center` untuk mencegah `stretch` di sumbu silang. Atau, jika Anda memang ingin `stretch` tetapi tidak sejauh itu, bungkus `Row`/`Column` dalam `Align` atau `Center` atau berikan batasan `width`/`height` eksplisit pada `Row`/`Column` itu sendiri.

---

#### 2.2.3 Stack, Expanded, and Flexible

Sub-bagian ini akan memperkenalkan tiga _widget layout_ yang sangat berguna untuk menangani _layout_ kompleks: menumpuk _widget_ satu di atas yang lain, dan bagaimana _widget_ dapat mengisi ruang yang tersedia dalam tata letak linear.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari:

- **`Stack`**: Sebuah _widget_ yang memungkinkan Anda untuk melapisi _widget_ satu di atas yang lain di sepanjang sumbu Z (kedalaman), mirip dengan konsep _layers_ di perangkat lunak desain grafis. Ini sangat berguna untuk menempatkan teks di atas gambar, tombol di sudut layar, atau efek _parallax_.
- **`Expanded`**: Sebuah _widget_ yang memungkinkan anak dalam `Row` atau `Column` untuk mengisi semua ruang yang tersedia di sepanjang sumbu utama. Ini adalah solusi umum untuk _overflow error_ dan membuat tata letak yang responsif.
- **`Flexible`**: Mirip dengan `Expanded`, tetapi memberikan lebih banyak fleksibilitas dalam cara anak mengisi ruang. `Flexible` memungkinkan anak untuk tumbuh atau menyusut, tetapi tidak selalu mengisi semua ruang yang tersedia.

Penguasaan ketiga _widget_ ini sangat penting untuk membuat desain UI yang kompleks, dinamis, dan responsif, mengatasi batasan _layout_ dasar `Row` dan `Column`.

**Konsep Kunci & Filosofi Mendalam:**

- **Z-Axis Positioning (Stack):** Flutter umumnya merender _widget_ dalam urutan dari atas ke bawah (dalam `Column`) atau kiri ke kanan (dalam `Row`). `Stack` adalah pengecualian, memungkinkan Anda untuk secara eksplisit menempatkan _widget_ di atas yang lain, menciptakan efek kedalaman.

  - **Filosofi:** Memberikan dimensi ketiga ke _layout_, memungkinkan overlay UI yang kompleks dan elemen yang saling tumpang tindih.

- **Flex Factor (Expanded & Flexible):** Konsep yang berasal dari Flexbox, di mana _child_ dapat "mengembangkan" atau "menyusut" dalam proporsi tertentu terhadap ruang yang tersedia.

  - **Filosofi:** Memungkinkan _layout_ yang responsif dan fluid, di mana elemen-elemen secara otomatis menyesuaikan ukuran mereka berdasarkan ruang yang tersedia, tanpa perlu menghitung dimensi absolut. Ini adalah kunci untuk mengatasi masalah _overflow_ di `Row` dan `Column`.

- **Loose vs. Tight Constraints:**

  - `Expanded` memberikan batasan yang ketat (`tight`) pada anaknya, memaksa anak untuk mengambil semua ruang yang tersedia (sesuai _flex_ factor).
  - `Flexible` memberikan batasan yang longgar (`loose`) pada anaknya, memungkinkan anak untuk memilih ukurannya sendiri (hingga ruang maksimum yang tersedia).
  - **Filosofi:** Perbedaan ini adalah kunci untuk memahami perilaku `Expanded` dan `Flexible`. Ini menunjukkan bagaimana Flutter mengelola _layout_ dengan melewatkan batasan ke bawah dan menerima ukuran dari bawah ke atas.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

class StackExpandedFlexibleExample extends StatelessWidget {
  const StackExpandedFlexibleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stack, Expanded, Flexible Demo')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 1. Contoh Stack
              // Sintaks: Stack({Key? key, AlignmentGeometry alignment, TextDirection? textDirection,
              //                  StackFit fit, Clip clipBehavior, List<Widget> children = const []})
              // Digunakan untuk menumpuk widget satu di atas yang lain.
              const Text('Contoh Stack:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 200,
                color: Colors.grey[200],
                child: Stack(
                  alignment: Alignment.center, // Menyelaraskan semua anak di tengah Stack
                  children: <Widget>[
                    Container(width: 150, height: 150, color: Colors.blue), // Paling bawah
                    Positioned( // Mengontrol posisi anak secara eksplisit dalam Stack
                      top: 20,
                      left: 20,
                      child: Container(width: 100, height: 100, color: Colors.red), // Di atas biru
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(width: 70, height: 70, color: Colors.green), // Di atas merah
                    ),
                    const Align( // Menyelaraskan anak di posisi tertentu tanpa ukuran eksplisit
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Overlay Text',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2. Contoh Expanded
              // Sintaks: Expanded({Key? key, int flex = 1, required Widget child})
              // Digunakan dalam Row atau Column untuk membuat anak mengisi ruang yang tersisa.
              const Text('Contoh Expanded:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                color: Colors.yellow[100],
                child: Row(
                  children: <Widget>[
                    Container(width: 80, height: 80, color: Colors.orange, child: const Center(child: Text('Fixed'))),
                    Expanded( // Anak ini akan mengambil sisa ruang yang tersedia
                      flex: 2, // Mengambil 2 unit dari total flex
                      child: Container(height: 80, color: Colors.lightGreen, child: const Center(child: Text('Expanded (Flex 2)'))),
                    ),
                    Expanded( // Anak ini akan mengambil sisa ruang yang tersedia
                      flex: 1, // Mengambil 1 unit dari total flex
                      child: Container(height: 80, color: Colors.cyan, child: const Center(child: Text('Expanded (Flex 1)'))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 3. Contoh Flexible
              // Sintaks: Flexible({Key? key, int flex = 1, FlexFit fit = FlexFit.loose, required Widget child})
              // Mirip Expanded, tetapi anak tidak dipaksa mengisi semua ruang yang tersedia.
              const Text('Contoh Flexible:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                color: Colors.pink[100],
                child: Row(
                  children: <Widget>[
                    Container(width: 80, height: 80, color: Colors.redAccent, child: const Center(child: Text('Fixed'))),
                    Flexible( // Anak ini akan menyusut jika tidak ada cukup ruang, tapi tidak akan membesar melebihi kontennya
                      flex: 1,
                      fit: FlexFit.loose, // Default. Memungkinkan anak untuk menjadi sekecil yang dibutuhkan.
                      child: Container(
                        // width: 200, // Jika diberi width, Flexible akan menghormatinya sampai batas tertentu
                        height: 80,
                        color: Colors.blueAccent,
                        child: const Center(child: Text('Flexible (Loose)')),
                      ),
                    ),
                    Flexible( // Anak ini akan dipaksa mengisi ruang yang tersedia (mirip Expanded)
                      flex: 1,
                      fit: FlexFit.tight, // Mirip dengan Expanded
                      child: Container(
                        height: 80,
                        color: Colors.purpleAccent,
                        child: const Center(child: Text('Flexible (Tight)')),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 4. Perbandingan Expanded vs Flexible (Loose)
              const Text('Perbandingan Expanded vs Flexible (Loose):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(width: 60, height: 60, color: Colors.teal),
                    Expanded(
                      child: Container(
                        height: 60,
                        color: Colors.indigo,
                        child: const Center(child: Text('Expanded: fills remaining space')),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        height: 60,
                        color: Colors.lime,
                        child: const Center(child: Text('Flexible (Loose): only takes needed space')),
                      ),
                    ),
                    Container(width: 60, height: 60, color: Colors.brown),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: StackExpandedFlexibleExample(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **`Stack`**:

  - `alignment`: Mengontrol bagaimana anak-anak yang tidak diposisikan (yaitu, tidak dibungkus dengan `Positioned`) disejajarkan di dalam `Stack`.
  - `children`: Daftar _widget_ yang akan ditumpuk. Urutan di sini penting; _widget_ yang terakhir dalam daftar akan berada di paling atas.
  - **`Positioned`**: Sebuah _widget_ yang hanya berfungsi sebagai anak dari `Stack`. Ini memungkinkan Anda untuk menempatkan anaknya secara eksplisit menggunakan properti `top`, `bottom`, `left`, `right`, `width`, dan `height`.
  - **`Align`**: Mirip dengan `Positioned` tetapi lebih untuk _alignment_ relatif terhadap _Stack_ tanpa perlu menentukan ukuran atau koordinat pasti. Anaknya akan mengambil ukuran yang dibutuhkan.

- **`Expanded`**:

  - `flex`: Sebuah bilangan bulat yang menunjukkan seberapa banyak ruang yang harus diambil oleh _widget_ ini relatif terhadap _Expanded_ lainnya dalam `Row` atau `Column`. Misalnya, `flex: 2` berarti mengambil dua kali lipat ruang dari `flex: 1`. Jika tidak ditentukan, `flex` default-nya adalah `1`.
  - Ketika Anda membungkus _widget_ di dalam `Expanded`, _widget_ tersebut akan dipaksa untuk mengisi ruang yang tersisa di sepanjang sumbu utama dari `Row` atau `Column`-nya. Ini adalah solusi utama untuk _overflow error_.

- **`Flexible`**:

  - `flex`: Sama dengan `Expanded`.
  - `fit`: Mengontrol bagaimana anak `Flexible` akan menggunakan ruang.
    - `FlexFit.loose` (default): Anak dapat menjadi sekecil yang dibutuhkan tetapi tidak akan lebih besar dari ruang yang dialokasikan oleh _flex factor_.
    - `FlexFit.tight`: Anak dipaksa untuk mengisi semua ruang yang dialokasikan oleh _flex factor_, mirip dengan perilaku `Expanded`.
  - Perbedaan utama dengan `Expanded` adalah bahwa `Flexible` dengan `FlexFit.loose` memungkinkan anaknya untuk menjadi lebih kecil dari ruang yang dialokasikan jika anaknya tidak memerlukan seluruh ruang tersebut. `Expanded` (yang setara dengan `Flexible(fit: FlexFit.tight)`) akan selalu memaksa anaknya untuk mengisi seluruh ruang yang dialokasikan.

**Visualisasi Diagram Alur/Struktur:**

- **Stack:** Diagram visual yang menunjukkan tiga kotak berwarna yang ditumpuk, dengan properti `Positioned` dan `Align` yang mengontrol penempatannya.
- **Expanded/Flexible:** Ilustrasi `Row` dengan beberapa kotak. Satu kotak memiliki lebar tetap, yang lain adalah `Expanded` mengisi sisa ruang, dan yang ketiga adalah `Flexible` yang hanya mengambil ruang yang dibutuhkan. Tunjukkan bagaimana ruang dibagi berdasarkan `flex` factor.

**Terminologi Esensial & Penjelasan Detail:**

- **Stack:** _Widget_ yang melapisi anak-anaknya satu di atas yang lain.
- **Positioned:** _Widget_ yang digunakan dalam `Stack` untuk menempatkan anaknya pada koordinat tertentu.
- **Align:** _Widget_ yang digunakan dalam `Stack` untuk menyelaraskan anaknya relatif terhadap _Stack_.
- **Expanded:** _Widget_ yang memaksa anaknya untuk mengisi ruang yang tersisa dalam `Row` atau `Column` di sepanjang sumbu utama.
- **Flexible:** Mirip dengan `Expanded`, tetapi memungkinkan anaknya untuk memilih ukuran yang lebih kecil dari ruang yang tersedia jika diatur ke `FlexFit.loose`.
- **Flex Factor (`flex`):** Nilai numerik yang menentukan seberapa besar proporsi ruang yang akan diambil oleh `Expanded` atau `Flexible` relatif terhadap _widget_ fleksibel lainnya.
- **FlexFit (`fit`):** Properti dari `Flexible` yang mengontrol bagaimana anak mengisi ruang yang dialokasikan (`loose` atau `tight`).

**Sumber Referensi Lengkap:**

- [Stack Class (API Docs)](https://api.flutter.dev/flutter/widgets/Stack-class.html)
- [Positioned Class (API Docs)](https://api.flutter.dev/flutter/widgets/Positioned-class.html)
- [Expanded Class (API Docs)](https://api.flutter.dev/flutter/widgets/Expanded-class.html)
- [Flexible Class (API Docs)](https://api.flutter.dev/flutter/widgets/Flexible-class.html)
- [Flutter Layout Cheat Sheet](https://docs.flutter.dev/ui/layout/layout-cheat-sheet)
- [Expanded vs Flexible in Flutter](https://www.woolha.com/tutorials/flutter-expanded-flexible-widgets)

**Tips dan Praktik Terbaik:**

- **Prioritaskan `Expanded` untuk Mengisi Ruang:** Jika Anda ingin _widget_ mengisi semua ruang yang tersisa dan tidak ada kemungkinan _overflow_, gunakan `Expanded`. Ini adalah kasus penggunaan yang paling umum.
- **Gunakan `Flexible` untuk Kontrol Ukuran Konten:** Jika Anda ingin _widget_ tumbuh hingga batas tertentu tetapi juga bisa menyusut agar pas dengan kontennya (misalnya, `Text` yang akan membungkus jika terlalu panjang), gunakan `Flexible` dengan `FlexFit.loose`.
- **Hati-hati dengan `Positioned` di `Stack`:** Anak-anak `Positioned` di dalam `Stack` tidak akan merespons _flex_ atau _alignment_ dari `Stack`. Mereka akan diposisikan secara mutlak.
- **Kombinasikan dengan `Align` di `Stack`:** Jika Anda ingin anak di `Stack` memiliki ukuran aslinya tetapi diposisikan relatif terhadap _Stack_ (misalnya di sudut atau tengah), gunakan `Align` sebagai pembungkus.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** _Overflow error_ saat menggunakan `Row` atau `Column` dan anak-anaknya tidak fleksibel.

  - **Penyebab:** Anak-anak dalam `Row` atau `Column` mencoba mengambil lebih banyak ruang daripada yang tersedia, dan tidak ada _widget_ fleksibel yang diberi tugas untuk mengonsumsi sisa ruang atau menyusut.
  - **Solusi:** Bungkus _widget_ yang ingin Anda fleksibelkan dengan `Expanded` atau `Flexible`. Ini adalah solusi paling umum untuk _overflow_ di tata letak linear.

- **Kesalahan:** `Expanded` atau `Flexible` tidak berfungsi seperti yang diharapkan (misalnya tidak mengisi ruang).

  - **Penyebab:** `Expanded` dan `Flexible` hanya berfungsi sebagai anak langsung dari _widget_ yang memiliki _multi-child layout_ yang berbasis `Flex` (seperti `Row`, `Column`, `Flex`). Mereka tidak akan berfungsi di dalam _widget_ lain seperti `Container` yang hanya memiliki satu anak.
  - **Solusi:** Pastikan `Expanded` atau `Flexible` adalah anak langsung dari `Row` atau `Column`.

- **Kesalahan:** Anak dalam `Stack` tidak tumpang tindih seperti yang diharapkan.

  - **Penyebab:** Urutan anak dalam daftar `children` di `Stack` menentukan urutan tumpukan (yang terakhir di daftar adalah yang paling atas).
  - **Solusi:** Atur ulang urutan anak-anak dalam daftar `children` dari `Stack` sesuai dengan lapisan yang diinginkan.

---

#### 2.2.4 Centering and Alignment

Sub-bagian ini akan berfokus pada cara memposisikan dan menyelaraskan _widget_ di dalam _parent widget_ mereka. Ini adalah tugas _layout_ yang sangat umum dan penting untuk mencapai desain UI yang rapi dan estetis.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari berbagai cara untuk menengahkan (_center_) dan menyelaraskan (_align_) _widget_ di Flutter. Meskipun `Row` dan `Column` memiliki `mainAxisAlignment` dan `crossAxisAlignment`, ada _widget_ lain yang secara khusus dirancang untuk tujuan _centering_ dan _alignment_ yang lebih umum, atau untuk menangani kasus di mana _parent_ tidak menyediakan properti _alignment_. Ini termasuk `Center` _widget_ dan `Align` _widget_, serta properti `alignment` pada `Container`. Pemahaman mendalam tentang bagaimana _widget_ ini berinteraksi dengan sistem _constraints_ Flutter akan memungkinkan pembelajar untuk menguasai tata letak yang presisi.

**Konsep Kunci & Filosofi Mendalam:**

- **Parent-Driven Layout:** Di Flutter, ukuran dan posisi _child widget_ sangat dipengaruhi oleh _parent widget_. `Center` dan `Align` adalah contoh _widget_ yang memanfaatkan mekanisme ini untuk memposisikan anak-anaknya.

  - **Filosofi:** Menegaskan kembali aturan "Constraints Go Down, Sizes Go Up, Parent Sets Position". _Parent_ bertanggung jawab untuk memposisikan _child_ di dalam dirinya sendiri, dan `Center`/`Align` adalah _parent_ khusus yang hanya memiliki satu tujuan: memposisikan anaknya.

- **Alignment as a Transform:** Ketika sebuah _widget_ di-_align_, itu seperti menerapkan sebuah "transformasi" pada posisi _default_-nya di dalam ruang yang dialokasikan oleh _parent_.

  - **Filosofi:** Memberikan kontrol yang tepat atas penempatan spasial tanpa perlu perhitungan koordinat piksel yang rumit, memungkinkan fleksibilitas dalam desain responsif.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

class CenteringAlignmentExample extends StatelessWidget {
  const CenteringAlignmentExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Centering & Alignment Demo')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 1. Contoh Center Widget
            // Sintaks: Center({Key? key, double? widthFactor, double? heightFactor, Widget? child})
            // Menempatkan anaknya di tengah area yang tersedia. Akan mengambil ruang sebanyak mungkin
            // jika tidak ada batasan dari parent yang membatasi ukurannya.
            // Ini adalah widget layout yang paling sederhana untuk menengahkan.
            const Text('1. Center Widget:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 150,
              width: double.infinity, // Ambil lebar penuh
              color: Colors.blue[100],
              child: const Center(
                child: Text(
                  'Teks di Tengah',
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Contoh Align Widget
            // Sintaks: Align({Key? key, AlignmentGeometry alignment, double? widthFactor, double? heightFactor, Widget? child})
            // Menyelaraskan anaknya dalam ruang yang tersedia. `alignment` menggunakan koordinat
            // dari -1.0 (kiri/atas) hingga 1.0 (kanan/bawah). Default adalah Alignment.center (0.0, 0.0).
            // Mirip dengan Center, tetapi lebih fleksibel.
            const Text('2. Align Widget:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.green[100],
              child: Align(
                alignment: Alignment.bottomRight, // Menempatkan anak di kanan bawah
                child: Container(
                  width: 80,
                  height: 40,
                  color: Colors.green,
                  child: const Center(child: Text('BR', style: TextStyle(color: Colors.white))),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Contoh Container.alignment (properti alignment di Container)
            // Sintaks: Container({..., AlignmentGeometry? alignment, ...})
            // Jika Container memiliki ruang lebih besar dari anaknya, ia dapat menyelaraskan anaknya.
            const Text('3. Container.alignment:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.orange[100],
              alignment: Alignment.topLeft, // Menyelaraskan anak di kiri atas dalam Container
              child: Container(
                width: 70,
                height: 70,
                color: Colors.orange,
                child: const Center(child: Text('TL', style: TextStyle(color: Colors.white))),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Contoh MainAxisAlignment dan CrossAxisAlignment di Row/Column
            // (Sudah dibahas di 2.2.2, namun relevan sebagai metode alignment)
            const Text('4. Row/Column Alignment:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.purple[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribusi vertikal
                crossAxisAlignment: CrossAxisAlignment.end,     // Penyelarasan horizontal (kanan)
                children: <Widget>[
                  Container(width: 50, height: 50, color: Colors.purple),
                  Container(width: 70, height: 50, color: Colors.purple.shade300),
                  Container(width: 60, height: 50, color: Colors.purple.shade500),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Centering dengan Stack dan Positioned
            // (Sudah dibahas di 2.2.3, namun relevan sebagai metode alignment)
            const Text('5. Stack & Positioned Centering:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.teal[100],
              child: Stack(
                children: <Widget>[
                  // Menggunakan Align di dalam Stack untuk menengahkan anak
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.teal,
                      child: const Center(child: Text('Center', style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  // Atau menggunakan Positioned dengan top, bottom, left, right 0
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center( // Center di dalam Positioned untuk menengahkan child
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.redAccent,
                        child: const Center(child: Text('Inner', style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: CenteringAlignmentExample(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **`Center`**:

  - Jika Anda hanya perlu menengahkan satu _child_ di dalam ruang yang tersedia, `Center` adalah pilihan paling sederhana dan umum.
  - Secara _default_, `Center` akan mengambil sebanyak mungkin ruang yang diizinkan oleh _parent_-nya di kedua sumbu, lalu menengahkan anaknya di dalamnya.
  - `widthFactor` dan `heightFactor` dapat digunakan untuk membatasi ukuran `Center` itu sendiri menjadi kelipatan ukuran anaknya.

- **`Align`**:

  - Lebih fleksibel daripada `Center` karena Anda dapat menentukan posisi _alignment_ yang spesifik menggunakan objek `AlignmentGeometry`.
  - `Alignment(x, y)`: `x` dan `y` adalah nilai antara -1.0 dan 1.0. `(-1.0, -1.0)` adalah kiri atas, `(1.0, 1.0)` adalah kanan bawah, dan `(0.0, 0.0)` adalah tengah. Ada juga konstanta siap pakai seperti `Alignment.topLeft`, `Alignment.centerRight`, dll.
  - Seperti `Center`, `Align` akan mencoba mengambil ruang sebanyak mungkin yang diizinkan oleh _parent_-nya.

- **`Container.alignment`**:

  - Jika Anda sudah menggunakan `Container` untuk _styling_ (warna, _padding_, dll.), Anda bisa menggunakan properti `alignment`-nya untuk menyelaraskan anaknya tanpa perlu membungkusnya lagi dengan `Center` atau `Align`.
  - Properti ini hanya berlaku jika `Container` memiliki ruang yang lebih besar dari anaknya.

- **`Row`/`Column` (`mainAxisAlignment`, `crossAxisAlignment`):**

  - Ini adalah metode _alignment_ untuk skenario _multi-child_ linear. Mereka mengatur bagaimana anak-anak ditempatkan relatif terhadap satu sama lain dan sumbu _parent_.

- **`Stack` + `Align`/`Positioned`:**

  - Dalam `Stack`, Anda dapat menengahkan anak-anak dengan `Align(alignment: Alignment.center, child: ...)`.
  - Untuk _centering_ yang lebih "memaksa" dalam `Stack` (terutama jika Anda juga ingin anak mengambil ukuran maksimum), Anda dapat menggunakan `Positioned(top: 0, bottom: 0, left: 0, right: 0, child: Center(child: ...))`. Ini memaksa `Center` untuk mengisi seluruh `Stack`, kemudian menengahkan anaknya di dalamnya.

**Visualisasi Diagram Alur/Struktur:**

- Diagram yang menunjukkan `Center` _widget_ dan bagaimana ia menempatkan anaknya di tengah ruang yang dialokasikan.
- Diagram yang menunjukkan `Align` _widget_ dengan berbagai titik _alignment_ (topLeft, center, bottomRight) dan bagaimana anaknya ditempatkan relatif terhadap titik-titik tersebut.
- Ilustrasi perbandingan penggunaan `Container.alignment` vs `Center` atau `Align` terpisah.

**Terminologi Esensial & Penjelasan Detail:**

- **Centering:** Proses menempatkan _widget_ tepat di tengah _parent_-nya.
- **Alignment:** Proses menempatkan _widget_ relatif terhadap salah satu sisi atau sudut _parent_-nya, atau di tengah pada salah satu sumbu.
- **`Center`:** _Widget_ untuk menengahkan anaknya.
- **`Align`:** _Widget_ untuk menyelaraskan anaknya ke posisi tertentu.
- **`AlignmentGeometry`:** Kelas abstrak untuk mendefinisikan _alignment_. `Alignment` adalah implementasi 2D-nya.
  - `Alignment.topLeft`: (-1.0, -1.0)
  - `Alignment.center`: (0.0, 0.0)
  - `Alignment.bottomRight`: (1.0, 1.0)

**Sumber Referensi Lengkap:**

- [Center Class (API Docs)](https://api.flutter.dev/flutter/widgets/Center-class.html)
- [Align Class (API Docs)](https://api.flutter.dev/flutter/widgets/Align-class.html)
- [Alignment Class (API Docs)](https://api.flutter.dev/flutter/painting/Alignment-class.html)
- [Flutter Layout Cheat Sheet](https://docs.flutter.dev/ui/layout/layout-cheat-sheet)
- [Flutter Widgets: Align](https://www.youtube.com/watch%3Fv%3DR9C5J2P22vQ)

**Tips dan Praktik Terbaik:**

- **Pilih yang Paling Sederhana:** Jika Anda hanya perlu menengahkan, gunakan `Center`. Jika Anda perlu _alignment_ spesifik dan _widget_ adalah anak tunggal, gunakan `Align` atau `Container.alignment`. Untuk _multi-child linear layout_, gunakan `mainAxisAlignment` dan `crossAxisAlignment` dari `Row`/`Column`.
- **Pahami Hierarchy:** Ingat bahwa setiap _widget_ beroperasi dalam batas _parent_-nya. Jika _parent_ Anda tidak memberikan ruang yang cukup, _widget_ Anda mungkin tidak dapat menengahkan atau menyelaraskan seperti yang diharapkan.
- **DevTools untuk Debugging:** Gunakan Flutter DevTools (terutama Widget Inspector dan Layout Explorer) untuk melihat bagaimana _constraints_ dan _alignment_ bekerja secara visual. Ini sangat membantu dalam memahami mengapa _widget_ tidak berada di tempat yang Anda inginkan.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `Center` atau `Align` tidak menengahkan/menyelaraskan _widget_ karena _parent_ membatasi ukurannya.

  - **Penyebab:** Jika `Center` atau `Align` dibungkus oleh _parent_ yang memberikan batasan ketat (misalnya `SizedBox` dengan ukuran spesifik), maka `Center`/`Align` hanya akan bekerja di dalam batasan tersebut. Jika anak sudah sebesar _parent_-nya, _centering_ tidak akan terlihat.
  - **Solusi:** Pastikan `Center` atau `Align` memiliki ruang yang cukup untuk beroperasi. Dalam beberapa kasus, Anda mungkin perlu memastikan _parent_ dari `Center`/`Align` juga diperluas (`Expanded`) atau memiliki `double.infinity` pada dimensinya agar `Center`/`Align` dapat mengambil seluruh ruang yang tersedia.

- **Kesalahan:** Menggunakan `alignment` di `Container` tetapi tidak berpengaruh.

  - **Penyebab:** Properti `alignment` di `Container` hanya berpengaruh jika `Container` itu sendiri lebih besar dari anaknya. Jika `Container` menyusut mengikuti ukuran anaknya, tidak ada ruang untuk _alignment_.
  - **Solusi:** Pastikan `Container` memiliki `width`/`height` eksplisit atau batasan yang memungkinkannya menjadi lebih besar dari anaknya. Atau, pastikan `Container` dibungkus oleh _widget_ yang memaksanya untuk mengambil ruang yang lebih besar (misalnya `Expanded` atau `Center`).

---

### 2.3 Basic Interactive Widgets

Sub-bagian ini akan memperkenalkan _widget_ UI dasar yang digunakan untuk menampilkan konten dan memungkinkan interaksi pengguna. Ini adalah komponen esensial yang membentuk antarmuka pengguna fungsional.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari _widget_ yang paling sering digunakan untuk menampilkan informasi (`Text`, `Image`, `Icon`) dan _widget_ yang memungkinkan pengguna untuk berinteraksi dengan aplikasi (`Button`, `TextField`). Ini adalah blok bangunan dasar untuk setiap UI yang fungsional. Modul ini akan menunjukkan bagaimana _widget_ ini digunakan, properti utamanya, dan bagaimana mereka menangani _event_ pengguna. Penguasaan _widget-widget_ ini akan memungkinkan pembelajar untuk mulai membuat aplikasi Flutter yang interaktif dan informatif.

**Konsep Kunci & Filosofi Mendalam:**

- **Deklaratif UI & Reaktivitas:** Perubahan pada _state_ akan secara otomatis memicu pembaruan pada _widget_ yang menampilkan data (misalnya `Text` widget), dan interaksi pengguna (misalnya menekan tombol) akan memicu perubahan _state_ yang kemudian memperbarui UI.

  - **Filosofi:** Menekankan kembali paradigma deklaratif. Anda mendeflarasikan bagaimana UI harus terlihat berdasarkan _state_ saat ini, dan Flutter menangani pembaruan ketika _state_ berubah sebagai respons terhadap interaksi pengguna.

- **Separation of Concerns:** _Widget_ ini fokus pada tampilan atau input data, sementara logika bisnis (apa yang terjadi setelah tombol ditekan atau teks dimasukkan) biasanya ditangani di _callback function_ atau di _state management layer_ yang lebih tinggi.

  - **Filosofi:** Mempromosikan modularitas dan kode yang lebih bersih, di mana _widget_ bertanggung jawab atas presentasi dan _state_ mengelola data dan logika.

**Visualisasi Diagram Alur/Struktur:**

- Diagram sederhana yang menunjukkan bagaimana `onPressed` pada `Button` memicu `setState` untuk memperbarui `Text` atau `TextField`.
- Contoh _screenshot_ dari _widget-widget_ dasar ini yang digunakan dalam tata letak sederhana.

**Hubungan dengan Modul Lain:**
_Widget_ ini adalah fondasi untuk setiap UI interaktif. Mereka akan selalu digunakan bersama dengan _layout widgets_ (`Row`, `Column`, `Container`, dll.) yang dibahas sebelumnya. Interaksi dengan _widget_ ini seringkali akan mengubah _state_, sehingga konsep `StatelessWidget` vs `StatefulWidget` (terutama penggunaan `setState()`) akan sangat relevan. _Text input_ dari `TextField` akan menjadi dasar untuk validasi form dan pemrosesan data di fase-fase selanjutnya.

---

#### 2.3.1 Text, Image, Icon

Sub-bagian ini akan membahas _widget_ yang digunakan untuk menampilkan informasi visual dan tekstual kepada pengguna.

**Deskripsi Konkret & Peran dalam Kurikulum:**

- **`Text`**: _Widget_ paling dasar untuk menampilkan teks. Ini mendukung _styling_ yang kaya melalui `TextStyle`, memungkinkan kontrol atas font, ukuran, warna, berat, dan banyak lagi.
- **`Image`**: _Widget_ untuk menampilkan gambar. Flutter mendukung berbagai sumber gambar (aset lokal, jaringan, file, memori). Ini penting untuk memperkaya tampilan visual aplikasi.
- **`Icon`**: _Widget_ untuk menampilkan ikon Material Design atau Cupertino. Ikon sangat umum dalam aplikasi modern untuk memberikan petunjuk visual yang ringkas dan intuitif.

Penguasaan _widget_ ini memungkinkan pembelajar untuk membuat UI yang informatif dan menarik secara visual.

**Konsep Kunci & Filosofi Mendalam:**

- **Material Design & Cupertino:** Flutter menyediakan _widget_ yang sesuai dengan pedoman desain dari Google (Material Design) dan Apple (Cupertino). `Icon` adalah contoh yang jelas dari ini.
  - **Filosofi:** Memungkinkan pengembang untuk membangun aplikasi yang terlihat _native_ dan terasa akrab bagi pengguna di platform masing-masing.
- **Asset Management:** Memahami cara menambahkan gambar dan font kustom ke proyek dan cara merujuknya adalah keterampilan penting.
  - **Filosofi:** Memastikan bahwa semua sumber daya non-kode dikelola dengan benar dan dapat diakses oleh aplikasi.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

class BasicDisplayWidgetsExample extends StatelessWidget {
  const BasicDisplayWidgetsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text, Image, Icon Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 1. Contoh Text Widget
            // Sintaks: Text(String data, {Key? key, TextStyle? style, TextAlign? textAlign, ...})
            // Properti `data` adalah string yang akan ditampilkan.
            // Properti `style` mengambil objek `TextStyle` untuk styling.
            // Ini adalah widget dasar untuk menampilkan teks statis atau dinamis.
            const Text(
              'Hello, Flutter!',
              style: TextStyle(
                fontSize: 30, // Ukuran font
                fontWeight: FontWeight.bold, // Ketebalan font
                color: Colors.blue, // Warna teks
                letterSpacing: 2, // Jarak antar huruf
                fontStyle: FontStyle.italic, // Gaya font (miring)
                decoration: TextDecoration.underline, // Dekorasi teks (garis bawah)
                decorationColor: Colors.red,
              ),
              textAlign: TextAlign.center, // Penyelarasan teks dalam kotaknya
            ),
            const SizedBox(height: 30),

            // 2. Contoh Image Widget (dari asset lokal)
            // Agar bisa menggunakan Image.asset, gambar harus ditambahkan ke pubspec.yaml
            // Contoh pubspec.yaml:
            // flutter:
            //   assets:
            //     - assets/images/
            // Pastikan Anda punya gambar di folder assets/images/your_image.png
            // Sintaks: Image.asset(String name, {Key? key, double? width, double? height, BoxFit? fit, ...})
            // Digunakan untuk menampilkan gambar yang sudah bundled dengan aplikasi.
            Image.asset(
              'assets/images/flutter_logo.png', // Ganti dengan path gambar Anda
              width: 150,
              height: 150,
              fit: BoxFit.contain, // Cara gambar akan mengisi ruang
            ),
            const SizedBox(height: 10),

            // Contoh Image Widget (dari jaringan)
            // Sintaks: Image.network(String src, {Key? key, double? width, double? height, BoxFit? fit, ...})
            // Digunakan untuk menampilkan gambar dari URL. Membutuhkan koneksi internet.
            Image.network(
              'https://picsum.photos/id/237/200/200', // URL gambar contoh
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                // Konteks: loadingBuilder adalah callback opsional untuk menampilkan progress loading.
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // Konteks: errorBuilder adalah callback opsional untuk menampilkan error jika gambar gagal dimuat.
                return const Text('Failed to load image');
              },
            ),
            const SizedBox(height: 30),

            // 3. Contoh Icon Widget
            // Sintaks: Icon(IconData icon, {Key? key, double? size, Color? color, String? semanticLabel, ...})
            // IconData: Representasi data dari ikon, biasanya dari Icons.
            // Digunakan untuk menampilkan ikon dari set ikon Material Design.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(
                  Icons.star, // Ikon bintang
                  color: Colors.amber, // Warna ikon
                  size: 50, // Ukuran ikon
                  semanticLabel: 'Bintang rating', // Label untuk aksesibilitas
                ),
                SizedBox(width: 20),
                Icon(
                  Icons.favorite, // Ikon hati
                  color: Colors.pink,
                  size: 40,
                ),
                SizedBox(width: 20),
                Icon(
                  Icons.cloud, // Ikon awan
                  color: Colors.lightBlue,
                  size: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: BasicDisplayWidgetsExample(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **`Text`**:
  - `data`: String yang ingin ditampilkan.
  - `style`: Objek `TextStyle` untuk kustomisasi tampilan teks (font size, weight, color, dll.).
  - `textAlign`: Mengatur perataan teks dalam kotak _widget_ `Text` itu sendiri.
- **`Image.asset()`**: Untuk gambar dari folder `assets` proyek Anda. Anda harus mendeklarasikan _path_ folder `assets` di `pubspec.yaml` (misalnya, `assets: - assets/images/`).
- **`Image.network()`**: Untuk gambar yang dimuat dari URL. Perlu akses internet.
  - `loadingBuilder`: Callback opsional untuk menampilkan indikator _loading_ atau placeholder saat gambar sedang dimuat.
  - `errorBuilder`: Callback opsional untuk menampilkan _widget_ alternatif jika gambar gagal dimuat.
- **`BoxFit`**: Properti yang umum pada `Image` untuk mengontrol bagaimana gambar menyesuaikan diri dengan ruang yang tersedia:
  - `BoxFit.contain`: Gambar akan diskalakan agar sesuai dalam kotaknya, menjaga rasio aspek.
  - `BoxFit.cover`: Gambar akan diskalakan untuk menutupi seluruh kotaknya, memotong bagian jika perlu, menjaga rasio aspek.
  - `BoxFit.fill`: Gambar akan diskalakan untuk mengisi seluruh kotak, mengabaikan rasio aspek (bisa merenggang).
- **`Icon`**:
  - `Icons.star`, `Icons.favorite`, `Icons.cloud`: Ini adalah konstanta dari kelas `Icons` yang disediakan oleh Material Design Flutter, mewakili berbagai ikon.
  - `size`, `color`: Untuk mengontrol ukuran dan warna ikon.

**Visualisasi Diagram Alur/Struktur:**

- Contoh visual yang menunjukkan berbagai _styling_ `Text` (bold, italic, underline, color).
- Perbandingan visual antara `BoxFit.contain`, `BoxFit.cover`, dan `BoxFit.fill` pada sebuah gambar.
- Galeri kecil dari beberapa ikon Material Design dengan berbagai ukuran dan warna.

**Terminologi Esensial & Penjelasan Detail:**

- **Text:** Widget untuk menampilkan teks.
- **TextStyle:** Objek untuk mengontrol properti visual teks.
- **Image:** Widget untuk menampilkan gambar (dari asset, jaringan, file, memory).
- **BoxFit:** Enum yang mengontrol bagaimana gambar diskalakan dan diposisikan dalam ruang yang tersedia.
- **Icon:** Widget untuk menampilkan ikon dari set ikon Material Design atau Cupertino.
- **Icons (class):** Kelas yang berisi konstanta untuk berbagai ikon Material Design.

**Sumber Referensi Lengkap:**

- [Text Class (API Docs)](https://api.flutter.dev/flutter/widgets/Text-class.html)
- [Image Class (API Docs)](https://api.flutter.dev/flutter/widgets/Image-class.html)
- [Icon Class (API Docs)](https://api.flutter.dev/flutter/widgets/Icon-class.html)
- [Displaying images in Flutter](https://docs.flutter.dev/ui/assets-images/loading-images)
- [Using custom fonts in Flutter](https://docs.flutter.dev/ui/assets-images/fonts)

**Tips dan Praktik Terbaik:**

- **Gunakan Konstanta untuk Text Style:** Untuk _style_ teks yang sering digunakan, definisikan sebagai konstanta atau dalam `ThemeData` untuk konsistensi.
- **Optimalkan Gambar:** Gunakan ukuran gambar yang sesuai untuk aplikasi seluler untuk mengurangi ukuran APK dan mempercepat _loading_. Gunakan format modern seperti WebP jika memungkinkan.
- **Manajemen Asset:** Organisasikan asset Anda dalam folder yang logis (misalnya `assets/images`, `assets/fonts`).
- **Aksesibilitas:** Selalu pertimbangkan `semanticLabel` untuk `Icon` dan `Image` agar aplikasi Anda lebih mudah diakses oleh pengguna dengan kebutuhan khusus.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Gambar dari `Image.asset` tidak ditemukan atau `pubspec.yaml` error.

  - **Penyebab:** _Path_ gambar di `Image.asset` salah, atau folder `assets` belum dideklarasikan dengan benar di `pubspec.yaml`, atau setelah mengubah `pubspec.yaml` belum melakukan `flutter pub get`.
  - **Solusi:** Periksa kembali _path_ dan entri `assets` di `pubspec.yaml`. Jalankan `flutter pub get` setelah perubahan `pubspec.yaml`.

- **Kesalahan:** Gambar dari `Image.network` tidak muncul.

  - **Penyebab:** URL salah, tidak ada koneksi internet, masalah firewall, atau _image provider_ gagal memuat.
  - **Solusi:** Verifikasi URL. Pastikan perangkat memiliki koneksi internet. Tambahkan `errorBuilder` untuk melihat pesan kesalahan. Periksa _logging_ aplikasi.

- **Kesalahan:** Ikon tidak muncul atau ukurannya salah.

  - **Penyebab:** Salah eja nama ikon (misalnya `Icons.star` bukan `Icons.start`), atau properti `size` tidak diatur.
  - **Solusi:** Pastikan nama ikon benar. Gunakan properti `size` untuk mengontrol ukuran ikon.

---

#### 2.3.2 Buttons (ElevatedButton, TextButton, IconButton)

Sub-bagian ini akan memperkenalkan _widget_ tombol paling umum dalam Flutter Material Design, yang memungkinkan pengguna untuk memicu aksi atau navigasi dalam aplikasi.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari berbagai jenis tombol yang disediakan oleh Flutter Material Design, masing-masing dengan kegunaan dan tampilan visual yang berbeda. Fokus akan diberikan pada:

- **`ElevatedButton`**: Tombol dengan latar belakang berwarna dan efek elevasi (bayangan), sering digunakan untuk aksi utama atau menonjol.
- **`TextButton`**: Tombol datar tanpa elevasi, ideal untuk aksi sekunder, atau di dalam dialog/kartu.
- **`IconButton`**: Tombol yang hanya menampilkan ikon, cocok untuk aksi yang ringkas dan intuitif (misalnya, tombol "back", "search").

Penjelasan akan mencakup properti umum tombol seperti `onPressed` (untuk menangani _tap_), `child` (konten tombol), dan bagaimana mengkustomisasi tampilan mereka menggunakan `ButtonStyle` atau `Theme`. Penguasaan tombol adalah kunci untuk membuat aplikasi yang interaktif dan responsif terhadap input pengguna.

**Konsep Kunci & Filosofi Mendalam:**

- **Actionability & Interactivity:** Tombol adalah inti dari interaksi pengguna. Mereka memvisualisasikan aksi yang tersedia bagi pengguna.

  - **Filosofi:** Desain UI yang baik memastikan bahwa elemen yang dapat diklik mudah diidentifikasi dan memiliki respons visual yang jelas. Flutter mempermudah ini dengan menyediakan _widget_ tombol yang sudah memiliki efek visual interaktif (seperti _ripple effect_ dan elevasi).

- **Material Design Guidelines:** Flutter menyediakan implementasi tombol yang sesuai dengan Pedoman Desain Material Google, memastikan konsistensi dan pengalaman pengguna yang familiar.

  - **Filosofi:** Mengikuti standar desain yang mapan membantu menciptakan aplikasi yang mudah digunakan dan terlihat profesional di seluruh platform.

- **Callback Functions (`onPressed`):** Interaksi pengguna (seperti _tap_ pada tombol) ditangani melalui _callback function_. Jika `onPressed` adalah `null`, tombol akan dinonaktifkan secara otomatis.

  - **Filosofi:** Model _event-driven_ ini memungkinkan pemisahan yang jelas antara representasi UI dan logika aplikasi.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

class ButtonsExample extends StatefulWidget {
  const ButtonsExample({super.key});

  @override
  State<ButtonsExample> createState() => _ButtonsExampleState();
}

class _ButtonsExampleState extends State<ButtonsExample> {
  String _message = 'Tekan salah satu tombol!';

  void _updateMessage(String newMessage) {
    setState(() {
      _message = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buttons Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _message,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // 1. ElevatedButton
            // Sintaks: ElevatedButton({Key? key, required VoidCallback? onPressed, ButtonStyle? style, required Widget? child})
            // Tombol dengan efek "elevasi" (bayangan) yang menonjol.
            // Digunakan untuk aksi utama atau tombol yang perlu menarik perhatian.
            ElevatedButton(
              onPressed: () {
                _updateMessage('Elevated Button ditekan!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Warna latar belakang tombol
                foregroundColor: Colors.white,      // Warna teks/ikon di tombol
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding internal
                textStyle: const TextStyle(fontSize: 18), // Gaya teks
                shape: RoundedRectangleBorder( // Bentuk tombol
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8, // Tingkat elevasi (bayangan)
              ),
              child: const Text('Elevated Button'),
            ),
            const SizedBox(height: 20),

            // ElevatedButton (Disabled)
            ElevatedButton(
              onPressed: null, // Jika onPressed null, tombol akan dinonaktifkan
              child: const Text('Disabled Elevated Button'),
            ),
            const SizedBox(height: 20),

            // 2. TextButton
            // Sintaks: TextButton({Key? key, required VoidCallback? onPressed, ButtonStyle? style, required Widget? child})
            // Tombol datar tanpa elevasi, hanya teks.
            // Digunakan untuk aksi sekunder, di dalam dialog, atau saat ruang terbatas.
            TextButton(
              onPressed: () {
                _updateMessage('Text Button ditekan!');
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // Warna teks
                padding: const EdgeInsets.all(10),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Text Button'),
            ),
            const SizedBox(height: 20),

            // 3. IconButton
            // Sintaks: IconButton({Key? key, required VoidCallback? onPressed, required Icon icon,
            //                      double? iconSize, VisualDensity? visualDensity, EdgeInsetsGeometry? padding, ...})
            // Tombol yang hanya menampilkan ikon.
            // Digunakan untuk aksi yang ringkas dan sering digunakan (misalnya, tombol back, search, delete).
            IconButton(
              icon: const Icon(Icons.favorite), // Ikon yang ditampilkan
              onPressed: () {
                _updateMessage('Icon Button ditekan!');
              },
              iconSize: 40, // Ukuran ikon
              color: Colors.pink, // Warna ikon
              tooltip: 'Tambahkan ke Favorit', // Teks yang muncul saat di-hover/tekan lama
            ),
            const SizedBox(height: 20),

            // 4. OutlinedButton (opsional, sebagai variasi lain)
            // Tombol dengan border dan tanpa latar belakang padat, cocok untuk aksi sekunder.
            OutlinedButton(
              onPressed: () {
                _updateMessage('Outlined Button ditekan!');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo, // Warna teks/ikon
                side: const BorderSide(color: Colors.indigo, width: 2), // Warna dan lebar border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Outlined Button'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ButtonsExample(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **`onPressed`**: Ini adalah properti terpenting untuk semua tombol. Ini mengambil `VoidCallback` (fungsi yang tidak mengambil argumen dan tidak mengembalikan nilai). Ketika tombol ditekan, fungsi ini akan dijalankan. Jika `onPressed` adalah `null`, tombol akan secara otomatis menjadi _disabled_ (tidak dapat diklik) dan biasanya akan memiliki tampilan visual yang berbeda (lebih redup).
- **`child`**: Properti ini menerima `Widget`. Ini adalah konten visual tombol (misalnya, `Text`, `Icon`, atau kombinasi keduanya di dalam `Row`).
- **`style`**: Properti ini mengambil objek `ButtonStyle`. Ini adalah cara modern dan fleksibel untuk mengkustomisasi tampilan tombol secara individual. Setiap jenis tombol memiliki `.styleFrom()` statis yang memudahkan konfigurasi gaya umum:
  - `backgroundColor`: Warna latar belakang tombol (saat aktif).
  - `foregroundColor`: Warna teks dan ikon di dalam tombol.
  - `padding`: _Padding_ di sekitar `child` tombol.
  - `textStyle`: `TextStyle` yang diterapkan pada teks di dalam tombol.
  - `shape`: Bentuk tombol (misalnya, `RoundedRectangleBorder`, `CircleBorder`).
  - `elevation`: Hanya untuk `ElevatedButton`, mengontrol tingkat bayangan.
  - `side`: Hanya untuk `OutlinedButton`, mengontrol _border_.
- **`tooltip` (untuk `IconButton`)**: Teks singkat yang muncul saat pengguna menekan dan menahan tombol atau mengarahkan kursor ke atasnya (di _desktop/web_). Ini penting untuk _usability_ dan _accessibility_.
- **`setState`**: Digunakan di dalam `_ButtonsExampleState` untuk memperbarui `_message` dan memicu pembangunan ulang UI, sehingga teks di layar berubah setelah tombol ditekan. Ini menunjukkan bagaimana interaksi tombol mengubah _state_ aplikasi.

**Visualisasi Diagram Alur/Struktur:**

- _Screenshot_ berdampingan dari `ElevatedButton`, `TextButton`, `IconButton`, dan `OutlinedButton`, menunjukkan perbedaan visual masing-masing.
- Diagram yang menunjukkan siklus _tap_ tombol: _User Tap_ -\> `onPressed` _callback_ -\> `setState` -\> _UI rebuild_.

**Terminologi Esensial & Penjelasan Detail:**

- **Button:** _Widget_ interaktif yang memicu aksi saat ditekan.
- **`ElevatedButton`:** Tombol dengan bayangan/elevasi.
- **`TextButton`:** Tombol datar dengan hanya teks.
- **`IconButton`:** Tombol yang hanya menampilkan ikon.
- **`OutlinedButton`:** Tombol dengan garis tepi (outline) dan latar belakang transparan.
- **`onPressed`:** _Callback function_ yang dipanggil saat tombol ditekan. Jika `null`, tombol dinonaktifkan.
- **`child`:** Konten visual di dalam tombol.
- **`ButtonStyle`:** Kelas untuk mengkustomisasi tampilan tombol.
- **`ButtonStyle.styleFrom()`:** Metode pembantu untuk membuat `ButtonStyle` dengan properti umum.
- **`tooltip`:** Teks informasi yang muncul saat tombol di-_hover_ atau ditekan lama.

**Sumber Referensi Lengkap:**

- [Buttons in Flutter (Official Docs)](https://docs.flutter.dev/ui/widgets/buttons)
- [ElevatedButton Class (API Docs)](https://api.flutter.dev/flutter/material/ElevatedButton-class.html)
- [TextButton Class (API Docs)](https://api.flutter.dev/flutter/material/TextButton-class.html)
- [IconButton Class (API Docs)](https://api.flutter.dev/flutter/material/IconButton-class.html)
- [OutlinedButton Class (API Docs)](https://api.flutter.dev/flutter/material/OutlinedButton-class.html)
- [Material Design Buttons Guidelines](https://m2.material.io/components/buttons)

**Tips dan Praktik Terbaik:**

- **Pilih Tombol yang Tepat:**
  - Gunakan `ElevatedButton` untuk aksi utama yang memerlukan penekanan.
  - Gunakan `TextButton` untuk aksi sekunder, di dalam dialog, atau sebagai bagian dari daftar.
  - Gunakan `IconButton` untuk aksi yang dikenal secara universal oleh ikonnya (misalnya, hapus, tambah, pengaturan).
  - Gunakan `OutlinedButton` sebagai alternatif sekunder dengan penekanan yang lebih rendah dari `ElevatedButton`.
- **Disabled Buttons:** Atur `onPressed` ke `null` untuk menonaktifkan tombol secara visual dan fungsional. Ini adalah praktik baik untuk menunjukkan kepada pengguna bahwa aksi tidak tersedia saat ini.
- **Kustomisasi Tema Global:** Untuk konsistensi desain, sebagian besar gaya tombol dapat diatur secara global melalui `ThemeData` di `MaterialApp` (akan dibahas di fase selanjutnya), daripada mengkustomisasi setiap tombol satu per satu.
- **Gunakan `Row` atau `Column` untuk Grup Tombol:** Untuk menata beberapa tombol, bungkus mereka dalam `Row` atau `Column` dan gunakan properti _alignment_ yang sesuai.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Tombol tidak responsif atau tidak terlihat seperti yang diharapkan.

  - **Penyebab:**
    - `onPressed` tidak diatur (tombol dinonaktifkan).
    - Properti `style` tidak diatur dengan benar atau konflik dengan tema default.
    - Anak (`child`) tombol mengambil terlalu banyak ruang atau terlalu kecil.
  - **Solusi:**
    - Pastikan `onPressed` adalah fungsi yang valid, bukan `null`.
    - Periksa `style` dan pastikan Anda menggunakan properti yang benar. Jika ingin tampilan default Material Design, hapus `style` sepenuhnya.
    - Gunakan `SizedBox` atau `Padding` di sekitar anak jika Anda ingin mengontrol ukurannya.

- **Kesalahan:** Ikon di `IconButton` tidak muncul atau berukuran aneh.

  - **Penyebab:** Properti `icon` tidak diberi `Icon` _widget_, atau `iconSize` tidak diatur dengan benar.
  - **Solusi:** Pastikan `icon` adalah `const Icon(Icons.some_icon)`. Atur `iconSize` secara eksplisit jika ukuran default tidak sesuai.

- **Kesalahan:** Tombol tidak melebar atau menyusut seperti yang diharapkan di dalam `Row` atau `Column`.

  - **Penyebab:** `Expanded` atau `Flexible` tidak digunakan jika Anda ingin tombol mengambil ruang yang tersedia secara fleksibel. Secara _default_, tombol hanya mengambil ruang yang cukup untuk kontennya.
  - **Solusi:** Bungkus tombol dengan `Expanded` atau `Flexible` jika Anda ingin mereka mengisi ruang yang tersisa atau menyusut.

---

#### 2.3.3 Input Fields (TextField)

Sub-bagian ini akan membahas _widget_ utama untuk menerima input teks dari pengguna di Flutter: `TextField`.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari cara menggunakan `TextField` untuk memungkinkan pengguna memasukkan teks (misalnya nama, email, kata sandi, pesan). Ini adalah _widget_ kritis untuk formulir dan setiap aplikasi yang memerlukan input teks. Penjelasan akan mencakup properti utama untuk kustomisasi tampilan (`decoration`), penanganan perubahan teks (`onChanged`), dan pengambilan nilai saat ini menggunakan `TextEditingController`. Berbagai tipe keyboard dan validasi input dasar juga akan disinggung. Penguasaan `TextField` adalah fondasi untuk membangun formulir yang kuat dan interaktif di aplikasi Flutter.

**Konsep Kunci & Filosofi Mendalam:**

- **Controlled vs. Uncontrolled Input:**

  - **Controlled Input:** Mengelola _state_ `TextField` (teks yang ditampilkan, posisi kursor) secara eksternal menggunakan `TextEditingController`. Ini adalah pendekatan yang direkomendasikan untuk sebagian besar kasus karena memberikan kontrol penuh atas input.
  - **Uncontrolled Input:** `TextField` mengelola _state_ internalnya sendiri, dan Anda hanya mendengarkan perubahan melalui _callback_ `onChanged` atau mengambil nilai saat dibutuhkan. Kurang fleksibel untuk skenario kompleks.
  - **Filosofi:** Konsep ini mirip dengan React. Memberikan pengembang kontrol eksplisit atas _state_ input, memungkinkan implementasi fitur seperti validasi _real-time_, pemformatan input, dan reset formulir.

- **Input Decorator (`InputDecoration`):** Flutter memisahkan tampilan visual `TextField` (border, label, hint text, icon) dari fungsionalitas intinya. Ini dicapai melalui `InputDecoration`.

  - **Filosofi:** Mempromosikan modularitas desain. Anda dapat dengan mudah menyesuaikan tampilan _input field_ tanpa mengubah perilaku input itu sendiri, dan bahkan menggunakan kembali dekorasi yang sama untuk beberapa _field_.

- **Soft Keyboard Interaction:** Flutter secara otomatis menangani penampilan dan penghilangan _soft keyboard_ dan memastikan _widget_ tetap terlihat saat keyboard muncul.

  - **Filosofi:** Mengurangi beban pengembang dalam menangani interaksi yang kompleks dengan sistem operasi, memungkinkan fokus pada logika aplikasi.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

class TextFieldExample extends StatefulWidget {
  const TextFieldExample({super.key});

  @override
  State<TextFieldExample> createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  // TextEditingController digunakan untuk mengontrol teks yang ditampilkan
  // dan mendengarkan perubahan. Ini adalah cara yang direkomendasikan.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _displayedText = 'Input akan muncul di sini.';

  @override
  void initState() {
    super.initState();
    // Mendengarkan perubahan pada _nameController
    _nameController.addListener(_updateDisplayedText);
  }

  void _updateDisplayedText() {
    setState(() {
      _displayedText = 'Nama: ${_nameController.text}\n'
                      'Email: ${_emailController.text}';
    });
  }

  // Penting: Bersihkan controller saat widget dihapus untuk mencegah memory leak.
  @override
  void dispose() {
    _nameController.removeListener(_updateDisplayedText); // Hapus listener
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Field Demo')),
      body: SingleChildScrollView( // Agar keyboard tidak menutupi input
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. TextField Sederhana dengan Decoration
            // Sintaks: TextField({Key? key, TextEditingController? controller,
            //                    InputDecoration? decoration, ValueChanged<String>? onChanged,
            //                    TextInputType? keyboardType, bool obscureText = false, ...})
            // Ini adalah widget dasar untuk input teks.
            TextField(
              controller: _nameController, // Mengaitkan controller
              // InputDecoration digunakan untuk styling visual input field
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap', // Label di atas input
                hintText: 'Masukkan nama Anda', // Placeholder teks
                prefixIcon: Icon(Icons.person), // Ikon di awal input
                suffixIcon: Icon(Icons.clear),  // Ikon di akhir input
                border: OutlineInputBorder(),   // Gaya border
                helperText: 'Tulis nama Anda di sini', // Teks bantuan
              ),
              keyboardType: TextInputType.name, // Tipe keyboard yang muncul
              textInputAction: TextInputAction.next, // Aksi pada tombol 'Done/Next' di keyboard
              // onChanged: (value) {
              //   // Callback ini dipanggil setiap kali teks berubah
              //   print('Nama berubah menjadi: $value');
              // },
            ),
            const SizedBox(height: 20),

            // 2. TextField untuk Email dengan Validasi dasar
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'contoh@domain.com',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                errorText: 'Format email tidak valid', // Teks error (jika ada)
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                // Callback ini dipanggil saat tombol "Done" di keyboard ditekan
                print('Email disubmit: $value');
              },
            ),
            const SizedBox(height: 20),

            // 3. TextField untuk Password (teks disamarkan)
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Kata Sandi',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility), // Ikon mata untuk toggle visibility
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.visiblePassword, // Memastikan semua karakter tersedia
              obscureText: true, // Menyembunyikan teks (untuk password)
              maxLength: 12, // Batas panjang karakter
            ),
            const SizedBox(height: 30),

            // Menampilkan teks yang diambil dari controller
            Text(
              'Nilai Input Saat Ini:\n$_displayedText',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                // Mengambil nilai dari controller saat tombol ditekan
                String name = _nameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Input Anda'),
                      content: Text('Nama: $name\nEmail: $email\nPassword: $password'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Kirim Data'),
            ),
            const SizedBox(height: 20),

            // Tombol untuk mereset semua input
            TextButton(
              onPressed: () {
                _nameController.clear(); // Mengosongkan teks
                _emailController.clear();
                _passwordController.clear();
              },
              child: const Text('Reset Input'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: TextFieldExample(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **`TextField`**: Widget utama untuk input teks.
  - **`controller`**: Properti ini menerima `TextEditingController`. Ini adalah cara paling umum dan direkomendasikan untuk mengelola dan mengakses teks di `TextField`. Dengan `controller`, Anda dapat:
    - Mendapatkan teks saat ini (`_nameController.text`).
    - Menetapkan teks baru (`_nameController.text = 'Nilai Baru';`).
    - Mengosongkan teks (`_nameController.clear();`).
    - Menambahkan _listener_ untuk memantau perubahan secara _real-time_.
  - **`decoration`**: Properti ini menerima `InputDecoration` objek untuk mengkustomisasi tampilan visual `TextField`, seperti:
    - `labelText`: Teks label yang "mengambang" di atas input saat fokus.
    - `hintText`: Teks _placeholder_ yang muncul saat input kosong.
    - `prefixIcon`, `suffixIcon`: Ikon di awal dan akhir _input field_.
    - `border`: Mengontrol gaya _border_ (misalnya `OutlineInputBorder`, `UnderlineInputBorder`).
    - `helperText`: Teks bantuan di bawah input.
    - `errorText`: Teks error yang ditampilkan di bawah input (biasanya setelah validasi gagal).
  - **`keyboardType`**: Mengontrol jenis _soft keyboard_ yang muncul (misalnya `TextInputType.emailAddress`, `TextInputType.number`, `TextInputType.visiblePassword`).
  - **`obscureText`**: Jika `true`, teks akan disamarkan (misalnya untuk kata sandi).
  - **`maxLength`**: Batas jumlah karakter yang dapat dimasukkan.
  - **`onChanged`**: Callback yang dipanggil setiap kali teks di `TextField` berubah. Berguna untuk validasi _real-time_ atau pembaruan UI.
  - **`onSubmitted`**: Callback yang dipanggil ketika pengguna menekan tombol "Done" (atau yang setara) di _soft keyboard_.
  - **`textInputAction`**: Mengatur aksi pada tombol "Enter" di keyboard (misalnya `TextInputAction.next` untuk pindah ke _field_ berikutnya, `TextInputAction.done` untuk menyelesaikan input).
- **`TextEditingController`**:
  - Dibuat di `_TextFieldExampleState` menggunakan `final TextEditingController _nameController = TextEditingController();`.
  - **Penting**: Selalu panggil `dispose()` pada `TextEditingController` di dalam metode `dispose()` dari `StatefulWidget` Anda untuk mencegah _memory leak_.

**Visualisasi Diagram Alur/Struktur:**

- Ilustrasi `TextField` yang menunjukkan setiap bagian dari `InputDecoration` (label, hint, icon, border, helper text, error text).
- Diagram sederhana yang menunjukkan alur input teks: _User types_ -\> `onChanged` _callback_ -\> `TextEditingController` _updates_ -\> `setState` (jika diperlukan) -\> _UI rebuild_.

**Terminologi Esensial & Penjelasan Detail:**

- **TextField:** _Widget_ untuk menerima input teks.
- **TextEditingController:** Objek yang mengelola _state_ teks di `TextField`.
- **InputDecoration:** Kelas untuk mengkustomisasi tampilan visual `TextField`.
- **labelText:** Label yang "mengambang" saat input fokus.
- **hintText:** Teks _placeholder_ saat input kosong.
- **prefixIcon, suffixIcon:** Ikon di awal dan akhir _input field_.
- **border:** Gaya garis batas `TextField`.
- **keyboardType:** Jenis _soft keyboard_ yang ditampilkan.
- **obscureText:** Properti untuk menyamarkan teks (misalnya untuk password).
- **onChanged:** Callback saat teks berubah.
- **onSubmitted:** Callback saat tombol submit di keyboard ditekan.
- **dispose()**: Metode _lifecycle_ untuk membersihkan sumber daya, termasuk `TextEditingController`.

**Sumber Referensi Lengkap:**

- [TextField Class (API Docs)](https://api.flutter.dev/flutter/material/TextField-class.html)
- [TextEditingController Class (API Docs)](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html)
- [InputDecoration Class (API Docs)](https://api.flutter.dev/flutter/material/InputDecoration-class.html)
- [Handle text input in Flutter](https://docs.flutter.dev/cookbook/forms/text-input)
- [Flutter TextField Tutorial](https://www.youtube.com/watch%3Fv%3DYpL45p_mFjc)

**Tips dan Praktik Terbaik:**

- **Selalu Gunakan `TextEditingController`**: Meskipun ada cara untuk mendapatkan teks tanpa _controller_ (melalui `onSubmitted` atau `onChanged` dan menyimpan _state_ secara manual), `TextEditingController` adalah cara yang lebih kuat dan fleksibel untuk mengelola input teks, terutama dalam formulir yang kompleks atau saat Anda perlu mengedit teks secara terprogram.
- **Pembersihan `Controller`**: **Sangat penting** untuk memanggil `dispose()` pada setiap `TextEditingController` di dalam metode `dispose()` dari `StatefulWidget` Anda. Kegagalan melakukan ini akan menyebabkan _memory leak_.
- **`keyboardType` yang Sesuai**: Selalu setel `keyboardType` yang sesuai dengan jenis input yang diharapkan (misalnya `TextInputType.number` untuk angka, `TextInputType.emailAddress` untuk email) untuk meningkatkan _user experience_.
- **Validasi Input**: Meskipun contoh ini hanya menunjukkan `errorText` statis, dalam aplikasi nyata, Anda akan menggunakan logika validasi dinamis (seringkali dengan `Form` dan `TextFormField` yang akan dibahas nanti) untuk menampilkan pesan kesalahan berdasarkan input pengguna.
- **`SingleChildScrollView`**: Bungkus halaman yang berisi `TextField` di dalam `SingleChildScrollView` (atau `ListView`) untuk menghindari _overflow error_ ketika _soft keyboard_ muncul dan menutupi input.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** _Memory leak_ karena `TextEditingController` tidak di-_dispose_.

  - **Penyebab:** Lupa memanggil `_controller.dispose()` di dalam metode `dispose()` `StatefulWidget`.
  - **Solusi:** Pastikan setiap `TextEditingController` yang Anda buat memiliki panggilan `_controller.dispose()` yang sesuai.

- **Kesalahan:** Input tidak muncul di layar atau ada _overflow_ saat keyboard muncul.

  - **Penyebab:**
    - Teks tidak diatur ke `controller` atau tidak ada _listener_ yang memperbarui UI jika teks diubah secara terprogram.
    - Halaman tidak dibungkus dengan _widget_ yang dapat di-_scroll_ (`SingleChildScrollView` atau `ListView`).
  - **Solusi:**
    - Gunakan `TextEditingController` dan perbarui teks melalui `setState()` jika diperlukan.
    - Bungkus `Column` atau `Row` yang berisi `TextField` Anda dengan `SingleChildScrollView`.

- **Kesalahan:** Tampilan `TextField` tidak sesuai dengan keinginan.

  - **Penyebab:** Properti `decoration` tidak diatur dengan benar, atau ada konflik dengan tema aplikasi.
  - **Solusi:** Eksperimen dengan berbagai properti `InputDecoration`. Pastikan Anda memahami bagaimana tema default memengaruhi tampilan `TextField`.

## Selamat!

Kita telah menyelesaikan FASE 2. Selanjutnya kita akan melanjutkan ke **FASE 3: Navigation & Routing**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

<!----------------------------------------------------->

[0]: ../README.md#fase-2-widget-system--ui-foundation
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
