> [flash][pro7]

# **[FASE 7: Styling, Theming & Responsive Design][0]**

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- **[10. Advanced Theming System](#10-advanced-theming-system)**

  - **[10.1 Theme Architecture](#101-theme-architecture)**
    - Material Theme System
    - `ThemeData` configuration
    - Color scheme definition
    - Typography themes
    - Component themes
    - Dark theme implementation
    - Theme switching
    - Material 3 Dynamic Theming (termasuk _Dynamic color generation_, _Color harmonization_, _Seed color usage_, _Platform integration_, dan _Dynamic Color Package_)
    - Custom Theme Implementation (termasuk _Theme extensions_, _Custom color schemes_, _Component theme customization_, dan _Theme inheritance_)
  - **[10.2 Typography & Font Management](#102-typography--font-management)**
    - Font Integration (termasuk _Custom font loading_, _Font fallbacks_, _Variable fonts_, dan _Icon fonts_)
    - Text scaling
    - Penggunaan _Custom Fonts_, _Google Fonts Package_, dan _Font Awesome Icons_
    - Typography Systems (termasuk _Material typography scale_, _Custom typography themes_, _Text style inheritance_, _Responsive typography_, dan _Accessibility considerations_)

- **10. Advanced Theming System (Lanjutan)**
  - **[10.3 Responsive & Adaptive Design](#103-responsive--adaptive-design)**
    - Responsive Design Patterns (termasuk _Breakpoint management_, _Fluid layouts_, _Responsive widgets_, dan _Container queries_)
    - Screen size adaptation
    - _LayoutBuilder_ Usage
    - _MediaQuery Best Practices_
    - Adaptive Design (termasuk _Platform-specific UI_, _Adaptive widgets_, _Platform detection_, _Material vs Cupertino switching_, dan _Desktop adaptations_)
    - _Platform Adaptive Widgets_ (_Adaptive Scaffold_)
    - Multi-Screen Support (termasuk _Tablet layouts_, _Desktop layouts_, _Foldable device support_, _Multi-window support_, dan _Window size classes_)
- **[11. Animations & Visual Effects](#11-animations--visual-effects)**
  - **[11.1 Basic Animation System](#111-basic-animation-system)**
    - Animation Framework (termasuk _Animation controllers_, _Tween animations_, _Curved animations_, _Animation listeners_, dan _Animation status tracking_)
    - _Animations Tutorial_ (_AnimationController_, _Tween Animations_)
  - **[11.2 Advanced Animations](#112-advanced-animations)**
    - _Hero Animations_ (termasuk _Hero widget implementation_, _Custom hero animations_, _Hero flight paths_, dan _Nested hero animations_)
    - _Page Transitions_ (termasuk _Custom page routes_, _Transition builders_, dan _Shared element transitions_)
    - _Implicit & Explicit Animations_ (_AnimatedContainer usage_, _AnimatedOpacity dan variants_, _TweenAnimationBuilder_, dan _AnimationBuilder pattern_)
    - _Physics-Based Animations_ (_Spring simulations_, _Physics simulation_, _Friction dan gravity_, dan _Custom physics_)
    - _Spring Animations_
  - **[11.3 External Animation Libraries](#113-external-animation-libraries)**
    - _Lottie Animations_ (termasuk _Lottie file integration_, _Animation controllers_, _Dynamic properties_, dan _Performance optimization_)
    - _Rive Animations_ (termasuk _Rive file setup_, _State machines_, _Interactive animations_, dan _Custom artboards_)
- **[12. Custom Painting & Graphics](#12-custom-painting--graphics)**
  - **[12.1 Custom Painter](#121-custom-painter)**
    - _Canvas API_ (termasuk _Drawing primitives_, _Path creation_, _Paint properties_, _Clipping dan masking_, dan _Performance optimization_)
    - _Advanced Custom Painting_ (termasuk _Gradient painting_, _Shadow effects_, _Text painting_, _Image painting_, dan _Custom shapes_)
    - _SVG Integration_ (termasuk _SVG asset loading_, _SVG customization_, _Path parsing_, dan _Vector icons_)

</details>

---

#### **10. Advanced Theming System**

- **Peran:** Sistem _theming_ yang canggih memungkinkan Anda mengelola tampilan dan nuansa (look and feel) aplikasi secara terpusat. Ini krusial untuk menjaga konsistensi UI, memfasilitasi perubahan _brand_, mendukung mode gelap/terang, dan memastikan pengalaman pengguna yang kohesif. Dengan _advanced theming_, Anda dapat mendefinisikan estetika aplikasi di satu tempat dan menerapkannya secara otomatis ke seluruh _widget_.

---

##### **10.1 Theme Architecture**

- **Peran:** Arsitektur _theme_ mengacu pada cara Anda menstrukturkan dan menerapkan tema dalam aplikasi Flutter Anda. Ini melibatkan penggunaan _widget_ bawaan Flutter seperti `Theme` dan `ThemeData`, serta `Material 3` untuk pendekatan _theming_ yang lebih modern dan dinamis.

- **Material Theme System:**

  - **Peran:** Sistem desain Material Design oleh Google menyediakan panduan komprehensif untuk _UI/UX_, termasuk aspek _theming_. Flutter mengimplementasikan Material Design, memungkinkan pengembang untuk membuat aplikasi yang sesuai dengan standar visual Google.
  - **Detail:** Inti dari sistem ini adalah `ThemeData` yang mendefinisikan properti visual seperti warna, tipografi, bentuk, dan efek bayangan untuk berbagai _widget_.

- **`ThemeData` Configuration:**

  - **Peran:** `ThemeData` adalah kelas di Flutter yang menyimpan semua properti visual yang digunakan oleh _widget_ Material Design. Anda mendefinisikan _theme_ aplikasi dengan membuat _instance_ `ThemeData` dan menetapkannya ke properti `theme` dari `MaterialApp`.
  - **Detail:** `ThemeData` memiliki konstruktor yang memungkinkan Anda mengatur berbagai properti seperti `primaryColor`, `accentColor`, `textTheme`, `appBarTheme`, `buttonTheme`, dll.

- **Color Scheme Definition:**

  - **Peran:** Sejak Material 3, penekanan lebih besar diberikan pada `ColorScheme` sebagai cara terstruktur untuk mendefinisikan warna tema. `ColorScheme` membantu dalam menciptakan palet warna yang harmonis dan dapat diakses, dengan peran yang jelas untuk setiap warna (misalnya, `primary`, `onPrimary`, `secondary`, `error`, `surface`, `background`).
  - **Detail:** Anda dapat membuat `ColorScheme` dari _seed color_ (warna benih) menggunakan `ColorScheme.fromSeed()` atau mendefinisikannya secara manual. Warna-warna ini kemudian digunakan oleh `ThemeData` untuk mewarnai komponen.

- **Typography Themes:**

  - **Peran:** Mendefinisikan gaya teks (font family, ukuran, bobot, tinggi baris) untuk berbagai elemen teks dalam aplikasi Anda (misalnya, judul, subjudul, _body text_). Ini memastikan konsistensi tipografi di seluruh aplikasi.
  - **Detail:** Diatur melalui properti `textTheme` dari `ThemeData`, yang merupakan _instance_ dari `TextTheme`. `TextTheme` memiliki properti seperti `headlineLarge`, `titleMedium`, `bodySmall`, dll., yang masing-masing dapat Anda kustomisasi.

- **Component Themes:**

  - **Peran:** Memungkinkan Anda mengatur gaya default untuk _widget_ tertentu (misalnya, `AppBar`, `ElevatedButton`, `Card`) di seluruh aplikasi, tanpa harus mengatur properti satu per satu di setiap _instance widget_.
  - **Detail:** `ThemeData` memiliki properti seperti `appBarTheme`, `elevatedButtonTheme`, `cardTheme`, dll. Anda membuat _instance_ dari _theme_ komponen (misalnya, `AppBarTheme`, `ElevatedButtonThemeData`) dan menetapkannya ke properti yang sesuai.

- **Dark Theme Implementation:**

  - **Peran:** Menyediakan tema alternatif (biasanya dengan latar belakang gelap dan teks terang) untuk meningkatkan kenyamanan visual di lingkungan gelap dan menghemat baterai pada layar OLED.
  - **Detail:** Anda mendefinisikan dua _instance_ `ThemeData`: satu untuk tema terang (`ThemeData.light()`) dan satu untuk tema gelap (`ThemeData.dark()`). Properti `theme` dan `darkTheme` di `MaterialApp` digunakan untuk menetapkannya. Properti `themeMode` (misalnya, `ThemeMode.system`, `ThemeMode.light`, `ThemeMode.dark`) kemudian mengontrol tema mana yang aktif.

- **Theme Switching:**

  - **Peran:** Memungkinkan pengguna untuk beralih antara tema terang dan gelap (atau tema kustom lainnya) secara dinamis selama aplikasi berjalan.
  - **Mekanisme:** Anda biasanya menyimpan preferensi tema pengguna (misalnya, di `SharedPreferences`) dan menggunakan _state management solution_ (misalnya, `Provider`, `Riverpod`, `BLoC`) untuk memperbarui `themeMode` dari `MaterialApp` secara reaktif.

- **Contoh Kode (Theme Architecture dengan Material 3):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:shared_preferences/shared_preferences.dart'; // Untuk menyimpan preferensi tema

  // Kelas untuk mengelola preferensi tema
  class ThemeService extends ChangeNotifier {
    ThemeMode _themeMode = ThemeMode.system; // Default system

    ThemeMode get themeMode => _themeMode;

    ThemeService() {
      _loadThemeMode();
    }

    // Memuat preferensi tema dari SharedPreferences
    Future<void> _loadThemeMode() async {
      final prefs = await SharedPreferences.getInstance();
      final String? storedMode = prefs.getString('themeMode');
      if (storedMode == 'light') {
        _themeMode = ThemeMode.light;
      } else if (storedMode == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
      notifyListeners(); // Beri tahu listener jika mode berubah saat startup
    }

    // Mengubah tema dan menyimpannya ke SharedPreferences
    Future<void> setThemeMode(ThemeMode mode) async {
      if (_themeMode == mode) return; // Hindari update yang tidak perlu
      _themeMode = mode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('themeMode', mode.name); // Simpan nama enum
      notifyListeners(); // Beri tahu listener (widget yang menggunakan ini)
    }
  }


  void main() {
    // Untuk menggunakan ThemeService dengan Provider
    // Anda perlu menambahkan package provider: ^latest_version di pubspec.yaml
    // import 'package:provider/provider.dart';
    // runApp(
    //   ChangeNotifierProvider(
    //     create: (context) => ThemeService(),
    //     child: const MyApp(),
    //   ),
    // );
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      // Tanpa Provider, kita akan menggunakan ThemeService sebagai global/singleton sederhana
      // Dalam aplikasi nyata, gunakan Provider/BLoC/Riverpod untuk ThemeService
      final ThemeService themeService = ThemeService(); // Contoh sederhana, bukan praktik terbaik untuk global state

      return ListenableBuilder( // Untuk merebuild MaterialApp saat themeMode berubah
        listenable: themeService,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Theming Demo',
            theme: AppThemes.lightTheme, // Tema terang
            darkTheme: AppThemes.darkTheme, // Tema gelap
            themeMode: themeService.themeMode, // Mengontrol tema yang aktif
            home: const HomeScreen(),
          );
        },
      );
    }
  }

  class AppThemes {
    // Seed color untuk Material 3 Dynamic Theming
    static const Color _seedColor = Colors.deepPurple;

    // Tema Terang (Light Theme)
    static ThemeData lightTheme = ThemeData(
      useMaterial3: true, // Aktifkan Material 3
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
      // Contoh kustomisasi Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold, color: Colors.black87),
        titleLarge: TextStyle(fontSize: 22.0, fontStyle: FontStyle.italic, color: Colors.deepPurple),
        bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black54),
      ),
      // Contoh kustomisasi Component Theme (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _seedColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _seedColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _seedColor,
        foregroundColor: Colors.white,
      ),
    );

    // Tema Gelap (Dark Theme)
    static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold, color: Colors.white70),
        titleLarge: TextStyle(fontSize: 22.0, fontStyle: FontStyle.italic, color: Colors.deepPurpleAccent),
        bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white54),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _seedColor.shade200, // Warna lebih terang untuk dark theme
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _seedColor.shade900,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _seedColor.shade200,
        foregroundColor: Colors.black,
      ),
    );
  }

  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
      final ThemeService themeService = ThemeService(); // Akses ThemeService
      return Scaffold(
        appBar: AppBar(
          title: const Text('Advanced Theming'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to Themed App!',
                  style: Theme.of(context).textTheme.displayLarge, // Menggunakan typography theme
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'This is a body text example, demonstrating theme inheritance.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Menggunakan component theme dari ThemeData
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Button Pressed!')),
                    );
                  },
                  child: const Text('Press Me'),
                ),
                const SizedBox(height: 20),
                FloatingActionButton.extended(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('FAB Pressed!')),
                    );
                  },
                  label: const Text('Action'),
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(height: 30),
                Text('Current Theme Mode: ${themeService.themeMode.name}'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => themeService.setThemeMode(ThemeMode.light),
                      child: const Text('Light Theme'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => themeService.setThemeMode(ThemeMode.dark),
                      child: const Text('Dark Theme'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => themeService.setThemeMode(ThemeMode.system),
                      child: const Text('System Theme'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  ```

- **Sumber Daya Tambahan:**

  - [Flutter Theming](https://flutter.dev/docs/cookbook/design/themes)
  - [Material 3 Theming](https://m3.material.io/styles/color/the-color-system)

---

- **Material 3 Dynamic Theming**

  - **Peran:** Sebuah fitur inti dari Material 3 yang memungkinkan aplikasi untuk menghasilkan palet warna dinamis berdasarkan warna _wallpaper_ perangkat pengguna (di Android 12+), atau dari _seed color_ yang Anda tentukan. Ini menciptakan pengalaman yang sangat personal dan terintegrasi dengan sistem operasi.

  - **Detail:** Mekanisme ini menggunakan algoritma Monochromatic Color Extraction dari _wallpaper_ atau _seed color_ untuk menghasilkan `ColorScheme` yang lengkap dengan peran warna yang berbeda (primer, sekunder, tersier, netral, dll.).

  - **Dynamic Color Generation:**

    - **Peran:** Proses otomatis untuk menghasilkan `ColorScheme` lengkap dari satu warna "benih" (_seed color_) atau warna yang diekstrak dari sistem.
    - **Mekanisme:** Material 3 menyediakan _tooling_ dan algoritma yang secara otomatis menghasilkan berbagai nuansa warna dan peran warna (`primary`, `onPrimary`, `secondary`, `tertiary`, `surface`, `background`, dll.) dari _seed color_.

  - **Color Harmonization:**

    - **Peran:** Proses penyesuaian warna dalam tema agar terlihat harmonis dan menyenangkan secara visual, terutama saat tema dihasilkan secara dinamis.
    - **Mekanisme:** Algoritma Material 3 memastikan bahwa semua warna dalam `ColorScheme` yang dihasilkan memiliki hubungan yang konsisten satu sama lain, menjaga keterbacaan dan estetika.

  - **Seed Color Usage:**

    - **Peran:** `Seed color` adalah satu warna dasar yang Anda berikan, dari mana seluruh `ColorScheme` aplikasi akan dihasilkan secara dinamis. Ini adalah cara yang sederhana namun kuat untuk mempersonalisasi tema.
    - **Mekanisme:** Anda cukup meneruskan `seedColor` ke `ColorScheme.fromSeed()` dan Flutter/Material 3 akan melakukan sisanya.

  - **Platform Integration:**

    - **Peran:** Integrasi dengan fitur _dynamic color_ bawaan platform Android 12+ (yang disebut "Monet"). Aplikasi dapat secara otomatis mengadopsi warna dari _wallpaper_ sistem, menciptakan pengalaman yang sangat mulus dan terasa _native_.
    - **Mekanisme:** Menggunakan _package_ seperti `dynamic_color` untuk mengakses warna _dynamic_ dari sistem dan menggunakannya untuk membuat `ColorScheme` Anda.

  - **`Dynamic Color Package`:**

    - **Peran:** Sebuah _package_ yang menyediakan _widget_ `DynamicColorBuilder` untuk mengakses warna _dynamic_ dari perangkat Android 12+ dan secara otomatis membangun `ColorScheme` yang sesuai.

    - **Setup (`pubspec.yaml`):**

      ```yaml
      dependencies:
        dynamic_color: ^latest_version # Ganti dengan versi terbaru
      ```

      Setelah menambahkan, jalankan `flutter pub get`.

  - **Contoh Kode (`DynamicColorBuilder` dengan Material 3):**

    ```dart
    import 'package:flutter/material.dart';
    import 'package:dynamic_color/dynamic_color.dart'; // Import package

    void main() {
      runApp(const DynamicColorApp());
    }

    class DynamicColorApp extends StatelessWidget {
      const DynamicColorApp({super.key});

      // Definisi seed color fallback jika dynamic color tidak tersedia
      static const Color _defaultSeedColor = Colors.deepPurple;

      @override
      Widget build(BuildContext context) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            // Gunakan dynamic color jika tersedia, jika tidak, fallback ke seed color
            ColorScheme lightColorScheme = lightDynamic ??
                ColorScheme.fromSeed(
                  seedColor: _defaultSeedColor,
                  brightness: Brightness.light,
                );
            ColorScheme darkColorScheme = darkDynamic ??
                ColorScheme.fromSeed(
                  seedColor: _defaultSeedColor,
                  brightness: Brightness.dark,
                );

            return MaterialApp(
              title: 'Dynamic Theming Demo',
              theme: ThemeData(
                colorScheme: lightColorScheme,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: darkColorScheme,
                useMaterial3: true,
              ),
              themeMode: ThemeMode.system, // Gunakan tema sistem (light/dark)
              home: const DynamicColorHomeScreen(),
            );
          },
        );
      }
    }

    class DynamicColorHomeScreen extends StatelessWidget {
      const DynamicColorHomeScreen({super.key});

      @override
      Widget build(BuildContext context) {
        final ColorScheme colorScheme = Theme.of(context).colorScheme;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dynamic Theming M3'),
            backgroundColor: colorScheme.primary, // AppBar menggunakan warna primary dari ColorScheme
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'This app uses Dynamic Colors from Material 3!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Contoh penggunaan warna dari ColorScheme
                  Container(
                    width: 100,
                    height: 100,
                    color: colorScheme.primaryContainer, // Warna kontainer utama
                    child: Center(
                      child: Text(
                        'Primary Container',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.onPrimaryContainer),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 100,
                    height: 100,
                    color: colorScheme.secondaryContainer, // Warna kontainer sekunder
                    child: Center(
                      child: Text(
                        'Secondary Container',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.onSecondaryContainer),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // FloatingActionButton menggunakan theme.
                  FloatingActionButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('FAB color from Theme!'),
                            backgroundColor: colorScheme.tertiary),
                      );
                    },
                    child: const Icon(Icons.palette),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Set your device wallpaper to see dynamic colors in action (Android 12+).',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    ```

  - **Sumber Daya Tambahan:**

    - [Material 3 Dynamic Theming](https://m3.material.io/styles/color/dynamic-color/overview)
    - [Dynamic Color Package](https://pub.dev/packages/dynamic_color)

---

- **Custom Theme Implementation**

  - **Peran:** Meskipun Material Design menyediakan sistem _theming_ yang kuat, terkadang Anda memerlukan kustomisasi yang melampaui apa yang disediakan oleh `ThemeData` standar, atau Anda memiliki properti tema kustom yang ingin Anda distribusikan ke seluruh pohon _widget_.

  - **Detail:** Anda dapat mencapai ini dengan menggunakan `ThemeExtension` (Material 3) atau dengan membuat _InheritedWidget_ kustom.

  - **Theme Extensions:**

    - **Peran:** Fitur baru di Material 3 yang memungkinkan Anda menambahkan properti kustom ke `ThemeData` tanpa harus membuat _InheritedWidget_ yang terpisah. Ini adalah cara yang bersih dan _type-safe_ untuk memperluas tema Anda.
    - **Mekanisme:** Anda mendefinisikan kelas yang mengekstensi `ThemeExtension<YourCustomThemeExtension>`, tambahkan properti kustom Anda, dan implementasikan metode `copyWith` dan `lerp`. Kemudian, tambahkan _instance_ dari _extension_ ini ke daftar `extensions` di `ThemeData`.

  - **Custom Color Schemes:**

    - **Peran:** Selain `ColorScheme` Material 3 yang dihasilkan otomatis, Anda mungkin ingin mendefinisikan skema warna kustom Anda sendiri untuk mencapai estetika _brand_ yang unik atau skema warna yang lebih spesifik.
    - **Detail:** Anda bisa membuat kelas `ColorScheme` Anda sendiri dengan kumpulan warna yang telah ditentukan sebelumnya, atau menggunakannya sebagai bagian dari `ThemeExtension`.

  - **Component Theme Customization:**

    - **Peran:** Mengatur gaya default untuk _widget_ tertentu (misalnya, `AppBar`, `ElevatedButton`, `Card`) di seluruh aplikasi, dengan lebih detail atau dengan properti kustom Anda sendiri.
    - **Detail:** Sudah dibahas di `ThemeData` configuration, tetapi dengan `ThemeExtension`, Anda dapat menyertakan properti spesifik komponen yang tidak ada di `ThemeData` standar.

  - **Theme Inheritance:**

    - **Peran:** _Widget_ secara otomatis mewarisi properti tema dari _ancestor_ terdekat dalam pohon _widget_.
    - **Detail:** Ketika Anda mendefinisikan `ThemeData` di `MaterialApp`, semua _widget_ di bawahnya dapat mengakses tema tersebut menggunakan `Theme.of(context)`. Anda juga dapat menimpa sebagian tema untuk sub-pohon _widget_ tertentu dengan menempatkan _widget_ `Theme` di bawah `MaterialApp`.

  - **Contoh Kode (Theme Extensions):**

    ```dart
    import 'package:flutter/material.dart';

    // 1. Definisikan Theme Extension Anda
    @immutable
    class CustomAppColors extends ThemeExtension<CustomAppColors> {
      const CustomAppColors({
        required this.brandColor,
        required this.warningColor,
      });

      final Color? brandColor;
      final Color? warningColor;

      @override
      CustomAppColors copyWith({Color? brandColor, Color? warningColor}) {
        return CustomAppColors(
          brandColor: brandColor ?? this.brandColor,
          warningColor: warningColor ?? this.warningColor,
        );
      }

      // Interpolasi warna untuk transisi tema (misalnya, saat beralih light/dark)
      @override
      CustomAppColors lerp(ThemeExtension<CustomAppColors>? other, double t) {
        if (other is! CustomAppColors) {
          return this;
        }
        return CustomAppColors(
          brandColor: Color.lerp(brandColor, other.brandColor, t),
          warningColor: Color.lerp(warningColor, other.warningColor, t),
        );
      }

      // Untuk debug
      @override
      String toString() => 'CustomAppColors(brandColor: $brandColor, warningColor: $warningColor)';
    }

    // 2. Definisikan tema Anda dan tambahkan ekstensi
    class AppCustomThemes {
      static final lightTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        extensions: <ThemeExtension<dynamic>>[
          const CustomAppColors(
            brandColor: Color(0xFF1A73E8), // Google Blue
            warningColor: Colors.orange,
          ),
        ],
      );

      static final darkTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
        extensions: <ThemeExtension<dynamic>>[
          const CustomAppColors(
            brandColor: Color(0xFF8AB4F8), // Light blue for dark mode
            warningColor: Colors.deepOrangeAccent,
          ),
        ],
      );
    }

    void main() {
      runApp(const MyAppCustomTheme());
    }

    class MyAppCustomTheme extends StatelessWidget {
      const MyAppCustomTheme({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Custom Theme Extension Demo',
          theme: AppCustomThemes.lightTheme,
          darkTheme: AppCustomThemes.darkTheme,
          themeMode: ThemeMode.system, // Atau ganti ke .light/.dark untuk testing
          home: const CustomThemeHomeScreen(),
        );
      }
    }

    class CustomThemeHomeScreen extends StatelessWidget {
      const CustomThemeHomeScreen({super.key});

      @override
      Widget build(BuildContext context) {
        // 3. Akses properti custom theme Anda
        final CustomAppColors customColors = Theme.of(context).extension<CustomAppColors>()!;
        final ColorScheme colorScheme = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Custom Theme & Extensions'),
            backgroundColor: customColors.brandColor, // Menggunakan warna dari custom extension
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to Custom Themed App!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: customColors.brandColor, // Menggunakan warna dari custom extension
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: customColors.warningColor?.withOpacity(0.2), // Menggunakan warna warning
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'This is a warning message!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: customColors.warningColor,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Anda masih bisa menggunakan warna dari ColorScheme standar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Primary color: ${colorScheme.primary.value}'),
                        backgroundColor: colorScheme.primary,
                      ),
                    );
                  },
                  child: const Text('Show Primary Color'),
                ),
              ],
            ),
          ),
        );
      }
    }
    ```

  - **Sumber Daya Tambahan:**

    - [Theme Extensions](https://api.flutter.dev/flutter/material/ThemeExtension-class.html) (Dokumentasi API Flutter)
    - [Custom Color Schemes](https://m3.material.io/styles/color/the-color-system/custom-color) (Panduan Material 3)

---

Dengan pembahasan **10.1 Theme Architecture** ini, kita telah mencakup dasar-dasar sistem tema Material, konfigurasi `ThemeData`, konsep `ColorScheme`, _typography_ dan _component themes_, implementasi dan _switching_ tema gelap, Material 3 _dynamic theming_, serta implementasi tema kustom menggunakan _Theme Extensions_.

#### **10.2 Typography & Font Management**

- **Peran:** Tipografi dan manajemen _font_ adalah aspek krusial dalam desain UI yang memastikan keterbacaan, hierarki visual, dan estetika aplikasi. Mengelola _font_ secara efektif memungkinkan Anda untuk mengintegrasikan _font_ kustom, menggunakan _icon font_, menyesuaikan skala teks, dan menerapkan sistem tipografi yang konsisten, sekaligus mempertimbangkan aksesibilitas.

---

###### **Font Integration**

- **Peran:** Proses membawa dan menggunakan _font_ yang bukan _font_ sistem standar ke dalam aplikasi Flutter Anda. Ini memungkinkan _branding_ yang konsisten dan desain yang lebih menarik.

- **Custom Font Loading:**

  - **Peran:** Menginstruksikan Flutter untuk memuat berkas _font_ khusus yang Anda sediakan.
  - **Mekanisme:**
    1.  **Tambahkan berkas _font_:** Letakkan berkas _font_ (`.ttf`, `.otf`) Anda di dalam folder di proyek Anda (misalnya, `assets/fonts/`).
    2.  **Deklarasikan di `pubspec.yaml`:** Beri tahu Flutter tentang _font_ Anda di bagian `flutter:` dan `fonts:`. Anda harus menentukan `family` (nama _font_ yang akan Anda gunakan dalam kode) dan `asset` (jalur ke berkas _font_). Anda juga dapat menentukan `weight` dan `style` jika Anda memiliki beberapa varian (_bold_, _italic_, dll.) dalam keluarga _font_ yang sama.

- **Font Fallbacks:**

  - **Peran:** Mekanisme di mana sistem akan menggunakan _font_ alternatif jika _font_ utama tidak dapat memuat karakter tertentu (misalnya, emoji, karakter khusus bahasa) atau jika _font_ utama tidak tersedia.
  - **Mekanisme:** Flutter dan sistem operasi secara otomatis akan mencari _font_ yang cocok untuk karakter yang hilang. Meskipun demikian, Anda dapat secara eksplisit menentukan daftar `fontFamilyFallback` di `TextStyle` atau `TextTheme` untuk mengontrol urutan pencarian _fallback_.

- **Variable Fonts:**

  - **Peran:** Satu berkas _font_ yang berisi berbagai variasi desain (misalnya, berat, lebar, kemiringan) yang dapat diakses melalui sumbu desain. Ini mengurangi ukuran berkas _font_ secara keseluruhan dan menawarkan fleksibilitas desain yang lebih besar.
  - **Detail:** Daripada memuat berkas terpisah untuk _Light_, _Regular_, _Bold_, dan _Italic_, satu _variable font_ dapat mencakup semua variasi tersebut, di mana Anda dapat secara halus menyesuaikan `FontWeight` atau `FontStyle` dalam kode Anda. Dukungan penuh untuk _variable fonts_ mungkin memerlukan konfigurasi lebih lanjut atau _package_ spesifik, tetapi Flutter umumnya dapat menggunakannya jika didefinisikan dengan benar.

- **Icon Fonts:**

  - **Peran:** Menggunakan _font_ khusus di mana setiap karakter adalah sebuah ikon. Ini lebih efisien daripada menggunakan berkas gambar untuk setiap ikon karena mereka dapat diskalakan tanpa kehilangan kualitas dan dapat diwarnai seperti teks biasa.
  - **Mekanisme:** Mirip dengan _custom font_, Anda mendeklarasikan berkas `.ttf` dari _icon font_ di `pubspec.yaml`, lalu menggunakan `IconData` yang sesuai yang disediakan oleh _package_ _icon font_ (misalnya, `Font Awesome`).

- **Text Scaling:**

  - **Peran:** Menyesuaikan ukuran teks berdasarkan preferensi ukuran teks pengguna di pengaturan sistem operasi. Ini adalah fitur aksesibilitas penting yang memastikan pengguna dengan gangguan penglihatan dapat membaca konten dengan nyaman.
  - **Mekanisme:** Flutter secara otomatis menghormati pengaturan `textScaleFactor` dari `MediaQuery.of(context).textScaleFactor`. Anda harus merancang UI Anda agar tetap terlihat baik saat teks diskalakan (misalnya, dengan menggunakan `Flexible`, `Expanded`, `Wrap`, dan `SingleChildScrollView`).

- **Contoh Implementasi Font Integration & Text Scaling:**

  - **Langkah 1: Tambahkan berkas _font_ (misalnya, `assets/fonts/OpenSans-Regular.ttf`)**

  - **Langkah 2: Deklarasikan di `pubspec.yaml`:**

    ```yaml
    flutter:
      uses-material-design: true

      fonts:
        - family: OpenSans
          fonts:
            - asset: assets/fonts/OpenSans-Regular.ttf
            - asset: assets/fonts/OpenSans-Bold.ttf
              weight: 700 # Menentukan bobot untuk varian bold
            - asset: assets/fonts/OpenSans-Italic.ttf
              style: italic # Menentukan style untuk varian italic
        # Contoh deklarasi icon font (jika Anda punya custom icon font)
        # - family: MyCustomIcons
        #   fonts:
        #     - asset: assets/fonts/MyCustomIcons.ttf
    ```

  - **Langkah 3: Gunakan dalam kode Dart:**

    ```dart
    import 'package:flutter/material.dart';

    // Asumsikan pubspec.yaml sudah dikonfigurasi untuk 'OpenSans'
    // dan Anda sudah menambahkan Font Awesome Icons jika digunakan

    void main() {
      runApp(const FontManagementDemoApp());
    }

    class FontManagementDemoApp extends StatelessWidget {
      const FontManagementDemoApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Font Management Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'OpenSans', // Set default font family for the app
            textTheme: const TextTheme(
              // Override specific text styles
              displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.w700), // Bold from OpenSans-Bold.ttf
              bodyMedium: TextStyle(fontSize: 16.0),
            ),
            useMaterial3: true,
          ),
          home: const FontManagementHomeScreen(),
        );
      }
    }

    class FontManagementHomeScreen extends StatelessWidget {
      const FontManagementHomeScreen({super.key});

      @override
      Widget build(BuildContext context) {
        // Mengakses text scale factor dari pengaturan sistem
        final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Font & Typography'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Judul Besar (OpenSans Bold)',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ini adalah contoh teks body dengan font OpenSans reguler. '
                  'Aplikasi ini menggunakan font kustom yang diimport dari assets.',
                  style: TextStyle(fontSize: 16.0), // Menggunakan default font family dari ThemeData
                ),
                const SizedBox(height: 10),
                const Text(
                  'Teks ini menggunakan gaya italic',
                  style: TextStyle(fontStyle: FontStyle.italic), // Menggunakan OpenSans-Italic.ttf
                ),
                const SizedBox(height: 20),
                Text(
                  'Current Text Scale Factor: ${textScaleFactor.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ubah pengaturan "Ukuran Tampilan & Teks" di perangkat Anda untuk melihat efeknya pada ukuran teks ini.',
                  style: TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 20),
                // Contoh Icon Font (Membutuhkan package Font Awesome atau custom icon font)
                // Jika menggunakan package font_awesome_flutter: ^latest_version
                // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
                Row(
                  children: [
                    const Icon(Icons.star, size: 40, color: Colors.amber),
                    const SizedBox(width: 10),
                    // FaIcon(FontAwesomeIcons.solidHeart, size: 40, color: Colors.red), // Dari Font Awesome
                    // const SizedBox(width: 10),
                    // Icon(MyCustomIcons.myStar, size: 40, color: Colors.purple), // Dari Custom Icon Font Anda
                    const Text('Some Icons'),
                  ],
                ),
                const SizedBox(height: 20),
                // Contoh penggunaan font fallback:
                // Jika font utama tidak mendukung karakter Jepang, sistem akan mencari font lain.
                const Text(
                  'Hello World こんにちは', // こんにちは (Kon\'nichiwa) = Hello in Japanese
                  style: TextStyle(fontFamily: 'OpenSans'), // Jika OpenSans tidak mendukung Jepang
                ),
                const SizedBox(height: 20),
                const Divider(),
                const Text(
                  'Catatan: Untuk melihat efek text scaling, Anda perlu mengubah pengaturan ukuran font di pengaturan sistem operasi perangkat (misalnya, Pengaturan > Tampilan > Ukuran Tampilan & Teks di Android, atau Pengaturan > Aksesibilitas > Ukuran Teks di iOS).',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }
    }
    ```

- **Sumber Daya Tambahan:**

  - [Using Custom Fonts](https://flutter.dev/docs/cookbook/design/fonts)
  - [Google Fonts Package](https://pub.dev/packages/google_fonts)
    - **Peran:** Memungkinkan Anda dengan mudah menggunakan ribuan _font_ dari Google Fonts tanpa harus mengunduh berkas `.ttf` secara manual dan mendeklarasikannya di `pubspec.yaml`. _Font_ akan di-_fetch_ saat dibutuhkan dan di-_cache_ secara lokal.
    - **Contoh:** `Text('Hello', style: GoogleFonts.roboto());`
  - [Font Awesome Icons](https://pub.dev/packages/font_awesome_flutter)
    - **Peran:** Integrasi mudah dengan _icon set_ Font Awesome yang populer, menyediakan ribuan ikon yang dapat diwarnai dan diskalakan seperti teks.
    - **Contoh:** `FaIcon(FontAwesomeIcons.camera);`

---

###### **Typography Systems**

- **Peran:** Mendefinisikan seperangkat gaya teks yang kohesif dan hirarkis untuk aplikasi Anda, memastikan konsistensi visual dan kemudahan penggunaan di seluruh UI.

- **Material Typography Scale:**

  - **Peran:** Material Design menyediakan skala tipografi yang direkomendasikan dengan nama-nama semantik (misalnya, `displayLarge`, `headlineMedium`, `titleSmall`, `bodyLarge`, `labelSmall`). Ini memandu desainer dan pengembang untuk menerapkan hierarki teks yang jelas dan dapat diakses.
  - **Detail:** Anda dapat mengkustomisasi setiap gaya dalam `TextTheme` dari `ThemeData` agar sesuai dengan _brand_ Anda, sambil tetap mempertahankan struktur semantik Material.

- **Custom Typography Themes:**

  - **Peran:** Membuat tema tipografi Anda sendiri dengan mendefinisikan gaya teks untuk berbagai konteks penggunaan dalam aplikasi Anda.
  - **Mekanisme:** Seperti yang ditunjukkan dalam contoh `ThemeData` sebelumnya, Anda mengkustomisasi _instance_ `TextTheme` dan menetapkannya ke properti `textTheme` di `ThemeData`. Ini memungkinkan Anda untuk menggunakan `Theme.of(context).textTheme.headlineLarge` dan secara otomatis mendapatkan gaya yang Anda definisikan.

- **Text Style Inheritance:**

  - **Peran:** Properti gaya teks di Flutter (misalnya, `fontFamily`, `fontSize`, `color`) secara otomatis diwariskan dari _ancestor_ ke _descendant_ dalam pohon _widget_.
  - **Detail:** Jika Anda menetapkan `fontFamily` di `ThemeData` pada level `MaterialApp`, semua teks di bawahnya akan mengadopsi _font_ tersebut secara _default_ kecuali ditimpa secara eksplisit oleh `TextStyle` pada _widget_ `Text` yang lebih rendah. Ini mengurangi redundansi kode.

- **Responsive Typography:**

  - **Peran:** Menyesuaikan ukuran teks berdasarkan ukuran layar atau _breakpoint_ perangkat untuk memastikan keterbacaan yang optimal di berbagai perangkat (ponsel, tablet, desktop).
  - **Mekanisme:**
    - **`MediaQuery`:** Gunakan `MediaQuery.of(context).size` untuk mendapatkan dimensi layar dan sesuaikan ukuran _font_ secara programatik.
    - **`LayoutBuilder`:** Gunakan `LayoutBuilder` untuk mendapatkan batasan ukuran dari _ancestor_ terdekat dan sesuaikan ukuran teks berdasarkan ruang yang tersedia.
    - **Desain Skalabel:** Pertimbangkan untuk menggunakan skala relatif atau fungsi untuk ukuran _font_ agar lebih adaptif.

- **Accessibility Considerations:**

  - **Peran:** Memastikan bahwa teks aplikasi dapat diakses oleh semua pengguna, termasuk mereka yang memiliki gangguan penglihatan atau disabilitas lainnya.
  - **Detail:**
    - **Contrast Ratio:** Pastikan ada kontras yang cukup antara warna teks dan latar belakang. Material Design menyediakan pedoman untuk ini.
    - **Text Scaling:** Seperti yang dibahas sebelumnya, hormati preferensi ukuran teks sistem operasi.
    - **Semantic Labels:** Gunakan `Semantics` _widget_ atau properti `semanticsLabel` untuk `Text` dan `Icon` _widget_ untuk memberikan deskripsi yang bermakna bagi _screen reader_.
    - **Adjustable Text:** Hindari membatasi ukuran teks secara ketat yang mencegahnya diskalakan oleh pengguna.

- **Contoh Kode (Responsive Typography & Inheritance):**

  ```dart
  import 'package:flutter/material.dart';

  void main() {
    runApp(const ResponsiveTypographyApp());
  }

  class ResponsiveTypographyApp extends StatelessWidget {
    const ResponsiveTypographyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Responsive Typography Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
          // Tema tipografi dasar
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(fontSize: 28.0, fontStyle: FontStyle.italic),
            bodyMedium: TextStyle(fontSize: 16.0),
            labelSmall: TextStyle(fontSize: 11.0, color: Colors.grey),
          ),
        ),
        home: const ResponsiveTypographyScreen(),
      );
    }
  }

  class ResponsiveTypographyScreen extends StatelessWidget {
    const ResponsiveTypographyScreen({super.key});

    @override
    Widget build(BuildContext context) {
      // Mengakses tema tipografi dari context
      final TextTheme textTheme = Theme.of(context).textTheme;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Responsive Typography'),
        ),
        body: LayoutBuilder( // Gunakan LayoutBuilder untuk responsivitas berdasarkan lebar tersedia
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            double headlineFontSize;
            if (screenWidth < 600) { // Small screens (phones)
              headlineFontSize = 24.0;
            } else if (screenWidth < 900) { // Medium screens (tablets)
              headlineFontSize = 36.0;
            } else { // Large screens (desktop)
              headlineFontSize = 48.0;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Responsive Headline',
                    // Menggabungkan gaya dari tema dan kustomisasi responsif
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: headlineFontSize, // Ukuran font berubah berdasarkan lebar layar
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ini adalah teks body biasa, mewarisi gaya dari ThemeData.bodyMedium.',
                    // Ini akan mewarisi fontFamily, color, dll. dari default bodyMedium di ThemeData
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Label kecil',
                    style: textTheme.labelSmall, // Menggunakan gaya labelSmall dari tema
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text(
                    'Perhatikan bagaimana "Responsive Headline" berubah ukuran ketika Anda mengubah lebar jendela (jika di web/desktop) atau rotasi perangkat.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Untuk aksesibilitas, pastikan kontras teks cukup dan teks dapat diskalakan oleh sistem.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    // Ini juga akan diwarnai oleh theme, jika tidak di override.
                    // Untuk testing kontras, bisa pakai warna custom yang kontras rendah
                    // style: TextStyle(color: Colors.grey[200]), // Contoh buruk pada background putih
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
  ```

---

Dengan pembahasan **10.2 Typography & Font Management** ini, kita telah mencakup integrasi _font_ kustom, _font fallbacks_, _variable fonts_, _icon fonts_, _text scaling_, serta sistem tipografi Material dan kustomisasi.

#### **10.3 Responsive & Adaptive Design**

- **Peran:** Dalam ekosistem perangkat yang beragam saat ini, aplikasi harus mampu menyesuaikan tampilannya agar terlihat dan berfungsi dengan baik di berbagai ukuran layar, orientasi, dan _platform_ (ponsel, tablet, desktop, web, bahkan perangkat lipat). _Responsive_ dan _adaptive design_ adalah strategi kunci untuk mencapai tujuan ini, memastikan pengalaman pengguna yang optimal di mana pun aplikasi dijalankan.

---

###### **Responsive Design Patterns**

- **Peran:** Pola desain _responsive_ adalah pendekatan dan teknik untuk membuat tata letak yang secara otomatis menyesuaikan diri dengan ukuran dan orientasi layar yang berbeda. Tujuannya adalah untuk memastikan konten tetap dapat dibaca dan elemen UI dapat berinteraksi terlepas dari dimensi layar.

- **Breakpoint Management:**

  - **Peran:** Titik henti (_breakpoints_) adalah ambang batas lebar layar di mana tata letak atau gaya elemen UI berubah secara signifikan. Ini adalah fondasi desain _responsive_.
  - **Mekanisme:** Anda mendefinisikan lebar layar tertentu (misalnya, 600 piksel untuk tablet, 900 piksel untuk desktop) sebagai _breakpoint_. Berdasarkan apakah lebar layar saat ini di bawah atau di atas _breakpoint_ tersebut, Anda menerapkan tata letak atau _widget_ yang berbeda.
  - **Di Flutter:** Anda dapat menggunakan `MediaQuery.of(context).size.width` untuk mendapatkan lebar layar saat ini dan membandingkannya dengan _breakpoint_ yang telah Anda definisikan. Material Design juga memiliki _breakpoint_ standarnya sendiri.

- **Fluid Layouts:**

  - **Peran:** Tata letak yang menggunakan proporsi relatif (persentase atau _flex_ faktor) daripada nilai piksel tetap. Ini memungkinkan elemen untuk meregang atau menyusut secara proporsional saat ukuran layar berubah, mengisi ruang yang tersedia.
  - **Mekanisme:** Di Flutter, _widget_ seperti `Expanded`, `Flexible`, `FractionallySizedBox`, `AspectRatio`, dan `MediaQuery` sangat penting untuk menciptakan _fluid layouts_. Misalnya, `Expanded` dalam `Row` atau `Column` memungkinkan _widget_ untuk mengambil ruang yang tersedia secara proporsional.

- **Responsive Widgets:**

  - **Peran:** _Widget_ yang secara internal dirancang untuk menyesuaikan tampilannya berdasarkan ruang yang tersedia.
  - **Contoh:**
    - `Wrap`: Mengatur _widget_ dalam baris, dan jika tidak ada cukup ruang, secara otomatis "melilit" ke baris berikutnya.
    - `GridView`: Memungkinkan Anda menentukan jumlah kolom atau lebar item maksimum, dan secara otomatis mengatur item dalam grid.
    - `FittedBox`: Menskalakan dan memposisikan anaknya agar sesuai dengan ruang yang tersedia.
    - `AspectRatio`: Mengatur rasio aspek tertentu untuk sebuah _widget_, yang membantu menjaga proporsi saat ukuran berubah.

- **Container Queries:**

  - **Peran:** Kemampuan untuk menyesuaikan gaya atau tata letak elemen berdasarkan ukuran _container_ induknya, bukan hanya ukuran layar global. Ini sangat ampuh untuk membuat komponen yang dapat digunakan kembali di berbagai konteks tata letak.
  - **Detail:** Meskipun Flutter tidak memiliki "container queries" bawaan seperti di CSS, Anda dapat mencapainya menggunakan `LayoutBuilder` untuk mendapatkan batasan ukuran dari _ancestor_ terdekat dan kemudian menyesuaikan tata letak anak-anak berdasarkan batasan tersebut.

- **Screen Size Adaptation:**

  - **Peran:** Strategi umum untuk menyesuaikan seluruh tata letak aplikasi berdasarkan ukuran layar. Ini adalah penerapan _responsive design_ pada tingkat aplikasi.
  - **Mekanisme:** Menggunakan `MediaQuery` untuk memeriksa lebar dan tinggi layar, lalu mengembalikan _layout_ yang sama sekali berbeda (misalnya, `Row` untuk layar lebar, `Column` untuk layar sempit) atau _widget_ yang dikondisikan.

- **`LayoutBuilder` Usage:**

  - **Peran:** _Widget_ yang memungkinkan Anda membangun sub-pohon _widget_ yang berbeda berdasarkan batasan ukuran yang diterima dari _ancestor_ terdekatnya. Ini ideal untuk membuat _widget_ yang _responsive_ terhadap ruang yang tersedia untuk mereka, bukan hanya ukuran layar global.
  - **Mekanisme:** `LayoutBuilder` memiliki `builder` _callback_ yang menyediakan `BoxConstraints` (berisi `minWidth`, `maxWidth`, `minHeight`, `maxHeight`). Anda kemudian dapat menggunakan properti ini untuk mengkondisikan _layout_ anak-anaknya.

- **`MediaQuery` Best Practices:**

  - **Peran:** `MediaQuery` menyediakan informasi tentang media, seperti ukuran layar (lebar, tinggi), orientasi (potret/lanskap), _padding_, _text scale factor_, dll.
  - **Best Practices:**
    - **Jangan gunakan `MediaQuery` terlalu sering di dalam `build`:** `MediaQuery` akan menyebabkan _widget_ dibangun ulang setiap kali ada perubahan pada media (misalnya, rotasi layar). Untuk perubahan besar, gunakan di level `MaterialApp` atau `Scaffold` teratas.
    - **Gunakan `LayoutBuilder` untuk responsivitas komponen:** Ketika _widget_ perlu _responsive_ terhadap ruang yang diberikan oleh _parent_-nya, bukan seluruh layar, `LayoutBuilder` lebih cocok daripada `MediaQuery`.
    - **Perhatikan _padding_ dan _viewInsets_:** Gunakan `MediaQuery.of(context).padding` untuk _safe area_ (misalnya, _notch_ di iOS, _status bar_), dan `viewInsets` untuk keyboard _on-screen_.

- **Contoh Kode (Responsive Design dengan `LayoutBuilder` & `MediaQuery`):**

  ```dart
  import 'package:flutter/material.dart';

  void main() {
    runApp(const ResponsiveDemoApp());
  }

  class ResponsiveDemoApp extends StatelessWidget {
    const ResponsiveDemoApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Responsive Design Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          useMaterial3: true,
        ),
        home: const ResponsiveHomeScreen(),
      );
    }
  }

  class ResponsiveHomeScreen extends StatelessWidget {
    const ResponsiveHomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
      final Size screenSize = MediaQuery.of(context).size;
      final Orientation orientation = MediaQuery.of(context).orientation;

      // Mendefinisikan breakpoints
      const double smallScreenBreakpoint = 600.0;
      const double mediumScreenBreakpoint = 900.0;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Responsive & Adaptive Design'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Screen Width: ${screenSize.width.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Screen Height: ${screenSize.height.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Orientation: ${orientation == Orientation.portrait ? 'Portrait' : 'Landscape'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),

                // Contoh Screen Size Adaptation dengan MediaQuery
                if (screenSize.width < smallScreenBreakpoint)
                  _buildSmallScreenLayout(context)
                else if (screenSize.width < mediumScreenBreakpoint)
                  _buildMediumScreenLayout(context)
                else
                  _buildLargeScreenLayout(context),

                const SizedBox(height: 30),
                const Text(
                  'Container Query Example (using LayoutBuilder):',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Contoh Container Query dengan LayoutBuilder
                Container(
                  color: Colors.blueGrey.shade100,
                  padding: const EdgeInsets.all(8),
                  height: 200, // Tinggi tetap untuk contoh
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Konten di dalam container ini akan berubah berdasarkan lebar container, bukan layar
                      if (constraints.maxWidth < 300) {
                        return const Center(
                          child: Text(
                            'Narrow Container',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      } else if (constraints.maxWidth < 500) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Icons.dashboard, size: 40),
                            Text('Medium Container'),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Icons.dashboard, size: 50),
                            Text(
                              'Wide Container with more content',
                              style: TextStyle(fontSize: 20),
                            ),
                            Icon(Icons.settings, size: 50),
                          ],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Responsive Widgets (Wrap & GridView):',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Contoh Wrap Widget (responsive flow layout)
                const Wrap(
                  spacing: 8.0, // Spasi horizontal antar chip
                  runSpacing: 4.0, // Spasi vertikal antar baris chip
                  children: [
                    Chip(label: Text('Flutter')),
                    Chip(label: Text('Dart')),
                    Chip(label: Text('Responsive')),
                    Chip(label: Text('Design')),
                    Chip(label: Text('Widgets')),
                    Chip(label: Text('Adaptive')),
                  ],
                ),
                const SizedBox(height: 20),
                // Contoh GridView (responsive grid layout)
                SizedBox(
                  height: 300, // Batasi tinggi untuk contoh
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150.0, // Lebar maksimum setiap item
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 3 / 2, // Rasio aspek item
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.lightBlue[100 * (index % 9)],
                        child: Center(child: Text('Item $index')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildSmallScreenLayout(BuildContext context) {
      return Container(
        color: Colors.red.shade100,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: const [
            Icon(Icons.phone_android, size: 50, color: Colors.red),
            Text('Ini adalah tampilan untuk layar kecil (ponsel).', textAlign: TextAlign.center),
          ],
        ),
      );
    }

    Widget _buildMediumScreenLayout(BuildContext context) {
      return Container(
        color: Colors.green.shade100,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.tablet, size: 50, color: Colors.green),
            Expanded(
                child: Text(
              'Ini adalah tata letak untuk layar sedang (tablet).',
              textAlign: TextAlign.center,
            )),
          ],
        ),
      );
    }

    Widget _buildLargeScreenLayout(BuildContext context) {
      return Container(
        color: Colors.blue.shade100,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.desktop_windows, size: 60, color: Colors.blue),
            Expanded(
                child: Text(
              'Ini adalah tata letak untuk layar besar (desktop/web). Lebih banyak ruang untuk konten.',
              textAlign: TextAlign.center,
            )),
            Icon(Icons.laptop_chromebook, size: 60, color: Colors.blue),
          ],
        ),
      );
    }
  }
  ```

- **Visualisasi Konseptual: Responsive Design dengan Breakpoint**

  ```mermaid
  graph LR
      subgraph Screen Size
          A[Small Screen (< 600px)]
          B[Medium Screen (600px - 900px)]
          C[Large Screen (> 900px)]
      end

      subgraph Layout Adjustment
          L1[Column Layout / Simple UI]
          L2[Row Layout / Tablet UI]
          L3[Multi-column / Desktop UI]
      end

      A --> L1;
      B --> L2;
      C --> L3;
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana _responsive design_ bekerja dengan _breakpoints_. Berdasarkan lebar layar, aplikasi akan memilih tata letak yang berbeda (kolom sederhana untuk layar kecil, tata letak baris untuk layar sedang, dan tata letak multi-kolom untuk layar besar), menyesuaikan pengalaman pengguna dengan ukuran perangkat.

---

###### **Adaptive Design**

- **Peran:** Berbeda dengan _responsive design_ yang berfokus pada ukuran layar, _adaptive design_ berfokus pada penyesuaian aplikasi terhadap karakteristik _platform_ atau lingkungan tertentu (misalnya, iOS vs Android, _desktop_ vs _mobile_). Ini melibatkan perubahan perilaku atau tampilan elemen UI agar sesuai dengan pedoman desain _platform_ atau fungsionalitas unik.

- **Platform-specific UI:**

  - **Peran:** Mendesain _UI_ yang mengikuti panduan desain _platform_ asli (Material Design untuk Android/Web, Cupertino Design untuk iOS).
  - **Mekanisme:** Flutter menyediakan _widget_ Material dan Cupertino. Anda dapat secara kondisional menggunakan _widget_ yang sesuai berdasarkan _platform_ yang terdeteksi.

- **Adaptive Widgets:**

  - **Peran:** _Widget_ di Flutter yang secara internal dapat menyesuaikan tampilannya agar terlihat _native_ di _platform_ yang berbeda.
  - **Contoh:** `Switch.adaptive`, `Slider.adaptive`, `CircularProgressIndicator.adaptive`. _Widget-widget_ ini secara otomatis akan menampilkan tampilan Android atau iOS yang sesuai.

- **Platform Detection:**

  - **Peran:** Mengidentifikasi _platform_ perangkat tempat aplikasi berjalan.
  - **Mekanisme:** Gunakan `defaultTargetPlatform` dari `package:flutter/foundation` atau `Platform.isAndroid`, `Platform.isIOS`, `Platform.isWindows`, dll., dari `dart:io`.

- **Material vs Cupertino Switching:**

  - **Peran:** Kemampuan untuk beralih antara tampilan Material Design (Android-ish) dan Cupertino Design (iOS-ish) secara programatik, seringkali berdasarkan _platform_ yang terdeteksi.
  - **Mekanisme:** Dalam `build` _method_, Anda dapat memiliki logika `if (Platform.isIOS) { return CupertinoWidget(); } else { return MaterialWidget(); }`.

- **Desktop Adaptations:**

  - **Peran:** Menyesuaikan aplikasi untuk pengalaman pengguna desktop, yang seringkali melibatkan jendela yang dapat diubah ukurannya, kepadatan informasi yang lebih tinggi, dan navigasi yang berbeda (misalnya, _sidebar_ navigasi permanen).
  - **Mekanisme:** Gunakan _breakpoint_ layar yang lebih besar, `Drawer` yang selalu terbuka atau _custom sidebar_, dan tata letak multi-pane.

- **Platform Adaptive Widgets (`AdaptiveScaffold`):**

  - **Peran:** _Package_ `adaptive_scaffold` menyediakan _widget_ yang membantu membuat tata letak aplikasi yang adaptif untuk berbagai ukuran layar dan _platform_, khususnya untuk pengalaman _mobile_, tablet, dan _desktop_.

  - **Setup (`pubspec.yaml`):**

    ```yaml
    dependencies:
      flutter_adaptive_scaffold: ^latest_version # Ganti dengan versi terbaru
    ```

- **Contoh Kode (Adaptive Design & `AdaptiveScaffold`):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter/cupertino.dart'; // Untuk widget Cupertino
  import 'dart:io' show Platform; // Untuk deteksi platform

  // Import package flutter_adaptive_scaffold
  // Pastikan Anda sudah menambahkan dependensi ini di pubspec.yaml
  // import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';


  void main() {
    runApp(const AdaptiveDemoApp());
  }

  class AdaptiveDemoApp extends StatelessWidget {
    const AdaptiveDemoApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Adaptive Design Demo',
        theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
        // Anda bisa juga punya darkTheme dan themeMode di sini
        home: const AdaptiveHomeScreen(),
      );
    }
  }

  class AdaptiveHomeScreen extends StatefulWidget {
    const AdaptiveHomeScreen({super.key});

    @override
    State<AdaptiveHomeScreen> createState() => _AdaptiveHomeScreenState();
  }

  class _AdaptiveHomeScreenState extends State<AdaptiveHomeScreen> {
    int _selectedIndex = 0;

    final List<Widget> _pages = const [
      Center(child: Text('Home Page')),
      Center(child: Text('Settings Page')),
      Center(child: Text('Profile Page')),
    ];

    // Contoh sederhana widget adaptif
    Widget _buildPlatformSpecificSwitch() {
      if (Platform.isIOS) {
        return CupertinoSwitch(
          value: true,
          onChanged: (bool value) {},
        );
      } else {
        return Switch(
          value: true,
          onChanged: (bool value) {},
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      // Contoh penggunaan AdaptiveScaffold (membutuhkan package)
      // return AdaptiveScaffold(
      //   appBar: AppBar(title: const Text('Adaptive App Bar')),
      //   body: _pages[_selectedIndex],
      //   selectedIndex: _selectedIndex,
      //   onSelectedIndexChange: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      //   destinations: const <NavigationDestination>[
      //     NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      //     NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
      //     NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      //   smallBreakpoint: const WidthPlatformBreakpoint(end: 700), // Mobile
      //   mediumBreakpoint: const WidthPlatformBreakpoint(start: 700, end: 1000), // Tablet
      //   largeBreakpoint: const WidthPlatformBreakpoint(start: 1000), // Desktop
      //   // Konfigurasi untuk sidebar/rail di layar yang lebih besar
      //   // Untuk layar kecil, defaultnya adalah bottom navigation bar
      //   navigationRailBuilder: (context, leading, trailing, destinations) => NavigationRail(
      //     selectedIndex: _selectedIndex,
      //     onDestinationSelected: (index) {
      //       setState(() {
      //         _selectedIndex = index;
      //       });
      //     },
      //     leading: leading,
      //     trailing: trailing,
      //     destinations: destinations.map((d) => NavigationRailDestination(
      //       icon: d.icon,
      //       label: Text(d.label),
      //     )).toList(),
      //   ),
      // );


      // Tanpa AdaptiveScaffold, implementasi manual:
      return Scaffold(
        appBar: AppBar(
          title: const Text('Adaptive Design'),
        ),
        body: Row(
          children: [
            // Sidebar/NavigationRail untuk layar lebar
            if (MediaQuery.of(context).size.width >= 600)
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                ],
              ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _pages[_selectedIndex],
                    const SizedBox(height: 20),
                    Text(
                      'This is a platform-adaptive switch:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    _buildPlatformSpecificSwitch(), // Widget switch adaptif
                    const SizedBox(height: 20),
                    // Contoh Slider.adaptive
                    Slider.adaptive(
                      value: 0.5,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    // Contoh CircularProgressIndicator.adaptive
                    CircularProgressIndicator.adaptive(),
                    const SizedBox(height: 20),
                    Text(
                      'Aplikasi ini menyesuaikan berdasarkan platform. (Coba di iOS dan Android)',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: MediaQuery.of(context).size.width < 600
            ? BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              )
            : null, // Sembunyikan bottom nav bar di layar lebar
      );
    }
  }
  ```

- **Visualisasi Konseptual: Adaptive Design**

  ```mermaid
  graph LR
      A[Deteksi Platform/Karakteristik Lingkungan] --> B{If iOS};
      B -- Yes --> C[Gunakan Widget Cupertino];
      B -- No --> D{If Android};
      D -- Yes --> E[Gunakan Widget Material];
      D -- No --> F[Gunakan Widget Desktop/Web];

      C -- Adaptive Widgets --> G[Slider.adaptive];
      E -- Adaptive Widgets --> G;
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan alur _adaptive design_ di mana aplikasi mendeteksi karakteristik _platform_ atau lingkungan. Berdasarkan deteksi tersebut, aplikasi akan memilih set _widget_ yang berbeda (Cupertino untuk iOS, Material untuk Android) atau melakukan penyesuaian tata letak spesifik untuk _desktop/web_. _Adaptive widgets_ adalah contoh bagaimana satu _widget_ dapat beradaptasi secara internal.

---

###### **Multi-Screen Support**

- **Peran:** Desain untuk berbagai _form factor_ di luar ponsel standar, termasuk tablet, desktop, dan perangkat lipat. Ini seringkali melibatkan tata letak yang sama sekali berbeda untuk memanfaatkan ruang layar yang tersedia secara efisien.

- **Tablet Layouts:**

  - **Peran:** Mendesain tata letak yang memanfaatkan ruang horizontal ekstra yang ditawarkan tablet, seringkali dengan tata letak dua panel (_two-pane layout_) atau lebih banyak kolom.
  - **Contoh:** Aplikasi email dengan daftar email di satu panel dan detail email di panel lainnya; aplikasi pengaturan dengan daftar kategori di kiri dan detail di kanan.

- **Desktop Layouts:**

  - **Peran:** Mengoptimalkan aplikasi untuk lingkungan desktop, yang seringkali memiliki jendela yang dapat diubah ukurannya, _mouse_ dan dukungan _keyboard_ yang lengkap, serta _sidebar_ navigasi permanen.
  - **Detail:** Peningkatan kepadatan informasi, _hover effects_, dan dukungan untuk _keyboard shortcuts_ adalah pertimbangan penting.

- **Foldable Device Support:**

  - **Peran:** Mengembangkan aplikasi yang dapat beradaptasi dengan perangkat lipat (misalnya, Samsung Galaxy Fold) yang dapat beralih antara mode layar tunggal (ponsel) dan mode layar ganda/terbentang (tablet).
  - **Mekanisme:** Gunakan `MediaQuery` untuk mendeteksi _display features_ (dari _package_ `window_manager` atau `device_info_plus` jika tersedia _API_ yang sesuai) dan sesuaikan tata letak saat perangkat dibuka/ditutup. Pertimbangkan area "engsel" (_hinge_) jika aplikasi membentang di atasnya.

- **Multi-window Support:**

  - **Peran:** Memungkinkan aplikasi untuk berjalan di beberapa jendela secara bersamaan di _platform_ yang mendukungnya (misalnya, iPadOS Stage Manager, Android Freeform Windows, desktop).
  - **Detail:** Aplikasi harus dapat menangani `MediaQuery` yang berbeda untuk setiap jendela dan mungkin menyimpan _state_ yang terpisah per jendela.

- **Window Size Classes:**

  - **Peran:** Konsep dari Material Design yang mengategorikan ukuran jendela ke dalam kelas-kelas standar (`Compact`, `Medium`, `Expanded`) berdasarkan lebar yang tersedia. Ini adalah cara yang lebih terstruktur untuk mengelola _breakpoints_ besar untuk _adaptive UI_.
  - **Mekanisme:** Gunakan `MediaQuery.of(context).size.width` dan bandingkan dengan _breakpoint_ untuk `Compact` (lebar \< 600dp), `Medium` (600-840dp), dan `Expanded` (\> 840dp).

- **Contoh Konseptual (Multi-Screen Support dengan `Window Size Classes`):**

  ```dart
  import 'package:flutter/material.dart';

  // Enum untuk mengkategorikan ukuran jendela
  enum WindowSizeClass { compact, medium, expanded }

  // Helper function untuk menentukan WindowSizeClass
  WindowSizeClass getWindowSizeClass(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return WindowSizeClass.compact; // Ponsel
    } else if (width < 840) {
      return WindowSizeClass.medium; // Tablet portrait / small desktop
    } else {
      return WindowSizeClass.expanded; // Tablet landscape / large desktop
    }
  }

  class MultiScreenLayouts extends StatelessWidget {
    const MultiScreenLayouts({super.key});

    @override
    Widget build(BuildContext context) {
      final WindowSizeClass sizeClass = getWindowSizeClass(context);

      Widget layout;
      String description;

      switch (sizeClass) {
        case WindowSizeClass.compact:
          layout = _buildCompactLayout(context);
          description = 'Compact: Cocok untuk layar ponsel, seringkali dengan Bottom Navigation Bar.';
          break;
        case WindowSizeClass.medium:
          layout = _buildMediumLayout(context);
          description = 'Medium: Ideal untuk tablet (potret) atau jendela desktop kecil, bisa menggunakan Navigation Rail.';
          break;
        case WindowSizeClass.expanded:
          layout = _buildExpandedLayout(context);
          description = 'Expanded: Digunakan untuk tablet (lanskap) atau desktop, memungkinkan sidebar permanen dan multi-panel.';
          break;
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Multi-Screen Layouts'),
        ),
        body: Column(
          children: [
            Expanded(child: layout),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Current Window Size Class: ${sizeClass.name.toUpperCase()}\n$description',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildCompactLayout(BuildContext context) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Single Column Layout',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            ],
            onTap: (index) {},
          ),
        ],
      );
    }

    Widget _buildMediumLayout(BuildContext context) {
      return Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (index) {},
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(icon: Icon(Icons.search), label: Text('Search')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: Text(
                'Navigation Rail + Main Content',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildExpandedLayout(BuildContext context) {
      return Row(
        children: [
          // Sidebar navigasi permanen
          SizedBox(
            width: 250,
            child: ListView(
              children: const [
                ListTile(leading: Icon(Icons.inbox), title: Text('Inbox')),
                ListTile(leading: Icon(Icons.send), title: Text('Sent')),
                ListTile(leading: Icon(Icons.archive), title: Text('Archive')),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Dua panel konten (detail view)
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Main Content Panel 1 (List)',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                'Main Content Panel 2 (Detail)',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ],
      );
    }
  }

  // Untuk menjalankan contoh MultiScreenLayouts, ganti home di MaterialApp
  // home: const MultiScreenLayouts(),
  ```

- **Visualisasi Konseptual: Window Size Classes**

  ```mermaid
  graph LR
      A[Width < 600dp (Compact)] --> L1[Mobile Phone UI: Bottom Nav, Single Column];
      B[600dp <= Width < 840dp (Medium)] --> L2[Tablet Portrait / Small Desktop UI: Navigation Rail, Two Pane];
      C[Width >= 840dp (Expanded)] --> L3[Tablet Landscape / Large Desktop UI: Persistent Sidebar, Multi-Column/Panel];
  ```

  **Penjelasan Visual:**
  Diagram ini memetakan kelas-kelas ukuran jendela Material 3 (`Compact`, `Medium`, `Expanded`) ke tipe UI yang sesuai. Ini adalah pendekatan terstruktur untuk membuat tata letak yang berbeda untuk berbagai ukuran layar utama, dari ponsel hingga _desktop_.

---

Kita telah menyelesaikan seluruh topik **10. Advanced Theming System**. Selanjutnya **11. Animations & Visual Effects**.

#### **11. Animations & Visual Effects**

- **Peran:** Animasi dan efek visual adalah elemen penting yang meningkatkan pengalaman pengguna dalam aplikasi. Mereka memberikan _feedback_ visual, memandu perhatian pengguna, dan membuat transisi UI terasa lebih alami dan menyenangkan. Flutter menyediakan _framework_ animasi yang kaya dan fleksibel, memungkinkan Anda menciptakan berbagai macam efek visual.

---

##### **11.1 Basic Animation System**

- **Peran:** Memahami dasar-dasar _framework_ animasi Flutter adalah kunci untuk menciptakan animasi kustom. Ini melibatkan konsep-konsep seperti _AnimationController_, _Tween_, dan _CurvedAnimation_ yang bekerja sama untuk menggerakkan nilai dan menerapkan kurva waktu.

- **Animation Framework:**

  - **Peran:** Flutter menyediakan _framework_ animasi berbasis nilai (_value-based_) yang kuat. Ini berarti Anda tidak langsung menganimasikan _widget_ itu sendiri, melainkan menganimasikan nilai numerik (misalnya, dari 0.0 ke 1.0) selama durasi tertentu. Nilai ini kemudian digunakan untuk mengubah properti _widget_ (ukuran, posisi, warna, opasitas).

  - **Inti dari Framework:**

    - `Animation<T>`: Sebuah kelas abstrak yang mewakili nilai animasi. Ini adalah inti dari sistem.
    - `AnimationController`: Mengelola _state_ animasi. Ini adalah "mesin" yang menghasilkan nilai numerik secara bertahap selama durasi tertentu, biasanya dari 0.0 hingga 1.0. Ini juga mengontrol _playback_ (mulai, berhenti, maju, mundur).

  - **Animation Controllers (`AnimationController`):**

    - **Peran:** Objek yang mengontrol animasi. Ini adalah sumber nilai animasi dan memungkinkan Anda untuk memulai, menghentikan, membalikkan, atau mengulang animasi.
    - **Detail:**
      - Membutuhkan `vsync` (`TickerProviderStateMixin` biasanya digunakan dengan `StatefulWidget`) untuk menyinkronkan animasi dengan _refresh rate_ layar.
      - Anda dapat menentukan `duration` (berapa lama animasi akan berjalan), `lowerBound` (nilai awal, _default_ 0.0), dan `upperBound` (nilai akhir, _default_ 1.0).
      - Metode penting: `forward()`, `reverse()`, `repeat()`, `stop()`, `dispose()`.

  - **Tween Animations (`Tween<T>`):**

    - **Peran:** Objek yang mendefinisikan rentang nilai yang akan dianimasikan (misalnya, dari 0.0 ke 200.0 untuk ukuran, atau dari `Colors.red` ke `Colors.blue` untuk warna). `Tween` tahu bagaimana menginterpolasi antara nilai awal (`begin`) dan nilai akhir (`end`).
    - **Detail:**
      - `Tween` tidak menyimpan _state_. Ia hanya tahu cara menghasilkan nilai pada rentang tertentu.
      - `Tween.animate(Animation<double> parent)`: Menghubungkan `Tween` ke `AnimationController`. Ini menghasilkan objek `Animation<T>` baru yang nilainya akan diinterpolasi berdasarkan nilai dari `AnimationController` induk.
      - Contoh: `Tween<double>(begin: 0.0, end: 200.0)`, `ColorTween(begin: Colors.red, end: Colors.blue)`.

  - **Curved Animations (`CurvedAnimation`):**

    - **Peran:** Menerapkan kurva waktu non-linear ke nilai animasi yang dihasilkan oleh `AnimationController`. Ini membuat animasi terasa lebih alami, seperti efek percepatan atau perlambatan (ease-in, ease-out).
    - **Detail:** Dibangun di atas `AnimationController` dan membutuhkan objek `Curve` (misalnya, `Curves.easeIn`, `Curves.bounceOut`).
    - Contoh: `CurvedAnimation(parent: controller, curve: Curves.easeOut)`.

  - **Animation Listeners (`addListener`):**

    - **Peran:** _Callback_ yang dipanggil setiap kali nilai animasi berubah. Ini memungkinkan Anda untuk mere-_render_ UI dengan nilai animasi yang baru.
    - **Mekanisme:** Anda memanggil `controller.addListener(() { setState(() {}); });` untuk memicu _rebuild_ _widget_ setiap kali nilai _controller_ berubah.

  - **Animation Status Tracking (`addStatusListener`):**

    - **Peran:** _Callback_ yang dipanggil ketika status animasi berubah (misalnya, selesai, maju, mundur, atau dibatalkan). Berguna untuk memicu tindakan lain setelah animasi selesai atau untuk mengubah arah animasi.
    - **Mekanisme:** Anda memanggil `controller.addStatusListener((status) { /* handle status */ });`. Status-statusnya adalah `AnimationStatus.completed`, `dismissed`, `forward`, `reverse`.

- **Contoh Kode (Basic Animation System):**

  ```dart
  import 'package:flutter/material.dart';

  void main() {
    runApp(const BasicAnimationDemoApp());
  }

  class BasicAnimationDemoApp extends StatelessWidget {
    const BasicAnimationDemoApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Basic Animation Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AnimationExampleScreen(),
      );
    }
  }

  // Stateful widget diperlukan karena AnimationController membutuhkan TickerProviderStateMixin
  class AnimationExampleScreen extends StatefulWidget {
    const AnimationExampleScreen({super.key});

    @override
    State<AnimationExampleScreen> createState() => _AnimationExampleScreenState();
  }

  // SingleTickerProviderStateMixin adalah TickerProvider untuk satu AnimationController
  class _AnimationExampleScreenState extends State<AnimationExampleScreen>
      with SingleTickerProviderStateMixin {
    late AnimationController _controller; // Mengontrol animasi
    late Animation<double> _sizeAnimation; // Animasi untuk ukuran
    late Animation<Color?> _colorAnimation; // Animasi untuk warna
    late Animation<double> _curvedAnimation; // Animasi dengan kurva

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        duration: const Duration(seconds: 2), // Durasi animasi 2 detik
        vsync: this, // Sinkronisasi dengan frame rate layar
      );

      // 1. Definisi Tween untuk ukuran
      _sizeAnimation = Tween<double>(begin: 50.0, end: 200.0).animate(_controller);

      // 2. Definisi ColorTween untuk warna
      _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(_controller);

      // 3. Menggabungkan controller dengan kurva
      _curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic, // Contoh kurva (slow at beginning, fast at end)
      );

      // Menggunakan curved animation untuk ukuran
      _sizeAnimation = Tween<double>(begin: 50.0, end: 200.0).animate(_curvedAnimation);

      // Menambahkan listener untuk merebuild widget setiap frame
      _controller.addListener(() {
        setState(() {
          // Widget akan direbuild setiap kali nilai animasi berubah
        });
      });

      // Menambahkan status listener untuk aksi setelah animasi selesai/dibatalkan
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse(); // Balik animasi saat selesai
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward(); // Majukan animasi saat dibatalkan (kembali ke awal)
        }
      });

      // Memulai animasi secara otomatis saat layar dimuat
      _controller.forward();
    }

    @override
    void dispose() {
      _controller.dispose(); // Sangat penting untuk membuang controller
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Basic Animations'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menggunakan nilai animasi untuk properti Container
              Container(
                width: _sizeAnimation.value, // Ukuran dari _sizeAnimation
                height: _sizeAnimation.value,
                color: _colorAnimation.value, // Warna dari _colorAnimation
                child: Center(
                  child: Text(
                    'Value: ${_controller.value.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Current Animation Status: ${_controller.status.name}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.isAnimating) {
                        _controller.stop();
                      } else {
                        _controller.forward();
                      }
                    },
                    child: Text(_controller.isAnimating ? 'Stop' : 'Play Forward'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.isAnimating) {
                        _controller.stop();
                      } else {
                        _controller.reverse();
                      }
                    },
                    child: Text(_controller.isAnimating ? 'Stop' : 'Play Reverse'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Visualisasi Konseptual: Komponen Basic Animation**

  ```mermaid
  graph TD
      A[AnimationController] -- Mengontrol Waktu & Durasi --> B{0.0 hingga 1.0};
      B -- Diberi Curve (Misal: easeOut) --> C[CurvedAnimation];
      C -- Nilai Input ke --> D[Tween (begin, end)];
      D -- Menghasilkan Nilai Interpolasi --> E[Animation<T>];
      E -- Nilai ini digunakan oleh --> F[Widget.build (setState)];
      F -- Untuk Mengubah Properti Visual --> G[Ukuran, Warna, Posisi, Opasitas dll];
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana berbagai komponen dasar animasi Flutter bekerja sama. `AnimationController` mengontrol kemajuan waktu (dari 0.0 hingga 1.0). `CurvedAnimation` memodifikasi kemajuan ini dengan kurva waktu. `Tween` kemudian mengambil nilai yang dihasilkan dan menginterpolasinya ke dalam rentang nilai yang diinginkan (misalnya, ukuran piksel atau warna). Nilai animasi akhir ini kemudian digunakan dalam metode `build()` _widget_ untuk mengubah properti visual, yang direfresh oleh `setState()` yang dipicu oleh _listener_ `AnimationController`.

- **Sumber Daya Tambahan:**

  - [Animations Tutorial](https://docs.flutter.dev/ui/animations/tutorial) (Dokumentasi resmi Flutter)
  - [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html) (Dokumentasi API Flutter)
  - [Tween Animations](https://api.flutter.dev/flutter/animation/Tween-class.html) (Dokumentasi API Flutter)

---

Dengan ini, Anda seharusnya memiliki pemahaman yang kuat tentang fondasi animasi di Flutter.

##### **11.2 Advanced Animations**

- **Peran:** Animasi tingkat lanjut melampaui perubahan properti sederhana, memungkinkan transisi yang lebih kaya, interaksi yang lebih dinamis, dan efek yang terasa lebih hidup. Ini termasuk _shared element transitions_ antar halaman, animasi berbasis fisika, dan penggunaan _widget_ animasi implisit dan eksplisit untuk kemudahan dan kontrol.

---

###### **Hero Animations**

- **Peran:** Animasi _Hero_ adalah jenis _shared element transition_ di mana sebuah _widget_ ("_hero_") seolah-olah "terbang" dari satu lokasi di satu halaman ke lokasi baru di halaman lain saat transisi. Ini memberikan pengalaman navigasi yang mulus dan menarik, membantu pengguna memahami hubungan spasial antara dua layar.

- **Hero Widget Implementation:**

  - **Peran:** Untuk membuat animasi _Hero_, Anda menggunakan _widget_ `Hero` di kedua halaman (halaman asal dan halaman tujuan).
  - **Mekanisme:**
    1.  Bungkus _widget_ yang sama di halaman asal dan halaman tujuan dengan _widget_ `Hero`.
    2.  Berikan `tag` yang unik dan identik untuk kedua _widget_ `Hero`. _Tag_ ini memberi tahu Flutter bahwa kedua _widget_ tersebut adalah "objek" yang sama yang harus dianimasikan selama transisi.
    3.  Pastikan _widget_ anak dari `Hero` di halaman asal dan tujuan memiliki ukuran dan bentuk akhir yang berbeda agar ada perubahan yang dapat dianimasikan.
    4.  Gunakan `Navigator.push()` untuk transisi antar halaman.

- **Custom Hero Animations:**

  - **Peran:** Meskipun `Hero` _widget_ menangani sebagian besar transisi secara otomatis, Anda dapat mengkustomisasi "penerbangan" _Hero_ (misalnya, menambahkan efek _fade_ atau rotasi) dengan menggunakan properti `flightShuttleBuilder` di _widget_ `Hero`.
  - **Mekanisme:** `flightShuttleBuilder` memungkinkan Anda untuk menyediakan _widget_ kustom yang akan digunakan sebagai "pesawat ulang-alik" selama transisi, bukan hanya klon dari _widget_ asli.

- **Hero Flight Paths:**

  - **Peran:** Jalur "penerbangan" default untuk animasi _Hero_ adalah garis lurus dari posisi awal ke posisi akhir. Anda dapat memodifikasi ini menggunakan `createRectTween` di `ThemeData`.
  - **Mekanisme:** Dengan mengkustomisasi `createRectTween`, Anda dapat mengubah bagaimana _bounding box_ _Hero_ diinterpolasi selama transisi, menciptakan jalur yang lebih kompleks (misalnya, melengkung).

- **Nested Hero Animations:**

  - **Peran:** Menganimasikan beberapa _widget_ `Hero` dalam satu transisi halaman, atau memiliki _widget_ `Hero` di dalam _widget_ `Hero` lain.
  - **Detail:** Ini bisa menjadi kompleks dan harus dilakukan dengan hati-hati untuk menghindari konflik _tag_ atau perilaku yang tidak terduga. Pastikan setiap _Hero_ memiliki _tag_ yang unik di seluruh _widget tree_ yang relevan.

- **Contoh Kode (Hero Animation):**

  ```dart
  import 'package:flutter/material.dart';

  void main() {
    runApp(const HeroAnimationApp());
  }

  class HeroAnimationApp extends StatelessWidget {
    const HeroAnimationApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Hero Animation Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
        ),
        home: const HeroListScreen(),
      );
    }
  }

  class HeroListScreen extends StatelessWidget {
    const HeroListScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Hero List'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Hero(
                  tag: 'avatar-$index', // Tag unik untuk setiap item
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.teal[100 * (index + 1)],
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                title: Text('Item Number ${index + 1}'),
                subtitle: const Text('Tap to see Hero animation'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HeroDetailScreen(itemIndex: index),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    }
  }

  class HeroDetailScreen extends StatelessWidget {
    final int itemIndex;
    const HeroDetailScreen({super.key, required this.itemIndex});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Hero Detail'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'avatar-$itemIndex', // Tag yang sama dengan di ListScreen
                child: Container(
                  width: 200, // Ukuran berbeda di halaman detail
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.teal[100 * (itemIndex + 1)],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${itemIndex + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 80),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Detail for Item Number ${itemIndex + 1}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Ini adalah deskripsi detail untuk item yang dipilih. Perhatikan bagaimana lingkaran "terbang" dari daftar ke layar detail.',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Visualisasi Konseptual: Hero Animation Flow**

  ```mermaid
  graph TD
      A[Halaman A (List)] -- Punya Hero Widget dengan Tag "X" --> B[Navigasi ke Halaman B];
      B --> C[Halaman B (Detail)] -- Punya Hero Widget dengan Tag "X" di Lokasi Berbeda --> D[Flutter Animator];
      D -- "Terbangkan" Hero dari A ke C --> E[Transisi Mulus];
  ```

  **Penjelasan Visual:**
  Diagram ini menggambarkan bagaimana animasi _Hero_ bekerja. Saat navigasi dipicu, Flutter Animator mengidentifikasi dua _widget_ `Hero` dengan _tag_ yang sama di halaman asal dan tujuan. Animator kemudian menciptakan efek "terbang" dari _widget_ di halaman asal ke posisi _widget_ di halaman tujuan, menciptakan transisi yang mulus.

---

###### **Page Transitions**

- **Peran:** Transisi halaman adalah animasi yang terjadi saat beralih dari satu layar ke layar lain. Selain animasi _Hero_, ada banyak jenis transisi yang dapat meningkatkan fluiditas aplikasi.

- **Custom Page Routes:**

  - **Peran:** Memberi Anda kontrol penuh atas animasi saat transisi masuk dan keluar dari halaman. Anda dapat membuat _route_ kustom yang menentukan bagaimana halaman baru dibangun dan dianimasikan.
  - **Mekanisme:** Buat kelas yang mengekstensi `PageRouteBuilder`. Dalam konstruktor `PageRouteBuilder`, Anda mendefinisikan:
    - `pageBuilder`: Membangun _widget_ halaman yang akan ditampilkan.
    - `transitionsBuilder`: _Callback_ yang menyediakan `Animation<double>` yang dapat Anda gunakan untuk menganimasikan _widget_ (misalnya, _fade_, _slide_, _scale_).
  - **Contoh umum:** `FadeTransition`, `SlideTransition`, `ScaleTransition`, `RotationTransition`.

- **Transition Builders:**

  - **Peran:** Adalah _callback_ yang disediakan oleh `PageRouteBuilder` atau _widget_ animasi lainnya, di mana Anda menerima nilai `Animation` dan anak `widget` untuk membangun efek transisi.
  - **Detail:** Anda membungkus `child` _widget_ dengan _widget_ transisi (misalnya, `FadeTransition`) dan meneruskan `animation` yang disediakan.

- **Shared Element Transitions:**

  - **Peran:** Animasi di mana satu atau lebih elemen _UI_ (seperti gambar, teks, atau kartu) bergerak dan/atau berubah bentuk secara mulus dari satu posisi di satu layar ke posisi lain di layar berikutnya. _Hero Animations_ adalah jenis spesifik dari _shared element transition_.
  - **Detail:** Ini menciptakan rasa kontinuitas visual dan membantu pengguna menjaga konteks saat menavigasi.

- **Contoh Kode (Custom Page Transitions - Slide Transition):**

  ```dart
  import 'package:flutter/material.dart';

  void main() {
    runApp(const CustomPageRouteApp());
  }

  class CustomPageRouteApp extends StatelessWidget {
    const CustomPageRouteApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Custom Page Route Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: const FirstScreen(),
      );
    }
  }

  class SlidePageRoute extends PageRouteBuilder {
    final Widget page;
    SlidePageRoute(this.page)
        : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Posisi slide dari kanan ke kiri
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease; // Kurva animasi

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation, // Menerapkan offset dari animasi
                child: child, // Halaman yang sedang bertransisi
              );
            },
          );
  }

  class FadePageRoute extends PageRouteBuilder {
    final Widget page;
    FadePageRoute(this.page)
        : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Animasi fade in/out
              return FadeTransition(
                opacity: animation, // Opasitas dari 0.0 ke 1.0
                child: child,
              );
            },
          );
  }

  class FirstScreen extends StatelessWidget {
    const FirstScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('First Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, SlidePageRoute(const SecondScreen()));
                },
                child: const Text('Go to Second Screen (Slide)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, FadePageRoute(const SecondScreen()));
                },
                child: const Text('Go to Second Screen (Fade)'),
              ),
            ],
          ),
        ),
      );
    }
  }

  class SecondScreen extends StatelessWidget {
    const SecondScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Second Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Second Screen!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Kembali ke layar sebelumnya
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

---

###### **Implicit & Explicit Animations**

Flutter membedakan antara dua kategori utama animasi berdasarkan cara Anda mengontrolnya:

- **Implicit Animations (Animasi Implisit):**

  - **Peran:** Animasi yang secara otomatis terjadi ketika properti _widget_ tertentu berubah. Anda cukup memberikan nilai _target_ yang baru, dan _widget_ akan secara otomatis menganimasikannya dari nilai saat ini ke nilai _target_ tersebut selama durasi yang ditentukan. Ini adalah cara yang lebih sederhana untuk membuat animasi.

  - **Mekanisme:** Gunakan _widget_ yang diawali dengan `Animated` (misalnya, `AnimatedContainer`, `AnimatedOpacity`, `AnimatedPositioned`, `AnimatedCrossFade`). Anda tidak perlu `AnimationController` atau `Tween` secara eksplisit.

  - **Kapan digunakan:** Untuk animasi sederhana dan tunggal yang langsung terkait dengan perubahan _state_ _widget_.

  - **`AnimatedContainer` Usage:**

    - **Peran:** Sebuah _container_ yang menganimasikan perubahannya ketika propertinya seperti `width`, `height`, `color`, `decoration`, `padding`, atau `alignment` berubah.
    - **Properti:** Anda menentukan `duration` dan opsional `curve`.

  - **`AnimatedOpacity` dan variants:**

    - **Peran:** Menganimasikan opasitas anak _widget_.
    - **Variants:** Ada banyak _widget_ `Animated` lainnya seperti `AnimatedAlign`, `AnimatedPositioned`, `AnimatedDefaultTextStyle`, `AnimatedPadding`, `AnimatedSwitcher`, dan `AnimatedCrossFade`. Masing-masing dirancang untuk menganimasikan properti tertentu dari anak mereka.

  - **Contoh Kode (Implicit Animations):**

    ```dart
    import 'package:flutter/material.dart';

    void main() {
      runApp(const ImplicitAnimationDemoApp());
    }

    class ImplicitAnimationDemoApp extends StatelessWidget {
      const ImplicitAnimationDemoApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Implicit Animation Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            useMaterial3: true,
          ),
          home: const ImplicitAnimationScreen(),
        );
      }
    }

    class ImplicitAnimationScreen extends StatefulWidget {
      const ImplicitAnimationScreen({super.key});

      @override
      State<ImplicitAnimationScreen> createState() => _ImplicitAnimationScreenState();
    }

    class _ImplicitAnimationScreenState extends State<ImplicitAnimationScreen> {
      double _size = 100.0;
      Color _color = Colors.orange;
      bool _showText = true;

      void _toggleAnimation() {
        setState(() {
          _size = _size == 100.0 ? 200.0 : 100.0;
          _color = _color == Colors.orange ? Colors.deepPurple : Colors.orange;
          _showText = !_showText;
        });
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Implicit Animations'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AnimatedContainer: Animasi ukuran dan warna secara otomatis
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(_size / 2),
                  ),
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _showText ? 1.0 : 0.0,
                    child: Text(
                      _showText ? 'Hello!' : 'Goodbye!',
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // AnimatedSwitcher: Animasi transisi antar widget yang berbeda
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _showText
                      ? const Text(
                          'Text is visible!',
                          key: ValueKey('visibleText'), // Key penting untuk AnimatedSwitcher
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        )
                      : const Text(
                          'Text is hidden!',
                          key: ValueKey('hiddenText'),
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _toggleAnimation,
                  child: const Text('Toggle Animation'),
                ),
              ],
            ),
          ),
        );
      }
    }
    ```

- **Explicit Animations (Animasi Eksplisit):**

  - **Peran:** Memberi Anda kontrol penuh atas siklus hidup animasi menggunakan `AnimationController`. Anda secara manual mengontrol kapan animasi dimulai, dihentikan, dibalik, dan bagaimana nilainya digunakan untuk mempengaruhi properti _widget_.

  - **Mekanisme:** Melibatkan penggunaan `AnimationController`, `Tween`, `CurvedAnimation`, dan `addListener()` (atau `AnimatedBuilder`/`TweenAnimationBuilder`).

  - **Kapan digunakan:** Untuk animasi yang lebih kompleks, berurutan, berulang, atau ketika Anda perlu berkoordinasi banyak animasi bersama.

  - **`TweenAnimationBuilder`:**

    - **Peran:** _Widget_ sederhana yang menggabungkan `Tween` dan `AnimationController` (secara internal) untuk menganimasikan properti tunggal. Anda hanya perlu memberikan nilai _target_ (`tween.end`) dan durasi. Ini lebih mudah daripada `AnimationController` untuk kasus sederhana, tetapi tidak memiliki kontrol _playback_ yang sama.
    - **Mekanisme:** Anda memberikan `duration`, `tween` (atau `builder` yang membuat `tween`), dan `builder` _callback_ yang akan direbuild setiap kali nilai animasi berubah.

  - **`AnimationBuilder` Pattern:**

    - **Peran:** Sebuah _widget_ yang dirancang untuk merebuild sebagian dari pohon _widget_ Anda setiap kali `Animation` berubah nilainya. Ini adalah cara yang lebih efisien untuk menggunakan nilai animasi tanpa memanggil `setState` pada seluruh _StatefulWidget_.
    - **Mekanisme:** `AnimatedBuilder` menerima `animation` (misalnya, `AnimationController` atau `CurvedAnimation`) dan `builder` _callback_. Bagian _widget tree_ yang berubah harus berada di dalam _builder_ _callback_. Properti `child` di `AnimatedBuilder` adalah _widget_ yang tidak berubah selama animasi, yang kemudian dapat diteruskan ke _builder_ untuk kinerja yang lebih baik.

  - **Contoh Kode (Explicit Animations dengan `TweenAnimationBuilder` & `AnimatedBuilder`):**

    ```dart
    import 'package:flutter/material.dart';

    void main() {
      runApp(const ExplicitAnimationDemoApp());
    }

    class ExplicitAnimationDemoApp extends StatelessWidget {
      const ExplicitAnimationDemoApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Explicit Animation Demo',
          theme: ThemeData(
            primarySwatch: Colors.green,
            useMaterial3: true,
          ),
          home: const ExplicitAnimationScreen(),
        );
      }
    }

    class ExplicitAnimationScreen extends StatefulWidget {
      const ExplicitAnimationScreen({super.key});

      @override
      State<ExplicitAnimationScreen> createState() => _ExplicitAnimationScreenState();
    }

    // TickerProviderStateMixin untuk AnimationController
    class _ExplicitAnimationScreenState extends State<ExplicitAnimationScreen>
        with SingleTickerProviderStateMixin {
      late AnimationController _controller;
      double _targetOpacity = 1.0;
      double _targetScale = 1.0;

      @override
      void initState() {
        super.initState();
        _controller = AnimationController(
          duration: const Duration(seconds: 2),
          vsync: this,
        );
      }

      @override
      void dispose() {
        _controller.dispose();
        super.dispose();
      }

      void _toggleManualAnimation() {
        if (_controller.status == AnimationStatus.completed || _controller.status == AnimationStatus.forward) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Explicit Animations'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TweenAnimationBuilder: Animasi skala tombol secara otomatis
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.5, end: _targetScale), // Animasi dari 0.5 ke _targetScale
                  duration: const Duration(seconds: 1),
                  curve: Curves.elasticOut, // Contoh kurva elastis
                  builder: (BuildContext context, double scale, Widget? child) {
                    return Transform.scale(
                      scale: scale, // Menggunakan nilai animasi skala
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _targetScale = _targetScale == 1.0 ? 1.5 : 1.0;
                          });
                        },
                        child: const Text('Scale Me (TweenAnimationBuilder)'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // AnimatedBuilder: Menggunakan nilai dari AnimationController untuk rotasi
                // Widget yang TIDAK berubah selama animasi ada di luar builder,
                // dan diteruskan sebagai `child` dari AnimatedBuilder.
                // Ini mengoptimalkan performa karena hanya bagian dalam builder yang direbuild.
                AnimatedBuilder(
                  animation: _controller, // Controller adalah Animation yang diamati
                  builder: (BuildContext context, Widget? child) {
                    return Transform.rotate(
                      angle: _controller.value * 2.0 * 3.14159, // Rotasi 0 hingga 360 derajat
                      child: child, // Menggunakan child yang tidak berubah
                    );
                  },
                  child: Container( // Widget ini hanya dibangun sekali
                    width: 100,
                    height: 100,
                    color: Colors.green,
                    child: const Center(
                      child: Text(
                        'Rotate',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _toggleManualAnimation,
                  child: Text(_controller.isAnimating ? 'Stop Rotation' : 'Start Rotation'),
                ),
              ],
            ),
          ),
        );
      }
    }
    ```

---

###### **Physics-Based Animations**

- **Peran:** Animasi tradisional seringkali menggunakan kurva waktu yang telah ditentukan (misalnya, `Curves.easeOut`). Animasi berbasis fisika meniru perilaku objek di dunia nyata (misalnya, pegas, gesekan, gravitasi), memberikan perasaan yang lebih organik dan responsif terhadap _gesture_ pengguna atau perubahan _state_.

- **Spring Simulations:**

  - **Peran:** Menggunakan model pegas (_spring model_) untuk mensimulasikan gerakan. Ketika suatu objek dipindahkan, ia akan "memantul" atau "berosilasi" seperti pegas sebelum berhenti pada posisi akhirnya.
  - **Mekanisme:** Flutter menyediakan `SpringSimulation` dalam _package_ `flutter/physics`. Anda menentukan properti pegas seperti `mass`, `stiffness` (kekakuan), dan `damping` (redaman).

- **Physics Simulation:**

  - **Peran:** Konsep umum tentang bagaimana objek bergerak di bawah pengaruh gaya fisika. Flutter memiliki _package_ `flutter/physics` yang menyediakan kelas-kelas untuk simulasi fisika ini.
  - **Detail:** Ini lebih dari sekadar kurva waktu; ini tentang bagaimana _value_ berubah berdasarkan simulasi fisik yang berkelanjutan.

- **Friction dan Gravity:**

  - **Peran:** Selain pegas, simulasi fisika juga dapat mencakup gesekan (untuk memperlambat objek) dan gravitasi (untuk menarik objek ke bawah).
  - **Mekanisme:** Anda dapat membangun simulasi kustom atau menggunakan simulasi bawaan yang memasukkan faktor-faktor ini.

- **Custom Physics:**

  - **Peran:** Membuat simulasi fisika Anda sendiri untuk mencapai efek gerakan yang sangat spesifik dan unik.
  - **Mekanisme:** Anda dapat mengimplementasikan kelas `Simulation` dari _package_ `flutter/physics` dan menentukan bagaimana nilai berubah seiring waktu berdasarkan model fisika Anda.

- **`SpringAnimation`:**

  - **Peran:** Ini merujuk pada penggunaan `SpringSimulation` dengan `AnimationController` untuk menghasilkan animasi berbasis pegas.
  - **Contoh:** Mengatur `AnimationController` untuk menggunakan `SpringSimulation` sebagai `upperBound` dan `lowerBound` pada `AnimationController` Anda, atau dengan lebih mudah menggunakan _package_ yang menyederhanakan _spring animations_.

- **Contoh Kode (Physics-Based Animation - Spring):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter/physics.dart'; // Untuk SpringSimulation

  void main() {
    runApp(const SpringAnimationDemoApp());
  }

  class SpringAnimationDemoApp extends StatelessWidget {
    const SpringAnimationDemoApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Spring Animation Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          useMaterial3: true,
        ),
        home: const SpringAnimationScreen(),
      );
    }
  }

  class SpringAnimationScreen extends StatefulWidget {
    const SpringAnimationScreen({super.key});

    @override
    State<SpringAnimationScreen> createState() => _SpringAnimationScreenState();
  }

  class _SpringAnimationScreenState extends State<SpringAnimationScreen>
      with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    late SpringSimulation _springSimulation;

    @override
    void initState() {
      super.initState();

      _controller = AnimationController(vsync: this);

      // Definisikan properti pegas
      final SpringDescription springDescription = SpringDescription(
        mass: 1, // Massa objek
        stiffness: 100, // Kekakuan pegas (seberapa cepat kembali)
        damping: 10, // Redaman (seberapa cepat berhenti berosilasi)
      );

      // Buat simulasi pegas
      _springSimulation = SpringSimulation(
        springDescription,
        0.0, // Posisi awal (dari mana dimulai)
        1.0, // Posisi akhir (ke mana ia akan berosilasi/berhenti)
        0.0, // Kecepatan awal
      );

      // Set controller untuk menjalankan simulasi fisika
      _controller.animateWith(_springSimulation);

      // Listener untuk merefresh UI
      _controller.addListener(() {
        setState(() {});
      });
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      final double scale = 1.0 + (_controller.value * 0.5); // Animasi skala dari 1.0 ke 1.5

      return Scaffold(
        appBar: AppBar(
          title: const Text('Physics-Based Animations (Spring)'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: scale, // Menerapkan skala dari animasi fisika
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Bounce',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Reset dan mulai ulang animasi
                  _controller.reset();
                  _controller.animateWith(_springSimulation);
                },
                child: const Text('Re-run Spring Animation'),
              ),
              const SizedBox(height: 10),
              Text(
                'Controller Value: ${_controller.value.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Controller Velocity: ${_controller.velocity.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Visualisasi Konseptual: Spring Simulation Parameters**

  ```mermaid
  graph TD
      A[Mass] --> S[Spring Simulation];
      B[Stiffness] --> S;
      C[Damping] --> S;
      S --> D[Animasi Objek yang Realistis (Memantul/Meredam)];
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan tiga parameter utama yang mempengaruhi simulasi pegas: Massa (berat objek), Kekakuan (_Stiffness_) pegas (seberapa kuat tarikannya), dan Redaman (_Damping_) (seberapa cepat gerakan mereda). Mengubah parameter ini akan menghasilkan perilaku animasi yang berbeda, dari sangat "kenyal" hingga gerakan yang lambat dan halus.

