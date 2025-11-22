> [pro][flash10]

# **[FASE 10: Performance & Optimization][0]**

### Daftar Isi

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- **16. Performance Monitoring & Optimization**
  - **16.1. Performance Analysis**
    - 16.1.1. Flutter DevTools Profiling
    - 16.1.2. Memory Management
  - **16.2. Build & Runtime Optimization**
    - 16.2.1. Build Optimization
    - 16.2.2. Runtime Performance
  - **16.3. Monitoring & Analytics**
    - 16.3.1. Crash Reporting
    - 16.3.2. Performance Analytics

</details>

---

### **16. Performance Monitoring & Optimization**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Performa adalah tentang seberapa cepat dan lancar aplikasi Anda berjalan. Aplikasi yang sering mengalami _lag_, macet, atau menghabiskan banyak baterai akan cepat ditinggalkan oleh pengguna. Fase ini mengajarkan Anda cara menjadi "detektif performa". Anda akan belajar menggunakan alat-alat canggih seperti **Flutter DevTools** untuk mendiagnosis masalah, mengidentifikasi bagian kode yang lambat (_bottlenecks_), dan menerapkan berbagai teknik optimisasi untuk membuat aplikasi Anda berjalan secepat dan seefisien mungkin.

---

#### **16.1. Performance Analysis**

##### **16.1.1. Flutter DevTools Profiling**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Flutter DevTools** adalah seperangkat alat performa dan _debugging_ berbasis web untuk aplikasi Dart dan Flutter. Ini adalah "ruang kontrol" Anda untuk memahami apa yang terjadi di dalam aplikasi Anda saat berjalan. Bagian ini akan fokus pada penggunaan _tab_ **Performance** dan **CPU Profiler** untuk memvisualisasikan bagaimana setiap _frame_ dirender dan mengidentifikasi pekerjaan yang memakan waktu terlalu lama di _thread_ UI atau _thread_ lainnya.

**Konsep Kunci & Filosofi Mendalam:**

- **The Two Threads (Dua Thread Utama):** Aplikasi Flutter pada dasarnya berjalan di dua _thread_ utama:
  1.  **UI Thread:** Menjalankan kode Dart dan bertanggung jawab untuk membangun _widget tree_ dan logika aplikasi.
  2.  **Raster Thread** (atau GPU Thread): Mengambil hasil dari _UI thread_ dan menggambarnya ke layar.
      Masalah performa paling umum (_jank_ atau patah-patah) terjadi ketika **UI Thread terblokir** dan tidak dapat menyelesaikan pekerjaannya dalam waktu yang ditentukan untuk satu _frame_ (biasanya \~16 milidetik untuk layar 60Hz).
- **Flame Charts:** Ini adalah visualisasi utama di _CPU Profiler_. _Flame chart_ menampilkan tumpukan panggilan (_call stack_) dari waktu ke waktu. Sumbu X adalah waktu, dan sumbu Y adalah kedalaman tumpukan panggilan. Balok yang **lebar** pada _flame chart_ menunjukkan fungsi yang memakan waktu lama untuk dieksekusi dan merupakan kandidat utama untuk dioptimalkan.
- **Widget Rebuilds:** Salah satu fitur paling kuat di DevTools adalah kemampuannya untuk menyorot widget apa saja yang dibangun ulang (_rebuilt_) pada setiap _frame_. Membangun ulang widget yang tidak perlu adalah salah satu penyebab utama pemborosan CPU. Tujuannya adalah untuk menjaga jumlah _rebuild_ seminimal mungkin.

**Contoh Penggunaan DevTools:**

1.  Jalankan aplikasi Anda dalam mode _debug_ atau _profile_.
2.  Buka DevTools dari IDE Anda (biasanya ada ikon observatorium kecil).
3.  Buka _tab_ **Performance**.
4.  Aktifkan "Track Widget Builds".
5.  Berinteraksi dengan aplikasi Anda. Anda akan melihat garis-garis biru pada linimasa untuk setiap _frame_ yang dirender. Garis yang tinggi (melebihi batas \~16ms) berwarna merah dan menandakan _jank_.
6.  Klik pada _frame_ yang merah untuk melihat _flame chart_ di bagian bawah dan analisis apa yang terjadi pada _frame_ tersebut.

### **Visualisasi Konseptual (DevTools UI)**

