Setelah membahas berbagai komponen UI bawaan Material Design dan Cupertino, kini saatnya kita melangkah lebih jauh dan belajar bagaimana membangun *widget* kustom Anda sendiri. Kemampuan untuk membuat *widget* kustom adalah inti dari fleksibilitas *Flutter*, memungkinkan Anda untuk merancang UI apa pun yang dapat Anda bayangkan.

-----

### **3.2 Custom Widget Development**

##### **Creating Custom Widgets**

**Deskripsi Detail & Peran:**
*Creating Custom Widgets* adalah proses mendefinisikan *widget* baru yang sesuai dengan kebutuhan spesifik aplikasi Anda. Meskipun *Flutter* menyediakan banyak *widget* bawaan, seringkali Anda perlu mengombinasikannya atau membuat elemen UI yang unik yang tidak ada di perpustakaan standar. Bagian ini akan mengajarkan Anda prinsip-prinsip dan praktik terbaik untuk membangun *widget* kustom Anda sendiri, baik itu `StatelessWidget` sederhana atau `StatefulWidget` yang lebih kompleks.

**Konsep Kunci & Filosofi:**
Filosofi utama di balik pengembangan *widget* kustom di *Flutter* adalah **komposisi**. Alih-alih mewarisi dari *widget* yang sudah ada dan mengubah perilakunya (walaupun kadang diperlukan), Anda akan sering kali *menggabungkan* beberapa *widget* yang lebih kecil dan sederhana menjadi *widget* yang lebih besar dan kompleks. Ini menghasilkan kode yang lebih modular, *reusable*, dan mudah di-*maintain*.

Berikut adalah aspek-aspek utama dalam membuat *widget* kustom:

1.  **Composition vs Inheritance Approach:**

      * **Komposisi (Composition):**
          * **Peran:** Ini adalah pendekatan yang paling umum dan direkomendasikan di *Flutter*. Anda membangun *widget* kustom dengan menggabungkan (mengompilasi) *widget-widget* yang lebih kecil yang sudah ada.
          * **Detail:** Sebuah *widget* kustom akan memiliki `build` *method* yang mengembalikan sebuah *widget tree* yang terdiri dari *widget* bawaan atau *widget* kustom lainnya. Ini seperti membangun rumah dari batu bata yang sudah jadi.
          * **Keuntungan:** Fleksibilitas tinggi, kode modular, mudah dibaca, dan mudah diuji. Perubahan pada satu komponen tidak terlalu memengaruhi komponen lain.
      * **Pewarisan (Inheritance):**
          * **Peran:** Meskipun tidak sepopuler komposisi untuk membangun UI biasa, pewarisan tetap penting untuk *widget* fundamental tertentu (misalnya, membuat *widget* seperti `InheritedWidget` atau `RenderObjectWidget` Anda sendiri).
          * **Detail:** Anda akan memperluas (mewarisi dari) kelas *widget* yang sudah ada dan menimpa *method* serta propertinya.
          * **Penggunaan:** Lebih jarang untuk *widget* UI tingkat aplikasi, tetapi krusial untuk *framework extension* atau *widget* yang sangat fundamental.
      * **Filosofi:** **"Favor composition over inheritance"** adalah prinsip desain perangkat lunak umum yang sangat relevan di *Flutter*.

2.  **`StatelessWidget` Custom Widgets:**

      * **Peran:** Membuat *widget* kustom yang tidak memiliki *state* yang berubah sepanjang siklus hidupnya. Semua datanya bersifat final dan disediakan saat *widget* dibuat.
      * **Detail:** Anda perlu memperluas kelas `StatelessWidget` dan menimpa *method* `build(BuildContext context)`. *Method* `build` ini akan mengembalikan *widget tree* yang mewakili UI *widget* kustom Anda.
      * **Kapan Digunakan:** Untuk elemen UI yang statis atau hanya merespons input eksternal (data yang diteruskan melalui konstruktor) tanpa menyimpan *state* internalnya sendiri. Contoh: `Text`, `Icon`, `Container` sederhana.

    <!-- end list -->

    ```dart
    class MyCustomStatelessWidget extends StatelessWidget {
      final String title; // Parameter untuk widget kustom

      const MyCustomStatelessWidget({super.key, required this.title});

      @override
      Widget build(BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blueAccent,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        );
      }
    }
    ```