---

Dengan pembahasan **11.2 Advanced Animations** ini, Anda kini memiliki pemahaman tentang bagaimana menciptakan transisi _Hero_ antar halaman, mengkustomisasi _page transitions_, serta memanfaatkan kekuatan animasi implisit dan eksplisit, hingga animasi berbasis fisika.

Selanjutnya, masuk ke bagian terakhir dari topik animasi: **11.3 External Animation Libraries**.

##### **11.3 External Animation Libraries**

- **Peran:** Meskipun Flutter memiliki _framework_ animasi bawaan yang kuat, ada kalanya Anda memerlukan animasi yang lebih kompleks, dibuat oleh desainer grafis, atau di luar kemampuan animasi _code-based_ yang efisien. _External animation libraries_ seperti Lottie dan Rive memungkinkan Anda mengintegrasikan animasi vektor pra-dibuat yang ringan dan interaktif ke dalam aplikasi Anda, menjembatani kesenjangan antara desain dan pengembangan.

---

###### **Lottie Animations**

- **Peran:** Lottie adalah pustaka animasi _open-source_ dari Airbnb yang merender animasi Adobe After Effects yang diekspor sebagai JSON di _mobile_ dan _web_ secara _real-time_. Ini sangat populer untuk animasi UI yang ringan, berkualitas tinggi, dan dapat diskalakan.

