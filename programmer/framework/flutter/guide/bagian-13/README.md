# [FASE 11: Deployment & Distribution][0]

Fase ini akan membahas proses penting untuk menyiapkan, membangun, dan mendistribusikan aplikasi Flutter Anda ke berbagai platform (Android, iOS, Web). Ini mencakup langkah-langkah seperti _signing_ aplikasi, mengoptimalkan ukuran _bundle_, dan mengunggah ke toko aplikasi.

**Kita akan memulai dengan topik pertama dalam fase ini:**

### 18. App Build & Release Process

#### 18.1 Building for Android

- **Persiapan Proyek Android:**
  - **Perbarui `build.gradle`:** Memahami konfigurasi penting di level aplikasi (`app/build.gradle`) dan level proyek (`android/build.gradle`) seperti `minSdkVersion`, `targetSdkVersion`, `compileSdkVersion`, `buildToolsVersion`, dan `kotlin_version`.
  - **`android/app/src/main/AndroidManifest.xml`:** Memahami konfigurasi izin (`permissions`), fitur (`features`), dan aktivitas utama aplikasi.
  - **ProGuard/R8 (Code Shrinking & Obfuscation):**
    - **Deskripsi:** Tool untuk mengurangi ukuran aplikasi dan meng-_obfuscate_ kode.
    - **Konfigurasi:** Mengaktifkan ProGuard/R8 di `build.gradle` dan memahami file `proguard-rules.pro`.
    - **Manfaat:** Mengurangi ukuran aplikasi dan membuat _reverse engineering_ lebih sulit.
- **Generate Keystore (Signing Key):**
  - **Deskripsi:** Keystore adalah file biner yang berisi kunci kriptografi yang Anda gunakan untuk menandatangani aplikasi Anda secara digital. Ini adalah langkah keamanan penting.
  - **Peran dalam Proses Rilis:** Aplikasi Android yang akan diunggah ke Google Play Store harus ditandatangani dengan kunci rilis.
  - **Perintah `keytool`:** Cara membuat keystore baru dari _command line_ (`keytool -genkey -v -keystore my-release-key.jks -keyalias alias_name -keyalg RSA -keysize 2048 -validity 10000`).
  - **Pentingnya Menjaga Keamanan Keystore:** Konsekuensi jika kehilangan atau membocorkan keystore.
- **Configure Signing in Flutter:**
  - **File `key.properties`:** Cara menyimpan informasi keystore (path, alias, password) secara aman dan terpisah dari kode sumber.
  - **Referensi di `build.gradle`:** Menghubungkan `key.properties` ke konfigurasi _signing_ di `app/build.gradle`.
- **Build Release APK/AppBundle:**
  - **Perintah `flutter build apk` vs `flutter build appbundle`:** Perbedaan dan kapan menggunakannya. App Bundle adalah format distribusi yang direkomendasikan Google.
  - **`--target-platform`:** Menentukan arsitektur CPU target (armeabi-v7a, arm64-v8a, x86_64).
  - **`--split-per-abi`:** Membangun APK terpisah per ABI (Application Binary Interface) jika Anda perlu mendistribusikan APK daripada App Bundle.
  - **Output Lokasi:** Menemukan file APK/App Bundle yang sudah ditandatangani.

#### 18.2 Building for iOS

- **Persiapan Proyek iOS (Xcode):**
  - **Membuka Proyek Flutter di Xcode:**
    - **Deskripsi:** Proyek Flutter memiliki bagian iOS di dalam folder `ios/`. Anda perlu membukanya dengan Xcode untuk konfigurasi dan manajemen sertifikat.
    - **Cara Membuka:** Navigasi ke folder `ios/` di proyek Flutter Anda, lalu klik dua kali file `Runner.xcworkspace`. Atau, dari dalam Xcode, pilih `File > Open...` dan arahkan ke file tersebut.
  - **`Info.plist`:**
    - **Deskripsi:** File konfigurasi penting untuk aplikasi iOS, berisi metadata aplikasi seperti nama aplikasi, ikon, orientasi, izin, dan konfigurasi _deep linking_.
    - **Konfigurasi:** Menambahkan deskripsi penggunaan izin (`Privacy - Camera Usage Description`, `Privacy - Location When In Use Usage Description`, dll.), mengonfigurasi URL scheme, dan Universal Links.
  - **General Settings (Bundle Identifier, Version, Build Number):**
    - **Deskripsi:** Mengonfigurasi identifikasi unik aplikasi (`Bundle Identifier`), versi yang terlihat oleh pengguna (`Version`), dan nomor _build_ internal (`Build Number`).
    - **Cara Menggunakan:** Di Xcode, buka `Runner` target, lalu pergi ke tab `General`. Sesuaikan `Bundle Identifier`, `Version`, dan `Build`.