3.  **`StatefulWidget` Custom Widgets:**

      * **Peran:** Membuat *widget* kustom yang memiliki *state* yang dapat berubah sepanjang siklus hidupnya, dan UI-nya diperbarui untuk merefleksikan perubahan *state* tersebut.
      * **Detail:** Anda perlu memperluas kelas `StatefulWidget` dan menimpa *method* `createState()`, yang akan mengembalikan sebuah objek `State`. Objek `State` inilah yang akan menyimpan data yang dapat berubah dan memiliki *method* `build(BuildContext context)` untuk merender UI. Perubahan *state* dipicu oleh `setState()`.
      * **Kapan Digunakan:** Untuk elemen UI yang interaktif atau data yang berubah seiring waktu. Contoh: *Checkbox*, *Slider*, *Form fields*, *Animated widgets*.

    <!-- end list -->

    ```dart
    class MyCustomStatefulWidget extends StatefulWidget {
      final String initialText;

      const MyCustomStatefulWidget({super.key, required this.initialText});

      @override
      State<MyCustomStatefulWidget> createState() => _MyCustomStatefulWidgetState();
    }

    class _MyCustomStatefulWidgetState extends State<MyCustomStatefulWidget> {
      late String _currentText; // State yang bisa berubah

      @override
      void initState() {
        super.initState();
        _currentText = widget.initialText; // Inisialisasi state dari parameter widget
      }

      void _changeText() {
        setState(() {
          _currentText = 'Teks Berubah!'; // Memperbarui state
        });
      }

      @override
      Widget build(BuildContext context) {
        return Column(
          children: [
            Text(_currentText, style: const TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: _changeText,
              child: const Text('Ubah Teks'),
            ),
          ],
        );
      }
    }
    ```

4.  **Widget Parameters dan Configuration:**

      * **Peran:** Bagaimana Anda meneruskan data ke *widget* kustom Anda dari *parent* *widget*.
      * **Detail:** Parameter ini didefinisikan sebagai *final fields* di dalam kelas `StatelessWidget` atau `StatefulWidget`. Untuk `StatefulWidget`, parameter ini diakses melalui properti `widget` dari objek `State` terkait (misalnya `widget.propertyName`).
      * **Praktik Terbaik:** Gunakan `required` pada parameter yang wajib dan berikan *default value* jika parameter opsional. Gunakan `const` konstruktor jika memungkinkan untuk `StatelessWidget` atau `StatefulWidget` agar kompilasi waktu konstanta dapat dioptimalkan.
      * **Filosofi:** Membuat *widget* Anda *reusable* dan dapat dikonfigurasi.

5.  **Widget Testing Considerations:**

      * **Peran:** Memastikan bahwa *widget* kustom Anda berfungsi seperti yang diharapkan dan tidak rusak oleh perubahan kode di masa mendatang.
      * **Detail:** *Flutter* menyediakan *testing framework* yang kuat (`flutter_test`). Anda akan menulis *widget tests* untuk memverifikasi tampilan dan interaksi *widget* kustom Anda.
      * **Kapan Dilakukan:** Sebaiknya tulis *widget tests* saat Anda mengembangkan *widget* kustom untuk memastikan keandalannya.
      * **Filosofi:** Pengembangan yang didorong oleh tes (TDD) dan jaminan kualitas.

6.  **Documentation dan Examples:**

      * **Peran:** Membuat *widget* kustom Anda mudah dipahami dan digunakan oleh *developer* lain (termasuk diri Anda di masa depan\!).
      * **Detail:** Gunakan *doc comments* (komentar `///`) untuk mendeskripsikan tujuan *widget*, parameternya, dan contoh penggunaannya. Sertakan contoh kode yang jelas.
      * **Filosofi:** Kode yang terdokumentasi dengan baik sama pentingnya dengan kode yang berfungsi.

