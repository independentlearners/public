# [FASE 10: Performance & Optimization][0]

Pada fase ini, kita akan fokus pada bagaimana mengidentifikasi, menganalisis, dan mengatasi masalah kinerja dalam aplikasi Flutter Anda, untuk memastikan aplikasi berjalan cepat, lancar, dan responsif. Ini adalah aspek krusial untuk pengalaman pengguna yang baik.

**Kita akan memulai dengan topik pertama dalam fase ini:**

### 16. Performance Monitoring & Optimization

#### 16.1 Performance Analysis

- **Flutter DevTools Overview:**
  - Pengenalan DevTools sebagai suite alat untuk _debugging_ dan _profiling_.
  - Cara mengakses dan menavigasi antar bagian DevTools (Inspector, Performance, CPU Profiler, Memory, Debugger, Network, etc.).
- **Widget Inspector:**
  - Memahami _widget tree_ dan _render tree_.
  - Menganalisis tata letak dan _render objects_.
  - Mengidentifikasi _widget_ yang di-_rebuild_ secara tidak perlu (misalnya dengan "Repaint Rainbows" atau "Slow Animations" di DevTools).
  - Menggunakan _layout explorer_ untuk _debugging_ tata letak.
- **Performance Overlay:**
  - Memahami grafis rasterisasi (GPU) dan _build_ (CPU).
  - Mengidentifikasi _jank_ (stuttering) dan frame drop.
  - Analisis _frame rate_ (FPS) dan waktu _build/raster_.
- **Performance View:**
  - Menganalisis _timeline_ aplikasi: _frames per second_ (FPS), waktu _build_, waktu _raster_, dan penggunaan CPU/GPU.
  - Mengidentifikasi _bottlenecks_ kinerja dengan melihat aktivitas _thread_ UI dan _thread_ GPU.
  - _Tracing_ _custom events_ untuk mengukur performa kode tertentu.

---

**1. Flutter DevTools Overview:**

- **Pengenalan DevTools sebagai _suite_ alat untuk _debugging_ dan _profiling_:**
  - Flutter DevTools adalah serangkaian alat _debugging_ dan _profiling_ yang kaya fitur dan terintegrasi langsung dengan Flutter SDK. DevTools membantu Anda memahami dan mengoptimalkan kinerja aplikasi, men-debug masalah tata letak, menganalisis penggunaan memori, dan banyak lagi.
  - Ini adalah "Swiss Army Knife" untuk pengembang Flutter, menyediakan visibilitas yang belum pernah ada sebelumnya ke internal aplikasi Anda.
- **Cara mengakses dan menavigasi antar bagian DevTools:**
  - **Melalui VS Code:**
    1.  Jalankan aplikasi Flutter Anda di _emulator_ atau perangkat fisik.
    2.  Klik ikon "Debug Console" (ikon serangga) di bilah samping kiri.
    3.  Di panel "Debug Console", cari dan klik tautan "Open DevTools" atau "Dart DevTools".
  - **Melalui Android Studio/IntelliJ IDEA:**
    1.  Jalankan aplikasi Flutter Anda.
    2.  Di panel "Run" atau "Debug", cari ikon DevTools (biasanya ikon palu/obeng atau logo Flutter dengan tanda panah).
    3.  Klik ikon tersebut untuk membuka DevTools di _browser_.
  - **Melalui Command Line (CLI):**
    1.  Pastikan aplikasi Flutter Anda berjalan (`flutter run`).
    2.  Di terminal lain, jalankan `flutter pub global activate devtools` (jika belum terinstal).
    3.  Kemudian jalankan `devtools`. Ini akan membuka DevTools di _browser_ Anda dan secara otomatis mencoba terhubung ke aplikasi Flutter yang sedang berjalan. Jika ada beberapa aplikasi, Anda mungkin perlu memilihnya.
  - **Antarmuka DevTools:** Setelah terbuka, Anda akan melihat beberapa tab di bagian atas:
    - **Inspector:** Untuk memeriksa _widget tree_ dan _render tree_.
    - **Performance:** Untuk menganalisis _frame rendering_, _timeline event_, dan _bottlenecks_.
    - **CPU Profiler:** Untuk menganalisis penggunaan CPU oleh kode Dart Anda.
    - **Memory:** Untuk melacak alokasi dan penggunaan memori.
    - **Debugger:** Untuk _debugging_ kode Dart.
    - **Network:** Untuk memantau panggilan jaringan.
    - **Logs:** Untuk melihat _output_ konsol.
    - **App Size:** Untuk menganalisis ukuran _bundle_ aplikasi.

**2. Widget Inspector:**

- **Memahami _widget tree_ dan _render tree_:**
  - _Widget Inspector_ adalah alat visual yang memungkinkan Anda menjelajahi struktur UI aplikasi Anda secara _runtime_.
  - Anda dapat memilih _widget_ di layar perangkat Anda, dan Inspector akan menampilkan lokasinya di _widget tree_ dan _render tree_.
  - **Widget Tree:** Representasi hierarkis dari semua _widget_ yang membentuk UI Anda.
  - **Render Tree:** Representasi objek-objek yang sebenarnya bertanggung jawab untuk melukis UI di layar. _RenderObject_ adalah representasi tata letak dan _painting_ dari sebuah _widget_.
- **Menganalisis tata letak dan _render objects_:**
  - Anda dapat melihat properti tata letak (_constraints_ dan _size_) dari setiap _RenderObject_ yang dipilih, membantu Anda memahami mengapa _widget_ memiliki ukuran atau posisi tertentu.
  - Ini sangat berguna untuk men-debug masalah tata letak seperti _overflow_, _widget_ yang tidak muncul, atau _widget_ yang memiliki ukuran tidak terduga.
- **Mengidentifikasi _widget_ yang di-_rebuild_ secara tidak perlu (misalnya dengan "Repaint Rainbows" atau "Slow Animations" di DevTools):**
  - **"Repaint Rainbows" (Pernah disebut "Show Repaints"):** Fitur ini, ketika diaktifkan (biasanya di _setting_ Inspector), akan menampilkan kotak berwarna pelangi di sekitar _widget_ setiap kali di-_repaint_. Jika Anda melihat _widget_ yang terus-menerus berubah warna padahal seharusnya statis, itu menandakan _repaint_ yang tidak perlu dan potensi masalah performa.
  - **"Highlight Oversized Images":** Menyoroti gambar yang ukurannya lebih besar dari yang dibutuhkan oleh tata letak, menunjukkan pemborosan memori dan potensi _lag_.
  - **"Show Slow Animations":** Mengidentifikasi animasi yang berjalan di bawah 60 FPS (atau 120 FPS untuk perangkat yang mendukungnya) dengan menampilkan peringatan visual.
  - Mengurangi _rebuild_ yang tidak perlu adalah salah satu kunci optimasi kinerja Flutter. Ingat kembali konsep `const` _constructor_, `Equatable`, `BlocBuilder`/`Selector`, dan `ref.watch().select()` yang telah kita bahas di manajemen _state_.