- **Lottie File Integration:**

  - **Mekanisme:**
    1.  **Dapatkan berkas Lottie:** Unduh berkas `.json` dari platform seperti [LottieFiles](https://lottiefiles.com/).
    2.  **Tambahkan dependensi:** Di `pubspec.yaml`, tambahkan _package_ `lottie`:
        ```yaml
        dependencies:
          lottie: ^latest_version # Ganti dengan versi terbaru
        ```
    3.  **Tambahkan aset:** Letakkan berkas `.json` Anda di folder aset (misalnya, `assets/lotties/`). Deklarasikan folder ini di `pubspec.yaml`:
        ```yaml
        flutter:
          assets:
            - assets/lotties/
        ```
    4.  **Muat animasi:** Gunakan `Lottie.asset()`, `Lottie.network()`, `Lottie.file()`, atau `Lottie.memory()` untuk memuat animasi.

- **Animation Controllers (dengan Lottie):**

  - **Peran:** Mirip dengan animasi Flutter bawaan, Anda sering menggunakan `AnimationController` untuk mengontrol _playback_ animasi Lottie (mulai, berhenti, putar ulang, maju/mundur pada _frame_ tertentu).
  - **Mekanisme:** Berikan `controller` ke _widget_ `Lottie`. Anda kemudian dapat memanggil metode pada `_controller` untuk memanipulasi animasi.

- **Dynamic Properties:**

  - **Peran:** Lottie memungkinkan Anda untuk mengubah properti animasi secara _runtime_, seperti warna, opasitas, atau bahkan teks, tanpa memodifikasi berkas JSON asli. Ini sangat kuat untuk tema atau kustomisasi pengguna.
  - **Mekanisme:** Gunakan `LottieComposition.fromMap` untuk memuat animasi, lalu gunakan `ValueNotifier<T>` untuk mengubah properti yang di-_exposed_ oleh Lottie melalui jalur properti. `Lottie.asset` dan `Lottie.network` juga memiliki properti `delegates` dan `keyPath` untuk kustomisasi dinamis.

- **Performance Optimization:**

  - **Tips:**
    - **Batasi ukuran berkas:** Animasi yang lebih kecil lebih cepat dimuat dan dirender.
    - **Gunakan _caching_:** Lottie secara otomatis melakukan _caching_ (jika memungkinkan), tetapi pastikan Anda menggunakannya dengan benar.
    - **Dispose controller:** Pastikan untuk membuang `AnimationController` saat _widget_ tidak lagi digunakan.
    - **Hindari animasi besar di ListView:** Jika Anda memiliki banyak animasi Lottie dalam daftar yang dapat digulir, pertimbangkan untuk hanya menganimasikan yang terlihat untuk menghemat sumber daya.

- **Contoh Kode (Lottie Animation):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:lottie/lottie.dart'; // Import package lottie

  void main() {
    runApp(const LottieAnimationDemoApp());
  }

  class LottieAnimationDemoApp extends StatelessWidget {
    const LottieAnimationDemoApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Lottie Animation Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          useMaterial3: true,
        ),
        home: const LottieScreen(),
      );
    }
  }

  class LottieScreen extends StatefulWidget {
    const LottieScreen({super.key});

    @override
    State<LottieScreen> createState() => _LottieScreenState();
  }

  class _LottieScreenState extends State<LottieScreen> with TickerProviderStateMixin {
    late AnimationController _lottieController;

    @override
    void initState() {
      super.initState();
      _lottieController = AnimationController(vsync: this);
    }

    @override
    void dispose() {
      _lottieController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lottie Animations'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pastikan Anda memiliki berkas JSON Lottie di assets/lotties/
              // Misalnya, 'assets/lotties/animation_loader.json'
              // Anda bisa mengunduh dari LottieFiles.com
              Lottie.asset(
                'assets/lotties/animation_loader.json', // Ganti dengan path ke file Lottie Anda
                controller: _lottieController,
                onLoaded: (composition) {
                  // Simpan durasi animasi agar controller bisa memutarnya
                  _lottieController
                    ..duration = composition.duration
                    ..repeat(); // Ulangi animasi setelah dimuat
                },
                width: 200,
                height: 200,
                fit: BoxFit.fill,
                repeat: true, // Atau kontrol dari controller
              ),
              const SizedBox(height: 20),
              const Text(
                'Loading Lottie Animation',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_lottieController.isAnimating) {
                    _lottieController.stop();
                  } else {
                    _lottieController.repeat(); // Lanjutkan mengulang
                  }
                },
                child: Text(_lottieController.isAnimating ? 'Stop Animation' : 'Start Animation'),
              ),
              const SizedBox(height: 10),
              // Contoh mengubah properti dinamis (jika Lottie memiliki path yang sesuai)
              // Misalnya, mengubah warna layer bernama 'Layer 1'
              // Lottie.asset(
              //   'assets/lotties/animation_loader.json',
              //   delegates: LottieDelegates(
              //     values: [
              //       ValueDelegate.color(['Layer 1', 'Shape 1', 'Fill 1'], value: Colors.green),
              //     ],
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Catatan: Untuk menjalankan contoh ini, pastikan Anda menambahkan `lottie` ke `pubspec.yaml` dan menempatkan berkas Lottie JSON (misalnya, `animation_loader.json`) di folder `assets/lotties/` yang sudah dideklarasikan di `pubspec.yaml`.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Visualisasi Konseptual: Lottie Workflow**

  ```mermaid
  graph LR
      A[Adobe After Effects] -- Ekspor --> B[Berkas JSON Lottie (.json)];
      B -- Tambahkan ke Proyek Flutter (Assets) --> C[Package Lottie di Flutter];
      C -- Render di Aplikasi dengan Lottie.asset/network --> D[Animasi Kualitas Tinggi yang Ringan];
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan alur kerja Lottie. Animasi dibuat di Adobe After Effects, diekspor sebagai berkas JSON, lalu diintegrasikan ke dalam proyek Flutter menggunakan _package_ Lottie untuk dirender sebagai animasi yang ringan dan berkualitas tinggi.

---

###### **Rive Animations**

- **Peran:** Rive (sebelumnya Flare) adalah _tool_ desain dan pustaka _runtime_ yang memungkinkan desainer membuat animasi interaktif yang kompleks, _state machine_, dan ilustrasi vektor yang dapat diskalakan dalam satu berkas `.riv`. Ini sangat kuat untuk animasi yang merespons input pengguna atau perubahan _state_ aplikasi.

- **Rive File Setup:**

  - **Mekanisme:**
    1.  **Buat animasi Rive:** Desainer membuat animasi dan _state machine_ di Rive editor ([rive.app](https://rive.app/)).
    2.  **Ekspor berkas Rive:** Ekspor animasi sebagai berkas `.riv`.
    3.  **Tambahkan dependensi:** Di `pubspec.yaml`, tambahkan _package_ `rive`:
        ```yaml
        dependencies:
          rive: ^latest_version # Ganti dengan versi terbaru
        ```
    4.  **Tambahkan aset:** Letakkan berkas `.riv` Anda di folder aset (misalnya, `assets/rives/`). Deklarasikan folder ini di `pubspec.yaml`.
    5.  **Muat animasi:** Gunakan `RiveAnimation.asset()` atau `RiveAnimation.network()`.

- **State Machines:**

  - **Peran:** Salah satu fitur paling kuat dari Rive. _State machine_ memungkinkan desainer mendefinisikan _state_ animasi (misalnya, _idle_, _hover_, _click_) dan transisi antar _state_ ini. Pengembang kemudian dapat memicu transisi ini dari kode.
  - **Mekanisme:** Di Rive editor, Anda mendefinisikan _state_ dan panah transisi. Di Flutter, Anda mendapatkan _controller_ _state machine_ dari animasi Rive (`RiveAnimation.asset(onInit: (artboard) { ... })`) dan memicu input (misalnya, `SMIBool.change(true)`) yang telah Anda definisikan di _state machine_.

- **Interactive Animations:**

  - **Peran:** Membuat animasi yang merespons secara langsung terhadap interaksi pengguna (misalnya, _hover_, _tap_, geser) atau _state_ aplikasi.
  - **Mekanisme:** Dengan menggunakan _state machine_ Rive, Anda dapat membuat _toggle_, _slider_, atau tombol yang memiliki animasi kustom saat disentuh atau nilainya berubah.

- **Custom Artboards:**

  - **Peran:** Berkas Rive dapat berisi beberapa _artboard_ (mirip dengan halaman atau _scene_ dalam _tool_ desain). Anda dapat memilih _artboard_ mana yang akan ditampilkan.
  - **Mekanisme:** Tentukan `artboard` di konstruktor `RiveAnimation` jika berkas `.riv` Anda memiliki lebih dari satu _artboard_.

- **Contoh Kode (Rive Animation):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:rive/rive.dart'; // Import package rive

  void main() {
    runApp(const RiveAnimationDemoApp());
  }

  class RiveAnimationDemoApp extends StatelessWidget {
    const RiveAnimationDemoApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Rive Animation Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          useMaterial3: true,
        ),
        home: const RiveScreen(),
      );
    }
  }

  class RiveScreen extends StatefulWidget {
    const RiveScreen({super.key});

    @override
    State<RiveScreen> createState() => _RiveScreenState();
  }

  class _RiveScreenState extends State<RiveScreen> {
    /// Controller untuk state machine Rive
    SMIBool? _btnClick; // Contoh boolean input dari state machine Rive

    void _onRiveInit(Artboard artboard) {
      // Mendapatkan instance StateMachineController dari Artboard
      final controller =
          StateMachineController.fromArtboard(artboard, 'State Machine 1'); // Ganti 'State Machine 1' dengan nama State Machine Anda
      artboard.addController(controller!);

      // Mendapatkan input boolean 'btnClick' dari state machine
      _btnClick = controller.findInput<bool>('btnClick') as SMIBool; // Ganti 'btnClick' dengan nama boolean input Anda
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rive Animations'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // Pemicu animasi Rive melalui state machine input
                  _btnClick?.change(true); // Set boolean input menjadi true
                  Future.delayed(const Duration(milliseconds: 500), () {
                    _btnClick?.change(false); // Set kembali menjadi false setelah delay
                  });
                },
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: RiveAnimation.asset(
                    'assets/rives/example_button.riv', // Ganti dengan path ke file Rive Anda
                    fit: BoxFit.contain,
                    onInit: _onRiveInit, // Panggil _onRiveInit saat Rive dimuat
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tap the Rive animation above!',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Catatan: Untuk menjalankan contoh ini, pastikan Anda menambahkan `rive` ke `pubspec.yaml` dan menempatkan berkas Rive `.riv` (misalnya, `example_button.riv`) di folder `assets/rives/` yang sudah dideklarasikan di `pubspec.yaml`. Animasi Rive ini memerlukan State Machine dengan input boolean bernama `btnClick`.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Visualisasi Konseptual: Rive State Machine**

  ```mermaid
  graph TD
      A[Idle State] -- onHover --> B[Hover State];
      B -- onClick --> C[Click State];
      C -- onAnimationComplete --> A;
      B -- onMouseLeave --> A;
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan contoh sederhana _state machine_ di Rive. Animasi dapat beralih antara _state_ seperti `Idle`, `Hover`, dan `Click` berdasarkan input (_onHover_, _onClick_, _onMouseLeave_) dan pemicu animasi (_onAnimationComplete_). Ini memungkinkan animasi interaktif yang kompleks yang dikelola oleh desainer.