7.  **Building Custom Widgets (Proses Umum):**

      * **Langkah 1: Identifikasi Kebutuhan:** Apa yang harus dilakukan *widget* ini? Data apa yang dibutuhkannya? Apakah *state*-nya berubah?
      * **Langkah 2: Pilih Jenis Widget:** `StatelessWidget` atau `StatefulWidget`?
      * **Langkah 3: Desain API:** Parameter apa yang akan diterima *widget* ini? (misalnya `text`, `onPressed`, `color`).
      * **Langkah 4: Tulis Kode `build`:** Gunakan komposisi dari *widget* yang lebih kecil untuk membangun UI yang diinginkan.
      * **Langkah 5: Tambahkan Logika (Jika Stateful):** Kelola *state* menggunakan `setState()` dan *lifecycle methods*.
      * **Langkah 6: Uji:** Tulis *widget tests* untuk memastikan fungsionalitas.
      * **Langkah 7: Dokumentasikan:** Tambahkan komentar yang jelas.

**Sintaks/Contoh Implementasi Lengkap (Custom Progress Bar):**

Mari kita buat *widget* kustom yang sederhana: `CustomProgressBar`.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _progressValue = 0.0;

  void _increaseProgress() {
    setState(() {
      _progressValue += 0.1;
      if (_progressValue > 1.0) {
        _progressValue = 0.0; // Reset jika sudah penuh
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Widget Progress Bar'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Menggunakan custom widget yang telah kita buat
              CustomProgressBar(
                progress: _progressValue,
                height: 20,
                backgroundColor: Colors.grey[300]!,
                progressBarColor: Colors.teal,
                borderRadius: 10,
              ),
              const SizedBox(height: 30),
              Text(
                'Progress: ${(_progressValue * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _increaseProgress,
                child: const Text('Tambah Progress'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A custom progress bar widget.
/// This widget displays a progress bar with customizable colors, height, and border radius.
/// It's a StatelessWidget because its appearance is entirely determined by its input parameters.
class CustomProgressBar extends StatelessWidget {
  /// The current progress value, from 0.0 to 1.0.
  final double progress;

  /// The height of the progress bar.
  final double height;

  /// The background color of the progress bar track.
  final Color backgroundColor;

  /// The color of the filled progress indicator.
  final Color progressBarColor;

  /// The border radius for the progress bar.
  final double borderRadius;

  const CustomProgressBar({
    super.key,
    required this.progress,
    this.height = 10.0,
    this.backgroundColor = Colors.grey,
    this.progressBarColor = Colors.blue,
    this.borderRadius = 5.0,
  }) : assert(progress >= 0.0 && progress <= 1.0, 'Progress value must be between 0.0 and 1.0');
       // Assertions for validation

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Mengisi lebar yang tersedia
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          // Bagian progress yang terisi
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                width: constraints.maxWidth * progress, // Lebar dihitung berdasarkan progress
                decoration: BoxDecoration(
                  color: progressBarColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              );
            },
          ),
          // Opsional: Teks persentase di tengah progress bar
          // Center(
          //   child: Text(
          //     '${(progress * 100).toStringAsFixed(0)}%',
          //     style: const TextStyle(color: Colors.white, fontSize: 12),
          //   ),
          // ),
        ],
      ),
    );
  }
}
```

**Visualisasi Konseptual (Komposisi Widget Kustom):**

```
MyApp
└── MaterialApp
    └── MyHomePage (StatefulWidget)
        ├── Scaffold
        │   ├── AppBar
        │   └── body
        │       └── Column
        │           ├── CustomProgressBar (StatelessWidget)
        │           │   └── Container (background)
        │           │       └── Stack
        │           │           └── LayoutBuilder
        │           │               └── Container (progress fill)
        │           ├── Text (showing percentage)
        │           └── ElevatedButton (to change progress)
