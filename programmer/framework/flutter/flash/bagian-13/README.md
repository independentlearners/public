> [pro][flash13]

# **[FASE 13: Advanced Flutter Concepts][0]**

Ini akan membawa Anda ke pemahaman yang lebih dalam tentang internal Flutter dan teknik-teknik canggih. Anda akan belajar bagaimana Flutter merender _pixel_ di layar, cara berinteraksi dengan kode _native_ tingkat rendah, dan bagaimana mengotomatiskan pembuatan kode untuk efisiensi yang lebih besar.

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- **[20. Custom Rendering & Low-Level APIs](#20-custom-rendering--low-level-apis)**
  - [20.1 Render Objects](#201-render-objects)
    - Custom Render Objects
    - RenderObject lifecycle
    - Layout protocols
    - Painting protocols
    - Hit testing
    - Performance optimization
    - RenderObject Deep Dive
    - Custom RenderObject Tutorial
    - Multi-Child Layouts
    - RenderFlex implementation
    - Custom layout algorithms
    - Constraint propagation
    - Size negotiation
    - Custom Multi-Child Layouts
  - [20.2 Flutter Engine Integration](#202-flutter-engine-integration)
    - Embedder API
    - Custom embedder development
    - Platform-specific integration
    - Engine customization
    - Native view integration
    - Flutter Embedder API
    - Dart FFI Integration
    - Native library integration
    - C/C++ interop
    - Memory management
    - Performance considerations
    - Dart FFI
    - FFI Best Practices
- **[21. Code Generation & Metaprogramming](#21-code-generation--metaprogramming)**
  - [21.1 Build System](#211-build-system)
    - Build Runner
    - Custom builders
    - Code generation pipeline
    - Watch mode development
    - Build configuration
    - Performance optimization
    - Build Runner Guide
    - Custom Builder Development
    - Source Generation
    - Analyzer-based generation
    - Template-based generation
    - AST manipulation
    - Code formatting
    - Error handling
    - Source Gen Package
    - Analyzer Package
  - [21.2 Advanced Code Generation](#212-advanced-code-generation)
    - Macro System (Upcoming)
    - Macro definitions
    - Compile-time execution
    - AST transformation
    - Type introspection
    - Dart Macros Proposal
    - Reflection Alternatives
    - Compile-time reflection
    - Type introspection
    - Annotation processing
    - Metadata generation
    - Reflectable Package

</details>

---

### **20. Custom Rendering & Low-Level APIs**

- **Peran:** Bagian ini akan membawa Anda melampaui _widget_ yang sudah jadi dan menyelami bagaimana Flutter benar-benar menggambar _pixel_ di layar. Memahami _render object_ dan berinteraksi dengan API tingkat rendah akan memungkinkan Anda membuat efek visual yang sangat kustom dan mengoptimalkan kinerja pada tingkat fundamental.

---

#### **20.1 Render Objects**

- **Peran:** Di Flutter, _widget_ adalah deskripsi konfigurasi untuk bagian UI. Namun, _widget_ itu sendiri tidak melakukan _rendering_ apa pun. Pekerjaan _rendering_ sebenarnya dilakukan oleh **Render Objects**. _Render object_ adalah objek yang menangani _layout_ dan _painting_ dari elemen UI. Mereka membentuk pohon _render_ yang paralel dengan pohon _widget_, dan inilah yang sebenarnya berinteraksi dengan _Flutter engine_ untuk menggambar di layar.

- **Custom Render Objects:**

  - **Peran:** Membuat _render object_ Anda sendiri memungkinkan Anda untuk memiliki kontrol penuh atas bagaimana suatu elemen diukur (_layout_), ditempatkan, dan digambar (_painted_) di layar, serta bagaimana ia merespons _input_ (_hit testing_). Ini diperlukan untuk efek UI yang sangat unik yang tidak dapat dicapai dengan kombinasi _widget_ standar.
  - **Kapan Digunakan:**
    - Efek _layout_ yang kompleks (misalnya, _circular layout_, _overlapping elements_).
    - Efek _painting_ kustom (misalnya, _shader_ kustom, grafik khusus).
    - Interaksi sentuhan yang sangat spesifik.

- **RenderObject Lifecycle:**

  - **Mekanisme:** Mirip dengan _widget_, _render object_ juga memiliki siklus hidup yang meliputi:
    - **Creation:** Dibuat oleh `RenderObjectElement` (bagian internal dari pohon _element_).
    - **Attachment:** Dilampirkan ke pohon _render_.
    - **Layout:** Diberi _constraints_ oleh _parent_ dan menentukan ukurannya sendiri.
    - **Painting:** Menggambar diri sendiri ke _canvas_.
    - **Hit Testing:** Menentukan apakah titik tertentu (misalnya, sentuhan) berada di dalamnya.
    - **Detachment:** Dilepaskan dari pohon _render_.
    - **Disposal:** Dibuang dari memori.

- **Layout Protocols:**

  - **Peran:** _Render object_ berkomunikasi satu sama lain melalui _layout protocols_ untuk menentukan ukuran dan posisi. Setiap _render object_ diminta untuk menyediakan ukuran berdasarkan _constraints_ yang diberikan oleh _parent_-nya.
  - **Mekanisme:**
    - **`performLayout()`:** Metode di mana _render object_ menghitung ukurannya sendiri berdasarkan `constraints` yang diterimanya dari _parent_ dan menentukan posisi serta ukuran _child_-nya.
    - **`constraints`:** Batasan ukuran (min/max width/height) yang diberikan oleh _parent_ kepada _child_.

- **Painting Protocols:**

  - **Peran:** Setelah _layout_ selesai, _render object_ menggunakan _painting protocols_ untuk menggambar diri mereka sendiri ke _canvas_.
  - **Mekanisme:**
    - **`paint()`:** Metode di mana _render object_ menggambar representasi visualnya ke objek `Canvas` yang disediakan. Ini adalah tempat Anda menggunakan `Canvas` dan `Paint` untuk menggambar bentuk, teks, gambar, dll.

- **Hit Testing:**

  - **Peran:** Proses menentukan _render object_ mana yang berada di bawah titik tertentu di layar (misalnya, di mana pengguna menyentuh). Ini penting untuk menangani _input event_.
  - **Mekanisme:**
    - **`hitTest()`:** Metode yang diimplementasikan oleh _render object_ untuk menentukan apakah titik tertentu (dalam koordinat lokal) berada di dalam batasnya. Jika ya, ia akan terus melakukan _hit testing_ pada _child_-nya.

- **Performance Optimization:**

  - **Peran:** Memastikan _custom render object_ Anda bekerja dengan efisien dan tidak menyebabkan _jank_.
  - **Tips:**
    - **Minimalkan `performLayout()` dan `paint()`:** Kedua metode ini dipanggil sering. Hindari komputasi yang mahal di dalamnya.
    - **Gunakan `RepaintBoundary`:** Untuk _widget_ yang sering berubah tetapi tidak memengaruhi _layout_ di sekitarnya, `RepaintBoundary` dapat mengisolasi _repaint_ ke area tersebut.
    - **Hindari `saveLayer` yang berlebihan:** `saveLayer` bisa mahal karena melibatkan _offscreen buffer_. Gunakan hanya jika benar-benar diperlukan.
    - **_Caching_:** _Cache_ hasil komputasi mahal atau objek `Paint` jika memungkinkan.

- **Sumber Daya Tambahan:**

  - [RenderObject Deep Dive](https://medium.com/flutter/diving-deep-into-flutter-rendering-f8442d87e07a) (Artikel mendalam tentang Flutter Rendering)
  - [Custom RenderObject Tutorial](https://flutter.dev/docs/development/ui/advanced/render-objects) (Tutorial resmi tentang Custom RenderObject)

---

##### **Multi-Child Layouts**

- **Peran:** Dalam Flutter, _render object_ yang memiliki banyak _child_ (seperti `Row`, `Column`, `Stack`, `Flex`) memiliki logika _layout_ yang kompleks untuk memposisikan _child_-nya. Memahami bagaimana mereka bekerja memungkinkan Anda membuat algoritma _layout_ kustom sendiri untuk _widget_ yang memiliki banyak _child_.

- **RenderFlex Implementation:**

  - **Peran:** `RenderFlex` adalah _render object_ yang mendasari _widget_ `Row` dan `Column`. Mempelajari implementasinya memberikan wawasan tentang bagaimana Flutter menangani _layout_ fleksibel.
  - **Mekanisme:** `RenderFlex` mengimplementasikan `performLayout()` dengan logika untuk mendistribusikan ruang di antara _child_-nya berdasarkan `flex` dan `mainAxisAlignment`/`crossAxisAlignment`.

- **Custom Layout Algorithms:**

  - **Peran:** Membuat _render object_ kustom yang dapat mengatur posisi dan ukuran banyak _child_ dengan cara yang unik.
  - **Mekanisme:** Anda perlu mewarisi dari `RenderBox` (atau kelas _render object_ yang sesuai) dan mengimplementasikan metode `performLayout()`. Di dalamnya, Anda akan:
    1.  Mendapatkan _constraints_ dari _parent_.
    2.  Mengiterasi melalui _child_ Anda.
    3.  Mengukur setiap _child_ menggunakan `child.layout(constraints, parentUsesSize: true/false)`.
    4.  Menentukan `offset` (posisi) untuk setiap _child_.
    5.  Mengatur ukuran _render object_ Anda sendiri (`size = ...`).

- **Constraint Propagation:**

  - **Peran:** _Constraints_ adalah batasan ukuran (min/max width/height) yang diteruskan oleh _parent_ ke _child_ selama proses _layout_. Ini adalah salah satu konsep fundamental dalam sistem _layout_ Flutter.
  - **Mekanisme:** _Parent render object_ memberikan _constraints_ kepada setiap _child_-nya. _Child_ kemudian harus memilih ukurannya yang sesuai dengan _constraints_ tersebut. _Child_ tidak boleh mencoba melampaui _constraints_ ini.

- **Size Negotiation:**

  - **Peran:** Proses di mana _parent_ dan _child_ berinteraksi untuk menentukan ukuran akhir _render object_. _Parent_ memberikan _constraints_, dan _child_ mengembalikan ukurannya sendiri yang sesuai.
  - **Mekanisme:** Ini adalah alur satu arah: _parent_ memaksakan _constraints_, _child_ mematuhi dan melaporkan ukurannya. _Child_ tidak dapat meminta ukuran tertentu kepada _parent_ di luar _constraints_ yang diberikan.

- **Sumber Daya Tambahan:**

  - [Custom Multi-Child Layouts](https://flutter.dev/docs/development/ui/advanced/custom-layout) (Panduan resmi untuk membuat _multi-child layout_ kustom)

---

Dengan ini, kita telah menyelesaikan **20.1 Render Objects**, termasuk konsep _custom render object_ dan _multi-child layouts_. Anda kini memiliki pemahaman yang jauh lebih dalam tentang bagaimana Flutter merender visual di layar, membuka pintu untuk kustomisasi UI yang sangat canggih.

Selanjutnya, kita akan masuk ke **20.2 Flutter Engine Integration**, di mana kita akan menjelajahi bagaimana Flutter berinteraksi dengan sistem _native_ di tingkat yang lebih rendah.

---

### **20.2 Flutter Engine Integration**

- **Peran:** Bagian ini membahas bagaimana aplikasi Flutter berinteraksi dengan _Flutter Engine_ itu sendiri dan komponen _native_ dari _platform_ yang mendasarinya. Memahami integrasi ini penting untuk skenario lanjutan seperti kustomisasi _engine_, _embedding_ Flutter ke aplikasi _native_, atau berinteraksi dengan _library_ C/C++ menggunakan Dart FFI.

---

#### **Embedder API**

- **Peran:** **Flutter Embedder API** adalah antarmuka tingkat rendah yang memungkinkan Anda mengintegrasikan _Flutter engine_ ke dalam aplikasi _native_ yang sudah ada. Ini adalah bagaimana aplikasi Flutter "biasa" berjalan di perangkat, dengan _Flutter engine_ yang di-_embed_ ke dalam aplikasi host Android atau iOS. Namun, Anda juga bisa menggunakan API ini untuk _embedding_ Flutter di _platform_ atau lingkungan non-standar.

- **Custom Embedder Development:**

  - **Peran:** Membuat _embedder_ Anda sendiri berarti Anda menulis kode _native_ yang bertanggung jawab untuk menginisialisasi _Flutter engine_, menyediakan _surface_ untuk _rendering_ (misalnya, OpenGL/Vulkan _context_), menangani _input event_ (sentuhan, keyboard), dan memfasilitasi komunikasi antara Flutter dan _platform_ _native_.
  - **Kapan Digunakan:**
    - Membawa Flutter ke _platform_ baru yang tidak didukung secara resmi (misalnya, sistem _infotainment_ mobil, perangkat IoT).
    - Mengintegrasikan Flutter sebagai bagian UI dalam aplikasi _native_ yang sangat kompleks di mana _add-to-app_ bawaan tidak cukup.

- **Platform-specific Integration:**

  - **Peran:** Mengacu pada cara _Flutter engine_ berinteraksi dengan API spesifik _platform_ (Android SDK, iOS SDK). _Embedder_ yang disediakan Flutter (untuk Android, iOS, Windows, macOS, Linux) sudah menangani sebagian besar integrasi ini.
  - **Mekanisme:** Ini melibatkan penggunaan **Platform Channels** (sudah dibahas di fase awal) untuk komunikasi antara kode Dart dan kode _native_. _Embedder_ memastikan bahwa saluran ini berfungsi dan bahwa _event_ seperti siklus hidup aplikasi (_lifecycle events_) diteruskan dengan benar ke Flutter.

- **Engine Customization:**

  - **Peran:** Memodifikasi atau mengonfigurasi _Flutter engine_ itu sendiri untuk memenuhi kebutuhan spesifik, seperti mengubah _rendering pipeline_ atau mengoptimalkan untuk _hardware_ tertentu. Ini adalah level kustomisasi yang sangat mendalam dan jarang diperlukan untuk aplikasi standar.
  - **Mekanisme:** Membutuhkan membangun _Flutter engine_ dari sumber (_building the engine from source_) dan memodifikasi kodenya. Ini adalah tugas yang kompleks dan membutuhkan pemahaman C++.

- **Native View Integration:**

  - **Peran:** Menampilkan _native view_ (misalnya, Google Maps _native_, tampilan video _native_) di dalam pohon _widget_ Flutter. Ini diperlukan ketika _widget_ Flutter tidak dapat mereplikasi fungsionalitas _native_ secara efisien atau ketika Anda perlu menggunakan komponen UI _platform_ yang ada.
  - **Mekanisme:** Menggunakan _widget_ `PlatformView` (khusus AndroidView dan UiKitView untuk iOS). Ini memungkinkan Flutter untuk membuat _native view_ dan menempatkannya dalam pohon _rendering_ Flutter.

- **Sumber Daya Tambahan:**

  - [Flutter Embedder API](https://github.com/flutter/flutter/wiki/The-Flutter-Engine%23embedders) (Informasi tentang Flutter Embedder API di Wiki GitHub Flutter)

---

#### **Dart FFI Integration**

- **Peran:** **Dart Foreign Function Interface (FFI)** adalah mekanisme yang memungkinkan kode Dart untuk secara langsung memanggil fungsi yang diimplementasikan dalam _library_ C/C++ (_native libraries_) dan sebaliknya. Ini memungkinkan Anda untuk menggunakan kembali kode _native_ yang sudah ada, berinteraksi dengan API sistem tingkat rendah, atau memanfaatkan _library_ yang dioptimalkan untuk kinerja yang ditulis dalam C/C++.

- **Native Library Integration:**

  - **Peran:** Menghubungkan aplikasi Flutter Anda dengan _library_ C/C++ yang dikompilasi (_shared libraries_ seperti `.so` di Linux, `.dylib` di macOS, `.dll` di Windows).
  - **Mekanisme:**
    1.  **Muat Library:** Gunakan `DynamicLibrary.open()` untuk memuat _shared library_ _native_.
    2.  **Lookup Fungsi:** Gunakan `lookupFunction<NativeSignature, DartSignature>()` untuk mendapatkan Dart _function pointer_ ke fungsi C/C++ yang Anda butuhkan. `NativeSignature` adalah tanda tangan fungsi C, `DartSignature` adalah tanda tangan Dart yang sesuai.
    3.  **Panggil Fungsi:** Panggil fungsi yang dilookup seperti fungsi Dart biasa.

- **C/C++ Interop:**

  - **Peran:** Memfasilitasi komunikasi dua arah antara Dart dan C/C++. Ini termasuk melewatkan data, mengelola _pointer_, dan menangani tipe data yang berbeda.
  - **Mekanisme:** Dart FFI menyediakan tipe data `Pointer<T>` untuk bekerja dengan _pointer_ memori C. Anda dapat:
    - **Lewatkan data primitif:** Tipe seperti `int`, `double`, `bool` dapat dilewatkan secara langsung.
    - **Lewatkan _struct_:** Definisikan _struct_ C dalam Dart menggunakan `Struct` dan `@Packed`.
    - **Lewatkan _array_:** Gunakan `Pointer.asTypedList()` untuk mengonversi _pointer_ C ke `TypedData` Dart.
    - **Callback:** Kode C dapat memanggil kembali ke kode Dart menggunakan `Pointer.fromFunction()`.

- **Memory Management:**

  - **Peran:** Mengelola memori yang dialokasikan di sisi C/C++. Dart memiliki _garbage collector_ sendiri, tetapi memori yang dialokasikan oleh kode C harus dikelola secara manual atau menggunakan `Finalizer` yang lebih baru di Dart untuk membersihkan _resource native_.
  - **Mekanisme:**
    - **Manual Allocation/Deallocation:** Gunakan `malloc`, `free` dari _library_ C (melalui FFI) untuk alokasi/dealokasi manual. **Penting:** Pastikan setiap `malloc` ada `free` yang sesuai untuk mencegah _memory leak_.
    - **`calloc` / `realloc`:** Fungsi alokasi memori lainnya.
    - **`Finalizer`:** Fitur Dart yang memungkinkan Anda mendaftarkan _callback_ yang akan dijalankan ketika objek Dart tidak lagi dapat dijangkau oleh _garbage collector_, memungkinkan Anda untuk membersihkan _resource native_ terkait. Ini adalah cara yang lebih aman untuk mengelola siklus hidup memori _native_ dari Dart.

- **Performance Considerations:**

  - **Overhead Panggilan:** Meskipun FFI cepat, ada _overhead_ kecil untuk setiap panggilan antara Dart dan C. Untuk operasi yang sangat sering atau pendek, ini bisa terakumulasi.
  - **Batching:** Kelompokkan panggilan FFI jika memungkinkan untuk mengurangi _overhead_ panggilan individu.
  - **Data Copying:** Hindari penyalinan data yang tidak perlu antara Dart _heap_ dan memori C. Manfaatkan `Pointer` dan `TypedData` untuk bekerja langsung dengan _buffer_ memori.
  - **Thread Safety:** Pastikan _native library_ Anda aman untuk _thread_ jika dipanggil dari _isolate_ Dart yang berbeda atau jika ada panggilan asinkron.

- **Sumber Daya Tambahan:**

  - [Dart FFI](https://dart.dev/guides/libraries/c-interop) (Panduan resmi Dart FFI)
  - [FFI Best Practices](https://flutter.dev/docs/development/platform-integration/c-interop) (Praktik terbaik FFI di dokumentasi Flutter)

---

Anda kini memiliki gambaran tentang bagaimana Flutter bekerja di tingkat paling dasar, dari _rendering_ hingga interaksi dengan kode _native_. Ini adalah area yang kuat bagi mereka yang ingin mendorong batas kemampuan Flutter. Selanjutnya, kita akan masuk ke bagian terakhir yang akan membahas bagaimana mengotomatisasi lebih banyak proses pengembangan.

---

### **21. Code Generation & Metaprogramming**

- **Peran:** Bagian ini membahas bagaimana menggunakan _code generation_ di Dart dan Flutter untuk menulis kode secara otomatis. Ini adalah teknik yang sangat ampuh untuk mengurangi _boilerplate code_, menjaga konsistensi, dan memastikan kode selalu mutakhir, terutama untuk tugas-tugas berulang atau integrasi dengan _library_ pihak ketiga. _Metaprogramming_ mengacu pada kemampuan program untuk memperlakukan program lain (atau dirinya sendiri) sebagai datanya sendiri.

---

#### **21.1 Build System**

- **Peran:** Sistem _build_ Dart, yang berpusat pada _package_ `build_runner`, adalah fondasi untuk _code generation_. Ini mengelola bagaimana "builder" (generator kode) dijalankan untuk menghasilkan berkas kode baru berdasarkan berkas sumber Anda.

- **Build Runner:**

  - **Peran:** `build_runner` adalah _tool_ CLI (Command Line Interface) yang menjalankan "builder" secara efisien. Ia melacak berkas input, berkas output, dan hanya menjalankan ulang _builder_ yang diperlukan ketika berkas sumber berubah.
  - **Mekanisme:** Anda menjalankan `flutter pub run build_runner build` (untuk _single-pass build_) atau `flutter pub run build_runner watch` (untuk mode _watch_ yang terus-menerus membangun ulang saat berkas berubah). `build_runner` kemudian menemukan semua _builder_ yang didefinisikan dalam dependensi Anda (misalnya, `json_serializable`, `injectable_generator`) dan menjalankannya sesuai konfigurasi.
  - **Keunggulan:** Mengurangi waktu _build_, mengelola ketergantungan _builder_, dan menyediakan lingkungan yang terstandarisasi untuk _code generation_.

- **Custom Builders:**

  - **Peran:** Jika Anda memiliki kebutuhan _code generation_ yang sangat spesifik yang tidak dapat dipenuhi oleh _builder_ yang sudah ada, Anda dapat menulis _builder_ kustom Anda sendiri.
  - **Mekanisme:** Anda membuat _package_ Dart terpisah yang mendefinisikan kelas yang mengimplementasikan _interface_ `Builder` dari _package_ `build`. Di dalam _builder_ tersebut, Anda akan menulis logika untuk membaca berkas sumber (menggunakan `build_runner` API), menganalisisnya (seringkali dengan _package_ `analyzer`), dan menulis berkas output.

- **Code Generation Pipeline:**

  - **Peran:** Urutan _builder_ yang dijalankan `build_runner`. Beberapa _builder_ mungkin bergantung pada output dari _builder_ lain.
  - **Mekanisme:** Anda mengonfigurasi urutan _builder_ di berkas `build.yaml` di _root_ proyek Anda (meskipun seringkali _package_ _code gen_ sudah menyertakan konfigurasi _default_). Misalnya, _builder_ yang menghasilkan kode JSON _serialization_ mungkin berjalan sebelum _builder_ yang memerlukan model data yang sudah di-_generate_.

- **Watch Mode Development:**

  - **Peran:** Mode `build_runner` yang secara otomatis menjalankan ulang _builder_ setiap kali ada perubahan pada berkas sumber Anda. Ini sangat penting untuk alur kerja pengembangan yang efisien.
  - **Mekanisme:** Jalankan `flutter pub run build_runner watch`. _Build_runner_ akan terus memantau perubahan, dan hanya akan menjalankan _builder_ yang terpengaruh, mirip dengan _hot reload_ tetapi untuk _code generation_.

- **Build Configuration:**

  - **Peran:** Mengonfigurasi perilaku `build_runner` dan _builder_ individual.
  - **Mekanisme:** Dilakukan melalui berkas `build.yaml`. Anda dapat menentukan _input files_, _output directories_, _options_ khusus untuk _builder_, dan _builders_ mana yang harus diaktifkan.

- **Performance Optimization (Build Runner):**

  - **Tips:**
    - **`--delete-conflicting-outputs`:** Selalu gunakan _flag_ ini untuk membersihkan _output_ yang berpotensi konflik.
    - **Cache:** `build_runner` memiliki _cache_ internal; hindari menghapusnya secara manual kecuali ada masalah.
    - **Spesifikkan Target:** Jika Anda hanya perlu menjalankan _builder_ tertentu, Anda dapat menentukannya untuk mempercepat proses.
    - **Pilih `build_runner` versi stabil:** Pastikan Anda menggunakan versi _build_runner_ yang kompatibel dan stabil dengan _package code gen_ Anda.

- **Sumber Daya Tambahan:**

  - [Build Runner Guide](https://dart.dev/tools/build_runner) (Panduan resmi `build_runner`)
  - [Custom Builder Development](https://github.com/dart-lang/build/blob/master/docs/writing_a_builder.md) (Panduan untuk membuat _builder_ kustom)

---

#### **Source Generation**

- **Peran:** Proses sebenarnya dari membuat kode Dart baru berdasarkan analisis kode Dart yang sudah ada. Ini adalah inti dari apa yang dilakukan oleh _builder_ yang dijalankan oleh `build_runner`.

- **Analyzer-based Generation:**

  - **Peran:** Teknik _code generation_ di mana _builder_ menggunakan _package_ `analyzer` Dart untuk membaca dan memahami kode sumber Anda sebagai _Abstract Syntax Tree_ (AST). Ini memungkinkan _builder_ untuk secara cerdas menganalisis struktur kode (kelas, metode, anotasi, tipe) dan menghasilkan kode baru berdasarkan pemahaman tersebut.
  - **Mekanisme:** _Builder_ akan:
    1.  Membaca berkas sumber menggunakan _API_ dari `build` _package_.
    2.  Mengurai berkas tersebut menjadi AST menggunakan `analyzer`.
    3.  Mengunjungi simpul-simpul AST (misalnya, mencari kelas dengan anotasi tertentu).
    4.  Menulis kode baru berdasarkan informasi yang diekstraksi dari AST.
  - **Keunggulan:** Sangat kuat dan tepat karena beroperasi pada pemahaman sintaksis dan semantik kode yang dalam.

- **Template-based Generation:**

  - **Peran:** Teknik di mana _builder_ menggunakan _template_ (seringkali berkas teks dengan _placeholder_) untuk menghasilkan kode. Data yang akan mengisi _placeholder_ ini diambil dari berkas sumber.
  - **Mekanisme:** _Builder_ membaca data dari berkas sumber, kemudian menggunakan _template engine_ (misalnya, `mustache`, `jinja`) untuk mengisi _placeholder_ dalam _template_ dan menghasilkan kode.
  - **Keunggulan:** Lebih mudah diimplementasikan untuk kasus sederhana, dan _template_ dapat dibaca oleh manusia. Kurang kuat dari _analyzer-based_ jika logika sangat kompleks.

- **AST Manipulation:**

  - **Peran:** Secara langsung memodifikasi _Abstract Syntax Tree_ dari kode sumber. Meskipun _code generation_ umumnya berarti membuat berkas baru, konsep AST manipulation adalah dasar dari bagaimana _builder_ memahami kode yang ada.
  - **Mekanisme:** Melalui _package_ `analyzer`, Anda dapat mengakses dan menelusuri simpul-simpul AST untuk mendapatkan informasi tentang kode.

- **Code Formatting:**

  - **Peran:** Memastikan bahwa kode yang dihasilkan secara otomatis tetap konsisten dengan gaya format kode proyek Anda.
  - **Mekanisme:** Setelah kode dihasilkan, _builder_ seringkali memanggil _formatter_ Dart (`dart format`) pada berkas yang baru dibuat.

- **Error Handling (in Builders):**

  - **Peran:** Memberikan pesan _error_ yang jelas dan informatif ketika _builder_ gagal atau menemukan masalah dalam berkas sumber.
  - **Mekanisme:** _Builder_ harus menangkap _exception_ dan memberikan _feedback_ yang baik kepada pengembang, seringkali menunjuk ke baris kode sumber yang menyebabkan masalah.

- **Sumber Daya Tambahan:**

  - [Source Gen Package](https://pub.dev/packages/source_gen) (Pustaka yang mempermudah pembuatan _source generators_)
  - [Analyzer Package](https://pub.dev/packages/analyzer) (Pustaka Dart Analyzer)

---

#### **21.2 Advanced Code Generation**

- **Peran:** Bagian ini membahas tren dan konsep yang lebih maju dalam _code generation_ dan _metaprogramming_ di Dart, termasuk fitur yang akan datang dan alternatif untuk _reflection_.

- **Macro System (Upcoming):**

  - **Peran:** Sistem _macro_ adalah fitur yang sedang dalam pengembangan untuk Dart yang akan memungkinkan pengembang menulis _macro_ yang beroperasi pada _Abstract Syntax Tree_ (AST) selama _compile-time_. Ini memungkinkan transformasi kode yang sangat canggih dan _code generation_ yang lebih terintegrasi.
  - **Mekanisme (Konsep):**
    - **Macro Definitions:** Anda akan menulis fungsi Dart yang ditandai sebagai _macro_.
    - **Compile-time Execution:** _Macro_ akan dieksekusi oleh kompilator Dart sebelum kode di-_compile_ menjadi _bytecode_.
    - **AST Transformation:** _Macro_ akan menerima AST dari kode sumber sebagai _input_, memodifikasinya (menambahkan kelas, metode, anggota, dll.), dan mengembalikan AST yang dimodifikasi.
    - **Type Introspection:** _Macro_ akan memiliki akses ke informasi tipe yang lengkap pada _compile-time_, memungkinkan keputusan _generation_ kode yang sangat cerdas.
  - **Manfaat:** Mengurangi _boilerplate_ lebih jauh, memungkinkan _library_ untuk mengimplementasikan fungsionalitas kompleks dengan lebih sedikit kode, dan berpotensi menjadi alternatif yang lebih kuat daripada _build_runner_ untuk beberapa kasus penggunaan.

- **Sumber Daya Tambahan:**

  - [Dart Macros Proposal](https://www.google.com/search?q=https://github.com/dart-lang/language/blob/main/accepted/future-releases/macros/feature-specification.md) (Spesifikasi proposal Dart Macros)

- **Reflection Alternatives:**

  - **Peran:** _Reflection_ (kemampuan program untuk memeriksa atau memodifikasi strukturnya sendiri saat _runtime_) di Dart saat ini terbatas (hanya tersedia di Flutter Web dan mode _JIT_ non-prod). Untuk _native_ dan _AOT_ (_Ahead-of-Time_) _compiled_ Dart/Flutter, _reflection_ tidak didukung karena alasan ukuran dan kinerja _binary_. Oleh karena itu, _code generation_ sering digunakan sebagai alternatif.
  - **Mekanisme:**
    - **Compile-time Reflection:** Daripada memeriksa tipe dan anotasi saat _runtime_ (yang tidak didukung), _code generation_ memeriksa tipe dan anotasi saat _compile-time_ (menggunakan `analyzer`) dan menghasilkan kode yang sesuai. Kode yang dihasilkan inilah yang kemudian dieksekusi saat _runtime_.
    - **Type Introspection:** _Code generation_ menggunakan kemampuan _analyzer_ untuk melakukan _introspection_ tipe pada _compile-time_.
    - **Annotation Processing:** Anotasi digunakan untuk "memberi tahu" _builder_ tentang bagaimana kode harus dihasilkan. Misalnya, `@JsonSerializable()` memberi tahu `json_serializable` untuk membuat kode _serialization_ JSON.
    - **Metadata Generation:** _Builder_ dapat menghasilkan berkas dengan _metadata_ tentang kelas atau anggota, yang kemudian dapat diakses oleh kode aplikasi tanpa perlu _runtime reflection_.
  - **Contoh Pustaka:**
    - **`reflectable` package:** Sebuah _package_ yang mencoba mensimulasikan _reflection_ di Dart dengan menggunakan _code generation_. Anda menandai kelas atau anggota yang ingin Anda refleksikan, dan `reflectable` akan menghasilkan kode yang diperlukan untuk memungkinkan _introspection_ terbatas saat _runtime_. Ini adalah cara untuk mendapatkan sebagian besar manfaat _reflection_ tanpa _overhead_ penuhnya.

# Selamat!

Kita telah menyelesaikan seluruh **Fase 13: Advanced Flutter Concepts**!

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-12/README.md
[selanjutnya]: ../bagian-14/README.md
[flash13]: ../../pro/bagian-13/README.md

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
