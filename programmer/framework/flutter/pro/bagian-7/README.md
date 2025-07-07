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

Kita telah menyelesaikan arsitektur tema. Selanjutnya, kita akan fokus pada salah satu aspek terpenting dari desain: tipografi.

Saya akan melanjutkan ke **10.2 Typography & Font Management**.

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
