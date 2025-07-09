> [pro][fase7]

# **[FASE 7: Styling, Theming & Responsive Design][0]**

### **Daftar Isi**

<details>
  <summary>📃 Struktur Materi</summary>

- **[10. Advanced Theming System](#10-advanced-theming-system)**
  - **[10.1. Theme Architecture](#101-theme-architecture)**
    - [10.1.1. Material Theme System](#1011-material-theme-system)
    - [10.1.2. Material 3 Dynamic Theming](#1012-material-3-dynamic-theming)
    - [10.1.3. Custom Theme Implementation](#1013-custom-theme-implementation)
  - **[10.2. Typography & Font Management](#)**
    - [10.2.1. Font Integration](#)
    - [10.2.2. Typography Systems](#)
  - **[10.3. Responsive & Adaptive Design](#)**
    - [10.3.1. Responsive Design Patterns](#)
    - [10.3.2. Adaptive Design](#)
    - [10.3.3. Multi-Screen Support](#)
- **[11. Animations & Visual Effects](#)**
  - **[11.1. Basic Animation System](#)**
    - [11.1.1. Animation Framework](#)
  - **[11.2. Advanced Animations](#)**
    - [11.2.1. Hero Animations](#)
    - [11.2.2. Page Transitions](#)
    - [11.2.3. Implicit & Explicit Animations](#)
    - [11.2.4. Physics-Based Animations](#)
  - **[11.3. External Animation Libraries](#)**
    - [11.3.1. Lottie Animations](#)
    - [11.3.2. Rive Animations](#)
- **[12. Custom Painting & Graphics](#)**
  - **[12.1. Custom Painter](#)**
    - [12.1.1. Canvas API](#)
    - [12.1.2. Advanced Custom Painting](#)
    - [12.1.3. SVG Integration](#)

</details>

---

### **10. Advanced Theming System**

**Deskripsi Konkret & Peran dalam Kurikulum:**
_Theming_ adalah proses mendefinisikan palet warna, gaya teks, dan properti visual lainnya secara terpusat, sehingga semua komponen di seluruh aplikasi Anda memiliki tampilan yang konsisten dan seragam. Daripada mengatur warna setiap tombol secara manual, Anda mendefinisikannya sekali di dalam "Tema" aplikasi. Bagian ini mengajarkan cara membangun dan mengelola sistem tema yang kuat, memungkinkan aplikasi Anda untuk dengan mudah beralih antara mode terang dan gelap, atau bahkan mengadopsi skema warna yang sepenuhnya kustom, yang merupakan ciri khas dari aplikasi yang dipoles secara profesional.

---

#### **10.1. Theme Architecture**

##### **10.1.1. Material Theme System**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah fondasi dari _theming_ di Flutter. `ThemeData` adalah sebuah kelas masif yang berisi ratusan properti untuk mengkonfigurasi hampir setiap aspek visual dari widget Material Design. Memahami cara kerja `ThemeData`, terutama `ColorScheme` dan `TextTheme`, adalah langkah pertama yang fundamental. Dengan ini, Anda dapat menyesuaikan tampilan aplikasi Anda agar sesuai dengan identitas merek (_branding_) tanpa harus mengubah kode di setiap widget secara individual.

**Konsep Kunci & Filosofi Mendalam:**

- **Centralized Configuration:** Filosofi utamanya adalah sentralisasi. Alih-alih: `Text('Halo', style: TextStyle(color: Colors.blue, fontSize: 16))`, Anda seharusnya menggunakan: `Text('Halo', style: Theme.of(context).textTheme.bodyLarge)`. Ini membuat gaya Anda konsisten dan mudah diubah. Jika Anda ingin mengubah semua `bodyLarge` di aplikasi Anda, Anda hanya perlu mengubahnya di satu tempat: `ThemeData`.
- **Inheritance (Pewarisan):** `ThemeData` disebarkan ke seluruh _widget tree_ menggunakan `InheritedWidget` di belakang layar. Setiap widget dapat "melihat" ke atas pohon untuk menemukan `ThemeData` terdekat menggunakan `Theme.of(context)`.
- **Component Themes:** Selain warna dan teks global, `ThemeData` juga memungkinkan Anda untuk mendefinisikan tema spesifik untuk komponen tertentu. Contohnya, `elevatedButtonTheme` memungkinkan Anda untuk mengatur gaya default untuk semua `ElevatedButton` di aplikasi Anda.

**Terminologi Esensial & Penjelasan Detil:**

- **`ThemeData`:** Objek utama yang menyimpan semua konfigurasi visual.
- **`ColorScheme`:** Bagian dari `ThemeData` yang berfokus khusus pada definisi warna berdasarkan perannya (bukan nama warnanya). Ini adalah cara modern dan direkomendasikan untuk mengelola warna. Contoh peran: `primary` (warna utama merek), `secondary` (warna aksen), `surface` (warna latar belakang untuk komponen seperti Card), `onPrimary` (warna teks/ikon di atas warna `primary`).
- **`TextTheme`:** Bagian dari `ThemeData` yang mendefinisikan gaya teks untuk berbagai peran tipografi, seperti `displayLarge`, `headlineMedium`, `bodyLarge`, `labelSmall`, dll.
- **`Theme.of(context)`:** Metode statis yang digunakan oleh widget untuk mengakses `ThemeData` saat ini dari `BuildContext`.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini mendefinisikan tema terang dan gelap sederhana dan menyediakan tombol untuk beralih di antara keduanya. (Untuk kemudahan, state pergantian tema dikelola secara lokal di sini).

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// --- Definisi Tema Terpusat ---
class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    // 1. Gunakan ColorScheme.fromSeed untuk membuat palet warna lengkap
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    // 2. Definisikan tema untuk komponen spesifik
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple, // Warna tombol utama
        foregroundColor: Colors.white, // Warna teks di tombol
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark, // Ini akan membuat warna menjadi gelap
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade300,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    useMaterial3: true,
  );
}

// --- Aplikasi Utama ---
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theming Demo',
      // 3. Terapkan tema ke MaterialApp
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode, // State yang mengontrol tema mana yang aktif
      home: ThemingScreen(onToggleTheme: _toggleTheme),
    );
  }
}

// --- Layar Contoh ---
class ThemingScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  const ThemingScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar secara otomatis menggunakan warna 'primary' dari ColorScheme
        title: const Text('Material Theming'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 4. Gunakan gaya teks dari TextTheme
            Text('Ini adalah Headline', style: Theme.of(context).textTheme.headlineMedium),
            Text('Ini adalah Body Text standar.', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            Center(
              // Tombol ini akan menggunakan gaya dari elevatedButtonTheme
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Tombol Bertema'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        // FAB secara otomatis menggunakan warna 'secondary' atau 'tertiary'
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### **Visualisasi Hasil Kode**

```
┌──────────────────────────────────┐        ┌──────────────────────────────────┐
│  Tampilan Mode Terang            │        │  Tampilan Mode Gelap             │
├──────────────────────────────────┤        ├──────────────────────────────────┤
│ AppBar: [Material Theming]       │        │ AppBar: [Material Theming]       │
│ (Warna Ungu)                     │        │ (Warna Ungu Gelap)               │
│ -------------------------------- │        │ -------------------------------- │
│                                  │        │                                  │
│  Ini adalah Headline             │        │  Ini adalah Headline             │
│  (Teks Gelap)                    │        │  (Teks Terang)                   │
│                                  │        │                                  │
│  Ini adalah Body Text standar.   │        │  Ini adalah Body Text standar.   │
│                                  │        │                                  │
│        ┌──────────────────┐      │        │        ┌──────────────────┐      │
│        │ Tombol Bertema   │      │        │        │ Tombol Bertema   │      │
│        │ (Background Ungu)│      │        │        │(Background Ungu Muda)   │
│        └──────────────────┘      │        │        └──────────────────┘      │
│                                  │        │                                  │
│                            [+]   │        │                            [+]   │
└──────────────────────────────────┘        └──────────────────────────────────┘
```

### **Representasi Diagram Alur (Theming)**

```
┌──────────────────────────────────────────┐
│  main.dart                               │
│  ┌────────────────────────────────────┐  │
│  │ MaterialApp                        │  │
│  │ ┌────────────────────────────────┐ │  │
│  │ │ theme: ThemeData(...)        ◄─┼───┤ // Definisi Tema Terang
│  │ │ darkTheme: ThemeData(...)    ◄─┼───┤ // Definisi Tema Gelap
│  │ │ themeMode: _themeMode        ◄─┼───┤ // State yang memilih tema
│  │ └────────────────────────────────┘ │  │
│  └───────────────────┬────────────────┘  │
└──────────────────────┴───────────────────┘
                       │ (Tema disebarkan ke bawah melalui context)
┌──────────────────────▼───────────────────┐
│  ThemingScreen                           │
│  ┌────────────────────────────────────┐  │
│  │ Scaffold                           │  │
│  │ ┌────────────────────────────────┐ │  │
│  │ │ AppBar(...)                    │ │  │ // Otomatis mengambil warna AppBar
│  │ ├────────────────────────────────┤ │  │
│  │ │ body: Column(...)              │ │  │
│  │ │ ┌────────────────────────────┐ │ │  │
│  │ │ │ Text(...)                  │ │ │  │
│  │ │ │ style: Theme.of(context).  │ │ │  │
│  │ │ │         textTheme.headline │ ◄───┤ // Mengambil gaya teks dari tema
│  │ │ ├────────────────────────────┤ │ │  │
│  │ │ │ ElevatedButton(...)        │ │ │  │ // Otomatis mengambil gaya tombol
│  │ │ └────────────────────────────┘ │ │  │
│  │ └────────────────────────────────┘ │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

Diagram ini menunjukkan bagaimana `ThemeData` yang didefinisikan di `MaterialApp` secara otomatis "mengalir" ke bawah dan dapat diakses oleh widget apa pun di bawahnya untuk menerapkan gaya yang konsisten.

---

Kita akan langsung masuk ke evolusi dari sistem tema Material, yaitu kemampuan aplikasi untuk beradaptasi secara dinamis dengan preferensi visual pengguna, sebuah fitur unggulan dari Material 3.

---

##### **10.1.2. Material 3 Dynamic Theming**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Dynamic Theming** (juga dikenal sebagai **Material You**) adalah fitur andalan dari Material Design 3. Ini memungkinkan aplikasi untuk secara otomatis mengekstrak warna dari _wallpaper_ perangkat pengguna (di Android 12+) dan membuat palet warna (`ColorScheme`) yang unik dan harmonis. Perannya dalam kurikulum adalah untuk menunjukkan bagaimana cara membangun aplikasi yang terasa sangat personal dan terintegrasi secara mendalam dengan sistem operasi. Ini adalah puncak dari _theming_ modern yang adaptif.

**Konsep Kunci & Filosofi Mendalam:**

- **Personalized UI (UI yang Dipersonalisasi):** Filosofi utamanya adalah bahwa aplikasi tidak seharusnya memiliki tampilan yang kaku, melainkan harus beradaptasi dengan gaya personal pengguna. Dengan mengambil warna dari _wallpaper_, setiap pengguna akan mendapatkan pengalaman visual yang unik, membuat aplikasi terasa seperti "milik mereka".
- **Algorithmic Color Generation:** Proses ini tidak hanya mengambil satu warna. Sistem operasi menggunakan algoritma canggih untuk mengekstrak beberapa warna dominan dan aksen dari _wallpaper_, lalu menghasilkan seluruh `ColorScheme` yang harmonis (termasuk warna `primary`, `secondary`, `tertiary`, `surface`, dan semua varian `on*`-nya) secara otomatis.
- **`dynamic_color` Package:** Untuk mengimplementasikan ini di Flutter, kita menggunakan paket `dynamic_color`. Paket ini bertindak sebagai jembatan untuk mendapatkan palet warna dinamis dari sistem operasi dan memberikannya ke aplikasi Flutter kita.

**Terminologi Esensial & Penjelasan Detil:**

- **Dynamic Color:** Skema warna yang dihasilkan secara algoritmik dari sumber eksternal, biasanya _wallpaper_ pengguna.
- **Seed Color:** Warna dasar yang digunakan oleh algoritma untuk menghasilkan seluruh palet `ColorScheme`. Dalam _dynamic theming_, _seed color_ ini disediakan oleh OS. Dalam _static theming_, kita menyediakannya secara manual (seperti pada contoh `ColorScheme.fromSeed(seedColor: Colors.deepPurple)` sebelumnya).
- **Color Harmonization:** Proses menyesuaikan warna-warna di dalam aplikasi (misalnya, warna dari sebuah gambar produk) agar terlihat serasi dengan `ColorScheme` utama dari tema dinamis.

**Sintaks Dasar / Contoh Implementasi Inti:**
Implementasi ini sangat bergantung pada paket `dynamic_color`.

```dart
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// Kita tetap definisikan tema statis sebagai fallback
// jika dynamic color tidak tersedia (misal di iOS atau Android versi lama).
final staticLightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  useMaterial3: true,
);

final staticDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Bungkus MaterialApp dengan DynamicColorBuilder
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        // 2. Gunakan ColorScheme dinamis jika tersedia, jika tidak, gunakan statis.
        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = staticLightTheme.colorScheme;
          darkColorScheme = staticDarkTheme.colorScheme;
        }

        return MaterialApp(
          title: 'Dynamic Theming Demo',
          // 3. Buat ThemeData dari ColorScheme yang terpilih.
          theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
          darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
          home: const ThemingScreen(onToggleTheme: (){}), // Anggap ThemingScreen sudah ada
        );
      },
    );
  }
}
```

### **Visualisasi Hasil Kode**

_Mockup_ ini mengilustrasikan bagaimana UI yang sama dapat memiliki skema warna yang sama sekali berbeda pada dua perangkat pengguna yang berbeda.

```
┌──────────────────────────────────┐        ┌──────────────────────────────────┐
│  Perangkat Pengguna A            │        │  Perangkat Pengguna B            │
│ (Wallpaper Hijau Alam)           │        │ (Wallpaper Biru Laut)            │
├──────────────────────────────────┤        ├──────────────────────────────────┤
│ AppBar: [Dynamic Theming]        │        │ AppBar: [Dynamic Theming]        │
│ (Warna Hijau Tua)                │        │ (Warna Biru Tua)                 │
│ -------------------------------- │        │ -------------------------------- │
│                                  │        │                                  │
│  Ini adalah Headline             │        │  Ini adalah Headline             │
│  (Aksen Hijau)                   │        │  (Aksen Biru)                    │
│                                  │        │                                  │
│        ┌──────────────────┐      │        │        ┌──────────────────┐      │
│        │ Tombol Bertema   │      │        │        │ Tombol Bertema   │      │
│        │ (BG Hijau)       │      │        │        │ (BG Biru)        │      │
│        └──────────────────┘      │        │        └──────────────────┘      │
│                                  │        │                                  │
│                            [+]   │        │                            [+]   │
│                        (Hijau)   │        │                          (Biru)  │
└──────────────────────────────────┘        └──────────────────────────────────┘
```

### **Representasi Diagram Alur (Dynamic Theming)**

```
┌───────────────────────────┐
│  Wallpaper Pengguna       │
│  (Sumber Warna)           │
└────────────┬──────────────┘
             │
┌────────────▼──────────────┐
│  Sistem Operasi (Android) │
│  (Mengekstrak Palet Warna)│
└────────────┬──────────────┘
             │
┌────────────▼──────────────┐
│  `dynamic_color` Paket    │ // Jembatan antara OS dan Flutter
│  (Membaca Palet dari OS)  │
└────────────┬──────────────┘
             │
┌────────────▼──────────────┐
│  DynamicColorBuilder      │
│  (Menerima Palet Dinamis) │
└────────────┬──────────────┘
             │
┌────────────▼──────────────┐
│  ColorScheme? lightDynamic│ // Objek ColorScheme yang dihasilkan
│  ColorScheme? darkDynamic │
└────────────┬──────────────┘
             │
┌────────────▼────────────────┐
│  MaterialApp                │
│  (Menggunakan ColorScheme   │
│  untuk membangun ThemeData) │
└─────────────────────────────┘
```

---

##### **10.1.3. Custom Theme Implementation**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Terkadang, `ThemeData` standar tidak cukup. Bagaimana jika aplikasi Anda memiliki nilai-nilai gaya kustom yang tidak ada di `ThemeData`, seperti warna khusus untuk status "sukses" atau "bahaya", atau ukuran spasi standar? **Theme Extensions** adalah cara modern dan _type-safe_ untuk menambahkan properti gaya kustom Anda sendiri ke sistem tema Flutter. Perannya adalah untuk memungkinkan Anda membuat sistem desain yang sepenuhnya dapat disesuaikan dan dapat diperluas, sambil tetap terintegrasi dengan baik dengan `Theme.of(context)`.

**Konsep Kunci & Filosofi Mendalam:**

- **Extending, Not Replacing:** Anda tidak mengganti `ThemeData`. Anda **memperluasnya**. _Theme extensions_ hidup berdampingan dengan `ColorScheme`, `TextTheme`, dll. di dalam `ThemeData`.
- **Type-Safety:** Anda mengakses ekstensi Anda dengan cara yang aman secara tipe: `Theme.of(context).extension<MyCustomColors>()`. Jika ekstensi tidak ada atau tipenya salah, _compiler_ akan memberitahu Anda.
- **Interpolasi untuk Animasi:** _Theme extensions_ dirancang untuk mendukung animasi transisi tema. Anda harus mengimplementasikan metode `lerp` (Linear Interpolation) yang memberitahu Flutter bagaimana cara beranimasi dari satu set nilai kustom ke set nilai lainnya.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini membuat sebuah ekstensi untuk warna-warna semantik kustom.

**Langkah 1: Buat Kelas ThemeExtension**

```dart
import 'package:flutter/material.dart';

// 1. Buat kelas yang meng-extend ThemeExtension
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.danger,
  });

  final Color? success;
  final Color? danger;

  // 2. Implementasikan copyWith, dibutuhkan oleh ThemeExtension
  @override
  AppColors copyWith({Color? success, Color? danger}) {
    return AppColors(
      success: success ?? this.success,
      danger: danger ?? this.danger,
    );
  }

  // 3. Implementasikan lerp, untuk transisi tema yang mulus
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      success: Color.lerp(success, other.success, t),
      danger: Color.lerp(danger, other.danger, t),
    );
  }
}
```

**Langkah 2: Tambahkan Ekstensi ke ThemeData**

```dart
final myLightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  // 4. Tambahkan ekstensi Anda ke dalam list 'extensions'
  extensions: const <ThemeExtension<dynamic>>[
    AppColors(
      success: Colors.green,
      danger: Colors.red,
    ),
  ],
);

final myDarkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
  extensions: <ThemeExtension<dynamic>>[
    AppColors(
      success: Colors.green.shade300,
      danger: Colors.red.shade300,
    ),
  ],
);
```

**Langkah 3: Gunakan di UI**

```dart
class CustomThemeScreen extends StatelessWidget {
  const CustomThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. Akses warna kustom melalui Theme.of(context).extension<T>()
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Theme')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: appColors.success, // Gunakan warna sukses kustom
              padding: const EdgeInsets.all(12),
              child: const Text('Operasi Berhasil', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Container(
              color: appColors.danger, // Gunakan warna bahaya kustom
              padding: const EdgeInsets.all(12),
              child: const Text('Terjadi Error', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
```

### **Representasi Diagram Alur (Theme Extension)**

```
┌─────────────────────────────────────────┐
│  ThemeData                              │
│  (Objek Tema Pusat)                     │
│ ┌─────────────────────────────────────┐ │
│ │ colorScheme: ColorScheme(...)       │ │
│ │ textTheme: TextTheme(...)           │ │
│ │ ... (properti standar)              │ │
│ │ ┌─────────────────────────────────┐ │ │
│ │ │ extensions: [                   │ │ │ // Properti untuk ekstensi
│ │ │   AppColors(                    │ │ │
│ │ │     success: Colors.green,      │ │ │
│ │ │     danger: Colors.red,         │ │ │
│ │ │   ),                            │ │ │
│ │ │ ]                               │ │ │
│ │ └─────────────────────────────────┘ │ │
│ └─────────────────────────────────────┘ │
└──────────────────┬──────────────────────┘
                   │ (Disebarkan melalui context)
┌──────────────────▼──────────────────────┐
│  Widget Anda (misal CustomThemeScreen)  │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│  Theme.of(context)                      │
│  (Mengakses seluruh tema)               │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│  .extension<AppColors>()!               │ // Meminta ekstensi spesifik
│  (Mengambil Objek AppColors)            │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│  .success                               │ // Mengakses properti kustom
│  (Menggunakan Nilai Warna)              │
└─────────────────────────────────────────┘
```

---

Kita telah menyelesaikan arsitektur tema. Selanjutnya, kita akan fokus pada elemen yang memberikan "suara" dan "kepribadian" pada aplikasi kita: tipografi. Penggunaan font dan gaya teks yang konsisten adalah pilar dari desain antarmuka yang baik.

---

### **10.2. Typography & Font Management**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Tipografi lebih dari sekadar memilih font yang indah; ini adalah seni mengatur teks agar mudah dibaca, dapat dipahami, dan menarik secara visual. Bagian ini mengajarkan cara mengintegrasikan file font kustom ke dalam aplikasi Anda dan, yang lebih penting, cara mendefinisikan dan mengelola **sistem tipografi** yang konsisten. Dengan ini, Anda dapat memastikan bahwa semua judul, subjudul, dan isi teks di seluruh aplikasi memiliki hierarki visual yang jelas, yang secara fundamental meningkatkan pengalaman pengguna dan keterbacaan.

---

#### **10.2.1. Font Integration**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Seringkali, font standar yang disediakan oleh sistem operasi tidak cukup untuk mencerminkan identitas merek sebuah aplikasi. Bagian ini adalah panduan teknis untuk menambahkan file font kustom (seperti `.ttf` atau `.otf`) ke dalam proyek Flutter Anda. Ini mencakup proses dari menempatkan file font di dalam struktur aset hingga mendeklarasikannya di `pubspec.yaml` dan akhirnya menerapkannya pada widget `Text`.

**Konsep Kunci & Filosofi Mendalam:**

- **Fonts as Assets:** Flutter memperlakukan file font sama seperti aset lainnya (misalnya, gambar). Mereka harus disertakan di dalam paket aplikasi Anda dan dideklarasikan agar _framework_ mengetahuinya.
- **Family Name:** Saat mendeklarasikan font, Anda mendefinisikan sebuah `family`, yang merupakan nama yang akan Anda gunakan di dalam kode untuk merujuk ke font tersebut. Sebuah _family_ dapat memiliki beberapa varian, seperti bobot (misalnya, _regular_, _bold_) dan gaya (misalnya, _italic_).
- **The `google_fonts` Package:** Meskipun proses manual penting untuk dipahami, untuk proyek yang membutuhkan fleksibilitas, paket `google_fonts` adalah alternatif yang sangat populer. Ia memungkinkan Anda untuk menggunakan ratusan font dari Google Fonts secara dinamis tanpa perlu mengunduh dan menyertakan file font secara manual di dalam aset Anda. Paket ini menangani pengunduhan dan _caching_ font di belakang layar.

**Sintaks Dasar / Contoh Implementasi Inti (Metode Manual):**

**Langkah 1: Tambahkan File Font ke Aset**

1.  Buat direktori baru di root proyek Anda, misalnya `assets/fonts`.
2.  Tempatkan file font Anda (misalnya, `Poppins-Regular.ttf` dan `Poppins-Bold.ttf`) di dalam direktori tersebut.

**Langkah 2: Deklarasikan Font di `pubspec.yaml`**
Ini adalah langkah krusial. Anda harus memberitahu Flutter tentang keberadaan font Anda dan variannya.

```yaml
# file: pubspec.yaml

flutter:
  uses-material-design: true

  # Untuk menambahkan font ke aplikasi Anda, tambahkan bagian fonts.
  fonts:
    - family: Poppins # Ini adalah nama yang akan Anda gunakan di kode
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        # Properti 'weight' sesuai dengan bobot font.
        # 100-900. 400 adalah normal/regular, 700 adalah bold.
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

**Penting:** Perhatikan indentasi dalam file YAML. Setelah mengedit `pubspec.yaml`, selalu jalankan `flutter pub get`.

**Langkah 3: Gunakan Font di dalam Kode**

```dart
import 'package:flutter/material.dart';

class FontDemoScreen extends StatelessWidget {
  const FontDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Terapkan font pada AppBar Title
        title: const Text(
          'Custom Fonts Demo',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ini menggunakan Poppins Regular.',
              style: TextStyle(
                fontFamily: 'Poppins', // Cukup panggil nama family
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ini menggunakan Poppins Bold.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w700, // Flutter akan memilih file font yang tepat
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### **Visualisasi Hasil Kode**

_Mockup_ ini membandingkan tampilan UI dengan font default sistem versus font Poppins kustom.

```
┌──────────────────────────────────┐        ┌──────────────────────────────────┐
│  Tampilan Font Default (Roboto)  │        │  Tampilan Font Kustom (Poppins)  │
├──────────────────────────────────┤        ├──────────────────────────────────┤
│ AppBar: [Custom Fonts Demo]      │        │ AppBar: [Custom Fonts Demo]      │
│ -------------------------------- │        │ -------------------------------- │
│                                  │        │                                  │
│   Ini menggunakan Roboto Regular.│        │  ni menggunakan Poppins Regular. │
│                                  │        │                                  │
│   Ini menggunakan Roboto Bold.   │        │  ni menggunakan Poppins Bold.    │
│                                  │        │                                  │
└──────────────────────────────────┘        └──────────────────────────────────┘
```

### **Representasi Diagram (Alur Integrasi Font)**

```
  Struktur Proyek
  └── assets/
      └── fonts/
          ├── Poppins-Regular.ttf
          └── Poppins-Bold.ttf

              │ (Direferensikan oleh)
              ▼

  pubspec.yaml
  └── flutter:
      └── fonts:
          └── - family: Poppins
              └── fonts:
                  ├── - asset: assets/fonts/Poppins-Regular.ttf
                  └── - asset: assets.fonts/Poppins-Bold.ttf
                      └── weight: 700

                          │ (Digunakan oleh)
                          ▼

  Kode Widget Dart
  └── Text(
      │   'Contoh Teks',
      │   style: TextStyle(
      │     fontFamily: 'Poppins',  // Merujuk ke nama family
      │     fontWeight: FontWeight.w700 // Flutter memilih file `Bold`
      │   )
      └──)
```

---

#### **10.2.2. Typography Systems**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Setelah bisa menggunakan font kustom, langkah selanjutnya adalah menggunakannya secara sistematis. Sistem tipografi adalah tentang mendefinisikan sekumpulan gaya teks standar untuk peran yang berbeda (misalnya, judul besar, subjudul, isi paragraf, teks tombol). Di Flutter, ini diimplementasikan melalui `TextTheme`. Dengan mendefinisikan `TextTheme` secara terpusat, Anda memastikan konsistensi tipografi di seluruh aplikasi dan membuat perubahan gaya menjadi sangat mudah.

**Konsep Kunci & Filosofi Mendalam:**

- **Hierarki Visual:** Sistem tipografi menciptakan hierarki yang jelas. Pengguna dapat secara intuitif mengetahui bagian mana dari teks yang paling penting hanya dengan melihat gayanya. `displayLarge` jelas lebih penting daripada `bodyMedium`.
- **Semantik, Bukan Spesifik:** Anda harus berpikir secara semantik. Alih-alih berpikir "Saya butuh teks ukuran 24, bold", Anda harus berpikir "Saya butuh gaya untuk **subjudul halaman**". Anda kemudian memetakan peran "subjudul halaman" ke salah satu gaya `TextTheme`, misalnya `headlineSmall`. Jika di masa depan desain berubah, Anda hanya perlu mengubah definisi `headlineSmall` di `ThemeData`, dan semua subjudul di aplikasi Anda akan otomatis diperbarui.
- **Skala Tipografi Material Design:** Material Design 3 menyediakan skala tipografi standar yang sudah dipikirkan dengan baik, mencakup peran-peran seperti `display`, `headline`, `title`, `body`, dan `label`, masing-masing dengan varian `Large`, `Medium`, dan `Small`. Menggunakan skala ini sebagai titik awal adalah praktik yang sangat baik.

**Sintaks Dasar / Contoh Implementasi Inti:**
Mengintegrasikan font Poppins kustom kita ke dalam sistem tema aplikasi.

**Langkah 1: Definisikan `TextTheme` Kustom di `ThemeData`**

```dart
// file: theme/app_theme.dart (melanjutkan dari contoh sebelumnya)

class AppTheme {
  // Definisikan TextTheme kustom
  static const _customTextTheme = TextTheme(
    displayLarge: TextStyle(fontFamily: 'Poppins', fontSize: 57, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16, height: 1.5), // height untuk spasi baris
    labelLarge: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold),
  );

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    // 1. Terapkan TextTheme kustom ke ThemeData
    textTheme: _customTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // Gunakan gaya teks yang sudah didefinisikan untuk tombol
        textStyle: _customTextTheme.labelLarge,
      ),
    ),
    useMaterial3: true,
  );
  // ... (definisi darkTheme juga harus menyertakan textTheme)
}
```

**Langkah 2: Gunakan Gaya Teks dari Tema di UI**

```dart
// file: ui/screens/typography_screen.dart

class TypographyDemoScreen extends StatelessWidget {
  const TypographyDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Akses TextTheme dari context
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        // AppBar secara otomatis akan mencoba menggunakan gaya titleLarge
        title: const Text('Typography System'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 3. Terapkan gaya semantik ke widget Text
          const Text('Display Large', style: textTheme.displayLarge),
          const Divider(),
          const Text('Headline Medium', style: textTheme.headlineMedium),
          const Divider(),
          const Text(
            'Body Large: Ini adalah contoh paragraf yang menggunakan gaya bodyLarge dari TextTheme. Gaya ini konsisten di seluruh aplikasi.',
            style: textTheme.bodyLarge,
          ),
          const Divider(),
          const Text('Label Large (digunakan di tombol)', style: textTheme.labelLarge),
        ],
      ),
    );
  }
}
```

### **Visualisasi Konseptual (Struktur Sistem Tipografi)**

Diagram ini menjelaskan bagaimana `TextTheme` menjadi pusat dari semua gaya teks.

```
┌────────────────────────────────────────────────────────────┐
│ ThemeData                                                  │ // Objek Tema Pusat
│ ┌────────────────────────────────────────────────────────┐ │
│ │ textTheme: TextTheme(                                  │ │ // Definisi terpusat untuk semua gaya teks
│ │   headlineMedium: TextStyle(                           │ │
│ │     fontFamily: 'Poppins',                             │ │
│ │     fontSize: 28,                                      │ │
│ │     fontWeight: FontWeight.bold                        │ │
│ │   ),                                                   │ │
│ │   bodyLarge: TextStyle(                                │ │
│ │     fontFamily: 'Poppins',                             │ │
│ │     fontSize: 16,                                      │ │
│ │   ),                                                   │ │
│ │   ... (dan gaya lainnya)                               │ │
│ │ )                                                      │ │
│ └────────────────────────────────────────────────────────┘ │
└──────────────────────────┬─────────────────────────────────┘
                           │ (Disediakan ke seluruh aplikasi melalui context)
┌──────────────────────────▼─────────────────────────────────┐
│ Widget Text #1 (misalnya, di HomeScreen)                   │
│ └── style: Theme.of(context).textTheme.headlineMedium      │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ Widget Text #2 (misalnya, di DetailsScreen)                │
│ └── style: Theme.of(context).textTheme.headlineMedium      │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ Widget Text #3 (misalnya, di ProfileScreen)                │
│ └── style: Theme.of(context).textTheme.bodyLarge           │
└────────────────────────────────────────────────────────────┘
```

**Alur Keuntungan:** Jika Anda ingin mengubah semua `headlineMedium` menjadi ukuran 30, Anda hanya perlu mengubahnya di satu tempat (dalam `TextTheme` di `ThemeData`). Semua widget `Text` yang mereferensikan `headlineMedium` akan otomatis diperbarui, memastikan konsistensi tanpa perlu mencari dan mengganti setiap `TextStyle` secara manual.

---

Kita telah menyelesaikan pembahasan mengenai sistem tema dan tipografi. Kini kita akan beralih ke salah satu topik paling krusial dalam pengembangan aplikasi modern: membuat UI yang dapat beradaptasi dengan berbagai ukuran layar.Ini adalah salah satu area paling kritis dalam pengembangan aplikasi modern, yaitu memastikan aplikasi kita tidak hanya terlihat bagus, tetapi juga berfungsi dengan baik di ribuan perangkat dengan ukuran dan bentuk layar yang berbeda.

---

### **10.3. Responsive & Adaptive Design**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Di dunia dengan beragam perangkat—mulai dari ponsel kecil, ponsel lipat, tablet, hingga monitor desktop yang besar—membangun UI dengan ukuran yang kaku (_hardcoded_) adalah praktik yang tidak dapat diterima. Bagian ini mengajarkan dua konsep yang saling berhubungan namun berbeda:

- **Responsive Design:** Membuat UI yang secara cair **bereaksi** terhadap perubahan ukuran layar yang tersedia. Elemen-elemen mungkin akan menyusun ulang dirinya, mengubah ukuran, atau menyembunyikan/menampilkan konten.
- **Adaptive Design:** Membuat UI yang **beradaptasi** dengan platform atau konteks penggunaan yang berbeda. Ini bukan hanya tentang ukuran, tetapi juga tentang mengikuti konvensi desain spesifik platform (misalnya, menampilkan widget gaya iOS di iPhone) atau mengubah layout secara drastis untuk faktor bentuk yang berbeda (misalnya, layout tablet vs. ponsel).

Menguasai kedua konsep ini akan memungkinkan Anda membangun aplikasi yang benar-benar universal dan memberikan pengalaman pengguna yang optimal di semua perangkat.

---

#### **10.3.1. Responsive Design Patterns**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Desain responsif adalah tentang fleksibilitas. Daripada mendefinisikan layout dengan piksel yang tetap, Anda mendefinisikannya dengan aturan dan batasan yang memungkinkannya "mengalir" dan menyesuaikan diri. Bagian ini mengajarkan Anda tentang _widget_ dan teknik dasar di Flutter untuk membangun UI yang responsif terhadap perubahan dimensi.

**Konsep Kunci & Filosofi Mendalam:**

- **Constraints, Not Sizes:** Filosofi inti dari sistem layout Flutter sangat mendukung desain responsif. Anda jarang memberikan ukuran absolut pada sebuah widget. Sebaliknya, Anda menggunakan widget layout seperti `Expanded`, `Flexible`, atau `FractionallySizedBox` yang bekerja di dalam batasan (`constraints`) yang diberikan oleh induknya.
- **Breakpoints (Titik Henti):** Ini adalah ambang batas lebar layar di mana layout Anda berubah secara signifikan. Misalnya, Anda bisa mendefinisikan sebuah _breakpoint_ pada 600 piksel. Jika lebar layar \< 600px, tampilkan satu kolom. Jika \>= 600px, tampilkan dua kolom. Menentukan _breakpoint_ yang masuk akal adalah kunci dari desain responsif.
- **Widget Fundamental untuk Responsivitas:**
  - **`LayoutBuilder`:** Sebuah widget yang `builder`-nya memberikan Anda objek `BoxConstraints`. Dengan ini, Anda bisa mengetahui lebar dan tinggi maksimum yang tersedia untuk widget Anda dan membuat keputusan layout berdasarkan nilai tersebut. Sangat berguna untuk membuat widget individual menjadi responsif.
  - **`MediaQuery`:** Memberikan Anda informasi tentang seluruh layar, bukan hanya batasan dari widget induk. Anda bisa mendapatkan ukuran layar total, orientasi (potret/lanskap), _padding_ sistem (area _notch_), dan banyak lagi. Berguna untuk keputusan layout di tingkat halaman.
  - **`OrientationBuilder`:** Pintasan yang lebih sederhana untuk `MediaQuery` yang secara spesifik membangun ulang UI saat orientasi perangkat berubah antara `portrait` dan `landscape`.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini membuat sebuah halaman yang menampilkan dua kontainer. Di layar sempit (ponsel), mereka akan ditumpuk secara vertikal. Di layar lebar (tablet), mereka akan ditampilkan berdampingan.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget { /* ... */ }

class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responsive Design')),
      // 1. Gunakan LayoutBuilder untuk mendapatkan constraints
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // 2. Tentukan breakpoint
          if (constraints.maxWidth > 600) {
            // Jika layar lebar, gunakan Row
            return _buildWideLayout();
          } else {
            // Jika layar sempit, gunakan Column
            return _buildNarrowLayout();
          }
        },
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        // Gunakan Expanded agar setiap anak mengisi ruang yang tersedia
        Expanded(
          child: Container(color: Colors.blue, child: const Center(child: Text('Panel Kiri'))),
        ),
        Expanded(
          child: Container(color: Colors.green, child: const Center(child: Text('Panel Kanan'))),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        Expanded(
          child: Container(color: Colors.blue, child: const Center(child: Text('Panel Atas'))),
        ),
        Expanded(
          child: Container(color: Colors.green, child: const Center(child: Text('Panel Bawah'))),
        ),
      ],
    );
  }
}
```

### **Visualisasi Hasil Kode**

```
┌─────────────────────────────┐        ┌──────────────────────────────────────────────┐
│    Tampilan Layar Sempit    │        │             Tampilan Layar Lebar             │
│(constraints.maxWidth <= 600)│        │          (constraints.maxWidth > 600)        │
├─────────────────────────────┤        ├──────────────────────────────────────────────┤
│ AppBar: [Responsive Design] │        │ AppBar: [Responsive Design]                  │
│ --------------------------- │        │ -------------------------------------------- │
│                             │        │                                              │
│    ┌────────────────────┐   │        │  ┌────────────────────┬────────────────────┐ │
│    │     Panel Atas     │   │        │  │     Panel Kiri     │     Panel Kanan    │ │
│    │       (Biru)       │   │        │  │       (Biru)       │       (Hijau)      │ │
│    └────────────────────┘   │        │  └────────────────────┴────────────────────┘ │
│    ┌────────────────────┐   │        │                                              │
│    │    Panel Bawah     │   │        │                                              │
│    │      (Hijau)       │   │        │                                              │
│    └────────────────────┘   │        │                                              │
│                             │        │                                              │
└─────────────────────────────┘        └──────────────────────────────────────────────┘
```

### **Representasi Diagram Alur (Logika Responsif)**

```
┌──────────────────────────────────────────┐
│  LayoutBuilder                           │
│  (Widget Pembangun Responsif)            │
└───────────────┬──────────────────────────┘
                │
┌───────────────▼──────────────────────────┐
│  builder: (context, constraints) => {    │ // Builder dipanggil dengan constraints saat ini
└───────────────┬──────────────────────────┘
                │
┌───────────────▼──────────────────────────┐
│  if (constraints.maxWidth > 600)         │ // Kondisi: Pengecekan breakpoint
│  (Logika Keputusan)                      │
└───────────────┬──────────────────────────┘
      ┌─────────┴─────────┐
      │                   │
(TRUE / Layar Lebar)   (FALSE / Layar Sempit)
      │                   │
┌─────▼─────┐         ┌───▼────────┐
│ return    │         │ return     │
│ Row(...)  │         │ Column(...)│
└───────────┘         └────────────┘
```

---

#### **10.3.2. Adaptive Design**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Desain adaptif melangkah lebih jauh dari sekadar mengubah ukuran. Ini adalah tentang menghormati **idiom dan konvensi desain** dari platform tempat aplikasi berjalan. Pengguna Android terbiasa dengan komponen Material Design, sementara pengguna iOS terbiasa dengan gaya Cupertino. Membuat aplikasi yang adaptif berarti menyajikan komponen yang terasa "asli" bagi pengguna, yang secara signifikan meningkatkan kepercayaan dan kemudahan penggunaan.

**Konsep Kunci & Filosofi Mendalam:**

- **Platform sebagai Konteks:** Konteks utama untuk keputusan desain di sini bukanlah ukuran layar, melainkan sistem operasi. Anda secara eksplisit memeriksa: "Apakah aplikasi ini berjalan di iOS? Jika ya, tampilkan `CupertinoSwitch`. Jika tidak (misalnya Android), tampilkan `Switch` Material."
- **Deteksi Platform:** Flutter menyediakan cara mudah untuk mendeteksi platform saat ini melalui objek global `Platform` dari `dart:io`. Namun, ini tidak berfungsi di web. Pendekatan yang lebih modern dan universal adalah menggunakan `Theme.of(context).platform`, yang mengembalikan `TargetPlatform`.
- **Kapan Harus Adaptif?** Anda tidak perlu membuat setiap widget menjadi adaptif. Praktik terbaiknya adalah fokus pada komponen yang memiliki perbedaan interaksi atau visual yang sangat mencolok antar platform, seperti:
  - Dialog peringatan (`AlertDialog` vs. `CupertinoAlertDialog`)
  - Indikator aktivitas (`CircularProgressIndicator` vs. `CupertinoActivityIndicator`)
  - Tombol geser (`Switch` vs. `CupertinoSwitch`)
  - Struktur navigasi tingkat atas.

**Sintaks Dasar / Contoh Implementasi Inti:**
Membuat sebuah widget `AdaptiveSwitch` yang merender dirinya secara berbeda di iOS dan Android.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform; // Cara klasik, tapi tidak bekerja di web

class AdaptiveScreen extends StatefulWidget {
  const AdaptiveScreen({super.key});
  @override
  State<AdaptiveScreen> createState() => _AdaptiveScreenState();
}

class _AdaptiveScreenState extends State<AdaptiveScreen> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Design')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notifikasi', style: TextStyle(fontSize: 18)),
              _buildAdaptiveSwitch(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget yang membuat keputusan adaptif
  Widget _buildAdaptiveSwitch() {
    // Pendekatan modern yang juga bekerja di web
    final TargetPlatform platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      // Tampilkan gaya Cupertino untuk platform Apple
      return CupertinoSwitch(
        value: _switchValue,
        onChanged: (value) {
          setState(() {
            _switchValue = value;
          });
        },
      );
    } else {
      // Tampilkan gaya Material untuk platform lain (Android, Windows, Linux)
      return Switch(
        value: _switchValue,
        onChanged: (value) {
          setState(() {
            _switchValue = value;
          });
        },
      );
    }
  }
}
```

### **Visualisasi Hasil Kode**

```
┌──────────────────────────┐        ┌──────────────────────────┐
│  Tampilan di Android     │        │  Tampilan di iOS         │
│   (Material Design)      │        │  (Cupertino Design)      │
├──────────────────────────┤        ├──────────────────────────┤
│ AppBar: [Adaptive Design]│        │ AppBar: [Adaptive Design]│
│ ------------------------ │        │ ------------------------ │
│                          │        │                          │
│  Notifikasi      [▢---]  │        │  Notifikasi    [---▢]    │
│                 (Bulat)  │        │               (Lonjong)  │
│                          │        │                          │
│                          │        │                          │
└──────────────────────────┘        └──────────────────────────┘
```

### **Representasi Diagram Alur (Logika Adaptif)**

```
┌──────────────────────────────────┐
│  _buildAdaptiveSwitch()          │
│  (Widget Pembangun Adaptif)      │
└──────────────┬───────────────────┘
               │
┌──────────────▼───────────────────┐
│  Theme.of(context).platform      │ // Mendapatkan platform saat ini
│  (Deteksi Konteks)               │
└──────────────┬───────────────────┘
               │
┌──────────────▼───────────────────────┐
│  if (platform == TargetPlatform.iOS) │
│  (Logika Keputusan)                  │
└──────────────┬───────────────────────┘
      ┌────────┴──────────┐
      │                   │
 (TRUE / Platform Apple) (FALSE / Platform Lain)
      │                   │
┌─────▼──────────┐    ┌───▼────────────────┐
│     return     │    │        return      │
│CupertinoSwitch │    │  Switch (Material) │
└────────────────┘    └────────────────────┘
```

---

#### **10.3.3. Multi-Screen Support**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Dukungan multi-layar adalah evolusi dari desain responsif. Ini bukan hanya tentang mengubah satu `Row` menjadi `Column`, tetapi tentang menyajikan **pola layout yang sama sekali berbeda** untuk memanfaatkan ruang layar yang lebih besar secara efektif. Kasus penggunaan yang paling umum adalah layout **Master-Detail**, di mana layar lebar (tablet/desktop) menampilkan daftar item (master) di satu sisi dan detail dari item yang dipilih (detail) di sisi lain secara bersamaan. Di layar sempit (ponsel), kedua bagian ini ditampilkan sebagai dua layar terpisah.

**Konsep Kunci & Filosofi Mendalam:**

- **Memanfaatkan Ruang:** Filosofinya adalah bahwa lebih banyak ruang layar harus memberikan lebih banyak informasi atau fungsionalitas, bukan hanya membuat elemen yang ada menjadi lebih besar.
- **State Management yang Terkoordinasi:** Dalam layout master-detail, _state_ item yang dipilih di panel _master_ harus mengontrol konten apa yang ditampilkan di panel _detail_. Ini memerlukan _state management_ (seperti `Provider` atau `BLoC`) yang dapat diakses oleh kedua panel untuk berkomunikasi.
- **Navigasi yang Berbeda:** Di layar lebar, mengklik item di daftar _master_ hanya memperbarui panel _detail_. Di layar sempit, mengklik item yang sama akan melakukan navigasi `push` ke halaman detail yang baru. Logika navigasi Anda harus sadar akan layout saat ini.

**Contoh Implementasi (Konseptual):**
Mengimplementasikan master-detail dari awal bisa sangat kompleks. Namun, secara konseptual, kita bisa menggunakan `LayoutBuilder` untuk memutuskan arsitektur mana yang akan dirender.

```dart
// --- Konsep dengan LayoutBuilder ---
class MasterDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 720) { // Breakpoint untuk Tablet
          return TabletLayout(); // Menampilkan dua panel berdampingan
        } else {
          return PhoneLayout(); // Menampilkan satu panel (master)
        }
      },
    );
  }
}

// --- Layout untuk Tablet ---
class TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Panel Kiri (Master)
        SizedBox(
          width: 300,
          child: ItemList(
            onItemSelected: (id) {
              // Panggil state management untuk memperbarui ID item yang dipilih
              // Contoh: context.read<ItemBloc>().add(SelectItem(id));
            },
          ),
        ),
        // Panel Kanan (Detail)
        Expanded(
          child: ItemDetails(), // Widget ini akan mendengarkan state item yang dipilih
        ),
      ],
    );
  }
}