- **Mengelola Sertifikat, Provisioning Profile, & App IDs:**
  - **Apple Developer Program:**
    - **Deskripsi:** Keanggotaan yang diperlukan (berbayar) untuk mendistribusikan aplikasi ke App Store atau menguji di perangkat fisik.
    - **Pentingnya:** Memungkinkan akses ke _tools_ sertifikat, _provisioning profiles_, dan App Store Connect.
  - **Certificates (Development, Distribution):**
    - **Development Certificate:** Digunakan untuk menjalankan aplikasi di perangkat fisik Anda selama pengembangan.
    - **Distribution Certificate:** Digunakan untuk menandatangani aplikasi untuk distribusi ke App Store atau Ad Hoc.
    - **Cara Membuat:** Melalui Xcode otomatis atau secara manual di portal Apple Developer.
  - **App IDs:**
    - **Deskripsi:** Pengidentifikasi unik yang menghubungkan aplikasi Anda dengan sertifikat dan _provisioning profile_ tertentu.
    - **Format:** Biasanya berbentuk `com.yourcompany.yourappname`. Harus cocok dengan `Bundle Identifier` di Xcode.
  - **Provisioning Profiles (Development, App Store, Ad Hoc):**
    - **Development Provisioning Profile:** Mengizinkan aplikasi yang ditandatangani dengan _development certificate_ untuk berjalan di perangkat terdaftar Anda.
    - **App Store Provisioning Profile:** Digunakan untuk mengirim aplikasi ke App Store Connect untuk ditinjau dan didistribusikan.
    - **Ad Hoc Provisioning Profile:** Untuk distribusi terbatas kepada penguji yang terdaftar.
    - **Cara Membuat:** Melalui Xcode otomatis (`Automatically manage signing`) atau manual di portal Apple Developer.
    - **Pentingnya Otomatisasi (Xcode `Automatically manage signing`):** Xcode dapat mengelola sebagian besar proses ini secara otomatis jika Anda masuk dengan akun Apple Developer Anda.
- **Build Release `IPA` (iOS App Store Package):**
  - **Perintah `flutter build ipa`:**
    - **Deskripsi:** Perintah ini akan membangun aplikasi Flutter Anda untuk iOS dan menghasilkan file `.ipa` yang sudah ditandatangani, siap untuk diunggah ke App Store Connect.
    - **Pentingnya:** Ini adalah format distribusi yang diperlukan untuk App Store.
    - **Output Lokasi:** File `.ipa` yang dihasilkan akan berada di `build/ios/archive/Runner.xcarchive/Products/Applications/`.
  - **Mengunggah ke App Store Connect (Xcode Organizer atau `flutter_fastlane`):**
    - **Xcode Organizer:** Setelah `.ipa` dibangun, Anda dapat menggunakan Xcode's `Window > Organizer` untuk menemukan arsip Anda dan mengunggahnya ke App Store Connect.
    - **`fastlane` (Otomatisasi):** Alat otomatisasi pihak ketiga yang sangat populer untuk mengotomatiskan seluruh proses _build_, _signing_, dan _upload_ ke App Store Connect (akan dibahas lebih lanjut di 18.4).

---

#### 18.3 Building for Web & Desktop

