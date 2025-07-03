> pro

# **[FASE 2: Widget System & UI Foundation][0]**

#### **Struktur Daftar Isi**

<details>
  <summary>📃 Materi</summary>

---

- **[2. Widget Architecture Deep Dive](#2-widget-architecture-deep-dive)**

  - [2.1. Widget Tree & Rendering Engine](#21-widget-tree--rendering-engine)
  - [2.1.1. Widget Tree Fundamentals](#211-widget-tree-fundamentals)
  - [2.1.2. Widget Lifecycle Management](#212-widget-lifecycle-management)

- **[2.2. Layout System Mastery](#22-layout-system-mastery)**
  - [2.2.1. Core Layout Widgets](#221-core-layout-widgets)
  - [2.2.2. Advanced Layout Techniques](#222-advanced-layout-techniques)
- **[3. UI Components & Material Design](#3-ui-components--material-design)**
  - [3.1. Material Design Implementation](#31-material-design-implementation)
  - [3.2. Custom Widget Development](#32-custom-widget-development)

</details>

---

**Deskripsi Konkret:**
Setelah memahami filosofi dan arsitektur di Fase 1, Fase 2 adalah tempat di mana kita benar-benar mulai "membangun". Ini adalah fondasi praktis dari pengembangan UI di Flutter. Di fase ini, kita akan membongkar konsep "Everything is a Widget" menjadi komponen-komponen yang bisa dipahami dan digunakan. Menguasai fase ini berarti Anda akan mampu menerjemahkan desain statis (misalnya dari Figma) menjadi antarmuka pengguna yang fungsional dan hidup di Flutter.

**Hubungan dengan Modul Lain:** Fase 2 adalah jembatan antara teori (Fase 1) dan _state management_ (Fase 3). Anda tidak bisa mengelola _state_ jika Anda tidak tahu apa yang akan diubah (_state_ tersebut), yaitu _widget_. Pengetahuan tentang _layout_ dan _widget_ di sini akan menjadi dasar mutlak untuk membangun aplikasi yang responsif (Fase 7) dan interaktif dengan _forms_ (Fase 5) serta navigasi (Fase 4).

---

#### **2. Widget Architecture Deep Dive**

Bagian ini membedah anatomi dari sebuah widget. Kita akan melihat "organ" internalnya, bagaimana ia "hidup", "mati", dan berinteraksi dengan lingkungannya. Ini adalah pengetahuan mikroskopis yang memisahkan developer pemula dari developer menengah.

---

##### **2.1 Widget Tree & Rendering Engine**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah kelanjutan langsung dari pembahasan arsitektur tiga pohon di Fase 1, namun dengan fokus pada aspek praktis yang akan ditemui developer setiap hari. Kita akan belajar bagaimana Flutter secara efisien membangun UI dari kode kita dan mengapa pemahaman tentang `BuildContext` dan `Keys` sangat penting untuk mencegah _bug_ yang sulit dilacak.

###### **2.1.1 Widget Tree Fundamentals**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah inti dari pengembangan UI di Flutter. Kita belajar dua jenis "sel" utama pembentuk UI (`StatelessWidget` dan `StatefulWidget`) dan bagaimana mereka berinteraksi dalam sebuah ekosistem (`Widget Tree` dan `BuildContext`).

**Konsep Kunci & Filosofi Mendalam:**

- **`StatelessWidget` vs `StatefulWidget`:** Ini adalah pemisahan fundamental di Flutter.
  - **`StatelessWidget`:** Widget yang konfigurasinya tidak berubah seumur hidupnya. Ia tidak memiliki "memori" internal. Sekali digambar, ia akan tetap seperti itu kecuali konfigurasinya diubah oleh _parent_-nya. Contoh: `Icon`, `Text` (dengan teks statis), `Container` dengan dekorasi tetap. Ia sangat ringan dan efisien.
  - **`StatefulWidget`:** Widget yang memiliki "memori" atau _state_ internal yang bisa berubah selama _runtime_. Ketika _state_-nya berubah (melalui `setState()`), widget ini akan memberi tahu Flutter untuk menjadwalkan pembangunan ulang (_rebuild_) UI-nya agar merefleksikan _state_ yang baru. Contoh: _checkbox_ yang bisa dicentang, _slider_ yang bisa digeser, _form field_ yang bisa diisi.
- **`BuildContext` Understanding:** `BuildContext` adalah salah satu konsep paling kuat sekaligus paling sering disalahpahami. Ini **bukan** sekadar parameter biasa. `BuildContext` adalah "lokator" atau "alamat" dari sebuah widget di dalam _Widget Tree_. Ia menyimpan informasi tentang di mana widget tersebut berada relatif terhadap widget lain. Melalui `BuildContext`, sebuah widget bisa "naik" ke pohon untuk menemukan _ancestor_ (leluhur) terdekat dari tipe tertentu (misalnya, `Scaffold.of(context)` untuk menemukan `Scaffold` terdekat). **Setiap metode `build` memiliki `BuildContext`-nya sendiri yang unik.**
- **Element Tree vs Widget Tree:** Seperti yang dibahas di Fase 1, _Widget Tree_ adalah _blueprint_ yang kita tulis di kode. _Element Tree_ adalah pohon perantara yang _mutable_ (bisa berubah) yang dibuat Flutter. Flutter sangat pintar dalam membandingkan _Widget Tree_ yang baru dengan yang lama. Jika sebuah widget di pohon baru memiliki tipe dan _key_ yang sama dengan elemen di lokasi yang sama pada pohon lama, Flutter akan memperbarui elemen tersebut dengan konfigurasi widget yang baru, alih-alih membuatnya dari awal. Ini adalah inti dari efisiensi Flutter.
- **Widget Keys:** _Keys_ adalah identifikasi opsional untuk widget. Mereka memberi tahu Flutter cara yang lebih baik untuk mencocokkan widget di pohon lama dengan widget di pohon baru selama proses _rebuild_. Ini menjadi sangat penting ketika kita memanipulasi daftar widget dengan tipe yang sama (misalnya, menambah, menghapus, atau menyusun ulang item dalam `ListView`). Tanpa _keys_, Flutter mungkin akan salah mencocokkan _state_ dengan widget, menyebabkan _bug_ visual.

**Terminologi Esensial & Penjelasan Detil:**

- **Immutable:** Tidak dapat diubah setelah dibuat. Semua `Widget` bersifat _immutable_.
- **State Object:** Objek terpisah yang berpasangan dengan `StatefulWidget`. Objek inilah yang menyimpan data yang bisa berubah dan bertahan di antara _rebuilds_.
- **Key:** Identifier unik untuk sebuah widget yang membantu Flutter dalam proses rekonsiliasi (_reconciliation_) atau pembaruan _Element Tree_.
  - `ValueKey`: Menggunakan nilai sederhana (String, int) sebagai identifier.
  - `ObjectKey`: Menggunakan objek kompleks sebagai identifier.
  - `GlobalKey`: Kunci yang unik di seluruh aplikasi, bukan hanya di antara _siblings_. Memungkinkan akses ke _state_ atau _context_ dari widget lain.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Stateless vs Stateful')),
        // Di sini kita menggunakan CounterWidget, sebuah StatefulWidget
        body: const Center(child: CounterWidget()),
      ),
    );
  }
}

// CONTOH STATEFUL WIDGET
class CounterWidget extends StatefulWidget {
  // 1. Bagian ini adalah `Widget`, bersifat immutable.
  const CounterWidget({super.key});

  // 2. `createState()` membuat objek State yang akan mengelola widget ini.
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

// Tanda underscore `_` menjadikan class ini private untuk file ini.
class _CounterWidgetState extends State<CounterWidget> {
  // 3. Ini adalah `State` object. Variabel di sini adalah 'memori' widget.
  int _counter = 0;

  void _incrementCounter() {
    // 4. `setState` memberitahu Flutter bahwa state internal telah berubah.
    //    Flutter akan menjadwalkan `build()` untuk dijalankan lagi.
    setState(() {
      _counter++;
    });
  }

  // 5. Metode `build` dijalankan setiap kali `setState` dipanggil atau
  //    ketika parent widget melakukan rebuild.
  @override
  Widget build(BuildContext context) {
    // `build` ini memiliki `BuildContext`nya sendiri.
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Anda telah menekan tombol ini sebanyak:'), // StatelessWidget
        Text(
          '$_counter', // Menggunakan nilai `_counter` dari state
          style: Theme.of(context).textTheme.headlineMedium, // Menggunakan BuildContext untuk mengakses Theme
        ),
        ElevatedButton(
          onPressed: _incrementCounter, // Memanggil method yang memanggil setState
          child: const Icon(Icons.add), // StatelessWidget
        )
      ],
    );
  }
}
```

**Rekomendasi Visualisasi:**
Diagram pohon ganda yang menunjukkan _Widget Tree_ (yang kita tulis) di satu sisi dan _Element Tree_ (yang Flutter kelola) di sisi lain akan sangat membantu. Ilustrasikan bagaimana `setState` memicu perbandingan dan pembaruan pada pohon.

**Hubungan dengan Modul Lain:**
Pemahaman `StatefulWidget` dan `setState` adalah dasar mutlak untuk **Fase 3: State Management**. Semua solusi _state management_ yang lebih canggih (Provider, BLoC, Riverpod) pada dasarnya adalah cara yang lebih terstruktur untuk melakukan apa yang `setState` lakukan, tetapi dalam skala yang lebih besar dan terorganisir.

**Sumber Referensi Lengkap:**

- **Pengenalan Widget:** [Introduction to widgets](https://docs.flutter.dev/development/ui/widgets-intro)
- **Penjelasan `BuildContext`:** [Understanding BuildContext in Flutter](https://medium.com/flutter-community/understanding-buildcontext-in-flutter-c8c72c7b9c7c)
- **Penjelasan Keys:** [Using Keys in Flutter](https://medium.com/flutter/keys-what-are-they-good-for-13cb51742e7d) (Artikel oleh tim Flutter)

---

###### **2.1.2 Widget Lifecycle Management**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Setiap `StatefulWidget` memiliki siklus hidup, mirip dengan makhluk hidup: ia "dilahirkan", "hidup", dan "mati". Memahami setiap tahap dalam siklus ini memungkinkan kita untuk melakukan tindakan pada waktu yang tepat, seperti menginisialisasi data, berlangganan _stream_, atau membersihkan _resource_ untuk mencegah _memory leaks_.

**Konsep Kunci & Filosofi Mendalam:**
Siklus hidup ini hanya ada pada `State` object dari sebuah `StatefulWidget`.

1.  **`createState()`:** Dipanggil sekali ketika `StatefulWidget` dimasukkan ke dalam pohon. Ini adalah langkah pertama, di mana objek `State` dibuat.
2.  **`initState()`:** Dipanggil sekali tepat setelah objek `State` dibuat. Ini adalah tempat yang ideal untuk melakukan inisialisasi satu kali yang bergantung pada `context` atau _widget properties_. Contoh: berlangganan _stream_, menginisialisasi _controller_, atau mengambil data awal dari API.
3.  **`didChangeDependencies()`:** Dipanggil segera setelah `initState()` pada kali pertama, dan kemudian setiap kali dependensi objek `State` berubah (misalnya, ketika sebuah `InheritedWidget` yang diandalkannya diperbarui).
4.  **`build()`:** Dipanggil berkali-kali. Dipanggil setelah `didChangeDependencies()` dan setiap kali `setState()` dipanggil atau ketika _parent widget_ membangun ulang. Tugasnya hanya satu: mengembalikan sebuah `Widget` berdasarkan _state_ saat ini. Metode ini harus murni dan bebas dari _side effects_.
5.  **`didUpdateWidget()`:** Dipanggil ketika _widget_ yang terkait dengan objek `State` ini dikonfigurasi ulang (misalnya, _parent_-nya membangun ulang dengan parameter yang berbeda). Anda bisa membandingkan `widget` (konfigurasi baru) dengan `oldWidget` (konfigurasi lama) untuk bereaksi terhadap perubahan.
6.  **`setState()`:** Bukan bagian dari _lifecycle_ dalam urutan, tetapi ini adalah _trigger_ utama yang memberitahu Flutter bahwa _state_ telah berubah dan `build()` perlu dijalankan kembali.
7.  **`deactivate()`:** Dipanggil ketika objek `State` dihapus dari pohon, tetapi mungkin akan dimasukkan kembali di tempat lain (misalnya, memindahkan widget dalam daftar).
8.  **`dispose()`:** Dipanggil ketika objek `State` dihapus dari pohon secara permanen. Ini adalah tempat untuk bersih-bersih: batalkan langganan _stream_, buang _controller_, tutup koneksi. **Sangat penting untuk mengimplementasikan ini untuk mencegah _memory leaks_.**

**Terminologi Esensial & Penjelasan Detil:**

- **Lifecycle:** Urutan tahapan yang dilalui sebuah objek dari pembuatan hingga penghancuran.
- **Side Effect:** Tindakan apa pun dalam sebuah fungsi yang memengaruhi sesuatu di luar lingkup fungsi itu sendiri (misalnya, panggilan API, menulis ke database). Metode `build` harus bebas dari ini.
- **Memory Leak:** Kegagalan untuk melepaskan memori yang tidak lagi digunakan, menyebabkan aplikasi secara bertahap mengonsumsi lebih banyak memori dari waktu ke waktu hingga akhirnya _crash_.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'dart:async';
import 'package:flutter/material.dart';

class LifecycleWatcher extends StatefulWidget {
  const LifecycleWatcher({super.key});

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> {
  late Timer _timer;

  // 1. Dipanggil saat objek State dibuat
  @override
  void initState() {
    super.initState();
    print('initState() called');
    // Tempat ideal untuk inisialisasi:
    // Misal, memulai timer yang berdetak setiap 5 detik
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('Timer tick!');
    });
  }

  // 2. Dipanggil setelah initState() dan saat dependensi berubah
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies() called');
  }

  // 3. Dipanggil saat widget dikonfigurasi ulang
  @override
  void didUpdateWidget(LifecycleWatcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget() called');
  }

  // 4. Dipanggil saat widget dihapus dari pohon (mungkin sementara)
  @override
  void deactivate() {
    super.deactivate();
    print('deactivate() called');
  }

  // 5. Dipanggil saat widget dihapus permanen. WAKTUNYA BERSIH-BERSIH!
  @override
  void dispose() {
    print('dispose() called - Cleaning up resources...');
    // Sangat penting untuk membatalkan timer untuk mencegah memory leak!
    _timer.cancel();
    super.dispose();
  }

  // 6. Metode build, dipanggil berkali-kali
  @override
  Widget build(BuildContext context) {
    print('build() called');
    return const Center(
      child: Text('Periksa konsol Anda untuk log lifecycle!'),
    );
  }
}
```

**Rekomendasi Visualisasi:**
Diagram alur (_flowchart_) yang jelas menunjukkan urutan pemanggilan metode _lifecycle_ dari `createState` hingga `dispose`, termasuk kapan `setState` dan `didUpdateWidget` masuk ke dalam alur, akan sangat berharga.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Melakukan panggilan API atau inisialisasi berat di dalam metode `build()`. Ini akan menyebabkan panggilan API berulang setiap kali widget di-_rebuild_, membuang-buang sumber daya.
- **Solusi:** Pindahkan semua inisialisasi satu kali ke `initState()`.
- **Kesalahan:** Lupa memanggil `dispose()` pada _controller_ (seperti `TextEditingController`, `AnimationController`) atau membatalkan `StreamSubscription`. Ini adalah penyebab paling umum dari _memory leaks_.
- **Solusi:** Jadikan kebiasaan: setiap kali Anda menulis `initState()` untuk membuat sesuatu, segera tulis metode `dispose()` untuk membersihkannya.

**Sumber Referensi Lengkap:**

- **Dokumentasi `State` class:** [State class - Flutter API](https://api.flutter.dev/flutter/widgets/State-class.html) (Siklus hidup didokumentasikan di sini)
- **Artikel Mendalam:** [Flutter Widget Lifecycle](https://medium.com/flutter-community/flutter-widget-lifecycle-in-depth-7b8c3c9f7b7b)

---

### **2.2. Layout System Mastery**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Jika widget adalah "batu bata", maka _layout system_ adalah "semen" dan "cetakan"-nya. Bagian ini mengajarkan cara menyusun, menata, dan memposisikan widget-widget tersebut di layar. Menguasai sistem layout adalah keterampilan paling fundamental untuk mengubah desain visual menjadi aplikasi nyata. Tanpa ini, aplikasi kita hanya akan menjadi tumpukan widget yang tidak teratur. Ini adalah dasar dari semua desain UI, dari yang sederhana hingga yang kompleks dan responsif.

---

#### **2.2.1. Core Layout Widgets**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah "kosa kata" dasar dalam bahasa layout Flutter. Kita akan mempelajari widget-widget yang paling sering digunakan untuk membangun 90% dari semua UI yang akan Anda temui. Setiap widget memiliki peran spesifik, dan memahami kapan harus menggunakan widget yang tepat adalah kunci untuk membangun layout yang efisien dan dapat diprediksi.

**Konsep Kunci & Filosofi Mendalam:**

- **Model Constraints di Flutter:** Filosofi utama layout di Flutter adalah _"Constraints go down. Sizes go up. Parent sets position."_ (Batasan turun. Ukuran naik. Induk menentukan posisi).

  1.  **Constraints go down:** Widget induk (`parent`) memberitahu widget anak (`child`) batasan ukuran yang boleh ditempatinya (misalnya, "kamu boleh memiliki lebar antara 100 dan 300 piksel").
  2.  **Sizes go up:** Widget anak menentukan ukurannya sendiri di dalam batasan tersebut (misalnya, "oke, kalau begitu aku akan berukuran 250 piksel").
  3.  **Parent sets position:** Widget induk menentukan di mana posisi widget anaknya (misalnya, "kamu akan aku letakkan di tengah").
      Memahami alur ini adalah kunci untuk men-debug semua masalah layout.

- **Widget Anak Tunggal vs. Anak Banyak:**

  - **Single-child layout widgets:** Hanya bisa memiliki satu `child` (misalnya `Container`, `Center`, `SizedBox`).
  - **Multi-child layout widgets:** Bisa memiliki banyak `children` dalam bentuk `List<Widget>` (misalnya `Row`, `Column`, `Stack`, `Wrap`).

**Terminologi Esensial & Penjelasan Detil:**

- **Constraints (Batasan):** Objek yang memberitahu widget tentang lebar dan tinggi minimum dan maksimum yang diizinkan (`minWidth`, `maxWidth`, `minHeight`, `maxHeight`).
- **Axis (Sumbu):** Arah utama dari sebuah layout.
  - **Main Axis (Sumbu Utama):** Arah di mana `children` diatur. Untuk `Row`, ini adalah sumbu horizontal. Untuk `Column`, ini adalah sumbu vertikal.
  - **Cross Axis (Sumbu Silang):** Arah yang tegak lurus dengan sumbu utama. Untuk `Row`, ini adalah sumbu vertikal. Untuk `Column`, ini adalah sumbu horizontal.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini membangun sebuah "kartu profil" sederhana menggunakan beberapa widget layout inti.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea( // SafeArea menjaga UI agar tidak terpotong oleh notch atau status bar.
          child: ProfileCard(),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. COLUMN: Menyusun widget-widget secara vertikal.
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Menengahkan semua anak di sumbu vertikal.
      children: <Widget>[
        const CircleAvatar(
          radius: 50.0,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
        ),
        const Text(
          'Jane Doe',
          style: TextStyle(
            fontFamily: 'Pacifico', // Pastikan font ini ada di pubspec.yaml
            fontSize: 40.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'FLUTTER DEVELOPER',
          style: TextStyle(
            fontFamily: 'Source Sans Pro',
            color: Colors.teal.shade100,
            fontSize: 20.0,
            letterSpacing: 2.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        // 2. SIZEDBOX: Memberikan jarak vertikal dengan tinggi 20 piksel,
        // sekaligus berfungsi sebagai garis pemisah.
        SizedBox(
          height: 20.0,
          width: 150.0,
          child: Divider(
            color: Colors.teal.shade100,
          ),
        ),
        // 3. CONTAINER: Bertindak seperti <div>. Memberi padding, margin, warna.
        // Di sini kita gunakan Card, yang pada dasarnya adalah Container dengan style.
        Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: ListTile(
            // 4. ROW: Menyusun widget secara horizontal.
            leading: const Icon(
              Icons.phone,
              color: Colors.teal,
            ),
            title: Text(
              '+62 123 4567 8910',
              style: TextStyle(
                color: Colors.teal.shade900,
                fontFamily: 'Source Sans Pro',
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: ListTile(
            leading: const Icon(
              Icons.email,
              color: Colors.teal,
            ),
            title: Text(
              'jane.doe@example.com',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.teal.shade900,
                fontFamily: 'Source Sans Pro',
              ),
            ),
          ),
        ),
        // 5. SPACER: Mengambil semua ruang kosong yang tersedia.
        // Di sini ia akan mendorong widget di bawahnya ke bagian bawah.
        const Spacer(),
        // 6. WRAP: Mirip Row/Column, tapi akan "turun baris" jika tidak cukup ruang.
        const Wrap(
          spacing: 8.0, // Jarak horizontal antar anak
          runSpacing: 4.0, // Jarak vertikal jika ada baris baru
          children: <Widget>[
            Chip(label: Text('Leadership')),
            Chip(label: Text('Teamwork')),
            Chip(label: Text('Visionary')),
            Chip(label: Text('Project Management')),
          ],
        ),
        const SizedBox(height: 20), // Memberi sedikit jarak di bawah.
      ],
    );
  }
}
```

**Penjelasan Widget Inti dari Contoh:**

- **`Container`:** Widget serbaguna untuk menampung satu `child`. Bisa diberi `padding`, `margin`, `decoration` (warna, border, shadow), dan `constraints` (ukuran). Sangat fundamental.
- **`Row` & `Column`:** Widget layout multi-child paling penting. `Row` menyusun anaknya secara horizontal, `Column` secara vertikal.
- **`Stack`:** Memungkinkan widget saling menumpuk. Widget pertama di daftar `children` ada di paling bawah, yang terakhir di paling atas. Gunakan `Positioned` untuk menempatkan anak-anak `Stack` secara presisi.
- **`Expanded` vs `Flexible`:** Keduanya digunakan di dalam `Row` atau `Column`.
  - `Expanded`: Memaksa anaknya untuk mengisi semua ruang kosong yang tersedia di sumbu utama.
  - `Flexible`: Memberi anaknya fleksibilitas untuk mengisi ruang kosong, tetapi tidak memaksanya. Anaknya boleh lebih kecil dari ruang yang tersedia.
- **`Wrap`:** Seperti `Row` atau `Column`, tetapi jika anaknya melebihi ruang yang tersedia, ia akan secara otomatis pindah ke baris atau kolom berikutnya. Sangat berguna untuk layout yang responsif (misalnya, tag cloud).
- **`SizedBox` & `Spacer`:**
  - `SizedBox`: Membuat sebuah kotak dengan ukuran yang pasti. Cara paling efisien untuk memberi jarak antar widget.
  - `Spacer`: Sebuah widget "kosong" yang akan mengambil semua ruang kosong yang tersisa di dalam `Row` atau `Column`. Berguna untuk mendorong widget lain ke ujung.

**Rekomendasi Visualisasi:**
Diagram visual yang menunjukkan perbedaan `Main Axis` dan `Cross Axis` untuk `Row` dan `Column` adalah wajib. Sebuah "Layout Cheat Sheet" visual yang menunjukkan bagaimana setiap widget inti berperilaku juga akan sangat membantu.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mendapat _overflow error_ (garis kuning-hitam). Ini paling sering terjadi ketika sebuah `Row` atau `Column` berisi widget yang memiliki ukuran tak terbatas (seperti `Row` di dalam `Row` lain, atau `ListView` di dalam `Column`).
- **Solusi:** Bungkus widget yang "bermasalah" dengan `Expanded` atau `Flexible` untuk memberitahunya agar menyesuaikan diri dengan ruang yang tersedia, atau berikan ukuran yang pasti pada widget tersebut.

**Sumber Referensi Lengkap:**

- **Katalog Widget Layout:** [Layout widgets - Flutter Docs](https://docs.flutter.dev/development/ui/widgets/layout)
- **Panduan Visual Layout:** [Flutter Layout Cheat Sheet](https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e) (Meskipun dari 2019, konsepnya masih sangat relevan)
- **Video Konsep Constraints:** [Understanding constraints - Flutter (YouTube)](https://www.youtube.com/watch%3Fv%3D_Y_-JJ5sn3g)

---

#### **2.2.2. Advanced Layout Techniques**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Setelah menguasai "kosa kata" dasar, sekarang kita belajar "tata bahasa"-nya. Bagian ini mengajarkan cara menyempurnakan penataan widget di dalam `Row` dan `Column`, serta memperkenalkan konsep-konsep yang lebih canggih untuk layout yang lebih kompleks dan presisi.

**Konsep Kunci & Filosofi Mendalam:**

- **Alignment (Perataan):** Anda memiliki kontrol penuh atas bagaimana `children` diatur di sepanjang sumbu utama dan sumbu silang.
  - `MainAxisAlignment`: Mengontrol penataan di sumbu utama.
    - `start`: Rata kiri (Row) atau rata atas (Column).
    - `center`: Di tengah.
    - `end`: Rata kanan (Row) atau rata bawah (Column).
    - `spaceBetween`: Ruang kosong didistribusikan secara merata di _antara_ anak-anak.
    - `spaceAround`: Mirip `spaceBetween`, tetapi juga ada setengah ruang di awal dan akhir.
    - `spaceEvenly`: Ruang kosong didistribusikan secara merata, termasuk di awal dan akhir.
  - `CrossAxisAlignment`: Mengontrol penataan di sumbu silang.
    - `start`: Rata atas (Row) atau rata kiri (Column).
    - `center`: Di tengah sumbu silang.
    - `end`: Rata bawah (Row) atau rata kanan (Column).
    - `stretch`: Memaksa anak-anak untuk mengisi seluruh ruang di sumbu silang.
- **`MainAxisSize`:** Mengontrol seberapa banyak ruang yang harus diambil oleh `Row`/`Column` di sepanjang sumbu utamanya.
  - `max` (default): Ambil semua ruang yang diizinkan oleh `parent`.
  - `min`: Ambil hanya ruang yang dibutuhkan oleh `children`.
- **`IntrinsicWidth` & `IntrinsicHeight`:** Widget yang mahal secara komputasi. Mereka memberitahu anaknya, "ukur dirimu seolah-olah kamu memiliki ruang tak terbatas, lalu beritahu aku ukuran 'ideal'-mu, dan aku akan berukuran pas denganmu." Gunakan dengan hati-hati karena dapat memengaruhi performa.
- **`Flow` Widget:** Pintu gerbang menuju layout kustom sepenuhnya. `Flow` memungkinkan Anda mengimplementasikan logika transformasi (posisi, rotasi, skala) Anda sendiri untuk setiap anak, memberikan kontrol penuh yang tidak bisa dicapai dengan `Row`, `Column`, atau `Stack`.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini mendemonstrasikan berbagai properti alignment.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Advanced Layout')),
        body: const AlignmentDemo(),
      ),
    );
  }
}

class AlignmentDemo extends StatelessWidget {
  const AlignmentDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('MainAxisAlignment.spaceBetween'),
        // Contoh 1: spaceBetween
        Container(
          height: 100,
          color: Colors.blue[100],
          child: Row(
            // ANAK-ANAK AKAN DIDORONG KE UJUNG DENGAN RUANG RATA DI ANTARANYA
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.star, size: 50),
              Icon(Icons.star, size: 50),
              Icon(Icons.star, size: 50),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('CrossAxisAlignment.start'),
        // Contoh 2: crossAxisAlignment
        Container(
          height: 100,
          color: Colors.green[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // ANAK-ANAK AKAN DIRATAKAN KE BAGIAN ATAS ROW
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.person, size: 30),
              Icon(Icons.person, size: 60), // Ukuran berbeda untuk melihat efeknya
              Icon(Icons.person, size: 30),
            ],
          ),
        ),
         const SizedBox(height: 20),
        const Text('MainAxisSize.min'),
        // Contoh 3: MainAxisSize.min
        Container(
          color: Colors.red[100],
          child: Row(
             // ROW INI HANYA AKAN SELEBAR TOTAL LEBAR ANAK-ANAKNYA
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.favorite, size: 50),
              Text('Love It!'),
            ],
          ),
        ),
      ],
    );
  }
}
```

**Rekomendasi Visualisasi:**
Wajib ada diagram visual yang menunjukkan efek dari setiap nilai `MainAxisAlignment` dan `CrossAxisAlignment` secara berdampingan.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `MainAxisAlignment` (seperti `spaceBetween`) tidak memiliki efek.
- **Solusi:** Ini terjadi karena `Row`/`Column` tersebut hanya memiliki ruang seukuran total anaknya (`MainAxisSize.min`). Agar alignment berfungsi, `Row`/`Column` harus memiliki ruang ekstra. Pastikan `parent`-nya memberikan ruang lebih atau `Row`/`Column` tersebut berada dalam `parent` yang memaksanya untuk melebar (seperti `Center` atau `Container` tanpa ukuran pasti).

**Sumber Referensi Lengkap:**

- **Properti `Flex` (Induk dari Row/Column):** [Flex class - Flutter API](https://api.flutter.dev/flutter/widgets/Flex-class.html)
- **Layout Lanjutan (Slivers):** [Slivers, demystified - Flutter (YouTube)](https://www.youtube.com/watch?v=ORiTTaVY6mM) (Ini adalah konsep yang lebih maju, tetapi relevan untuk layout yang kompleks).
- **Stack dan Positioned:** [Stack class - Flutter API](https://api.flutter.dev/flutter/widgets/Stack-class.html)

---

Kita telah menyelesaikan pembahasan untuk **sub-bagian 2.2: Layout System Mastery**. Ini adalah fondasi mutlak untuk bisa menyusun UI apa pun di Flutter. Berikutnya kita akan mengisi kerangka tersebut dengan komponen-komponen yang fungsional dan memiliki tampilan yang menarik. Ini adalah bagian di mana aplikasi kita mulai terasa "hidup" dan interaktif.

### **3. UI Components & Material Design**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Bagian ini adalah "katalog" komponen siap pakai yang disediakan oleh Flutter. Kita akan fokus pada dua set desain utama: Material Design dari Google dan Cupertino dari Apple. Mempelajari bagian ini akan secara drastis mempercepat proses pengembangan karena kita tidak perlu membuat komponen umum seperti tombol, app bar, atau dialog dari nol. Perannya adalah memberikan "daging dan kulit" pada kerangka layout yang telah kita pelajari, mengubah struktur kosong menjadi aplikasi yang indah dan fungsional.

---

#### **3.1. Material Design Implementation**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah set komponen default dan yang paling umum digunakan di Flutter. Material Design adalah sistem desain komprehensif dari Google yang menyediakan panduan tentang animasi, style, layout, dan komponen. Menguasai bagian ini berarti Anda bisa membangun aplikasi Android (dan platform lain) yang terlihat modern, konsisten, dan intuitif bagi pengguna.

###### **3.1.1. Material Components**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah widget-widget spesifik yang mengimplementasikan panduan Material Design. Kita akan belajar tentang `Scaffold`, `AppBar`, `Button`, `Dialog`, dan komponen fundamental lainnya yang membentuk struktur dan interaktivitas sebagian besar aplikasi Flutter.

**Konsep Kunci & Filosofi Mendalam:**

- **`Scaffold` sebagai Struktur Utama:** `Scaffold` adalah widget yang paling penting di bagian ini. Ia menyediakan kerangka kerja standar untuk sebuah layar dalam aplikasi Material Design. Ia memiliki "slot" khusus untuk komponen umum seperti `AppBar` (di atas), `BottomNavigationBar` (di bawah), `FloatingActionButton` (mengambang), `Drawer` (menu samping), dan tentu saja `body` untuk konten utama. Menggunakan `Scaffold` memastikan aplikasi Anda memiliki struktur yang benar dan konsisten.
- **Komponen Interaktif:** Banyak dari widget ini (seperti `FloatingActionButton`, `ElevatedButton`, `IconButton`) memiliki parameter `onPressed`. Ini adalah _callback function_ yang akan dieksekusi ketika pengguna berinteraksi (menekan) widget tersebut. Di sinilah logika aplikasi mulai terhubung dengan UI.

**Terminologi Esensial & Penjelasan Detil:**

- **`Scaffold`:** Kerangka visual dasar untuk halaman Material Design.
- **`AppBar`:** Bar di bagian atas layar, biasanya berisi judul halaman, ikon, dan tombol aksi.
- **`FloatingActionButton` (FAB):** Tombol bulat yang mengambang di atas UI, digunakan untuk aksi utama di sebuah layar.
- **`Drawer`:** Panel navigasi yang muncul dari samping layar (biasanya dari kiri).
- **`BottomNavigationBar`:** Bar navigasi di bagian bawah layar dengan beberapa item untuk berpindah antar halaman utama.
- **`SnackBar`:** Pesan singkat yang muncul di bagian bawah layar untuk memberikan notifikasi sementara.
- **`Dialog`:** Jendela kecil yang muncul di atas konten utama untuk meminta konfirmasi atau input dari pengguna.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini menunjukkan penggunaan `Scaffold` dengan beberapa komponen utamanya.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Halaman Beranda', style: TextStyle(fontSize: 30)),
    Text('Halaman Pencarian', style: TextStyle(fontSize: 30)),
    Text('Halaman Profil', style: TextStyle(fontSize: 30)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. SCAFFOLD: Menyediakan struktur utama halaman.
    return Scaffold(
      // 2. APPBAR: Bar di bagian atas.
      appBar: AppBar(
        title: const Text('Komponen Material'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
        ],
      ),
      // 3. DRAWER: Menu samping yang muncul dari kiri.
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text('Menu Utama', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(leading: Icon(Icons.message), title: Text('Pesan')),
            ListTile(leading: Icon(Icons.account_circle), title: Text('Profil')),
            ListTile(leading: Icon(Icons.settings), title: Text('Pengaturan')),
          ],
        ),
      ),
      // 4. BODY: Konten utama halaman.
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // 5. FLOATINGACTIONBUTTON: Tombol aksi utama.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 6. SNACKBAR: Menampilkan notifikasi saat FAB ditekan.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Anda menekan tombol FAB!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      // 7. BOTTOMNAVIGATIONBAR: Navigasi di bagian bawah.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
```

**Rekomendasi Visualisasi:**
Diagram beranotasi yang membedah sebuah `Scaffold` dan menunjuk ke setiap "slot"-nya (`appBar`, `body`, `floatingActionButton`, `drawer`, `bottomNavigationBar`) akan sangat efektif.

**Sumber Referensi Lengkap:**

- **Katalog Komponen Material:** [Material Components widgets - Flutter Docs](https://docs.flutter.dev/development/ui/widgets/material)
- **Panduan Desain Material 3:** [Material Design 3](https://m3.material.io/)

---

###### **3.1.2. Material Design 3 (Material You)**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah pembaruan terbaru dari sistem desain Google. Fokus utamanya adalah personalisasi (_Material You_), dengan bentuk yang lebih organik dan skema warna yang dinamis. Mengetahui M3 penting agar aplikasi Anda terlihat modern dan sesuai dengan estetika terbaru di platform Android.

**Konsep Kunci & Filosofi Mendalam:**

- **Dynamic Color:** Fitur andalan M3, terutama di Android 12+. Sistem secara otomatis mengambil warna dari _wallpaper_ pengguna dan membuat skema warna (`ColorScheme`) yang harmonis untuk digunakan di seluruh aplikasi. Ini membuat setiap aplikasi terasa lebih personal dan terintegrasi dengan OS.
- **Color Roles & Tokens:** M3 mendefinisikan warna berdasarkan perannya (misalnya, `primary`, `secondary`, `surface`, `onPrimary`), bukan nama warnanya (seperti `blue`, `red`). Ini memungkinkan tema gelap/terang dan warna dinamis bekerja secara mulus. _Tokens_ adalah "variabel" desain yang menyimpan nilai untuk warna, tipografi, dll.
- **Komponen yang Diperbarui:** Hampir semua komponen Material (seperti `Button`, `AppBar`, `Card`) memiliki tampilan baru di M3, seringkali dengan bentuk sudut yang lebih bulat.

**Sintaks Dasar / Contoh Implementasi Inti:**
Untuk mengaktifkan M3, Anda cukup mengatur `useMaterial3: true` di `ThemeData` aplikasi Anda.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // KONFIGURASI TEMA
      theme: ThemeData(
        // 1. Aktifkan Material 3
        useMaterial3: true,

        // 2. Definisikan skema warna.
        // `fromSeed` akan secara cerdas menghasilkan palet warna
        // lengkap (primary, secondary, tertiary, surface, dll)
        // hanya dari satu warna dasar (seed).
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const M3DemoScreen(),
    );
  }
}

class M3DemoScreen extends StatelessWidget {
  const M3DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Di M3, warna AppBar biasanya mengambil dari warna `surface`.
        title: const Text('Demo Material 3'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Card di M3 memiliki style yang sedikit berbeda.
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Ini adalah Card M3'),
              ),
            ),
            const SizedBox(height: 20),
            // FilledButton adalah varian baru di M3.
            FilledButton(
              onPressed: () {},
              child: const Text('Filled Button'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // FAB di M3 secara default berbentuk kotak bulat (squircle).
        onPressed: () {},
        // Warna FAB akan mengambil dari `primary` atau `tertiary` container
        // dari ColorScheme.
        child: const Icon(Icons.edit),
      ),
    );
  }
}
```

**Tips dan Praktik Terbaik:**
Gunakan `ColorScheme.fromSeed()` untuk memulai tema M3 Anda. Ini adalah cara termudah untuk mendapatkan palet warna yang harmonis dan lengkap tanpa harus mendefinisikan setiap warna secara manual.

**Sumber Referensi Lengkap:**

- **Flutter dan Material 3:** [Bringing Material 3 to Flutter - Flutter (Medium)](https://medium.com/flutter/material-3-in-flutter-f84e4a5b9d4c)
- **Paket untuk Dynamic Color:** [dynamic_color package - pub.dev](https://pub.dev/packages/dynamic_color)

---

###### **3.1.3. Cupertino (iOS) Design**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Flutter tidak hanya untuk Android. Bagian ini memperkenalkan pustaka widget Cupertino, yang memungkinkan Anda membangun aplikasi dengan tampilan dan nuansa asli iOS, sesuai dengan _Human Interface Guidelines (HIG)_ dari Apple.

**Konsep Kunci & Filosofi Mendalam:**

- **Platform-Adaptive Apps:** Tujuan utamanya adalah membuat aplikasi yang terasa "di rumah" di platform mana pun ia berjalan. Daripada memaksakan tampilan Material di iOS, developer yang baik akan mendeteksi platform dan menampilkan widget Cupertino saat di iOS dan widget Material saat di Android.
- **Paralelisme Komponen:** Banyak widget Material memiliki padanan di Cupertino.
  - `MaterialApp` -\> `CupertinoApp`
  - `Scaffold` -\> `CupertinoPageScaffold`
  - `AppBar` -\> `CupertinoNavigationBar`
  - `BottomNavigationBar` -\> `CupertinoTabBar`

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/cupertino.dart'; // Import library Cupertino
import 'dart:io' show Platform;
import 'package:flutter/material.dart';

// Di aplikasi nyata, Anda akan menggunakan logika untuk memilih
// mana yang akan dijalankan.
void main() {
  if (Platform.isIOS) {
    runApp(const MyCupertinoApp());
  } else {
    runApp(const MyMaterialApp()); // Anggap MyMaterialApp sudah ada
  }
}

class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Gunakan CupertinoApp sebagai root.
    return const CupertinoApp(
      title: 'Demo Cupertino',
      home: CupertinoHomeScreen(),
    );
  }
}

class CupertinoHomeScreen extends StatelessWidget {
  const CupertinoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Gunakan CupertinoPageScaffold sebagai kerangka halaman.
    return CupertinoPageScaffold(
      // 3. Gunakan CupertinoNavigationBar sebagai app bar.
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Gaya iOS'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 4. Gunakan widget Cupertino lainnya.
            CupertinoButton.filled(
              onPressed: () {
                // Menampilkan dialog gaya iOS
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Dialog iOS'),
                    content: const Text('Ini adalah contoh dialog Cupertino.'),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                );
              },
              child: const Text('Tampilkan Dialog iOS'),
            ),
            const SizedBox(height: 20),
            const CupertinoActivityIndicator(radius: 20), // Loading spinner iOS
          ],
        ),
      ),
    );
  }
}

// Dummy MaterialApp untuk contoh
class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(home: Scaffold(body: Center(child: Text("Ini aplikasi Material"))));
```

**Sumber Referensi Lengkap:**

- **Katalog Widget Cupertino:** [Cupertino widgets - Flutter Docs](https://docs.flutter.dev/development/ui/widgets/cupertino)
- **Panduan Desain Apple:** [Human Interface Guidelines - Apple Developer](https://developer.apple.com/design/human-interface-guidelines/)
- **Membuat Aplikasi Adaptif:** [Building adaptive apps - Flutter Docs](https://docs.flutter.dev/development/ui/layout/adaptive-responsive)

---

#### **3.2. Custom Widget Development**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Setelah menggunakan komponen bawaan, langkah selanjutnya adalah belajar membuat komponen kita sendiri. Ini adalah keterampilan krusial untuk menjaga kode agar tetap _DRY (Don't Repeat Yourself)_, bersih, dan mudah dikelola. Dengan membuat widget kustom, kita dapat mengenkapsulasi UI dan logika yang kompleks menjadi satu unit yang dapat digunakan kembali di seluruh aplikasi.

###### **3.2.1. Creating Custom Widgets**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Bagian ini mengajarkan pendekatan praktis untuk mengekstrak bagian dari UI menjadi kelas widget tersendiri (`StatelessWidget` atau `StatefulWidget`).

**Konsep Kunci & Filosofi Mendalam:**

- **Composition over Inheritance:** Ini adalah prinsip inti di Flutter. Daripada mencoba "mewarisi" atau "memperluas" widget yang kompleks seperti `ElevatedButton`, cara yang benar adalah dengan **menyusun** widget-widget yang lebih sederhana di dalam widget kustom Anda. Widget kustom Anda biasanya akan memiliki `Container`, `Row`, `Column`, `Text`, dll. di dalamnya.
- **Manfaat Widget Kustom:**
  1.  **Reusability (Dapat Digunakan Kembali):** Gunakan widget yang sama di banyak tempat.
  2.  **Readability (Keterbacaan):** `Widget Tree` utama menjadi lebih pendek dan lebih mudah dibaca. Daripada 50 baris kode layout, Anda mungkin hanya memiliki `<ProfileHeader />`.
  3.  **Maintainability (Kemudahan Perawatan):** Jika Anda perlu mengubah desain, Anda hanya perlu mengubahnya di satu tempat (di dalam file widget kustom).

**Sintaks Dasar / Contoh Implementasi Inti:**
Kita akan mengambil salah satu `Card` dari contoh layout `ProfileCard` sebelumnya dan mengubahnya menjadi widget kustom yang dapat digunakan kembali.

```dart
import 'package:flutter/material.dart';

// SEBELUM (di dalam satu build method):
// Card(
//   margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
//   child: ListTile(
//     leading: const Icon(Icons.phone, color: Colors.teal),
//     title: Text('+62 123 4567 8910', style: ...),
//   ),
// ),

// --- REFACTOR MENJADI WIDGET KUSTOM ---

// SESUDAH:
// 1. Buat class StatelessWidget baru.
class InfoCard extends StatelessWidget {
  // 2. Definisikan parameter yang dibutuhkan di constructor.
  // Ini membuat widget menjadi dinamis dan dapat dikonfigurasi.
  final String text;
  final IconData icon;

  // `required` memastikan parameter ini harus diisi saat widget dibuat.
  const InfoCard({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // 3. Pindahkan UI yang berulang ke dalam build method di sini.
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: ListTile(
        leading: Icon(
          icon, // Gunakan parameter ikon
          color: Colors.teal,
        ),
        title: Text(
          text, // Gunakan parameter teks
          style: TextStyle(
            color: Colors.teal.shade900,
            fontFamily: 'Source Sans Pro',
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}

// --- CARA MENGGUNAKANNYA DI UI UTAMA ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const <Widget>[
          // 4. Panggil widget kustom kita. Kode jadi lebih bersih!
          InfoCard(
            icon: Icons.phone,
            text: '+62 123 4567 8910',
          ),
          InfoCard(
            icon: Icons.email,
            text: 'jane.doe@example.com',
          ),
          InfoCard(
            icon: Icons.location_on,
            text: 'Jakarta, Indonesia',
          ),
        ],
      ),
    );
  }
}
```

**Tips dan Praktik Terbaik:**
Ekstrak widget sesering mungkin! Jika Anda melihat sekelompok widget yang logis atau sebuah bagian UI yang mungkin akan Anda gunakan lagi, jangan ragu untuk membungkusnya dalam `StatelessWidget` atau `StatefulWidget` kustom.

**Sumber Referensi Lengkap:**

- **Panduan Resmi:** [Building custom widgets - Flutter Docs](https://docs.flutter.dev/development/ui/widgets/custom)

# Selamat!

Ini menandai akhir dari **FASE 2**. Anda sekarang memiliki semua pengetahuan fundamental tentang UI di Flutter: memahami anatomi dan siklus hidup widget, cara menyusunnya dengan sistem layout, mengetahui komponen-komponen siap pakai, dan cara membuat komponen Anda sendiri. Anda sudah bisa membangun hampir semua jenis UI statis.

---

Keterampilan ini sangat kuat, tetapi belum lengkap. Aplikasi kita belum bisa benar-benar "berpikir" atau mengelola data yang kompleks. Itulah yang akan kita pelajari selanjutnya yaitu memasuki dunia yang sangat penting berikutnya di **FASE 3: State Management & Data Flow**.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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