// --- Layout untuk Ponsel ---
class PhoneLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Hanya menampilkan daftar item.
    // Navigasi ke detail terjadi di dalam ItemList.
    return ItemList(
      onItemSelected: (id) {
        // Lakukan navigasi ke halaman baru
        // Contoh: context.go('/items/$id');
      },
    );
  }
}
```

### **Visualisasi Hasil Kode**

```
┌──────────────────────────┐        ┌──────────────────────────────────────────────┐
│ Tampilan di Ponsel       │        │  Tampilan di Tablet/Desktop                  │
├──────────────────────────┤        ├──────────────────────────────────────────────┤
│ AppBar: [Daftar Item]    │        │ AppBar: [Aplikasi Saya]                      │
│ ------------------------ │        │ -------------------------------------------- │
│                          │        │ ┌────────────────────┬─────────────────────┐ │
│  - Item 1                │        │ │ - Item 1           │                     │ │
│  - Item 2      (KLIK) ---┼───────►│ │ - Item 2           │   Detail untuk      │ │
│  - Item 3                │        │ │ - Item 3  (AKTIF)  │   Item 3            │ │
│  - Item 4                │        │ │ - Item 4           │   ...               │ │
│                          │        │ │                    │                     │ │
│                          │        │ │                    │                     │ │
│ ┌────────────────────┐   │        │ └────────────────────┴─────────────────────┘ │
│ │ Halaman Detail     │   │        │                                              │
│ │ untuk Item 2       │   │        │                                              │
│ │ (Setelah Navigasi) │   │        │                                              │
│ └────────────────────┘   │        │                                              │
└──────────────────────────┘        └──────────────────────────────────────────────┘
```

Alur di ponsel adalah navigasi sekuensial (layar ke layar), sedangkan di tablet adalah pembaruan panel secara berdampingan.

---

Kita telah menyelesaikan pembahasan yang sangat penting mengenai desain yang responsif dan adaptif. Kini aplikasi kita sudah memiliki gaya yang konsisten dan dapat beradaptasi. Langkah selanjutnya adalah membuatnya terasa "hidup" dan interaktif. Kita akan memasuki dunia animasi, yang akan mengubah aplikasi Anda dari statis dan fungsional menjadi dinamis dan menyenangkan.

### **11. Animations & Visual Effects**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Animasi adalah ilusi gerak yang dibuat dengan menampilkan serangkaian gambar diam secara cepat. Dalam pengembangan UI, animasi adalah alat yang sangat kuat untuk:

1.  **Memberikan Umpan Balik:** Menunjukkan bahwa sebuah aksi telah berhasil (misalnya, tombol yang berdenyut saat ditekan).
2.  **Mengarahkan Perhatian:** Menarik mata pengguna ke elemen penting.
3.  **Menciptakan Transisi yang Mulus:** Menghaluskan perubahan antar state atau layar, membuatnya terasa alami, bukan tiba-tiba.
4.  **Meningkatkan Estetika:** Membuat aplikasi terasa lebih dipoles dan berkualitas tinggi.

Bagian ini akan mengajarkan Anda dari dasar-dasar framework animasi Flutter hingga teknik-teknik lanjutan dan penggunaan library eksternal untuk menciptakan efek visual yang menakjubkan.

---

### **11.1. Basic Animation System**

#### **11.1.1. Animation Framework**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah fondasi dari semua animasi **eksplisit** di Flutter. Animasi eksplisit adalah jenis animasi di mana Anda memiliki kontrol penuh atas setiap aspeknya: durasi, kurva, dan apa yang terjadi di setiap _frame_. Bagian ini akan memperkenalkan Anda pada "mesin" di balik animasi Flutter, yang terdiri dari beberapa kelas inti yang bekerja sama seperti sebuah orkestra untuk menciptakan gerakan. Memahami framework ini sangat penting untuk membuat animasi kustom yang tidak dapat dicapai hanya dengan widget animasi implisit.

**Konsep Kunci & Filosofi Mendalam:**

- **Pemisahan Tanggung Jawab:** Framework animasi Flutter dirancang dengan sangat baik dengan memisahkan berbagai tanggung jawab ke dalam kelas-kelas yang berbeda:
  1.  **`AnimationController`:** Ini adalah "Konduktor" atau "Sutradara" dari animasi. Tugasnya adalah menghasilkan nilai numerik yang berubah dari waktu ke waktu (biasanya dari 0.0 ke 1.0) selama durasi yang ditentukan. Ia mengontrol kapan animasi dimulai (`.forward()`), berhenti (`.stop()`), berbalik (`.reverse()`), atau berulang (`.repeat()`).
  2.  **`Ticker`:** Ini adalah "Detak Jantung" dari aplikasi. Ia menyediakan sinyal yang sinkron dengan _refresh rate_ layar (biasanya 60 kali per detik). Setiap kali _ticker_ "berdetak", ia akan memanggil _callback_ yang memberitahu `AnimationController` untuk memperbarui nilainya. Anda biasanya tidak berinteraksi langsung dengan `Ticker`, tetapi menyediakannya melalui `TickerProvider`.
  3.  **`Tween` (dari "in-between"):** Ini adalah "Penerjemah". Ia tidak tahu apa-apa tentang durasi atau detak jantung. Tugasnya hanya memetakan rentang input (yang hampir selalu 0.0 - 1.0 dari `AnimationController`) ke rentang output yang Anda inginkan. Misalnya, `ColorTween(begin: Colors.blue, end: Colors.red)` akan menerjemahkan nilai 0.0 menjadi biru, 0.5 menjadi ungu, dan 1.0 menjadi merah. `SizeTween` akan menerjemahkan 0.0-1.0 menjadi ukuran 100-200.
  4.  **`Animation`:** Ini adalah objek hasil akhir yang "didengarkan" oleh widget. `Animation` menggabungkan `AnimationController` dan `Tween` untuk memberikan nilai yang sudah diterjemahkan pada setiap _frame_.
- **`AnimatedBuilder` untuk Optimisasi:** Daripada memanggil `setState()` pada setiap detak animasi (yang akan membangun ulang seluruh layar), praktik terbaiknya adalah menggunakan widget `AnimatedBuilder`. `AnimatedBuilder` akan mendengarkan `AnimationController` dan hanya akan membangun ulang _widget sub-tree_ yang Anda berikan di dalam `builder`-nya, membuat animasi menjadi sangat efisien.

**Terminologi Esensial & Penjelasan Detil:**

- **`AnimationController`:** Objek utama yang mengelola progres dan state animasi (maju, mundur, berhenti).
- **`TickerProvider` (biasanya `SingleTickerProviderStateMixin`):** Sebuah _mixin_ yang ditambahkan ke kelas `State` dari `StatefulWidget` Anda. Tugasnya adalah menyediakan `Ticker` untuk `AnimationController`.
- **`Tween`:** Objek yang mendefinisikan rentang nilai awal dan akhir dari sebuah properti yang akan dianimasikan.
- **`.animate()`:** Metode yang digunakan untuk menghubungkan sebuah `Tween` ke sebuah `AnimationController`, menghasilkan objek `Animation`.
- **`Curve`:** Sebuah objek yang mendefinisikan laju perubahan animasi, membuatnya tidak linear. Contoh: `Curves.easeIn` (memulai dengan lambat, lalu cepat), `Curves.bounce` (memantul).

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini membuat sebuah logo Flutter yang membesar dan memudar saat layar pertama kali dimuat.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget { /* ... */ }

class BasicAnimationScreen extends StatefulWidget {
  const BasicAnimationScreen({super.key});
  @override
  State<BasicAnimationScreen> createState() => _BasicAnimationScreenState();
}

// 1. Tambahkan TickerProviderStateMixin ke kelas State
class _BasicAnimationScreenState extends State<BasicAnimationScreen>
    with SingleTickerProviderStateMixin {
  // 2. Deklarasikan Controller dan Animation
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // 3. Inisialisasi Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this, // 'this' merujuk ke TickerProvider
    );

    // 4. Buat Animasi menggunakan Tween dan Curve
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // 5. Mulai animasi
    _controller.forward();
  }

  @override
  void dispose() {
    // 6. Selalu dispose controller untuk mencegah memory leak!
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animation Framework')),
      body: Center(
        // 7. Gunakan AnimatedBuilder untuk efisiensi
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // child di sini adalah FlutterLogo yang kita berikan di bawah.
            // Ini mencegah FlutterLogo dibuat ulang di setiap frame.
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: const FlutterLogo(size: 200),
        ),
      ),
    );
  }
}
```