---

Dengan ini, kita telah menyelesaikan seluruh topik **11. Animations & Visual Effects**.

Selanjutnya, kita akan masuk ke bagian terakhir dari **Fase 7: Styling, Theming & Responsive Design**: **12. Custom Painting & Graphics**.

Tentu, mari kita lanjutkan ke bagian terakhir dari **Fase 7: Styling, Theming & Responsive Design**: **12. Custom Painting & Graphics**.

---

### **FASE 7: Styling, Theming & Responsive Design (Lanjutan)**

#### **12. Custom Painting & Graphics**

- **Peran:** Meskipun Flutter menyediakan banyak _widget_ yang kaya untuk membangun UI, ada kalanya Anda memerlukan kontrol piksel yang lebih halus untuk menggambar bentuk, grafik, atau efek visual yang benar-benar kustom. `CustomPainter` dan `Canvas API` memberikan fleksibilitas tak terbatas untuk menggambar apa pun yang Anda inginkan langsung ke layar.

---

##### **12.1 Custom Painter**

- **Peran:** `CustomPainter` adalah _widget_ yang memungkinkan Anda menggambar grafik kustom langsung pada `Canvas`. Ini adalah fondasi untuk membuat grafik non-standar, visualisasi data, atau elemen UI yang sangat unik yang tidak dapat dicapai dengan _widget_ bawaan.

