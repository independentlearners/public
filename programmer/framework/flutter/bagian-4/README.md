# [FASE 2: Widget System & UI Foundation][0]

Fase ini adalah inti dari pengembangan UI di Flutter. Setelah memahami dasar-dasar Flutter dan Dart di Fase 1, pembelajar akan mulai menyelami dunia _widget_, yang merupakan blok bangunan fundamental dari setiap antarmuka pengguna di Flutter.

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

## 2\. Widget System & UI Foundation

Modul ini adalah jantung dari pengembangan UI di Flutter. Ini akan membawa pembelajar dari pemahaman konseptual tentang _widget_ di Fase 1 ke implementasi praktisnya, membentuk fondasi yang kuat untuk membangun antarmuka pengguna yang kompleks.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Bagian ini adalah tempat pembelajar akan mulai menulis kode UI yang sesungguhnya. Mereka akan mempelajari anatomi _widget_, perbedaan kritis antara _StatelessWidget_ dan _StatefulWidget_ beserta siklus hidupnya, dan bagaimana menggunakan _widget layout_ dasar untuk mengatur elemen di layar. Pemahaman mendalam tentang bagaimana _widget_ berinteraksi dan membentuk sebuah pohon hierarkis adalah inti dari modul ini. Ini adalah dasar mutlak untuk membangun UI apa pun di Flutter, yang akan menjadi prasyarat untuk semua topik UI yang lebih canggih di fase-fase berikutnya.

**Struktur Pembelajaran Internal:**

- [2.1 The "Everything is a Widget" Principle in Practice](https://www.google.com/search?q=%2321-the-everything-is-a-widget-principle-in-practice)
  - [2.1.1 Stateless vs Stateful Widgets](https://www.google.com/search?q=%23211-stateless-vs-stateful-widgets)
  - [2.1.2 Widget Tree and BuildContext](https://www.google.com/search?q=%23212-widget-tree-and-buildcontext)
  - [2.1.3 Understanding the Widget Lifecycle](https://www.google.com/search?q=%23213-understanding-the-widget-lifecycle)
- [2.2 Essential Layout Widgets](https://www.google.com/search?q=%2322-essential-layout-widgets)
  - [2.2.1 Container and Padding](https://www.google.com/search?q=%23221-container-and-padding)
  - [2.2.2 Row and Column (Flexbox Concepts)](https://www.google.com/search?q=%23222-row-and-column-flexbox-concepts)
  - [2.2.3 Stack, Expanded, and Flexible](https://www.google.com/search?q=%23223-stack-expanded-and-flexible)
  - [2.2.4 Centering and Alignment](https://www.google.com/search?q=%23224-centering-and-alignment)
- [2.3 Basic Interactive Widgets](https://www.google.com/search?q=%2323-basic-interactive-widgets)
  - [2.3.1 Text, Image, Icon](https://www.google.com/search?q=%23231-text-image-icon)
  - [2.3.2 Buttons (ElevatedButton, TextButton, IconButton)](https://www.google.com/search?q=%23232-buttons-elevatedbutton-textbutton-iconbutton)
  - [2.3.3 Input Fields (TextField)](https://www.google.com/search?q=%23233-input-fields-textfield)

---

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

- [Stateless vs Stateful Widgets (Flutter Official Docs)](https://www.google.com/search?q=https://flutter.dev/docs/development/ui/widgets-intro%23stateless-vs-stateful)
- [Introduction to Widgets (Flutter Official Docs)](https://flutter.dev/docs/development/ui/widgets-intro)
- [StatefulWidget Class](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
- [StatelessWidget Class](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)
- [Understanding StatelessWidget and StatefulWidget in Flutter](https://www.google.com/search?q=https://medium.com/flutter-community/understanding-statelesswidget-and-statefulwidget-in-flutter-43dd59d297a7)

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

Berikutnya:
**2.1.2 Widget Tree and BuildContext**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