```

**Terminologi Esensial:**

  * **Custom Widget:** *Widget* yang Anda definisikan sendiri untuk memenuhi kebutuhan UI spesifik.
  * **Composition:** Pendekatan membangun *widget* kustom dengan menggabungkan *widget* yang lebih kecil.
  * **Inheritance:** Pendekatan membangun *widget* kustom dengan memperluas kelas *widget* yang sudah ada.
  * **`StatelessWidget`:** *Widget* yang tidak memiliki *state* yang berubah.
  * **`StatefulWidget`:** *Widget* yang memiliki *state* yang dapat berubah.
  * **Widget Parameters:** Properti yang diteruskan ke *widget* kustom melalui konstruktornya.
  * **`super.key`:** Penting untuk meneruskan `key` ke *constructor* *parent* *widget* untuk identifikasi yang benar dalam *widget tree*.

**Struktur Internal (Mini-DAFTAR ISI):**

  * Komposisi vs Pewarisan
  * Membuat `StatelessWidget` Kustom
  * Membuat `StatefulWidget` Kustom
  * Meneruskan Parameter ke *Widget*
  * Pertimbangan Pengujian *Widget*
  * Pentingnya Dokumentasi

**Hubungan dengan Bagian Lain:**

  * **Widget Architecture Deep Dive:** Membangun *widget* kustom sangat bergantung pada pemahaman `StatelessWidget` vs `StatefulWidget`, siklus hidup *widget*, dan `BuildContext`.
  * **Layout System Mastery:** *Widget* kustom Anda akan sering menggunakan *widget* *layout* (`Column`, `Row`, `Stack`, `Container`, dll.) untuk mengatur elemen-elemennya.
  * **UI Components & Material Design:** *Widget* kustom Anda dapat mengintegrasikan dan memperluas *Material Components* atau *Cupertino Components*.

**Referensi Lengkap:**

  * [Building Custom Widgets](https://www.google.com/search?q=https://flutter.dev/docs/development/ui/widgets/building-layouts%23building-custom-widgets): Dokumentasi resmi Flutter tentang membuat *widget* kustom.
  * [Custom Widget Best Practices](https://www.google.com/search?q=https://medium.com/flutter/the-flutter-way-creating-custom-widgets-d56ee3f114c2): Artikel Medium tentang praktik terbaik dalam membuat *widget* kustom.
  * [Composition vs Inheritance](https://www.google.com/search?q=https://www.geeksforgeeks.org/composition-vs-inheritance-in-object-oriented-programming/): Konsep pemrograman umum yang relevan di Flutter.

**Tips & Best Practices (untuk peserta):**

  * **Mulai dari yang Kecil:** Selalu mulai dengan membangun *widget* yang lebih kecil dan fungsional, lalu kombinasikan untuk membentuk *widget* yang lebih kompleks.
  * **Pisahkan Kekhawatiran:** Jika *widget* Anda mulai menjadi terlalu besar atau kompleks, pertimbangkan untuk memisahkannya menjadi *widget* yang lebih kecil yang memiliki tanggung jawab tunggal.
  * **Pertimbangkan Kembali `StatefulWidget`:** Jika Anda merasa perlu menggunakan `StatefulWidget` hanya untuk meneruskan data ke bawah, pertimbangkan apakah `InheritedWidget` atau manajemen *state* lainnya akan menjadi solusi yang lebih baik dan lebih efisien.
  * **Gunakan `const` dengan Bijak:** Jika *widget* atau bagian dari *widget tree* Anda tidak akan berubah, gunakan `const` untuk membantu *Flutter* mengoptimalkan kinerja *rendering*.

**Potensi Kesalahan Umum & Solusi:**

  * **Kesalahan:** Mencoba memanggil `setState()` di dalam `StatelessWidget`.
      * **Solusi:** `StatelessWidget` tidak memiliki *state* yang dapat diubah. Jika Anda memerlukan *state* internal, ubah *widget* Anda menjadi `StatefulWidget`.
  * **Kesalahan:** Mengakses properti `StatefulWidget` di dalam `State` *object* tanpa menggunakan kata kunci `widget` (misalnya `initialText` alih-alih `widget.initialText`).
      * **Solusi:** Properti *widget* diakses melalui `widget.propertyName` di dalam kelas `State` yang terkait.
  * **Kesalahan:** `Hot Reload` tidak memperbarui *state* yang diharapkan dalam `StatefulWidget`.
      * **Solusi:** `Hot Reload` hanya membangun ulang *widget tree* dari *scratch*, tetapi *state* itu sendiri akan dipertahankan. Jika Anda mengubah parameter *widget* yang digunakan untuk menginisialisasi *state* di `initState`, perubahan itu tidak akan terlihat hingga `Hot Restart`. Gunakan `didUpdateWidget` jika Anda ingin *state* bereaksi terhadap perubahan properti dari *parent*.

-----

Luar biasa\! Anda telah berhasil menuntaskan pembahasan mendalam tentang **Creating Custom Widgets** di *Flutter*. Ini adalah keterampilan yang sangat memberdayakan yang akan memungkinkan Anda untuk membangun hampir semua UI yang Anda inginkan.