### **Visualisasi Hasil Kode**

_Mockup_ ini menggambarkan progresi animasi dari waktu ke waktu.

```
┌────────────────────┐      ┌────────────────────┐      ┌────────────────────┐
│  t = 0.0 detik     │      │  t = 1.0 detik     │      │  t = 2.0 detik     │
├────────────────────┤      ├────────────────────┤      ├────────────────────┤
│                    │      │                    │      │                    │
│                    │      │                    │      │                    │
│                    │      │        (LOGO)      │      │     (LOGO)         │
│      (LOGO)        │      │    (Ukuran 75%)    │      │  (Ukuran 100%)     │
│  (Ukuran 50%)      │      │    (Opacity 50%)   │      │  (Opacity 100%)    │
│  (Opacity 0%)      │      │                    │      │                    │
│                    │      │                    │      │                    │
│                    │      │                    │      │                    │
└────────────────────┘      └────────────────────┘      └────────────────────┘
   (Animasi Dimulai)           (Tengah Animasi)           (Animasi Selesai)
```

### **Representasi Diagram Alur (Framework Animasi)**

```
┌───────────────────────────┐
│  StatefulWidget dengan    │ // 'Penyedia Detak Jantung'
│ `TickerProviderStateMixin`│
└─────────────┬─────────────┘
              │ vsync
┌─────────────▼─────────────┐
│  AnimationController      │ // 'Sutradara' (0.0 -> 1.0)
│  (duration: 2s)           │
└─────────────┬─────────────┘
      ┌───────┴──────────────┐
      │                      │
┌─────▼──────────┐     ┌─────▼──────────┐
│  Tween<double> │     │  Tween<double> │ // 'Penerjemah'
│  (0.5 -> 1.0)  │     │  (0.0 -> 1.0)  │
└─────┬──────────┘     └─────┬──────────┘
      │.animate(_controller) │ .animate(_controller)
┌─────▼──────────┐     ┌─────▼──────────┐
│_scaleAnimation │     │_fadeAnimation  │ // Hasil akhir yang 'didengarkan'
└────────────────┘     └────────────────┘
      │                      │
      └──────┬───────────────┘
             │     (diberikan ke properti 'animation')
┌────────────▼───────────────┐
│  AnimatedBuilder           │ // 'Aktor' yang efisien
│  ┌───────────────────────┐ │
│  │ builder: (ctx, child) │ │
│  │ ┌───────────────────┐ │ │
│  │ │ Opacity(          │ │ │
│  │ │  opacity:         │ │ │ // Mengambil nilai .value terbaru
│  │ │   _fadeAnimation. │ │ │ // dari animasi di setiap frame.
│  │ │   value           │ │ │
│  │ │ )                 │ │ │
│  │ │ Transform.scale(  │ │ │
│  │ │   scale:          │ │ │
│  │ │   _scaleAnimation.│ │ │
│  │ │   value           │ │ │
│  │ │ )                 │ │ │
│  │ └───────────────────┘ │ │
│  └───────────────────────┘ │
└────────────────────────────┘
```