- **Menggunakan _layout explorer_ untuk _debugging_ tata letak:**
  - Ketika Anda memilih _widget_ tata letak seperti `Row`, `Column`, atau `Stack`, _layout explorer_ di Inspector akan menampilkan representasi visual dari bagaimana _widget_ tersebut mengatur anak-anaknya.
  - Anda dapat memanipulasi properti seperti `mainAxisAlignment`, `crossAxisAlignment`, `mainAxisSize`, dan melihat perubahan tata letak secara _real-time_, membantu Anda memahami dan memperbaiki masalah tata letak yang kompleks.

**3. Performance Overlay:**

- **Memahami grafis rasterisasi (GPU) dan _build_ (CPU):**
  - _Performance Overlay_ adalah grafis yang muncul di atas aplikasi Anda (diaktifkan dari DevTools atau `debugShowPerformanceOverlay: true` di `MaterialApp`).
  - Ia menampilkan dua grafik utama:
    - **Grafik Kiri (UI Thread / Build):** Mengukur waktu yang dibutuhkan _thread_ UI untuk membangun _frame_ (yaitu, menjalankan metode `build` _widget_ Anda, menghitung tata letak, dll.). Jika grafik ini tinggi atau bergejolak, itu menunjukkan _bottleneck_ di CPU Anda.
    - **Grafik Kanan (Raster Thread / GPU):** Mengukur waktu yang dibutuhkan _thread_ Raster (GPU) untuk meraster _frame_ (yaitu, mengubah _render objects_ menjadi piksel di layar). Jika grafik ini tinggi, itu menunjukkan _bottleneck_ di GPU atau _rendering_ yang terlalu kompleks.
  - Idealnya, kedua grafik harus berada di bawah garis 16ms (untuk 60 FPS) atau 8ms (untuk 120 FPS) dan tetap datar.
- **Mengidentifikasi _jank_ (stuttering) dan _frame drop_:**
  - **Jank:** Terjadi ketika aplikasi tidak dapat me-render _frame_ dalam waktu yang dibutuhkan (misalnya, 1/60 detik untuk 60 FPS), menyebabkan UI terlihat tersendat-sendat atau tidak mulus.
  - _Performance Overlay_ secara visual menunjukkan _jank_ dengan lonjakan pada grafik. Setiap kali grafik melewati batas 16ms/8ms, Anda mengalami _jank_ atau _frame drop_.
- **Analisis _frame rate_ (FPS) dan waktu _build/raster_:**
  - Anda akan dapat melihat FPS rata-rata secara kasar dari seberapa sering grafik di-update dan seberapa mulus animasinya.
  - Angka di sebelah kanan setiap grafik menunjukkan waktu dalam milidetik yang dibutuhkan untuk _build_ dan _raster_.

**4. Performance View (di DevTools):**

- **Menganalisis _timeline_ aplikasi: _frames per second_ (FPS), waktu _build_, waktu _raster_, dan penggunaan CPU/GPU:**
  - Tab "Performance" di DevTools memberikan tampilan yang lebih rinci dan interaktif daripada _Performance Overlay_.
  - Anda dapat merekam sesi _profiling_ saat Anda berinteraksi dengan aplikasi.
  - **Frame Chart:** Menampilkan daftar _frame_ yang di-render, dengan visualisasi waktu _build_ dan _raster_ untuk setiap _frame_. Anda dapat mengklik _frame_ individu untuk analisis yang lebih dalam.
  - **CPU Usage:** Menunjukkan penggunaan CPU oleh _thread_ UI dan _thread_ GPU seiring waktu.
- **Mengidentifikasi _bottlenecks_ kinerja dengan melihat aktivitas _thread_ UI dan _thread_ GPU:**
  - Ketika Anda memilih sebuah _frame_ yang "jank" di _Frame Chart_, Anda dapat melihat detail aktivitas di _thread_ UI dan _thread_ GPU untuk _frame_ tersebut.
  - **UI Thread:** Jika Anda melihat banyak waktu yang dihabiskan untuk metode `build` atau perhitungan tata letak, itu menunjukkan bahwa logika UI Anda terlalu mahal atau ada _rebuild_ yang tidak perlu.
  - **Raster Thread (GPU):** Jika waktu di sini tinggi, itu berarti GPU Anda kesulitan me-render _scene_. Ini bisa disebabkan oleh _widget_ yang sangat kompleks, terlalu banyak efek visual (bayangan, _blur_), atau gambar beresolusi tinggi yang tidak di-_cache_ dengan baik.
- **_Tracing_ _custom events_ untuk mengukur performa kode tertentu:**
  - Anda dapat menambahkan _event_ _tracing_ kustom ke kode Dart Anda menggunakan `Timeline.startSync()` dan `Timeline.finishSync()` dari `dart:developer`.
  - Ini memungkinkan Anda untuk mengukur secara presisi berapa lama waktu yang dibutuhkan oleh blok kode tertentu, dan data ini akan muncul di _timeline_ "Performance" DevTools, membantu Anda menargetkan optimasi dengan lebih akurat.

---

Dengan memahami dan menggunakan alat-alat ini, Anda akan dapat secara sistematis menemukan dan memperbaiki masalah kinerja dalam aplikasi Flutter Anda, yang merupakan keterampilan penting untuk membangun aplikasi yang _polished_ dan berkinerja tinggi.

#### 16.2 Common Performance Bottlenecks

Bagian ini akan mengidentifikasi penyebab umum masalah kinerja pada aplikasi Flutter. Memahami _bottleneck_ ini sangat penting untuk mengetahui di mana harus fokus upaya optimasi Anda.

- **Terlalu Banyak _Rebuild_ Widget yang Tidak Perlu:**

  - **Deskripsi:** Ini adalah salah satu penyebab paling sering dari _jank_ dan _performance issue_. Terjadi ketika sebuah _widget_ di-_rebuild_ (metode `build()`-nya dipanggil) padahal tidak ada perubahan pada _state_ atau properti yang mempengaruhi tampilannya.
  - **Mengapa Terjadi:**
    - Menggunakan `setState()` pada `StatefulWidget` di level atas _widget tree_ yang memicu _rebuild_ seluruh sub-tree-nya.
    - Membangun _widget_ baru di dalam metode `build()` _widget_ lain tanpa menggunakan `const` _constructor_ atau meng-_cache_ _widget_ tersebut.
    - Tidak mengoptimalkan _consumer_ _state management_ (misalnya, `Provider.of(context)`, `BlocBuilder`, `ref.watch()`) untuk hanya mendengarkan bagian _state_ yang relevan, atau tidak menggunakan `Selector`/`.select()`.
  - **Dampak:** Memboroskan siklus CPU, terutama untuk _widget tree_ yang kompleks, menyebabkan _frame drop_.
  - **Cara Mengidentifikasi (menggunakan DevTools):**
    - **"Repaint Rainbows"** di Widget Inspector: Jika sebuah area berkedip dengan warna-warni pelangi padahal tidak ada perubahan visual, itu berarti terjadi _repaint_ yang tidak perlu.
    - **Performance View:** Cari lonjakan waktu di _UI Thread_ untuk _frame_ tertentu. Jika waktu _build_ tinggi, selidiki _widget_ apa yang memakan banyak waktu.

