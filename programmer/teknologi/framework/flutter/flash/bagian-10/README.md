> [flash][pro10]

# **[Fase 10: Performance & Optimization][0]**.

Fase ini akan membekali Anda dengan pengetahuan dan alat untuk membuat aplikasi Flutter Anda berjalan dengan mulus, cepat, dan efisien.

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- **[16. Performance Monitoring & Optimization](#16-performance-monitoring--optimization)**
  - [16.1 Performance Analysis](#161-performance-analysis)
    - Flutter DevTools Profiling
    - Performance tab usage
    - Widget rebuild analysis
    - Memory usage monitoring
    - Network profiling
    - CPU profiling
    - DevTools Performance
    - Performance Best Practices
    - Performance Profiling
    - Memory Management
    - Memory leak detection
    - Object lifecycle management
    - Image memory optimization
    - Garbage collection tuning
    - Memory profiling tools
    - Memory Management
    - Image Memory Optimization
  - [16.2 Build & Runtime Optimization](#162-build--runtime-optimization)
    - Build Optimization
    - Tree shaking configuration
    - Code splitting strategies
    - Asset optimization
    - Bundle size analysis
    - Obfuscation setup
    - Build Optimization
    - Flutter Build Modes
    - Runtime Performance
    - Widget rebuilding optimization
    - List performance (ListView.builder)
    - Image loading optimization
    - Animation performance
    - Shader compilation
    - ListView Performance
    - Image Performance
  - [16.3 Monitoring & Analytics](#163-monitoring--analytics)
    - Crash Reporting
    - Firebase Crashlytics
    - Sentry integration
    - Custom crash reporting
    - Error tracking strategies
    - Firebase Crashlytics
    - Sentry Flutter
    - Performance Analytics
    - Firebase Performance Monitoring
    - Custom metrics collection
    - User experience tracking
    - Performance benchmarking
    - Firebase Performance
    - Performance Monitoring

</details>

---

#### **16. Performance Monitoring & Optimization**

- **Peran:** Memantau dan mengoptimalkan kinerja aplikasi adalah proses berkelanjutan untuk memastikan bahwa aplikasi berjalan secepat dan seefisien mungkin, memberikan pengalaman pengguna yang responsif dan lancar. Ini melibatkan identifikasi _bottleneck_, pengurangan penggunaan sumber daya, dan peningkatan kecepatan eksekusi.

---

##### **16.1 Performance Analysis**

- **Peran:** Analisis kinerja adalah langkah pertama dalam mengoptimalkan aplikasi. Ini melibatkan penggunaan alat untuk mengidentifikasi area kode yang memakan waktu atau sumber daya paling banyak, seperti CPU, memori, atau jaringan.

---

###### **Flutter DevTools Profiling**

- **Peran:** Flutter DevTools adalah rangkaian alat kinerja dan _debugging_ yang komprehensif untuk aplikasi Flutter dan Dart. Ini adalah alat utama Anda untuk menganalisis kinerja aplikasi secara _real-time_ selama pengembangan.

- **Akses DevTools:**

  - Dari terminal saat aplikasi berjalan: Tekan `p` (untuk membuka DevTools di _browser_).
  - Dari VS Code atau Android Studio: Ada opsi langsung untuk membuka DevTools di bilah alat _debugging_.

- **Performance Tab Usage:**

  - **Mekanisme:** Tab "Performance" di DevTools adalah pusat untuk menganalisis kinerja _rendering_ UI aplikasi Anda.
  - **Fitur Utama:**
    - **FPS (Frames Per Second) graph:** Menampilkan grafik laju bingkai (frame rate) aplikasi Anda. Tujuan utamanya adalah menjaga FPS tetap stabil di 60 FPS (atau 120 FPS untuk perangkat dengan _refresh rate_ tinggi) untuk pengalaman visual yang mulus. Penurunan di bawah 60 FPS menunjukkan _jank_ (stuttering).
    - **CPU profiler:** Menunjukkan berapa banyak waktu CPU yang dihabiskan untuk berbagai bagian kode Anda.
    - **Flutter frame chart:** Visualisasi _timeline_ terperinci dari setiap bingkai, menunjukkan berapa banyak waktu yang dihabiskan untuk membangun (Build), tata letak (Layout), melukis (Paint), dan me-_raster_ (Raster) bingkai.
    - **GPU usage:** Informasi tentang penggunaan GPU.

- **Widget Rebuild Analysis:**

  - **Peran:** Mengidentifikasi _widget_ mana yang dibangun ulang (rebuilt) secara berlebihan. Membangun ulang _widget_ yang tidak perlu adalah penyebab umum masalah kinerja.
  - **Mekanisme di DevTools:**
    - **"Toggle Platform" Overlay:** Aktifkan "Highlight repaints" dan "Show slow animations" di menu _overlay_ Flutter (biasanya ikon petir di DevTools atau di bilah alat _debugging_ IDE).
    - **"Performance Overlay":** Aktifkan dari Flutter Inspector atau DevTools. Ini menampilkan dua grafik di atas aplikasi Anda: satu untuk waktu GPU dan satu lagi untuk waktu UI. Garis hijau menunjukkan bingkai yang render dalam 1/60 detik (\~16.67ms). Garis merah menunjukkan _jank_.
    - **"Widget Rebuilds" tab di Flutter Inspector:** Menunjukkan hitungan _rebuild_ untuk setiap _widget_ yang terlihat.
    - **"Track Widget Rebuilds" di Performance Tab:** Memungkinkan Anda merekam sesi dan melihat _rebuild_ per _widget_ secara rinci.

- **Memory Usage Monitoring:**

  - **Peran:** Memantau berapa banyak memori yang digunakan aplikasi Anda dan mengidentifikasi _memory leak_ atau penggunaan memori yang tidak efisien.
  - **Mekanisme di DevTools:** Tab "Memory". Ini menampilkan grafik penggunaan memori dari waktu ke waktu, dan Anda dapat mengambil _snapshot heap_ untuk menganalisis objek yang ada di memori.

- **Network Profiling:**

  - **Peran:** Menganalisis aktivitas jaringan aplikasi Anda, seperti permintaan HTTP, respons, dan latensi.
  - **Mekanisme di DevTools:** Tab "Network". Ini mencantumkan semua permintaan jaringan yang dibuat oleh aplikasi Anda, bersama dengan durasi, ukuran, dan statusnya.

- **CPU Profiling:**

  - **Peran:** Menentukan fungsi atau metode mana yang paling banyak menghabiskan waktu CPU. Ini membantu Anda menemukan _bottleneck_ komputasi.
  - **Mekanisme di DevTools:** Tab "CPU Profiler". Anda dapat merekam sesi dan melihat _call stack_ dan _flame chart_ yang menunjukkan waktu yang dihabiskan di berbagai fungsi.

- **Sumber Daya Tambahan:**

  - [DevTools Performance](https://docs.flutter.dev/tools/devtools/performance) (Dokumentasi resmi Flutter DevTools untuk tab Performance)
  - [Performance Best Practices](https://docs.flutter.dev/perf/rendering/best-practices) (Panduan praktik terbaik kinerja dari dokumentasi Flutter)
  - [Performance Profiling](https://docs.flutter.dev/perf/rendering/profile) (Panduan umum tentang profiling kinerja di Flutter)

---

###### **Memory Management**

- **Peran:** Manajemen memori adalah tentang mengelola alokasi dan dealokasi memori secara efisien untuk mencegah _memory leak_ dan memastikan aplikasi menggunakan sumber daya dengan bijak.

- **Memory Leak Detection:**

  - **Peran:** _Memory leak_ terjadi ketika aplikasi gagal melepaskan memori yang tidak lagi dibutuhkan, menyebabkan penggunaan memori terus meningkat seiring waktu, yang dapat menyebabkan aplikasi lambat atau _crash_.
  - **Mekanisme:**
    - Gunakan tab "Memory" di DevTools. Ambil beberapa _snapshot heap_ di titik-titik berbeda saat aplikasi berjalan (terutama setelah menavigasi ke dan dari layar yang sama berulang kali). Jika jumlah objek tertentu terus meningkat (misalnya, _widget state_, _controller_, _stream subscriptions_), itu mungkin indikasi _leak_.
    - Perhatikan _retained size_ objek—ini menunjukkan berapa banyak memori yang akan dibebaskan jika objek tersebut di-garbage collection.

- **Object Lifecycle Management:**

  - **Peran:** Memastikan bahwa objek yang tidak lagi diperlukan (misalnya, `StreamSubscription`, `AnimationController`, `TextEditingController`, _listener_) dibuang atau ditutup dengan benar saat _widget_ atau objek yang memegangnya dibuang.
  - **Praktik Terbaik:**
    - Selalu gunakan `dispose()` untuk objek yang memerlukan _cleanup_ di `StatefulWidget`.
    - Batalkan `StreamSubscription` di `dispose()`.
    - Buang `ChangeNotifier`, `AnimationController`, `TextEditingController`, dll., di `dispose()`.

- **Image Memory Optimization:**

  - **Peran:** Gambar seringkali merupakan salah satu konsumen memori terbesar dalam aplikasi. Mengoptimalkan penggunaan memori gambar sangat penting untuk kinerja.
  - **Mekanisme:**
    - **Resolusi Gambar yang Sesuai:** Muat gambar dalam resolusi yang sesuai dengan kebutuhan tampilan. Jangan memuat gambar 4K jika hanya akan ditampilkan dalam _thumbnail_ kecil.
    - **Format Gambar Efisien:** Gunakan format gambar yang efisien seperti WebP (jika didukung) atau JPEG untuk foto, dan PNG untuk grafis dengan transparansi.
    - **Caching Gambar:** Gunakan _widget_ `Image.network` atau pustaka penanganan gambar seperti `cached_network_image` yang menangani _caching_ memori dan disk secara otomatis.
    - **Placeholder dan Error Handling:** Tampilkan _placeholder_ saat gambar dimuat dan tangani _error_ pemuatan gambar untuk pengalaman pengguna yang lebih baik.

- **Garbage Collection Tuning:**

  - **Peran:** Dart menggunakan _garbage collection_ otomatis (Dart VM memiliki _generational garbage collector_). Meskipun Anda tidak dapat "menyetel" _garbage collector_ secara langsung seperti di beberapa bahasa lain, praktik pengkodean yang baik (misalnya, menghindari alokasi objek yang tidak perlu di _hot path_) akan membantu _garbage collector_ bekerja lebih efisien.
  - **Mekanisme:** Hindari membuat objek baru dalam _loop_ yang sering dipanggil atau dalam metode `build` _widget_ jika objek tersebut tidak berubah. Gunakan `const` _constructor_ jika memungkinkan.

- **Memory Profiling Tools:**

  - **Mekanisme:** Selain tab "Memory" di DevTools, alat _native_ seperti Android Studio Profiler (untuk Android) dan Xcode Instruments (untuk iOS) dapat memberikan pandangan yang lebih mendalam tentang penggunaan memori pada tingkat sistem operasi.

- **Sumber Daya Tambahan:**

  - [Memory Management](https://docs.flutter.dev/perf/memory) (Panduan manajemen memori di dokumentasi Flutter)
  - [Image Memory Optimization](https://flutter.dev/docs/cookbook/images/fading-in-images) (Contoh pemuatan gambar efisien, terkait dengan memori)

---

Dengan ini, kita telah menyelesaikan **16.1 Performance Analysis**, mencakup penggunaan Flutter DevTools dan aspek-aspek penting dari manajemen memori. Anda sekarang memiliki alat dan pemahaman dasar untuk mengidentifikasi dan menangani _bottleneck_ kinerja yang berkaitan dengan UI _rendering_ dan penggunaan memori.

Selanjutnya, kita akan masuk ke **16.2 Build & Runtime Optimization**, di mana kita akan menjelajahi teknik untuk mengoptimalkan ukuran aplikasi dan kinerja saat runtime.

Bagian ini akan membahas strategi untuk mengoptimalkan ukuran aplikasi Anda saat _build time_ dan meningkatkan kinerja saat aplikasi berjalan (_runtime_).

---

##### **16.2 Build & Runtime Optimization**

- **Peran:** Mengoptimalkan kinerja aplikasi melibatkan dua aspek utama: mengurangi ukuran aplikasi yang di-_deploy_ (_build optimization_) dan memastikan aplikasi berjalan dengan lancar dan responsif setelah diinstal (_runtime performance_). Keduanya berkontribusi pada pengalaman pengguna yang unggul.

---

###### **Build Optimization**

- **Peran:** _Build optimization_ adalah proses mengurangi ukuran berkas aplikasi yang dihasilkan (APK untuk Android, IPA untuk iOS) agar lebih cepat diunduh, diinstal, dan membutuhkan lebih sedikit ruang penyimpanan di perangkat pengguna. Ukuran aplikasi yang lebih kecil juga dapat meningkatkan tingkat konversi di toko aplikasi.

- **Tree Shaking Configuration:**

  - **Peran:** _Tree shaking_ adalah teknik optimasi _compiler_ yang menghilangkan kode mati (kode yang tidak pernah dipanggil atau direferensikan) dari _bundle_ akhir aplikasi. Ini sangat efektif dalam mengurangi ukuran aplikasi, terutama jika Anda menggunakan banyak _package_ atau pustaka yang hanya Anda gunakan sebagian kecil fungsinya.
  - **Mekanisme:** Dart dan Flutter secara otomatis melakukan _tree shaking_ selama _build_ rilis. Untuk memastikan _tree shaking_ bekerja optimal, hindari pola kode yang mencegah _compiler_ mengidentifikasi kode mati (misalnya, penggunaan refleksi yang berlebihan atau penggunaan `dart:mirrors` di _production_). Pastikan juga Anda selalu melakukan _build_ dalam mode _release_ (`flutter build apk --release` atau `flutter build appbundle --release`).

- **Code Splitting Strategies:**

  - **Peran:** Memecah _bundle_ kode aplikasi menjadi bagian-bagian yang lebih kecil yang dapat dimuat secara _lazy_ (hanya saat dibutuhkan). Ini sangat berguna untuk aplikasi besar dengan banyak fitur yang tidak digunakan secara bersamaan, mengurangi waktu _startup_ awal dan ukuran _bundle_ yang dimuat pertama kali.
  - **Mekanisme di Flutter:** Saat ini, Flutter tidak memiliki dukungan _built-in_ untuk _code splitting_ dinamis yang mirip dengan yang ditemukan di _framework_ web (misalnya, Webpack). Namun, ada pendekatan yang dapat membantu mencapai efek serupa:
    - **Memisahkan Modul/Fitur:** Mengatur fitur-fitur besar dalam _package_ atau modul terpisah dan hanya memasukkannya ke dalam _build_ tertentu jika fitur itu diaktifkan.
    - **Memisahkan Aplikasi Menjadi Beberapa Aplikasi Kecil (Micro-Apps):** Jika memungkinkan, pecah aplikasi monolitik menjadi beberapa aplikasi yang lebih kecil yang dapat diinstal secara terpisah atau dimuat melalui _dynamic feature modules_ (khusus Android) atau melalui integrasi _native_ yang lebih dalam.

- **Asset Optimization:**

  - **Peran:** Mengoptimalkan ukuran dan format aset (gambar, font, berkas suara, dll.) yang dibundel dengan aplikasi. Aset adalah salah satu penyumbang terbesar terhadap ukuran aplikasi.
  - **Mekanisme:**
    - **Kompresi Gambar:** Gunakan alat kompresi gambar (misalnya, TinyPNG, ImageOptim) untuk mengurangi ukuran berkas gambar tanpa kehilangan kualitas yang signifikan.
    - **Format Efisien:** Pilih format gambar yang tepat (WebP untuk gambar, SVG untuk ikon vektor).
    - **Hanya Sertakan Resolusi yang Dibutuhkan:** Jika Anda mendukung berbagai kepadatan layar, pastikan Anda hanya menyediakan aset untuk kepadatan yang benar-benar Anda targetkan, atau gunakan alat _build_ yang dapat mengoptimalkan ini.
    - **Font Subsetting:** Jika Anda menggunakan _custom font_, sertakan hanya _glyph_ yang benar-benar Anda gunakan untuk mengurangi ukuran font.

- **Bundle Size Analysis:**

  - **Peran:** Menganalisis komposisi ukuran _bundle_ aplikasi Anda untuk mengidentifikasi komponen mana yang paling berkontribusi terhadap ukuran total.
  - **Mekanisme:**
    - Jalankan `flutter build apk --release --analyze-size` atau `flutter build appbundle --release --analyze-size`.
    - Ini akan menghasilkan laporan yang menunjukkan ukuran setiap _library_, aset, dan bagian lain dari _bundle_ aplikasi Anda, membantu Anda mengidentifikasi area untuk optimasi.

- **Obfuscation Setup:**

  - **Peran:** Mengaburkan (obfuscating) kode sumber Anda agar sulit untuk di-_reverse engineer_. Ini juga dapat sedikit mengurangi ukuran berkas karena nama variabel dan fungsi dipersingkat.
  - **Mekanisme:**
    - Tambahkan _flag_ `--obfuscate` dan `--split-debug-info` saat melakukan _build_ rilis:
      ```bash
      flutter build appbundle --release --obfuscate --split-debug-info=<path_to_output_dir>
      ```
    - `split-debug-info` akan menghasilkan berkas simbol yang terpisah yang dibutuhkan untuk _de-obfuscate stack traces_ jika terjadi _crash_ di _production_. Ini sangat penting\!

- **Sumber Daya Tambahan:**

  - [Build Optimization](https://docs.flutter.dev/perf/app-size) (Panduan resmi Flutter tentang optimasi ukuran aplikasi)
  - [Flutter Build Modes](https://docs.flutter.dev/tools/build-modes) (Penjelasan tentang berbagai mode _build_ Flutter: debug, profile, release)

---

###### **Runtime Performance**

- **Peran:** _Runtime performance_ mengacu pada seberapa cepat dan lancar aplikasi Anda berjalan setelah diinstal di perangkat pengguna. Ini mencakup responsivitas UI, laju bingkai (FPS), kecepatan pemrosesan, dan efisiensi konsumsi daya.

- **Widget Rebuilding Optimization:**

  - **Peran:** Mengurangi jumlah _rebuild_ _widget_ yang tidak perlu adalah salah satu kunci utama untuk kinerja _runtime_ yang optimal. Setiap _rebuild_ dapat memakan waktu CPU dan GPU.
  - **Praktik Terbaik:**
    - **Gunakan `const` Constructors:** Jika _widget_ sepenuhnya statis dan tidak akan pernah berubah, gunakan `const` _constructor_. Ini memberi tahu Flutter bahwa _widget_ tersebut dapat digunakan kembali tanpa dibangun ulang.
    - **Pisahkan _Widget_ Besar:** Pecah _widget_ besar menjadi _widget_ yang lebih kecil dan lebih terfokus. Jika hanya sebagian kecil dari UI yang perlu berubah, hanya _widget_ kecil itu yang akan dibangun ulang, bukan seluruh pohon _widget_ yang lebih besar.
    - **`ChangeNotifier` dan `Consumer` (Provider):** Pastikan Anda hanya mendengarkan perubahan pada bagian data yang benar-benar dibutuhkan oleh _widget_ tertentu. Gunakan `Consumer<T>(builder: (context, value, child) => ...)` dan letakkan bagian UI yang tidak perlu dibangun ulang di dalam argumen `child` _Consumer_.
    - **`Selector` (Provider):** Gunakan `Selector` untuk hanya membangun ulang ketika bagian spesifik dari model berubah.
    - **`ValueListenableBuilder` dan `StreamBuilder`:** Gunakan _builder_ ini untuk hanya membangun ulang bagian UI yang bergantung pada `ValueListenable` atau `Stream` tertentu.
    - **`didUpdateWidget`:** Pahami kapan ini dipanggil dan bagaimana mengelola _state_ yang bergantung pada _properties_ _widget_ lama.

- **List Performance (ListView.builder):**

  - **Peran:** Mengoptimalkan kinerja daftar panjang, yang merupakan salah satu tantangan umum di aplikasi _mobile_.
  - **Mekanisme:**
    - **`ListView.builder`:** Selalu gunakan `ListView.builder` (atau `GridView.builder`, `CustomScrollView` dengan _slivers_) untuk daftar dengan jumlah item yang tidak diketahui atau sangat besar. Ini melakukan _lazy loading_ (membuat item hanya saat digulir ke tampilan), sangat menghemat memori dan kinerja.
    - **`itemExtent` atau `prototypeItem`:** Jika semua item memiliki tinggi yang sama, tentukan `itemExtent` atau `prototypeItem` di `ListView.builder`. Ini memungkinkan Flutter menghitung _scroll position_ dan tata letak secara lebih efisien tanpa harus mengukur setiap item.
    - **`addAutomaticKeepAlives: false` dan `addRepaintBoundaries: false`:** Pertimbangkan untuk menonaktifkan ini jika Anda mengelola _state_ dan _rendering_ dengan sangat hati-hati pada item daftar untuk menghindari _overhead_ yang tidak perlu, terutama untuk daftar yang sangat besar.

- **Image Loading Optimization:**

  - **Peran:** Memuat dan menampilkan gambar secara efisien untuk menghindari _jank_ dan penggunaan memori yang berlebihan.
  - **Mekanisme:**
    - **`cached_network_image`:** Gunakan _package_ ini untuk gambar jaringan. Ia akan menyimpan gambar di memori dan disk, mencegah pengunduhan dan pemrosesan ulang yang berulang.
    - **_Image Caching_:** Pahami cara kerja _image caching_ di Flutter. Gambar yang dimuat dari aset atau jaringan akan di-_cache_ di memori.
    - **Ukuran Gambar yang Benar:** Muat gambar dari aset dengan resolusi yang tepat untuk _device pixel ratio_ perangkat.
    - **Placeholder dan Fading:** Gunakan _placeholder_ dan efek _fade-in_ saat memuat gambar untuk pengalaman pengguna yang lebih baik.

- **Animation Performance:**

  - **Peran:** Memastikan animasi berjalan dengan mulus pada 60 (atau 120) FPS tanpa _jank_.
  - **Mekanisme:**
    - **Gunakan _Implicit Animations_ (`AnimatedContainer`, `AnimatedOpacity`):** Ini seringkali lebih sederhana dan dioptimalkan oleh Flutter.
    - **`AnimatedBuilder`:** Untuk animasi yang lebih kompleks, gunakan `AnimatedBuilder` untuk memisahkan _rendering_ animasi dari bagian _widget tree_ yang tidak perlu dibangun ulang.
    - **`Transform.translate`, `Transform.scale`, `Transform.rotate`:** Preferensi untuk animasi _transform_ karena tidak menyebabkan _repaint_ yang mahal.
    - **Hindari `ClipRRect` atau `Opacity` yang berlebihan:** Penggunaan `ClipRRect` atau `Opacity` yang berlapis-lapis pada setiap bingkai animasi dapat memicu `saveLayer` di GPU, yang bisa mahal.
    - **`RepaintBoundary`:** Dapat digunakan untuk mengisolasi area _rendering_ yang sering berubah, membatasi _repaint_ ke area tersebut.

- **Shader Compilation:**

  - **Peran:** _Shader_ adalah program kecil yang berjalan di GPU untuk merender grafis. Kompilasi _shader_ bisa menyebabkan _jank_ saat pertama kali _shader_ dibutuhkan.
  - **Mekanisme:** Flutter telah membuat kemajuan signifikan dalam mengurangi _jank_ kompilasi _shader_. Untuk aplikasi rilis, Flutter akan mengompilasi _shader_ yang paling sering digunakan sebelumnya. Namun, jika Anda melihat _jank_ awal, itu bisa terkait dengan _shader_.
  - **Prasyarat:** Pastikan Anda menggunakan Flutter versi terbaru.

- **Sumber Daya Tambahan:**

  - [ListView Performance](https://docs.flutter.dev/perf/rendering/best-practices%23using-listviewbuilder) (Panduan kinerja `ListView.builder`)
  - [Image Performance](https://docs.flutter.dev/perf/images) (Panduan optimasi gambar di dokumentasi Flutter)

---

Dengan ini, kita telah menyelesaikan **16.2 Build & Runtime Optimization**. Anda sekarang memiliki pemahaman yang kuat tentang bagaimana mengoptimalkan ukuran aplikasi Anda dan memastikan kinerja yang lancar saat aplikasi berjalan.

Selanjutnya, kita akan masuk ke bagian terakhir dari Fase 10: **16.3 Monitoring & Analytics**, di mana kita akan membahas alat dan strategi untuk memantau kinerja aplikasi dan _crash_ di _production_.

##### **16.3 Monitoring & Analytics**

- **Peran:** Monitoring dan analitik adalah praktik krusial dalam siklus hidup aplikasi. Ini melibatkan pengumpulan data tentang bagaimana aplikasi berperilaku di lingkungan _production_, termasuk _crash_, _error_, kinerja, dan perilaku pengguna. Data ini sangat berharga untuk mengidentifikasi masalah, memahami _bottleneck_, dan membuat keputusan berbasis data untuk peningkatan di masa mendatang.

---

###### **Crash Reporting**

- **Peran:** _Crash reporting_ adalah proses otomatis menangkap informasi ketika aplikasi mengalami _crash_ atau _error_ yang tidak tertangani. Laporan ini kemudian dikirimkan ke layanan terpusat agar pengembang dapat meninjau, mendiagnosis, dan memperbaiki masalah. Ini sangat penting untuk menjaga stabilitas aplikasi dan pengalaman pengguna yang baik.

- **Firebase Crashlytics:**

  - **Peran:** Layanan _crash reporting_ yang kuat dari Google Firebase. Ini secara otomatis mengumpulkan _crash report_ dari aplikasi Anda, mengelompokkannya, dan menyediakan _stack trace_ yang dapat dibaca, prioritas, dan konteks untuk membantu Anda mendiagnosis masalah.
  - **Mekanisme:**

    1.  **Setup Proyek Firebase:** Pastikan proyek Flutter Anda terhubung dengan Firebase.
    2.  **Tambahkan Dependensi:** Tambahkan `firebase_crashlytics` ke `pubspec.yaml`.
    3.  **Inisialisasi:** Inisialisasi Crashlytics di awal aplikasi Anda (biasanya di `main()`):

        ```dart
        import 'package:firebase_core/firebase_core.dart';
        import 'package:firebase_crashlytics/firebase_crashlytics.dart';
        import 'package:flutter/foundation.dart'; // Untuk kDebugMode

        void main() async {
          WidgetsFlutterBinding.ensureInitialized();
          await Firebase.initializeApp();

          // Tangkap semua error Flutter yang tidak tertangani
          FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

          // Tangkap semua error Dart yang tidak tertangani
          PlatformDispatcher.instance.onError = (error, stack) {
            FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
            return true;
          };

          runApp(const MyApp());
        }
        ```

    4.  **Menambahkan Konteks:** Anda dapat menambahkan kunci kustom, log, atau ID pengguna untuk memberikan konteks tambahan pada _crash report_.
        ```dart
        FirebaseCrashlytics.instance.setCustomKey('user_id', 'user123');
        FirebaseCrashlytics.instance.log('User navigated to home screen');
        ```
    5.  **Simulasi _Crash_:** Untuk menguji, Anda bisa memicu _crash_ secara sengaja:
        ```dart
        ElevatedButton(
          onPressed: () {
            FirebaseCrashlytics.instance.crash(); // Memaksa crash
          },
          child: const Text('Simulate Crash'),
        )
        ```
        Atau memicu error yang tidak tertangkap:
        ```dart
        throw Exception('This is a test non-fatal error!');
        ```
        Untuk error yang tidak fatal (non-fatal error):
        ```dart
        try {
          // ... kode yang mungkin gagal
        } catch (e, s) {
          FirebaseCrashlytics.instance.recordError(e, s, fatal: false);
        }
        ```

- **Sentry Integration:**

  - **Peran:** Sentry adalah _platform_ pemantauan kesalahan _open-source_ dan _proprietary_ yang kuat yang mendukung berbagai bahasa dan _framework_, termasuk Flutter. Ini menawarkan pelacakan kesalahan _real-time_, peringatan, dan alat _debugging_.
  - **Mekanisme:**

    1.  **Daftar Akun Sentry:** Buat proyek di Sentry.io untuk mendapatkan DSN (Data Source Name) Anda.
    2.  **Tambahkan Dependensi:** Tambahkan `sentry_flutter` ke `pubspec.yaml`.
    3.  **Inisialisasi:** Bungkus `runApp` Anda dengan `SentryFlutter.init`:

        ```dart
        import 'package:sentry_flutter/sentry_flutter.dart';

        Future<void> main() async {
          await SentryFlutter.init(
            (options) {
              options.dsn = 'YOUR_SENTRY_DSN'; // Ganti dengan DSN Anda
              // Set sampling rate for performance monitoring to 100% when in debug mode.
              options.tracesSampleRate = 1.0;
              // ... opsi konfigurasi lainnya
            },
            appRunner: () => runApp(const MyApp()),
          );
        }
        ```

    4.  **Menangkap Kesalahan:** Sentry secara otomatis menangkap sebagian besar kesalahan. Anda juga dapat menangkapnya secara manual:
        ```dart
        try {
          throw Exception('Ini adalah kesalahan Sentry yang disengaja!');
        } catch (exception, stackTrace) {
          await Sentry.captureException(exception, stackTrace: stackTrace);
        }
        ```

- **Custom Crash Reporting:**

  - **Peran:** Meskipun layanan pihak ketiga sangat nyaman, ada kalanya Anda mungkin ingin membangun solusi _crash reporting_ kustom, terutama untuk kebutuhan privasi yang sangat ketat atau integrasi dengan sistem _backend_ yang ada.
  - **Mekanisme:** Melibatkan penggunaan `FlutterError.onError` dan `PlatformDispatcher.instance.onError` untuk menangkap kesalahan, kemudian mengirim _stack trace_ dan data konteks lainnya ke _endpoint_ _backend_ Anda sendiri.

- **Error Tracking Strategies:**

  - **Prioritisasi:** Fokus pada _crash_ yang paling sering terjadi atau yang memengaruhi pengguna paling banyak.
  - **Reproduksi:** Berusaha mereproduksi _crash_ di lingkungan pengembangan.
  - **Konteks:** Pastikan laporan _crash_ menyertakan informasi yang cukup (versi OS, versi aplikasi, ID pengguna, jejak langkah, dll.).
  - **Peringatan:** Siapkan peringatan untuk _crash_ yang tiba-tiba meningkat atau _crash_ baru yang penting.
  - **Integrasi:** Integrasikan _crash reporting_ dengan sistem pelacakan masalah (misalnya, Jira, GitHub Issues).

- **Sumber Daya Tambahan:**

  - [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics/get-started?platform=flutter) (Dokumentasi resmi Firebase Crashlytics untuk Flutter)
  - [Sentry Flutter](https://docs.sentry.io/platforms/flutter/) (Dokumentasi resmi Sentry untuk Flutter)

---

###### **Performance Analytics**

- **Peran:** _Performance analytics_ adalah proses mengumpulkan dan menganalisis metrik kinerja aplikasi dari pengguna nyata di lingkungan _production_. Berbeda dengan _profiling_ (yang dilakukan di lingkungan pengembangan), analitik kinerja memberikan pandangan dunia nyata tentang bagaimana aplikasi Anda berfungsi untuk basis pengguna Anda.

- **Firebase Performance Monitoring:**

  - **Peran:** Layanan dari Firebase yang membantu Anda mendapatkan wawasan tentang kinerja aplikasi Anda secara _real-time_ di lingkungan _production_. Ini secara otomatis mengumpulkan metrik untuk latensi _startup_ aplikasi, permintaan jaringan, dan permintaan HTTP/S.
  - **Mekanisme:**

    1.  **Setup Proyek Firebase:** Seperti Crashlytics, pastikan Firebase terintegrasi.
    2.  **Tambahkan Dependensi:** Tambahkan `firebase_performance` ke `pubspec.yaml`.
    3.  **Inisialisasi:** Tidak ada inisialisasi eksplisit yang diperlukan di kode Dart, karena Firebase Performance Monitoring terintegrasi langsung dengan SDK _native_ Firebase setelah _setup_ awal (baik Android maupun iOS).
    4.  **Pelacakan Otomatis:** Secara otomatis melacak:
        - **Durasi _Startup_ Aplikasi:** Waktu yang dibutuhkan aplikasi untuk memulai.
        - **Permintaan Jaringan:** Waktu respons, ukuran _payload_ untuk permintaan HTTP/S.
        - **Aktivitas Layar:** Waktu yang dihabiskan di setiap layar (tersedia di beberapa _platform_).
    5.  **Metrik Kustom (_Custom Traces_):** Anda dapat mendefinisikan _trace_ kustom untuk mengukur durasi atau metrik kustom lainnya untuk bagian spesifik kode Anda.

        ```dart
        import 'package:firebase_performance/firebase_performance.dart';

        Future<void> _doSomethingExpensive() async {
          final trace = FirebasePerformance.instance.newTrace('doSomethingExpensiveTrace');
          await trace.start(); // Mulai melacak durasi

          // ... lakukan operasi yang memakan waktu ...
          await Future.delayed(const Duration(seconds: 2));

          trace.incrementMetric('item_processed', 1); // Tambahkan metrik kustom
          await trace.stop(); // Hentikan pelacakan
        }
        ```

- **Custom Metrics Collection:**

  - **Peran:** Mengumpulkan metrik kinerja yang spesifik untuk logika bisnis atau fitur aplikasi Anda yang tidak dicakup oleh alat standar.
  - **Mekanisme:** Gunakan `Stopwatch` di Dart untuk mengukur durasi operasi, kemudian kirim data ini ke layanan analitik Anda (misalnya, Firebase Analytics, Google Analytics, atau _backend_ kustom Anda).

- **User Experience Tracking:**

  - **Peran:** Memahami bagaimana pengguna berinteraksi dengan aplikasi, termasuk alur navigasi, fitur yang sering digunakan, dan titik-titik friksi. Meskipun bukan metrik "kinerja" secara langsung, ini memengaruhi persepsi pengguna terhadap kinerja.
  - **Mekanisme:** Gunakan alat analitik umum seperti Firebase Analytics, Google Analytics, atau Mixpanel untuk melacak _event_ pengguna, layar yang dilihat, dan demografi pengguna.

- **Performance Benchmarking:**

  - **Peran:** Mengukur kinerja aplikasi Anda di bawah kondisi terkontrol untuk membandingkan hasil seiring waktu atau antara versi yang berbeda.
  - **Mekanisme:** Ini bisa melibatkan penulisan tes integrasi khusus yang mengukur _frame rate_ atau waktu eksekusi untuk alur tertentu, dan menjalankannya secara teratur di lingkungan CI. _Package_ `flutter_test` memiliki dukungan untuk _benchmarking_ melalui `tester.traceAction()`.

- **Sumber Daya Tambahan:**

  - [Firebase Performance](https://firebase.google.com/docs/perf-mon/get-started%3Fplatform%3Dflutter) (Dokumentasi resmi Firebase Performance Monitoring untuk Flutter)
  - [Performance Monitoring](https://docs.flutter.dev/perf/rendering/tools) (Gambaran umum alat pemantauan kinerja di dokumentasi Flutter)

# Selamat!

Dengan ini, kita telah menyelesaikan seluruh **Fase 10: Performance & Optimization**!

Anda sekarang memiliki pemahaman yang komprehensif tentang bagaimana menganalisis, mengoptimalkan, dan memantau kinerja aplikasi Flutter Anda dari pengembangan hingga _production_. Ini adalah keterampilan yang sangat berharga untuk membangun aplikasi yang sukses.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md
[pro10]: ../../pro/bagian-10/README.md

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