- **Canvas API:**

  - **Peran:** `Canvas` adalah antarmuka yang menyediakan metode untuk menggambar berbagai bentuk geometris, teks, dan gambar. Ini adalah kanvas tempat Anda melukis.

  - **Proses:** Anda mengimplementasikan kelas `CustomPainter` yang mengekspos metode `paint(Canvas canvas, Size size)`. Di sinilah Anda menggunakan `Canvas API`.

  - **Drawing Primitives:**

    - **Peran:** Fungsi dasar untuk menggambar bentuk sederhana seperti garis, lingkaran, persegi panjang, dan busur.
    - **Mekanisme:**
      - `canvas.drawLine(Offset p1, Offset p2, Paint paint)`: Menggambar garis antara dua titik.
      - `canvas.drawCircle(Offset center, double radius, Paint paint)`: Menggambar lingkaran.
      - `canvas.drawRect(Rect rect, Paint paint)`: Menggambar persegi panjang.
      - `canvas.drawOval(Rect rect, Paint paint)`: Menggambar oval atau elips.
      - `canvas.drawArc(Rect rect, double startAngle, double sweepAngle, bool useCenter, Paint paint)`: Menggambar busur.
      - `canvas.drawPath(Path path, Paint paint)`: Menggambar bentuk kompleks yang didefinisikan oleh objek `Path`.

  - **Path Creation:**

    - **Peran:** `Path` adalah objek yang merepresentasikan urutan operasi menggambar (bergerak ke titik, menggambar garis, kurva Bezier) yang kemudian dapat digambar sebagai satu kesatuan. Ini sangat kuat untuk membuat bentuk-bentuk yang tidak biasa atau kompleks.
    - **Mekanisme:** Anda membuat _instance_ `Path` dan kemudian memanggil metode seperti `moveTo()`, `lineTo()`, `arcTo()`, `cubicTo()`, `close()`. Setelah _path_ didefinisikan, Anda menggambarnya menggunakan `canvas.drawPath(path, paint)`.

  - **Paint Properties (`Paint`):**

    - **Peran:** Objek `Paint` mendefinisikan bagaimana bentuk atau objek akan digambar. Ini mengontrol warna, gaya goresan (fill/stroke), lebar goresan, efek bayangan, dan lainnya.
    - **Properti utama:**
      - `color`: Warna untuk menggambar.
      - `style`: `PaintingStyle.fill` (mengisi bentuk) atau `PaintingStyle.stroke` (menggambar garis tepi).
      - `strokeWidth`: Lebar garis tepi jika `style` adalah `stroke`.
      - `blendMode`: Bagaimana piksel yang digambar bercampur dengan piksel yang sudah ada.
      - `maskFilter`: Efek seperti _blur_.
      - `shader`: Untuk _gradient_ atau _image fills_.
      - `filterQuality`: Kualitas rendering (misalnya, `high`, `medium`).

  - **Clipping dan Masking:**

    - **Peran:** Membatasi area di mana gambar dapat muncul. Hanya bagian dari gambar yang berada di dalam area _clipping_ yang akan terlihat.
    - **Mekanisme:** `canvas.clipRect()`, `canvas.clipRRect()`, `canvas.clipPath()`. Operasi _clipping_ berlaku untuk semua operasi menggambar berikutnya pada _canvas_ hingga `save()`/`restore()` dipanggil.

  - **Performance Optimization (Custom Painter):**

    - **`shouldRepaint`:** Metode ini dari `CustomPainter` sangat penting. Kembalikan `false` jika _painter_ tidak perlu digambar ulang saat _widget_ `CustomPaint` direbuild (misalnya, jika semua properti gambar statis). Kembalikan `true` jika data yang digambar berubah.
    - **`addCallback` / `removeCallback`:** Jika `CustomPainter` Anda bergantung pada `Listenable` (misalnya, `AnimationController`), daftarkan _listener_ di konstruktor `CustomPainter` dan batalkan pendaftarannya di `dispose()` untuk memastikan _painter_ direpaint hanya saat diperlukan.
    - **Hindari perhitungan mahal di `paint`:** Lakukan perhitungan kompleks di luar metode `paint` dan berikan hasilnya sebagai properti ke _painter_. Metode `paint` harus secepat mungkin.
    - **Gunakan `CustomPaint` dengan `RepaintBoundary`:** Jika `CustomPaint` Anda sering berubah, pertimbangkan untuk membungkusnya dengan `RepaintBoundary` untuk mengisolasi _re-rendering_ ke bagian tersebut.