---

Kita telah menyelesaikan fondasi dari animasi eksplisit. Sekarang, kita akan membangun di atas fondasi ini untuk melihat berbagai pola dan teknik animasi tingkat lanjut.

---

### **11.2. Advanced Animations**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Bagian ini membahas teknik-teknik dan widget-widget spesifik yang menggunakan _animation framework_ untuk menciptakan efek visual yang umum dan mengesankan. Kita akan belajar cara membuat transisi antar halaman yang mulus (`Hero`), membangun animasi kustom untuk perpindahan halaman, dan memahami perbedaan antara animasi implisit dan eksplisit untuk memilih alat yang tepat untuk setiap pekerjaan.

---

##### **11.2.1. Hero Animations**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Animasi **Hero** adalah salah satu efek visual yang paling mengesankan dan mudah diimplementasikan di Flutter. Ia menciptakan ilusi di mana sebuah widget "terbang" dari satu layar ke layar lain dan berubah bentuk serta ukuran di sepanjang jalan. Kasus penggunaan paling umum adalah untuk gambar mini produk di halaman daftar yang membesar menjadi gambar utama di halaman detail. Perannya adalah untuk mengajarkan cara membuat transisi antar halaman yang sinematik dan terfokus, yang memberikan konteks visual yang kuat kepada pengguna.

