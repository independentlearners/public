# [FASE 3: Navigation & Routing][0]

### Overview Fase

**Deskripsi Fase:**
Fase ini berfokus pada mekanisme inti navigasi antar layar dalam aplikasi Flutter. Pembelajar akan memahami bagaimana aplikasi multi-layar bekerja, mulai dari navigasi dasar `push` dan `pop`, penggunaan _named routes_ untuk navigasi yang lebih terstruktur, hingga konsep lanjutan seperti animasi transisi dan _overlays_ UI. Penguasaan navigasi adalah kunci untuk membangun aplikasi yang fungsional dan memiliki pengalaman pengguna yang lancar.

**Tujuan Pembelajaran Fase:**
Setelah menyelesaikan fase ini, peserta akan mampu:

- Menerapkan navigasi antar layar menggunakan `Navigator.push()` dan `Navigator.pop()`.
- Mengelola data yang dikirim antar layar menggunakan argumen rute.
- Menggunakan _named routes_ untuk navigasi yang lebih bersih dan terkelola.
- Memahami dan mengimplementasikan _route generation_ untuk _named routes_ dinamis.
- Menggunakan `Hero` _animation_ untuk transisi visual yang menarik.
- Menampilkan dialog, _bottom sheets_, dan _snackbars_ sebagai bentuk _overlay_ UI.

**Hubungan dengan Fase Sebelumnya:**
Fase ini sangat bergantung pada pemahaman _Widget System_ (Fase 2). Setiap "layar" dalam aplikasi Flutter adalah sebuah _widget_. Pemahaman tentang bagaimana _widget_ dibangun, bagaimana _state_ dikelola, dan bagaimana _layout_ diatur akan menjadi prasyarat untuk merancang dan mengimplementasikan layar-layar yang akan dinavigasikan.

**Durasi Estimasi:** 2-3 minggu

---

Berikut adalah struktur terperinci untuk **FASE 3: Navigation & Routing**:

<details>
  <summary>📃 Struktur Pembelajaran Internal</summary>

#