- **Advanced Custom Painting:**

  - **Gradient Painting (`Paint.shader`):**

    - **Peran:** Mengisi bentuk atau goresan dengan transisi warna yang mulus.
    - **Mekanisme:** Gunakan `LinearGradient`, `RadialGradient`, atau `SweepGradient` dari _package_ `dart:ui` (melalui `ui.Gradient.linear(...)`) dan atur sebagai `paint.shader`.

  - **Shadow Effects (`canvas.drawShadow`):**

    - **Peran:** Menambahkan efek bayangan pada bentuk untuk memberikan kedalaman.
    - **Mekanisme:** Gunakan `canvas.drawShadow(Path path, Color color, double elevation, bool transparentOccluder)`. Bayangan digambar di bawah _path_ yang diberikan.

  - **Text Painting (`TextPainter`):**

    - **Peran:** Menggambar teks dengan kontrol _layout_ dan gaya yang presisi di atas `Canvas`.
    - **Mekanisme:** Anda membuat _instance_ `TextPainter`, mengatur `textDirection`, `text` (`TextSpan`), `layout()` teks, dan kemudian memanggil `paint(canvas, offset)`.

  - **Image Painting (`canvas.drawImage`):**

    - **Peran:** Menggambar gambar bitmap (`ui.Image`) yang sudah dimuat ke `Canvas`.
    - **Mekanisme:** Gunakan `canvas.drawImage(ui.Image image, Offset offset, Paint paint)` atau `drawImageRect` untuk kontrol _cropping_ dan penskalaan. Anda perlu memuat gambar terlebih dahulu (misalnya, menggunakan `rootBundle` atau `NetworkImage` dan kemudian mengkonversinya ke `ui.Image`).

  - **Custom Shapes (dengan `Path`):**

    - **Peran:** Membuat bentuk-bentuk geometris arbitrer atau kompleks yang tidak tersedia sebagai _primitive_ dasar.
    - **Mekanisme:** Ini adalah penggunaan utama dari `Path` seperti yang dijelaskan sebelumnya, di mana Anda membangun urutan segmen garis dan kurva untuk membentuk bentuk apa pun yang Anda inginkan.