- **Pembaruan State yang Tidak Efisien:**

  - **Deskripsi:** Berkaitan erat dengan _rebuild_ yang tidak perlu, ini adalah ketika perubahan _state_ memicu perhitungan atau pemrosesan yang berat secara berulang.
  - **Mengapa Terjadi:**
    - Logika komputasi berat yang dieksekusi langsung di dalam metode `build()`.
    - Perbandingan objek _state_ yang tidak efisien (misalnya, objek `List` atau `Map` yang selalu dianggap berbeda meskipun isinya sama, jika tidak menggunakan `Equatable` atau perbandingan yang benar).
    - Terlalu sering memicu perubahan _state_ (misalnya, di dalam _callback_ `onChanged` pada `TextField` untuk setiap karakter tanpa _debouncing_).
  - **Dampak:** Membebani CPU, menyebabkan _jank_.
  - **Cara Mengidentifikasi (menggunakan DevTools):**
    - **CPU Profiler:** Rekam sesi _profiling_ dan cari fungsi-fungsi yang memakan persentase waktu CPU yang tinggi. Perhatikan tumpukan panggilan untuk melihat dari mana pemborosan berasal (misalnya, dari metode `build` atau _setter_ _state_).
    - **Performance View:** Lonjakan pada _UI thread_ menunjukkan aktivitas komputasi yang tinggi.

- **Operasi I/O (Input/Output) pada UI Thread:**

  - **Deskripsi:** Melakukan operasi yang memakan waktu (seperti panggilan jaringan, membaca/menulis file, akses database) langsung pada _UI thread_.
  - **Mengapa Terjadi:** Kode sinkron yang memblokir _thread_ utama saat menunggu respons I/O.
  - **Dampak:** Memblokir _UI thread_ dari me-render _frame_ baru, menyebabkan aplikasi "membeku" atau _jank_ yang parah.
  - **Cara Mengidentifikasi (menggunakan DevTools):**
    - **Performance Overlay:** Lonjakan tinggi pada grafik _UI thread_ yang diikuti oleh jeda panjang di mana tidak ada pembaruan UI.
    - **Performance View:** Akan terlihat jeda waktu yang signifikan pada _UI thread_ dengan _frame_ yang terlewat. Jika Anda merekam _CPU Profile_, Anda akan melihat bahwa _thread_ UI menunggu operasi I/O.
    - **Network View:** Untuk panggilan jaringan, Anda bisa melihat durasi panggilan dan apakah itu menyebabkan hambatan.

- **Gambar & Aset yang Tidak Dioptimalkan:**

  - **Deskripsi:** Menggunakan gambar dengan resolusi yang terlalu tinggi, tidak mengoptimalkan format gambar, atau tidak mengelola _cache_ gambar dengan baik.
  - **Mengapa Terjadi:**
    - Memuat gambar yang jauh lebih besar dari ukuran tampilannya di layar.
    - Tidak mengompresi gambar atau menggunakan format yang tidak efisien (misalnya, PNG besar untuk foto).
    - Tidak membersihkan _cache_ gambar yang tidak lagi diperlukan.
  - **Dampak:** Konsumsi memori yang tinggi (Out Of Memory - OOM), _jank_ saat memuat gambar, dan _asset bundle_ aplikasi yang besar.
  - **Cara Mengidentifikasi (menggunakan DevTools):**
    - **Widget Inspector:** Aktifkan "Highlight Oversized Images" untuk melihat gambar yang dirender pada resolusi lebih rendah dari aslinya.
    - **Memory View:** Pantau penggunaan memori. Jika penggunaan memori melonjak tajam saat memuat banyak gambar, itu bisa jadi indikasi.
    - **Performance View:** Perhatikan lonjakan di _raster thread_ saat gambar dimuat atau di-_scroll_ (terutama jika ada banyak gambar).

- **Struktur Pohon Widget yang Sangat Dalam/Kompleks:**

  - **Deskripsi:** Membuat _widget tree_ yang sangat dalam dan berlapis-lapis (`deep nesting`).
  - **Mengapa Terjadi:** Seringkali akibat terlalu banyak membungkus _widget_ tanpa alasan yang jelas, atau _over-engineering_ tata letak.
  - **Dampak:** Setiap _widget_ memiliki biaya _overhead_ kecil untuk _layout_ dan _render_. _Tree_ yang sangat dalam dapat meningkatkan waktu _build_ dan _layout_, terutama jika ada banyak _rebuild_.
  - **Cara Mengidentifikasi (menggunakan DevTools):**
    - **Widget Inspector:** Periksa kedalaman _widget tree_ Anda. Jika Anda melihat banyak lapisan `Container`, `Padding`, atau `SizedBox` yang berlapis-lapis tanpa alasan yang jelas, itu bisa menjadi sinyal.
    - **Performance View:** Waktu _build_ yang tinggi, meskipun _rebuild_ tidak terlalu sering, bisa mengindikasikan kompleksitas _layout_ yang tinggi.

- **Penggunaan `Opacity` yang Berlebihan:**

  - **Deskripsi:** Menerapkan `Opacity` (atau `FadeInImage`, `AnimatedOpacity`) ke _widget_ yang besar atau sering berubah.
  - **Mengapa Terjadi:** `Opacity` pada dasarnya membutuhkan lapisan _rendering_ terpisah (offscreen buffer) untuk menerapkan transparansi, yang bisa mahal, terutama jika konten di dalamnya sering diubah atau dianimasikan.
  - **Dampak:** Meningkatkan beban pada _GPU thread_ (raster thread), menyebabkan _jank_.
  - **Cara Mengidentifikasi (menggunakan DevTools):**
    - **Performance Overlay:** Lonjakan tinggi pada grafik _Raster thread_.
    - **Performance View:** Lihat aktivitas di _Raster thread_ dan cari operasi yang terkait dengan _compositing_ atau _layer management_.

- **List Scrolling Performance:**
  - **Deskripsi:** Masalah kinerja yang sering terjadi saat menggulir daftar panjang atau kompleks.
  - **Mengapa Terjadi:**
    - _Widget_ di dalam daftar terlalu kompleks atau terlalu banyak _rebuild_ per item.
    - Tidak menggunakan _lazy loading_ untuk daftar yang panjang (`ListView.builder`, `GridView.builder`).
    - Menggunakan `shrinkWrap: true` tanpa batas yang jelas pada `ListView` atau `GridView` di dalam `Column`/`Row` (menyebabkan _parent_ mencoba meng-_render_ semua item sekaligus).
    - Gambar yang tidak di-_cache_ atau dimuat secara efisien saat di-_scroll_.
  - **Dampak:** _Jank_ saat _scrolling_, UI terasa lambat.
  - **Cara Mengidentifikasi (menggunakan DevTools):**
    - **Performance Overlay:** Perhatikan lonjakan _jank_ yang konsisten saat melakukan _scrolling_.
    - **Performance View:** Analisis _frames_ selama _scrolling_ untuk melihat di mana waktu dihabiskan (UI atau Raster).
    - **CPU Profiler:** Cari fungsi-fungsi terkait _build_ atau _layout_ yang dipanggil berulang kali saat _scrolling_.