```
┌──────────────────────────────────────────────────────────────────────────┐
│ 💻 Flutter DevTools - Performance Tab                                    │
├──────────────────────────────────────────────────────────────────────────┤
│ [Timeline Events] [Frame Analysis] [Widget Rebuilds]                     │
│ ------------------------------------------------------------------------ │
│                                                                          │
│  Frame Rendering Stats:                                                  │
│  ║       █      █ █                                  █ █ ║              │
│  ║ █ █ █ ███ █ ██ ███ █ <--- UI Thread      (Grafik Batang Biru)     │
│  ╠══════════════════════════════════════════════════════════════════════╣ <--- Batas 16ms
│  ║ █ █ █ ███ █ █  █  █ <--- Raster Thread    (Grafik Batang Hijau)    │
│  ║       █      █ █                                                     │
│                                                                          │
│ ------------------------------------------------------------------------ │
│  CPU Profiler (Flame Chart untuk Frame yang Dipilih):                    │
│                                                                          │
│                 ┌───────────────────────────┐                            │
│                 │      build_very_wide_function()     │ <-- Balok lebar = Masalah!
│                 └─────────────────┬─────────┘                            │
│         ┌─────────────────────────┼────────────────────────┐             │
│         │   buildExpensiveWidget()│                        │             │
│         └───────────────┬─────────┘                        │             │
│     ┌───────────────────┼───────────────────────────────┐  │             │
│     │   MyPage.build()  │                               │  │             │
│     └───────────────────┴───────────────────────────────┘  │             │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

##### **16.1.2. Memory Management**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Manajemen memori adalah tentang memastikan aplikasi Anda menggunakan RAM seefisien mungkin. Aplikasi yang menggunakan terlalu banyak memori dapat menjadi lambat, sering dihentikan oleh sistem operasi, atau bahkan _crash_. Kebocoran memori (_memory leak_), di mana objek yang tidak lagi dibutuhkan gagal dilepaskan dari memori, adalah masalah umum. Bagian ini mengajarkan cara menggunakan **Memory Tab** di DevTools untuk melacak alokasi objek dan mendeteksi kebocoran.

**Konsep Kunci & Filosofi Mendalam:**

- **Garbage Collection (GC):** Dart adalah bahasa yang _garbage-collected_. Ini berarti developer tidak perlu secara manual mengalokasikan dan melepaskan memori. _Garbage Collector_ secara periodik berjalan untuk menemukan dan membersihkan objek yang tidak lagi dapat dijangkau dari kode Anda.
- **Deteksi Memory Leak:** Alur kerja umum untuk mendeteksi _leak_ adalah:
  1.  Buka halaman di aplikasi Anda.
  2.  Buka _tab_ Memory di DevTools dan ambil _snapshot_.
  3.  Tinggalkan halaman tersebut (misalnya dengan `Navigator.pop()`).
  4.  Picu GC secara manual di DevTools.
  5.  Ambil _snapshot_ kedua.
  6.  Bandingkan kedua _snapshot_. Jika Anda masih melihat instance dari _controller_ atau _state_ halaman yang seharusnya sudah hancur, Anda kemungkinan besar memiliki _memory leak_.
- **Penyebab Umum Leak:** Penyebab paling umum adalah lupa membatalkan langganan ke `Stream` atau lupa memanggil `.dispose()` pada objek seperti `AnimationController`, `TextEditingController`, atau `StreamController`.

---

#### **16.2. Build & Runtime Optimization**

##### **16.2.1. Build Optimization**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Optimisasi ini terjadi saat Anda membangun aplikasi untuk rilis. Tujuannya adalah untuk membuat paket aplikasi (APK untuk Android, IPA untuk iOS) sekecil dan secepat mungkin saat pertama kali dijalankan.

**Konsep Kunci & Implementasi:**

- **Tree Shaking:** Flutter secara otomatis melakukan _tree shaking_ dalam mode rilis. Ini adalah proses menganalisis kode Anda dan "mengguncang pohon" untuk membuang semua kode (kelas, fungsi, variabel) yang tidak pernah digunakan. Anda tidak perlu melakukan apa pun, tetapi penting untuk mengetahui bahwa ini terjadi.
- **Code Splitting (Deferred Loading):** Untuk aplikasi web, Anda dapat memecah kode Dart Anda menjadi beberapa "potongan" (_chunks_) yang diunduh sesuai kebutuhan, bukan mengunduh semuanya di awal. Ini secara drastis mengurangi waktu muat awal. Ini dilakukan dengan menggunakan kata kunci `deferred as`.
- **Bundle Size Analysis:** Anda dapat menjalankan `flutter build apk --analyze-size` untuk mendapatkan laporan detail tentang apa saja yang berkontribusi pada ukuran APK Anda, memungkinkan Anda untuk mengidentifikasi aset besar atau dependensi yang tidak perlu.
- **Obfuscation (Obfuskasi):** Proses mengganti nama kelas, metode, dan variabel Anda menjadi nama-nama pendek yang tidak berarti. Ini membuat kode Anda lebih sulit untuk di-_reverse engineer_ dan juga sedikit mengurangi ukuran _bundle_. Anda mengaktifkannya dengan flag `--obfuscate --split-debug-info`.

---

##### **16.2.2. Runtime Performance**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah optimisasi yang Anda lakukan di dalam kode Anda untuk memastikan aplikasi berjalan lancar saat digunakan.

**Konsep Kunci & Praktik Terbaik:**

- **Minimalkan Widget Rebuilds:**
  - **Gunakan `const` constructors** sedapat mungkin. Widget `const` tidak akan pernah dibangun ulang.
  - **Pisahkan widget yang besar** menjadi widget-widget yang lebih kecil. Ini memungkinkan Flutter untuk hanya membangun ulang bagian kecil dari UI yang state-nya berubah.
  - **Gunakan `Consumer` atau `Selector`** (dari paket `provider`) atau `BlocBuilder` untuk melokalisasi _rebuild_ hanya ke widget yang benar-benar membutuhkan data state.
- **List Performance (`ListView.builder`):** Untuk daftar yang panjang, **jangan pernah** menggunakan `ListView(children: [ ... ])`. Ini akan membangun semua _item_ di dalam daftar sekaligus, bahkan yang tidak terlihat di layar, yang sangat boros memori dan CPU. Selalu gunakan `ListView.builder`, yang hanya membangun _item_ yang akan terlihat di layar secara _lazy_.
- **Image Loading Optimization:**
  - Gunakan `CachedNetworkImage` untuk menghindari pengunduhan ulang gambar.
  - Tampilkan gambar dengan resolusi yang sesuai dengan ukuran tampilannya. Jangan memuat gambar 4K untuk ditampilkan sebagai avatar kecil.
- **Menghindari Operasi Mahal di Metode `build()`:** Metode `build()` harus cepat dan murni. Hindari menempatkan logika bisnis yang kompleks atau panggilan jaringan di dalamnya, karena `build()` dapat dipanggil berkali-kali setiap detik.

---

#### **16.3. Monitoring & Analytics**

##### **16.3.1. Crash Reporting**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Tidak peduli seberapa banyak Anda menguji, _bug_ dan _crash_ di lingkungan produksi tidak dapat dihindari. **Crash Reporting** adalah layanan yang secara otomatis menangkap _unhandled exceptions_ (error yang menyebabkan aplikasi Anda mogok) dari perangkat pengguna dan mengirimkannya ke dasbor terpusat. Ini memungkinkan Anda untuk secara proaktif mengetahui, mendiagnosis, dan memperbaiki _crash_ yang dialami pengguna Anda di dunia nyata.

**Konsep & Alat Populer:**

- **Firebase Crashlytics:** Solusi gratis dan sangat populer dari Google. Ia secara otomatis menangkap _crash_ dan mengelompokkannya, memberikan _stack trace_ yang detail, serta informasi tentang perangkat dan versi OS pengguna.
- **Sentry:** Alternatif populer lainnya yang menyediakan fitur serupa dengan integrasi yang luas ke berbagai _workflow_ pengembangan.
- **Error Tracking:** Anda juga dapat secara manual melaporkan _non-fatal exceptions_ (error yang Anda tangkap di blok `try-catch` tetapi tetap ingin Anda ketahui) ke layanan ini untuk mendapatkan gambaran lengkap tentang kesehatan aplikasi Anda.

##### **16.3.2. Performance Analytics**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah tentang mengukur performa aplikasi Anda di **dunia nyata**, di perangkat pengguna yang beragam. Layanan seperti **Firebase Performance Monitoring** secara otomatis mengumpulkan data tentang:

- **Waktu Startup Aplikasi:** Berapa lama waktu yang dibutuhkan aplikasi Anda untuk dibuka.
- **Performa Jaringan:** Mengukur latensi dan tingkat keberhasilan dari permintaan HTTP.
- **Render Frames:** Mendeteksi _frame_ yang lambat atau beku.
- **Custom Traces:** Anda dapat secara manual "membungkus" bagian kode yang ingin Anda ukur (misalnya, berapa lama waktu yang dibutuhkan untuk memproses sebuah gambar) untuk melihat performanya di berbagai kondisi.

---

### **Selamat !**

Kita telah menyelesaikan seluruh fase. Anda telah bertransformasi dari seorang pembangun aplikasi menjadi seorang "mekanik" aplikasi. Anda kini dibekali dengan pengetahuan untuk menggunakan **Flutter DevTools** sebagai stetoskop untuk mendiagnosis masalah **performa CPU** dan **kebocoran memori**. Anda memahami strategi untuk mengoptimalkan aplikasi baik pada saat **build** (untuk ukuran yang lebih kecil) maupun saat **runtime** (untuk UI yang lebih lancar).

Terakhir, Anda tahu cara memasang "kotak hitam" di aplikasi Anda menggunakan layanan **Crash Reporting** dan **Performance Analytics**, memungkinkan Anda untuk memantau kesehatan dan kecepatan aplikasi Anda setelah dirilis ke tangan pengguna.

Kemampuan untuk membangun aplikasi yang tidak hanya berfungsi tetapi juga berkinerja tinggi adalah pembeda utama dari seorang developer senior.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-9/README.md
[selanjutnya]: ../bagian-11/README.md
[flash10]: ../../flash/bagian-10/README.md

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