- **Contoh Kode (Custom Painter dengan Advanced Features):**

  ```dart
  import 'package:flutter/material.dart';
  import 'dart:ui' as ui; // Import untuk ui.Image, ui.Gradient

  void main() {
    runApp(const CustomPaintDemoApp());
  }

  class CustomPaintDemoApp extends StatelessWidget {
    const CustomPaintDemoApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Custom Painting Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          useMaterial3: true,
        ),
        home: const CustomPaintScreen(),
      );
    }
  }

  class CustomPaintScreen extends StatefulWidget {
    const CustomPaintScreen({super.key});

    @override
    State<CustomPaintScreen> createState() => _CustomPaintScreenState();
  }

  class _CustomPaintScreenState extends State<CustomPaintScreen> {
    ui.Image? _image;

    @override
    void initState() {
      super.initState();
      _loadImage();
    }

    // Fungsi untuk memuat gambar dari assets
    Future<void> _loadImage() async {
      final ByteData data = await DefaultAssetBundle.of(context).load('assets/images/flutter_logo.png'); // Pastikan path ini benar
      _image = await decodeImageFromList(data.buffer.asUint8List());
      setState(() {}); // Perbarui UI setelah gambar dimuat
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Custom Painting & Graphics'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Drawing Primitives & Path:'),
                CustomPaint(
                  size: const Size(300, 200),
                  painter: PrimitiveAndPathPainter(),
                ),
                const Divider(),
                const Text('Gradient & Shadow:'),
                CustomPaint(
                  size: const Size(300, 200),
                  painter: GradientAndShadowPainter(),
                ),
                const Divider(),
                const Text('Text & Image Painting:'),
                CustomPaint(
                  size: const Size(300, 250),
                  painter: TextAndImagePainter(image: _image),
                ),
                const Divider(),
                const Text('Clipping:'),
                CustomPaint(
                  size: const Size(300, 200),
                  painter: ClippingPainter(),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Catatan: Untuk contoh Image Painting, pastikan Anda memiliki berkas gambar (misalnya, `flutter_logo.png`) di folder `assets/images/` dan dideklarasikan di `pubspec.yaml`:\n\nflutter:\n  assets:\n    - assets/images/',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  // --- Contoh CustomPainter untuk berbagai fitur ---

  class PrimitiveAndPathPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
      final paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      // Menggambar Garis
      canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);

      // Menggambar Lingkaran
      paint.color = Colors.red;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);

      // Menggambar Persegi Panjang
      paint.color = Colors.green;
      paint.style = PaintingStyle.stroke;
      canvas.drawRect(Rect.fromLTWH(20, size.height - 70, 80, 60), paint);

      // Menggambar Path kustom (Segitiga)
      paint.color = Colors.purple;
      paint.style = PaintingStyle.fill;
      final Path trianglePath = Path()
        ..moveTo(size.width - 20, 20)
        ..lineTo(size.width - 80, 80)
        ..lineTo(size.width - 20, 80)
        ..close(); // Menutup path untuk membentuk segitiga tertutup
      canvas.drawPath(trianglePath, paint);
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  }

  class GradientAndShadowPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
      // Gradient Linear
      final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height / 2);
      final gradientPaint = Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomRight,
          [Colors.orange.shade200, Colors.deepOrange],
        );
      canvas.drawRect(rect, gradientPaint);

      // Gradient Radial
      final circleCenter = Offset(size.width / 2, size.height * 0.75);
      final radialPaint = Paint()
        ..shader = ui.Gradient.radial(
          circleCenter,
          size.width / 4,
          [Colors.yellow.shade200, Colors.brown],
          [0.0, 1.0],
        );
      canvas.drawCircle(circleCenter, size.width / 4, radialPaint);

      // Efek Bayangan
      final shadowPath = Path()
        ..addRect(Rect.fromLTWH(size.width * 0.2, size.height * 0.4, size.width * 0.6, size.height * 0.4));
      canvas.drawShadow(shadowPath, Colors.black.withOpacity(0.5), 10.0, false);

      // Gambar bentuk di atas bayangan
      final solidPaint = Paint()..color = Colors.lightGreen;
      canvas.drawRect(Rect.fromLTWH(size.width * 0.2, size.height * 0.4, size.width * 0.6, size.height * 0.4), solidPaint);
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  }

  class TextAndImagePainter extends CustomPainter {
    final ui.Image? image;

    TextAndImagePainter({this.image});

    @override
    void paint(Canvas canvas, Size size) {
      // Menggambar Teks
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'Hello Custom Painter!',
          style: TextStyle(
            color: Colors.blue.shade800,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr, // Penting untuk layout teks
      );
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, 20));

      // Menggambar Teks Multiline
      final multiLineTextPainter = TextPainter(
        text: TextSpan(
          text: 'Ini adalah contoh teks multi-baris yang digambar di kanvas.\n'
                'Anda bisa mengontrol posisi dan ukuran.',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      multiLineTextPainter.layout(minWidth: 0, maxWidth: size.width - 40); // Batasi lebar
      multiLineTextPainter.paint(canvas, Offset(20, textPainter.height + 40));


      // Menggambar Gambar (jika tersedia)
      if (image != null) {
        final srcRect = Rect.fromLTWH(0, 0, image!.width.toDouble(), image!.height.toDouble());
        final dstRect = Rect.fromLTWH(size.width / 4, size.height * 0.5, size.width / 2, size.height / 2); // Atur posisi dan ukuran gambar
        canvas.drawImageRect(image!, srcRect, dstRect, Paint());
      } else {
        // Tampilkan placeholder jika gambar belum dimuat
        final placeholderPaint = Paint()..color = Colors.grey.shade300;
        canvas.drawRect(Rect.fromLTWH(size.width / 4, size.height * 0.5, size.width / 2, size.height / 2), placeholderPaint);
        final loadingTextPainter = TextPainter(
          text: TextSpan(
            text: 'Loading Image...',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        );
        loadingTextPainter.layout(minWidth: 0, maxWidth: size.width);
        loadingTextPainter.paint(canvas, Offset(size.width / 2 - loadingTextPainter.width / 2, size.height * 0.5 + size.height / 4 - loadingTextPainter.height / 2));
      }
    }

    @override
    bool shouldRepaint(covariant TextAndImagePainter oldDelegate) {
      return oldDelegate.image != image; // Repaint jika gambar berubah
    }
  }

  class ClippingPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
      final paint = Paint()..color = Colors.blue;

      // Menggambar persegi panjang besar
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Colors.lightBlue.shade50);

      // Clip Rect: Hanya bagian ini yang terlihat
      canvas.save(); // Simpan state canvas sebelum clipping
      canvas.clipRect(Rect.fromLTWH(size.width * 0.2, size.height * 0.2, size.width * 0.6, size.height * 0.6));
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, paint..color = Colors.red); // Lingkaran ini akan terpotong
      canvas.restore(); // Kembalikan state canvas (hapus clipping)

      // Clip RRect: Memotong dengan sudut membulat
      canvas.save();
      canvas.clipRRect(BorderRadius.circular(20).toRRect(Rect.fromLTWH(size.width * 0.1, size.height * 0.7, size.width * 0.8, size.height * 0.2)));
      canvas.drawRect(Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.2), paint..color = Colors.green);
      canvas.restore();


      // Clip Path: Memotong dengan bentuk kustom
      canvas.save();
      final Path starPath = Path();
      starPath.moveTo(size.width * 0.5, size.height * 0.1); // Titik atas
      starPath.lineTo(size.width * 0.6, size.height * 0.3);
      starPath.lineTo(size.width * 0.8, size.height * 0.3);
      starPath.lineTo(size.width * 0.65, size.height * 0.5);
      starPath.lineTo(size.width * 0.7, size.height * 0.7);
      starPath.lineTo(size.width * 0.5, size.height * 0.6);
      starPath.lineTo(size.width * 0.3, size.height * 0.7);
      starPath.lineTo(size.width * 0.35, size.height * 0.5);
      starPath.lineTo(size.width * 0.2, size.height * 0.3);
      starPath.lineTo(size.width * 0.4, size.height * 0.3);
      starPath.close();

      canvas.clipPath(starPath);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint..color = Colors.purple.withOpacity(0.5));
      canvas.restore(); // Pastikan untuk mengembalikan state
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
  }
  ```