---

Memahami _bottleneck_ umum ini adalah langkah pertama dan paling krusial dalam optimasi. Di bagian selanjutnya, kita akan membahas strategi dan teknik konkret untuk mengatasi masalah-masalah ini.

#### 16.3 Optimization Techniques

Setelah mengidentifikasi _bottleneck_, langkah selanjutnya adalah menerapkan strategi dan teknik untuk mengoptimalkan kinerja aplikasi Anda.

- **Minimizing Widget Rebuilds:**

  - **Menggunakan `const` Constructor:**
    - **Deskripsi:** `const` _constructor_ menandakan bahwa sebuah _widget_ atau objek adalah _immutable_ (tidak akan berubah setelah dibuat) dan dapat di-_compile time_ di-_cache_.
    - **Implementasi:** Tambahkan `const` sebelum deklarasi _widget_ atau objek (misalnya, `const Text('Hello')`, `const SizedBox(height: 10)`).
    - **Manfaat:** Jika Flutter melihat _widget_ dengan `const` _constructor_ yang sama (dengan argumen yang sama) di _build_ berikutnya, ia tidak perlu me-_rebuild_ _widget_ tersebut. Ini sangat efisien.
    - **Kapan Digunakan:** Gunakan `const` kapan pun memungkinkan untuk _widget_ yang tidak akan berubah.
  - **Pemisahan Widget yang Berubah dari yang Tidak Berubah:**
    - **Deskripsi:** Identifikasi bagian mana dari UI yang sering berubah dan pisahkan menjadi _widget_ terpisah dengan _scope_ yang lebih kecil.
    - **Implementasi:** Daripada memanggil `setState()` pada `StatefulWidget` yang besar, pisahkan bagian yang berubah menjadi `StatefulWidget` anak yang lebih kecil. Pastikan _widget_ anak tersebut hanya di-_rebuild_ saat _state_ internalnya atau properti yang diteruskan berubah.
    - **Manfaat:** Meminimalkan area _rebuild_ pada _widget tree_, sehingga hanya bagian yang relevan saja yang dibangun ulang.
  - **`Consumer`/`Selector` di Provider/BLoC dan `ref.watch().select()` di Riverpod:**
    - **Deskripsi:** Teknik-teknik ini memungkinkan Anda untuk hanya me-_rebuild_ bagian UI yang benar-benar bergantung pada perubahan _state_ tertentu.
    - **Implementasi:**
      - **`package:provider`:** Gunakan `Consumer<MyData>(builder: (context, data, child) => ...)` atau `Selector<MyData, MyProperty>(selector: (context, data) => data.myProperty, builder: (context, myProperty, child) => ...)`.
      - **`flutter_bloc`:** Gunakan `BlocBuilder<MyBloc, MyState>(builder: (context, state) => ...)` dengan `buildWhen` _callback_ opsional, atau `BlocSelector<MyBloc, MyState, MyProperty>(selector: (state) => state.myProperty, builder: (context, myProperty) => ...)`.
      - **Riverpod:** Gunakan `ref.watch(myProvider.select((data) => data.myProperty))` untuk hanya mendengarkan perubahan pada properti `myProperty`.
    - **Manfaat:** Ini adalah kunci untuk _fine-grained reactivity_, memastikan _widget_ hanya di-_rebuild_ ketika data yang benar-benar mereka gunakan berubah.

- **Asynchronous Operations:**

  - **Menggunakan `async`/`await` dengan benar (tidak memblokir UI Thread):**
    - **Deskripsi:** Pastikan semua operasi I/O atau komputasi berat dijalankan secara _asynchronous_ untuk mencegah pemblokiran _UI Thread_.
    - **Implementasi:** Gunakan `async`/`await` untuk panggilan API, pembacaan file, operasi database, dan komputasi yang memakan waktu.
    - **Manfaat:** Memastikan _UI Thread_ tetap bebas untuk me-render _frame_, menjaga aplikasi tetap responsif.
  - **Isolates untuk Komputasi Berat:**
    - **Deskripsi:** Untuk komputasi yang sangat intensif dan tidak dapat ditangani oleh `async`/`await` saja (karena masih berjalan di _thread_ utama), gunakan Isolates. Isolates adalah _thread_ independen yang tidak berbagi memori, sehingga aman untuk menjalankan operasi yang memblokir tanpa mempengaruhi _UI Thread_.
    - **Implementasi:** Gunakan fungsi `compute` dari `flutter/foundation.dart` untuk _simple background tasks_ atau bangun Isolates secara manual untuk skenario yang lebih kompleks.
    - **Manfaat:** Mencegah _jank_ parah akibat komputasi berat.

- **Asset Optimization (Images, Fonts, etc.):**

  - **Optimasi Gambar (Resolusi, Format, Kompresi):**
    - **Resolusi:** Sajikan gambar dengan resolusi yang sesuai untuk tampilan di perangkat. Jangan memuat gambar 4K jika hanya akan ditampilkan dalam ukuran thumbnail. Gunakan _tool_ seperti `Image.asset(..., cacheWidth: ..., cacheHeight: ...)` atau `Image.network(..., cacheWidth: ..., cacheHeight: ...)` untuk menginstruksikan Flutter men-decode gambar ke ukuran yang lebih sesuai.
    - **Format:** Gunakan format gambar yang efisien. JPEG untuk foto, PNG untuk gambar dengan transparansi. Pertimbangkan format modern seperti WebP atau AVIF untuk kompresi yang lebih baik.
    - **Kompresi:** Kompresi gambar sebelum dimasukkan ke _asset bundle_ aplikasi Anda untuk mengurangi ukuran aplikasi dan waktu pemuatan.
  - **Lazy Loading Aset:**
    - **Deskripsi:** Muat aset (terutama gambar atau font kustom) hanya ketika dibutuhkan, bukan sekaligus di awal.
    - **Implementasi:**
      - Untuk daftar gambar, gunakan `FadeInImage` atau `CachedNetworkImage` (`package:cached_network_image`) untuk memuat secara _lazy_ dan meng-_cache_.
      - Pastikan `ListView.builder` atau `GridView.builder` digunakan untuk daftar panjang agar _widget_ dirender hanya saat masuk ke _viewport_.
      - Untuk font kustom, gunakan `loadFont` di `FontLoader` jika Anda ingin mengontrol kapan font dimuat.
  - **Caching Aset (terutama gambar dari jaringan):**
    - **Deskripsi:** Simpan aset yang diunduh (terutama gambar) secara lokal untuk menghindari pengunduhan ulang.
    - **Implementasi:** Gunakan _package_ seperti `cached_network_image` untuk _automatic caching_ gambar jaringan, atau implementasikan strategi _caching_ kustom untuk aset lain.
    - **Manfaat:** Mengurangi penggunaan bandwidth, mempercepat waktu pemuatan, dan meningkatkan pengalaman _offline_.