- [FASE 3: Navigation \& Routing](#fase-3-navigation--routing)
  - [Overview Fase](#overview-fase)
- [](#)
  - [3.1 Basic Navigation (Push/Pop)](#31-basic-navigation-pushpop)
    - [3.1.1 Navigator and MaterialPageRoute](#311-navigator-and-materialpageroute)
    - [3.1.2 Passing Data Between Screens (Arguments)](#312-passing-data-between-screens-arguments)
  - [3.2 Named Routes](#32-named-routes)
    - [3.2.1 Defining Named Routes (`routes` property)](#321-defining-named-routes-routes-property)
    - [3.2.2 Generating Routes (`onGenerateRoute`)](#322-generating-routes-ongenerateroute)
  - [3.3 Advanced Navigation Concepts](#33-advanced-navigation-concepts)
    - [3.3.1 Hero Animations](#331-hero-animations)
    - [3.3.2 Dialogs, Bottom Sheets, and Snackbars (as overlays)](#332-dialogs-bottom-sheets-and-snackbars-as-overlays)
  - [Selamat!](#selamat)

</details>

---

### 3.1 Basic Navigation (Push/Pop)

Sub-bagian ini adalah fondasi dari semua navigasi di Flutter. Ini akan memperkenalkan konsep _stack navigasi_ dan metode dasar untuk berpindah antar layar.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari bagaimana Flutter mengelola "halaman" atau "layar" aplikasi sebagai tumpukan (_stack_). Setiap kali Anda "membuka" layar baru, itu didorong (_pushed_) ke atas tumpukan. Ketika Anda "kembali" dari layar, itu ditarik (_popped_) dari tumpukan. Ini akan dijelaskan melalui dua _widget_ utama: `Navigator` (yang mengelola tumpukan) dan `MaterialPageRoute` (yang mendefinisikan transisi antar layar). Penguasaan konsep _push_ dan _pop_ adalah prasyarat untuk semua bentuk navigasi yang lebih canggih di Flutter.

**Konsep Kunci & Filosofi Mendalam:**

- **Stack-based Navigation:** Flutter mengimplementasikan navigasi menggunakan konsep _stack_ (tumpukan). Layar yang sedang aktif selalu berada di paling atas tumpukan.

  - **Filosofi:** Model ini intuitif dan mudah dipahami, mirip dengan bagaimana orang berpikir tentang membuka dan menutup halaman di browser atau aplikasi. Ini juga memungkinkan Flutter untuk mengelola _lifecycle_ layar secara efisien.

- **Imperative Navigation (for basic cases):** Menggunakan `Navigator.push()` dan `Navigator.pop()` adalah bentuk navigasi imperatif di mana Anda secara eksplisit memberitahu `Navigator` untuk melakukan aksi.

  - **Filosofi:** Meskipun Flutter menggunakan UI deklaratif, navigasi seringkali melibatkan aksi yang imperatif sebagai respons terhadap _event_ pengguna. Ini adalah salah satu area di mana pendekatan hibrida paling efektif.

- **Route:** Sebuah "rute" (atau _route_) adalah abstraksi dari sebuah layar atau halaman dalam aplikasi. `MaterialPageRoute` adalah jenis _route_ yang paling umum untuk aplikasi Material Design.

  - **Filosofi:** Memisahkan definisi layar dari navigasi itu sendiri, memungkinkan _reusability_ dan modularitas.

**Visualisasi Diagram Alur/Struktur:**

- Diagram tumpukan (_stack_) dengan beberapa kotak (layar) yang menunjukkan bagaimana layar didorong ke atas (`push`) dan ditarik keluar (`pop`).
- Diagram sederhana yang menunjukkan aplikasi dengan dua layar (Layar A, Layar B) dan panah yang menunjukkan `push` dari A ke B, dan `pop` dari B kembali ke A.

**Hubungan dengan Modul Lain:**
Navigasi adalah jembatan antara berbagai _widget_ dan _state_. Tombol (`ElevatedButton`, `TextButton`) dan _gestures_ akan sering memicu aksi navigasi. Data yang dilewatkan antar layar akan memengaruhi _state_ dan tampilan _widget_ di layar tujuan.

---

#### 3.1.1 Navigator and MaterialPageRoute

Sub-bagian ini akan menyelami detail penggunaan `Navigator` dan `MaterialPageRoute` untuk berpindah antar layar.

**Deskripsi Konkret & Peran dalam Kurikulum:**

- **`Navigator`**: Sebuah _widget_ yang mengelola tumpukan `Route`. Ada satu `Navigator` per `MaterialApp` (atau `CupertinoApp`). Anda berinteraksi dengannya menggunakan metode statis seperti `Navigator.of(context).push()` atau `Navigator.of(context).pop()`.
- **`MaterialPageRoute`**: Sebuah kelas yang membuat `Route` yang menggantikan seluruh layar dengan transisi platform-spesifik (misalnya, geser dari kanan di Android, geser dari kiri di iOS). Anda perlu menyediakan `builder` yang mengembalikan _widget_ untuk layar baru.

Ini adalah metode navigasi paling dasar dan langsung, ideal untuk aplikasi kecil atau untuk memahami konsep inti navigasi.

**Konsep Kunci & Filosofi Mendalam:**

- **`BuildContext` dalam Navigasi:** Setiap _widget_ memiliki `BuildContext`. Untuk melakukan navigasi, Anda perlu `BuildContext` dari _widget_ yang berada di bawah `Navigator` di _widget tree_. `Navigator.of(context)` menggunakan `context` untuk menemukan `Navigator` terdekat di atasnya.

  - **Filosofi:** Menekankan pentingnya `BuildContext` sebagai "handle" ke lokasi _widget_ dalam _tree_ dan bagaimana _widget_ dapat berinteraksi dengan _ancestor_-nya.

- **Transisi Platform-Specific:** `MaterialPageRoute` menyediakan transisi default yang terasa _native_ di Android dan iOS.

  - **Filosofi:** Mengurangi pekerjaan pengembang dalam menciptakan _user experience_ yang konsisten dengan platform, sekaligus memungkinkan kustomisasi jika diperlukan.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

// --- Layar Pertama ---
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layar Pertama'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Anda berada di Layar Pertama.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Sintaks: Navigator.of(context).push(MaterialPageRoute(builder: (context) => YourNewScreen()));
                // 'push' menambahkan rute baru ke atas stack.
                // 'MaterialPageRoute' mendefinisikan rute dan transisi UI.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SecondScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Pergi ke Layar Kedua'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Layar Kedua ---
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layar Kedua'),
        backgroundColor: Colors.green,
        // Tombol kembali (panah) secara otomatis ditambahkan jika ada rute sebelumnya di stack.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Anda berada di Layar Kedua.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Sintaks: Navigator.of(context).pop();
                // 'pop' menghapus rute paling atas dari stack, kembali ke rute sebelumnya.
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Kembali ke Layar Pertama'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FirstScreen(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **`Navigator.of(context)`**: Ini adalah cara untuk mendapatkan instance `Navigator` yang terdekat dengan `context` _widget_ Anda. Ini sangat penting karena operasi navigasi memerlukan `Navigator` untuk mengelola _stack_.
- **`push()`**: Metode ini digunakan untuk menambahkan `Route` baru ke bagian atas tumpukan `Navigator`. Ketika sebuah `Route` didorong, `Navigator` membangun `widget` yang sesuai untuk `Route` tersebut dan menganimasikannya ke dalam tampilan.
- **`MaterialPageRoute`**: Ini adalah implementasi `PageRoute` yang menyediakan transisi visual Material Design dan efek _swiping_ ke belakang (di iOS). Konstruktornya memerlukan parameter `builder` yang merupakan fungsi yang mengembalikan _widget_ untuk layar baru. `builder` menerima `BuildContext` baru untuk _widget_ layar kedua.
- **`pop()`**: Metode ini digunakan untuk menghapus `Route` paling atas dari tumpukan `Navigator`. Ketika sebuah `Route` ditarik, `Navigator` menganimasikannya keluar dari tampilan, dan layar di bawahnya akan terlihat kembali. `AppBar` secara otomatis menambahkan tombol kembali jika ada sesuatu untuk kembali.

**Visualisasi Diagram Alur/Struktur:**

- Animasi singkat yang menunjukkan `FirstScreen` diganti oleh `SecondScreen` dengan transisi geser, lalu `SecondScreen` menghilang dengan transisi geser kembali.
- Representasi visual dari _stack_ navigasi:
  - Awal: `[FirstScreen]`
  - Setelah push: `[FirstScreen, SecondScreen]`
  - Setelah pop: `[FirstScreen]`

**Terminologi Esensial & Penjelasan Detail:**

- **Navigator:** _Widget_ yang mengelola tumpukan `Route`.
- **Route:** Representasi abstrak dari sebuah layar atau halaman.
- **MaterialPageRoute:** Jenis `Route` yang menyediakan transisi Material Design.
- **Push:** Aksi menambahkan `Route` ke tumpukan.
- **Pop:** Aksi menghapus `Route` dari tumpukan.
- **Stack:** Struktur data tumpukan di mana `Route` disimpan.
- **BuildContext:** Handle ke lokasi _widget_ dalam _widget tree_, diperlukan untuk operasi `Navigator`.

**Sumber Referensi Lengkap:**

- [Navigator Class (API Docs)](https://api.flutter.dev/flutter/widgets/Navigator-class.html)
- [MaterialPageRoute Class (API Docs)](https://api.flutter.dev/flutter/material/MaterialPageRoute-class.html)
- [Navigation and routing in Flutter (Official Docs)](https://docs.flutter.dev/data/navigation/navigation-basics)
- [Flutter Navigators in 100 Seconds](https://www.youtube.com/watch%3Fv%3DR9C5J2P22vQ)

**Tips dan Praktik Terbaik:**

- **Kapan Menggunakan `push()` dan `pop()`?** Ini adalah cara yang baik untuk navigasi sederhana di mana Anda tahu persis ke layar mana Anda akan pergi dan Anda hanya bergerak satu langkah maju atau mundur.
- **Jangan Lupa `BuildContext`**: Pastikan `context` yang Anda gunakan untuk `Navigator.of(context)` adalah `context` dari _widget_ yang berada di bawah `Navigator` di _widget tree_. `BuildContext` yang salah bisa menyebabkan _error_.
- **Pikirkan Stack:** Selalu bayangkan _stack_ layar Anda. Setiap `push` menambah, setiap `pop` mengurangi.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `Navigator.of(context).push()` gagal atau _crash_ karena `Navigator` tidak ditemukan.

  - **Penyebab:** `BuildContext` yang digunakan tidak memiliki `Navigator` sebagai _ancestor_. Ini sering terjadi jika Anda mencoba memanggil navigasi dari _widget_ yang bukan bagian dari _widget tree_ yang dimulai oleh `MaterialApp` (atau `CupertinoApp`).
  - **Solusi:** Pastikan `MaterialApp` atau `CupertinoApp` adalah _ancestor_ dari _widget_ tempat Anda memanggil navigasi. Untuk _widget_ yang sangat dalam di _tree_, pastikan `context` yang diteruskan adalah yang benar.

- **Kesalahan:** Tidak ada tombol kembali di `AppBar` setelah `push()`.

  - **Penyebab:** Tombol kembali otomatis di `AppBar` hanya muncul jika ada lebih dari satu `Route` di _stack_. Jika `FirstScreen` adalah `home` dari `MaterialApp` dan Anda `push()` ke `SecondScreen`, tombol kembali akan muncul. Tetapi jika Anda `pushReplacement()` atau `popAndPushNamed()` ke `SecondScreen` (yang menghapus `FirstScreen` dari _stack_), maka tidak ada yang bisa dikembalikan, sehingga tidak ada tombol kembali.
  - **Solusi:** Pastikan Anda memahami cara `push()` vs `pushReplacement()`, dll. Jika Anda ingin tombol kembali, pastikan ada `Route` sebelumnya di _stack_. Atau, Anda bisa menambahkan `IconButton` secara manual ke `AppBar` jika diperlukan.

---

#### 3.1.2 Passing Data Between Screens (Arguments)

Sub-bagian ini akan membahas cara mengirim data dari satu layar ke layar lain saat melakukan navigasi. Ini adalah fungsionalitas fundamental untuk membangun aplikasi yang dinamis dan berinteraksi.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari dua metode utama untuk meneruskan data antar layar saat menggunakan navigasi dasar (`Navigator.push()`):

1.  **Melalui Konstruktor Widget**: Data langsung diteruskan ke konstruktor _widget_ layar tujuan. Ini adalah cara paling sederhana dan langsung untuk meneruskan data.
2.  **Mengembalikan Data dari Layar**: Cara layar tujuan dapat mengembalikan hasil atau data kembali ke layar asal saat layar tujuan di-_pop_.

Penguasaan teknik ini sangat penting untuk membuat aplikasi di mana satu layar bergantung pada input atau hasil dari layar lain (misalnya, layar detail produk yang menampilkan data produk tertentu, atau layar pengaturan yang mengembalikan preferensi yang diubah).

**Konsep Kunci & Filosofi Mendalam:**

- **Dependency Injection (via Constructor):** Meneruskan data melalui konstruktor adalah bentuk dasar dari _dependency injection_. Layar tujuan secara eksplisit mendeklarasikan data apa yang dibutuhkannya.

  - **Filosofi:** Membuat _widget_ lebih mandiri dan dapat diuji. Sebuah _widget_ hanya akan tahu tentang data yang diteruskan kepadanya, bukan bagaimana data itu didapatkan.

- **Future and Asynchronous Programming (for returning data):** Mengembalikan data dari layar yang di-_pop_ melibatkan konsep `Future` dan `async/await`, karena aksi _pop_ adalah operasi asinkron.

  - **Filosofi:** Memperkenalkan pembelajar pada pola pemrograman asinkron yang umum di Flutter dan Dart, yang krusial untuk operasi I/O dan interaksi UI yang responsif.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

// --- Layar Pertama (Mengirim Data) ---
class FirstScreenWithData extends StatefulWidget {
  const FirstScreenWithData({super.key});

  @override
  State<FirstScreenWithData> createState() => _FirstScreenWithDataState();
}

class _FirstScreenWithDataState extends State<FirstScreenWithData> {
  String _returnedData = 'Belum ada data dari Layar Kedua.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layar Pertama (Kirim/Terima Data)'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Anda berada di Layar Pertama.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Data yang diterima: $_returnedData',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final String dataToSend = 'Halo dari Layar Pertama!';
                final String? result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    // 1. Meneruskan data melalui konstruktor
                    builder: (context) => SecondScreenWithData(data: dataToSend),
                  ),
                );

                // 2. Menerima data yang dikembalikan dari layar kedua
                if (result != null) {
                  setState(() {
                    _returnedData = 'Diterima: "$result"';
                  });
                } else {
                  setState(() {
                    _returnedData = 'Layar Kedua ditutup tanpa data.';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Pergi ke Layar Kedua & Kirim Data'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Layar Kedua (Menerima Data & Mengembalikan Data) ---
class SecondScreenWithData extends StatelessWidget {
  // Properti untuk menerima data yang diteruskan melalui konstruktor
  final String data;

  const SecondScreenWithData({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layar Kedua (Terima/Kembalikan Data)'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Anda berada di Layar Kedua.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Data diterima dari Layar Pertama: "$data"',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Sintaks: Navigator.of(context).pop(dataToReturn);
                // 'pop' dapat mengembalikan data ke layar sebelumnya.
                Navigator.of(context).pop('Halo dari Layar Kedua!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Kembali & Kirim Balasan'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Pop tanpa mengembalikan data
                Navigator.of(context).pop();
              },
              child: const Text('Kembali Tanpa Balasan'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FirstScreenWithData(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **Meneruskan Data (Layar Pertama ke Layar Kedua):**

  - Di `FirstScreenWithData`, saat memanggil `Navigator.of(context).push()`, kita membuat instance `SecondScreenWithData` dan meneruskan data melalui konstruktornya: `SecondScreenWithData(data: dataToSend)`.
  - Di `SecondScreenWithData`, kita mendeklarasikan properti `final String data;` di konstruktornya dan menggunakannya untuk menampilkan teks yang diterima. Menggunakan `final` pada properti data di `StatelessWidget` adalah praktik terbaik karena menandakan bahwa data tersebut tidak akan berubah setelah _widget_ dibuat.

- **Mengembalikan Data (Layar Kedua ke Layar Pertama):**

  - Di `SecondScreenWithData`, ketika `Navigator.of(context).pop()` dipanggil, kita dapat meneruskan argumen ke metode `pop()`: `Navigator.of(context).pop('Halo dari Layar Kedua!');`. Argumen ini akan menjadi nilai _return_ dari `Future` yang dikembalikan oleh `push()`.
  - Di `FirstScreenWithData`, panggilan `push()` dibungkus dalam blok `async`/`await`:
    ```dart
    final String? result = await Navigator.of(context).push(...);
    ```
    Kata kunci `await` menunggu hingga `Future` yang dikembalikan oleh `push()` selesai (yaitu, ketika `SecondScreenWithData` di-_pop_). Nilai yang diteruskan ke `pop()` kemudian ditangkap oleh variabel `result`.
  - `result` bisa `null` jika layar di-_pop_ tanpa data (misalnya, tombol kembali fisik atau `pop()` tanpa argumen). Oleh karena itu, penting untuk menangani kasus `null`.

**Visualisasi Diagram Alur/Struktur:**

- Diagram panah yang menunjukkan aliran data: `FirstScreen` -\> `push(data)` -\> `SecondScreen`.
- Diagram panah terbalik yang menunjukkan aliran data yang dikembalikan: `SecondScreen` -\> `pop(result)` -\> `FirstScreen` menerima `result`.
- Representasi _pseudo-code_ dari `async/await` dalam konteks `push()` dan `pop()`.

**Terminologi Esensial & Penjelasan Detail:**

- **Constructor Arguments:** Meneruskan data langsung ke konstruktor _widget_ tujuan.
- **Returning Data:** Mengembalikan nilai dari layar yang di-_pop_ kembali ke layar asal.
- **`async` / `await`:** Kata kunci dalam Dart untuk menangani operasi asinkron. `push()` mengembalikan `Future`, dan `await` digunakan untuk menunggu penyelesaian `Future` tersebut.
- **`Future<T>`:** Objek yang mewakili hasil dari operasi asinkron yang mungkin belum selesai. `T` adalah tipe data yang akan dikembalikan.
- **`Navigator.pop(result)`:** Metode `pop` yang juga meneruskan nilai `result` kembali ke `Future` yang menunggu di layar sebelumnya.

**Sumber Referensi Lengkap:**

- [Navigation and routing in Flutter (Official Docs) - Pass arguments to a named route (konsepnya mirip untuk constructor arguments)](https://docs.flutter.dev/data/navigation/navigation-basics%23pass-arguments-to-a-named-route)
- [Return data from a screen (Cookbook)](https://docs.flutter.dev/cookbook/navigation/returning-data)
- [Futures and async-await (Dart Documentation)](https://dart.dev/guides/language/language-tour%23futures)

**Tips dan Praktik Terbaik:**

- **Gunakan Konstruktor untuk Data yang Diperlukan:** Jika sebuah layar _pasti_ membutuhkan data tertentu untuk berfungsi, teruskannya melalui konstruktor dan deklarasikan sebagai `required` (misalnya `required this.data`). Ini membuat API _widget_ lebih jelas dan mencegah _bug_ data yang hilang.
- **Pertimbangkan Nullability:** Ketika mengembalikan data dengan `pop()`, ingat bahwa `result` bisa `null` jika layar ditutup dengan cara lain (misalnya, tombol kembali sistem Android/gesture _swipe_ kembali di iOS). Selalu periksa `null` jika data opsional.
- **Kapan Tidak Mengembalikan Data Besar:** Untuk data yang sangat besar atau kompleks, meneruskannya melalui `pop()` mungkin kurang efisien. Pertimbangkan untuk menggunakan _state management_ (akan dibahas di fase selanjutnya) untuk berbagi _state_ global.
- **Tipe Data yang Dikembalikan:** Anda bisa mengembalikan tipe data apapun (String, int, Map, bahkan objek kustom) dari `pop()`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Data yang diteruskan melalui konstruktor adalah `null` atau tipe yang salah, menyebabkan _runtime error_.

  - **Penyebab:** Lupa meneruskan argumen, atau meneruskan tipe data yang salah saat memanggil konstruktor layar tujuan.
  - **Solusi:** Gunakan `required` pada properti konstruktor jika data wajib ada. Gunakan _type checking_ atau pastikan tipe data konsisten.

- **Kesalahan:** `Future` dari `push()` tidak pernah selesai atau `await` tidak berfungsi.

  - **Penyebab:** Lupa memanggil `Navigator.pop()` di layar tujuan. Jika layar tidak pernah di-_pop_, `Future` tidak akan pernah selesai dan `await` akan terus menunggu.
  - **Solusi:** Pastikan ada mekanisme untuk `pop` layar tujuan (misalnya, tombol, tombol kembali `AppBar` default).

- **Kesalahan:** `setState()` dipanggil di `StatelessWidget` untuk memperbarui data yang diterima.

  - **Penyebab:** `StatelessWidget` tidak memiliki _state_ yang dapat berubah. Jika Anda menerima data yang kemudian perlu ditampilkan atau diproses secara dinamis di layar pertama, layar pertama harus berupa `StatefulWidget`.
  - **Solusi:** Pastikan layar yang menerima data dan perlu memperbarui UI adalah `StatefulWidget`, dan pembaruan UI dilakukan di dalam `setState()`. (Seperti contoh `FirstScreenWithData` di atas).

---

### 3.2 Named Routes

Sub-bagian ini akan memperkenalkan konsep _named routes_, sebuah metode yang lebih terstruktur dan _scalable_ untuk navigasi dibandingkan dengan `MaterialPageRoute` eksplisit.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan memahami bahwa daripada membuat `MaterialPageRoute` baru setiap kali navigasi, layar dapat diberi nama (string) yang unik. Navigasi kemudian dilakukan dengan merujuk nama tersebut. Ini sangat berguna untuk aplikasi yang lebih besar dengan banyak layar, karena membantu menjaga kode navigasi tetap bersih, mudah dibaca, dan dikelola. Konsep _named routes_ juga mendukung _deep linking_ (membuka aplikasi ke layar tertentu dari URL atau notifikasi).

**Konsep Kunci & Filosofi Mendalam:**

- **Declarative Routing:** Dengan _named routes_, Anda mendeklarasikan semua rute yang mungkin di satu tempat (biasanya di `MaterialApp`). Ini berbeda dari pendekatan imperatif `push()`/`pop()` yang langsung membuat `MaterialPageRoute`.

  - **Filosofi:** Meningkatkan keterbacaan dan pemeliharaan kode dengan mengonsolidasikan definisi rute. Ini juga memungkinkan Flutter untuk mengoptimalkan _route management_ secara internal.

- **Scalability & Maintainability:** Untuk aplikasi besar, mengelola banyak `MaterialPageRoute` eksplisit akan menjadi rumit. _Named routes_ menyediakan cara yang lebih bersih untuk merujuk dan mengatur rute.

  - **Filosofi:** Mempromosikan praktik pengembangan yang baik untuk aplikasi skala besar, mengurangi _boilerplate_ dan _error_ yang terkait dengan _string_ yang salah ketik.

- **Deep Linking Foundation:** _Named routes_ adalah dasar untuk mengimplementasikan _deep linking_, di mana URL eksternal atau notifikasi dapat langsung membuka layar tertentu dalam aplikasi.

  - **Filosofi:** Memungkinkan integrasi aplikasi yang lebih dalam dengan ekosistem sistem operasi dan memberikan _user experience_ yang lebih mulus.

**Visualisasi Diagram Alur/Struktur:**

- Diagram yang menunjukkan `MaterialApp` dengan daftar `routes` yang memetakan nama (`/home`, `/details`) ke _widget_ layar.
- Alur navigasi: Tombol -\> `Navigator.pushNamed('/details')` -\> `Navigator` mencari `/details` di peta rute -\> Menampilkan layar terkait.

**Hubungan dengan Modul Lain:**
_Named routes_ akan digunakan sebagai alternatif dari `MaterialPageRoute` untuk semua bentuk navigasi berikutnya. Konsep pengiriman data antar layar juga relevan, tetapi dengan sedikit perbedaan implementasi saat menggunakan _named routes_.

---

#### 3.2.1 Defining Named Routes (`routes` property)

Sub-bagian ini akan menjelaskan cara mendefinisikan _named routes_ menggunakan properti `routes` di `MaterialApp` dan cara menggunakannya untuk navigasi dasar.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari bagaimana mendaftarkan semua _named routes_ aplikasi dalam sebuah `Map<String, WidgetBuilder>` yang diteruskan ke properti `routes` dari `MaterialApp`. Setiap entri dalam _map_ ini memiliki kunci (nama rute, misalnya `'/detail'`) dan nilai (`WidgetBuilder` yang mengembalikan instance _widget_ layar yang sesuai). Setelah rute didefinisikan, navigasi dapat dilakukan dengan `Navigator.pushNamed()`.

**Konsep Kunci & Filosofi Mendalam:**

- **Centralized Route Management:** Mendefinisikan rute di satu tempat memudahkan untuk melihat semua rute yang tersedia dan memastikan konsistensi dalam penamaan.

  - **Filosofi:** Mengurangi _magic strings_ yang tersebar di seluruh kode dan menyediakan titik tunggal untuk konfigurasi navigasi.

- **Route Home (`/`):** Rute awal aplikasi (`/`) biasanya didefinisikan sebagai properti `home` di `MaterialApp`, tetapi bisa juga didefinisikan di `routes` dengan kunci `'/'`.

  - **Filosofi:** Memberikan titik masuk yang jelas untuk aplikasi.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

// --- Layar Awal (Home Screen) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen (Named Routes)'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Selamat datang di Home Screen!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Sintaks: Navigator.of(context).pushNamed(routeName);
                // Menggunakan pushNamed untuk navigasi ke rute dengan nama '/settings'.
                Navigator.of(context).pushNamed('/settings');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Pergi ke Pengaturan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Untuk rute yang belum didefinisikan atau memerlukan argumen kompleks,
                // tetap bisa menggunakan MaterialPageRoute.
                // Namun, kita akan bahas cara meneruskan argumen di named routes selanjutnya.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(item: 'Item Default'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Pergi ke Detail (Langsung)'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Layar Pengaturan ---
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Ini adalah Layar Pengaturan.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Pop untuk kembali ke rute sebelumnya
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Layar Detail (untuk demonstrasi, akan dihubungkan dengan named routes nanti) ---
class DetailScreen extends StatelessWidget {
  final String item;
  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Ini adalah Layar Detail.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Menampilkan detail untuk: "$item"',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
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
    return MaterialApp(
      title: 'Named Routes Demo',
      // Properti 'home' adalah rute awal aplikasi
      home: const HomeScreen(), // Layar awal saat aplikasi dibuka

      // Properti 'routes' adalah Map yang mendefinisikan named routes
      // Kunci adalah nama rute (String), Nilai adalah WidgetBuilder (fungsi yang mengembalikan widget layar)
      routes: {
        // '/': (context) => const HomeScreen(), // Opsional: bisa juga definisikan home di sini
        '/settings': (context) => const SettingsScreen(),
        // Catatan: '/detail' tidak bisa didefinisikan langsung di sini karena memerlukan argumen konstruktor.
        // Akan dibahas di 3.2.2 Generating Routes.
      },
    );
  }
}
```

**Penjelasan Konteks Kode:**

- **`MaterialApp` `home` vs `initialRoute` + `routes`**:
  - Properti `home` dari `MaterialApp` digunakan untuk menentukan _widget_ awal yang akan ditampilkan saat aplikasi pertama kali diluncurkan. Ini secara otomatis menjadi rute pertama dalam _stack_ `Navigator`.
  - Alternatifnya, Anda dapat menggunakan properti `initialRoute` (misalnya `initialRoute: '/'`) bersama dengan properti `routes`. Jika `initialRoute` dan `home` keduanya ditentukan, `initialRoute` akan diabaikan.
- **`routes` Property**:
  - Ini adalah `Map<String, WidgetBuilder>` di `MaterialApp`.
  - Kunci (`String`) adalah nama unik untuk rute (misalnya, `'/settings'`). Penting untuk menggunakan nama yang konsisten.
  - Nilai (`WidgetBuilder`) adalah sebuah fungsi (biasanya `(context) => YourWidget()`) yang mengembalikan instance _widget_ yang akan menjadi layar untuk rute tersebut.
  - **Penting**: `WidgetBuilder` tidak boleh menerima argumen tambahan. Ini berarti rute yang memerlukan data yang diteruskan melalui konstruktor tidak dapat didefinisikan langsung di sini. Ini akan dibahas di 3.2.2 (`onGenerateRoute`).
- **`Navigator.of(context).pushNamed(routeName)`**:
  - Ini adalah metode untuk menavigasi ke _named route_. Anda hanya perlu menyediakan nama rutenya.
  - `Navigator` akan mencari nama rute ini di `routes` _map_ yang telah Anda definisikan di `MaterialApp` dan kemudian mendorong `Route` yang sesuai ke _stack_.
- **`Navigator.of(context).pop()`**:
  - Berfungsi sama seperti pada navigasi dasar. Ini akan menghapus rute yang sedang aktif dari _stack_, menampilkan rute sebelumnya.

**Visualisasi Diagram Alur/Struktur:**

- Diagram yang lebih detail tentang `MaterialApp` dan `routes` map-nya.
- Alur navigasi yang menekankan bagaimana `pushNamed` merujuk ke _map_ rute untuk menemukan _widget_ yang akan ditampilkan.

**Terminologi Esensial & Penjelasan Detail:**

- **Named Route:** Sebuah rute yang diidentifikasi oleh sebuah _string_ unik (nama).
- **`routes` (property):** Sebuah properti di `MaterialApp` yang merupakan `Map` dari nama rute ke `WidgetBuilder` yang membangun _widget_ layar.
- **`WidgetBuilder`:** Sebuah `typedef` untuk fungsi yang menerima `BuildContext` dan mengembalikan `Widget`.
- **`pushNamed()`:** Metode `Navigator` untuk menavigasi ke _named route_.
- **`home` (property):** Properti `MaterialApp` yang mendefinisikan _widget_ awal aplikasi.

**Sumber Referensi Lengkap:**

- [Navigation and routing in Flutter (Official Docs) - Named routes](https://docs.flutter.dev/data/navigation/navigation-basics%23named-routes)
- [MaterialApp Class (API Docs)](https://api.flutter.dev/flutter/material/MaterialApp-class.html)
- [Navigator.pushNamed Method (API Docs)](https://api.flutter.dev/flutter/widgets/Navigator/pushNamed.html)

**Tips dan Praktik Terbaik:**

- **Konstanta Nama Rute:** Untuk menghindari _typo_ dan mempermudah _refactoring_, simpan nama rute sebagai konstanta statis di kelas terpisah atau di dalam kelas _widget_ itu sendiri.

  ```dart
  class AppRoutes {
    static const String home = '/';
    static const String settings = '/settings';
    static const String detail = '/detail'; // Akan digunakan nanti
  }

  // Kemudian gunakan: Navigator.of(context).pushNamed(AppRoutes.settings);
  ```

- **Skalabilitas:** Untuk aplikasi kecil, `MaterialPageRoute` langsung mungkin cukup. Tetapi untuk aplikasi yang lebih besar atau yang membutuhkan _deep linking_, _named routes_ sangat direkomendasikan.
- **Pilih Salah Satu:** Jangan campur terlalu banyak `home`, `routes`, dan `onGenerateRoute` tanpa pemahaman yang jelas. Untuk rute yang sangat sederhana, `home` dan `routes` mungkin cukup. Untuk kasus yang lebih kompleks, `onGenerateRoute` lebih powerful.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** "Route with name 'X' was not found."

  - **Penyebab:**
    - Nama rute di `pushNamed()` tidak cocok dengan nama rute yang didefinisikan di `routes` _map_.
    - Lupa mendeklarasikan rute di `routes` _map_ di `MaterialApp`.
    - Mencoba menavigasi ke _named route_ yang memerlukan argumen konstruktor melalui properti `routes` langsung (yang tidak mengizinkan argumen).
  - **Solusi:** Periksa kembali nama rute, pastikan ejaannya sama persis. Pastikan rute didefinisikan. Untuk rute dengan argumen, gunakan `onGenerateRoute` (akan dibahas di sub-bagian selanjutnya).

- **Kesalahan:** `builder` di `routes` mengembalikan instance _widget_ dengan konstruktor yang salah.

  - **Penyebab:** `WidgetBuilder` (nilai dalam `routes` _map_) haruslah fungsi yang hanya menerima `BuildContext` dan mengembalikan `Widget`. Anda tidak dapat meneruskan argumen langsung ke konstruktor _widget_ dari sini.
  - **Solusi:** Jika _widget_ layar membutuhkan argumen, Anda harus menggunakan `onGenerateRoute` atau tetap menggunakan `MaterialPageRoute` secara eksplisit.

---

#### 3.2.2 Generating Routes (`onGenerateRoute`)

Sub-bagian ini akan menjelaskan mekanisme yang lebih canggih untuk mengelola _named routes_, terutama ketika rute membutuhkan argumen yang dinamis atau ketika rute tidak didefinisikan secara statis.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari `onGenerateRoute` sebagai _callback_ di `MaterialApp` yang dipanggil ketika `Navigator.pushNamed()` dipanggil untuk nama rute yang **tidak** ada dalam `routes` _map_ statis. Ini adalah metode yang sangat kuat dan fleksibel untuk:

1.  **Meneruskan Argumen ke Named Routes:** Memungkinkan Anda untuk mengirim data kompleks ke layar tujuan melalui properti `arguments` dari `RouteSettings`.
2.  **Validasi Rute Dinamis:** Memproses nama rute dinamis (misalnya, `/products/123` di mana `123` adalah ID produk).
3.  **Penanganan Rute Tidak Ditemukan:** Mengarahkan pengguna ke layar "404 Not Found" jika rute yang diminta tidak ada.

Penguasaan `onGenerateRoute` adalah kunci untuk membangun aplikasi dengan navigasi yang kompleks dan _scalable_, serta untuk mengimplementasikan fitur seperti _deep linking_ dengan lebih efektif.

**Konsep Kunci & Filosofi Mendalam:**

- **Centralized Dynamic Route Management:** Berbeda dengan `routes` properti yang statis, `onGenerateRoute` memberikan kontrol terpusat yang dinamis atas pembuatan rute.

  - **Filosofi:** Memberikan fleksibilitas yang lebih besar dalam menangani skenario navigasi yang lebih kompleks, terutama ketika rute atau argumen rute ditentukan saat _runtime_.

- **`RouteSettings`:** Objek yang diteruskan ke _callback_ `onGenerateRoute`, berisi nama rute yang diminta dan argumen opsional yang diteruskan.

  - **Filosofi:** Menyediakan konteks lengkap tentang permintaan navigasi, memungkinkan logika pembuatan rute yang cerdas.

- **Error Handling in Routing:** `onGenerateRoute` memungkinkan penanganan rute yang tidak valid atau tidak ditemukan secara elegan.

  - **Filosofi:** Meningkatkan _robustness_ aplikasi dengan menyediakan _fallback_ untuk kasus navigasi yang tidak terduga.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

// Definisi nama rute sebagai konstanta untuk menghindari typo
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String settings = '/settings';
  static const String unknown = '/unknown';
}

// Model data yang akan diteruskan
class ItemArguments {
  final String title;
  final String description;

  ItemArguments(this.title, this.description);
}

// --- Layar Awal (Home Screen) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Selamat datang di Home Screen!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke named route '/settings' yang statis
                Navigator.of(context).pushNamed(AppRoutes.settings);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Pergi ke Pengaturan'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke named route '/detail' dan meneruskan argumen
                // Sintaks: Navigator.of(context).pushNamed(routeName, arguments: data);
                final args = ItemArguments('Produk XYZ', 'Detail lengkap untuk produk XYZ yang luar biasa ini.');
                Navigator.of(context).pushNamed(AppRoutes.detail, arguments: args);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Pergi ke Detail Produk'),
            ),
            const SizedBox(height: 20),
             ElevatedButton(
              onPressed: () {
                // Mencoba navigasi ke rute yang tidak dikenal
                Navigator.of(context).pushNamed('/nonExistentRoute');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Pergi ke Rute Tidak Dikenal'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Layar Pengaturan (didefinisikan statis di 'routes') ---
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Ini adalah Layar Pengaturan.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Layar Detail (Menerima Argumen dari onGenerateRoute) ---
class DetailScreen extends StatelessWidget {
  final ItemArguments args;

  // DetailScreen sekarang membutuhkan ItemArguments
  const DetailScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Ini adalah Layar Detail.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Judul: "${args.title}"\nDeskripsi: "${args.description}"',
                style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Layar "404 Not Found" ---
class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Tidak Ditemukan'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'Oops! Halaman yang Anda cari tidak ada.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Kembali ke Home Screen atau pop jika ada rute sebelumnya
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Kembali ke Home'),
            ),
          ],
        ),
      ),
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
    return MaterialApp(
      title: 'Named Routes with onGenerateRoute Demo',
      // Menggunakan home untuk rute awal
      home: const HomeScreen(),

      // 'routes' untuk rute statis yang tidak memerlukan argumen
      routes: {
        AppRoutes.settings: (context) => const SettingsScreen(),
        // AppRoutes.home: (context) => const HomeScreen(), // Opsional jika sudah ada home
      },

      // 'onGenerateRoute' adalah fungsi yang dipanggil ketika Navigator.pushNamed
      // dipanggil untuk rute yang TIDAK ada di dalam 'routes' map.
      onGenerateRoute: (RouteSettings settings) {
        // 'settings' berisi informasi tentang rute yang diminta:
        // - settings.name: Nama rute yang diminta (e.g., '/detail')
        // - settings.arguments: Argumen yang diteruskan saat pushNamed (e.g., ItemArguments)

        switch (settings.name) {
          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case AppRoutes.detail:
            // Cast arguments ke tipe yang diharapkan (ItemArguments)
            final args = settings.arguments as ItemArguments; // Hati-hati dengan type casting!
            return MaterialPageRoute(
              builder: (_) => DetailScreen(args: args),
            );
          case AppRoutes.settings:
            // Meskipun sudah ada di 'routes', kita bisa menanganinya di sini juga
            // jika ingin logika tambahan. Tapi umumnya cukup di 'routes'.
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          default:
            // Ini adalah fallback untuk rute yang tidak dikenali
            return MaterialPageRoute(builder: (_) => const UnknownRouteScreen());
        }
      },

      // 'onUnknownRoute' adalah fallback terakhir jika onGenerateRoute
      // juga mengembalikan null atau tidak ada rute yang cocok.
      // Ini jarang digunakan jika onGenerateRoute sudah komprehensif.
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (_) => const UnknownRouteScreen());
      },
    );
  }
}
```

**Penjelasan Konteks Kode:**

- **`AppRoutes` Class**: Praktik terbaik untuk mendefinisikan nama rute sebagai konstanta statis untuk menghindari _typo_ dan mempermudah _refactoring_.
- **`ItemArguments` Class**: Contoh kelas sederhana untuk membungkus data yang akan diteruskan. Ini lebih baik daripada meneruskan `Map` atau tipe primitif langsung, karena memberikan _type safety_.
- **`MaterialApp` `onGenerateRoute`**:
  - Properti ini menerima `RouteFactory`, yaitu sebuah fungsi yang mengambil `RouteSettings` dan mengembalikan `Route?`.
  - Fungsi ini dipanggil ketika `Navigator.pushNamed()` dipanggil dan rute yang diminta tidak ditemukan di _map_ `routes` yang statis.
  - Di dalam _callback_, Anda dapat memeriksa `settings.name` untuk mengetahui rute mana yang diminta.
  - Anda dapat mengakses argumen yang diteruskan melalui `settings.arguments`. Penting untuk melakukan _type casting_ argumen ke tipe yang benar (`as ItemArguments`).
  - Anda harus mengembalikan `MaterialPageRoute` (atau jenis `PageRoute` lainnya) yang mengembalikan _widget_ layar yang sesuai.
  - Jika rute tidak dikenali, Anda bisa mengembalikan `MaterialPageRoute` ke layar kesalahan (`UnknownRouteScreen`) atau mengembalikan `null` (yang kemudian akan memicu `onUnknownRoute` jika didefinisikan).
- **`Navigator.of(context).pushNamed(AppRoutes.detail, arguments: args)`**:
  - Saat memanggil `pushNamed`, Anda dapat meneruskan objek apa pun sebagai `arguments`. Objek ini akan tersedia di `settings.arguments` di _callback_ `onGenerateRoute`.
- **`Navigator.of(context).popUntil((route) => route.isFirst)`**: Contoh penggunaan `Navigator` yang lebih canggih untuk kembali ke rute paling awal di _stack_ (biasanya rute `home`).

**Visualisasi Diagram Alur/Struktur:**

- Diagram alur yang menunjukkan urutan pencarian rute:
  - `pushNamed('X')` -\> Cek `routes` _map_
  - Jika ditemukan: Gunakan rute dari `routes`
  - Jika tidak ditemukan: Panggil `onGenerateRoute`
  - Di dalam `onGenerateRoute`: Cek `settings.name`, ambil `settings.arguments`, buat `MaterialPageRoute`
  - Jika `onGenerateRoute` gagal/mengembalikan `null`: Panggil `onUnknownRoute`.

**Terminologi Esensial & Penjelasan Detail:**

- **`onGenerateRoute`:** Callback di `MaterialApp` untuk membuat `Route` secara dinamis.
- **`RouteSettings`:** Objek yang berisi informasi tentang permintaan navigasi, termasuk `name` dan `arguments`.
- **`settings.name`:** Nama rute yang diminta oleh `pushNamed()`.
- **`settings.arguments`:** Argumen yang diteruskan ke `pushNamed()` melalui parameter `arguments`.
- **Dynamic Routing:** Kemampuan untuk membuat rute saat _runtime_ berdasarkan data.
- **`onUnknownRoute`:** _Callback_ terakhir yang dipanggil jika `onGenerateRoute` tidak mengembalikan rute yang valid.

**Sumber Referensi Lengkap:**

- [Navigation and routing in Flutter (Official Docs) - Generate routes with `onGenerateRoute`](<https://docs.flutter.dev/data/navigation/navigation-basics%23generate-routes-with-ongenerateroute%5D(https://docs.flutter.dev/data/navigation/navigation-basics%23generate-routes-with-ongenerateroute)>)
- [MaterialApp Class (API Docs)](https://api.flutter.dev/flutter/material/MaterialApp-class.html)
- [RouteSettings Class (API Docs)](https://api.flutter.dev/flutter/widgets/RouteSettings-class.html)
- [Flutter Navigation with Named Routes and Arguments](https://medium.com/flutter-community/flutter-navigation-with-named-routes-and-arguments-e5f80b85a3a7)

**Tips dan Praktik Terbaik:**

- **Pusatkan Logika `onGenerateRoute`:** Jaga agar logika `onGenerateRoute` tetap bersih dan terorganisir, idealnya menggunakan `switch` _statement_ seperti contoh.
- **Type Safety untuk Argumen:** Selalu gunakan kelas kustom (seperti `ItemArguments`) untuk membungkus argumen, bukan hanya `Map<String, dynamic>` atau tipe primitif. Ini memberikan _type safety_ dan membuat kode lebih mudah dibaca dan di-_maintain_.
- **Penanganan Error Rute:** Selalu sertakan kasus `default` di `switch` _statement_ `onGenerateRoute` untuk menangani rute yang tidak valid, biasanya dengan mengarahkan ke layar "404 Not Found" (`UnknownRouteScreen`). Ini jauh lebih baik daripada membiarkan aplikasi _crash_.
- **Jangan Campur `routes` dan `onGenerateRoute` untuk Rute yang Sama:** Jika sebuah rute didefinisikan di `routes` _map_, `onGenerateRoute` tidak akan dipanggil untuk rute tersebut. Gunakan `onGenerateRoute` untuk semua rute yang dinamis atau yang memerlukan argumen.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** "type 'dynamic' is not a subtype of type 'ItemArguments' in type cast".

  - **Penyebab:** Argumen yang diterima di `settings.arguments` memiliki tipe yang salah atau `null`. Ini sering terjadi jika Anda lupa meneruskan argumen di `pushNamed()` atau meneruskan tipe data yang tidak sesuai.
  - **Solusi:** Pastikan Anda meneruskan objek `ItemArguments` (atau tipe yang diharapkan) saat memanggil `pushNamed`. Selalu periksa `null` atau gunakan `as` dengan hati-hati (misalnya, `settings.arguments as ItemArguments?` dan kemudian periksa `null`).

- **Kesalahan:** Rute tidak ditemukan meskipun sudah didefinisikan di `onGenerateRoute`.

  - **Penyebab:**
    - Nama rute di `pushNamed()` tidak cocok dengan `case` di `onGenerateRoute`.
    - Ada rute dengan nama yang sama di properti `routes` statis (yang akan diprioritaskan).
  - **Solusi:** Periksa ejaan nama rute. Pastikan tidak ada duplikasi nama rute antara `routes` dan `onGenerateRoute` jika Anda ingin `onGenerateRoute` menangani rute tersebut.

- **Kesalahan:** Aplikasi _crash_ saat navigasi, terutama setelah _hot restart_.

  - **Penyebab:** Kadang-kadang _hot restart_ dapat menyebabkan _state_ navigasi yang aneh.
  - **Solusi:** Coba _full restart_ aplikasi (stop dan jalankan ulang). Ini lebih sering terjadi di awal pengembangan.

---

### 3.3 Advanced Navigation Concepts

Sub-bagian ini akan membahas aspek-aspek navigasi yang lebih canggih yang meningkatkan pengalaman pengguna dan kemampuan aplikasi. Ini melampaui transisi layar dasar dan melibatkan _overlays_ UI.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari bagaimana menambahkan sentuhan profesional pada aplikasi dengan animasi transisi yang menarik dan cara menggunakan _overlays_ UI seperti dialog, _bottom sheets_, dan _snackbars_ untuk memberikan informasi atau menerima input dalam konteks yang berbeda.

- **`Hero` Animations**: Memungkinkan transisi visual yang mulus dari satu _widget_ di satu layar ke _widget_ yang sama di layar lain. Ini menciptakan efek visual yang sangat menarik dan intuitif.
- **Dialogs, Bottom Sheets, and Snackbars**: Ini adalah bentuk _overlay_ UI yang tidak sepenuhnya menggantikan layar, melainkan muncul di atas konten yang sudah ada. Mereka digunakan untuk interaksi cepat, konfirmasi, pesan singkat, atau menampilkan informasi tambahan tanpa harus menavigasi ke layar baru.

Penguasaan konsep ini sangat penting untuk membangun aplikasi Flutter yang tidak hanya fungsional tetapi juga memiliki _user experience_ yang kaya dan intuitif.

**Konsep Kunci & Filosofi Mendalam:**

- **Shared Element Transitions:** `Hero` _animation_ adalah implementasi dari konsep _shared element transition_, di mana sebuah elemen UI "terbang" dari posisi awalnya ke posisi akhirnya di layar baru.

  - **Filosofi:** Meningkatkan _perceived performance_ dan memberikan isyarat visual kepada pengguna tentang hubungan antara dua layar, sehingga membuat navigasi terasa lebih kohesif dan alami.

- **Overlay vs. Route:** Dialog, _bottom sheets_, dan _snackbars_ adalah _overlays_ yang ditampilkan di atas _route_ yang sedang aktif, bukan sebagai _route_ baru dalam _stack Navigator_.

  - **Filosofi:** Memungkinkan interaksi pengguna yang cepat dan kontekstual tanpa mengganggu alur navigasi utama atau menumpuk _stack_ `Navigator` dengan layar yang bersifat sementara. Ini juga meminimalkan _boilerplate_ jika hanya dibutuhkan interaksi kecil.

- **Modal vs. Non-Modal UI:** Dialog dan _bottom sheets_ seringkali bersifat modal (memblokir interaksi dengan konten di bawahnya sampai ditutup), sementara _snackbars_ bersifat non-modal (muncul sebentar dan tidak memblokir interaksi).

  - **Filosofi:** Memilih jenis _overlay_ yang tepat sesuai dengan tujuan interaksi dan dampaknya terhadap alur kerja pengguna.

**Visualisasi Diagram Alur/Struktur:**

- Animasi singkat yang menunjukkan `Hero` _animation_ (misalnya, gambar thumbnail di daftar "membesar" menjadi gambar penuh di layar detail).
- _Screenshot_ atau ilustrasi yang menunjukkan dialog, _bottom sheet_, dan _snackbar_ muncul di atas layar utama, menunjukkan posisi dan perilakunya.

**Hubungan dengan Modul Lain:**
Konsep ini akan digunakan bersama dengan semua teknik navigasi yang sudah dipelajari. `Hero` _animation_ bekerja dengan `Navigator.push()` atau `pushNamed()`. Dialog, _bottom sheets_, dan _snackbars_ sering dipicu oleh interaksi dari _widget_ interaktif (tombol, _list item_).

---

#### 3.3.1 Hero Animations

Sub-bagian ini akan menjelaskan cara menggunakan _widget_ `Hero` untuk menciptakan efek transisi visual yang menarik antara dua layar.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan belajar bagaimana `Hero` _widget_ memungkinkan _widget_ untuk "terbang" secara visual dari satu posisi di layar asal ke posisi baru di layar tujuan selama transisi navigasi. Ini sangat efektif untuk elemen visual seperti gambar profil, kartu produk, atau ikon yang muncul di kedua layar. Implementasinya melibatkan pembungkusan _widget_ yang ingin dianimasikan dengan `Hero` _widget_ dan memberikan `tag` yang unik dan identik pada kedua `Hero` _widget_ di layar asal dan layar tujuan.

**Konsep Kunci & Filosofi Mendalam:**

- **Unique Tagging:** Kunci dari `Hero` _animation_ adalah `tag` yang unik dan identik. Flutter menggunakan `tag` ini untuk mengidentifikasi _widget_ yang sama di kedua layar.

  - **Filosofi:** Ini adalah cara deklaratif untuk memberi tahu Flutter tentang hubungan spasial antara elemen di layar yang berbeda, memungkinkan kerangka kerja untuk mengotomatisasi animasi kompleks.

- **Performance Optimization:** Flutter menangani _rendering_ `Hero` _animation_ dengan efisien, memastikan transisi yang mulus bahkan pada perangkat kelas bawah.

  - **Filosofi:** Flutter dirancang untuk memberikan kinerja tinggi dan pengalaman pengguna yang halus secara _default_, dan `Hero` adalah contoh yang bagus dari hal tersebut.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

// --- Data Model (Contoh Sederhana) ---
class GalleryItem {
  final String imageUrl;
  final String title;

  GalleryItem({required this.imageUrl, required this.title});
}

// --- Layar Daftar Galeri (Source Screen) ---
class GalleryListScreen extends StatelessWidget {
  final List<GalleryItem> items = [
    GalleryItem(imageUrl: 'https://picsum.photos/id/10/300/300', title: 'Pemandangan 1'),
    GalleryItem(imageUrl: 'https://picsum.photos/id/20/300/300', title: 'Kota Tua'),
    GalleryItem(imageUrl: 'https://picsum.photos/id/30/300/300', title: 'Pegunungan'),
  ];

  GalleryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeri Gambar'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4.0,
            child: InkWell( // InkWell untuk efek ripple saat ditekan
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GalleryDetailScreen(item: item),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    // 1. Hero Widget di Layar Asal
                    // tag harus UNIK untuk setiap Hero dan identik dengan Hero di layar tujuan
                    Hero(
                      tag: 'hero-image-${item.imageUrl}', // Tag unik berbasis URL gambar
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- Layar Detail Galeri (Destination Screen) ---
class GalleryDetailScreen extends StatelessWidget {
  final GalleryItem item;

  const GalleryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 2. Hero Widget di Layar Tujuan
            // Tag harus SAMA persis dengan Hero di layar asal
            Hero(
              tag: 'hero-image-${item.imageUrl}', // Tag identik
              child: Image.network(
                item.imageUrl,
                width: MediaQuery.of(context).size.width * 0.9, // Gambar lebih besar
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Ini adalah detail untuk ${item.title}. Gambar ini "terbang" dari daftar sebelumnya!',
                style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Kembali ke Galeri'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GalleryListScreen(),
    // Tidak perlu named routes untuk contoh ini karena kita meneruskan objek langsung
    // Jika menggunakan named routes, Hero animation tetap bekerja, argumen diteruskan via onGenerateRoute
  ));
}
```

**Penjelasan Konteks Kode:**

- **`Hero` Widget**:
  - Anda harus membungkus _widget_ yang ingin dianimasikan dengan `Hero` _widget_ di **kedua layar** (layar asal dan layar tujuan).
  - Properti **`tag`** adalah yang terpenting. Ini adalah `Object` (biasanya `String`) yang secara unik mengidentifikasi elemen yang sama di kedua layar.
    - `tag` harus **unik** untuk setiap `Hero` _widget_ di satu layar.
    - `tag` harus **sama persis** untuk `Hero` _widget_ yang berhubungan di layar asal dan tujuan.
- **`MaterialPageRoute`**: `Hero` _animation_ secara otomatis bekerja dengan `MaterialPageRoute` karena _page transition_-nya mendukung efek ini.
- **`Image.network`**: Digunakan untuk menampilkan gambar dari URL, serupa dengan yang dibahas di 2.3.1.
- **`ClipRRect`**: Digunakan untuk membuat sudut membulat pada gambar di layar daftar, memberikan estetika yang lebih baik.

**Visualisasi Diagram Alur/Struktur:**

- Animasi GIF atau video pendek yang memperlihatkan bagaimana gambar kecil di daftar "membesar" dan "terbang" ke posisi di layar detail, dan sebaliknya saat kembali.
- _Screenshot_ berdampingan dari `Hero` _widget_ di `GalleryListScreen` dan `GalleryDetailScreen` dengan panah yang menunjukkan koneksi `tag`.

**Terminologi Esensial & Penjelasan Detail:**

- **Hero Animation:** Efek transisi visual di mana sebuah elemen "terbang" dari satu layar ke layar lain.
- **`Hero` (Widget):** _Widget_ yang membungkus _widget_ lain untuk memungkinkan `Hero` _animation_.
- **`tag` (Properti):** Kunci unik yang mengidentifikasi `Hero` _widget_ di antara dua layar.
- **Shared Element Transition:** Konsep desain UI di mana elemen yang sama muncul di dua layar berbeda dan dianimasikan saat transisi.

**Sumber Referensi Lengkap:**

- [Hero Animation Cookbook (Official Docs)](https://docs.flutter.dev/cookbook/navigation/hero-animations)
- [Hero Class (API Docs)](https://api.flutter.dev/flutter/widgets/Hero-class.html)
- [Beautiful Transitions in Flutter: Hero Animations](https://medium.com/flutter/beautiful-transitions-in-flutter-hero-animations-b9c1d1d86d63)
- [Flutter Hero Animations Explained (YouTube)](https://www.youtube.com/watch%3Fv%3DYpL45p_mFjc)

**Tips dan Praktik Terbaik:**

- **Pastikan Tag Unik:** Gunakan `tag` yang benar-benar unik untuk setiap `Hero` _widget_ di seluruh aplikasi, terutama jika ada banyak _item_ yang sama di sebuah daftar (misalnya, gunakan ID unik dari data sebagai bagian dari `tag`).
- **Cocokkan Tipe `Hero` Child:** Meskipun tidak wajib, `Hero` _animation_ akan terlihat paling baik jika _widget_ `child` di kedua sisi memiliki tipe yang sama dan properti visual yang serupa (misalnya, `Image` ke `Image`, `Container` ke `Container`).
- **Perhatikan Ukuran:** Jika ukuran `child` `Hero` sangat berbeda antara dua layar, animasi mungkin terlihat sedikit aneh. Pastikan transisi ukuran tidak terlalu ekstrem.
- **`Placeholder` atau `FadeInImage`:** Untuk gambar jaringan, pertimbangkan menggunakan `FadeInImage` sebagai _child_ dari `Hero` untuk menampilkan _placeholder_ saat gambar dimuat, memastikan animasi tetap mulus.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Animasi `Hero` tidak terjadi, atau terlihat putus-putus.

  - **Penyebab:**
    - `tag` tidak sama persis antara `Hero` di layar asal dan tujuan.
    - Salah satu `Hero` _widget_ (atau keduanya) tidak ditemukan di _widget tree_ saat transisi dimulai.
    - Ada lebih dari satu `Hero` _widget_ dengan `tag` yang sama di satu layar.
  - **Solusi:**
    - Periksa kembali `tag` untuk memastikan ejaan dan kasusnya sama persis.
    - Pastikan `Hero` _widget_ berada di _widget tree_ pada saat `push()` dan `pop()` dipanggil.
    - Pastikan setiap `Hero` _widget_ di _setiap layar_ memiliki `tag` yang unik.

- **Kesalahan:** Gambar tiba-tiba muncul atau hilang tanpa transisi.

  - **Penyebab:** Biasanya karena `tag` tidak cocok, atau `Hero` _widget_ tidak ada di salah satu sisi transisi.
  - **Solusi:** Verifikasi kembali implementasi `Hero` di kedua layar.

---

#### 3.3.2 Dialogs, Bottom Sheets, and Snackbars (as overlays)

Sub-bagian ini akan membahas berbagai jenis _overlays_ UI yang umum digunakan di Flutter untuk interaksi pengguna yang cepat dan kontekstual, tanpa harus melibatkan navigasi layar penuh.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari tiga _widget_/fungsi _overlay_ utama dari Material Design:

- **Dialogs (`AlertDialog`, `SimpleDialog`)**: _Pop-up_ modal yang biasanya digunakan untuk informasi penting, konfirmasi aksi, atau input singkat. Mereka memblokir interaksi dengan konten di bawahnya.
- **Bottom Sheets (`showModalBottomSheet`)**: Panel yang muncul dari bawah layar, bisa bersifat modal atau persisten. Ideal untuk menampilkan daftar opsi, formulir singkat, atau konten tambahan yang tidak memerlukan layar penuh.
- **Snackbars (`ScaffoldMessenger.of(context).showSnackBar`)**: Pesan singkat yang muncul di bagian bawah layar untuk memberikan umpan balik kepada pengguna tentang suatu operasi, seperti "Item ditambahkan ke keranjang". Mereka menghilang secara otomatis setelah beberapa detik.

Penguasaan elemen-elemen ini penting untuk menciptakan pengalaman pengguna yang mulus, di mana aplikasi dapat memberikan informasi atau meminta input tanpa memaksa pengguna untuk berpindah konteks layar.

**Konsep Kunci & Filosofi Mendalam:**

- **Overlay Layer:** Flutter memiliki _overlay layer_ di atas _widget tree_ utama, tempat dialog, _bottom sheets_, dan _snackbars_ ditampilkan. Ini memungkinkan mereka untuk mengambang di atas konten yang ada tanpa mengubah tumpukan navigasi.

  - **Filosofi:** Pemisahan _layer_ UI memungkinkan fleksibilitas dalam menampilkan elemen temporal atau kontekstual tanpa mengganggu _layout_ atau _state_ dari layar utama.

- **Modal vs. Non-Modal Interaction:**

  - **Modal (Dialogs, Modal Bottom Sheets):** Memblokir interaksi dengan UI di bawahnya sampai ditutup. Digunakan untuk aksi yang memerlukan perhatian pengguna.
  - **Non-Modal (Snackbars, Persistent Bottom Sheets):** Tidak memblokir interaksi dengan UI di bawahnya. Digunakan untuk umpan balik atau informasi sekunder.
  - **Filosofi:** Memastikan bahwa interaksi pengguna sesuai dengan tingkat urgensi dan dampak pada alur kerja aplikasi.

- **Contextual Feedback:** _Overlays_ ini dirancang untuk memberikan umpan balik atau opsi dalam konteks layar saat ini.

  - **Filosofi:** Meningkatkan _usability_ dengan menjaga pengguna di alur kerja yang sama saat memberikan informasi atau menerima input kecil, mengurangi kebutuhan untuk navigasi yang berlebihan.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

class OverlayDemoScreen extends StatefulWidget {
  const OverlayDemoScreen({super.key});

  @override
  State<OverlayDemoScreen> createState() => _OverlayDemoScreenState();
}

class _OverlayDemoScreenState extends State<OverlayDemoScreen> {
  String _selectedOption = 'Belum memilih opsi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overlay UI Demo'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tekan tombol di bawah untuk melihat Overlay UI:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // --- 1. Dialog (AlertDialog) ---
            ElevatedButton(
              onPressed: () => _showAlertDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Tampilkan AlertDialog'),
            ),
            const SizedBox(height: 20),

            // --- 2. Bottom Sheet (ModalBottomSheet) ---
            ElevatedButton(
              onPressed: () => _showModalBottomSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Tampilkan Bottom Sheet'),
            ),
            const SizedBox(height: 20),

            // --- 3. Snackbar ---
            ElevatedButton(
              onPressed: () => _showSnackBar(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Tampilkan Snackbar'),
            ),
            const SizedBox(height: 30),
            Text(
              'Opsi terpilih dari Bottom Sheet: $_selectedOption',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // --- Implementasi AlertDialog ---
  void _showAlertDialog(BuildContext context) {
    // Sintaks: showDialog(context: BuildContext, builder: (BuildContext) => Widget)
    // showDialog adalah fungsi yang menampilkan dialog.
    // builder harus mengembalikan widget Dialog (misalnya AlertDialog atau SimpleDialog).
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // Gunakan dialogContext untuk widget di dalam dialog
        return AlertDialog(
          title: const Text('Konfirmasi Aksi'),
          content: const Text('Apakah Anda yakin ingin melanjutkan aksi ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Menutup dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Aksi dibatalkan.')),
                );
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Menutup dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Aksi dikonfirmasi!')),
                );
              },
              child: const Text('Ya, Lanjutkan'),
            ),
          ],
        );
      },
    );
  }

  // --- Implementasi Bottom Sheet ---
  void _showModalBottomSheet(BuildContext context) async {
    // Sintaks: showModalBottomSheet(context: BuildContext, builder: (BuildContext) => Widget)
    // showModalBottomSheet juga mengembalikan Future yang bisa ditunggu untuk hasil.
    final String? selected = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext sheetContext) { // Gunakan sheetContext
        return SizedBox( // Wrap content in SizedBox for specific height, or ListView/Column for dynamic height
          height: 200,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Pilih Opsi:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop('Opsi A'); // Mengembalikan data saat pop
                  },
                  child: const Text('Opsi A'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop('Opsi B');
                  },
                  child: const Text('Opsi B'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedOption = selected;
      });
    } else {
      setState(() {
        _selectedOption = 'Tidak ada opsi yang dipilih.';
      });
    }
  }

  // --- Implementasi Snackbar ---
  void _showSnackBar(BuildContext context) {
    // ScaffoldMessenger.of(context) digunakan untuk menampilkan Snackbar.
    // Pastikan ScaffoldMessenger adalah ancestor dari context.
    // Snackbar adalah widget yang ditampilkan.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ini adalah Snackbar!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Kode untuk membatalkan aksi
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Aksi dibatalkan.')),
            );
          },
        ),
        duration: const Duration(seconds: 3), // Durasi tampil
        // backgroundColor: Colors.blueGrey,
        // behavior: SnackBarBehavior.floating, // Untuk tampilan floating
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: OverlayDemoScreen(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **`showDialog()`**:
  - Adalah fungsi tingkat atas yang menampilkan `Dialog` sebagai _overlay_.
  - Membutuhkan `context` dan `builder` fungsi yang mengembalikan _widget_ `Dialog` (`AlertDialog` atau `SimpleDialog`).
  - `AlertDialog` digunakan untuk pesan penting dengan opsi aksi. Memiliki `title`, `content`, dan `actions`.
  - `Navigator.of(dialogContext).pop()` digunakan untuk menutup dialog. Perhatikan penggunaan `dialogContext` yang diteruskan ke `builder`.
- **`showModalBottomSheet()`**:
  - Fungsi tingkat atas yang menampilkan _bottom sheet_ modal.
  - Juga membutuhkan `context` dan `builder`.
  - Mengembalikan `Future<T?>` yang akan selesai ketika _bottom sheet_ di-_pop_, memungkinkan Anda untuk menerima data kembali (mirip dengan `Navigator.push()`).
  - Konten _bottom sheet_ dapat berupa `SizedBox` dengan tinggi tetap atau _widget_ yang dapat di-_scroll_ seperti `ListView` atau `Column` di dalam `SingleChildScrollView` untuk konten dinamis.
  - `Navigator.of(sheetContext).pop(data)` digunakan untuk menutup _bottom sheet_ dan mengembalikan data.
- **`ScaffoldMessenger.of(context).showSnackBar()`**:
  - Digunakan untuk menampilkan `SnackBar`. `ScaffoldMessenger` adalah _widget_ yang mengelola `SnackBar` dan `MaterialBanner` untuk seluruh `Scaffold`.
  - `SnackBar` adalah _widget_ yang memiliki `content` (biasanya `Text`) dan bisa memiliki `action` (tombol undo, misalnya).
  - Properti `duration` mengontrol berapa lama _snackbar_ akan terlihat.

**Visualisasi Diagram Alur/Struktur:**

- _Screenshot_ atau ilustrasi masing-masing:
  - `AlertDialog` di tengah layar dengan latar belakang _dimmed_.
  - `ModalBottomSheet` muncul dari bawah, menutupi bagian bawah layar.
  - `Snackbar` muncul di bagian bawah layar, biasanya di atas `BottomNavigationBar` jika ada.

**Terminologi Esensial & Penjelasan Detail:**

- **Dialog:** Jendela _pop-up_ kecil yang muncul di atas konten utama untuk informasi atau konfirmasi.
  - **`AlertDialog`:** Implementasi `Dialog` untuk peringatan atau konfirmasi.
  - **`SimpleDialog`:** Implementasi `Dialog` untuk menampilkan daftar opsi sederhana.
- **Bottom Sheet:** Panel yang meluncur dari bagian bawah layar.
  - **Modal Bottom Sheet:** Memblokir interaksi di belakangnya, ditutup dengan _swipe_ ke bawah atau mengetuk di luar.
  - **Persistent Bottom Sheet:** Tetap terbuka dan tidak memblokir interaksi di bawahnya (dikelola oleh `ScaffoldState`). (Contoh di atas adalah Modal Bottom Sheet).
- **Snackbar:** Pesan non-modal singkat yang muncul di bagian bawah layar.
- **`ScaffoldMessenger`:** _Widget_ yang mengelola `SnackBar` dan `MaterialBanner` untuk _ancestor_ `Scaffold` terdekat.
- **`Overlay`:** Lapisan di atas _widget tree_ utama tempat elemen seperti dialog ditampilkan.
- **`BuildContext` (untuk _overlays_):** Penting untuk menggunakan `context` yang benar saat memanggil `showDialog`, `showModalBottomSheet`, atau `ScaffoldMessenger.of(context)`. `builder` untuk dialog/bottom sheet menerima `BuildContext` baru untuk konten di dalam _overlay_.

**Sumber Referensi Lengkap:**

- [Dialogs, alerts, and panels (Official Docs - Design Guidelines)](https://m2.material.io/components/dialogs)
- [AlertDialog Class (API Docs)](https://api.flutter.dev/flutter/material/AlertDialog-class.html)
- [showDialog Function (API Docs)](https://api.flutter.dev/flutter/material/showDialog.html)
- [Bottom sheets (Official Docs - Design Guidelines)](https://m2.material.io/components/sheets-bottom)
- [showModalBottomSheet Function (API Docs)](https://api.flutter.dev/flutter/material/showModalBottomSheet.html)
- [Snackbars (Official Docs - Design Guidelines)](https://m2.material.io/components/snackbars)
- [SnackBar Class (API Docs)](https://api.flutter.dev/flutter/material/SnackBar-class.html)
- [ScaffoldMessenger Class (API Docs)](https://api.flutter.dev/flutter/material/ScaffoldMessenger-class.html)

**Tips dan Praktik Terbaik:**

- **Pilih _Overlay_ yang Tepat:**
  - Gunakan **Dialog** untuk konfirmasi yang penting atau informasi krusial yang memerlukan persetujuan eksplisit.
  - Gunakan **Bottom Sheet** untuk daftar opsi atau formulir singkat yang dapat diselesaikan dengan cepat tanpa mengganti layar penuh.
  - Gunakan **Snackbar** untuk umpan balik non-invasif tentang suatu aksi (misalnya, "Item ditambahkan", "Berhasil disimpan").
- **Gunakan `await` untuk Hasil:** Gunakan `await` dengan `showDialog` atau `showModalBottomSheet` jika Anda ingin melakukan sesuatu setelah _overlay_ ditutup dan/atau jika Anda mengharapkan data kembali.
- **Jangan Lupa `context`:** Pastikan `context` yang Anda gunakan untuk memanggil fungsi `show...` memiliki `Scaffold` (untuk `SnackBar`) atau `Navigator` (untuk `pop` dari dialog/bottom sheet) sebagai _ancestor_ yang memadai.
- **Bersihkan Pesan Lama:** Untuk `SnackBar`, jika Anda memanggil `showSnackBar` berulang kali, _snackbar_ sebelumnya akan antri atau diganti. Gunakan `ScaffoldMessenger.of(context).hideCurrentSnackBar()` atau `clearSnackBars()` jika Anda ingin membersihkan _snackbar_ yang sedang tampil sebelum menampilkan yang baru.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** "No ScaffoldMessenger found with that context."

  - **Penyebab:** Anda mencoba memanggil `ScaffoldMessenger.of(context).showSnackBar()` dari `context` yang tidak memiliki `ScaffoldMessenger` (atau `Scaffold`) sebagai _ancestor_. Ini sering terjadi jika Anda memanggilnya dari `main()` atau dari _widget_ yang berada di atas `MaterialApp` atau `Scaffold`.
  - **Solusi:** Pastikan panggilan `showSnackBar` dilakukan dari `context` dari _widget_ yang merupakan anak dari `Scaffold` (atau `ScaffoldMessenger`). Contohnya, dari dalam `build` metode `StatefulWidget` atau `StatelessWidget` yang ada di dalam `Scaffold`.

- **Kesalahan:** Dialog/Bottom Sheet tidak menutup setelah aksi.

  - **Penyebab:** Lupa memanggil `Navigator.of(context).pop()` (atau `Navigator.of(dialogContext).pop()`) di dalam _callback_ aksi dialog/bottom sheet.
  - **Solusi:** Pastikan Anda memanggil `pop()` yang sesuai ketika pengguna menyelesaikan interaksi dengan _overlay_.

- **Kesalahan:** Data yang dikembalikan dari `showModalBottomSheet` adalah `null` padahal seharusnya ada.

  - **Penyebab:** `pop()` dipanggil di _bottom sheet_ tanpa argumen, atau _bottom sheet_ ditutup oleh _gesture swipe_ ke bawah atau ketukan di luar tanpa secara eksplisit memanggil `pop()` dengan nilai.
  - **Solusi:** Pastikan Anda meneruskan nilai ke `pop()` di dalam `onPressed` _callback_ tombol. Ingat bahwa penutupan _gesture_ default tidak akan mengembalikan nilai kecuali Anda secara eksplisit menanganinya (yang biasanya tidak perlu kecuali untuk kasus khusus).

## Selamat!

Kita telah menyelesaikan FASE 3. Selanjutnya kita akan masuk pada **FASE 4: State Management Fundamentals**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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