- **Visualisasi Konseptual: `CustomPainter` Flow**

  ```mermaid
  graph TD
      A[CustomPaint Widget] -- Panggil --> B[CustomPainter (Class)];
      B -- Implementasi --> C[paint(Canvas canvas, Size size)];
      C -- Gunakan --> D[Canvas API (drawX, clipY)];
      D -- Gunakan --> E[Paint Object (color, style, shader)];
      D -- Gunakan --> F[Path Object (moveTo, lineTo, close)];
      C -- Hasilnya --> G[Grafik Kustom pada Layar];
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan alur kerja `CustomPainter`. Anda menempatkan `CustomPaint` di pohon _widget_. `CustomPaint` kemudian memanggil metode `paint()` dari kelas `CustomPainter` yang Anda berikan. Di dalam metode `paint()`, Anda menggunakan `Canvas API` dan objek `Paint` serta `Path` untuk menggambar piksel demi piksel langsung ke kanvas, menghasilkan grafik kustom yang terlihat di layar.

---

###### **SVG Integration**

- **Peran:** SVG (_Scalable Vector Graphics_) adalah format gambar berbasis XML untuk grafik vektor 2D. Gambar SVG tidak kehilangan kualitas saat diperbesar atau diperkecil karena didefinisikan secara matematis, bukan piksel. Mengintegrasikan SVG sangat penting untuk ikon, ilustrasi, dan grafik lain yang perlu diskalakan dengan sempurna di berbagai resolusi layar.

- **SVG Asset Loading:**

  - **Mekanisme:**
    1.  **Tambahkan dependensi:** Di `pubspec.yaml`, tambahkan _package_ `flutter_svg`:
        ```yaml
        dependencies:
          flutter_svg: ^latest_version # Ganti dengan versi terbaru
        ```
    2.  **Tambahkan aset:** Letakkan berkas `.svg` Anda di folder aset (misalnya, `assets/svgs/`). Deklarasikan folder ini di `pubspec.yaml`.
    3.  **Muat SVG:** Gunakan `SvgPicture.asset()`, `SvgPicture.network()`, atau `SvgPicture.string()` untuk memuat dan menampilkan SVG.

- **SVG Customization:**

  - **Peran:** Anda dapat mengubah properti visual SVG saat _runtime_, seperti warna _fill_, warna _stroke_, atau ukuran, tanpa memodifikasi berkas SVG asli.
  - **Mekanisme:** Gunakan properti `color`, `width`, `height`, `fit`, `clipToViewBox`, `colorFilter`, atau `theme` pada _widget_ `SvgPicture`. Properti `colorFilter` sangat berguna untuk mengubah warna ikon SVG.

- **Path Parsing (Konseptual):**

  - **Peran:** Di balik layar, _package_ `flutter_svg` membaca kode XML dari berkas SVG dan mengurai perintah-perintah menggambar (seperti `M` untuk `moveTo`, `L` untuk `lineTo`, `C` untuk _cubic Bezier_) menjadi objek `Path` Flutter yang dapat digambar oleh `Canvas`.
  - **Detail:** Anda biasanya tidak perlu berinteraksi langsung dengan proses _parsing_ _path_ ini, tetapi penting untuk memahami bahwa SVG pada dasarnya adalah instruksi menggambar vektor yang kemudian diterjemahkan ke `Canvas API` Flutter.

- **Vector Icons:**

  - **Peran:** Menggunakan SVG sebagai pengganti _icon font_ atau _bitmap_ untuk ikon aplikasi Anda. Keuntungan utamanya adalah skalabilitas sempurna dan ukuran berkas yang kecil.
  - **Mekanisme:** Muat ikon SVG menggunakan `SvgPicture.asset()` di mana pun Anda membutuhkan ikon.

- **Contoh Kode (SVG Integration):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart'; // Import package flutter_svg

  void main() {
    runApp(const SvgIntegrationDemoApp());
  }

  class SvgIntegrationDemoApp extends StatelessWidget {
    const SvgIntegrationDemoApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'SVG Integration Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: const SvgScreen(),
      );
    }
  }

  class SvgScreen extends StatelessWidget {
    const SvgScreen({super.key});

    @override
    Widget build(BuildContext context) {
      // Path ke file SVG Anda (pastikan dideklarasikan di pubspec.yaml)
      final String assetName = 'assets/svgs/rocket.svg'; // Ganti dengan path ke file SVG Anda
      // Anda bisa mengunduh contoh SVG dari internet atau membuat sendiri.

      return Scaffold(
        appBar: AppBar(
          title: const Text('SVG Integration'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Original SVG Icon:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Memuat SVG asli
              SvgPicture.asset(
                assetName,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 30),
              const Text(
                'Customized SVG Icon (Color & Size):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Mengkustomisasi warna SVG
              SvgPicture.asset(
                assetName,
                width: 150,
                height: 150,
                colorFilter: const ColorFilter.mode(Colors.deepPurple, BlendMode.srcIn), // Mengubah warna SVG
              ),
              const SizedBox(height: 30),
              const Text(
                'SVG from Network (Example):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Contoh memuat SVG dari network (membutuhkan koneksi internet)
              // Pastikan URL SVG ini valid dan dapat diakses
              SvgPicture.network(
                'https://www.svgrepo.com/show/530664/leaf-bold.svg', // Contoh URL SVG
                width: 80,
                height: 80,
                colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(), // Placeholder saat memuat
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Catatan: Untuk menjalankan contoh ini, pastikan Anda menambahkan `flutter_svg` ke `pubspec.yaml` dan menempatkan berkas SVG (misalnya, `rocket.svg`) di folder `assets/svgs/` yang sudah dideklarasikan di `pubspec.yaml`.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Visualisasi Konseptual: SVG Workflow**

  ```mermaid
  graph TD
      A[Desainer Membuat SVG] -- Berkas .svg --> B[Proyek Flutter (Assets)];
      B -- Digunakan oleh Package flutter_svg --> C[SvgPicture.asset/network];
      C -- Render Sebagai --> D[Vektor Grafik yang Skalabel Sempurna];
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan alur kerja integrasi SVG. Desainer membuat berkas SVG, yang kemudian ditambahkan ke aset proyek Flutter. _Package_ `flutter_svg` membaca dan merender berkas ini, menghasilkan grafik vektor yang dapat diskalakan dengan sempurna di aplikasi Anda.

# Selamat!

Dengan ini, kita telah menyelesaikan seluruh **Fase 7: Styling, Theming & Responsive Design**!

Anda telah mempelajari dasar-dasar hingga teknik lanjutan dalam membuat aplikasi yang menarik secara visual, konsisten secara tema, dan adaptif untuk berbagai perangkat.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md
[pro7]: ../../pro/bagian-7/README.md

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