- **List Scrolling Performance:**

  - **Menggunakan `ListView.builder`, `GridView.builder`, `CustomScrollView`:**
    - **Deskripsi:** Ini adalah kunci untuk performa _scrolling_ yang baik. Mereka hanya membangun _widget_ yang terlihat di _viewport_ dan mendaur ulang yang sudah tidak terlihat.
    - **Implementasi:** Selalu gunakan `.builder` _constructor_ untuk daftar yang panjang.
    - **Hindari `shrinkWrap: true` tanpa `primary: false` atau batasan tinggi:** Jika `ListView.builder` berada di dalam `Column` tanpa tinggi yang dibatasi dan Anda menggunakan `shrinkWrap: true`, daftar akan mencoba me-render semua item sekaligus, membatalkan tujuan _builder_. Gunakan `Expanded` atau `SizedBox` untuk memberikan batasan tinggi, atau set `primary: false` jika `ListView` tidak menjadi _scrollable_ utama.
  - **`itemExtent` untuk Item List dengan Tinggi Konstan:**
    - **Deskripsi:** Memberi tahu `ListView.builder` tinggi setiap item secara eksplisit jika tingginya konsisten.
    - **Implementasi:** Setel properti `itemExtent` pada `ListView.builder`.
    - **Manfaat:** Flutter dapat melakukan perhitungan tata letak yang jauh lebih cepat karena tidak perlu mengukur setiap item secara individual, menghasilkan _scrolling_ yang lebih mulus.
  - **Pre-fetching Data & Smart Caching:**
    - **Deskripsi:** Prediksi item mana yang kemungkinan akan digulirkan pengguna dan muat data untuk item tersebut di latar belakang.
    - **Implementasi:** Gunakan _scroll controller_ untuk mendeteksi posisi _scroll_ dan memicu pemuatan data untuk item di luar _viewport_ saat ini.
    - **Manfaat:** Mengurangi _lag_ saat pengguna menggulir dengan cepat.

- **Pemanfaatan `const` dan `Key` secara Efektif:**

  - **`const` Constructor:** Sudah dibahas di atas, ini adalah optimasi pertama dan termudah.
  - **`Key` untuk Identifikasi Widget (khususnya dalam daftar dinamis):**
    - **Deskripsi:** `Key` adalah pengidentifikasi unik opsional untuk _widget_. Ketika daftar _widget_ berubah (misalnya, item ditambahkan, dihapus, atau diurutkan ulang), Flutter menggunakan `Key` untuk secara efisien mencocokkan _widget_ lama dengan _widget_ baru di _element tree_.
    - **Implementasi:** Gunakan `ValueKey`, `ObjectKey`, atau `UniqueKey` pada _widget_ dalam daftar dinamis. Contoh: `ListView.builder(itemBuilder: (context, index) => MyItemWidget(key: ValueKey(myItems[index].id), item: myItems[index]))`.
    - **Manfaat:** Mencegah Flutter dari _rebuilding_ seluruh daftar atau bagian yang salah dari daftar, menjaga _state_ _widget_ yang benar, dan meningkatkan kinerja secara signifikan saat daftar berubah.

- **Mengurangi Penggunaan `Opacity`:**
  - **Deskripsi:** Hindari penggunaan `Opacity` pada _widget_ yang sering dianimasikan atau di-_rebuild_, terutama jika _widget_ tersebut kompleks atau besar.
  - **Alternatif:**
    - Pertimbangkan untuk mengatur warna dengan _alpha channel_ langsung pada _widget_ yang transparan jika memungkinkan (`Color(0x80RRGGBB)`).
    - Jika _widget_ memiliki warna latar belakang solid, Anda bisa me-_repaint_ ulang _widget_ tersebut secara keseluruhan dengan warna yang lebih transparan, daripada menggunakan `Opacity` yang menambahkan _layer_ baru.
    - Gunakan `FadeTransition` dengan `Opacity` jika animasinya sederhana dan tidak terlalu sering.
  - **Manfaat:** Mengurangi beban _rasterization_ pada GPU.

---

Dengan menguasai teknik-teknik optimasi ini, Anda akan memiliki kemampuan untuk membangun aplikasi Flutter yang tidak hanya indah tetapi juga berkinerja tinggi.

#### 16.4 Tools & Best Practices

Bagian ini akan merangkum alat-alat tambahan dan praktik terbaik yang harus Anda terapkan secara rutin untuk memastikan aplikasi Flutter Anda selalu optimal.

- **Flutter DevTools (Overview & Advanced Usage):**
  - **Rekap:** Kita sudah membahas DevTools secara mendalam di **16.1 Performance Analysis** (Widget Inspector, Performance Overlay, Performance View, CPU Profiler, Memory, Network).
  - **Penggunaan Lanjutan:**
    - **Tracing Kustom:** Menggunakan `dart:developer`'s `Timeline.startSync()` dan `Timeline.finishSync()` untuk menandai segmen kode kustom di _timeline_ Performance DevTools. Ini sangat berguna untuk mengukur waktu eksekusi fungsi atau blok kode spesifik yang Anda curigai menjadi _bottleneck_.
    - **Analisis Penggunaan Memori:** Tab "Memory" di DevTools memungkinkan Anda melihat grafik penggunaan memori, melacak alokasi objek, dan menemukan _memory leak_ dengan mengambil _snapshot_ tumpukan memori. Anda bisa mencari objek yang terus bertambah tanpa dilepaskan.
    - **Analisis Jaringan:** Tab "Network" membantu Anda memantau permintaan HTTP, melihat waktu respons, ukuran data, dan mengidentifikasi panggilan jaringan yang lambat atau berlebihan.
    - **Analisis Ukuran Aplikasi:** Tab "App Size" (tersedia untuk _build_ rilis) memberikan detail tentang komponen yang berkontribusi pada ukuran _bundle_ aplikasi Anda, membantu Anda mengurangi ukuran akhir aplikasi.
- **Performance Testing & Profiling:**
  - **Menulis Tes Performa (misalnya, _microbenchmarks_):**
    - **Deskripsi:** Membuat tes otomatis yang mengukur waktu eksekusi blok kode kritis atau _widget_ tertentu.
    - **Implementasi:** Gunakan _package_ `benchmark` atau tulis _microbenchmark_ kustom dengan `Stopwatch` untuk mengukur waktu eksekusi. Jalankan tes ini di lingkungan yang konsisten (misalnya, perangkat fisik tanpa aplikasi lain yang berjalan di latar belakang) dan bandingkan hasilnya dari waktu ke waktu.
    - **Manfaat:** Mengidentifikasi regresi performa dini dalam siklus pengembangan.
  - **Profil Aplikasi Secara Teratur:**
    - **Deskripsi:** Lakukan _profiling_ performa secara rutin, tidak hanya ketika Anda menduga ada masalah. Jadwalkan sesi _profiling_ di berbagai perangkat dan skenario penggunaan.
    - **Kapan:** Saat menambahkan fitur besar, sebelum rilis utama, atau sebagai bagian dari _code review_.
    - **Manfaat:** Menangkap masalah kinerja sejak dini dan mencegahnya menumpuk.