**Konsep Kunci & Filosofi Mendalam:**

- **Shared Element Transition:** Konsep intinya adalah "transisi elemen bersama". Flutter mengidentifikasi dua widget `Hero` di dua layar berbeda yang memiliki `tag` yang sama. Saat navigasi terjadi, Flutter tidak menghancurkan widget pertama dan membuat yang kedua. Sebaliknya, ia menganimasikan transformasi (posisi, ukuran, bentuk) dari widget pertama ke properti widget kedua di atas semua layar lainnya.
- **Tag sebagai Identifier:** Properti `tag` adalah kunci dari semuanya. Ini haruslah sebuah objek yang unik yang sama untuk widget `Hero` di layar awal dan layar tujuan. Biasanya ini adalah ID unik dari data yang ditampilkan (misalnya, `product.id`).

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini menunjukkan daftar lingkaran berwarna. Saat sebuah lingkaran disentuh, ia akan "terbang" dan membesar menjadi layar detail dengan warna yang sama.

```dart
// file: ui/hero_list_screen.dart
class HeroListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Animation: List')),
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: List.generate(5, (index) {
            final color = Colors.primaries[index * 2];
            final tag = 'color_box_$index'; // 1. Buat tag yang unik

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HeroDetailScreen(color: color, tag: tag),
                ));
              },
              // 2. Bungkus widget di layar awal dengan Hero
              child: Hero(
                tag: tag,
                child: Container(
                  width: 100,
                  height: 100,
                  color: color,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// file: ui/hero_detail_screen.dart
class HeroDetailScreen extends StatelessWidget {
  final Color color;
  final String tag;

  const HeroDetailScreen({super.key, required this.color, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Animation: Detail')),
      // 3. Bungkus widget di layar tujuan dengan Hero yang memiliki tag SAMA
      body: Hero(
        tag: tag,
        child: Container(
          color: color,
        ),
      ),
    );
  }
}
```

### **Visualisasi Hasil Kode & Alur**

```
┌──────────────────────────┐        ┌──────────────────────────┐
│  Layar Daftar (Awal)     │        │  Layar Detail (Tujuan)   │
├──────────────────────────┤        ├──────────────────────────┤
│ AppBar: [Hero List]      │        │ AppBar: [Hero Detail]    │
│ ------------------------ │        │ ------------------------ │
│                          │        │                          │
│  [■] [■] [■]             │        │                          │
│   (merah)                │        │                          │
│      (KLIK)              │        │                          │
│       │                  │        │  ┌────────────────────┐  │
│       └─────────┐        │        │  │                    │  │
│  [■] [■]        │        │        │  │      (MERAH)       │  │
│                 │        │        │  │                    │  │
└─────────────────┼────────┘        │  │                    │  │
                  │                 │  └────────────────────┘  │
                  │                 └──────────────────────────┘
                  │
                  └─► (Animasi Transisi: Kotak merah 'terbang'
                         dan membesar mengisi seluruh layar)
```

---

Kita telah membahas framework dasar dan Hero Animations.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md
[fase7]: ../../flash/bagian-7/README.md

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
