> [flash][pro2]

# **[FASE 2: Widget System & UI Foundation][0]**

Fase ini adalah tempat Anda akan mulai memahami dan membangun antarmuka pengguna di _Flutter_ secara praktis, berlandaskan filosofi "Everything is a Widget" yang telah kita pelajari sebelumnya. Ini adalah titik awal Anda dalam membangun antarmuka pengguna yang sesungguhnya di _Flutter_.

### **DAFTAR ISI FASE**

<details>
  <summary>📃 Struktur Daftar Materi</summary>

---

[2.1 Pengenalan Widget: Building Blocks UI](#21-pengenalan-widget-building-blocks-ui)

- [Apa itu Widget (Stateless vs Stateful)](#satu)
- [Struktur Widget Tree](#dua)
- [Hot Reload & Widget Tree Reconstruction](#tiga)
- [Diagrma](#empat)
- [Sintaks/Contoh Implementasi](#lima)
- [Visualisasi](#enam)
- [Terminologi Esensial](#tujuh)
- [Hubungan dengan Bagian Lain](#delapan)
- [Tips & Best Practices](#sembilan)
- [Potensi Kesalahan Umum & Solusi](#sepuluh)

---

[2.2 Tipe-tipe Widget Utama](#22-tipe-tipe-widget-utama)

- [Layout Widgets (Row, Column, Stack, Container, Padding, Center, Expanded)](#sebelas)
- [Basic Material Design Widgets (Text, Icon, Image, Button - ElevatedButton, TextButton, OutlinedButton)](#duabelas)
- [Interaktif Widgets (GestureDetector, InkWell)](#tigabelas)
- [Sintaks/Contoh Implementasi](#empatbelas)
- [Visualisasi](#limabelas)
- [Terminologi Esensial](#enambelas)
- [Hubungan dengan Bagian Lain](#tujuhbelas)
- [Tips & Best Practices](#delapanbelas)
- [Potensi Kesalahan Umum & Solusi](#sembilanbelas)

---

[2.3 Membangun UI Kompleks dengan Komposisi Widget](#23-membangun-ui-kompleks-dengan-komposisi-widget)

- [Nesting Widgets](#duapuluh)
- [Understanding Context](#duapuluhsatu)
- [Widget Keys (GlobalKey, LocalKey, ValueKey, ObjectKey)](#duapuluhdua)
- [Sintaks/Contoh Implementasi](#duapuluhtiga)
- [Visualisasi](#duapuluhempat)
- [Terminologi Esensial](#duapuluhlima)
- [Hubungan dengan Bagian Lain](#duapuluhenam)
- [Tips & Best Practices](#duapuluhtujuh)
- [Potensi Kesalahan Umum & Solusi](#duapuluhdelapan)

---

2.4 Navigasi Dasar (Navigator 1.0)

- Push & Pop Routes
- Passing Data Between Routes

---

2.5 Pengenalan Asset (Images, Fonts, Icons)

</details>

---

### **[2.1 Pengenalan Widget: Building Blocks UI](#)**

**Deskripsi Detail & Peran:**
Sub-bagian ini adalah pondasi utama dalam memahami cara membangun UI di _Flutter_. Kita akan membahas konsep fundamental _widget_, yang merupakan "balok bangunan" dari setiap aplikasi _Flutter_. Memahami _widget_ adalah kunci karena, sesuai filosofi _Flutter_, **"Everything is a Widget"**. Peran _widget_ sangat sentral; mereka tidak hanya mendeskripsikan elemen visual di layar (seperti teks atau tombol) tetapi juga aspek _layout_ (seperti _padding_ atau perataan), interaksi, dan bahkan aplikasi itu sendiri.

**Konsep Kunci & Filosofi:**
Filosofi utama di sini adalah **komposisi** dan **deklaratif**. Daripada memanipulasi elemen UI secara langsung (imperatif), Anda _mendeklarasikan_ bagaimana UI Anda seharusnya terlihat pada _state_ tertentu dengan mengkomposisikan _widget-widget_ kecil menjadi _widget_ yang lebih besar dan kompleks.

<h3 id="satu"></h3>

- **[Apa itu Widget (Stateless vs Stateful):](#)**

  - **Widget:** Sebuah _widget_ adalah deskripsi dari bagian antarmuka pengguna Anda pada titik waktu tertentu. _Widget_ itu sendiri _immutable_ (tidak dapat diubah setelah dibuat). Jika ada perubahan pada konfigurasi _widget_, _Flutter_ akan membuat _widget_ baru yang menggantikan _widget_ lama.
  - **StatelessWidget:** Digunakan untuk bagian UI yang tidak berubah sepanjang waktu atau tidak memerlukan _state_ internal. Ketika `build` method dipanggil, _StatelessWidget_ akan membangun UI-nya berdasarkan konfigurasi yang diberikan dan tidak akan berubah kecuali konfigurasi inputnya berubah dari _parent widget_. Contoh: `Text`, `Icon`, `AppBar`.
  - **StatefulWidget:** Digunakan untuk bagian UI yang dapat berubah seiring waktu atau memerlukan _state_ internal yang dapat diubah. Ketika _state_ internalnya berubah (misalnya, nilai _counter_ yang bertambah), _StatefulWidget_ akan memicu pembangunan ulang dirinya sendiri (melalui `setState()`) untuk merefleksikan perubahan _state_ tersebut. Contoh: `Checkbox`, `Slider`, _widget_ yang menampilkan data dari _API_.

<h3 id="dua"></h3>

- **[Struktur Widget Tree:](#)**

  - Setiap aplikasi _Flutter_ adalah kumpulan _widget_ yang tersusun dalam struktur hierarkis yang disebut **Widget Tree**. _Widget_ di bagian atas _tree_ adalah _parent_ dari _widget_ di bawahnya, dan _widget_ di bawah adalah _child_. Proses membangun UI di _Flutter_ adalah tentang menumpuk _widget-widget_ ini (nesting) untuk membentuk antarmuka yang kompleks.

<h3 id="tiga"></h3>

- **[Hot Reload & Widget Tree Reconstruction:](#)**

  - _Hot Reload_ bekerja dengan membangun ulang bagian _widget tree_ yang berubah. Saat Anda mengubah kode dan melakukan _Hot Reload_, _Flutter_ akan membandingkan _widget tree_ yang baru dengan yang lama. Jika ada perubahan, _Flutter_ akan secara efisien memperbarui bagian-bagian _tree_ yang relevan tanpa mereset seluruh _state_ aplikasi. Ini memungkinkan siklus _feedback_ yang sangat cepat selama pengembangan.

<h3 id="empat"></h3>

**[Diagram:](#)**

Diagram yang menggambarkan konsep _widget_ dan _widget tree_.

```
┌───────────────────────────────────────────────┐
│     Induk atau Pembungkus (Parent Widget)     │
│   (Misal: Scaffold, Column, Container)        │
└───────────────┬───────────────────────────────┘
                │
                ▼
┌────────────────────────────────────────────────┐
│    anak-anak Widget UI (Child Widgets)         │
│ ┌────────────────────────────────────────────┐ │        Keterangan:
│ │               Widget A                     │ │          - Setiap blok adalah Widget.
│ │(Jenis Kode: StatelessWidget/StatefulWidget)│ │          - Widget adalah deskripsi UI.
│ └───────┬────────────────────────────────────┘ │          - Tersusun hierarkis (Parent-Child).
│         │                                      │
│         ▼                                      │
│ ┌────────────────────────────────────────────┐ │
│ │               Widget B                     │ │
│ │(Jenis Kode: StatelessWidget/StatefulWidget)│ │
│ └───────┬────────────────────────────────────┘ │
│         │                                      │
│         ▼                                      │
│ ┌────────────────────────────────────────────┐ │
│ │               Widget C                     │ │
│ │(Jenis Kode: StatelessWidget/StatefulWidget)│ │
│ └────────────────────────────────────────────┘ │
└────────────────────────────────────────────────┘
```

<h3 id="lima"></h3>

**[Sintaks/Contoh Implementasi:](#)**

Berikut adalah contoh kode (Dart) yang menunjukkan penggunaan `StatelessWidget` dan `StatefulWidget` serta bagaimana mereka bersarang untuk membentuk sebuah `Widget Tree`.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp adalah StatelessWidget
// Ini adalah "Induk" dari seluruh aplikasi kita.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // MaterialApp juga merupakan "Induk" dari Scaffold
      title: 'Widget Demo',
      home: Scaffold( // Scaffold adalah "Pembungkus" utama halaman
        appBar: AppBar(
          title: const Text('Pengenalan Widget'), // Text adalah "anak" dari AppBar
        ),
        body: Center( // Center adalah "Pembungkus" yang menengahkan anaknya
          child: Column( // Column adalah "Pembungkus" yang menata anak-anaknya secara vertikal
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ // children adalah daftar "anak-anak Widget UI"
              const TeksStateless(), // Anak Widget UI (Stateless)
              const SpasiVertikal(tinggi: 20), // Anak Widget UI (Stateless)
              const TombolCounter(), // Anak Widget UI (Stateful)
            ],
          ),
        ),
      ),
    );
  }
}

// Contoh StatelessWidget sederhana
// Widget ini tidak memiliki state yang berubah secara internal.
// Ia hanya menampilkan teks berdasarkan konfigurasinya.
class TeksStateless extends StatelessWidget {
  const TeksStateless({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Saya adalah StatelessWidget!',
      style: TextStyle(fontSize: 20, color: Colors.blueAccent),
    );
  }
}

// Contoh StatelessWidget lain untuk spasi
class SpasiVertikal extends StatelessWidget {
  final double tinggi;
  const SpasiVertikal({super.key, required this.tinggi});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: tinggi); // SizedBox adalah widget yang memberikan ukuran
  }
}


// Contoh StatefulWidget sederhana
// Widget ini memiliki state internal (nilai _counter) yang bisa berubah.
class TombolCounter extends StatefulWidget {
  const TombolCounter({super.key});

  @override
  State<TombolCounter> createState() => _TombolCounterState();
}

class _TombolCounterState extends State<TombolCounter> {
  int _counter = 0; // State internal dari widget

  void _incrementCounter() {
    // setState() memberitahu Flutter bahwa state telah berubah
    // dan widget perlu dibangun ulang untuk merefleksikan perubahan tersebut.
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column( // Contoh Induk/Pembungkus untuk menampilkan teks dan tombol
      children: <Widget>[
        Text(
          'Counter: $_counter', // Menampilkan state _counter
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ElevatedButton( // Anak Widget UI (Tombol)
          onPressed: _incrementCounter, // Ketika ditekan, ubah state
          child: const Text('Tambah Counter'),
        ),
      ],
    );
  }
}
```

<h3 id="enam"></h3>

**[Visualisasi](#)**

Widget Tree dari Contoh Kode di Atas:

```
┌──────────────────────────────────────────────────────────┐
│                      MyApp (StatelessWidget)             │
│                (Induk utama aplikasi Flutter)            │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│                   MaterialApp (StatelessWidget)          │
│         (Pembungkus konfigurasi Material Design)         │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│                   Scaffold (StatelessWidget)             │
│           (Pembungkus struktur halaman dasar)            │
└───────────────────────┬──────────────────────────────────┘
            ┌───────────┴───────────┐
            ▼                       ▼
┌─────────────────┐       ┌────────────────────────────────────────────────┐
│AppBar(Stateless)│       │        Center (StatelessWidget)                │
│                 │       │ (Pembungkus untuk menengahkan anaknya)         │
└────────┬────────┘       └───────────────────────┬────────────────────────┘
         │                                        │
         ▼                                        ▼
┌─────────────────┐             ┌──────────────────────────────────────────┐
│ Text (Stateless)│             │               Column (StatelessWidget)   │
│ ("Pengenalan   "│             │   (Pembungkus untuk menata anak vertikal)│
│ " Widget")      │             └───────────────────┬──────────────────────┘
└─────────────────┘                         ┌───────┴────────────────────────────┐
                                            ▼                                    ▼
┌──────────────────────────┐      ┌──────────────────────────┐      ┌──────────────────────────┐
│ TeksStateless (Stateless)│      │ SpasiVertikal (Stateless)│      │ TombolCounter (Stateful) │
│("Saya adalah Stateless" )│      │ (tinggi: 20)             │      │ (Counter: 0, Tombol)     │
└──────────────────────────┘      └──────────────────────────┘      └──────────────────────────┘
```

<h3 id="tujuh"></h3>

**[Terminologi Esensial:](#)**

- **Widget:** Unit dasar dan _immutable_ dari UI di _Flutter_.
- **StatelessWidget:** _Widget_ yang tidak memiliki _state_ yang berubah. UI-nya ditentukan oleh argumen konstruktornya.
- **StatefulWidget:** _Widget_ yang memiliki _state_ internal yang dapat berubah sepanjang siklus hidupnya. Membangun ulang UI ketika _state_ berubah.
- **Widget Tree:** Struktur hierarkis dari semua _widget_ yang membentuk UI aplikasi.
- **Parent Widget:** _Widget_ yang berisi atau membungkus _widget_ lain.
- **Child Widget:** _Widget_ yang terkandung di dalam _parent widget_.
- **Nesting:** Proses menempatkan _widget_ di dalam _widget_ lain.
- **Build Method:** Metode yang harus diimplementasikan oleh setiap _widget_ (`StatelessWidget` atau `StatefulWidget`) yang mengembalikan _widget tree_ yang mewakili bagian UI dari _widget_ tersebut.
- **setState():** Metode yang dipanggil dalam `State` dari `StatefulWidget` untuk memberi tahu _Flutter_ bahwa _state_ internal telah berubah dan _widget_ perlu dibangun ulang.

**Struktur Internal (Mini-DAFTAR ISI):**

- Definisi Widget dan Perannya
- Perbedaan antara StatelessWidget dan StatefulWidget
- Konsep dan Visualisasi Widget Tree
- Bagaimana Hot Reload Berinteraksi dengan Widget Tree

<h3 id="delapan"></h3>

**[Hubungan dengan Bagian Lain:](#)**
Pengenalan _widget_ ini adalah inti dari seluruh **FASE 2: Widget System & UI Foundation**. Pemahaman yang kuat di sini akan menjadi dasar untuk semua topik berikutnya, termasuk "Tipe-tipe Widget Utama" (Anda akan menggunakan banyak _widget_), "Membangun UI Kompleks dengan Komposisi Widget" (Anda akan banyak melakukan _nesting_), dan "State Management" (bagaimana _state_ memengaruhi pembangunan ulang _widget_). Ini adalah fondasi dari seni membangun UI di _Flutter_.

**Referensi Lengkap:**

- [Flutter Official Documentation - Widgets Introduction](https://docs.flutter.dev/ui/widgets/basics)
- [Flutter Official Documentation - State Management: Simple app state management](https://docs.flutter.dev/data-and-backend/state-mgmt/options%23simple-app-state-management) (Meskipun judulnya _State Management_, bagian awal membahas _Stateless_ vs _Stateful_ secara baik.)
- [YouTube - Widget (Flutter in Focus)](https://www.youtube.com/watch%3Fv%3DF0K01X30jS4)

<h3 id="sembilan"></h3>

**[Tips & Best Practices (untuk peserta):](#)**

- **Pikirkan dalam Blok Kecil:** Daripada mencoba membangun seluruh layar sekaligus, pecah UI menjadi _widget-widget_ kecil yang dapat digunakan kembali.
- **Pahami `build` method:** Ini adalah jantung dari setiap _widget_. Ia harus mengembalikan _widget tree_ yang merepresentasikan UI.
- **Jangan Lupakan `const`:** Gunakan `const` pada _widget_ yang tidak akan berubah untuk performa yang lebih baik. Ini memungkinkan _Flutter_ untuk tidak membangun ulang _widget_ tersebut setiap saat.
- **Kapan StatefulWidget?** Hanya gunakan `StatefulWidget` ketika Anda benar-benar membutuhkan _state_ yang berubah secara internal. Jika UI hanya menampilkan data yang diterima dari _parent_ atau sumber eksternal, gunakan `StatelessWidget`.

<h3 id="sepuluh"></h3>

**[Potensi Kesalahan Umum & Solusi:](#)**

- **Kesalahan:** Mencoba mengubah properti _widget_ yang sudah ada secara langsung setelah dibangun (misalnya `Text('Hello').text = 'Hi'`).
  - **Solusi:** Ingat bahwa _widget_ _immutable_. Untuk mengubah UI, Anda harus mengembalikan _widget_ baru dari `build` method Anda (atau memanggil `setState` jika itu adalah `StatefulWidget` yang memicu pembangunan ulang).
- **Kesalahan:** Meletakkan semua UI dalam satu _widget_ besar yang kompleks.
  - **Solusi:** Pecah UI menjadi _widget_ kecil yang terpisah dan fokus pada satu tanggung jawab. Ini meningkatkan keterbacaan, _reusability_, dan performa.
- **Kesalahan:** Menggunakan `setState()` pada `StatelessWidget`.
  - **Solusi:** `StatelessWidget` tidak memiliki `State` dan oleh karena itu tidak memiliki metode `setState()`. Jika Anda perlu mengelola _state_ yang berubah, gunakan `StatefulWidget`.

---

**Selamat!** Anda telah menyelami **Pengenalan Widget: Building Blocks UI** dengan detail yang komprehensif, termasuk visualisasi penting dari _Widget Tree_. Memahami _widget_, perbedaannya, dan bagaimana mereka bersarang, adalah langkah pertama yang paling fundamental dalam perjalanan Anda sebagai pengembang _Flutter_. Ini adalah dasar dari segalanya!

---

Selanjutnya kita akan melanjutkan ke sub-bagian berikutnya, yaitu **2.2 Tipe-tipe Widget Utama**. Di sini, Anda akan mulai mengenal berbagai _widget_ yang paling sering digunakan dalam membangun antarmuka pengguna di _Flutter_. Memahami tipe-tipe _widget_ ini adalah kunci untuk merancang _layout_ yang efektif, menampilkan konten, dan menambahkan interaktivitas ke aplikasi Anda.

### **[2.2 Tipe-tipe Widget Utama](#)**

**Deskripsi Detail & Peran:**
Sub-bagian ini akan memperkenalkan Anda pada berbagai _widget_ inti yang disediakan oleh _Flutter framework_. _Widget-widget_ ini dapat dikategorikan berdasarkan fungsi utamanya: _layout_, menampilkan konten, dan interaksi. Memahami peran dan properti dari setiap _widget_ akan memungkinkan Anda untuk membangun antarmuka yang kompleks dengan mudah.

**Konsep Kunci & Filosofi:**
Filosofi di balik _widget-widget_ ini adalah **modularitas** dan **kemudahan penggunaan**. _Flutter_ menyediakan banyak _widget_ siap pakai yang dapat Anda gunakan untuk membangun UI tanpa perlu menulis kode _rendering_ tingkat rendah. Setiap _widget_ memiliki tanggung jawab yang spesifik, sehingga Anda dapat menggabungkannya untuk menciptakan antarmuka yang kompleks.

<h3 id="sebelas"></h3>

- **[Layout Widgets (Row, Column, Stack, Container, Padding, Center, Expanded):](#daftar-isi-fase)**
  - Widget-widget ini digunakan untuk mengatur posisi dan ukuran _widget_ lain di dalam layout.
  - `Row` dan `Column` mengatur _widget_ secara horizontal dan vertikal.
  - `Stack` menumpuk _widget_ di atas satu sama lain.
  - `Container` adalah _widget_ serbaguna yang dapat digunakan untuk menambahkan _padding_, _margin_, _border_, dan _background_ ke _widget_ lain.
  - `Padding` menambahkan ruang kosong di sekitar _widget_.
  - `Center` menengahkan _widget_ di dalam _parent_-nya.
  - `Expanded` membuat _widget_ mengisi ruang kosong yang tersedia di dalam `Row` atau `Column`.

<h3 id="duabelas"></h3>

- **[Basic Material Design Widgets (Text, Icon, Image, Button - ElevatedButton, TextButton, OutlinedButton):](#daftar-isi-fase)**

  - Widget-widget ini digunakan untuk menampilkan konten dan menambahkan interaktivitas dasar
  - `Text` menampilkan teks.
  - `Icon` menampilkan ikon.
  - `Image` menampilkan gambar.
  - `ElevatedButton`, `TextButton`, dan `OutlinedButton` adalah berbagai jenis tombol yang dapat diklik.

<h3 id="tigabelas"></h3>

- **[Interaktif Widgets (GestureDetector, InkWell):](#)**
  - Widget-widget ini digunakan untuk mendeteksi dan merespons interaksi pengguna.
  - `GestureDetector` mendeteksi berbagai jenis _gesture_, seperti _tap_, _drag_, dan _swipe_.
  - `InkWell` menambahkan efek riak tinta saat _widget_ diklik.

<h3 id="empatbelas"></h3>

**[Sintaks/Contoh Implementasi & Visualisasi:](#daftar-isi-fase)**

Berikut adalah contoh kode yang menunjukkan penggunaan berbagai tipe _widget_ utama.

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tipe-tipe Widget Utama'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Halo Flutter!',
                style: TextStyle(fontSize: 24),
              ),
              const Icon(Icons.favorite, color: Colors.red),
              Image.network(
                'https://via.placeholder.com/150',
                width: 150,
                height: 150,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Tombol Elevated'),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gesture Detected!')),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Tap Me!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

<h3 id="limabelas"></h3>

**[Visualisasi:](#daftar-isi-fase)**

```
┌──────────────────────────────────────────────────────────┐
│              Column (Layout Widget)                      │
│         (Mengatur widget secara vertikal)                │
└───────────────────────┬──────────────────────────────────┘
            ┌───────────┴───────────┐
            ▼                       ▼
┌─────────────────┐       ┌──────────────────────────┐
│ Text (Material) │       │   Icon (Material)        │
│ (Menampilkan   )│       │  (Menampilkan ikon)      │
│ (teks)          │       └──────────┬───────────────┘
└─────────────────┘                  │
            ┌────────────────────────▼──────────────────────────┐
            ▼                                                   ▼
┌──────────────────────────┐                     ┌──────────────────────────┐
│     Image (Asset)        │                     │  ElevatedButton (Button) │
│  (Menampilkan gambar)    │                     │  (Tombol yang dapat      │
└──────────────────────────┘                     │  ditekan)                │
                                                 └──────────────────────────┘
            ┌────────────────────────▼──────────────────────────┐
            ▼                                                   ▼
         ┌──────────────────────────────────────────────────────────┐
         │          GestureDetector (Interactive)                   │
         │    (Mendeteksi gesture, dalam hal ini 'tap')             │
         └──────────────────────────────────────────────────────────┘
```

<h3 id="enambelas"></h3>

**[Terminologi Esensial:](#daftar-isi-fase)**

- **Layout:** Proses mengatur posisi dan ukuran _widget_ di layar.
- **Material Design:** Pedoman desain visual yang dikembangkan oleh Google.
- **Gesture:** Tindakan fisik yang dilakukan pengguna pada layar, seperti _tap_, _drag_, dan _swipe_.

**Struktur Internal (Mini-DAFTAR ISI):**

- Layout Widgets
- Basic Material Design Widgets
- Interactive Widgets

<h3 id="tujuhbelas"></h3>

**[Hubungan dengan Bagian Lain:](#daftar-isi-fase)**

- _Widget-widget_ ini adalah dasar dari semua antarmuka pengguna _Flutter_. Anda akan menggunakannya secara ekstensif di semua fase pengembangan aplikasi Anda.

**Referensi Lengkap:**

- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)

<h3 id="delapanbelas"></h3>

**[Tips & Best Practices:](#daftar-isi-fase)**

- Gunakan _widget layout_ untuk mengatur struktur halaman Anda.
- Gunakan _widget Material Design_ untuk membuat antarmuka yang konsisten dengan pedoman desain Android.
- Gunakan _widget_ interaktif untuk menambahkan respons terhadap tindakan pengguna.

<h3 id="sembilanbelas"></h3>

**[Potensi Kesalahan Umum & Solusi:](#)**

- _Kesalahan:_ Menggunakan _widget layout_ yang salah, seperti menggunakan `Row` ketika Anda membutuhkan `Column`.
  - _Solusi:_ Pikirkan tentang bagaimana Anda ingin mengatur _widget_ Anda sebelum memilih _widget layout_.
- _Kesalahan_: Lupa menambahkan padding atau margin, sehingga UI terlihat terlalu padat.
  - _Solusi_: Gunakan _widget Padding_ atau _Container_ untuk menambahkan ruang kosong di sekitar _widget_ Anda.

---

Mari kita lanjutkan ke sub-bagian berikutnya, yaitu **2.3 Membangun UI Kompleks dengan Komposisi Widget**. Di sini, Anda akan belajar bagaimana menggabungkan _widget-widget_ yang telah Anda pelajari sebelumnya untuk menciptakan antarmuka pengguna yang lebih kompleks dan dinamis. Konsep utama di sini adalah _nesting widget_, memahami _context_, dan penggunaan _widget keys_.

### **[2.3 Membangun UI Kompleks dengan Komposisi Widget](#daftar-isi-fase)**

**Deskripsi Detail & Peran:**
Sub-bagian ini akan membawa Anda lebih dalam ke praktik membangun antarmuka pengguna yang kompleks di _Flutter_. Anda akan belajar bagaimana _nesting widget_ untuk menciptakan _layout_ yang rumit, memahami peran `BuildContext` dalam mengakses informasi tentang posisi _widget_ dalam _tree_, dan menggunakan _widget keys_ untuk mengelola _state_ dan identitas _widget_ secara efektif.

**Konsep Kunci & Filosofi:**
Filosofi utama di sini adalah **komposisi** dan **modularitas**. Daripada membuat _widget_ besar yang monolitik, Anda akan belajar bagaimana memecah UI menjadi _widget-widget_ kecil yang dapat digunakan kembali dan menggabungkannya untuk menciptakan antarmuka yang kompleks.

<h3 id="duapuluh"></h3>

- **[Nesting Widgets:](#daftar-isi-fase)**
  - _Nesting widget_ adalah proses menempatkan satu _widget_ di dalam _widget_ lain. Ini adalah cara utama untuk membangun _layout_ yang kompleks di _Flutter_. Anda akan menggunakan _widget layout_ seperti `Row`, `Column`, dan `Stack` untuk mengatur posisi dan ukuran _widget-widget_ lain di dalam _parent_-nya.

<h3 id="duapuluhsatu"></h3>

- **[Understanding Context:](#daftar-isi-fase)**
  - `BuildContext` adalah objek yang berisi informasi tentang posisi _widget_ dalam _widget tree_. Anda dapat menggunakan `BuildContext` untuk mengakses tema aplikasi, media query, dan _widget-widget_ _ancestor_ lainnya. Memahami `BuildContext` sangat penting untuk membangun _widget_ yang responsif dan dapat beradaptasi dengan berbagai ukuran layar dan tema.

<h3 id="duapuluhdua"></h3>

- **[Widget Keys (GlobalKey, LocalKey, ValueKey, ObjectKey):](#daftar-isi-fase)**
  - _Widget keys_ adalah cara untuk memberikan identitas unik pada _widget_. Ini sangat berguna ketika Anda perlu mengelola _state_ _widget_ secara manual atau ketika Anda perlu memastikan bahwa _widget_ mempertahankan _state_-nya saat dipindahkan di dalam _widget tree_.

<h3 id="duapuluhtiga"></h3>

**[Sintaks/Contoh Implementasi & Visualisasi:](#daftar-isi-fase)**

Berikut adalah contoh kode yang menunjukkan bagaimana _nesting widget_ digunakan untuk membangun UI kompleks, bagaimana `BuildContext` digunakan untuk mengakses tema aplikasi, dan bagaimana `ValueKey` digunakan untuk mengelola _state_ _widget_ secara efektif.

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Komposisi Widget'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'UI Kompleks dengan Nesting',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              const WidgetKompleks(),
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetKompleks extends StatelessWidget {
  const WidgetKompleks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Icon(Icons.star, color: Colors.yellow),
              Text(
                'Bintang',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              const Icon(Icons.favorite, color: Colors.red),
              Text(
                'Suka',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

<h3 id="duapuluhempat"></h3>

**[Visualisasi:](#daftar-isi-fase)**

```
┌──────────────────────────────────────────────────────────┐
│               Column (Layout Widget)                     │
│         (Mengatur widget secara vertikal)                │
└───────────────────────┬──────────────────────────────────┘
            ┌───────────┴─────────────────────────────────────────┐
            ▼                                                     ▼
┌─────────────────┐                                  ┌────────────────────────┐
│ Text (Material) │                                  │    WidgetKompleks      │
│ (Menampilkan   )│                                  │  (Widget kompleks yang │
│ teks)           │                                  │  terdiri dari widget   │
└─────────────────┘                                  │  lainnya)              │
                                                     └────────────────────────┘
            ┌────────────────────────▼──────────────────────────┐
            ▼                                                   ▼
         ┌──────────────────────────────────────────────────────────┐
         │               Container (Layout Widget)                  │
         │    (Pembungkus dengan padding dan dekorasi)              │
         └───────────────────────┬──────────────────────────────────┘
                                 │
                                 ▼
         ┌──────────────────────────────────────────────────────────┐
         │                     Row (Layout Widget)                  │
         │           (Mengatur widget secara horizontal)            │
         └───────────────────────┬──────────────────────────────────┘
            ┌────────────────────┴───────────┐
            ▼                                ▼
┌─────────────────┐       ┌──────────────────────────┐
│  Column (Layout)│       │  Column (Layout)         │
│  (Mengatur     )│       │  (Mengatur               │
│  widget         │       │  widget                  │
│  vertikal)      │       │  vertikal)               │
└────────┬────────┘       └──────────┬───────────────┘
         │                           │
         ▼                           ▼
┌─────────────────┐       ┌──────────────────────────┐
│  Icon (Material)│       │  Icon (Material)         │
│  (Menampilkan  )│       │  (Menampilkan            │
│  ikon)          │       │  ikon)                   │
└────────┬────────┘       └──────────┬───────────────┘
         │                           │
         ▼                           ▼
┌─────────────────┐       ┌──────────────────────────┐
│  Text (Material)│       │  Text (Material)         │
│  (Menampilkan  )│       │  (Menampilkan            │
│  teks)          │       │  teks)                   │
└─────────────────┘       └──────────────────────────┘
```

<h3 id="duapuluhlima"></h3>

**[Terminologi Esensial:](#daftar-isi-fase)**

- **Nesting:** Proses menempatkan satu _widget_ di dalam _widget_ lain.
- **BuildContext:** Objek yang berisi informasi tentang posisi _widget_ dalam _widget tree_.
- **Widget Keys:** Cara untuk memberikan identitas unik pada _widget_.

**Struktur Internal (Mini-DAFTAR ISI):**

- Nesting Widgets
- Understanding Context
- Widget Keys

<h3 id="duapuluhenam"></h3>

**[Hubungan dengan Bagian Lain:](#daftar-isi-fase)**

- _Komposisi widget_ adalah inti dari semua antarmuka pengguna _Flutter_. Anda akan menggunakannya secara ekstensif di semua fase pengembangan aplikasi Anda.

**Referensi Lengkap:**

- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)
- [Flutter Keys](https://docs.flutter.dev/ui/advanced/state-management/keys)

<h3 id="duapuluhtujuh"></h3>

**[Tips & Best Practices:](#daftar-isi-fase)**

- Gunakan _widget layout_ untuk mengatur struktur halaman Anda.
- Gunakan _widget Material Design_ untuk membuat antarmuka yang konsisten dengan pedoman desain Android.
- Gunakan _widget keys_ untuk mengelola _state_ _widget_ secara efektif.

<h3 id="duapuluhdelapan"></h3>

**[Potensi Kesalahan Umum & Solusi:](#daftar-isi-fase)**

- _Kesalahan_: Menggunakan _widget layout_ yang salah, seperti menggunakan `Row` ketika Anda membutuhkan `Column`.
  - _Solusi_: Pikirkan tentang bagaimana Anda ingin mengatur _widget_ Anda sebelum memilih _widget layout_.
- _Kesalahan_: Lupa menambahkan padding atau margin, sehingga UI terlihat terlalu padat.
  - _Solusi_: Gunakan _widget Padding_ atau _Container_ untuk menambahkan ruang kosong di sekitar _widget_ Anda.

Apakah Anda ingin melanjutkan ke sub-bagian berikutnya, yaitu **2.4 Navigasi Dasar (Navigator 1.0)**, atau ada aspek dari "Membangun UI Kompleks dengan Komposisi Widget" yang ingin Anda fokuskan lebih dalam lagi?

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md
[pro2]:../../pro/bagian-2/README.md

<!----------------------------------------------------->

[0]: ../../README.md#fase-2-widget-system--ui-foundation
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