- **Best Practices for High-Performance Flutter Apps:**
  - **Gunakan `const` Constructor Sebanyak Mungkin:** Ini adalah aturan emas. Jika _widget_ tidak berubah, jadikan `const`. Ini mengurangi _rebuild_ secara drastis.
  - **Minimalkan Penggunaan `setState()`:** Gunakan `setState()` hanya pada `StatefulWidget` yang paling kecil dan terlokalisasi yang diperlukan. Pertimbangkan untuk mengangkat _state_ ke atas (lifting state up) jika `setState()` mempengaruhi terlalu banyak _widget_ yang tidak terkait.
  - **Optimalkan Pembaruan State:**
    - Pilih solusi manajemen _state_ yang tepat (`BlocBuilder`/`Selector`, `Consumer`/`Selector`, `ref.watch().select()`) untuk mengisolasi _rebuild_.
    - Pastikan objek _state_ Anda _immutable_ atau menerapkan `==` dan `hashCode` dengan benar (misalnya dengan `Equatable` atau `Freezed`) agar _provider_ atau _bloc_ dapat secara efisien menentukan kapan _state_ benar-benar berubah.
    - Hindari komputasi berat dalam metode `build()` atau dalam _setter_ _state_ yang sering dipanggil.
  - **Gunakan `ListView.builder` / `GridView.builder` untuk Daftar Panjang:** Selalu gunakan _constructors_ `.builder` untuk _lazy loading_ item daftar. Hindari `ListView` atau `GridView` biasa dengan banyak anak secara langsung.
  - **Hindari `shrinkWrap: true` tanpa _parent_ yang membatasi tinggi:** Kecuali Anda tahu apa yang Anda lakukan, ini bisa menyebabkan seluruh daftar dirender sekaligus.
  - **Manfaatkan `Keys` untuk Daftar Dinamis:** Untuk daftar di mana item dapat ditambahkan, dihapus, atau diurutkan ulang, gunakan `Key` (seperti `ValueKey`) pada setiap item _widget_ untuk membantu Flutter secara efisien mendaur ulang dan memelihara _state_.
  - **Pre-cache Assets (Gambar, Font):** Untuk gambar yang sering digunakan atau akan muncul pertama kali, gunakan `precacheImage()` untuk memuatnya ke dalam _cache_ sebelum ditampilkan.
  - **Pentingnya `RepaintBoundary`:**
    - **Deskripsi:** `RepaintBoundary` adalah _widget_ yang secara eksplisit memberitahu Flutter untuk mengisolasi _repaint_ dari anak-anaknya. Jika sebuah anak di dalam `RepaintBoundary` di-_repaint_, hanya bagian itu yang di-_repaint_, bukan seluruh _parent_.
    - **Kapan Digunakan:** Berguna ketika Anda memiliki bagian UI yang sangat sering di-_repaint_ (misalnya, animasi kompleks, grafis kustom) tetapi _parent_-nya stabil.
    - **Perhatian:** Setiap `RepaintBoundary` memiliki _overhead_ kecil karena menciptakan _render layer_ terpisah. Gunakan dengan bijak, hanya jika _profiling_ menunjukkan _repaint_ yang tidak perlu mempengaruhi kinerja _parent_.
  - **Gunakan `SizedBox` daripada `Container` yang Kosong:** `SizedBox` lebih ringan daripada `Container` jika Anda hanya membutuhkan ukuran spasi dan tidak ada _decoration_, _padding_, atau _margin_.
  - **Hindari `ClipRRect` atau `Opacity` yang Berlebihan:** Terutama pada _widget_ yang dianimasikan atau sering di-_repaint_. Mereka dapat menyebabkan _offscreen buffer_ yang mahal. Jika memungkinkan, coba terapkan _radius_ atau _alpha_ pada `Container` atau `CustomPainter` secara langsung.
  - **Jalankan Aplikasi dalam Mode `profile` atau `release`:** Selalu lakukan _profiling_ di mode `profile`. Mode `debug` menambahkan banyak _overhead_ untuk membantu _debugging_ dan tidak mencerminkan kinerja aplikasi yang sebenarnya. Mode `release` menghilangkan semua alat _debugging_ untuk kinerja maksimal.

---

Dengan ini, kita telah menyelesaikan seluruh topik **16. Performance Monitoring & Optimization**, yang merupakan bagian pertama dari **FASE 10: Performance & Optimization**. Sekarang, kita akan beralih ke bagian kedua dari FASE 10:

### 17. Debugging & Error Handling

#### 17.1 Debugging Techniques

- **Integrated Development Environment (IDE) Debugging:**
  - **Breakpoints:** Menetapkan titik henti dalam kode Anda untuk menghentikan eksekusi dan memeriksa _state_ aplikasi.
  - **Step-by-step Execution:** Maju selangkah demi selangkah melalui kode (`Step Over`, `Step Into`, `Step Out`, `Continue`).
  - **Variable Inspection:** Memeriksa nilai variabel pada saat _breakpoint_ diaktifkan.
  - **Call Stack:** Memahami urutan pemanggilan fungsi yang mengarah ke lokasi saat ini.
  - **Conditional Breakpoints:** Menghentikan eksekusi hanya ketika kondisi tertentu terpenuhi.
  - **Logpoints:** Mencetak informasi ke konsol tanpa menghentikan eksekusi.
- **Logging & Tracing:**
  - **`print()` dan `debugPrint()`:** Perbedaan dan kapan menggunakannya. `debugPrint()` lebih baik untuk aplikasi Flutter karena menghindari _buffer_ yang meluap pada konsol Android/iOS.
  - **`flutter: develop` Package:** Menggunakan `log` dari `dart:developer` untuk _logging_ yang lebih terstruktur dan dapat diintegrasikan dengan DevTools.
  - **Third-Party Logging Libraries (misalnya, `logger`, `sentry`):** Manfaat, konfigurasi, dan integrasi untuk _logging_ yang lebih canggih di lingkungan produksi.

### 17. Debugging & Error Handling

Bagian ini sangat penting untuk memastikan stabilitas dan keandalan aplikasi Anda. Kemampuan untuk men-debug masalah dengan cepat dan menangani _error_ secara elegan adalah ciri khas pengembang yang mahir.

**Kita akan memulai dengan sub-topik pertama:**

#### 17.1 Debugging Techniques

