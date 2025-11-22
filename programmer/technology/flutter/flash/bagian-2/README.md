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
- [Apa Itu Widget Tree (Lanjutan)](#empat)
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

## [🧱 Apa Itu Widget Tree?](#) (Lanjutan)

**Widget Tree** adalah _pohon dari widget_ yang tersusun **secara hierarkis**:

Disini akan menggambarkan **struktur dasar _Widget Tree_** di Flutter — dan ini adalah fondasi dari **semua UI yang akan anda buat**. Ini adalah bagian dimana fokus anda nantinya pada **struktur hierarki komponen UI yang anda tulis sendiri dalam Dart**.

---

- Setiap widget bisa punya **satu atau banyak anak (children)**.
- Widget di atas disebut **parent**, widget di bawah disebut **child**.
- Ini seperti "pohon keluarga" dari UI yang anda buat.

---

## 📦 Penjelasan Isi Diagram:

### 🔹 Induk atau Pembungkus (Parent Widget)

Contoh:

```dart
Scaffold(
  body: Column(
    children: [...],
  ),
);
```

➡ `Scaffold` adalah parent dari `Column`.
➡ `Column` adalah parent dari widget lainnya.
➡ Bisa juga `Container`, `Row`, `Stack`, dll.

---

### 🔹 Anak-anak Widget (Child Widgets)

Contoh konkret:

```dart
Column(
  children: [
    Text("A"), // Widget A
    Icon(Icons.star), // Widget B
    ElevatedButton(onPressed: () {}, child: Text("C")), // Widget C
  ],
);
```

- Masing-masing dari `Text`, `Icon`, dan `ElevatedButton` itu adalah **child widget**.
- Bisa berupa `StatelessWidget` atau `StatefulWidget`, tergantung apakah mereka menyimpan state atau tidak.

---

## 📘 Catatan Tambahan:

- **Widget bukan elemen yang tampil langsung**, tapi mereka adalah **deskripsi tentang seperti apa UI seharusnya muncul.**
- Flutter menggunakan deskripsi ini untuk membuat:

  - **Element Tree** (runtime instance),
  - **RenderObject Tree** (yang akan menggambar ke layar).

---

## 🔄 Kenapa Ini Penting?

- Memahami widget tree bikin anda bisa:

  - Menyusun UI yang kompleks secara rapi.
  - Mengelola state lebih baik (misal: tahu di mana harus naruh `StatefulWidget`).
  - **Menghindari rebuild yang tidak perlu.**
  - Ngerti debugging saat UI-nya “bertingkah”.

---

Berikut ini kita akan mencontohkan **kode Dart Flutter** yang sangat mudah. Dalam contoh di sini, kita akan membuat satu `Scaffold` (parent), yang berisi `Column` (pembungkus), dan di dalamnya ada beberapa child widget: `Text`, `Icon`, serta `Container`.

---

## ✅ Contoh Kode Flutter

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
      home: Scaffold( // Parent Widget (Induk)
        appBar: AppBar(title: const Text("Contoh Widget Tree")),
        body: Column( // Pembungkus Child Widgets
          children: const [
            Text("Widget A"), // Widget A
            Icon(Icons.star), // Widget B
            Container( // Widget C
              color: Colors.amber,
              padding: EdgeInsets.all(16),
              child: Text("Widget C"),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🌲 Diagram Widget Tree (berdasarkan kode di atas)

```
MyApp (StatelessWidget)
└── MaterialApp
    └── Scaffold
        ├── AppBar
        │   └── Text("Contoh Widget Tree")
        └── Column
            ├── Text("Widget A")
            ├── Icon(Icons.star)
            └── Container
                └── Text("Widget C")
```

---

## 📘 Penjelasan Singkat:

| Widget                      | Peran                                              |
| --------------------------- | -------------------------------------------------- |
| `Scaffold`                  | Sebagai **Parent Widget utama**.                   |
| `Column`                    | Pembungkus untuk beberapa widget dalam satu kolom. |
| `Text`, `Icon`, `Container` | Masing-masing adalah **Child Widgets**.            |
| `Container`                 | Bisa berisi widget lain (di sini: `Text`).         |

---

## 🎯 Tujuan Pembelajaran

- Memahami **struktur hierarki** antara parent dan child.
- Menyadari bahwa **setiap widget hanya deskripsi UI** — Flutter akan mengolah ini dalam build-rendering flow.
- Mengenali bahwa struktur yang baik akan **mempermudah debugging, komposisi ulang, dan optimisasi**.

## 📌 Kesimpulan

**Diagram ini menggambarkan pola berpikir struktural dalam Flutter.** Anda sebagai developer membangun UI seperti menyusun blok LEGO: satu widget di dalam widget lain, membentuk _tree_.

---

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

<div align="left">
<pre>
┌────────────────────────────────┐
│    MyApp (StatelessWidget)     │
│ (Induk utama aplikasi Flutter) │
└─────┬──────────────────────────┘
      │                  
      ▼                  
┌──────────────────────────────────────────┐
│      MaterialApp (StatelessWidget)       │
│ (Pembungkus konfigurasi Material Design) │
└─────┬────────────────────────────────────┘
      │                  
      ▼                  
┌─────────────────────────────────────┐
│     Scaffold (StatelessWidget)      │
│ (Pembungkus struktur halaman dasar) │
└───────────────────────┬─────────────┘
            ┌───────────┴───────────┐
            ▼                       ▼
┌─────────────────┐       ┌────────────────────────────────────────┐
│AppBar(Stateless)│       │       Center (StatelessWidget)         │
│                 │       │ (Pembungkus untuk menengahkan anaknya) │
└────────┬────────┘       └───────────┬────────────────────────────┘
         │                            │            
         ▼                            ▼            
┌─────────────────┐             ┌─────────────────────────────────────────┐
│ Text (Stateless)│             │        Column (StatelessWidget)         │
│ ("Pengenalan   "│             │ (Pembungkus untuk menata anak vertikal) │
│ " Widget")      │             └─────────┬───────────────────────────────┘
└─────────────────┘                    ┌──┴──────────────────────────┐
                                       ▼                             ▼
┌──────────────────────────┐      ┌──────────────────────────┐   ┌──────────────────────────┐
│ TeksStateless (Stateless)│      │ SpasiVertikal (Stateless)│   │ TombolCounter (Stateful) │
│("Saya adalah Stateless" )│      │ (tinggi: 20)             │   │ (Counter: 0, Tombol)     │
└──────────────────────────┘      └──────────────────────────┘   └──────────────────────────┘
</pre>
</div>

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

Sekarang mari kita perdalam pemahaman Anda tentang fondasi _Flutter_ dengan fokus pada bagaimana _widget tree_ berinteraksi dengan _element tree_ dan _render object tree_. Ini adalah kunci untuk memahami cara _Flutter_ bekerja di balik layar untuk merender UI Anda secara efisien.

### **2.1 Widget Tree & Rendering Engine (Lanjutan)**

#### **Widget Tree Fundamentals (Lanjutan)**

**Deskripsi Detail & Peran:**
Pada bagian ini, kita akan memperdalam pemahaman tentang `Widget Tree` yang telah kita singgung sebelumnya, serta memperkenalkan dua konsep _tree_ fundamental lainnya: `Element Tree` dan `RenderObject Tree`. Memahami perbedaan dan hubungan antara ketiga _tree_ ini adalah vital. Mereka membentuk _rendering pipeline_ _Flutter_, yang bertanggung jawab mengubah deskripsi UI deklaratif Anda menjadi piksel yang terlihat di layar.

**Konsep Kunci & Filosofi:**
Filosofi di balik ketiga _tree_ ini adalah **pemisahan tanggung jawab** dan **efisiensi**.

- **Widget Tree (Konfigurasi UI - Immutable):** Seperti yang telah kita bahas, `Widget` adalah deskripsi dari bagian UI Anda. Mereka adalah _blueprint_ yang ringan dan _immutable_. Setiap kali _state_ berubah, _widget_ baru akan dibuat.
- **Element Tree (Manajemen Instansi - Mutable):** `Element` adalah objek yang lebih persisten dan dapat diubah (`mutable`). Mereka adalah perantara antara `Widget` (deskripsi) dan `RenderObject` (tampilan aktual). `Element tree` bertugas mengelola hierarki `Element` dan menentukan `RenderObject` mana yang perlu di-_update_. Ketika `Widget Tree` dibangun ulang, `Element Tree` akan membandingkan _widget_ baru dengan _element_ yang sudah ada untuk meminimalkan perubahan pada `RenderObject Tree`. Ini adalah kunci dari efisiensi _Hot Reload_ dan _rendering_ _Flutter_.
- **RenderObject Tree (Layout & Painting - Mutable):** `RenderObject` adalah objek yang bertanggung jawab untuk _layout_ (menentukan ukuran dan posisi) dan _painting_ (menggambar piksel) di layar. Mereka tidak peduli dengan detail konfigurasi _widget_; mereka hanya peduli tentang cara menggambar piksel ke layar. `RenderObject Tree` adalah representasi aktual dari UI Anda di layar, yang kemudian digambar oleh _Skia Engine_.

**Sintaks/Contoh Implementasi & Visualisasi:**

Mari kita visualisasikan hubungan antara ketiga _tree_ ini dengan diagram alir yang lebih komprehensif, sesuai permintaan Anda.

**Diagram Alir Konseptual: Flutter Rendering Pipeline (Tiga Tree)**

```
┌───────────────────────────┐      ┌──────────────────────────────┐      ┌───────────────────────────────┐
│        Widget Tree        │      │        Element Tree          │      │       RenderObject Tree       │
│ (Blueprint UI - Immutable)│      │(Manajemen Instansi - Mutable)│      │ (Layout & Painting - Mutable) │
└───────────┬───────────────┘      └───────────┬──────────────────┘      └───────────┬───────────────────┘
            │                                  ▼                                     │
            │                       [Akses melalui BuildContext]                     │
            │                                  │                                     │
┌───────────▼─────────┐            ┌───────────▼────────┐             ┌──────────────▼───────┐
│ Root Widget (MyApp) │            │ Root Element       │             │ Root RenderObject    │
│ (Konfigurasi Awal)  │            │  (Mengelola MyApp) │             │ (Mulai Layout/Paint) │
└───────────┬─────────┘            └───────────┬────────┘             └───────────┬──────────┘
            │                                  │                                  │
            │                                  │                                  │
            ▼                                  ▼                                  ▼
┌───────────────────────────┐      ┌───────────────────────┐          ┌───────────────────┐
│   Widget X (misal Column) │      │   Element X           │          │   RenderObject X  │
│    (Konfigurasi Layout)   │      │  (Mengelola Widget X) │          │  (Layout Column)  │
└───────────┬───────────────┘      └───────────┬───────────┘          └───────────┬───────┘
            │                                  │                                  │
┌───────────┴───────────┐          ┌───────────┴───────────┐          ┌───────────┴───────────┐
│ Widget A (misal Text) │          │ Element A             │          │ RenderObject A        │
│ (Konfigurasi Teks)    │          │ (Mengelola Widget A)  │          │ (Layout/Paint Teks)   │
└───────────┬───────────┘          └───────────────────────┘          └───────────────────────┘
            │
            ▼
┌────────────────────────────────────────────────────────────────────────────┐
│ Keterangan:                                                                │
│ - Widget Tree: Apa yang Anda tulis dalam kode Dart Anda.                   │
│ - Element Tree: Representasi internal Flutter yang efisien dalam mengelola │
│   instance widget dan membandingkan perubahan.                             │
│ - RenderObject Tree: Representasi abstrak dari layout dan painting yang    │
│   kemudian digambar oleh Skia Engine.                                      │
└────────────────────────────────────────────────────────────────────────────┘
```

**Alur Kerja Rendering Pipeline:**

```
┌────────────────────────────────┐
│ 1. Widget Tree (Deskripsi UI)  │
│    (Dibuat oleh Developer)     │
└────────────────┬───────────────┘
                 │
                 ▼
┌──────────────────────────────────┐
│ 2. Flutter Membangun/Memperbarui │
│    Element Tree                  │
│    (Mengelola instance widget,   │
│     membandingkan perubahan)     │
└────────────────┬─────────────────┘
                 │
                 ▼
┌──────────────────────────────────┐
│ 3. Element Tree Membangun/       │
│    Memperbarui RenderObject Tree │
│    (Menerjemahkan ke layout &    │
│     instruksi painting)          │
└────────────────┬─────────────────┘
                 │
                 ▼
┌────────────────────────────────┐
│ 4. RenderObject Tree Dilukis   │
│    oleh Skia Engine            │
│    (Menggambar piksel ke layar)│
└────────────────┬───────────────┘
                 │
                 ▼
┌────────────────────────────────┐
│ 5. UI Tampil di Layar          │
└────────────────────────────────┘
```

**Contoh Kode dan Hubungannya dengan Tree:**

Saat Anda menulis kode seperti ini:

```dart
// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Widget (Konfigurasi UI)
      home: Scaffold( // Widget (Konfigurasi UI)
        appBar: AppBar( // Widget (Konfigurasi UI)
          title: const Text('Hello'), // Widget (Konfigurasi UI)
        ),
        body: Center( // Widget (Konfigurasi UI)
          child: Container( // Widget (Konfigurasi UI)
            color: Colors.blue,
            padding: const EdgeInsets.all(10),
            child: const Text('World'), // Widget (Konfigurasi UI)
          ),
        ),
      ),
    );
  }
}
```

- **Widget Tree:** Setiap instansi `MaterialApp`, `Scaffold`, `AppBar`, `Text`, `Center`, `Container`, dan `Text` di atas adalah bagian dari `Widget Tree` yang Anda definisikan. Mereka adalah _blueprint_ yang tidak berubah.
- **Element Tree:** Ketika `runApp(const MyApp())` pertama kali dipanggil, _Flutter_ akan membuat `Element` untuk setiap _widget_ dalam `Widget Tree` Anda. `Element` ini akan tetap ada selama _widget_ yang diwakilinya masih berada di posisi yang sama dalam _tree_. Jika Anda mengubah warna `Container` dari `Colors.blue` menjadi `Colors.red`, _Flutter_ akan membuat _widget Container_ baru, tetapi `Element` yang sesuai mungkin hanya akan memperbarui referensinya ke _widget_ baru dan meminta _RenderObject_ untuk menggambar ulang. Ini menghindari pembangunan ulang seluruh _tree_ dari awal.
- **RenderObject Tree:** Setiap `Element` yang memerlukan _layout_ dan _painting_ akan membuat atau memperbarui `RenderObject` yang sesuai. Misalnya, `Container` akan memiliki `RenderObject` yang menangani ukuran, posisi, dan warna. `Text` akan memiliki `RenderObject` yang menangani _layout_ dan _painting_ teks. _RenderObject_ ini akan berkomunikasi dengan _Skia_ untuk menggambar piksel sebenarnya di layar.

**Terminologi Esensial:**

- **Widget Tree:** Representasi deklaratif dari UI Anda yang terdiri dari _widget-widget immutable_.
- **Element Tree:** Struktur internal _Flutter_ yang terdiri dari objek `Element` yang _mutable_, bertindak sebagai perantara antara `Widget` dan `RenderObject`. Ini adalah lokasi di mana _Flutter_ melakukan _diffing_ untuk efisiensi.
- **RenderObject Tree:** Representasi _layout_ dan _painting_ dari UI Anda, terdiri dari objek `RenderObject` yang _mutable_ dan berinteraksi langsung dengan _Skia Engine_.
- **Immutable:** Tidak dapat diubah setelah dibuat.
- **Mutable:** Dapat diubah setelah dibuat.
- **Diffing:** Proses membandingkan dua _tree_ (misalnya _widget tree_ lama dan baru) untuk menemukan perbedaan minimal yang perlu diperbarui.

**Struktur Internal (Mini-DAFTAR ISI):**

- Widget Tree (Ulang Kaji dan Detail)
- Element Tree (Peran dan Interaksi)
- RenderObject Tree (Fungsi Layout dan Painting)
- Hubungan dan Alur Kerja Antar Ketiga Tree

**Hubungan dengan Bagian Lain:**
Pemahaman ketiga _tree_ ini adalah inti dari bagaimana _Flutter_ mencapai performa tinggi dan _Hot Reload_ yang cepat. Ini akan sangat relevan ketika kita membahas:

- **Widget Lifecycle Management:** Karena _lifecycle_ _widget_ (khususnya `StatefulWidget`) melibatkan bagaimana _element_ dan _render object_ dibuat, diperbarui, dan dibuang.
- **Performance & Optimization:** Mengoptimalkan aplikasi Anda seringkali berarti memahami bagaimana perubahan pada _widget tree_ memengaruhi _element_ dan _render object tree_ untuk meminimalkan _rendering_ yang tidak perlu.
- **Widget Keys:** `Keys` digunakan untuk secara eksplisit membantu _Flutter_ dalam mencocokkan _widget_ di _widget tree_ lama dan baru dengan _element_ yang sudah ada, sehingga menjaga _state_ dan identitas objek di _element tree_ dan _render object tree_.

**Referensi Lengkap:**

- [Flutter Widget Framework](https://flutter.dev/docs/development/ui/widgets-intro): Dokumentasi resmi yang memberikan gambaran tentang framework _widget_.
- [Widget Tree vs Element Tree](https://medium.com/flutter-community/flutter-widget-tree-element-tree-and-renderobject-tree-4e8b0c3f3f3c): Artikel yang menjelaskan perbedaan antara ketiga _tree_ secara mendalam.
- [Understanding BuildContext](https://medium.com/flutter-community/understanding-buildcontext-in-flutter-c8c72c7b9c7c): Artikel yang membahas peran `BuildContext` yang terikat pada _element_.

**Tips & Best Practices:**

- **Pikirkan secara Berlapis:** Selalu ingat bahwa ada tiga lapisan abstrak di bawah UI Anda: _Widget_, _Element_, dan _RenderObject_. Ini membantu dalam _debugging_ dan memahami mengapa sesuatu terlihat atau berperilaku seperti itu.
- **Efisiensi Update:** Pahami bahwa _Flutter_ cerdas dalam memperbarui UI. Ia tidak membangun ulang seluruh _tree_ setiap kali. Ini adalah kekuatan di balik `Element Tree`.
- **Gunakan `const` untuk Widget Statis:** Ini sangat membantu _Flutter_ mengoptimalkan proses _diffing_ karena _widget_ tersebut dianggap tidak akan pernah berubah, sehingga _element_ dan _render object_ terkait juga tidak perlu di-_update_ jika tidak ada perubahan _state_ di atasnya.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menganggap `Widget` adalah objek yang digambar ke layar.
  - **Solusi:** Ingat, `Widget` hanyalah deskripsi. `RenderObject` adalah yang melakukan _layout_ dan _painting_ sebenarnya, dengan `Element` sebagai perantara.
- **Kesalahan:** Tidak memahami mengapa `setState()` hanya bekerja pada `StatefulWidget` dan memicu pembangunan ulang.
  - **Solusi:** `setState()` memberitahu _Flutter_ untuk menandai `Element` terkait sebagai "kotor" (`dirty`), yang kemudian akan memicu pemanggilan `build()` dari _widget_ yang terkait dengan `Element` tersebut dan membandingkan _widget_ yang baru dengan yang lama untuk memperbarui _RenderObject Tree_.

---

Setelah kita memahami perbedaan dan interaksi antara _Widget Tree_, _Element Tree_, dan _RenderObject Tree_, kini saatnya kita menyoroti bagaimana siklus hidup (_lifecycle_) sebuah _widget_, terutama _StatefulWidget_, dikelola oleh _Flutter_. Memahami _lifecycle_ ini sangat penting untuk mengelola _state_, mengoptimalkan performa, dan mencegah _memory leak_ dalam aplikasi Anda.

---

### **2.1 Widget Tree & Rendering Engine (Lanjutan)**

#### **Widget Lifecycle Management**

**Deskripsi Detail & Peran:**
`Widget Lifecycle Management` berfokus pada serangkaian metode yang dipanggil oleh _Flutter framework_ pada _StatefulWidget_ selama masa hidupnya. Setiap metode memiliki peran spesifik, mulai dari pembuatan _state_, inisialisasi, pembaruan, hingga pembuangan _widget_. Memahami urutan dan tujuan metode-metode ini memungkinkan Anda untuk:

- Melakukan inisialisasi data.
- Mengelola _resource_ eksternal (seperti _stream_, _timer_, atau _controller_).
- Bereaksi terhadap perubahan konfigurasi _widget_ atau dependensi.
- Membersihkan _resource_ saat _widget_ tidak lagi digunakan.

**Konsep Kunci & Filosofi:**
Filosofi di sini adalah **manajemen _state_ yang terstruktur** dan **pembersihan _resource_ yang tepat waktu**. _Flutter_ menyediakan _hook_ ini agar Anda dapat menyisipkan logika kustom pada berbagai tahapan siklus hidup _widget_, memastikan aplikasi efisien dan stabil.

Berikut adalah metode-metode utama dalam _lifecycle_ _StatefulWidget_ secara berurutan dan penjelasannya:

1.  **`createState()` method:**

    - **Peran:** Ini adalah metode pertama yang dipanggil ketika _Flutter_ memutuskan untuk membangun `StatefulWidget` untuk pertama kalinya. Tugasnya adalah mengembalikan instance `State` yang terkait dengan `StatefulWidget` ini. `State` inilah yang akan menyimpan _mutable state_ untuk _widget_ tersebut.
    - **Kapan Dipanggil:** Hanya sekali, saat _widget_ pertama kali dimasukkan ke dalam _Widget Tree_.

2.  **`initState()` dan `dispose()`:**

    - **`initState()`:**

      - **Peran:** Dipanggil sekali setelah `State` objek dibuat dan dimasukkan ke dalam _Element Tree_. Ini adalah tempat yang ideal untuk melakukan inisialisasi satu kali yang bergantung pada `BuildContext` atau properti _widget_. Ini juga tempat yang umum untuk:
        - Melakukan inisialisasi _controller_ (misalnya `TextEditingController`, `ScrollController`).
        - Mendaftarkan _listener_ ke _stream_ atau `ChangeNotifier`.
        - Mengambil data awal dari _API_ atau _database_.
      - **Kapan Dipanggil:** Hanya sekali seumur hidup `State` objek.
      - **Catatan Penting:** Anda tidak dapat memanggil `setState()` di `initState()` (kecuali dalam _callback_ yang dijadwalkan, misalnya `WidgetsBinding.instance.addPostFrameCallback`), karena _widget_ belum sepenuhnya diinisialisasi.

    - **`dispose()`:**

      - **Peran:** Dipanggil ketika `State` objek secara permanen dihapus dari _Widget Tree_. Ini adalah tempat yang sangat krusial untuk membersihkan _resource_ apa pun yang telah Anda inisialisasi di `initState()` atau di tempat lain untuk mencegah _memory leak_. Contoh:
        - Membuang (_dispose_) _controller_.
        - Membatalkan (_unsubscribe_) _listener_.
        - Menutup _stream_.
      - **Kapan Dipanggil:** Tepat sebelum _state_ dibuang.

3.  **`build()` method optimization:**

    - **Peran:** Ini adalah metode yang paling sering dipanggil di _lifecycle_ _widget_. Tugasnya adalah mengembalikan _widget tree_ yang mendeskripsikan tampilan UI _widget_ pada _state_ saat ini.
    - **Kapan Dipanggil:**
      - Setelah `initState()`.
      - Setelah `didChangeDependencies()`.
      - Setelah `didUpdateWidget()`.
      - Setelah `setState()` dipanggil.
      - Setelah `deactivate()` (jika _widget_ diaktifkan kembali).
      - Setelah `reassemble()` (hanya saat _Hot Reload_).
      - Ketika _parent widget_ membangun ulang _child_-nya.
    - **Optimasi:** Karena sering dipanggil, penting untuk menjaga agar logika dalam `build()` seringan mungkin. Hindari operasi komputasi berat di sini. Fokuskan hanya pada deskripsi UI.

4.  **`setState()` best practices:**

    - **Peran:** Metode ini digunakan untuk memberi tahu _Flutter framework_ bahwa _state_ internal dari `State` objek telah berubah dan UI perlu dibangun ulang untuk merefleksikan perubahan tersebut.
    - **Kapan Dipanggil:** Kapan pun _state_ yang memengaruhi UI berubah.
    - **Best Practices:**
      - Selalu panggil `setState()` di dalam _callback_ asinkron atau di dalam blok `setState(() { ... });` itu sendiri.
      - Pastikan perubahan _state_ yang Anda lakukan di dalam `setState()` benar-benar memengaruhi properti yang digunakan dalam `build()` method.
      - Jangan memanggil `setState()` jika _widget_ tidak lagi berada di _tree_ (misalnya setelah `dispose()` dipanggil), hal ini akan menyebabkan _error_.
      - Batasi area yang di-_update_: _Flutter_ sangat efisien, tetapi pemanggilan `setState()` pada _widget_ yang sangat tinggi di _tree_ bisa memicu pembangunan ulang yang lebih luas. Usahakan untuk memanggil `setState()` di _widget_ serendah mungkin di _tree_ yang membutuhkan pembaruan.

5.  **`didUpdateWidget()` usage:**

    - **Peran:** Dipanggil ketika _parent widget_ membangun ulang _child_ `StatefulWidget` ini dengan _widget_ baru yang memiliki `runtimeType` dan `key` yang sama dengan _widget_ sebelumnya. Ini memberi Anda kesempatan untuk bereaksi terhadap perubahan pada properti _widget_ yang baru.
    - **Kapan Dipanggil:** Setelah `build()` dipanggil oleh _parent_ dan sebelum `build()` milik _child_ dipanggil.
    - **Penggunaan:** Sering digunakan untuk memperbarui _state_ internal berdasarkan properti baru yang diterima dari _parent_. Anda dapat membandingkan `widget.oldWidget.someProperty` dengan `widget.newWidget.someProperty` untuk mendeteksi perubahan.

6.  **`didChangeDependencies()` timing:**

    - **Peran:** Dipanggil setelah `initState()` dan setiap kali dependensi `State` objek berubah. Dependensi meliputi:
      - Perubahan tema (`Theme.of(context)`).
      - Perubahan ukuran media (`MediaQuery.of(context)`).
      - Perubahan `InheritedWidget` yang diandalkan oleh _widget_ ini.
    - **Kapan Dipanggil:**
      - Setelah `initState()`.
      - Ketika `InheritedWidget` yang digunakan oleh _widget_ ini diperbarui.
    - **Penggunaan:** Ideal untuk mengambil data atau melakukan inisialisasi yang bergantung pada dependensi dari `BuildContext` (misalnya, mengakses _provider_ melalui `Provider.of(context)` tanpa `listen: false`).

7.  **`deactivate()` dan `reassemble()`:**

    - **`deactivate()`:**
      - **Peran:** Dipanggil ketika _State_ untuk sementara waktu dihapus dari _tree_ (misalnya, saat _widget_ digulir keluar dari pandangan dalam `ListView`, atau saat tab aplikasi beralih). _Flutter_ mungkin akan memasukkannya kembali ke dalam _tree_ di kemudian hari.
      - **Kapan Dipanggil:** Ketika `Element` yang terkait dengan _state_ ini dipindahkan dari satu lokasi di _tree_ ke lokasi lain, atau dihapus sementara. Ini terjadi sebelum `dispose()` jika _state_ benar-benar akan dibuang.
    - **`reassemble()`:**
      - **Peran:** Metode ini khusus untuk pengembangan. Ini dipanggil setiap kali Anda melakukan _Hot Reload_. Tujuannya adalah untuk memungkinkan _widget_ membangun ulang _state_ internalnya setelah kode diubah, tanpa perlu memulai ulang aplikasi sepenuhnya.
      - **Kapan Dipanggil:** Hanya dalam mode _debug_ saat _Hot Reload_ terjadi.

**Diagram Alir Siklus Hidup StatefulWidget (Penyederhanaan):**

```
┌────────────────────────────────┐
│         Constructor            │
│   (StatefulWidget Dibuat)      │
└────────────────┬───────────────┘
                 │
                 ▼
┌────────────────────────────────┐
│          createState()         │
│   (Objek State Dibuat)         │
└────────────────┬───────────────┘
                 │
                 ▼
┌────────────────────────────────┐
│          initState()           │
│   (Inisialisasi Awal State)    │
└────────────────┬───────────────┘
                 │
                 ▼ (Jika ada perubahan dependensi)
┌────────────────────────────────┐
│     didChangeDependencies()    │
│  (Dependensi Context Berubah)  │
└────────────────┬───────────────┘
                 │
                 ▼
┌────────────────────────────────┐
│           build()              │
│    (Membangun UI Widget)       │
└────────────────┬───────────────┘
                 │
                 ▼ (Jika state berubah via setState())
┌────────────────────────────────┐
│          setState()            │
│    (Memperbarui State &        │
│     Meminta Pembangunan Ulang) │
└────────────────┬───────────────┘
                 │
                 ▼ (Kembali ke build())
┌────────────────────────────────┐
│       didUpdateWidget()        │
│   (Konfigurasi Widget Baru     │
│    dari Parent)                │
└────────────────┬───────────────┘
                 │
                 ▼ (Jika dihapus sementara/dipindahkan)
┌────────────────────────────────┐
│          deactivate()          │
│ (Dihapus Sementara dari Tree)  │
└────────────────┬───────────────┘
                 │
                 ▼ (Jika diaktifkan kembali, kembali ke build())
                 │ (Jika dihapus permanen)
┌────────────────────────────────┐
│           dispose()            │
│    (Pembersihan Resource)      │
└────────────────┬───────────────┘
                 │
                 ▼
┌────────────────────────────────┐
│       Widget Dibuang           │
└────────────────────────────────┘

┌────────────────────────────────┐
│ *Catatan: reassemble() hanya   │
│          dipanggil saat        │
│          Hot Reload.           │
└────────────────────────────────┘
```

**Contoh Kode: Mengimplementasikan Metode Lifecycle**

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
          title: const Text('Widget Lifecycle Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const LifecycleCounter(), // Widget yang akan menunjukkan lifecycle
              ElevatedButton(
                onPressed: () {
                  // Contoh untuk memicu perubahan di parent, yang akan memicu didUpdateWidget
                  // di child jika ada properti yang diubah.
                  // Untuk demo ini, kita akan fokus pada lifecycle internal.
                  print('Tombol di luar LifecycleCounter ditekan');
                },
                child: const Text('Tombol Luar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LifecycleCounter extends StatefulWidget {
  const LifecycleCounter({super.key});

  @override
  State<LifecycleCounter> createState() {
    print('1. createState() dipanggil');
    return _LifecycleCounterState();
  }
}

class _LifecycleCounterState extends State<LifecycleCounter> {
  int _counter = 0;

  @override
  void initState() {
    super.initState(); // Selalu panggil super.initState()
    print('2. initState() dipanggil. Counter diinisialisasi: $_counter');
    // Contoh: Fetch data awal, setup listener
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies(); // Selalu panggil super.didChangeDependencies()
    print('3. didChangeDependencies() dipanggil.');
    // Contoh: Akses InheritedWidget, Theme.of(context), MediaQuery.of(context)
  }

  @override
  void didUpdateWidget(covariant LifecycleCounter oldWidget) {
    super.didUpdateWidget(oldWidget); // Selalu panggil super.didUpdateWidget()
    print('4. didUpdateWidget() dipanggil. Widget lama: $oldWidget');
    // Contoh: Bereaksi terhadap perubahan properti dari parent
    // if (widget.someNewProperty != oldWidget.someNewProperty) { ... }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      print('5. setState() dipanggil. Counter menjadi: $_counter');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('6. build() dipanggil. Membangun UI untuk counter: $_counter');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Counter: $_counter',
          style: const TextStyle(fontSize: 40),
        ),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Text('Tambah Counter'),
        ),
      ],
    );
  }

  @override
  void deactivate() {
    super.deactivate(); // Selalu panggil super.deactivate()
    print('7. deactivate() dipanggil.');
    // Contoh: Widget mungkin dihapus sementara dari tree (misalnya gulir keluar layar)
  }

  @override
  void dispose() {
    super.dispose(); // Selalu panggil super.dispose()
    print('8. dispose() dipanggil. Membersihkan resource.');
    // Contoh: Buang controller, batalkan listener
  }

  @override
  void reassemble() {
    super.reassemble(); // Selalu panggil super.reassemble()
    print('9. reassemble() dipanggil (Hot Reload).');
    // Hanya dipanggil saat Hot Reload
  }
}
```

**Terminologi Esensial:**

- **Lifecycle Method:** Metode-metode yang dipanggil secara otomatis oleh _Flutter_ pada berbagai tahapan eksistensi sebuah _StatefulWidget_.
- **State:** Data _mutable_ yang dipegang oleh `StatefulWidget` dan dapat memengaruhi tampilan UI-nya.
- **Hot Reload:** Fitur _Flutter_ yang memungkinkan Anda melihat perubahan kode langsung di aplikasi tanpa kehilangan _state_ saat ini.
- **Memory Leak:** Situasi di mana program komputer gagal mengelola memori yang dialokasikan, sehingga menyebabkan peningkatan penggunaan memori yang tidak diperlukan dan, pada akhirnya, melambatnya atau _crash_ aplikasi.

**Struktur Internal (Mini-DAFTAR ISI):**

- Urutan dan Tujuan Metode Lifecycle
- `createState()`: Inisialisasi State
- `initState()` dan `dispose()`: Pasangan Krusial
- `build()`: Jantung UI
- `setState()`: Memicu Pembaruan UI
- `didUpdateWidget()`: Reaksi terhadap Perubahan Konfigurasi
- `didChangeDependencies()`: Reaksi terhadap Perubahan Dependensi
- `deactivate()` dan `reassemble()`: Penanganan Khusus

**Hubungan dengan Bagian Lain:**

- **Widget Keys:** Memahami `keys` membantu _Flutter_ untuk mencocokkan _widget_ lama dengan _element_ dan _state_ yang sesuai, sehingga mempengaruhi bagaimana metode _lifecycle_ seperti `didUpdateWidget()` dan `deactivate()`/`dispose()` dipanggil.
- **State Management:** Metode _lifecycle_ adalah fondasi untuk mengimplementasikan _state management_ yang benar dalam aplikasi Anda, memastikan _resource_ dialokasikan dan dibersihkan dengan tepat.
- **Performance Optimization:** Mengoptimalkan penggunaan `build()` dan memahami kapan _widget_ dibangun ulang adalah kunci untuk performa aplikasi yang halus.

**Referensi Lengkap:**

- [Stateful Widget Lifecycle](https://flutter.dev/docs/development/ui/interactive): Dokumentasi resmi _Flutter_ tentang _lifecycle_ _StatefulWidget_.
- [Widget Lifecycle Deep Dive](https://medium.com/flutter-community/flutter-widget-lifecycle-in-depth-7b8c3c9f7b7b): Artikel yang sangat mendalam tentang _lifecycle_ _widget_.
- [Widget Keys Explained](https://medium.com/flutter/keys-what-are-they-good-for-13cb51742e7d): Menjelaskan bagaimana `keys` berhubungan dengan _lifecycle_ dan _widget tree_.

**Tips & Best Practices (untuk peserta):**

- **Selalu Panggil `super`:** Pastikan Anda selalu memanggil implementasi `super` dari metode _lifecycle_ yang Anda _override_ (`super.initState()`, `super.dispose()`, dll.).
- **Hati-hati dengan `setState()`:** Jangan panggil `setState()` di `initState()`. Jika perlu, gunakan `WidgetsBinding.instance.addPostFrameCallback(() => setState(() { ... }));`.
- **Bersihkan di `dispose()`:** Ini adalah _best practice_ terpenting untuk mencegah _memory leak_. Setiap _listener_, _controller_, atau _timer_ yang diinisialisasi di `initState()` (atau di tempat lain) harus dibuang di `dispose()`.
- **Optimalkan `build()`:** Pertahankan `build()` method sebersih mungkin dari logika bisnis atau operasi berat.
- **Pahami `didUpdateWidget()` vs `didChangeDependencies()`:** Keduanya bereaksi terhadap perubahan, tetapi `didUpdateWidget()` bereaksi terhadap perubahan properti dari _parent_, sedangkan `didChangeDependencies()` bereaksi terhadap perubahan _inherited widgets_ atau dependensi konteks lainnya.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Lupa memanggil `dispose()` pada _controller_ atau _listener_, menyebabkan _memory leak_.
  - **Solusi:** Selalu pasangkan inisialisasi di `initState()` dengan pembersihan di `dispose()`.
- **Kesalahan:** Memanggil `setState()` setelah _widget_ dibuang (`setState() called on a dismounted element`).
  - **Solusi:** Periksa `mounted` properti (`if (mounted) { setState(() { ... }); }`) sebelum memanggil `setState()` dalam _callback_ asinkron.
- **Kesalahan:** Melakukan operasi _network_ yang berat di `build()` method.
  - **Solusi:** Pindahkan operasi _network_ atau komputasi berat ke `initState()` atau ke lapisan _business logic_ yang terpisah, lalu perbarui _state_ dan panggil `setState()` setelah operasi selesai.

---

### **Luar biasa dan Selamat!**

Anda telah berhasil menuntaskan pembahasan mendalam mengenai **Widget Lifecycle Management** di _Flutter_. Ini adalah salah satu aspek krusial untuk membangun aplikasi yang stabil, efisien, dan bebas _bug_. Dengan pemahaman ini, Anda tidak hanya tahu _bagaimana_ UI Anda dibangun, tetapi juga _kapan_ dan _mengapa_ _Flutter_ melakukan berbagai operasi di balik layar. Anda juga telah menyelami **Pengenalan Widget: Building Blocks UI** dengan detail yang komprehensif, termasuk visualisasi penting dari _Widget Tree_. Memahami _widget_, perbedaannya, dan bagaimana mereka bersarang, adalah langkah pertama yang paling fundamental dalam perjalanan Anda sebagai pengembang _Flutter_. Ini adalah dasar dari segalanya! dan ini sangat Luar biasa! karena Anda kini memiliki pemahaman yang jauh lebih dalam tentang **Widget Tree Fundamentals**, termasuk peran krusial dari _Element Tree_ dan _RenderObject Tree_ dalam _rendering pipeline_ _Flutter_. Ini adalah jantung bagaimana _Flutter_ bekerja secara efisien. Dengan pemahaman ini, Anda semakin menguasai pondasi arsitektur UI _Flutter_.

---

Selanjutnya kita akan masuk pada sub-bagian berikutnya, yaitu **2.2 Tipe-tipe Widget Utama**. Di sini, Anda akan mulai mengenal berbagai _widget_ yang paling sering digunakan dalam membangun antarmuka pengguna di _Flutter_. Memahami tipe-tipe _widget_ ini adalah kunci untuk merancang _layout_ yang efektif, menampilkan konten, dan menambahkan interaktivitas ke aplikasi Anda.

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
│ (Menampilkan)   │       │  (Menampilkan ikon)      │
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
┌───────────────────────────────────┐
│ (Mengatur widget secara vertikal) │
│       Column (Layout Widget)      │
└────────────┬──────────────────────┘
 ┌───────────┴──────────────┐
 ▼                          ▼
┌─────────────────┐   ┌────────────────────────┐
│ Text (Material) │   │    WidgetKompleks      │
│ (Menampilkan)   │─┬─│  (Widget kompleks yang │
│ teks)           │ │ │  terdiri dari widget   │
└─────────────────┘ │ │  lainnya)              │
                    │ └────────────────────────┘
            ┌───────▼───────────────┐
            ▼                       ▼
         ┌──────────────────────────────────────────┐
         │        Container (Layout Widget)         │
         │ (Pembungkus dengan padding dan dekorasi) │
         └───────────┬──────────────────────────────┘
                     │
                     ▼
         ┌─────────────────────────────────────┐
         │        Row (Layout Widget)          │
         │ (Mengatur widget secara horizontal) │
         └───────────────────────┬─────────────┘
            ┌────────────────────┴────┐
            ▼                         ▼
┌─────────────────┐       ┌───────────────────┐
│  Column (Layout)│       │  Column (Layout)  │
│  (Mengatur)     │       │  (Mengatur        │
│  widget         │       │  widget           │
│  vertikal)      │       │  vertikal)        │
└────────┬────────┘       └──────────┬────────┘
         │                           │
         ▼                           ▼
┌─────────────────┐       ┌───────────────────┐
│  Icon (Material)│       │  Icon (Material)  │
│  (Menampilkan)  │       │  (Menampilkan     │
│  ikon)          │       │  ikon)            │
└────────┬────────┘       └──────────┬────────┘
         │                           │
         ▼                           ▼
┌─────────────────┐       ┌───────────────────┐
│  Text (Material)│       │  Text (Material)  │
│  (Menampilkan)  │       │  (Menampilkan     │
│  teks)          │       │  teks)            │
└─────────────────┘       └───────────────────┘
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

---

Setelah menyelami arsitektur _widget_ dan siklus hidupnya, kini kita akan fokus pada bagaimana menata (_layout_) _widget-widget_ tersebut di layar dengan presisi dan fleksibilitas. Ini adalah dasar untuk menciptakan antarmuka pengguna yang visualnya menarik dan fungsional.

---

### **2.2 Layout System Mastery(lanjutan)**

#### **Core Layout Widgets**

**Deskripsi Detail & Peran:**
Sub-bagian ini akan membahas _widget-widget_ fundamental yang digunakan untuk mengatur posisi, ukuran, dan hubungan antar _widget_ di dalam UI Anda. Menguasai _core layout widgets_ adalah esensial, karena merekalah yang membentuk struktur visual setiap aplikasi _Flutter_. _Widget-widget_ ini dirancang untuk bekerja secara komposisi, memungkinkan Anda untuk membangun _layout_ yang kompleks dari komponen-komponen yang lebih kecil dan sederhana.

**Konsep Kunci & Filosofi:**
Filosofi di balik sistem _layout_ _Flutter_ adalah **constraint-based layout** dan **declarative UI**. Setiap _widget_ memberikan _constraint_ kepada _child_-nya, dan _child_ tersebut kemudian menentukan ukurannya sendiri dalam _constraint_ tersebut, lalu _parent_ memposisikannya. Ini membuat _layout_ sangat fleksibel dan prediktabel.

Berikut adalah _core layout widgets_ yang akan kita bahas secara mendetail:

1.  **`Container` (padding, margin, decoration):**

    - **Peran:** `Container` adalah _widget_ serbaguna yang dapat digunakan untuk menggambar, memposisikan, dan memberi gaya pada _widget_ lain. Ini seperti kotak di mana Anda dapat mengatur berbagai properti untuk memengaruhi tampilan dan _layout child_-nya.
    - **Properti Kunci:**
      - `child`: _Widget_ yang akan ditempatkan di dalam `Container`.
      - `padding`: Ruang kosong di dalam `Container`, antara _border_ dan `child`.
      - `margin`: Ruang kosong di luar `Container`, antara _border_ dan _widget_ lain di sekitarnya.
      - `color`: Warna latar belakang `Container`.
      - `decoration`: Dekorasi visual yang lebih kompleks (misalnya _border_, _box shadow_, _gradient_, _shape_, _image_). Jika `decoration` digunakan, properti `color` harus berada di dalam `decoration` (misalnya `BoxDecoration(color: Colors.blue)`).
      - `width`, `height`: Ukuran eksplisit `Container`. Jika tidak ditentukan, `Container` akan mencoba mengisi _constraint_ _parent_-nya (jika memiliki _child_) atau mengecil sekecil mungkin (jika tanpa _child_).
      - `alignment`: Menentukan bagaimana `child` diposisikan di dalam `Container`.
      - `transform`: Menerapkan transformasi 3D ke `Container`.
    - **Filosofi:** `Container` adalah _widget_ pembungkus yang dapat mengimplementasikan beberapa efek _layout_ dan gaya sekaligus, menjadikannya pilihan pertama untuk banyak kebutuhan dasar.

2.  **`Row`, `Column`, dan `Flex` properties:**

    - **Peran:** `Row` dan `Column` adalah _widget_ _layout_ dasar untuk menempatkan beberapa _child widget_ secara linear: `Row` mengatur mereka secara horizontal, sedangkan `Column` mengatur mereka secara vertikal. `Flex` adalah _widget_ dasar yang mendasari `Row` dan `Column`, menyediakan kontrol yang lebih granular atas bagaimana _child_ menggunakan ruang.
    - **Properti Kunci (untuk `Row` dan `Column`):**
      - `children`: Daftar _widget_ yang akan diatur.
      - `mainAxisAlignment`: Menentukan bagaimana _child_ ditempatkan sepanjang sumbu utama (`main axis`). Untuk `Row`, sumbu utama adalah horizontal; untuk `Column`, itu vertikal. Nilai-nilai umum: `start`, `end`, `center`, `spaceBetween`, `spaceAround`, `spaceEvenly`.
      - `crossAxisAlignment`: Menentukan bagaimana _child_ ditempatkan sepanjang sumbu silang (`cross axis`). Untuk `Row`, sumbu silang adalah vertikal; untuk `Column`, itu horizontal. Nilai-nilai umum: `start`, `end`, `center`, `stretch`, `baseline`.
      - `mainAxisSize`: Menentukan seberapa banyak ruang yang harus diambil oleh _parent_ di sepanjang sumbu utama.
        - `MainAxisSize.max`: Mengambil ruang sebanyak mungkin.
        - `MainAxisSize.min`: Mengambil ruang sesedikit mungkin yang dibutuhkan oleh _child_-nya.
      - `textDirection` (untuk `Row`): Menentukan arah horizontal teks, yang juga memengaruhi arah `mainAxisAlignment.start`/`end`.
      - `verticalDirection` (untuk `Column`): Menentukan arah vertikal _layout_.
    - **Filosofi:** Konsep "sumbu utama" dan "sumbu silang" adalah fundamental dalam _Flutter layout_. Memahaminya sangat penting untuk memposisikan _widget_ secara akurat dalam `Row` dan `Column`.

3.  **`Stack` dan `Positioned` widgets:**

    - **Peran:** `Stack` adalah _widget_ yang memungkinkan Anda untuk menumpuk _widget-widget_ di atas satu sama lain, seperti lapisan-lapisan dalam tumpukan kartu. Ini berguna untuk melapisi elemen UI (misalnya, _overlay_, _badge_, atau tombol di atas gambar). `Positioned` adalah _widget_ yang hanya dapat digunakan sebagai _child_ dari `Stack` untuk mengontrol posisi _child_ secara tepat dalam `Stack`.
    - **Properti Kunci (`Stack`):**
      - `children`: Daftar _widget_ yang akan ditumpuk. _Widget_ yang terakhir dalam daftar akan berada di paling atas.
      - `alignment`: Menentukan bagaimana _child_ yang tidak di-_positioned_ (yaitu, tidak dibungkus oleh `Positioned`) akan ditempatkan dalam `Stack`.
      - `fit`: Menentukan bagaimana _child_ yang tidak di-_positioned_ harus mengisi ruang `Stack`.
    - **Properti Kunci (`Positioned`):**
      - `left`, `top`, `right`, `bottom`: Jarak dari tepi `Stack`.
      - `width`, `height`: Ukuran eksplisit _child_ yang di-_positioned_.
    - **Filosofi:** `Stack` sangat kuat untuk _overlays_ dan _layout_ yang melibatkan tumpang tindih elemen. `Positioned` memberikan kontrol absolut dalam ruang yang disediakan oleh `Stack`.

4.  **`Expanded` vs `Flexible` differences:**

    - **Peran:** Keduanya adalah _widget_ yang hanya dapat digunakan sebagai _child_ dari `Row`, `Column`, atau `Flex`. Mereka digunakan untuk mengalokasikan ruang di sepanjang sumbu utama kepada _child_-nya.
    - **`Expanded`:**
      - Memaksa _child_ untuk mengisi semua ruang kosong yang tersedia di sepanjang sumbu utama.
      - `flex` properti: Menentukan rasio ruang yang harus diambil oleh _child_ ini relatif terhadap _child Expanded_ atau _Flexible_ lainnya.
    - **`Flexible`:**
      - Memberi _child_ fleksibilitas untuk mengisi ruang yang tersedia, tetapi tidak memaksanya untuk mengisi semua ruang.
      - `flex` properti: Sama seperti `Expanded`.
      - `fit` properti:
        - `FlexFit.tight`: Mirip dengan `Expanded` (memaksa _child_ untuk mengisi ruang).
        - `FlexFit.loose`: Memungkinkan _child_ untuk mengambil ruang sesedikit mungkin hingga _max constraint_ yang diberikan oleh `Flexible`.
    - **Filosofi:** Keduanya penting untuk _layout_ responsif di dalam `Row` atau `Column`, memungkinkan _child_ untuk beradaptasi dengan ruang yang tersedia. `Expanded` lebih agresif dalam mengambil ruang.

5.  **`Wrap` widget untuk responsive layouts:**

    - **Peran:** `Wrap` adalah _widget_ _layout_ yang mirip dengan `Row` atau `Column`, tetapi dengan satu perbedaan utama: jika ada terlalu banyak _child_ untuk muat di satu baris/kolom, _child_ tersebut akan "membungkus" ke baris/kolom berikutnya. Ini sangat berguna untuk _layout_ yang responsif seperti daftar _chip_ atau tag.
    - **Properti Kunci:**
      - `direction`: Arah sumbu utama (`Axis.horizontal` atau `Axis.vertical`).
      - `alignment`: Bagaimana _children_ ditempatkan sepanjang sumbu utama.
      - `spacing`: Jarak antar _children_ di sepanjang sumbu utama.
      - `runAlignment`: Bagaimana "jalur" (_run_) baru ditempatkan di sepanjang sumbu silang.
      - `runSpacing`: Jarak antar jalur baru di sepanjang sumbu silang.
    - **Filosofi:** Solusi elegan untuk _layout_ yang perlu beradaptasi secara dinamis dengan ruang yang tersedia, tanpa perlu logika _media query_ yang rumit.

6.  **`SizedBox` dan `Spacer` utilities:**

    - **Peran:** Ini adalah _widget_ sederhana namun sangat efektif untuk mengontrol ruang dalam _layout_.
    - **`SizedBox`:**
      - **Peran:** Membuat kotak dengan ukuran tetap. Dapat digunakan untuk menambahkan ruang kosong spesifik (`width` dan `height`) atau untuk memaksa _child_ memiliki ukuran tertentu.
      - **Penggunaan:** `SizedBox(width: 10)`, `SizedBox(height: 20)`, atau `SizedBox.expand()` untuk mengisi semua ruang yang tersedia.
    - **`Spacer`:**
      - **Peran:** Hanya dapat digunakan sebagai _child_ dari `Row`, `Column`, atau `Flex`. `Spacer` mengambil semua ruang kosong yang tersisa di sepanjang sumbu utama.
      - **Penggunaan:** Sangat berguna untuk mendorong _widget_ ke ujung `Row` atau `Column` atau untuk mendistribusikan ruang secara merata. Memiliki properti `flex` seperti `Expanded`.
    - **Filosofi:** Memberikan kontrol yang tepat atas _spacing_ dan dimensi, seringkali lebih bersih daripada menggunakan `Padding` atau `Container` hanya untuk tujuan _spacing_.

**Sintaks/Contoh Implementasi & Visualisasi:**

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
          title: const Text('Core Layout Widgets Demo'),
        ),
        body: SingleChildScrollView( // Agar bisa di-scroll jika kontennya panjang
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('1. Container (Padding, Margin, Decoration)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
                    ],
                  ),
                  child: const Text(
                    'Ini adalah Container dengan margin, padding, dan decoration.',
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(),

                const Text('2. Row, Column, dan Flex properties', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                // Contoh Row
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(color: Colors.red, width: 50, height: 50),
                      Container(color: Colors.green, width: 50, height: 50),
                      Container(color: Colors.blue, width: 50, height: 50),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Contoh Column
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Penting untuk Column yang tidak mengisi semua ruang
                    children: <Widget>[
                      Container(color: Colors.orange, width: 50, height: 50),
                      Container(color: Colors.purple, width: 50, height: 50),
                      Container(color: Colors.brown, width: 50, height: 50),
                    ],
                  ),
                ),
                const Divider(),

                const Text('3. Stack dan Positioned', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center, // Untuk child yang tidak di-positioned
                    children: <Widget>[
                      Container(color: Colors.yellow, width: 200, height: 100),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(color: Colors.black, width: 50, height: 50),
                      ),
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        child: Text(
                          'Teks di Bawah Kiri',
                          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                const Text('4. Expanded vs Flexible', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  color: Colors.grey[300],
                  height: 100,
                  child: Row(
                    children: <Widget>[
                      Container(color: Colors.cyan, width: 50, height: 80),
                      Expanded(
                        flex: 2, // Mengambil 2 bagian dari total fleksibilitas
                        child: Container(color: Colors.pink, height: 80, child: const Center(child: Text('Expanded (2)'))),
                      ),
                      Flexible(
                        flex: 1, // Mengambil 1 bagian
                        fit: FlexFit.loose, // Mengambil ruang sesedikit mungkin
                        child: Container(color: Colors.lime, height: 80, child: const Center(child: Text('Flexible Loose (1)'))),
                      ),
                      Flexible(
                        flex: 1, // Mengambil 1 bagian
                        fit: FlexFit.tight, // Mengambil ruang sebanyak mungkin
                        child: Container(color: Colors.deepOrange, height: 80, child: const Center(child: Text('Flexible Tight (1)'))),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                const Text('5. Wrap Widget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                    spacing: 8.0, // Jarak antar item
                    runSpacing: 4.0, // Jarak antar baris/kolom
                    children: List.generate(
                      10,
                      (index) => Chip(
                        label: Text('Tag ${index + 1}'),
                        backgroundColor: Colors.amber[100],
                      ),
                    ),
                  ),
                ),
                const Divider(),

                const Text('6. SizedBox dan Spacer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  color: Colors.grey[200],
                  child: Row(
                    children: <Widget>[
                      Container(color: Colors.teal, width: 50, height: 50),
                      const SizedBox(width: 20), // Spasi horizontal tetap
                      Container(color: Colors.indigo, width: 50, height: 50),
                      const Spacer(), // Mengambil semua ruang yang tersisa
                      Container(color: Colors.greenAccent, width: 50, height: 50),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Spasi vertikal tetap
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Visualisasi Konseptual Layout Widgets:**

```
┌──────────────────────────────────────────────────────────┐
│                   Container                              │
│ (Margin) ┌───────────────────────────────┐ (Margin)      │
│          │             Padding           │               │
│          │   ┌─────────────────────────┐ │               │
│          │   │         Child           │ │               │
│          │   └─────────────────────────┘ │               │
│          └───────────────────────────────┘               │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│                   Row                    │
│ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐  │
│ │ Child │ │ Child │ │ Child │ │ Child │  │
│ └───────┘ └───────┘ └───────┘ └───────┘  │
└──────────────────────────────────────────┘

┌─────────────────┐
│     Column      │
│ ┌───────────┐   │
│ │   Child   │   │
│ └───────────┘   │
│ ┌───────────┐   │
│ │   Child   │   │
│ └───────────┘   │
│ ┌───────────┐   │
│ │   Child   │   │
│ └───────────┘   │
└─────────────────┘

┌──────────────────────────────────────────┐
│                   Stack                  │
│ ┌──────────────────────────────────────┐ │
│ │ Layer 3 (Paling Atas)                │ │
│ │   ┌────────────────────────────────┐ │ │
│ │   │ Layer 2                        │ │ │
│ │   │   ┌──────────────────────────┐ │ │ │
│ │   │   │ Layer 1 (Paling Bawah)   │ │ │ │
│ │   │   │                          │ │ │ │
│ │   │   └──────────────────────────┘ │ │ │
│ │   └────────────────────────────────┘ │ │
│ └──────────────────────────────────────┘ │
└──────────────────────────────────────────┘

┌────────────────────────────────────────────┐
│   Row (dengan Expanded/Flexible)           │
│ ┌───────┐ ┌───────────────┐ ┌───────┐      │
│ │ Tetap │ │ Expanded/     │ │ Tetap │      │
│ │       │ │ Flexible      │ │       │      │
│ └───────┘ └───────────────┘ └───────┘      │
└────────────────────────────────────────────┘
(Expanded akan mengisi sisa ruang, Flexible bisa mengisi sebagian atau sesuai child)

┌──────────────────────────────────────────┐
│                   Wrap                   │
│ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐  │
│ │ Item  │ │ Item  │ │ Item  │ │ Item  │  │
│ └───────┘ └───────┘ └───────┘ └───────┘  │
│ ┌───────┐ ┌───────┐ ┌───────┐            │
│ │ Item  │ │ Item  │ │ Item  │            │
│ └───────┘ └───────┘ └───────┘            │
└──────────────────────────────────────────┘
(Item akan membungkus ke baris berikutnya jika tidak muat)

┌──────────────────────────────────────────┐
│              Row/Column                  │
│ ┌───────┐┌─────────┐┌───────┐            │
│ │ Child ││SizedBox ││ Child │            │
│ └───────┘└─────────┘└───────┘            │
│                                          │
│ ┌───────┐           ┌───────┐            │
│ │ Child │   Spacer  │ Child │            │
│ └───────┘           └───────┘            │
└──────────────────────────────────────────┘
```

**Terminologi Esensial:**

- **Layout:** Proses mengatur ukuran dan posisi _widget_ di layar.
- **Constraint-based Layout:** Sistem di mana _parent widget_ memberikan batasan (_constraint_) kepada _child_-nya, dan _child_ kemudian menentukan ukurannya dalam batasan tersebut.
- **Main Axis:** Sumbu utama tempat _widget_ diatur dalam `Row` (horizontal) atau `Column` (vertikal).
- **Cross Axis:** Sumbu silang, tegak lurus dengan sumbu utama.
- **Flex Factor:** Angka yang menunjukkan rasio ruang yang harus diambil oleh _widget_ `Expanded` atau `Flexible` relatif terhadap _widget flex_ lainnya.
- **Box Decoration:** Konfigurasi visual untuk `Container` seperti _border_, _radius_, _shadow_, dll.
- **Run:** Dalam `Wrap`, ini adalah baris atau kolom _child_ yang baru dibungkus.

**Struktur Internal (Mini-DAFTAR ISI):**

- Container: Pembungkus Serbaguna
- Row & Column: Pengatur Linear
- Stack & Positioned: Penumpuk Berlapis
- Expanded & Flexible: Pengatur Ruang Fleksibel
- Wrap: Pengatur Responsif Otomatis
- SizedBox & Spacer: Pengatur Jarak Presisi

**Hubungan dengan Bagian Lain:**

- **Widget Tree & Rendering Engine:** Memahami bagaimana _layout widgets_ ini bekerja secara internal terkait erat dengan konsep _RenderObject Tree_, karena _RenderObject_ yang sebenarnya melakukan perhitungan _layout_.
- **UI Components & Material Design:** Sebagian besar komponen Material Design (seperti `Card`, `AppBar`) menggunakan kombinasi dari _core layout widgets_ ini di bawah kap.
- **Responsive UI:** _Core layout widgets_ adalah fondasi untuk membangun UI yang responsif dan beradaptasi dengan berbagai ukuran layar.

**Referensi Lengkap:**

- [Flutter Layout Widgets](https://flutter.dev/docs/development/ui/widgets/layout): Dokumentasi resmi yang merangkum _widget-widget layout_ utama.
- [Layout Cheat Sheet](https://medium.com/flutter-community/flutter-layout-cheat-sheet-5363348d037e): Sumber daya visual yang bagus untuk memahami berbagai properti _layout_.
- [Understanding Constraints](https://flutter.dev/docs/development/ui/layout/constraints): Artikel penting untuk memahami bagaimana sistem _layout_ _Flutter_ bekerja di balik layar.

**Tips & Best Practices (untuk peserta):**

- **Pahami Aliran Constraints:** Ingatlah selalu bahwa _parent_ memberikan _constraint_ kepada _child_, dan _child_ menentukan ukurannya sendiri dalam _constraint_ tersebut.
- **Gunakan _Widget_ Paling Sederhana:** Jika Anda hanya butuh ruang, gunakan `SizedBox` atau `Spacer` daripada `Container` yang lebih berat.
- **Visualisasikan:** Gunakan _Flutter Inspector_ di _DevTools_ untuk melihat _layout_ _widget tree_ Anda secara visual; ini sangat membantu dalam _debugging layout_ yang kompleks.
- **Coba Kombinasi:** _Layout_ yang kompleks hampir selalu merupakan kombinasi dari _widget-widget layout_ sederhana yang disarang (_nested_) satu sama lain.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mengatur `width` atau `height` pada _child_ `Row` atau `Column` yang juga dibungkus oleh `Expanded` atau `Flexible`. Ini seringkali akan menyebabkan _error_ karena _constraint_ saling bertentangan.
  - **Solusi:** Biarkan `Expanded` atau `Flexible` mengelola dimensi di sepanjang sumbu utama. Jika Anda perlu ukuran tetap, jangan gunakan `Expanded` atau `Flexible` untuk _widget_ tersebut.
- **Kesalahan:** _Widget_ di dalam `Column` atau `Row` melimpah (_overflow_) dari layar.
  - **Solusi:**
    - Gunakan `Expanded` atau `Flexible` pada _child_ yang harus mengisi ruang.
    - Bungkus `Row` atau `Column` dengan `SingleChildScrollView` jika Anda ingin konten dapat digulir.
    - Pastikan `mainAxisSize` diatur dengan benar, terutama `MainAxisSize.min` untuk `Column` jika Anda tidak ingin ia mengambil seluruh tinggi _parent_.
- **Kesalahan:** Properti `color` tidak bekerja pada `Container` saat `decoration` juga ada.
  - **Solusi:** Pindahkan properti `color` ke dalam `BoxDecoration` (misalnya `decoration: BoxDecoration(color: Colors.blue)`).

---

Setelah menguasai _core layout widgets_, kini saatnya kita melangkah lebih jauh ke teknik _layout_ yang lebih canggih. Ini akan memungkinkan Anda menciptakan antarmuka pengguna yang sangat fleksibel, efisien, dan presisi, bahkan untuk skenario yang kompleks.

---

#### **Advanced Layout Techniques**

**Deskripsi Detail & Peran:**
Sub-bagian ini akan membawa Anda melampaui penggunaan dasar _layout widgets_. Kita akan menyelami properti dan _widget_ yang memungkinkan kontrol lebih granular atas bagaimana _widget_ diukur dan diposisikan, serta bagaimana membangun _layout_ kustom yang tidak dapat dicapai dengan _widget_ standar. Memahami teknik-teknik ini adalah kunci untuk optimasi performa dan pengembangan UI yang benar-benar unik.

**Konsep Kunci & Filosofi:**
Filosofi di sini adalah **"Constraints go down, sizes go up, parent sets position"**. Ini adalah aturan fundamental dalam sistem _layout_ _Flutter_. _Parent_ memberikan _constraint_ (batas ukuran) kepada _child_, _child_ memilih ukurannya sendiri dalam _constraint_ tersebut, lalu _parent_ memposisikan _child_. Teknik lanjutan ini akan mengeksplorasi bagaimana kita dapat memanipulasi atau memanfaatkan aturan ini untuk efek _layout_ yang lebih kompleks.

Berikut adalah teknik dan konsep yang akan kita bahas:

1.  **`MainAxisAlignment` dan `CrossAxisAlignment` (Re-visit & Advanced Context):**

    - **Peran:** Meskipun sudah disinggung pada `Row` dan `Column`, kedua properti ini memiliki nuansa lanjutan, terutama saat berinteraksi dengan `MainAxisSize`, `Expanded`, dan `Flexible`. Mereka menentukan bagaimana _child_ didistribusikan dan disejajarkan dalam ruang yang tersedia di sepanjang sumbu utama dan sumbu silang.
    - **Detail Lanjutan:**
      - `MainAxisAlignment`: Mengontrol distribusi ruang _kosong_ di sepanjang sumbu utama. Misalnya, `spaceBetween` dan `spaceEvenly` sangat efektif untuk distribusi otomatis.
      - `CrossAxisAlignment`: Mengontrol penempatan _child_ yang mungkin lebih kecil dari ruang yang dialokasikan di sepanjang sumbu silang. `CrossAxisAlignment.stretch` adalah properti yang kuat untuk membuat _child_ mengisi seluruh ruang silang yang tersedia.
    - **Filosofi:** Pengaturan alignment yang tepat adalah kunci untuk _layout_ yang rapi dan seimbang.

2.  **`MainAxisSize` properties (Re-visit & Advanced Context):**

    - **Peran:** Properti ini sangat penting untuk `Row` dan `Column` dan sering diabaikan. `MainAxisSize` menentukan seberapa banyak ruang yang harus diambil oleh `Row` atau `Column` itu sendiri di sepanjang sumbu utamanya.
    - **Detail Lanjutan:**
      - `MainAxisSize.max`: (Default untuk `Row`) `Row`/`Column` akan mencoba mengambil ruang sebanyak mungkin di sepanjang sumbu utamanya.
      - `MainAxisSize.min`: (Default untuk `Column`) `Row`/`Column` akan mengambil ruang sesedikit mungkin di sepanjang sumbu utamanya, hanya cukup untuk menampung _child_-nya.
    - **Penggunaan Lanjutan:** Sering digunakan ketika Anda ingin sebuah `Column` atau `Row` tidak mengisi seluruh lebar/tinggi yang tersedia dari _parent_-nya, tetapi hanya sebatas kontennya.

3.  **`TextDirection` dan `VerticalDirection`:**

    - **Peran:** Properti ini memengaruhi bagaimana _children_ diatur dalam `Row` dan `Column` sehubungan dengan sumbu utamanya.
    - **`TextDirection` (untuk `Row`):**
      - **Peran:** Menentukan arah horizontal _layout_ untuk `Row` (dan secara implisit memengaruhi `start`/`end` dari `MainAxisAlignment`).
      - **Nilai:** `TextDirection.ltr` (kiri-ke-kanan, default untuk bahasa seperti Inggris/Indonesia) atau `TextDirection.rtl` (kanan-ke-kiri, untuk bahasa seperti Arab/Ibrani).
    - **`VerticalDirection` (untuk `Column`):**
      - **Peran:** Menentukan arah vertikal _layout_ untuk `Column` (dan memengaruhi `start`/`end` dari `MainAxisAlignment`).
      - **Nilai:** `VerticalDirection.down` (atas-ke-bawah, default) atau `VerticalDirection.up` (bawah-ke-atas).
    - **Filosofi:** Penting untuk lokalisasi (mendukung bahasa RTL) dan untuk _layout_ yang perlu disusun secara terbalik.

4.  **`Intrinsic width` dan `height`:**

    - **Peran:** Kadang-kadang Anda perlu agar sebuah _widget_ memiliki lebar atau tinggi yang "inheren" dari _child_-nya yang paling lebar/tinggi, bahkan jika _parent_ memberikan _constraint_ tak terbatas. Ini diatasi dengan `IntrinsicWidth` dan `IntrinsicHeight`.
    - **`IntrinsicWidth`:** Membuat _child_ memiliki lebar yang sama dengan lebar intrinsik _child_-nya yang paling lebar.
    - **`IntrinsicHeight`:** Membuat _child_ memiliki tinggi yang sama dengan tinggi intrinsik _child_-nya yang paling tinggi.
    - **Peringatan:** Penggunaan ini cenderung **mahal secara komputasi** karena memerlukan dua _layout pass_. Hindari jika ada alternatif lain.
    - **Filosofi:** Memungkinkan _child_ untuk "memberi tahu" _parent_ tentang ukuran idealnya, memecah aturan "constraint goes down, size goes up".

5.  **`Baseline alignment`:**

    - **Peran:** `Baseline` adalah cara untuk menyelaraskan _child_ dalam `Row` berdasarkan garis dasar teks mereka, bukan tepi atas atau bawahnya. Ini sangat berguna ketika Anda memiliki teks dengan ukuran font berbeda yang ingin disejajarkan dengan rapi.
    - **Penggunaan:** Digunakan dengan `CrossAxisAlignment.baseline` di `Row` dan memerlukan properti `textBaseline` yang ditentukan.
    - **Filosofi:** Menyediakan kontrol _alignment_ yang sangat spesifik untuk _layout_ berbasis teks.

6.  **Custom layout dengan `Flow` widget:**

    - **Peran:** `Flow` adalah _widget_ _low-level_ yang memungkinkan Anda untuk melakukan _custom painting_ dan _layout_ yang sangat efisien dan dapat dioptimalkan. Berbeda dengan sebagian besar _layout widgets_ yang melakukan dua _pass_ (_measure_ dan _layout_), `Flow` dapat melakukan _layout_ _child_-nya dalam satu _pass_.
    - **Kapan Digunakan:**
      - Ketika Anda memiliki _layout_ yang sangat spesifik dan kompleks yang tidak dapat dicapai dengan _widget_ standar.
      - Untuk animasi yang melibatkan pergerakan banyak _child_ secara bersamaan (misalnya _radial menu_, _tag cloud_ dinamis) di mana performa sangat kritis.
    - **Kompleksitas:** `Flow` jauh lebih kompleks untuk digunakan daripada _layout widgets_ lainnya karena Anda harus secara manual menghitung posisi dan ukuran setiap _child_.
    - **Filosofi:** Memberikan kendali penuh pada _developer_ untuk _layout_ dan _painting_ kustom, dengan biaya peningkatan kompleksitas.

**Contoh Implementasi & Visualisasi:**

```dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
          title: const Text('Advanced Layout Techniques'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('1. MainAxisAlignment & CrossAxisAlignment (Advanced)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // Contoh CrossAxisAlignment.stretch
              Container(
                height: 120,
                color: Colors.blue[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Membuat children meregang di sumbu silang
                  children: [
                    Container(width: 50, color: Colors.red, child: const Center(child: Text('A'))),
                    Container(width: 50, color: Colors.green, child: const Center(child: Text('B'))),
                    Container(width: 50, color: Colors.blue, child: const Center(child: Text('C'))),
                  ],
                ),
              ),
              const Divider(),

              const Text('2. MainAxisSize properties (Advanced)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // Column dengan MainAxisSize.min
              Container(
                color: Colors.orange[50],
                width: double.infinity, // Ambil lebar penuh agar Column bisa memusat
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Column hanya setinggi child-nya
                  mainAxisAlignment: MainAxisAlignment.center, // Memusatkan Column itu sendiri
                  children: [
                    Container(height: 50, width: 50, color: Colors.orange, child: const Center(child: Text('1'))),
                    Container(height: 50, width: 50, color: Colors.deepOrange, child: const Center(child: Text('2'))),
                  ],
                ),
              ),
              const Divider(),

              const Text('3. TextDirection dan VerticalDirection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // Row dengan TextDirection.rtl
              Container(
                color: Colors.purple[50],
                padding: const EdgeInsets.all(8),
                child: Row(
                  textDirection: TextDirection.rtl, // Dari kanan ke kiri
                  mainAxisAlignment: MainAxisAlignment.start, // Mulai dari kanan
                  children: [
                    Container(width: 50, height: 50, color: Colors.purple, child: const Center(child: Text('1'))),
                    Container(width: 50, height: 50, color: Colors.pink, child: const Center(child: Text('2'))),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Column dengan VerticalDirection.up
              Container(
                color: Colors.teal[50],
                height: 150,
                child: Column(
                  verticalDirection: VerticalDirection.up, // Dari bawah ke atas
                  mainAxisAlignment: MainAxisAlignment.start, // Mulai dari bawah
                  children: [
                    Container(width: 50, height: 50, color: Colors.teal, child: const Center(child: Text('A'))),
                    Container(width: 50, height: 50, color: Colors.cyan, child: const Center(child: Text('B'))),
                  ],
                ),
              ),
              const Divider(),

              const Text('4. Intrinsic Width dan Height', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              IntrinsicHeight( // Memaksa Column memiliki tinggi dari child tertinggi
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Agar children meregang vertikal
                  children: [
                    Container(width: 100, color: Colors.grey[200], child: const Text('Ini adalah teks pendek.')),
                    Container(
                      width: 100,
                      color: Colors.grey[300],
                      child: const Text('Ini adalah teks yang sangat panjang dan butuh beberapa baris untuk ditampilkan dengan rapi.'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              IntrinsicWidth( // Memaksa Row memiliki lebar dari child terlebar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Agar children meregang horizontal
                  children: [
                    Container(height: 50, color: Colors.brown[100], child: const Center(child: Text('Pendek'))),
                    Container(height: 50, color: Colors.brown[200], child: const Center(child: Text('Ini agak panjang'))),
                    Container(height: 50, color: Colors.brown[300], child: const Center(child: Text('Ini sangat sangat panjang'))),
                  ],
                ),
              ),
              const Divider(),

              const Text('5. Baseline Alignment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                color: Colors.lime[50],
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic, // Penting untuk baseline
                  children: [
                    const Text('Hello', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    const Text('World', style: TextStyle(fontSize: 40)),
                    const SizedBox(width: 10),
                    const Text('!', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              const Divider(),

              const Text('6. Custom layout dengan Flow Widget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Flow(
                  delegate: RadialFlowDelegate(),
                  children: List.generate(5, (index) => _buildCircle(index + 1)),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(int number) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.primaries[number % Colors.primaries.length],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}

// Delegate kustom untuk Flow widget (contoh Radial Menu)
class RadialFlowDelegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    const double radius = 80; // Radius lingkaran
    final double angle = math.pi * 2 / context.childCount; // Sudut antar children

    for (int i = 0; i < context.childCount; i++) {
      final double x = radius * math.cos(i * angle);
      final double y = radius * math.sin(i * angle);

      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          x + context.size.width / 2 - 25, // Pusatkan child
          y + context.size.height / 2 - 25,
          0,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return false; // Tidak perlu repaint kecuali ada perubahan
  }
}
```

**Visualisasi Konseptual Advanced Layout Techniques:**

```
┌──────────────────────────────────────────────────────────┐
│       Row (CrossAxisAlignment.stretch)                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                │
│  │ Child A  │  │ Child B  │  │ Child C  │                │
│  │(Meregang │  │(Meregang │  │(Meregang │                │
│  │ Vertikal)│  │ Vertikal)│  │ Vertikal)│                │
│  └──────────┘  └──────────┘  └──────────┘                │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│               Column (MainAxisSize.min)                  │
│              (Hanya setinggi kontennya)                  │
│  ┌─────────────────┐                                     │
│  │     Child 1     │                                     │
│  └─────────────────┘                                     │
│  ┌─────────────────┐                                     │
│  │     Child 2     │                                     │
│  └─────────────────┘                                     │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│          Row (TextDirection.rtl)                         │
│  ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐                 │
│  │ Item D│ │ Item C│ │ Item B│ │ Item A│                 │
│  └───────┘ └───────┘ └───────┘ └───────┘                 │
│  (Mulai dari kanan)                                      │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│              Column (VerticalDirection.up)               │
│  ┌───────┐                                               │
│  │ Item D│                                               │
│  └───────┘                                               │
│  ┌───────┐                                               │
│  │ Item C│                                               │
│  └───────┘                                               │
│  ┌───────┐                                               │
│  │ Item B│                                               │
│  └───────┘                                               │
│  ┌───────┐                                               │
│  │ Item A│                                               │
│  └───────┘                                               │
│  (Mulai dari bawah)                                      │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│    Row (CrossAxisAlignment.baseline)                     │
│    Teks pendek                                           │
│                 Teks panjang                             │
│                      Teks                                │
│    ────────────── Baseline ────────────────────────────  │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│                   Flow Widget (Radial)                   │
│        .  .  .  .  .  .  .  .  .  .  .  .                │
│    .                                        .            │
│  .                                            .          │
│ .            [1]                           [5]  .        │
│ .                                               .        │
│ .                                               .        │
│ .                                               .        │
│ .          [2]                         [4]      .        │
│  .                                            .          │
│    .            [3]                     .  .             │
│      .  .  .  .  .  .  .  .  .  .  .  .                  │
└──────────────────────────────────────────────────────────┘
```

**Terminologi Esensial:**

- **Constraint-based Layout:** Aturan dasar _Flutter_ di mana _parent_ memberikan batasan ukuran kepada _child_.
- **Two-pass Layout:** Sebagian besar _widget_ melakukan dua _pass_ untuk _layout_: _measure_ (_child_ memberitahu _parent_ ukuran idealnya) dan _layout_ (_parent_ memposisikan _child_). `Intrinsic` _widgets_ seringkali memicu _two-pass layout_.
- **Intrinsic Size:** Ukuran "alami" atau "ideal" sebuah _widget_ berdasarkan kontennya, bukan _constraint_ dari _parent_.
- **Baseline:** Garis imajiner di mana karakter teks diletakkan.
- **Flow Delegate:** Kelas kustom yang digunakan dengan `Flow` _widget_ untuk menentukan bagaimana _child_ diukur dan diposisikan secara manual.

**Struktur Internal (Mini-DAFTAR ISI):**

- Penjajaran Lanjutan (`MainAxisAlignment`, `CrossAxisAlignment`)
- Ukuran Sumbu Utama (`MainAxisSize`)
- Arah Teks & Vertikal (`TextDirection`, `VerticalDirection`)
- Ukuran Intrinsik (`IntrinsicWidth`, `IntrinsicHeight`)
- Penjajaran Baseline
- Layout Kustom (`Flow` Widget)

**Hubungan dengan Bagian Lain:**

- **Performance Optimization:** Memahami `Intrinsic` _widgets_ dan `Flow` adalah kunci untuk mengoptimalkan performa _layout_ di skenario yang menantang.
- **Responsive UI:** Teknik ini memungkinkan kontrol yang sangat halus untuk membuat UI beradaptasi dengan berbagai skenario.
- **Custom Painting:** `Flow` _widget_ sangat erat kaitannya dengan konsep _custom painting_ karena Anda sering menggambar _child_ pada posisi yang dihitung secara manual.

**Referensi Lengkap:**

- [Flutter Layout Widgets](https://flutter.dev/docs/development/ui/widgets/layout): Selalu menjadi referensi utama untuk _widget-widget layout_.
- [Understanding Constraints](https://flutter.dev/docs/docs/development/ui/layout/constraints): Artikel yang menjelaskan model _constraint_ _Flutter_ secara mendalam.
- [Flex and Flexible Widgets](https://flutter.dev/docs/development/ui/layout/flex): Detail tentang penggunaan `flex` dan `fit`.
- [Stack and Positioned Advanced](https://flutter.dev/docs/cookbook/animation/physics-simulation): Meskipun judulnya tentang animasi, bagian ini menjelaskan lebih banyak tentang `Stack` dan `Positioned`.
- [CustomScrollView & Slivers](https://flutter.dev/docs/development/ui/advanced/slivers): Akan kita bahas lebih lanjut di bagian _scrolling_, namun relevan dengan _layout_ tingkat lanjut.
- [Flow Widget](https://api.flutter.dev/flutter/widgets/Flow-class.html): Dokumentasi API untuk `Flow` _widget_.

**Tips & Best Practices (untuk peserta):**

- **Gunakan `Intrinsic` dengan Hati-hati:** Hindari `IntrinsicWidth` dan `IntrinsicHeight` jika ada cara lain yang lebih ringan untuk mencapai efek yang diinginkan, karena mereka memicu _layout pass_ kedua yang mahal.
- **Mulai dari Sederhana:** Selalu coba selesaikan masalah _layout_ dengan `Row`, `Column`, `Stack`, `Expanded`, `Flexible`, `SizedBox`, dan `Padding` terlebih dahulu. `Flow` adalah pilihan terakhir untuk _layout_ yang sangat spesifik.
- **Debug dengan Visualisasi:** Gunakan `debugPaintSizeEnabled = true;` (import `package:flutter/rendering.dart;` di `main.dart` Anda) untuk melihat batas-batas _layout_ _widget_, dan _Flutter Inspector_ di _DevTools_ untuk memeriksa _layout tree_ dan _constraint_.
- **Pahami `flex`:** Dalam `Expanded` dan `Flexible`, `flex` adalah rasio, bukan ukuran absolut. Total `flex` dari semua _child_ akan dibagi untuk menentukan proporsi ruang.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menggunakan `MainAxisSize.max` pada `Column` di dalam `SingleChildScrollView` (atau sebaliknya). Ini sering menyebabkan _render overflow_ karena `Column` mencoba mengisi tak terbatas sementara _ScrollView_ juga menyediakan ruang tak terbatas.
  - **Solusi:** Pastikan _constraint_ yang mengalir ke bawah adalah _bounded_ (terbatas) di salah satu titik. `Column` di dalam `SingleChildScrollView` harus memiliki `mainAxisSize: MainAxisSize.min` (default untuk `Column`).
- **Kesalahan:** `CrossAxisAlignment.baseline` tidak bekerja.
  - **Solusi:** Pastikan semua _child_ yang ingin disejajarkan memiliki `Text` _widget_ dan `textBaseline` properti `Row` diatur (misalnya `TextBaseline.alphabetic`).
- **Kesalahan:** Bingung kapan menggunakan `Expanded` vs `Flexible`.
  - **Solusi:** `Expanded` akan _selalu_ mengisi sisa ruang yang tersedia. `Flexible` hanya akan mengisi ruang _jika child-nya membutuhkan_ (dengan `FlexFit.loose`) atau mengisi _jika dipaksa_ (dengan `FlexFit.tight`). Pikirkan `Expanded` sebagai `Flexible(fit: FlexFit.tight)`.

# Luar biasa dan Selamat!

Anda telah berhasil menuntaskan pembahasan mendalam tentang **Core Layout Widgets** di _Flutter_. Ini adalah fondasi kuat untuk merancang dan membangun antarmuka pengguna yang visualnya menarik dan berfungsi dengan baik. Bagian **Advanced Layout Techniques** juga membekali Anda dengan alat untuk menangani skenario _layout_ yang paling menantang sekalipun, memastikan Anda dapat membangun UI yang presisi, responsif, dan performatif.

---

### **3: UI Components & Material Design**.

#### **3.1 Material Design Implementation**

Pada bagian ini, kita akan mulai membangun antarmuka pengguna yang indah dan fungsional dengan memanfaatkan komponen-komponen yang telah disediakan oleh _Flutter_, khususnya yang mengikuti pedoman Material Design.

##### **Material Components**

**Deskripsi Detail & Peran:**
Sub-bagian ini akan memperkenalkan Anda pada _Material Components_, yaitu serangkaian _widget_ yang mengimplementasikan pedoman desain Material Design dari Google. _Material Design_ adalah sistem desain komprehensif untuk aplikasi digital, dan _Flutter_ menyediakan implementasi _widget_ yang kaya untuk memudahkan Anda membangun aplikasi yang konsisten, intuitif, dan menarik secara visual di berbagai platform. Memahami _Material Components_ adalah langkah fundamental untuk membangun aplikasi _Flutter_ yang tampak profesional.

**Konsep Kunci & Filosofi:**
Filosofi inti di balik _Material Components_ adalah **konsistensi**, **aksesibilitas**, dan **pengalaman pengguna yang intuitif**. Setiap komponen dirancang untuk memiliki tampilan dan perilaku yang dapat diprediksi, mengurangi beban kognitif pengguna, dan memungkinkan pengembangan yang cepat. _Flutter_ mewujudkan ini dengan menyediakan _widget_ siap pakai yang dapat disesuaikan.

Berikut adalah _Material Components_ utama yang akan kita bahas:

1.  **`Scaffold` structure dan components:**

    - **Peran:** `Scaffold` adalah _widget_ _top-level_ yang menyediakan struktur _layout_ dasar untuk aplikasi Material Design. Ini adalah fondasi di mana Anda akan menempatkan sebagian besar _widget_ UI lainnya. Ibaratnya, ini adalah kerangka bangunan aplikasi Anda.
    - **Properti Kunci & Komponen Internal:**
      - `appBar`: Sebuah `AppBar` yang ditampilkan di bagian atas layar.
      - `body`: Konten utama layar, menempati sisa ruang yang tidak digunakan oleh `AppBar`, `bottomNavigationBar`, dll.
      - `floatingActionButton`: Tombol aksi mengambang yang biasanya digunakan untuk aksi utama pada layar.
      - `floatingActionButtonLocation`: Mengatur posisi `FloatingActionButton`.
      - `drawer`: Panel samping yang muncul dari kiri (biasanya menu navigasi).
      - `endDrawer`: Panel samping yang muncul dari kanan (biasanya pengaturan atau info tambahan).
      - `bottomNavigationBar`: Bar navigasi di bagian bawah layar, sering digunakan untuk navigasi antar bagian utama aplikasi.
      - `bottomSheet`: Sebuah panel yang muncul dari bawah layar, dapat di-_dismiss_ atau persisten.
      - `backgroundColor`: Warna latar belakang `Scaffold`.
      - `resizeToAvoidBottomInset`: Mengontrol apakah `Scaffold` akan mengubah ukurannya untuk menghindari _keyboard_ yang muncul.
    - **Filosofi:** `Scaffold` mengkonsolidasikan elemen-elemen UI umum yang ditemukan di hampir setiap aplikasi modern, memungkinkan _developer_ fokus pada konten.

    <!-- end list -->

    ```
    Scaffold
    ├── AppBar
    │   └── Title, Actions
    ├── body
    │   └── Content Widget Tree
    ├── floatingActionButton
    ├── drawer
    ├── endDrawer
    └── bottomNavigationBar
        └── Items (e.g., BottomNavigationBarItem)
    ```

2.  **`AppBar` customization dan variants:**

    - **Peran:** `AppBar` adalah bilah di bagian atas layar yang menyediakan informasi, tindakan, dan navigasi kontekstual untuk layar saat ini.
    - **Properti Kunci:**
      - `title`: Judul utama `AppBar`, biasanya berupa `Text` _widget_.
      - `leading`: _Widget_ di sisi kiri `title` (misalnya tombol _drawer_ atau tombol _back_).
      - `actions`: Daftar _widget_ di sisi kanan `title` (misalnya ikon pencarian, pengaturan).
      - `bottom`: _Widget_ yang ditampilkan di bawah `AppBar` utama (misalnya `TabBar`).
      - `backgroundColor`: Warna latar belakang `AppBar`.
      - `elevation`: Tinggi `AppBar` di atas _body_, memberikan efek bayangan.
      - `toolbarHeight`: Tinggi `toolbar` `AppBar` itu sendiri.
      - `flexibleSpace`: _Widget_ yang ditumpuk di belakang `toolbar` dan `bottom`, berguna untuk efek _parallax_.
    - **Varian:**
      - `SliverAppBar`: Digunakan dalam `CustomScrollView` untuk efek _collapsible_ atau _expandable_ saat menggulir.
    - **Filosofi:** Menyediakan cara yang konsisten dan dapat disesuaikan untuk menampilkan kontrol dan informasi penting di bagian atas layar.

    <!-- end list -->

    ```
    AppBar
    ├── leading (e.g., IconButton for Drawer)
    ├── title (e.g., Text)
    ├── actions (List of IconButtons/Widgets)
    └── bottom (Optional: TabBar)
    ```

3.  **`FloatingActionButton` types:**

    - **Peran:** Tombol aksi mengambang adalah tombol melingkar yang mengambang di atas UI dan digunakan untuk mempromosikan aksi utama pada layar.
    - **Properti Kunci:**
      - `child`: _Widget_ yang ditampilkan di dalam tombol (biasanya `Icon`).
      - `onPressed`: _Callback_ yang dipanggil saat tombol ditekan.
      - `backgroundColor`: Warna latar belakang tombol.
      - `mini`: Membuat tombol lebih kecil.
      - `heroTag`: Digunakan untuk animasi _hero_ antar layar. Penting jika ada lebih dari satu `FloatingActionButton` dalam _route tree_.
    - **Tipe/Varian:**
      - **Standard FAB:** Bentuk lingkaran standar.
      - **Mini FAB:** Versi lebih kecil dari standar FAB.
      - **Extended FAB:** Bentuk persegi panjang dengan label teks dan ikon, lebih menonjol.
    - **Filosofi:** Menarik perhatian ke aksi terpenting di layar saat ini.

    <!-- end list -->

    ```
    FloatingActionButton
    └── Icon / Text (for Extended FAB)
    ```

4.  **`Drawer` dan `EndDrawer`:**

    - **Peran:** `Drawer` adalah panel navigasi yang biasanya tersembunyi dan muncul dari tepi layar (defaultnya kiri). `EndDrawer` adalah `Drawer` yang muncul dari tepi berlawanan (defaultnya kanan).
    - **Properti Kunci:**
      - `child`: _Widget_ yang ditampilkan di dalam `Drawer`, biasanya `ListView` yang berisi `DrawerHeader` dan daftar `ListTile` untuk item navigasi.
    - **Penggunaan:** Sering digunakan untuk navigasi tingkat atas, pengaturan, atau informasi akun pengguna.
    - **Filosofi:** Menyediakan akses ke navigasi atau opsi sekunder tanpa mengganggu konten utama layar.

    <!-- end list -->

    ```
    Drawer
    └── ListView
        ├── DrawerHeader
        │   └── User Info / App Logo
        └── ListTile (for each navigation item)
            ├── Icon
            └── Text
    ```

5.  **`BottomNavigationBar` vs `NavigationRail`:**

    - **Peran:** Keduanya menyediakan navigasi persisten di antara beberapa tujuan di tingkat atas aplikasi.
    - **`BottomNavigationBar`:**
      - **Peran:** Bar navigasi yang ditampilkan di bagian bawah layar. Ideal untuk 3-5 tujuan tingkat atas.
      - **Properti Kunci:**
        - `items`: Daftar `BottomNavigationBarItem` (ikon dan label).
        - `onTap`: _Callback_ saat item ditekan.
        - `currentIndex`: Indeks item yang saat ini dipilih.
        - `type`: Mengontrol perilaku visual (fixed/shifting).
      - **Batasan:** Tidak ideal untuk lebih dari 5 item.
    - **`NavigationRail`:**
      - **Peran:** Alternatif untuk `BottomNavigationBar` yang cocok untuk _layout_ yang lebih besar (tablet, desktop). Menampilkan navigasi secara vertikal di sepanjang sisi kiri atau kanan layar.
      - **Properti Kunci:**
        - `destinations`: Daftar `NavigationRailDestination` (ikon dan label).
        - `selectedIndex`: Indeks item yang saat ini dipilih.
        - `onDestinationSelected`: _Callback_ saat item dipilih.
        - `leading`, `trailing`: _Widget_ opsional di bagian atas/bawah rel navigasi.
        - `extended`: Mengontrol apakah rel diperluas untuk menampilkan label teks.
      - **Penggunaan:** Sangat baik untuk aplikasi yang perlu beradaptasi dengan berbagai ukuran layar, menyediakan pengalaman navigasi yang optimal.
    - **Filosofi:** Memastikan navigasi yang mudah diakses dan konsisten di berbagai form factor.

    <!-- end list -->

    ```
    BottomNavigationBar
    ├── BottomNavigationBarItem (Icon, Label)
    ├── BottomNavigationBarItem (Icon, Label)
    └── ...

    NavigationRail
    ├── leading (Optional)
    ├── destinations (List of NavigationRailDestination)
    │   ├── Icon
    │   └── Label
    └── trailing (Optional)
    ```

6.  **`SnackBar` dan `Banner` notifications:**

    - **Peran:** Keduanya digunakan untuk menampilkan pesan singkat dan informatif kepada pengguna.
    - **`SnackBar`:**
      - **Peran:** Pesan ringan yang muncul sementara di bagian bawah layar. Ideal untuk pemberitahuan singkat yang tidak mengganggu aliran pengguna (misalnya "Item ditambahkan ke keranjang").
      - **Penggunaan:** Ditampilkan menggunakan `ScaffoldMessenger.of(context).showSnackBar()`.
      - **Interaksi:** Dapat memiliki aksi opsional (misalnya tombol "Undo"). Akan hilang secara otomatis setelah beberapa detik atau saat pengguna berinteraksi.
    - **`MaterialBanner` (sering disebut `Banner`):**
      - **Peran:** Pesan penting yang muncul di bagian atas layar, di bawah `AppBar`, dan tetap terlihat hingga ditutup oleh pengguna. Ideal untuk pesan yang memerlukan perhatian atau interaksi segera (misalnya, masalah koneksi, pemberitahuan persetujuan cookie).
      - **Penggunaan:** Ditampilkan menggunakan `ScaffoldMessenger.of(context).showMaterialBanner()`.
      - **Interaksi:** Memiliki aksi dan tombol tutup eksplisit.
    - **Filosofi:** Memberikan umpan balik kepada pengguna secara non-intrusif (SnackBar) atau lebih menonjol (Banner) sesuai dengan tingkat urgensi pesan.

7.  **`Dialog` variants (`AlertDialog`, `SimpleDialog`, `Custom`):**

    - **Peran:** `Dialog` adalah _popup_ yang muncul di atas konten layar saat ini untuk meminta informasi atau keputusan dari pengguna. Mereka menghalangi interaksi dengan konten di belakangnya.
    - **`AlertDialog`:**
      - **Peran:** Dialog yang digunakan untuk memberi tahu pengguna tentang situasi yang memerlukan konfirmasi. Memiliki judul, konten, dan daftar aksi (tombol).
      - **Penggunaan:** Sering digunakan untuk konfirmasi penghapusan, peringatan _error_, atau pertanyaan ya/tidak.
    - **`SimpleDialog`:**
      - **Peran:** Dialog yang menawarkan daftar opsi kepada pengguna. Memiliki judul opsional dan daftar _child_ (biasanya `SimpleDialogOption`).
      - **Penggunaan:** Ideal untuk memilih dari daftar opsi yang sederhana.
    - **Custom Dialog:**
      - **Peran:** Menggunakan `showDialog` dengan _widget_ `Dialog` dasar atau `Container` untuk membuat _popup_ dengan _layout_ yang sepenuhnya kustom.
      - **Penggunaan:** Ketika `AlertDialog` atau `SimpleDialog` tidak cukup fleksibel untuk kebutuhan UI Anda.
    - **Filosofi:** Mengambil fokus pengguna untuk keputusan penting atau input.

    <!-- end list -->

    ```
    Dialog (Conceptual)
    ├── Title (Optional)
    ├── Content (Text, List of Options, Custom Widget)
    └── Actions (Buttons - for AlertDialog)
    ```

**Sintaks/Contoh Implementasi Lengkap:**

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
      title: 'Material Components Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, // Menggunakan Material 2 untuk demo ini
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ini adalah SnackBar!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Kode untuk aksi Undo
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text('Ini adalah Material Banner yang penting!'),
        leading: const Icon(Icons.info, color: Colors.blue),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('DISMISS'),
          ),
          TextButton(
            onPressed: () {
              // Aksi lain
            },
            child: const Text('PELAJARI LEBIH'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('BATAL'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('HAPUS'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
                _showSnackBar(context); // Tampilkan SnackBar setelah hapus
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSimpleDialog(BuildContext context) async {
    switch (await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Pilih Opsi'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'Opsi 1');
              },
              child: const Text('Opsi Satu'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'Opsi 2');
              },
              child: const Text('Opsi Dua'),
            ),
          ],
        );
      },
    )) {
      case 'Opsi 1':
        print('Anda memilih Opsi Satu');
        break;
      case 'Opsi 2':
        print('Anda memilih Opsi Dua');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. AppBar
      appBar: AppBar(
        title: const Text('Material Components Demo'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Membuka Drawer
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSnackBar(context); // Demo SnackBar
            },
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              _showBanner(context); // Demo Banner
            },
          ),
        ],
      ),
      // 2. Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu Aplikasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                _onItemTapped(1);
              },
            ),
          ],
        ),
      ),
      // 3. Body
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Halaman saat ini: ${['Home', 'Pengaturan', 'Profil'][_selectedIndex]}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showAlertDialog(context),
              child: const Text('Tampilkan AlertDialog'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showSimpleDialog(context),
              child: const Text('Tampilkan SimpleDialog'),
            ),
            const SizedBox(height: 10),
            // Example of using NavigationRail for larger screens (conceptual for this single screen app)
            // You'd typically use LayoutBuilder or MediaQuery to conditionally show it
            if (MediaQuery.of(context).size.width > 600)
              SizedBox(
                height: 150, // Hanya untuk demo, agar terlihat
                child: Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: const <NavigationRailDestination>[
                        NavigationRailDestination(
                          icon: Icon(Icons.home),
                          selectedIcon: Icon(Icons.home_filled),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings),
                          selectedIcon: Icon(Icons.settings_suggest),
                          label: Text('Pengaturan'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person),
                          selectedIcon: Icon(Icons.person),
                          label: Text('Profil'),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Konten Rail: ${['Home', 'Pengaturan', 'Profil'][_selectedIndex]}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      // 4. FloatingActionButton
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('FAB ditekan!');
          _showSnackBar(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Baru'),
      ),
      // 5. BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
```

**Terminologi Esensial:**

- **Material Design:** Sistem desain yang dibuat oleh Google untuk aplikasi di berbagai platform, fokus pada grid-based layout, responsif, dan _deep motion_.
- **Scaffold:** Kerangka utama aplikasi Material Design.
- **AppBar:** Bilah atas yang berisi judul dan aksi.
- **FloatingActionButton (FAB):** Tombol aksi utama yang mengambang.
- **Drawer:** Panel navigasi samping yang muncul dari tepi.
- **BottomNavigationBar:** Bar navigasi di bagian bawah layar.
- **NavigationRail:** Bar navigasi vertikal, cocok untuk layar lebih besar.
- **SnackBar:** Pesan pemberitahuan sementara di bagian bawah layar.
- **MaterialBanner:** Pesan pemberitahuan persisten di bagian atas layar.
- **Dialog:** _Pop-up_ yang meminta input atau konfirmasi pengguna.

**Struktur Internal (Mini-DAFTAR ISI):**

- Struktur `Scaffold`
- Kustomisasi `AppBar`
- Jenis `FloatingActionButton`
- Penggunaan `Drawer` dan `EndDrawer`
- Perbandingan `BottomNavigationBar` dan `NavigationRail`
- Pemberitahuan `SnackBar` dan `Banner`
- Varian `Dialog`

**Hubungan dengan Bagian Lain:**

- **Layout System Mastery:** `Scaffold` menyediakan kerangka _layout_ yang kemudian diisi oleh _widget-widget layout_ lainnya.
- **State Management:** Perubahan pada _state_ seperti pemilihan item di `BottomNavigationBar` atau `NavigationRail` akan memicu `setState()` untuk membangun ulang UI yang relevan.
- **Responsif UI:** Pemilihan antara `BottomNavigationBar` dan `NavigationRail` adalah contoh bagaimana Anda dapat membuat UI Anda responsif terhadap ukuran layar yang berbeda.

**Referensi Lengkap:**

- [Material Components Flutter](https://flutter.dev/docs/development/ui/widgets/material): Dokumentasi resmi semua _Material Components_.
- [Material Design 3 Guidelines](https://m3.material.io/): Panduan desain resmi dari Google.
- [Material You Implementation](https://medium.com/flutter/material-3-in-flutter-f84e4a5b9d4c): Artikel tentang implementasi Material Design 3 di Flutter.

**Tips & Best Practices (untuk peserta):**

- **Gunakan `ScaffoldMessenger`:** Untuk menampilkan `SnackBar` dan `MaterialBanner`, selalu gunakan `ScaffoldMessenger.of(context)`. Ini memastikan mereka ditampilkan dengan benar bahkan jika `Scaffold` yang awalnya menampilkannya sudah tidak ada di _tree_.
- **Konsisten dengan Desain:** Ikuti pedoman Material Design (atau Cupertino Design untuk iOS) untuk memastikan aplikasi Anda terlihat dan terasa familiar bagi pengguna.
- **Prioritaskan Aksesibilitas:** Pastikan Anda menyediakan label yang jelas dan mudah diakses untuk semua komponen, terutama untuk pengguna dengan kebutuhan khusus.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mencoba memanggil `Scaffold.of(context)` di dalam `build` _method_ dari _widget_ yang sama dengan `Scaffold` tanpa menggunakan `Builder`.
  - **Solusi:** Bungkus _widget_ yang memanggil `Scaffold.of(context)` dengan `Builder` _widget_ (`Builder(builder: (BuildContext newContext) { return IconButton(... Scaffold.of(newContext).openDrawer(); });`). Ini memastikan `context` yang digunakan adalah anak dari `Scaffold`.
- **Kesalahan:** Lebih dari satu `FloatingActionButton` dalam _route tree_ tanpa `heroTag` yang unik, menyebabkan _hero animation error_.
  - **Solusi:** Berikan `heroTag: null` jika Anda tidak membutuhkan animasi _hero_ atau `heroTag: 'uniqueTag'` untuk setiap `FloatingActionButton` yang berbeda.
- **Kesalahan:** `BottomNavigationBar` tidak menampilkan label teks.
  - **Solusi:** Periksa `type` properti. Jika `type` adalah `BottomNavigationBarType.fixed`, label akan selalu terlihat. Jika `type` adalah `BottomNavigationBarType.shifting` (default jika ada 4+ item), label hanya muncul saat item dipilih. Pastikan `selectedItemColor` dan `unselectedItemColor` juga diatur.

---

Setelah mendalami **Material Components** standar, kini saatnya kita melangkah ke evolusi berikutnya dari Material Design, yaitu **Material Design 3**, yang sering disebut juga **Material You**. Ini adalah pembaruan besar yang membawa personalisasi dan ekspresivitas yang lebih kaya ke antarmuka pengguna Anda.

---

### **3.1 Material Design Implementation (Lanjutan)**

##### **Material Design 3 (Material You)**

**Deskripsi Detail & Peran:**
_Material Design 3_ (M3), atau _Material You_, adalah versi terbaru dari sistem desain Material Design dari Google. Fokus utamanya adalah pada personalisasi, ekspresi diri, dan adaptasi UI berdasarkan preferensi pengguna dan konteks perangkat. Ini membawa perubahan signifikan pada estetika visual, sistem warna dinamis, tipografi, elevasi, dan komponen UI. Memahami M3 sangat penting untuk membangun aplikasi _Flutter_ yang modern, adaptif, dan responsif terhadap tema perangkat pengguna.

**Konsep Kunci & Filosofi:**
Filosofi inti M3 adalah **"personalization"**, **"adaptability"**, dan **"fluidity"**. Ini bertujuan untuk menciptakan pengalaman digital yang terasa lebih unik dan personal bagi setiap individu, memungkinkan aplikasi untuk beradaptasi secara mulus dengan tema perangkat, preferensi warna, dan ukuran layar. Ini juga mendorong penggunaan desain yang lebih ekspresif dan berani.

Berikut adalah aspek-aspek utama dari Material Design 3:

1.  **Dynamic Color System:**

    - **Peran:** Ini adalah fitur paling menonjol dari _Material You_. Sistem ini memungkinkan aplikasi untuk secara otomatis menyesuaikan skema warnanya berdasarkan _wallpaper_ atau tema sistem operasi perangkat pengguna.
    - **Detail:** M3 memperkenalkan konsep palet warna algoritmik yang berasal dari warna utama yang dipilih pengguna (misalnya dari _wallpaper_). Warna-warna ini kemudian diperluas menjadi palet _tonal_ yang kaya (misalnya _primary_, _secondary_, _tertiary_, _error_, dan variannya) yang digunakan di seluruh UI aplikasi.
    - **Filosofi:** Menciptakan pengalaman yang lebih kohesif dan pribadi antara aplikasi dan sistem operasi.

2.  **Material 3 tokens:**

    - **Peran:** _Tokens_ adalah nilai-nilai desain yang dapat disesuaikan dan distandarisasi (seperti warna, tipografi, bentuk, elevasi, _motion_) yang mendefinisikan tampilan dan perilaku UI. M3 sangat bergantung pada sistem _token_ ini untuk konsistensi dan kemudahan kustomisasi.
    - **Detail:** Alih-alih langsung menggunakan nilai heksadesimal untuk warna atau piksel untuk ukuran, Anda akan menggunakan _token_ seperti `color.primary`, `typography.headlineLarge`, atau `shape.cornerMedium`. Ini memungkinkan perubahan skala di seluruh aplikasi dengan mengubah nilai _token_ di satu tempat.
    - **Filosofi:** Mempermudah penskalaan desain, memungkinkan perubahan tema yang cepat, dan memastikan konsistensi desain di seluruh aplikasi.

3.  **Color roles dan usage:**

    - **Peran:** M3 mendefinisikan serangkaian _peran_ warna yang jelas (misalnya `primary`, `onPrimary`, `primaryContainer`, `onPrimaryContainer`, `secondary`, dll.) yang harus dipatuhi.
    - **Detail:** Setiap peran memiliki tujuan spesifik:
      - `primary`: Warna utama merek Anda.
      - `onPrimary`: Warna untuk konten yang diletakkan di atas `primary` (agar terbaca).
      - `primaryContainer`: Warna untuk elemen _container_ yang menonjol.
      - `onPrimaryContainer`: Warna untuk konten di atas `primaryContainer`.
      - Siklus ini berulang untuk `secondary`, `tertiary`, dan `error` _roles_.
    - **Penggunaan:** Memisahkan _makna_ warna dari _nilai_ warnanya, membuatnya lebih mudah untuk menerapkan _dynamic color_ dan tema yang konsisten.
    - **Filosofi:** Memberikan struktur yang kuat untuk sistem warna, memastikan aksesibilitas dan adaptasi tema.

4.  **Typography scale M3:**

    - **Peran:** M3 memperkenalkan skala tipografi yang disederhanakan dan lebih ekspresif dengan nama-nama yang intuitif.
    - **Detail:** Skala ini mencakup `display`, `headline`, `title`, `body`, dan `label` dengan varian `large`, `medium`, `small` di masing-masingnya. Misalnya, `displayLarge`, `headlineMedium`, `bodySmall`.
    - **Penggunaan:** Memungkinkan Anda memilih gaya teks yang tepat untuk berbagai hierarki informasi dan konteks, tanpa perlu banyak kustomisasi font secara manual.
    - **Filosofi:** Meningkatkan keterbacaan, hierarki visual, dan ekspresivitas tipografi.

5.  **Elevation dan shadows M3:**

    - **Peran:** Model elevasi dan bayangan di M3 telah disederhanakan dan lebih menekankan pada cahaya ambien.
    - **Detail:** Alih-alih bayangan berlapis yang kompleks, M3 menggunakan campuran warna `surface` dan `primary` untuk menciptakan efek elevasi yang lebih halus dan adaptif terhadap tema dinamis. Semakin tinggi elevasi, semakin besar tintanya.
    - **Penggunaan:** Memberikan kesan kedalaman dan hierarki visual antar elemen UI.
    - **Filosofi:** Menciptakan tampilan yang lebih bersih, modern, dan terintegrasi dengan sistem warna dinamis.

6.  **Component variants M3:**

    - **Peran:** Banyak _Material Components_ telah diperbarui di M3 dengan varian baru yang lebih ekspresif, seringkali dengan bentuk yang lebih membulat dan visual yang lebih berani.
    - **Detail:** Contohnya termasuk `FilledButton`, `ElevatedButton`, `OutlinedButton` yang memiliki tampilan berbeda, _Card_ dengan bentuk yang lebih bervariasi, `NavigationBar` (pengganti `BottomNavigationBar` yang lebih fleksibel), dan banyak lagi.
    - **Penggunaan:** Memberikan _developer_ lebih banyak pilihan untuk mengekspresikan merek dan tujuan aplikasi melalui komponen.
    - **Filosofi:** Meningkatkan ekspresivitas dan fleksibilitas visual komponen, selaras dengan estetika _Material You_.

7.  **Migration dari M2 ke M3:**

    - **Peran:** Memandu _developer_ dalam memperbarui aplikasi yang sudah ada dari Material Design 2 ke Material Design 3.
    - **Detail:** Proses migrasi melibatkan pembaruan `ThemeData` untuk menggunakan properti M3, mengganti _widget_ M2 lama dengan varian M3 baru, dan menyesuaikan sistem warna serta tipografi. `useMaterial3: true` di `ThemeData` adalah langkah pertama.
    - **Filosofi:** Memfasilitasi adopsi M3 sambil meminimalkan upaya migrasi.

**Sintaks/Contoh Implementasi (Pengaturan Dasar M3):**

Untuk mengaktifkan Material Design 3 di aplikasi _Flutter_ Anda, perubahan utamanya ada di `ThemeData`:

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
      title: 'Material 3 Demo',
      theme: ThemeData(
        useMaterial3: true, // AKTIFKAN MATERIAL 3 DI SINI!
        // Di bawah ini adalah contoh bagaimana warna akan bereaksi dengan M3
        // Jika Anda memiliki Dynamic Color (di Android 12+), ini akan diabaikan.
        // Jika tidak, ini akan menjadi dasar tema Anda.
        colorSchemeSeed: Colors.deepPurple, // Warna dasar yang akan digunakan M3 untuk membuat skema warna
        brightness: Brightness.light, // Tema terang
        // Atur properti M3 lainnya sesuai kebutuhan (misalnya shape, typography)
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer, // Menggunakan warna dari skema M3
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
        // Contoh tipografi M3:
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.normal),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ),
      darkTheme: ThemeData( // Contoh tema gelap M3
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        // Properti tema gelap lainnya
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengakses ColorScheme M3
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 App'),
        // AppBar secara otomatis akan mengikuti tema warna M3
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Selamat Datang di Material 3!',
                style: textStyles.headlineMedium, // Menggunakan skala tipografi M3
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Contoh Button M3
              FilledButton(
                onPressed: () {},
                child: const Text('Filled Button'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Elevated Button'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Outlined Button'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: const Text('Text Button'),
              ),
              const SizedBox(height: 20),
              Card( // Card akan mengadopsi bentuk dan elevasi M3
                color: colors.surfaceVariant, // Warna permukaan varian dari M3
                elevation: 1.0, // Elevasi M3 yang lebih halus
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Ini adalah Card dengan gaya Material 3.',
                    style: textStyles.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Contoh penggunaan warna dari ColorScheme M3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    color: colors.primary,
                    child: Center(child: Text('P', style: TextStyle(color: colors.onPrimary))),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    color: colors.secondary,
                    child: Center(child: Text('S', style: TextStyle(color: colors.onSecondary))),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    color: colors.tertiary,
                    child: Center(child: Text('T', style: TextStyle(color: colors.onTertiary))),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    color: colors.error,
                    child: Center(child: Text('E', style: TextStyle(color: colors.onError))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      // Bottom navigation bar M3 variant: NavigationBar
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: colors.onSurfaceVariant),
            selectedIcon: Icon(Icons.home_filled, color: colors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline, color: colors.onSurfaceVariant),
            selectedIcon: Icon(Icons.favorite, color: colors.primary),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: colors.onSurfaceVariant),
            selectedIcon: Icon(Icons.settings, color: colors.primary),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: (int index) {
          // Handle navigation
        },
      ),
    );
  }
}
```

**Visualisasi Konseptual (Adaptasi Warna Dinamis):**

```
[Sistem Operasi (misal Android 12+)]
   └── Wallpaper / Tema Pengguna (misal: Warna Ungu)
       │
       ▼
[Flutter App (dengan useMaterial3: true)]
   └── ThemeData (colorSchemeSeed: Colors.deepPurple)
       │
       ▼
   Material 3 Dynamic Color System
       │
       ▼
   [Generated ColorScheme M3]
   ├── primary (ungu tua)
   ├── onPrimary (putih/kontras)
   ├── primaryContainer (ungu muda)
   ├── onPrimaryContainer (ungu tua)
   ├── secondary (aksen sekunder dari ungu)
   ├── tertiary (aksen tersier)
   └── ... (semua color roles lainnya)
       │
       ▼
   [UI Komponen Aplikasi]
   ├── AppBar (menggunakan primaryContainer)
   ├── Buttons (menggunakan primary/secondary/tertiary)
   ├── Card (menggunakan surfaceVariant)
   └── Text (menggunakan onPrimary/onSurface, dll.)
```

**Terminologi Esensial:**

- **Material Design 3 (M3) / Material You:** Versi terbaru dari sistem desain Material Design yang fokus pada personalisasi.
- **Dynamic Color:** Kemampuan aplikasi untuk secara otomatis menyesuaikan skema warnanya berdasarkan _wallpaper_ atau tema sistem perangkat.
- **Color Roles:** Penamaan standar untuk penggunaan warna dalam UI (misalnya `primary`, `onPrimary`, `surface`, `onSurface`, dll.).
- **Tokens:** Nilai desain yang dapat disesuaikan (warna, tipografi, bentuk) yang digunakan untuk mendefinisikan tampilan UI.
- **ColorScheme:** Kelas di _Flutter_ yang mendefinisikan palet warna lengkap untuk tema Material Design 3.
- **NavigationBar:** _Widget_ navigasi dasar baru di M3, pengganti modern untuk `BottomNavigationBar`.

**Struktur Internal (Mini-DAFTAR ISI):**

- Pengantar Material Design 3
- Sistem Warna Dinamis
- _Material 3 Tokens_ dan _Color Roles_
- Skala Tipografi M3
- Elevasi dan Bayangan M3
- Varian Komponen M3
- Migrasi M2 ke M3

**Hubungan dengan Bagian Lain:**

- **Material Components:** M3 adalah evolusi dari Material Components. _Widget_ yang sama (seperti `Button`, `Card`, `AppBar`) akan memiliki tampilan dan perilaku M3 ketika `useMaterial3: true` diaktifkan.
- **Custom Widget Development:** Saat membuat _widget_ kustom, Anda dapat sepenuhnya memanfaatkan `ColorScheme` dan `TextTheme` dari M3 untuk memastikan _widget_ Anda terintegrasi dengan mulus ke dalam tema aplikasi secara keseluruhan.
- **Responsif UI & Adaptasi Platform:** M3 mendukung adaptasi ke berbagai ukuran layar dan preferensi pengguna (mode terang/gelap, tema dinamis).

**Referensi Lengkap:**

- [Material Design 3 Guidelines](https://m3.material.io/): Panduan resmi dan terlengkap dari Google tentang Material Design 3. Ini adalah sumber daya yang wajib Anda baca untuk memahami filosofi dan implementasi.
- [Material You in Flutter](https://medium.com/flutter/material-3-in-flutter-f84e4a5b9d4c): Artikel Medium resmi Flutter yang membahas implementasi Material 3 di Flutter.
- [What's New in Material 3 for Flutter](https://docs.flutter.dev/release/breaking-changes/material-3): Dokumentasi perubahan dan fitur baru Material 3 di Flutter.

**Tips & Best Practices (untuk peserta):**

- **Aktifkan M3 Sejak Awal:** Jika Anda memulai proyek baru, selalu aktifkan `useMaterial3: true` di `ThemeData` Anda dari awal. Ini akan sangat memudahkan Anda dalam jangka panjang.
- **Gunakan `ColorScheme`:** Daripada menentukan warna secara _hardcode_, selalu akses warna dari `Theme.of(context).colorScheme` (misalnya `Theme.of(context).colorScheme.primary`). Ini memastikan aplikasi Anda akan merespons tema dinamis atau kustom yang Anda atur.
- **Eksplorasi Varian Komponen:** Luangkan waktu untuk melihat dan menggunakan varian komponen M3 yang baru (misalnya `FilledButton`, `NavigationBar`).

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mengaktifkan `useMaterial3: true` tetapi UI tidak berubah seperti yang diharapkan (misalnya tombol masih terlihat seperti M2).
  - **Solusi:** Pastikan Anda menggunakan _widget_ `MaterialApp` dan bahwa _widget_ _container_ Anda (seperti `Scaffold`) juga berada di bawah `MaterialApp`. Kadang, beberapa properti _widget_ perlu diatur ulang agar mengikuti tema M3 (misalnya `AppBarTheme` di `ThemeData`). Pastikan juga tidak ada properti _hardcoded_ di _widget_ individual yang menimpa tema.
- **Kesalahan:** Warna _dynamic color_ tidak berfungsi di perangkat Android.
  - **Solusi:** _Dynamic Color_ hanya tersedia secara otomatis pada perangkat Android 12 (API level 31) ke atas. Selain itu, Anda perlu memastikan aplikasi Anda menggunakan _theme_ yang tepat (misalnya `Theme.of(context).colorScheme.primary`) dan tidak menimpa warna secara _hardcode_.
- **Kesalahan:** Menggunakan `BottomNavigationBar` di M3, padahal `NavigationBar` lebih direkomendasikan.
  - **Solusi:** `BottomNavigationBar` masih berfungsi di M3, tetapi `NavigationBar` adalah _widget_ yang diperbarui dan direkomendasikan untuk pengalaman M3 yang lebih baik, dengan estetika visual dan fungsionalitas yang lebih selaras dengan pedoman M3.

---

Dengan ini, kita telah menyelesaikan pembahasan mendalam tentang **Material Design 3 (Material You)** Anda sekarang memiliki pemahaman yang kuat tentang bagaimana membangun aplikasi _Flutter_ yang modern dan adaptif dengan estetika Material Design terbaru.

Berikutnya kita akan menjelajahi Material Design, ini juga termasuk pembaruan Material Design 3 yang berfokus pada personalisasi dan adaptasi Android, kini saatnya kita beralih ke sisi lain spektrum desain: **Cupertino (iOS) Design**. _Flutter_ menawarkan serangkaian _widget_ yang secara khusus meniru tampilan dan nuansa aplikasi iOS, memungkinkan Anda untuk membangun aplikasi yang terasa _native_ di ekosistem Apple.

---

### **3.1 Material Design Implementation (Lanjutan)**

##### **Cupertino (iOS) Design**

**Deskripsi Detail & Peran:**
_Cupertino Design_ adalah implementasi pedoman desain _Human Interface Guidelines_ (HIG) dari Apple untuk platform iOS. _Flutter_ menyediakan satu set _widget_ yang dinamakan _Cupertino widgets_ yang secara visual dan perilaku meniru komponen UI iOS. Ini sangat penting jika Anda ingin aplikasi Anda memiliki tampilan dan nuansa yang akrab bagi pengguna iPhone dan iPad, atau jika Anda mengembangkan aplikasi yang secara spesifik menargetkan pasar iOS dengan estetika yang konsisten.

**Konsep Kunci & Filosofi:**
Filosofi inti _Cupertino Design_ adalah **"clarity"**, **"deference"**, dan **"depth"**. Ini menekankan pada desain minimalis, penggunaan ruang putih yang efektif, tipografi yang bersih, dan transisi yang halus untuk menciptakan pengalaman pengguna yang intuitif dan mudah dipahami. _Cupertino widgets_ di _Flutter_ berusaha untuk meniru estetika ini, memastikan aplikasi Anda terasa _native_ di perangkat iOS.

Berikut adalah komponen-komponen utama dalam _Cupertino Design_:

1.  **`CupertinoApp` structure:**

    - **Peran:** Ini adalah _widget_ _root_ untuk aplikasi yang ingin mengadopsi tampilan dan nuansa iOS secara keseluruhan. Ini mirip dengan `MaterialApp` tetapi dirancang untuk gaya Cupertino.
    - **Detail:** `CupertinoApp` menyediakan konfigurasi dasar seperti navigasi, tema, dan lokal untuk aplikasi bergaya iOS. Menggunakannya akan membuat _widget-widget_ _Cupertino_ berperilaku dan terlihat konsisten dengan iOS.
    - **Filosofi:** Menyiapkan fondasi yang tepat untuk pengalaman pengguna iOS yang otentik.

    <!-- end list -->

    ```
    CupertinoApp
    └── CupertinoPageScaffold / CupertinoTabScaffold
        └── (Cupertino Widgets)
    ```

2.  **`CupertinoNavigationBar`:**

    - **Peran:** Bilah navigasi di bagian atas layar untuk aplikasi iOS. Mirip dengan `AppBar` di Material Design, tetapi dengan estetika dan perilaku iOS yang khas (misalnya, judul yang memudar saat digulir, tombol kembali otomatis).
    - **Properti Kunci:**
      - `leading`, `middle`, `trailing`: Slot untuk _widget_ di kiri, tengah (judul), dan kanan bilah navigasi.
      - `border`: Garis batas bawah bilah navigasi.
      - `backgroundColor`: Warna latar belakang bilah.
      - `previousPageTitle`: Digunakan untuk menampilkan judul halaman sebelumnya di tombol kembali.
    - **Filosofi:** Menyediakan navigasi yang jelas dan konsisten dengan sentuhan iOS.

    <!-- end list -->

    ```
    CupertinoNavigationBar
    ├── leading (e.g., CupertinoBackButton)
    ├── middle (e.g., Text for Title)
    └── trailing (e.g., CupertinoButton for Actions)
    ```

3.  **`CupertinoTabScaffold`:**

    - **Peran:** Sebuah _widget_ yang mengimplementasikan struktur aplikasi berbasis tab ala iOS, dengan bar tab di bagian bawah layar.
    - **Detail:** Ini mengelola beberapa _tab_ dan menjaga _state_ dari setiap _tab_ saat beralih. Setiap _tab_ memiliki `CupertinoTabView` sendiri yang mengelola _stack_ navigasinya.
    - **Properti Kunci:**
      - `tabBar`: `CupertinoTabBar` yang ditampilkan di bagian bawah.
      - `tabBuilder`: Sebuah fungsi yang membangun konten untuk setiap _tab_.
    - **Filosofi:** Menyediakan navigasi tingkat atas yang mudah diakses dan konsisten di iOS.

    <!-- end list -->

    ```
    CupertinoTabScaffold
    ├── CupertinoTabBar (Bottom)
    │   └── List of BottomNavigationBarItem (Icon, Label)
    └── CupertinoTabView (for each tab's content/navigation)
        └── ...
    ```

4.  **`CupertinoPageScaffold`:**

    - **Peran:** Kerangka _layout_ dasar untuk satu halaman di aplikasi Cupertino, yang mencakup `CupertinoNavigationBar` di bagian atas dan _body_ utama.
    - **Detail:** Ini adalah analog `Scaffold` untuk Material Design, tetapi dengan komponen-komponen Cupertino.
    - **Properti Kunci:**
      - `navigationBar`: Sebuah `CupertinoNavigationBar`.
      - `child`: Konten utama halaman.
      - `backgroundColor`: Warna latar belakang halaman.
      - `resizeToAvoidBottomInset`: Mengontrol apakah _body_ harus mengubah ukurannya untuk menghindari _keyboard_.
    - **Filosofi:** Menyediakan struktur halaman tunggal yang sesuai dengan pedoman iOS.

    <!-- end list -->

    ```
    CupertinoPageScaffold
    ├── navigationBar (CupertinoNavigationBar)
    └── child (Main content Widget Tree)
    ```

5.  **iOS-style dialogs dan action sheets:**

    - **Peran:** Dialog dan _action sheets_ yang meniru tampilan dan perilaku sistem iOS, penting untuk memberikan umpan balik atau meminta input pengguna secara _native_.
    - **`CupertinoAlertDialog`:** Mirip dengan `AlertDialog`, tetapi dengan gaya iOS yang lebih halus dan tombol aksi di bagian bawah.
    - **`CupertinoActionSheet`:** Sebuah _popup_ yang muncul dari bagian bawah layar, menawarkan serangkaian opsi yang dapat diklik. Umum digunakan untuk tindakan kontekstual atau pilihan.
    - **Penggunaan:** Ditampilkan menggunakan `showCupertinoDialog` atau `showCupertinoModalPopup`.
    - **Filosofi:** Memberikan interaksi _native_ untuk peringatan dan pilihan penting.

6.  **Cupertino form components:**

    - **Peran:** Serangkaian _widget_ input formulir yang dirancang agar terlihat dan berperilaku seperti kontrol formulir standar iOS.
    - **Contoh:**
      - `CupertinoTextField`: Bidang teks input dengan gaya iOS.
      - `CupertinoSwitch`: Tombol _toggle_ gaya iOS.
      - `CupertinoSlider`: Slider gaya iOS.
      - `CupertinoSegmentedControl`: Kontrol tersegmentasi gaya iOS.
      - `CupertinoPicker` dan `CupertinoDatePicker`: Pemilih nilai dan tanggal/waktu gaya iOS.
    - **Filosofi:** Menyediakan elemen formulir yang familiar bagi pengguna iOS, meningkatkan konsistensi pengalaman.

7.  **`Cupertino Widgets` (Umum):**

    - Secara keseluruhan, _Flutter_ menyediakan berbagai _widget_ Cupertino lainnya, seperti `CupertinoButton`, `CupertinoActivityIndicator`, `CupertinoScrollbar`, dll., yang semuanya dirancang untuk mencerminkan estetika dan fungsionalitas iOS.

8.  **iOS Human Interface Guidelines (HIG):**

    - **Peran:** Ini adalah panduan desain resmi dari Apple yang menjelaskan prinsip-prinsip desain, komponen UI, ikonografi, dan perilaku yang diharapkan dari aplikasi iOS.
    - **Detail:** Meskipun _Flutter_ menyediakan _widget_ Cupertino, memahami HIG sangat penting untuk membuat keputusan desain yang tepat dan memastikan aplikasi Anda terasa _native_, bahkan di luar komponen visual.
    - **Filosofi:** Mengkomunikasikan standar kualitas dan konsistensi yang diharapkan oleh Apple dari semua aplikasi di platform mereka.

9.  **Platform Adaptive Design:**

    - **Peran:** Konsep ini membahas bagaimana membangun aplikasi yang dapat beradaptasi secara cerdas dengan platform di mana aplikasi tersebut dijalankan (Android atau iOS).
    - **Detail:** Anda dapat menggunakan `Theme.of(context).platform` atau `defaultTargetPlatform` dari `package:flutter/foundation.dart` untuk mendeteksi platform dan kemudian secara kondisional merender _Material widgets_ atau _Cupertino widgets_.
    - **Contoh:** Menggunakan `if (Theme.of(context).platform == TargetPlatform.iOS) { return CupertinoButton(...) } else { return ElevatedButton(...) }`
    - **Filosofi:** Menciptakan pengalaman _native_ yang optimal di kedua platform dari satu basis kode.

**Sintaks/Contoh Implementasi Lengkap:**

```dart
import 'package:flutter/cupertino.dart'; // Import khusus untuk widget Cupertino
import 'package:flutter/material.dart'; // Masih bisa diimport untuk fungsi dasar atau MaterialApp

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan CupertinoApp sebagai root untuk aplikasi bergaya iOS
    return const CupertinoApp(
      title: 'Cupertino Design Demo',
      home: CupertinoHomeScreen(),
      debugShowCheckedModeBanner: false, // Untuk menyembunyikan banner debug
    );
  }
}

class CupertinoHomeScreen extends StatefulWidget {
  const CupertinoHomeScreen({super.key});

  @override
  State<CupertinoHomeScreen> createState() => _CupertinoHomeScreenState();
}

class _CupertinoHomeScreenState extends State<CupertinoHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      // 1. CupertinoTabBar (untuk navigasi bawah)
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      // 2. Tab Builder untuk setiap tab (CupertinoTabView)
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return const HomePage();
              case 1:
                return const SettingsPage();
              case 2:
                return const ProfilePage();
              default:
                return const Center(child: Text('Halaman tidak ditemukan'));
            }
          },
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _showCupertinoAlert(BuildContext context) async {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) => CupertinoAlertDialog(
        title: const Text('Peringatan iOS'),
        content: const Text('Ini adalah contoh Cupertino Alert Dialog.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true, // Untuk teks aksi yang destruktif (merah)
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Oke'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCupertinoActionSheet(BuildContext context) async {
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext popupContext) => CupertinoActionSheet(
        title: const Text('Pilih Opsi'),
        message: const Text('Ini adalah contoh Cupertino Action Sheet.'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(popupContext, 'Opsi 1');
            },
            child: const Text('Opsi Satu'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(popupContext, 'Opsi 2');
            },
            child: const Text('Opsi Dua'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(popupContext, 'Batal');
          },
          child: const Text('Batal'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // 3. CupertinoNavigationBar
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Home Page'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            _showCupertinoAlert(context);
          },
          child: const Icon(CupertinoIcons.info),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Selamat Datang di Aplikasi iOS!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // 4. Contoh Cupertino Button
            CupertinoButton.filled(
              onPressed: () {
                _showCupertinoAlert(context);
              },
              child: const Text('Tampilkan Alert iOS'),
            ),
            const SizedBox(height: 10),
            CupertinoButton(
              onPressed: () {
                _showCupertinoActionSheet(context);
              },
              child: const Text('Tampilkan Action Sheet iOS'),
            ),
            const SizedBox(height: 20),
            // 5. Contoh Cupertino Form Component: Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Aktifkan Notifikasi'),
                CupertinoSwitch(
                  value: true, // Anda bisa menggunakan state di sini
                  onChanged: (bool value) {
                    // Handle perubahan switch
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Contoh Cupertino Form Component: TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: CupertinoTextField(
                placeholder: 'Masukkan Teks Disini',
                clearButtonMode: OverlayVisibilityMode.editing,
                keyboardType: TextInputType.text,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.lightBackgroundGray),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Halaman Pengaturan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Contoh Cupertino Activity Indicator
            const CupertinoActivityIndicator(
              radius: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Profile'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Halaman Profil',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: () {
                // Contoh penggunaan date picker
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                      height: MediaQuery.of(context).copyWith().size.height / 3,
                      color: CupertinoColors.systemBackground.resolveFrom(context),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (DateTime newDateTime) {
                          print(newDateTime);
                        },
                      ),
                    );
                  },
                );
              },
              child: const Text('Pilih Tanggal Lahir'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Visualisasi Konseptual (Struktur Aplikasi Cupertino):**

```
CupertinoApp
└── CupertinoTabScaffold
    ├── CupertinoTabBar (Bottom Navigation)
    │   ├── Tab 1 Icon & Label (Home)
    │   ├── Tab 2 Icon & Label (Settings)
    │   └── Tab 3 Icon & Label (Profile)
    └── CupertinoTabView (Per Tab)
        ├── TabView 1 (Home)
        │   └── CupertinoPageScaffold
        │       ├── CupertinoNavigationBar (Home Title, Info Button)
        │       └── Child (Page Content: Buttons, Form fields)
        ├── TabView 2 (Settings)
        │   └── CupertinoPageScaffold
        │       ├── CupertinoNavigationBar (Settings Title)
        │       └── Child (Page Content: Activity Indicator)
        └── TabView 3 (Profile)
            └── CupertinoPageScaffold
                ├── CupertinoNavigationBar (Profile Title)
                └── Child (Page Content: Date Picker)
```

**Terminologi Esensial:**

- **Cupertino Widgets:** Sekumpulan _widget_ di _Flutter_ yang meniru tampilan dan nuansa komponen UI iOS.
- **CupertinoApp:** _Root widget_ untuk aplikasi bergaya iOS.
- **CupertinoNavigationBar:** Bilah navigasi atas gaya iOS.
- **CupertinoTabScaffold:** Struktur aplikasi berbasis tab gaya iOS.
- **CupertinoPageScaffold:** Kerangka _layout_ untuk satu halaman gaya iOS.
- **CupertinoAlertDialog:** Dialog peringatan gaya iOS.
- **CupertinoActionSheet:** Lembar aksi (menu pop-up) gaya iOS yang muncul dari bawah.
- **iOS Human Interface Guidelines (HIG):** Pedoman desain resmi Apple untuk aplikasi iOS.
- **Platform Adaptive Design:** Strategi pengembangan untuk membuat aplikasi yang beradaptasi secara otomatis dengan platform (Android/iOS) di mana ia berjalan.

**Struktur Internal (Mini-DAFTAR ISI):**

- Pengantar Desain Cupertino
- Struktur Aplikasi Cupertino (`CupertinoApp`, `CupertinoPageScaffold`, `CupertinoTabScaffold`)
- Komponen Navigasi (`CupertinoNavigationBar`, `CupertinoTabBar`)
- Dialog dan Lembar Aksi Gaya iOS
- Komponen Formulir Cupertino
- Pentingnya iOS HIG
- Strategi Desain Adaptif Platform

**Hubungan dengan Bagian Lain:**

- **Material Components:** Desain Cupertino adalah alternatif dari Material Design. Anda akan memilih salah satu atau mengimplementasikan desain adaptif untuk mendukung keduanya.
- **Widget Tree & Rendering Engine:** Memahami bagaimana _widget_ Cupertino dibangun dan di-_render_ membantu dalam mengkustomisasi atau memecahkan masalah.
- **Layout System Mastery:** Prinsip-prinsip _layout_ dasar tetap berlaku, tetapi _widget_ Cupertino menyediakan implementasi yang spesifik untuk gaya iOS.

**Referensi Lengkap:**

- [Cupertino Widgets](https://flutter.dev/docs/development/ui/widgets/cupertino): Dokumentasi resmi semua _Cupertino widgets_.
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/): Panduan desain resmi Apple. Ini adalah sumber penting untuk memahami filosofi di balik desain iOS.
- [Platform Adaptive Design](https://flutter.dev/docs/development/ui/layout/adaptive-responsive): Dokumentasi Flutter tentang bagaimana membangun aplikasi yang adaptif untuk berbagai platform.

**Tips & Best Practices (untuk peserta):**

- **Pilih Tema dengan Jelas:** Putuskan apakah Anda akan membuat aplikasi yang murni Material, murni Cupertino, atau adaptif. Ini akan memandu pilihan _widget_ _root_ Anda (`MaterialApp` atau `CupertinoApp`).
- **Gunakan Paket Tambahan untuk HIG:** Untuk beberapa komponen iOS yang kompleks atau sangat spesifik, Anda mungkin perlu mencari paket dari `pub.dev` jika _Flutter_ tidak menyediakan implementasi _native_ langsung.
- **Perhatikan Perilaku:** Selain tampilan, pastikan perilaku _widget_ Anda juga sesuai dengan harapan pengguna iOS (misalnya _scrolling physics_, transisi navigasi).

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menggunakan `CupertinoApp` tetapi mengharapkan _Material widgets_ berfungsi penuh secara default atau sebaliknya.
  - **Solusi:** `CupertinoApp` menyediakan tema dan perilaku untuk _Cupertino widgets_. Jika Anda mencampuradukkan `Material widgets` di dalamnya, mereka mungkin tidak terlihat atau berperilaku sebagaimana mestinya. Gunakan `MaterialApp` jika mayoritas UI Anda adalah Material, atau gunakan desain adaptif.
- **Kesalahan:** Kesulitan dalam mengelola navigasi di `CupertinoTabView`.
  - **Solusi:** Setiap `CupertinoTabView` memiliki `Navigator` sendiri. Pahami bahwa `Navigator.of(context)` di dalam satu _tab_ hanya akan memengaruhi _stack_ navigasi _tab_ tersebut. Untuk navigasi antar _tab_, gunakan `CupertinoTabController`.
- **Kesalahan:** Tombol kembali di `CupertinoNavigationBar` tidak muncul.
  - **Solusi:** Tombol kembali akan muncul secara otomatis jika ada _route_ sebelumnya di _stack_ navigasi yang dapat di-_pop_. Pastikan Anda menggunakan `CupertinoPageRoute` untuk navigasi antar halaman, atau tambahkan `leading` _widget_ kustom jika tidak ada _route_ sebelumnya.

# Selamat!

Anda telah menyelesaikan pembahasan mendalam tentang **Material Components**. Ini adalah landasan utama untuk membangun antarmuka pengguna yang sesuai dengan pedoman Material Design. Pada **Cupertino (iOS) Design** kita telah memahami bagaimana membuat aplikasi _Flutter_ Anda terasa _native_ di perangkat iOS.

Setelah membahas berbagai komponen UI bawaan Material Design dan Cupertino, kini saatnya kita melangkah lebih jauh dan belajar bagaimana membangun _widget_ kustom Anda sendiri. Kemampuan untuk membuat _widget_ kustom adalah inti dari fleksibilitas _Flutter_, memungkinkan Anda untuk merancang UI apa pun yang dapat Anda bayangkan.

---

### **3.2 Custom Widget Development**

##### **Creating Custom Widgets**

**Deskripsi Detail & Peran:**
_Creating Custom Widgets_ adalah proses mendefinisikan _widget_ baru yang sesuai dengan kebutuhan spesifik aplikasi Anda. Meskipun _Flutter_ menyediakan banyak _widget_ bawaan, seringkali Anda perlu mengombinasikannya atau membuat elemen UI yang unik yang tidak ada di perpustakaan standar. Bagian ini akan mengajarkan Anda prinsip-prinsip dan praktik terbaik untuk membangun _widget_ kustom Anda sendiri, baik itu `StatelessWidget` sederhana atau `StatefulWidget` yang lebih kompleks.

**Konsep Kunci & Filosofi:**
Filosofi utama di balik pengembangan _widget_ kustom di _Flutter_ adalah **komposisi**. Alih-alih mewarisi dari _widget_ yang sudah ada dan mengubah perilakunya (walaupun kadang diperlukan), Anda akan sering kali _menggabungkan_ beberapa _widget_ yang lebih kecil dan sederhana menjadi _widget_ yang lebih besar dan kompleks. Ini menghasilkan kode yang lebih modular, _reusable_, dan mudah di-_maintain_.

Berikut adalah aspek-aspek utama dalam membuat _widget_ kustom:

1.  **Composition vs Inheritance Approach:**

    - **Komposisi (Composition):**
      - **Peran:** Ini adalah pendekatan yang paling umum dan direkomendasikan di _Flutter_. Anda membangun _widget_ kustom dengan menggabungkan (mengompilasi) _widget-widget_ yang lebih kecil yang sudah ada.
      - **Detail:** Sebuah _widget_ kustom akan memiliki `build` _method_ yang mengembalikan sebuah _widget tree_ yang terdiri dari _widget_ bawaan atau _widget_ kustom lainnya. Ini seperti membangun rumah dari batu bata yang sudah jadi.
      - **Keuntungan:** Fleksibilitas tinggi, kode modular, mudah dibaca, dan mudah diuji. Perubahan pada satu komponen tidak terlalu memengaruhi komponen lain.
    - **Pewarisan (Inheritance):**
      - **Peran:** Meskipun tidak sepopuler komposisi untuk membangun UI biasa, pewarisan tetap penting untuk _widget_ fundamental tertentu (misalnya, membuat _widget_ seperti `InheritedWidget` atau `RenderObjectWidget` Anda sendiri).
      - **Detail:** Anda akan memperluas (mewarisi dari) kelas _widget_ yang sudah ada dan menimpa _method_ serta propertinya.
      - **Penggunaan:** Lebih jarang untuk _widget_ UI tingkat aplikasi, tetapi krusial untuk _framework extension_ atau _widget_ yang sangat fundamental.
    - **Filosofi:** **"Favor composition over inheritance"** adalah prinsip desain perangkat lunak umum yang sangat relevan di _Flutter_.

2.  **`StatelessWidget` Custom Widgets:**

    - **Peran:** Membuat _widget_ kustom yang tidak memiliki _state_ yang berubah sepanjang siklus hidupnya. Semua datanya bersifat final dan disediakan saat _widget_ dibuat.
    - **Detail:** Anda perlu memperluas kelas `StatelessWidget` dan menimpa _method_ `build(BuildContext context)`. _Method_ `build` ini akan mengembalikan _widget tree_ yang mewakili UI _widget_ kustom Anda.
    - **Kapan Digunakan:** Untuk elemen UI yang statis atau hanya merespons input eksternal (data yang diteruskan melalui konstruktor) tanpa menyimpan _state_ internalnya sendiri. Contoh: `Text`, `Icon`, `Container` sederhana.

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

    - **Peran:** Membuat _widget_ kustom yang memiliki _state_ yang dapat berubah sepanjang siklus hidupnya, dan UI-nya diperbarui untuk merefleksikan perubahan _state_ tersebut.
    - **Detail:** Anda perlu memperluas kelas `StatefulWidget` dan menimpa _method_ `createState()`, yang akan mengembalikan sebuah objek `State`. Objek `State` inilah yang akan menyimpan data yang dapat berubah dan memiliki _method_ `build(BuildContext context)` untuk merender UI. Perubahan _state_ dipicu oleh `setState()`.
    - **Kapan Digunakan:** Untuk elemen UI yang interaktif atau data yang berubah seiring waktu. Contoh: _Checkbox_, _Slider_, _Form fields_, _Animated widgets_.

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

    - **Peran:** Bagaimana Anda meneruskan data ke _widget_ kustom Anda dari _parent_ _widget_.
    - **Detail:** Parameter ini didefinisikan sebagai _final fields_ di dalam kelas `StatelessWidget` atau `StatefulWidget`. Untuk `StatefulWidget`, parameter ini diakses melalui properti `widget` dari objek `State` terkait (misalnya `widget.propertyName`).
    - **Praktik Terbaik:** Gunakan `required` pada parameter yang wajib dan berikan _default value_ jika parameter opsional. Gunakan `const` konstruktor jika memungkinkan untuk `StatelessWidget` atau `StatefulWidget` agar kompilasi waktu konstanta dapat dioptimalkan.
    - **Filosofi:** Membuat _widget_ Anda _reusable_ dan dapat dikonfigurasi.

5.  **Widget Testing Considerations:**

    - **Peran:** Memastikan bahwa _widget_ kustom Anda berfungsi seperti yang diharapkan dan tidak rusak oleh perubahan kode di masa mendatang.
    - **Detail:** _Flutter_ menyediakan _testing framework_ yang kuat (`flutter_test`). Anda akan menulis _widget tests_ untuk memverifikasi tampilan dan interaksi _widget_ kustom Anda.
    - **Kapan Dilakukan:** Sebaiknya tulis _widget tests_ saat Anda mengembangkan _widget_ kustom untuk memastikan keandalannya.
    - **Filosofi:** Pengembangan yang didorong oleh tes (TDD) dan jaminan kualitas.

6.  **Documentation dan Examples:**

    - **Peran:** Membuat _widget_ kustom Anda mudah dipahami dan digunakan oleh _developer_ lain (termasuk diri Anda di masa depan\!).
    - **Detail:** Gunakan _doc comments_ (komentar `///`) untuk mendeskripsikan tujuan _widget_, parameternya, dan contoh penggunaannya. Sertakan contoh kode yang jelas.
    - **Filosofi:** Kode yang terdokumentasi dengan baik sama pentingnya dengan kode yang berfungsi.

7.  **Building Custom Widgets (Proses Umum):**

    - **Langkah 1: Identifikasi Kebutuhan:** Apa yang harus dilakukan _widget_ ini? Data apa yang dibutuhkannya? Apakah _state_-nya berubah?
    - **Langkah 2: Pilih Jenis Widget:** `StatelessWidget` atau `StatefulWidget`?
    - **Langkah 3: Desain API:** Parameter apa yang akan diterima _widget_ ini? (misalnya `text`, `onPressed`, `color`).
    - **Langkah 4: Tulis Kode `build`:** Gunakan komposisi dari _widget_ yang lebih kecil untuk membangun UI yang diinginkan.
    - **Langkah 5: Tambahkan Logika (Jika Stateful):** Kelola _state_ menggunakan `setState()` dan _lifecycle methods_.
    - **Langkah 6: Uji:** Tulis _widget tests_ untuk memastikan fungsionalitas.
    - **Langkah 7: Dokumentasikan:** Tambahkan komentar yang jelas.

**Sintaks/Contoh Implementasi Lengkap (Custom Progress Bar):**

Mari kita buat _widget_ kustom yang sederhana: `CustomProgressBar`.

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

- **Custom Widget:** _Widget_ yang Anda definisikan sendiri untuk memenuhi kebutuhan UI spesifik.
- **Composition:** Pendekatan membangun _widget_ kustom dengan menggabungkan _widget_ yang lebih kecil.
- **Inheritance:** Pendekatan membangun _widget_ kustom dengan memperluas kelas _widget_ yang sudah ada.
- **`StatelessWidget`:** _Widget_ yang tidak memiliki _state_ yang berubah.
- **`StatefulWidget`:** _Widget_ yang memiliki _state_ yang dapat berubah.
- **Widget Parameters:** Properti yang diteruskan ke _widget_ kustom melalui konstruktornya.
- **`super.key`:** Penting untuk meneruskan `key` ke _constructor_ _parent_ _widget_ untuk identifikasi yang benar dalam _widget tree_.

**Struktur Internal (Mini-DAFTAR ISI):**

- Komposisi vs Pewarisan
- Membuat `StatelessWidget` Kustom
- Membuat `StatefulWidget` Kustom
- Meneruskan Parameter ke _Widget_
- Pertimbangan Pengujian _Widget_
- Pentingnya Dokumentasi

**Hubungan dengan Bagian Lain:**

- **Widget Architecture Deep Dive:** Membangun _widget_ kustom sangat bergantung pada pemahaman `StatelessWidget` vs `StatefulWidget`, siklus hidup _widget_, dan `BuildContext`.
- **Layout System Mastery:** _Widget_ kustom Anda akan sering menggunakan _widget_ _layout_ (`Column`, `Row`, `Stack`, `Container`, dll.) untuk mengatur elemen-elemennya.
- **UI Components & Material Design:** _Widget_ kustom Anda dapat mengintegrasikan dan memperluas _Material Components_ atau _Cupertino Components_.

**Referensi Lengkap:**

- [Building Custom Widgets](https://flutter.dev/docs/development/ui/widgets/building-layouts%23building-custom-widgets): Dokumentasi resmi Flutter tentang membuat _widget_ kustom.
- [Custom Widget Best Practices](https://medium.com/flutter/the-flutter-way-creating-custom-widgets-d56ee3f114c2): Artikel Medium tentang praktik terbaik dalam membuat _widget_ kustom.
- [Composition vs Inheritance](https://www.geeksforgeeks.org/composition-vs-inheritance-in-object-oriented-programming/): Konsep pemrograman umum yang relevan di Flutter.

**Tips & Best Practices (untuk peserta):**

- **Mulai dari yang Kecil:** Selalu mulai dengan membangun _widget_ yang lebih kecil dan fungsional, lalu kombinasikan untuk membentuk _widget_ yang lebih kompleks.
- **Pisahkan Kekhawatiran:** Jika _widget_ Anda mulai menjadi terlalu besar atau kompleks, pertimbangkan untuk memisahkannya menjadi _widget_ yang lebih kecil yang memiliki tanggung jawab tunggal.
- **Pertimbangkan Kembali `StatefulWidget`:** Jika Anda merasa perlu menggunakan `StatefulWidget` hanya untuk meneruskan data ke bawah, pertimbangkan apakah `InheritedWidget` atau manajemen _state_ lainnya akan menjadi solusi yang lebih baik dan lebih efisien.
- **Gunakan `const` dengan Bijak:** Jika _widget_ atau bagian dari _widget tree_ Anda tidak akan berubah, gunakan `const` untuk membantu _Flutter_ mengoptimalkan kinerja _rendering_.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mencoba memanggil `setState()` di dalam `StatelessWidget`.
  - **Solusi:** `StatelessWidget` tidak memiliki _state_ yang dapat diubah. Jika Anda memerlukan _state_ internal, ubah _widget_ Anda menjadi `StatefulWidget`.
- **Kesalahan:** Mengakses properti `StatefulWidget` di dalam `State` _object_ tanpa menggunakan kata kunci `widget` (misalnya `initialText` alih-alih `widget.initialText`).
  - **Solusi:** Properti _widget_ diakses melalui `widget.propertyName` di dalam kelas `State` yang terkait.
- **Kesalahan:** `Hot Reload` tidak memperbarui _state_ yang diharapkan dalam `StatefulWidget`.
  - **Solusi:** `Hot Reload` hanya membangun ulang _widget tree_ dari _scratch_, tetapi _state_ itu sendiri akan dipertahankan. Jika Anda mengubah parameter _widget_ yang digunakan untuk menginisialisasi _state_ di `initState`, perubahan itu tidak akan terlihat hingga `Hot Restart`. Gunakan `didUpdateWidget` jika Anda ingin _state_ bereaksi terhadap perubahan properti dari _parent_.

# Luar biasa!

Anda telah berhasil menuntaskan pembahasan mendalam tentang **Creating Custom Widgets** di _Flutter_. Ini adalah keterampilan yang sangat memberdayakan yang akan memungkinkan Anda untuk membangun hampir semua UI yang Anda inginkan.

Setelah menjelajahi _Material Design_ dan _Cupertino Design_ dengan komponen-komponen siap pakai, kini saatnya kita melangkah lebih jauh. Kita akan masuk ke bagian yang sangat penting dan memberdayakan: **3.2 Custom Widget Development**. Di sini, Anda akan belajar bagaimana membangun _widget_ Anda sendiri dari nol, memberikan kontrol penuh atas tampilan dan perilaku UI Anda.

---

### **3.2 Custom Widget Development**

[versi kedua][1]

##### **Creating Custom Widgets**

**Deskripsi Detail & Peran:**
_Creating Custom Widgets_ adalah inti dari fleksibilitas _Flutter_. Meskipun _Flutter_ menyediakan banyak _widget_ bawaan, Anda akan sering menemukan kebutuhan untuk membuat _widget_ yang unik dan spesifik untuk aplikasi Anda. Ini memungkinkan Anda untuk mengkapsulasi logika UI yang kompleks, meningkatkan _reusability_ (penggunaan kembali), dan menjaga basis kode Anda tetap rapi serta mudah dikelola.

**Konsep Kunci & Filosofi:**
Filosofi utama di balik pengembangan _custom widget_ di _Flutter_ adalah **komposisi (composition) daripada pewarisan (inheritance)**. Ini berarti Anda lebih sering membangun _widget_ baru dengan menggabungkan (mengkomposisikan) _widget_ yang sudah ada, daripada memperluas (mewarisi) dari _widget_ yang sudah ada. Pendekatan ini menghasilkan kode yang lebih fleksibel, mudah diuji, dan lebih mudah dipahami.

Berikut adalah aspek-aspek utama dalam membuat _custom widget_:

1.  **Composition vs Inheritance approach:**

    - **Komposisi (Composition):** Ini adalah pendekatan yang paling direkomendasikan di _Flutter_. Anda membangun _widget_ baru dengan menggabungkan beberapa _widget_ yang lebih kecil dan sederhana sebagai _children_ atau properti. _Custom widget_ Anda akan berisi `Row`, `Column`, `Container`, `Text`, `Icon`, dll.
      - **Contoh:** Membuat `CustomCard` yang terdiri dari `Card`, `Column`, `Text`, dan `Image`.
      - **Kelebihan:** Kode lebih fleksibel, _reusable_, mudah diuji, dan mengurangi _coupling_ antar bagian.
    - **Pewarisan (Inheritance):** Anda akan mewarisi dari `StatelessWidget` atau `StatefulWidget` (yang merupakan bentuk pewarisan dasar untuk semua _widget_), tetapi jarang memperluas _widget_ UI spesifik lainnya seperti `Button` atau `Text` untuk mengubah perilakunya secara fundamental.
      - **Kelebihan:** Berguna untuk _widget_ dasar yang perlu mendefinisikan ulang _rendering_ atau _layout_ level rendah (ini adalah pekerjaan yang lebih kompleks dan jarang dilakukan _developer_ aplikasi).
      - **Batasan:** Dapat menghasilkan hierarki yang kaku dan sulit dikelola jika digunakan secara berlebihan untuk tujuan UI.
    - **Filosofi:** Komposisi adalah "seni" di _Flutter_. Ini memungkinkan Anda membangun UI yang kompleks dari blok-blok bangunan yang sederhana dan modular.

2.  **`StatelessWidget` custom widgets:**

    - **Peran:** Digunakan untuk _widget_ yang tidak memerlukan _state_ yang dapat berubah seiring waktu. Mereka hanya bergantung pada konfigurasi yang diberikan saat _widget_ dibuat.
    - **Implementasi:** Anda memperluas kelas `StatelessWidget` dan mengimplementasikan metode `build(BuildContext context)`. Metode `build` ini harus mengembalikan _widget tree_ yang menjelaskan UI yang akan ditampilkan oleh _widget_ kustom Anda.
    - **Contoh:** Tombol sederhana, ikon, teks statis, atau kartu dengan konten tetap.
    - **Kelebihan:** Ringan, efisien, dan mudah dipahami karena tidak ada _state_ internal yang perlu dikelola.

    <!-- end list -->

    ```
    CustomWidget (StatelessWidget)
    └── build(context) method
        └── Returns a Widget Tree (composed of other widgets)
    ```

3.  **`StatefulWidget` custom widgets:**

    - **Peran:** Digunakan untuk _widget_ yang memiliki _state_ yang dapat berubah seiring waktu atau berdasarkan interaksi pengguna.
    - **Implementasi:** Anda memperluas kelas `StatefulWidget` dan mengimplementasikan metode `createState()`, yang mengembalikan sebuah objek `State` yang terkait dengan _widget_ ini. Objek `State` inilah yang akan mengelola _state_ dan memiliki metode `build(BuildContext context)` serta metode _lifecycle_ lainnya.
    - **Contoh:** _Checkbox_, _toggle switch_, _form input_ dengan validasi dinamis, atau _widget_ yang menampilkan data yang dimuat dari jaringan.
    - **Kelebihan:** Mampu mengelola data internal yang berubah, memungkinkan interaktivitas dan UI yang dinamis.

    <!-- end list -->

    ```
    CustomWidget (StatefulWidget)
    └── createState() method
        └── Returns _CustomWidgetState
            └── _CustomWidgetState (State)
                ├── State properties (data that changes)
                ├── build(context) method
                │   └── Returns a Widget Tree (depends on state)
                └── Other lifecycle methods (initState, dispose, etc.)
    ```

4.  **Widget parameters dan configuration:**

    - **Peran:** _Custom widget_ seringkali perlu menerima data atau konfigurasi dari _parent widget_-nya. Ini dilakukan melalui _constructor_ _widget_.
    - **Implementasi:** Anda mendefinisikan _final fields_ di dalam kelas `StatelessWidget` atau `StatefulWidget` Anda. Ini adalah properti yang akan diterima oleh _widget_ saat instansiasi.
    - **Contoh:** `CustomButton({Key? key, required this.text, required this.onPressed})`.
    - **Kelebihan:** Membuat _widget_ Anda fleksibel dan _reusable_, karena dapat digunakan di berbagai konteks dengan konfigurasi yang berbeda.

5.  **Widget testing considerations:**

    - **Peran:** Menguji _custom widget_ adalah bagian penting dari proses pengembangan untuk memastikan _widget_ berfungsi seperti yang diharapkan dalam berbagai skenario.
    - **Detail:** _Flutter_ menyediakan _framework_ pengujian yang kuat (unit, _widget_, dan integrasi). Untuk _custom widget_, Anda akan sering melakukan _widget testing_ untuk memverifikasi tampilan, interaksi, dan respons terhadap perubahan _state_.
    - **Filosofi:** Pastikan _widget_ Anda kokoh dan bebas dari _bug_ sebelum diintegrasikan ke dalam aplikasi yang lebih besar.

6.  **Documentation dan examples:**

    - **Peran:** Mendokumentasikan _custom widget_ Anda sangat penting, terutama jika Anda bekerja dalam tim atau jika _widget_ tersebut akan digunakan kembali di proyek lain.
    - **Detail:** Gunakan _doc comments_ (`///`) di Dart untuk menjelaskan tujuan _widget_, properti yang diterimanya, dan bagaimana cara menggunakannya. Sertakan contoh penggunaan jika perlu.
    - **Kelebihan:** Mempermudah _developer_ lain (dan diri Anda sendiri di masa depan) untuk memahami dan menggunakan _widget_ Anda secara efektif.

7.  **Building Custom Widgets (Proses):**

    - **Identifikasi Kebutuhan:** Apa yang harus dilakukan _widget_ ini? Apa saja properti yang dibutuhkan? Apakah ia perlu _state_?
    - **Pilih Jenis Widget:** `StatelessWidget` atau `StatefulWidget`?
    - **Desain Kontraktor:** Tentukan parameter yang dibutuhkan. Gunakan `Key` untuk _widget_ yang perlu diidentifikasi secara unik atau yang berinteraksi dengan daftar dinamis.
    - **Bangun UI (Metode `build`):** Komposisikan _widget_ bawaan _Flutter_ atau _custom widget_ lainnya untuk menciptakan UI yang diinginkan.
    - **Tambahkan Logika (untuk `StatefulWidget`):** Kelola _state_ internal dan tanggapi interaksi pengguna (misalnya dengan `setState()`).
    - **Uji:** Tulis _widget tests_.
    - **Dokumentasikan:** Tambahkan _doc comments_.

**Sintaks/Contoh Implementasi Lengkap (Custom Widget):**

Mari kita buat contoh `CustomButton` (Stateless) dan `CounterWidget` (Stateful).

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
        useMaterial3: true, // Mengaktifkan Material 3
      ),
      home: const CustomWidgetScreen(),
    );
  }
}

// 1. Contoh StatelessWidget Custom Widget: CustomButton
// Widget ini tidak memiliki state internal yang berubah.
class CustomButton extends StatelessWidget {
  // Parameter (Konfigurasi) dari widget ini
  final String label;
  final VoidCallback onPressed; // VoidCallback adalah typedef untuk func tanpa argumen & return value
  final Color backgroundColor;
  final Color textColor;

  // Constructor dengan parameter yang diperlukan
  const CustomButton({
    Key? key, // Key untuk identifikasi widget, opsional
    required this.label, // Wajib diisi
    required this.onPressed, // Wajib diisi
    this.backgroundColor = Colors.blue, // Nilai default jika tidak disediakan
    this.textColor = Colors.white, // Nilai default
  }) : super(key: key); // Meneruskan key ke superclass

  @override
  Widget build(BuildContext context) {
    // Komposisi dari widget Material standar
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

// 2. Contoh StatefulWidget Custom Widget: CounterWidget
// Widget ini memiliki state internal (nilai counter) yang berubah.
class CounterWidget extends StatefulWidget {
  // StatelessWidget menerima parameter awal, tetapi StatefulWidget tidak membutuhkan
  // parameter untuk state-nya di sini, hanya untuk konfigurasi awal jika ada.
  final int initialValue;

  const CounterWidget({Key? key, this.initialValue = 0}) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

// Objek State yang terkait dengan CounterWidget
class _CounterWidgetState extends State<CounterWidget> {
  late int _counter; // Variabel state yang akan berubah

  @override
  void initState() {
    super.initState();
    // Inisialisasi state dari parameter widget
    _counter = widget.initialValue;
  }

  // Metode untuk mengubah state
  void _incrementCounter() {
    setState(() {
      _counter++; // Perubahan state
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--; // Perubahan state
    });
  }

  @override
  Widget build(BuildContext context) {
    // UI bergantung pada nilai _counter (state)
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Nilai Counter:',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _decrementCounter,
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Pastikan resource dibersihkan jika ada (misal: controller, listener)
    super.dispose();
  }
}

// Layar utama yang menggunakan Custom Widget
class CustomWidgetScreen extends StatelessWidget {
  const CustomWidgetScreen({super.key});

  void _onButtonPressed() {
    print("Tombol kustom ditekan!");
    // Dalam aplikasi nyata, ini bisa memicu navigasi, aksi data, dll.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengembangan Custom Widget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Menggunakan CustomButton
            CustomButton(
              label: 'Klik Saya!',
              onPressed: _onButtonPressed,
              backgroundColor: Colors.teal,
              textColor: Colors.yellow,
            ),
            const SizedBox(height: 30),
            // Menggunakan CounterWidget
            const CounterWidget(initialValue: 10), // Memberikan nilai awal
            const SizedBox(height: 30),
            // Contoh CustomButton lain dengan warna default
            CustomButton(
              label: 'Default Button',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Default button ditekan!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

**Visualisasi Konseptual (Komposisi Widget):**

```
CustomWidgetScreen (StatelessWidget)
└── Scaffold
    ├── AppBar
    ├── body (Center)
    │   └── Column
    │       ├── CustomButton (StatelessWidget)
    │       │   └── ElevatedButton (composed)
    │       │       └── Text (composed)
    │       ├── CounterWidget (StatefulWidget)
    │       │   └── _CounterWidgetState (State)
    │       │       └── Column (composed)
    │       │           ├── Text
    │       │           ├── Text (displaying _counter state)
    │       │           └── Row
    │       │               ├── ElevatedButton (decrement)
    │       │               └── ElevatedButton (increment)
    │       └── CustomButton (StatelessWidget)
    │           └── ElevatedButton (composed)
    │               └── Text (composed)
```

**Terminologi Esensial:**

- **Custom Widget:** _Widget_ yang Anda buat sendiri untuk kebutuhan spesifik aplikasi.
- **Komposisi (Composition):** Membangun _widget_ baru dengan menggabungkan _widget_ yang sudah ada.
- **Pewarisan (Inheritance):** Mengambil fungsionalitas dari kelas _parent_. Di _Flutter_, ini umum untuk `StatelessWidget` dan `StatefulWidget` tetapi jarang untuk _widget_ UI spesifik lainnya.
- **Widget Parameters:** Properti yang dilewatkan ke _constructor_ _widget_ untuk konfigurasinya.
- **`Key`:** Pengidentifikasi opsional untuk _widget_ yang membantu _Flutter_ mengelola _widget tree_ secara efisien, terutama dalam daftar dinamis.
- **`VoidCallback`:** _typedef_ untuk fungsi yang tidak menerima argumen dan tidak mengembalikan nilai, sering digunakan untuk _callback_ tombol.

**Struktur Internal (Mini-DAFTAR ISI):**

- Filosofi Komposisi vs Pewarisan
- Membuat `StatelessWidget` Kustom
- Membuat `StatefulWidget` Kustom
- Melewatkan Parameter ke _Widget_
- Pertimbangan Pengujian _Widget_
- Pentingnya Dokumentasi _Widget_

**Hubungan dengan Bagian Lain:**

- **Widget Tree & Rendering Engine:** Memahami bagaimana _custom widget_ Anda diintegrasikan ke dalam _widget tree_ dan bagaimana perubahan _state_ memicu _re-rendering_ sangat penting.
- **Widget Lifecycle Management:** Ini sangat relevan untuk `StatefulWidget` kustom, di mana Anda akan mengelola _state_ di dalam metode _lifecycle_ seperti `initState()` dan `dispose()`.
- **Layout System Mastery:** Saat menyusun _custom widget_, Anda akan menggunakan kembali semua _widget_ _layout_ yang sudah Anda pelajari (`Column`, `Row`, `Container`, dll.).
- **State Management:** Untuk _widget_ dengan _state_ internal yang kompleks, ini adalah langkah pertama sebelum menjelajahi solusi manajemen _state_ yang lebih canggih.

**Referensi Lengkap:**

- [Building Custom Widgets](https://flutter.dev/docs/development/ui/widgets-intro%23building-custom-widgets): Bagian dari dokumentasi resmi Flutter yang membahas pembuatan _custom widget_.
- [Custom Widget Best Practices](https://medium.com/flutter-community/flutter-custom-widget-best-practices-2022-7f9a1f2e1b1d): Artikel dari komunitas Flutter tentang praktik terbaik.
- [Composition vs Inheritance](https://blog.codemagic.io/composition-vs-inheritance-in-flutter-explained-with-examples/): Sebuah artikel yang menjelaskan perbedaan komposisi dan pewarisan di Flutter.

**Tips & Best Practices (untuk peserta):**

- **Keep It Small and Focused:** Buat _custom widget_ sekecil dan sefokus mungkin pada satu tujuan. Ini meningkatkan _reusability_ dan kemudahan pengujian.
- **Gunakan `const` Constructor:** Jika _widget_ Anda `StatelessWidget` dan semua propertinya `final`, buat *constructor*nya `const`. Ini memungkinkan _Flutter_ untuk melakukan optimasi kinerja.
- **Hindari `setState()` Berlebihan:** Di `StatefulWidget`, panggil `setState()` hanya ketika _state_ yang memengaruhi UI benar-benar berubah.
- **Gunakan `Key` dengan Bijak:** Pertimbangkan penggunaan `Key` saat Anda memiliki daftar _widget_ yang dinamis atau _widget_ yang perlu mempertahankan *state*nya ketika posisinya diubah di _tree_.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mengubah properti `final` dari `StatelessWidget` atau `StatefulWidget` dari luar _widget_.
  - **Solusi:** Properti `final` hanya dapat diatur saat _widget_ dibuat. Untuk _widget_ yang perlu berubah, gunakan `StatefulWidget` dan ubah _state_ internalnya melalui `setState()`.
- **Kesalahan:** Mencoba memanggil `setState()` di dalam `StatelessWidget`.
  - **Solusi:** `setState()` hanya tersedia di objek `State` dari `StatefulWidget`. Jika _widget_ Anda perlu mengubah UI-nya secara internal, itu harus menjadi `StatefulWidget`.
- **Kesalahan:** _Widget_ tidak memperbarui tampilan setelah data berubah.
  - **Solusi:** Pastikan Anda memanggil `setState()` setelah memodifikasi _state_ internal di `StatefulWidget`. Jika data datang dari _parent widget_ dan tidak memicu pembangunan ulang, periksa apakah *parent*nya juga memanggil `setState()` atau menggunakan _state management_ yang tepat.

---

Setelah memahami dasar-dasar pembuatan _widget_ kustom dengan `StatelessWidget` dan `StatefulWidget` serta pentingnya komposisi, kini kita akan mendalami **Widget Composition Patterns**. Ini adalah berbagai pola dan teknik yang lebih canggih untuk mengorganisir _widget_ kustom Anda, membuatnya lebih fleksibel, _reusable_, dan mudah di-_maintain_.

---

### **3.2 Custom Widget Development (Lanjutan)**

##### **Widget Composition Patterns**

**Deskripsi Detail & Peran:**
_Widget Composition Patterns_ adalah kumpulan teknik dan praktik yang memungkinkan Anda menyusun _widget_ secara lebih efektif dan modular. Ini melampaui sekadar menyatukan _widget_ menjadi satu `Column` atau `Row`, melainkan berfokus pada cara Anda merancang API _widget_, bagaimana mereka menerima dan memproses data, serta bagaimana mereka dapat diperluas atau dimodifikasi tanpa merusak desain aslinya.

**Konsep Kunci & Filosofi:**
Filosofi di balik pola komposisi adalah memaksimalkan **modularity**, **reusability**, **testability**, dan **separation of concerns**. Dengan menerapkan pola-pola ini, Anda dapat membangun _widget tree_ yang kompleks dari bagian-bagian yang lebih kecil dan independen, yang masing-masing memiliki tanggung jawab yang jelas.

Berikut adalah pola-pola komposisi _widget_ utama:

1.  **Builder Pattern untuk Widgets:**

    - **Peran:** Pola _builder_ di _Flutter_ sering digunakan untuk menunda pembuatan bagian dari _widget tree_ hingga konteks tertentu tersedia, atau untuk memungkinkan _parent widget_ menyediakan _dependency_ ke _child widget_ secara lebih fleksibel.
    - **Detail:** Anda akan sering melihat `builder` _callback_ di berbagai _widget_ (misalnya `LayoutBuilder`, `StreamBuilder`, `FutureBuilder`, `Consumer` dari Provider). _Builder_ _callback_ menerima `BuildContext` sebagai argumen, yang sangat penting karena _context_ hanya tersedia setelah _widget_ dimasukkan ke dalam _widget tree_.
    - **Keuntungan:** Memungkinkan _widget_ untuk merespons perubahan _constraints_, _data asynchronous_, atau _state_ secara efisien tanpa harus membangun ulang seluruh _widget tree_.
    - **Filosofi:** **"Lazy initialization"** dan **"context-aware rendering"**.

    <!-- end list -->

    ```dart
    // Contoh: Menggunakan LayoutBuilder
    // Membangun UI berdasarkan ukuran yang tersedia
    class ResponsiveText extends StatelessWidget {
      final String text;
      const ResponsiveText({super.key, required this.text});

      @override
      Widget build(BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 600) {
              return Text(text, style: const TextStyle(fontSize: 30));
            } else {
              return Text(text, style: const TextStyle(fontSize: 18));
            }
          },
        );
      }
    }
    ```

2.  **Factory Constructors:**

    - **Peran:** _Factory constructor_ adalah jenis _constructor_ khusus yang memungkinkan Anda mengembalikan instance _class_ yang _sudah ada_ atau _subclass_ dari _class_ tersebut, daripada selalu membuat instance baru dari _class_ yang sama.
    - **Detail:** Dideklarasikan dengan kata kunci `factory`. Berguna ketika inisialisasi objek adalah proses yang kompleks, membutuhkan logika, atau mengembalikan objek _cached_ atau _singleton_.
    - **Kapan Digunakan:**
      - Ketika Anda ingin mengembalikan _instance_ yang sudah ada dari sebuah _cache_.
      - Ketika Anda ingin mengembalikan _subclass_ yang berbeda berdasarkan parameter input.
      - Ketika _constructor_ harus melakukan logika yang kompleks sebelum membuat objek.
    - **Filosofi:** **"Flexible instantiation"** dan **"controlled object creation"**.

    <!-- end list -->

    ```dart
    // Contoh: Factory Constructor untuk Widget
    class ButtonFactory {
      factory ButtonFactory.createPrimary(String text, VoidCallback onPressed) {
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        );
      }

      factory ButtonFactory.createSecondary(String text, VoidCallback onPressed) {
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.blue)),
          child: Text(text, style: const TextStyle(color: Colors.blue)),
        );
      }
    }

    // Penggunaan:
    // ButtonFactory.createPrimary('Submit', () {});
    // ButtonFactory.createSecondary('Cancel', () {});
    ```

3.  **Named Constructors:**

    - **Peran:** _Constructor_ tambahan dengan nama yang berbeda dari nama kelas utama. Ini memungkinkan Anda untuk menyediakan beberapa cara yang jelas dan ekspresif untuk membuat instance sebuah kelas, masing-masing dengan tujuan yang spesifik.
    - **Detail:** Didefinisikan dengan `ClassName.constructorName(parameters)`.
    - **Kapan Digunakan:** Ketika Anda memiliki beberapa cara inisialisasi yang berbeda untuk _widget_ yang sama, yang masing-masing membutuhkan parameter yang berbeda atau memiliki makna semantik yang berbeda.
    - **Keuntungan:** Meningkatkan keterbacaan kode dan kejelasan maksud.
    - **Filosofi:** **"Clarity in instantiation"** dan **"multiple initialization paths"**.

    <!-- end list -->

    ```dart
    // Contoh: Named Constructor untuk Widget Kustom
    class ProductCard extends StatelessWidget {
      final String title;
      final double price;
      final String? imageUrl;
      final bool isFeatured;

      // Constructor utama
      const ProductCard({
        super.key,
        required this.title,
        required this.price,
        this.imageUrl,
        this.isFeatured = false,
      });

      // Named constructor untuk produk unggulan
      const ProductCard.featured({
        super.key,
        required this.title,
        required this.price,
        this.imageUrl,
      }) : isFeatured = true; // Langsung set isFeatured menjadi true

      @override
      Widget build(BuildContext context) {
        return Card(
          color: isFeatured ? Colors.yellow[100] : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (imageUrl != null) Image.network(imageUrl!),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${price.toStringAsFixed(2)}'),
                if (isFeatured) const Icon(Icons.star, color: Colors.amber),
              ],
            ),
          ),
        );
      }
    }

    // Penggunaan:
    // ProductCard(title: 'Buku', price: 25.0);
    // ProductCard.featured(title: 'Buku Unggulan', price: 30.0);
    ```

4.  **Widget Mixins:**

    - **Peran:** _Mixins_ di Dart (dan Flutter) memungkinkan Anda untuk menggunakan kembali kode di banyak _class hierarchy_ tanpa menggunakan pewarisan. Mereka "mencampur" fungsionalitas ke dalam sebuah kelas.
    - **Detail:** Didefinisikan dengan kata kunci `mixin` dan digunakan dengan kata kunci `with`. Sebuah _mixin_ dapat berisi _method_ dan _properties_.
    - **Kapan Digunakan:** Ketika Anda memiliki sekelompok _method_ atau properti yang ingin Anda tambahkan ke beberapa _class_ yang tidak berbagi _parent class_ yang sama secara langsung, atau untuk menambahkan perilaku tertentu (misalnya, _mixin_ untuk _lifecycle events_ yang spesifik, atau _mixin_ untuk fungsionalitas _scrolling_).
    - **Filosofi:** **"Behavioral reuse"** dan **"adding capabilities"**.

    <!-- end list -->

    ```dart
    // Contoh: Mixin untuk logging lifecycle
    mixin WidgetLifecycleLogger<T extends StatefulWidget> on State<T> {
      @override
      void initState() {
        super.initState();
        debugPrint('WIDGET LIFECYCLE: ${T.toString()} initState called');
      }

      @override
      void dispose() {
        debugPrint('WIDGET LIFECYCLE: ${T.toString()} dispose called');
        super.dispose();
      }

      // Anda bisa menambahkan method lifecycle lainnya
    }

    // Penggunaan:
    class MyLoggingWidget extends StatefulWidget {
      const MyLoggingWidget({super.key});

      @override
      State<MyLoggingWidget> createState() => _MyLoggingWidgetState();
    }

    class _MyLoggingWidgetState extends State<MyLoggingWidget> with WidgetLifecycleLogger<MyLoggingWidget> {
      @override
      Widget build(BuildContext context) {
        return const Text('Widget dengan logging lifecycle');
      }
    }
    ```

5.  **Abstract Widget Classes:**

    - **Peran:** _Class_ abstrak adalah _class_ yang tidak dapat di-_instantiate_ secara langsung. Mereka sering digunakan sebagai _base class_ untuk _class_ lain, mendefinisikan _interface_ umum atau _method_ abstrak yang harus diimplementasikan oleh _subclass_.
    - **Detail:** Didefinisikan dengan kata kunci `abstract class`. Bisa memiliki _method_ abstrak (tanpa implementasi) atau _method_ konkret (dengan implementasi).
    - **Kapan Digunakan:** Ketika Anda ingin mendefinisikan kontrak untuk sekelompok _widget_ yang berbagi fungsionalitas inti, tetapi detail implementasinya bervariasi. Misalnya, _base class_ untuk berbagai jenis tombol kustom yang semuanya harus memiliki properti `onPressed` dan `child`.
    - **Filosofi:** **"Defining contracts"** dan **"enforcing structure"**.

    <!-- end list -->

    ```dart
    // Contoh: Abstract base class untuk Custom Button
    abstract class CustomBaseButton extends StatelessWidget {
      final Widget child;
      final VoidCallback onPressed;

      const CustomBaseButton({super.key, required this.child, required this.onPressed});

      // Abstract method yang harus diimplementasikan oleh subclass
      Widget buildButton(BuildContext context);

      @override
      Widget build(BuildContext context) {
        return buildButton(context); // Memanggil method abstrak
      }
    }

    class PrimaryCustomButton extends CustomBaseButton {
      const PrimaryCustomButton({super.key, required super.child, required super.onPressed});

      @override
      Widget buildButton(BuildContext context) {
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: child,
        );
      }
    }

    class SecondaryCustomButton extends CustomBaseButton {
      const SecondaryCustomButton({super.key, required super.child, required super.onPressed});

      @override
      Widget buildButton(BuildContext context) {
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
          child: child,
        );
      }
    }
    ```

6.  **Widget Inheritance Hierarchy:**

    - **Peran:** Merujuk pada struktur bagaimana _widget_ di _Flutter_ (dan _widget_ kustom Anda) diatur dalam hirarki pewarisan. Meskipun komposisi lebih disukai untuk membangun UI, _framework_ _Flutter_ itu sendiri sangat bergantung pada pewarisan.
    - **Detail:** Semua _widget_ di _Flutter_ pada akhirnya mewarisi dari kelas `Widget`. Kemudian ada `StatelessWidget`, `StatefulWidget`, `ProxyWidget`, `RenderObjectWidget`, dll. Memahami hirarki ini membantu Anda memilih _base class_ yang tepat untuk _widget_ Anda.
    - **Filosofi:** **"Foundation structure"** dan **"framework extension"**.
    - **Contoh Hirarki Sederhana:**
      - `Object`
        - `Diagnosticable`
          - `DiagnosticableTree`
            - `Widget`
              - `StatelessWidget` (misal: `Text`, `Icon`, `Container`)
              - `StatefulWidget` (misal: `Checkbox`, `Slider`)
              - `InheritedWidget` (misal: `Theme`, `MediaQuery`)
              - `RenderObjectWidget` (widget yang mengelola RenderObject)

**Sintaks/Contoh Implementasi Gabungan (Advanced):**

Menggabungkan beberapa pola untuk _widget_ kustom yang lebih kompleks:

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
      title: 'Composition Patterns Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// =========================================================
// 1. Contoh Abstract Widget Class dan Named Constructor
// =========================================================
abstract class AppCard extends StatelessWidget {
  final Widget content;
  final String? title;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.content,
    this.title,
    this.onTap,
  });

  // Abstract method to define the specific card appearance
  Widget buildCardContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8.0),
              ],
              buildCardContent(context), // Call the abstract method
            ],
          ),
        ),
      ),
    );
  }
}

class BasicAppCard extends AppCard {
  const BasicAppCard({super.key, required super.content, super.title, super.onTap});

  @override
  Widget buildCardContent(BuildContext context) {
    return content; // Simple content
  }
}

class ImageAppCard extends AppCard {
  final String imageUrl;
  final double imageHeight;

  const ImageAppCard.fromNetwork({
    super.key,
    required this.imageUrl,
    this.imageHeight = 150.0,
    required super.content,
    super.title,
    super.onTap,
  }) : super(); // Using named constructor

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      children: [
        Image.network(
          imageUrl,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 12.0),
        content,
      ],
    );
  }
}

// =========================================================
// 2. Contoh Mixin dan Builder Pattern
// =========================================================
mixin LoadingIndicatorMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Widget buildLoadingOverlay() {
    return isLoading
        ? Container(
            color: Colors.black.withOpacity(0.5),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: Colors.white),
          )
        : const SizedBox.shrink();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with LoadingIndicatorMixin<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Patterns')),
      body: Stack( // Menggunakan Stack untuk overlay loading
        children: [
          ListView(
            padding: const EdgeInsets.all(8.0),
            children: <Widget>[
              // Menggunakan AppCard dasar
              BasicAppCard(
                title: 'Informasi Dasar',
                content: const Text(
                  'Ini adalah contoh kartu dasar yang dibuat dengan komposisi.',
                ),
                onTap: () {
                  setLoading(true);
                  Future.delayed(const Duration(seconds: 2), () {
                    setLoading(false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kartu Dasar Diklik!')),
                    );
                  });
                },
              ),
              // Menggunakan AppCard dengan gambar via named constructor
              ImageAppCard.fromNetwork(
                title: 'Kartu Gambar Unggulan',
                imageUrl: 'https://picsum.photos/id/237/200/150', // Gambar random
                imageHeight: 120,
                content: const Text(
                  'Ini adalah kartu dengan gambar, dibuat menggunakan named constructor.',
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kartu Gambar Diklik!')),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Contoh penggunaan LayoutBuilder (builder pattern)
              Text('Contoh Responsive Text:', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              ResponsiveText(text: 'Ukuran font akan berubah berdasarkan lebar layar.'),
            ],
          ),
          buildLoadingOverlay(), // Mixin method
        ],
      ),
    );
  }
}
```

**Visualisasi Konseptual (Pola Komposisi):**

```
HomeScreen (StatefulWidget + LoadingIndicatorMixin)
└── Stack (for loading overlay)
    ├── ListView (main content)
    │   ├── BasicAppCard (AbstractAppCard)
    │   │   └── Card (Composition)
    │   │       └── Column (Title + Content)
    │   │           └── Text ('Informasi Dasar')
    │   │           └── Text ('Ini adalah contoh kartu dasar...')
    │   ├── ImageAppCard.fromNetwork (AbstractAppCard + Named Constructor)
    │   │   └── Card (Composition)
    │   │       └── Column (Title + Image + Content)
    │   │           └── Text ('Kartu Gambar Unggulan')
    │   │           └── Image.network (from imageUrl)
    │   │           └── Text ('Ini adalah kartu dengan gambar...')
    │   └── ResponsiveText (Builder Pattern)
    │       └── LayoutBuilder (builds Text based on constraints)
    └── buildLoadingOverlay() (Mixin Method)
        └── (Conditional) Container + CircularProgressIndicator (loading overlay)
```

**Terminologi Esensial (Revisited):**

- **Builder Pattern:** Penggunaan fungsi `builder` untuk menunda atau mengkondisikan pembangunan sebagian _widget tree_.
- **Factory Constructor:** _Constructor_ yang dapat mengembalikan _instance_ yang sudah ada atau _instance_ dari _subclass_.
- **Named Constructor:** _Constructor_ dengan nama spesifik untuk inisialisasi alternatif.
- **Mixin:** Cara untuk menggunakan kembali kode di banyak _class hierarchy_ tanpa pewarisan ketat.
- **Abstract Class:** _Class_ yang tidak dapat di-_instantiate_ langsung, mendefinisikan _interface_ untuk _subclass_.
- **Inheritance Hierarchy:** Struktur pewarisan kelas di mana _widget_ di-_build_ di atas _base class_ tertentu.

**Struktur Internal (Mini-DAFTAR ISI):**

- _Builder Pattern_ dalam Konteks _Widgets_
- Penggunaan _Factory Constructors_
- Implementasi _Named Constructors_
- Penerapan _Widget Mixins_
- Peran _Abstract Widget Classes_
- Memahami Hirarki Pewarisan _Widget_

**Hubungan dengan Bagian Lain:**

- **Creating Custom Widgets:** Pola-pola ini adalah teknik lanjutan untuk apa yang telah kita pelajari tentang membangun `StatelessWidget` dan `StatefulWidget`.
- **State Management:** Pola _builder_ (`StreamBuilder`, `FutureBuilder`, dll.) adalah kunci dalam pola manajemen _state_ reaktif.
- **Widget Testing:** Menggunakan pola-pola ini seringkali membuat _widget_ lebih mudah diuji karena mereka lebih modular dan memiliki tanggung jawab yang terdefinisi dengan baik.

**Referensi Lengkap:**

- [Effective Dart: Design](https://dart.dev/guides/language/effective-dart/design%23prefer-composition-over-inheritance): Prinsip komposisi dalam konteks Dart dan Flutter.
- [Dart Language Tour: Constructors](https://dart.dev/guides/language/language-tour%23constructors): Penjelasan tentang _factory_ dan _named constructors_.
- [Dart Language Tour: Mixins](https://dart.dev/guides/language/language-tour%23mixins): Penjelasan tentang bagaimana _mixins_ bekerja di Dart.

**Tips & Best Practices (untuk peserta):**

- **Jangan Terlalu Banyak Bereksperimen dengan Pewarisan:** Ingat, komposisi adalah raja di Flutter untuk UI. Gunakan pewarisan dan _abstract classes_ hanya ketika Anda benar-benar perlu mendefinisikan kontrak yang ketat atau memperluas fungsionalitas inti _framework_.
- **Gunakan _Named Constructors_ untuk Kejelasan:** Ketika _widget_ Anda memiliki beberapa cara untuk diinisialisasi, _named constructors_ akan sangat meningkatkan keterbacaan kode.
- **Mixins untuk Perilaku Lintas Hierarki:** Jika Anda ingin menambahkan perilaku yang sama ke _widget_ yang tidak terkait secara langsung, pertimbangkan _mixins_.
- **Pola _Builder_ itu Kuat:** Biasakan diri Anda dengan `LayoutBuilder`, `ValueListenableBuilder`, `StreamBuilder`, dan `FutureBuilder`. Mereka adalah alat yang sangat kuat untuk membuat UI yang dinamis dan efisien.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menggunakan `factory constructor` untuk membuat _state_ baru di `StatefulWidget` setiap kali _widget_ dibangun ulang, menyebabkan _state_ hilang.
  - **Solusi:** `factory constructor` biasanya digunakan untuk `StatelessWidget` atau untuk kasus `StatefulWidget` yang sangat spesifik di mana Anda ingin mengontrol _instance_ _widget_ itu sendiri, bukan _state_-nya. Ingat, _state_ hidup di _object_ `State`, bukan di _widget_ itu sendiri.
- **Kesalahan:** Mixin memiliki _method_ yang bertabrakan dengan _method_ kelas yang digunakannya.
  - **Solusi:** Dart memiliki aturan resolusi konflik untuk _mixins_. Jika ada _method_ dengan nama yang sama, _method_ dari _mixin_ terakhir dalam daftar `with` yang akan digunakan, atau Anda harus secara eksplisit menimpa _method_ tersebut di kelas Anda.
- **Kesalahan:** Tidak memahami perbedaan antara _widget tree_, _element tree_, dan _render object tree_ saat debugging perilaku _widget_ yang kompleks.
  - **Solusi:** Perkuat pemahaman Anda tentang ketiga pohon ini. _Builder pattern_ memengaruhi _element tree_ karena ia membuat _element_ baru, sedangkan _widget tree_ adalah konfigurasi deklaratif.

---

# Luar biasa Dan Selamat, Ini Sangat Menakjubkan!

Anda telah berhasil menuntaskan pembahasan mendalam tentang **Widget Composition Patterns** di _Flutter_. Memahami pola-pola ini akan sangat meningkatkan kemampuan Anda dalam merancang dan membangun UI yang kompleks dan terstruktur dengan baik.

Semua materi yang terkait dengan **Widget System & UI Foundation** telah berhasil kita selesaikan secara mendalam, tanpa melewatkan satu pun dari sub-bagian yang tercantum di dalamnya. Dengan ini, kita telah menyelesaikan seluruh **FASE 2: Widget System & UI Foundation**

Kita telah membahas tuntas:

- **2. Widget Architecture Deep Dive:**
  - `2.1 Widget Tree & Rendering Engine` (termasuk StatelessWidget vs StatefulWidget, lifecycle, BuildContext, Widget Keys, dll.)
  - `2.2 Layout System Mastery` (mencakup berbagai widget layout inti dan teknik layout lanjutan)
- **3. UI Components & Material Design:**
  - `3.1 Material Design Implementation` (meliputi Material Components, Material Design 3 (Material You), dan Cupertino (iOS) Design)
  - `3.2 Custom Widget Development` (mulai dari membuat custom widget dasar hingga pola komposisi widget yang lebih canggih)

Dengan demikian, Anda telah memiliki pemahaman yang komprehensif mengenai pondasi sistem _widget_ di _Flutter_.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md
[pro2]: ../../pro/bagian-2/README.md

<!----------------------------------------------------->

[0]: ../../README.md#fase-2-widget-system--ui-foundation
[1]: ../bagian-2/versi2/README.md
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