- **18.3.1 Building for Web**

  - **Pengenalan Flutter for Web:**
    - **Deskripsi:** Memahami bagaimana Flutter dapat digunakan untuk membangun aplikasi web yang kaya UI, berkinerja tinggi, dan dapat disematkan di _browser_.
    - **Perbedaan dengan Aplikasi Native:** Fokus pada _rendering_ canvas (HTML/CanvasKit), SEO, PWA (Progressive Web Apps), dan _responsive design_ untuk web.
    - **Kapan Menggunakan:** Untuk _landing page_ yang interaktif, _dashboard_ admin, atau aplikasi yang membutuhkan tampilan dan nuansa konsisten di berbagai platform.
  - **Konfigurasi Proyek Web:**
    - **Mengaktifkan Dukungan Web:** Perintah `flutter config --enable-web`.
    - **Struktur Folder Web (`web/`):** Memahami file `index.html`, `main.dart.js`, dan aset web lainnya.
    - **`index.html` Customization:** Mengubah _title_, menambahkan _meta tags_, menyertakan _script_ eksternal, atau menyisipkan kode Google Analytics.
  - **Optimasi & Build Web:**
    - **Pilihan Renderer (HTML vs CanvasKit):**
      - **HTML Renderer:** Ringan, cocok untuk _low-end devices_, tidak memerlukan WebGL, tetapi mungkin memiliki _fidelity_ visual yang lebih rendah untuk grafis kompleks.
      - **CanvasKit Renderer:** Lebih berat (ukurannya lebih besar karena menyertakan Skia engine), membutuhkan WebGL, tetapi menawarkan _fidelity_ visual yang lebih tinggi dan performa yang lebih baik untuk grafis yang kompleks, mirip dengan pengalaman _native_.
      - **Kapan Menggunakan:** Pilih HTML untuk aplikasi web sederhana atau prioritas ukuran kecil; pilih CanvasKit untuk aplikasi yang kaya grafis atau membutuhkan presisi _pixel-perfect_.
    - **`flutter build web` Command:**
      - **`--release`:** Selalu gunakan ini untuk _build_ produksi untuk optimasi penuh.
      - **`--web-renderer html` / `--web-renderer canvaskit`:** Menentukan _renderer_ yang akan digunakan.
      - **`--csp` (Content Security Policy):** Mengaktifkan mode yang sesuai dengan CSP untuk lingkungan yang ketat.
    - **Deployment:** Meng-_host_ file yang dihasilkan (`build/web/`) di server web statis manapun (misalnya, Firebase Hosting, Netlify, Nginx, Apache).
    - **PWA (Progressive Web App):**
      - **Deskripsi:** Membuat aplikasi web Anda dapat diinstal di perangkat pengguna dan berfungsi seperti aplikasi _native_.
      - **Konfigurasi:** Memanfaatkan `manifest.json` dan _service worker_ (biasanya sudah ada di proyek Flutter Web) untuk fitur _offline_, _add to home screen_, dan _push notifications_.

- **18.3.2 Building for Desktop (Windows, macOS, Linux)**
  - **Pengenalan Flutter for Desktop:**
    - **Deskripsi:** Memahami bagaimana Flutter dapat digunakan untuk membangun aplikasi desktop yang _native-like_ dan berkinerja tinggi.
    - **Kapan Menggunakan:** Untuk aplikasi _standalone_, _utility tools_, atau _desktop apps_ yang membutuhkan UI yang kaya dan konsisten di berbagai OS desktop.
  - **Mengaktifkan Dukungan Desktop:**
    - Perintah `flutter config --enable-windows-desktop`, `flutter config --enable-macos-desktop`, `flutter config --enable-linux-desktop`.
  - **Struktur Proyek Desktop:**
    - Memahami folder `windows/`, `macos/`, `linux/` yang berisi kode _native_ untuk masing-masing platform, mirip dengan `android/` dan `ios/`.
  - **Konfigurasi Spesifik Platform (contoh: Windows `Runner.rc`, macOS `Info.plist`):**
    - **Windows:** Mengonfigurasi ikon aplikasi, metadata, dan properti eksekusi di file sumber daya Windows (`Runner.rc` atau Visual Studio project).
    - **macOS:** Mengonfigurasi `Info.plist` (mirip dengan iOS) untuk izin, kategori aplikasi, ikon, dan lainnya. Mengelola _signing_ dan _notarization_ untuk distribusi macOS.
    - **Linux:** Menyiapkan file `.desktop` dan mengonfigurasi `CMakeLists.txt` untuk pembangunan.
  - **Build Release Executables:**
    - **`flutter build windows`:** Menghasilkan file `.exe` dan aset lainnya yang dapat didistribusikan.
    - **`flutter build macos`:** Menghasilkan file `.app` atau _archive_ (`.dmg`) untuk macOS. Perhatikan _signing_ dan _notarization_ untuk distribusi di macOS App Store atau di luar.
    - **`flutter build linux`:** Menghasilkan _executable_ untuk Linux.
    - **`--release`:** Selalu gunakan ini untuk _build_ produksi.
  - **Distribusi Aplikasi Desktop:**
    - **Windows:** Distribusi melalui installer (`.msi` atau `.exe` installer), atau _zip_ yang dapat dieksekusi.
    - **macOS:** Melalui `.dmg` (Disk Image) atau Mac App Store. Membutuhkan _signing_ dan _notarization_ dari Apple.
    - **Linux:** Melalui _package manager_ (misalnya, `.deb` untuk Debian/Ubuntu, `.rpm` untuk Fedora/RHEL), atau sebagai AppImage/Snap/Flatpak untuk distribusi yang lebih luas.

---

Dengan menguasai pembangunan untuk Web dan Desktop, Anda benar-benar membuka potensi _cross-platform_ Flutter ke tingkat yang lebih tinggi.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-12/README.md
[selanjutnya]: ../bagian-14/README.md

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