- **Integrated Development Environment (IDE) Debugging:**

  - **Breakpoints:**
    - **Deskripsi:** Titik henti adalah lokasi dalam kode Anda di mana eksekusi program akan dijeda. Ini memungkinkan Anda untuk memeriksa _state_ aplikasi pada saat tertentu.
    - **Cara Menggunakan:** Klik di _gutter_ (margin kiri) di sebelah nomor baris kode di editor Anda (VS Code, Android Studio/IntelliJ). Sebuah titik merah akan muncul.
    - **Tujuan:** Menghentikan program untuk memeriksa nilai variabel, urutan eksekusi, atau kondisi tertentu.
  - **Step-by-step Execution:**
    - **Deskripsi:** Setelah program berhenti di _breakpoint_, Anda dapat melanjutkan eksekusi baris demi baris, memungkinkan Anda untuk mengikuti alur logika program secara detail.
    - **Tombol Umum di IDE:**
      - `Continue` (F5): Melanjutkan eksekusi hingga _breakpoint_ berikutnya atau akhir program.
      - `Step Over` (F10): Mengeksekusi baris kode saat ini dan melompat ke baris berikutnya. Jika baris saat ini adalah pemanggilan fungsi, fungsi tersebut dieksekusi sepenuhnya tanpa masuk ke dalamnya.
      - `Step Into` (F11): Mengeksekusi baris kode saat ini. Jika baris tersebut adalah pemanggilan fungsi, _debugger_ akan masuk ke dalam fungsi tersebut.
      - `Step Out` (Shift+F11): Mengeksekusi sisa fungsi saat ini dan berhenti di baris setelah pemanggilan fungsi tersebut.
    - **Tujuan:** Memahami alur kontrol program, terutama di logika yang kompleks atau berlapis.
  - **Variable Inspection:**
    - **Deskripsi:** Saat program dijeda di _breakpoint_, Anda dapat melihat dan terkadang memodifikasi nilai variabel dalam _scope_ saat ini.
    - **Cara Menggunakan:** Biasanya ada panel "Variables" atau "Watch" di jendela _debugger_ IDE Anda. Anda dapat mengklik variabel untuk melihat nilainya, dan terkadang menggantinya untuk menguji skenario yang berbeda.
    - **Tujuan:** Memeriksa _state_ data pada titik tertentu untuk menemukan nilai yang tidak terduga atau salah.
  - **Call Stack:**
    - **Deskripsi:** _Call Stack_ (atau _Stack Trace_) adalah daftar urutan pemanggilan fungsi yang menyebabkan eksekusi berhenti di lokasi _breakpoint_ saat ini. Ini menunjukkan bagaimana Anda sampai di sana.
    - **Cara Menggunakan:** Panel "Call Stack" di jendela _debugger_ akan menampilkan daftar fungsi yang dipanggil. Anda dapat mengklik setiap entri di _stack_ untuk melompat ke kode di lokasi pemanggilan fungsi tersebut.
    - **Tujuan:** Memahami konteks eksekusi dan melacak masalah kembali ke sumber pemanggil.
  - **Conditional Breakpoints:**
    - **Deskripsi:** _Breakpoint_ yang hanya akan menghentikan eksekusi jika suatu kondisi tertentu terpenuhi.
    - **Cara Menggunakan:** Klik kanan pada _breakpoint_ yang ada atau saat membuatnya, lalu masukkan ekspresi boolean. Contoh: `count > 10` atau `username == 'admin'`.
    - **Tujuan:** Sangat berguna untuk men-debug _loop_ besar atau skenario di mana masalah hanya muncul pada kondisi data atau alur tertentu.
  - **Logpoints (atau "Hit Breakpoints"):**
    - **Deskripsi:** _Breakpoint_ yang, alih-alih menghentikan eksekusi, hanya mencetak pesan ke konsol ketika dieksekusi.
    - **Cara Menggunakan:** Klik kanan pada _breakpoint_ dan pilih opsi "Log Message" atau "Edit Breakpoint" untuk menambahkan pesan yang akan dicetak. Anda juga dapat menyertakan ekspresi variabel di dalam pesan.
    - **Tujuan:** Untuk _logging_ non-invasif tanpa mengganggu alur program, berguna untuk melacak alur _event_ atau nilai variabel seiring waktu.

- **Logging & Tracing:**
  - **`print()` dan `debugPrint()`:**
    - **`print()`:** Fungsi bawaan Dart yang mencetak _output_ ke konsol.
    - **`debugPrint()`:** Fungsi yang direkomendasikan di Flutter (`package:flutter/foundation.dart`). Ini dirancang untuk bekerja lebih baik dengan _buffer_ log Android/iOS yang memiliki batas ukuran. Jika `print()` digunakan terlalu sering dan menghasilkan _output_ yang besar, _buffer_ bisa meluap dan membuang beberapa log. `debugPrint()` memecah _output_ yang panjang menjadi beberapa baris yang lebih kecil untuk mencegah hal ini.
    - **Kapan Menggunakan:** Untuk _logging_ sederhana dan cepat selama pengembangan. Hindari penggunaan berlebihan di produksi karena dapat memengaruhi kinerja dan keamanan.
  - **`flutter: develop` Package (`log` dari `dart:developer`):**
    - **Deskripsi:** `log` function adalah alternatif yang lebih canggih daripada `print()` atau `debugPrint()`. Ia dapat mencetak pesan dengan level log, nama, dan _error_ opsional.
    - **Implementasi:** `import 'dart:developer' as developer; developer.log('Pesan Log', name: 'MyFeature', error: someErrorObject);`
    - **Manfaat:** Pesan log yang lebih terstruktur dan dapat difilter di DevTools atau alat _logging_ lainnya. Berguna untuk _tracing_ event dan alur yang kompleks.
  - **Third-Party Logging Libraries (misalnya, `logger`, `sentry`, `firebase_crashlytics`):**
    - **Deskripsi:** Untuk _logging_ yang lebih _robust_ di lingkungan produksi, Anda akan membutuhkan _library_ pihak ketiga.
    - **Manfaat:**
      - **Level Log:** Mendukung level log yang berbeda (debug, info, warning, error, fatal).
      - **Formatter:** Format _output_ log agar lebih mudah dibaca (misalnya, dengan warna, _timestamp_, _stack trace_).
      - **Filter:** Memungkinkan Anda menyaring log berdasarkan level atau tag.
      - **Transport:** Mengirim log ke _remote service_ (seperti Sentry, Firebase Crashlytics, Datadog) untuk pemantauan _real-time_ _error_ dan _crash_ di aplikasi yang sudah rilis.
      - **Context:** Menambahkan konteks ke log (ID pengguna, _session ID_, dll.).
    - **Konfigurasi dan Integrasi:** Biasanya melibatkan penyiapan _logger_ global di `main.dart` dan kemudian menggunakannya di seluruh aplikasi.

---

Memiliki pemahaman yang kuat tentang teknik _debugging_ ini akan secara drastis mempercepat kemampuan Anda untuk menemukan dan menyelesaikan masalah dalam kode Flutter Anda.

#### 17.2 Error Handling Strategies

Penanganan _error_ yang efektif adalah kunci untuk membangun aplikasi yang _robust_ dan memberikan pengalaman pengguna yang baik, bahkan saat terjadi hal tak terduga.

- **`try-catch` Blocks:**

  - **Deskripsi:** Mekanisme dasar di Dart untuk menangani pengecualian (exceptions) yang dilemparkan selama eksekusi kode.
  - **Implementasi:**
    ```dart
    try {
        // Kode yang mungkin melempar exception
        int result = 10 ~/ 0; // Contoh: Division by zero
    } on IntegerDivisionByZeroException catch (e) {
        // Tangani exception spesifik ini
        print('Caught specific exception: $e');
    } catch (e) {
        // Tangani exception lainnya
        print('Caught general exception: $e');
    } finally {
        // Kode ini akan selalu dieksekusi, terlepas dari apakah ada exception atau tidak
        print('Finally block executed.');
    }
    ```
  - **Manfaat:** Mencegah aplikasi _crash_ karena _runtime error_ dan memungkinkan Anda untuk mengelola alur program saat terjadi kesalahan.
  - **`on` keyword:** Untuk menangkap tipe _exception_ tertentu.
  - **`catch` keyword (dengan atau tanpa `on`):** Menangkap _exception_. Anda dapat menangkap objek _exception_ (`e`) dan _stack trace_ (`s`) dengan `catch (e, s)`.
  - **`finally` block:** Kode yang dieksekusi terlepas dari apakah _exception_ terjadi atau tidak (sering digunakan untuk membersihkan sumber daya).

