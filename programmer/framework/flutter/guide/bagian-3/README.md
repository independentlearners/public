# [Flutter CLI dan DevTools][0]

<details>
  <summary>📃 Struktur Daftar Isi</summary>

- [Flutter CLI dan DevTools](#flutter-cli-dan-devtools)
    - [1.2.2 Flutter CLI dan DevTools](#122-flutter-cli-dan-devtools)
      - [Perintah Dasar Flutter CLI](#perintah-dasar-flutter-cli)
      - [Memahami Flutter DevTools](#memahami-flutter-devtools)
  - [Selamat!](#selamat)

</details>

---

### 1.2.2 Flutter CLI dan DevTools

Modul ini memperkenalkan dua alat penting yang akan menjadi bagian tak terpisahkan dari alur kerja pengembangan Flutter sehari-hari: _Command Line Interface_ (CLI) Flutter dan Flutter DevTools. CLI memungkinkan interaksi cepat dengan proyek Flutter, sementara DevTools menyediakan kemampuan _debugging_ dan _profiling_ yang canggih.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Bagian ini akan mengajarkan pembelajar cara menggunakan perintah dasar CLI Flutter untuk membuat, menjalankan, membangun, dan mengelola proyek. Selain itu, pembelajar akan dikenalkan pada Flutter DevTools, sebuah _suite_ alat grafis yang memungkinkan mereka untuk menginspeksi _widget tree_, memantau kinerja aplikasi, melacak penggunaan memori, dan men-debug kode secara visual. Pemahaman dan penguasaan alat-alat ini sangat penting untuk efisiensi dan efektivitas dalam pengembangan dan pemecahan masalah aplikasi Flutter.

**Konsep Kunci & Filosofi Mendalam:**

- **CLI (Command Line Interface):** Antarmuka pengguna berbasis teks yang memungkinkan pengguna berinteraksi dengan program komputer dengan mengetik perintah.

  - **Filosofi:** CLI menawarkan cara yang cepat, efisien, dan dapat diotomatisasi untuk melakukan tugas-tugas pengembangan. Ini sangat berguna untuk _scripting_, _Continuous Integration/Continuous Deployment_ (CI/CD), dan bagi pengembang yang lebih suka kontrol langsung melalui teks.

- **DevTools:** Kumpulan alat _debugging_ dan _profiling_ berbasis _web_ yang kaya fitur untuk Dart dan Flutter.

  - **Filosofi:** DevTools dirancang untuk memberikan visibilitas mendalam ke dalam perilaku aplikasi Flutter, memungkinkan pengembang untuk mengidentifikasi dan memecahkan masalah kinerja, _layout_, dan _state_ yang kompleks. Ini adalah alat penting untuk optimasi dan _troubleshooting_ aplikasi produksi.

**Visualisasi Diagram Alur/Struktur:**

- Contoh tangkapan layar terminal yang menunjukkan output dari beberapa perintah `flutter`.
- Tangkapan layar antarmuka Flutter DevTools yang menunjukkan panel-panel utama (misalnya, Widget Inspector, Performance, Memory, Debugger).

**Hubungan dengan Modul Lain:**
Penggunaan CLI akan menjadi kebiasaan sehari-hari untuk membuat proyek baru, menjalankan aplikasi, dan melakukan _build_. DevTools akan sangat relevan di modul-modul yang membahas _layout_, _state management_, _networking_, dan _performance optimization_ di fase-fase selanjutnya, karena ia menyediakan alat untuk memvisualisasikan dan menganalisis aspek-aspek tersebut.

---

#### Perintah Dasar Flutter CLI

**Deskripsi Konkret & Peran dalam Kurikulum:**
Sub-bagian ini akan memperkenalkan perintah _command-line_ yang paling sering digunakan dalam pengembangan Flutter. Menguasai perintah-perintah ini memungkinkan pengembang untuk mengelola siklus hidup proyek Flutter dari terminal, yang seringkali lebih cepat dan efisien untuk tugas-tugas tertentu dibandingkan melalui IDE.

**Konsep Kunci & Filosofi Mendalam:**

- **Automasi:** Perintah CLI memungkinkan otomatisasi tugas-tugas berulang, seperti membuat proyek baru atau menjalankan pengujian.
- **Agnostik IDE:** Perintah CLI bekerja secara independen dari IDE, memungkinkan alur kerja yang konsisten di berbagai lingkungan pengembangan.

**Sintaks Dasar / Contoh Implementasi Inti:**

Untuk menjalankan perintah-perintah ini, buka terminal atau _command prompt_ Anda.

1.  **`flutter doctor`**:

    - **Deskripsi:** Memeriksa lingkungan pengembangan Anda dan menampilkan laporan tentang status instalasi Flutter, alat-alat lain (Android Studio, Xcode), dan dependensi. Ini adalah perintah pertama yang harus dijalankan setelah instalasi Flutter.
    - **Sintaks:**
      ```bash
      flutter doctor
      ```
    - **Contoh Output (sukses):**
      ```
      [✓] Flutter (Channel stable, 3.x.x, on macOS 13.x.x 22F83, locale en-GB)
      [✓] Android toolchain - develop for Android devices (Android SDK version 34.x.x)
      [✓] Xcode - develop for iOS and macOS (Xcode 15.x.x)
      [✓] Android Studio (version 2023.x)
      [✓] VS Code (version 1.x.x)
      [✓] Connected device (2 available)
      [✓] Network resources
      ```
    - **Referensi:** [Flutter Doctor Command](https://www.google.com/search?q=https://flutter.dev/docs/reference/flutter-cli%23flutter-doctor)

2.  **`flutter create <project_name>`**:

    - **Deskripsi:** Membuat proyek Flutter baru dengan struktur file dasar dan contoh aplikasi "Hello World".
    - **Sintaks:**
      ```bash
      flutter create my_first_app
      ```
    - **Contoh Implementasi:**
      ```bash
      cd my_desired_directory
      flutter create my_new_project
      cd my_new_project
      ```
    - **Referensi:** [Creating a new Flutter project](https://www.google.com/search?q=https://flutter.dev/docs/get-started/test-drive%3Ftab%3Dterminal%23create-the-app)

3.  **`flutter run`**:

    - **Deskripsi:** Menjalankan aplikasi Flutter di perangkat yang terhubung (emulator/simulator atau perangkat fisik). Jika ada beberapa perangkat, Anda bisa memilih perangkat target.
    - **Sintaks:**
      ```bash
      flutter run
      ```
    - **Sintaks dengan target perangkat tertentu:**
      ```bash
      flutter run -d <device_id>
      ```
      (Dapatkan `<device_id>` dari `flutter devices`)
    - **Contoh Implementasi:**
      ```bash
      cd my_new_project
      flutter run
      ```
    - **Referensi:** [Running a Flutter app](https://www.google.com/search?q=https://flutter.dev/docs/get-started/test-drive%3Ftab%3Dterminal%23run-the-app)

4.  **`flutter devices`**:

    - **Deskripsi:** Mendaftar semua perangkat (emulator, simulator, atau perangkat fisik) yang terhubung dan tersedia untuk menjalankan aplikasi Flutter.
    - **Sintaks:**
      ```bash
      flutter devices
      ```
    - **Contoh Output:**

      ```
      2 connected devices:

      Pixel 7 (mobile)  • emulator-5554 • android-arm64  • Android 14 (API 34)
      iPhone 15 (mobile) • 42F995D8-A8A2-4B6E-A5D8-C8E7D4F995D8 • ios            • iOS 17.0 (simulator)
      ```

    - **Referensi:** [Flutter Devices Command](https://www.google.com/search?q=https://flutter.dev/docs/reference/flutter-cli%23flutter-devices)

5.  **`flutter build <platform>`**:

    - **Deskripsi:** Mengkompilasi aplikasi Flutter Anda ke dalam kode _native_ yang dapat didistribusikan untuk platform tertentu (Android, iOS, web, desktop).
    - **Sintaks:**
      ```bash
      flutter build apk      # Membangun file .apk untuk Android
      flutter build appbundle # Membangun file .aab untuk Android (direkomendasikan untuk Play Store)
      flutter build ios      # Membangun file .ipa untuk iOS (membutuhkan Xcode)
      flutter build web      # Membangun aplikasi web
      flutter build windows  # Membangun aplikasi Windows
      ```
    - **Contoh Implementasi:**
      ```bash
      cd my_new_project
      flutter build apk --release # Membangun versi rilis yang dioptimalkan
      ```
    - **Referensi:** [Flutter Build Command](https://www.google.com/search?q=https://flutter.dev/docs/deployment/android%23build-an-apk-or-app-bundle)

6.  **`flutter clean`**:

    - **Deskripsi:** Menghapus direktori `build/` dan file-file yang dihasilkan lainnya dalam proyek Flutter Anda. Berguna untuk membersihkan proyek dan mengatasi masalah _build_ yang aneh.
    - **Sintaks:**
      ```bash
      flutter clean
      ```
    - **Referensi:** [Flutter Clean Command](https://www.google.com/search?q=https://flutter.dev/docs/reference/flutter-cli%23flutter-clean)

7.  **`flutter pub get`**:

    - **Deskripsi:** Mengambil semua dependensi (paket/library) yang terdaftar di file `pubspec.yaml` proyek Anda. Ini secara otomatis dijalankan saat `flutter create` atau `flutter run`, tetapi mungkin perlu dijalankan secara manual setelah mengubah `pubspec.yaml`.
    - **Sintaks:**
      ```bash
      flutter pub get
      ```
    - **Referensi:** [Pub Get Command](https://dart.dev/tools/pub/cmd/pub-get)

8.  **`flutter analyze`**:

    - **Deskripsi:** Menganalisis kode Dart Anda untuk menemukan kesalahan, peringatan, dan potensi masalah berdasarkan aturan _linting_.
    - **Sintaks:**
      ```bash
      flutter analyze
      ```
    - **Referensi:** [Flutter Analyze Command](https://www.google.com/search?q=https://flutter.dev/docs/reference/flutter-cli%23flutter-analyze)

**Visualisasi Diagram Alur/Struktur:**

- Contoh _screenshot_ terminal dengan output dari `flutter doctor`, `flutter create`, dan `flutter run`.

**Terminologi Esensial & Penjelasan Detail:**

- **CLI (Command Line Interface):** Antarmuka berbasis teks untuk menjalankan perintah.
- **SDK (Software Development Kit):** Kumpulan alat pengembangan.
- **Project:** Direktori yang berisi semua file dan kode aplikasi Flutter Anda.
- **Device ID:** Pengidentifikasi unik untuk perangkat yang terhubung (emulator/simulator/fisik).
- **APK/AAB (Android Package/App Bundle):** Format paket aplikasi Android yang dapat diinstal.
- **IPA (iOS App Archive):** Format paket aplikasi iOS.
- **`pubspec.yaml`:** File konfigurasi proyek Flutter yang mendefinisikan metadata proyek dan dependensi.
- **Dependensi:** _Library_ atau paket pihak ketiga yang digunakan oleh proyek Anda.
- **Linting:** Proses analisis kode untuk menemukan kesalahan gaya atau potensi masalah.

**Sumber Referensi Lengkap:**

- [Flutter CLI Cheatsheet](https://flutter.dev/docs/reference/flutter-cli)
- [Flutter Build Modes](https://www.google.com/search?q=https://docs.flutter.dev/tools/build-modes)
- [Flutter Pubspec File](https://www.google.com/search?q=https://docs.flutter.dev/tools/pub/pubspec)

**Tips dan Praktik Terbaik:**

- **Biasakan Menggunakan Terminal:** Meskipun IDE menyediakan tombol untuk menjalankan dan membangun, membiasakan diri dengan perintah CLI akan memberi Anda kontrol lebih besar dan mempercepat tugas-tugas tertentu.
- **Gunakan `--verbose`:** Untuk perintah yang bermasalah, tambahkan `--verbose` (misalnya, `flutter run --verbose`) untuk mendapatkan output yang lebih detail dan membantu _debugging_.
- **Buka Terminal di Root Proyek:** Pastikan Anda berada di direktori akar proyek Flutter Anda saat menjalankan sebagian besar perintah CLI (`cd your_project_name`).

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Aplikasi tidak berjalan di perangkat yang diinginkan.

  - **Penyebab:** Perangkat tidak terdeteksi, atau ada beberapa perangkat dan Flutter tidak tahu yang mana yang harus digunakan.
  - **Solusi:** Jalankan `flutter devices` untuk melihat perangkat yang tersedia dan ID-nya. Kemudian gunakan `flutter run -d <device_id>` untuk menargetkan perangkat tertentu.

- **Kesalahan:** Terjadi kesalahan _build_ yang tidak jelas.

  - **Penyebab:** Dependensi yang rusak, cache _build_ yang kotor, atau masalah konfigurasi proyek.
  - **Solusi:** Coba jalankan `flutter clean` diikuti oleh `flutter pub get` dan kemudian coba _build_ lagi. Ini sering kali menyelesaikan masalah.

---

#### Memahami Flutter DevTools

**Deskripsi Konkret & Peran dalam Kurikulum:**
Flutter DevTools adalah _suite_ alat diagnostik yang kuat yang memungkinkan pengembang untuk menganalisis, men-debug, dan mengoptimalkan aplikasi Flutter. Bagian ini akan memperkenalkan berbagai fitur DevTools dan bagaimana menggunakannya secara efektif untuk memahami perilaku aplikasi Anda di _runtime_.

**Konsep Kunci & Filosofi Mendalam:**

- **Observability:** Kemampuan untuk memahami _state_ internal aplikasi dari data eksternal. DevTools meningkatkan kemampuan _observability_ aplikasi Flutter.
- **Performance Profiling:** Menganalisis konsumsi sumber daya (CPU, memori, _rendering_) untuk mengidentifikasi _bottleneck_ dan area yang perlu dioptimalkan.
- **Debugging Visual:** Kemampuan untuk melihat struktur UI secara grafis dan memeriksa properti _widget_ secara _real-time_.

**Sintaks Dasar / Contoh Implementasi Inti:**

1.  **Meluncurkan DevTools:**

    - **Melalui IDE (Direkomendasikan):** Saat aplikasi Flutter Anda sedang berjalan di emulator/simulator atau perangkat fisik, IDE (VS Code atau Android Studio) biasanya akan menampilkan _link_ atau tombol untuk membuka DevTools secara otomatis. Ini adalah cara termudah karena DevTools akan terhubung secara otomatis ke aplikasi Anda.
    - **Melalui CLI:**
      1.  Jalankan aplikasi Flutter Anda di terminal: `flutter run`
      2.  Setelah aplikasi berjalan, terminal akan menampilkan URL seperti: `A Dart VM observatory is available at: http://127.0.0.1:xxxx/xxxxxxxx/`.
      3.  Salin URL ini dan tempelkan ke _browser_ web Anda, atau jalankan perintah: `flutter pub global activate devtools` (jika belum terinstal) dan kemudian `flutter pub global run devtools` untuk meluncurkan server DevTools. Setelah server berjalan, tempelkan URL observatorium aplikasi Anda ke kolom "Connect to a running app" di DevTools.

2.  **Fitur-fitur Utama DevTools:**

    - **Widget Inspector:**

      - **Deskripsi:** Memungkinkan Anda untuk menjelajahi _widget tree_ aplikasi Anda secara visual, melihat properti setiap _widget_, dan memahami bagaimana mereka disusun. Anda bisa memilih _widget_ di layar dan melihat detailnya di panel inspektur.
      - **Kasus Penggunaan:** Memahami _layout_ dan struktur UI, men-debug masalah tata letak, memeriksa nilai properti _widget_.
      - **Visualisasi:** Diagram pohon _widget_ interaktif.
      - **Referensi:** [Inspect a Widget (Flutter DevTools)](https://www.google.com/search?q=https://docs.flutter.dev/tools/devtools/widget-inspector)

    - **Layout Explorer:**

      - **Deskripsi:** Bagian dari Widget Inspector yang membantu Anda memvisualisasikan bagaimana _widget_ di-_layout_ di layar, menampilkan batas, _padding_, dan _margin_ mereka. Sangat berguna untuk men-debug masalah _layout_.
      - **Kasus Penggunaan:** Memahami batasan _layout_ dan bagaimana _widget_ mengisi ruang.
      - **Visualisasi:** Kotak visual yang menampilkan batas _layout_ setiap _widget_.
      - **Referensi:** [Layout Explorer (Flutter DevTools)](https://www.google.com/search?q=https://docs.flutter.dev/tools/devtools/widget-inspector%23layout-explorer)

    - **Performance View:**

      - **Deskripsi:** Memungkinkan Anda untuk menganalisis kinerja _rendering_ aplikasi, melihat _frame_ yang jatuh (jika ada), dan mengidentifikasi _bottleneck_ CPU atau GPU. Anda dapat merekam sesi dan menganalisis jejak kinerja.
      - **Kasus Penggunaan:** Mengidentifikasi penyebab UI yang tidak mulus (janky UI), mengoptimalkan animasi dan _rendering_.
      - **Visualisasi:** Grafik _frame_, grafik CPU profiler.
      - **Referensi:** [Performance View (Flutter DevTools)](https://docs.flutter.dev/tools/devtools/performance)

    - **Memory View:**

      - **Deskripsi:** Memantau penggunaan memori aplikasi Anda, mengidentifikasi _memory leak_, dan melihat alokasi objek.
      - **Kasus Penggunaan:** Mengoptimalkan penggunaan memori, menemukan objek yang tidak terbuang oleh _garbage collector_.
      - **Visualisasi:** Grafik penggunaan memori, tabel alokasi objek.
      - **Referensi:** [Memory View (Flutter DevTools)](https://docs.flutter.dev/tools/devtools/memory)

    - **Debugger:**

      - **Deskripsi:** Mirip dengan _debugger_ di IDE, tetapi terintegrasi di DevTools. Memungkinkan Anda mengatur _breakpoint_, melangkah melalui kode, memeriksa variabel, dan melihat _call stack_.
      - **Kasus Penggunaan:** Menemukan _bug_ dalam logika aplikasi, memahami aliran eksekusi kode.
      - **Visualisasi:** Panel kode dengan _breakpoint_, panel variabel, _call stack_.
      - **Referensi:** [Debugging a Flutter app (Flutter DevTools)](https://docs.flutter.dev/tools/devtools/debugger)

    - **Network View:**

      - **Deskripsi:** Memantau semua _network requests_ yang dibuat oleh aplikasi Anda, melihat _payload_ permintaan/respons, status kode, dan waktu.
      - **Kasus Penggunaan:** Men-debug masalah konektivitas jaringan, memeriksa data yang dikirim/diterima.
      - **Visualisasi:** Daftar _network requests_ dengan detail.
      - **Referensi:** [Network View (Flutter DevTools)](https://docs.flutter.dev/tools/devtools/network)

**Visualisasi Diagram Alur/Struktur:**

- Tangkapan layar _dashboard_ utama Flutter DevTools dengan highlight pada tab-tab utama.
- Contoh _screenshot_ dari Widget Inspector yang menunjukkan pohon _widget_.

**Terminologi Esensial & Penjelasan Detail:**

- **DevTools:** _Suite_ alat _debugging_ dan _profiling_ untuk Flutter.
- **Widget Inspector:** Alat untuk memeriksa struktur UI dan properti _widget_.
- **Layout Explorer:** Bagian dari Widget Inspector untuk memvisualisasikan batasan tata letak.
- **Performance Profiling:** Menganalisis kinerja aplikasi.
- **Memory Leak:** Kondisi di mana aplikasi terus mengonsumsi memori tetapi tidak pernah melepaskannya.
- **Debugger:** Alat untuk menemukan dan memperbaiki _bug_ dalam kode.
- **Breakpoint:** Titik dalam kode di mana eksekusi akan berhenti sementara selama _debugging_.
- **Call Stack:** Daftar fungsi yang sedang dieksekusi, menunjukkan urutan panggilan fungsi.
- **Network Request:** Komunikasi yang dilakukan aplikasi melalui jaringan (misalnya, ke API).

**Sumber Referensi Lengkap:**

- [Flutter DevTools Documentation](https://docs.flutter.dev/tools/devtools)
- [tautan mencurigakan telah dihapus]

**Tips dan Praktik Terbaik:**

- **Integrasi IDE Terbaik:** Selalu luncurkan DevTools dari IDE Anda untuk pengalaman yang paling mulus, karena ini akan secara otomatis menghubungkan DevTools ke aplikasi Anda.
- **Manfaatkan Widget Inspector:** Ini adalah alat yang sangat powerful untuk memahami dan men-debug UI Anda. Jika UI tidak terlihat seperti yang Anda harapkan, mulailah dengan Widget Inspector.
- **Gunakan Performance View di Mode Profil:** Untuk analisis kinerja yang akurat, jalankan aplikasi Anda dalam mode `profile` (`flutter run --profile`) saat menggunakan Performance View, karena mode `debug` memiliki _overhead_ yang signifikan.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** DevTools tidak dapat terhubung ke aplikasi yang sedang berjalan.

  - **Penyebab:** Aplikasi belum berjalan, atau URL observatorium salah.
  - **Solusi:** Pastikan aplikasi Anda telah berhasil diluncurkan di emulator/simulator/perangkat. Jika meluncurkan DevTools secara manual, pastikan URL yang ditempelkan di kolom "Connect to a running app" adalah URL observatorium yang benar yang disediakan di terminal.

- **Kesalahan:** Data di DevTools tidak _real-time_ atau tidak akurat.

  - **Penyebab:** Terkadang ada masalah koneksi atau _caching_.
  - **Solusi:** Coba me-_refresh_ halaman DevTools di _browser_. Jika masih bermasalah, coba _restart_ aplikasi Flutter Anda dan luncurkan ulang DevTools. Pastikan Anda menjalankan aplikasi dalam mode `debug` atau `profile` (bukan `release`) untuk _debugging_ DevTools.

## Selamat!

Kita telah menyelesaikan FASE 1. Selanjutnya kita akan masuk pada **Fase 2: Widget System & UI Foundation**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