- **Error Boundaries (menggunakan `ErrorWidget` dan `FlutterError.onError`):**

  - **Deskripsi:** Flutter menyediakan mekanisme untuk menangani _error_ yang terjadi di dalam _widget tree_ atau selama _rendering_ UI, mencegah seluruh aplikasi _crash_.
  - **`ErrorWidget.builder`:**
    - **Implementasi:** Anda dapat mengganti tampilan _error_ default di UI.
      ```dart
      void main() {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          // Di debug mode, tampilkan error yang default
          if (kDebugMode) {
            return ErrorWidget(details.exception);
          }
          // Di release mode, tampilkan UI custom yang lebih ramah pengguna
          return Container(
            alignment: Alignment.center,
            child: Text(
              'Oops! Something went wrong.',
              style: TextStyle(color: Colors.red),
              textDirection: TextDirection.ltr,
            ),
          );
        };
        runApp(const MyApp());
      }
      ```
    - **Manfaat:** Memberikan _fallback UI_ yang ramah pengguna saat _error_ terjadi di bagian _widget tree_ tertentu, daripada hanya menunjukkan _red screen of death_.
  - **`FlutterError.onError`:**
    - **Deskripsi:** _Callback_ global yang dipanggil setiap kali Flutter melempar _error_ yang tidak tertangkap oleh _framework_ (misalnya, _error_ di dalam `build` method _widget_).
    - **Implementasi:**
      ```dart
      void main() {
        FlutterError.onError = (FlutterErrorDetails details) {
          // Di debug mode, gunakan default Flutter error handler
          FlutterError.dumpErrorToConsole(details);
          // Di release mode, kirim error ke layanan pelaporan error
          if (kReleaseMode) {
            FirebaseCrashlytics.instance.recordFlutterError(details);
            // Atau Sentry.captureFlutterError(details);
          }
        };
        runApp(const MyApp());
      }
      ```
    - **Manfaat:** Memungkinkan Anda untuk mencatat semua _error_ UI yang tidak tertangkap ke layanan pelaporan _crash_ (seperti Firebase Crashlytics atau Sentry) di lingkungan produksi, tanpa membiarkan pengguna melihat _red screen_.

- **Asynchronous Error Handling (untuk Futures & Streams):**

  - **`Future.catchError()`:**
    - **Deskripsi:** Digunakan untuk menangani _error_ yang mungkin dilemparkan oleh sebuah `Future`.
    - **Implementasi:**
      ```dart
      myAsyncFunction().catchError((error) {
          print('Future error: $error');
      }).then((value) {
          print('Future completed with value: $value');
      });
      ```
    - **Manfaat:** Menangani _error_ dalam operasi _asynchronous_ yang berbasis `Future`.
  - **`Stream.handleError()` & `Stream.listen(onError: ...)`:**

    - **Deskripsi:** Untuk _error_ dalam `Stream`.
    - **Implementasi:**

      ```dart
      myStream.listen(
        (data) => print('Data: $data'),
        onError: (error) => print('Stream error: $error'),
        onDone: () => print('Stream done'),
        cancelOnError: false, // Jangan batalkan stream setelah error pertama
      );

      // Atau menggunakan handleError
      myStream.handleError((error) {
        print('Stream error caught by handleError: $error');
      }).listen((data) => print('Data: $data'));
      ```

    - **Manfaat:** Mengelola _error_ yang terjadi secara berkelanjutan dalam _stream_ data.

  - **`runZonedGuarded` (untuk _top-level errors_):**
    - **Deskripsi:** Fungsi dari `dart:async` yang memungkinkan Anda untuk membuat "zona" di mana setiap _error_ yang tidak tertangkap akan diarahkan ke _error handler_ yang Anda tentukan. Ini adalah penangkap _error_ tingkat tertinggi di Dart.
    - **Implementasi:**
      ```dart
      void main() {
        runZonedGuarded<Future<void>>(() async {
          // Kode aplikasi Anda, termasuk runApp
          runApp(const MyApp());
        }, (Object error, StackTrace stack) {
          // Ini akan menangkap hampir semua error Dart yang tidak tertangkap
          // termasuk error asynchronous
          print('Caught top-level error: $error');
          print('Stack trace: $stack');
          // Kirim ke layanan pelaporan error
          if (kReleaseMode) {
            FirebaseCrashlytics.instance.recordError(error, stack);
            // Atau Sentry.captureException(error, stackTrace: stack);
          }
        });
      }
      ```
    - **Manfaat:** Menangkap _error_ yang mungkin terlewat oleh mekanisme lain, termasuk _error_ yang terjadi di _event loop_ atau di _futures_ yang tidak memiliki `.catchError()`. Ini sangat penting untuk _logging_ _crash_ aplikasi secara komprehensif di produksi.

- **Crash Reporting Tools (Firebase Crashlytics, Sentry):**

  - **Deskripsi:** Layanan pihak ketiga yang mengumpulkan, mengorganisir, dan menganalisis _crash_ dan _error_ dari aplikasi yang sudah di-_deploy_.
  - **Firebase Crashlytics:** Alat dari Google yang terintegrasi dengan Firebase, menyediakan pelaporan _crash_ _real-time_ yang kuat, _stack trace_ yang dapat dibaca, dan kemampuan untuk menambahkan log atau _key-value pair_ kustom.
  - **Sentry:** Platform pemantauan _error_ yang komprehensif, mendukung berbagai bahasa dan _framework_, menawarkan pelacakan _error_ _real-time_, _contextual data_, dan integrasi dengan alat manajemen proyek.
  - **Implementasi:** Biasanya melibatkan penambahan _package_ ke `pubspec.yaml`, inisialisasi di `main()`, dan konfigurasi untuk mengirim _error_ dari `FlutterError.onError` dan `runZonedGuarded`.
  - **Manfaat:**
    - **Visibilitas:** Memahami _crash_ dan _error_ yang dialami pengguna di lingkungan produksi.
    - **Prioritasi:** Mengidentifikasi _error_ paling sering atau yang memengaruhi banyak pengguna.
    - **Debugging Jarak Jauh:** Mendapatkan informasi _context_ seperti versi aplikasi, perangkat, dan log sebelumnya untuk membantu _debugging_ tanpa akses langsung ke perangkat pengguna.

---

Dengan penguasaan teknik penanganan _error_ ini, Anda dapat membuat aplikasi Flutter yang lebih tangguh dan mudah di-_maintain_.

# Selamat!

Dengan ini, Anda telah menyelesaikan seluruh **Fase 10**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-11/README.md
[selanjutnya]: ../bagian-13/README.md

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
