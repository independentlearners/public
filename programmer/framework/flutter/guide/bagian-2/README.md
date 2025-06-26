## Development Environment Setup

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- [1.2.1 IDE dan Tools Setup](#121-ide-dan-tools-setup)
  - [Instalasi Flutter SDK](#instalasi-flutter-sdk)
  - [Instalasi IDE (Visual Studio Code atau Android Studio)](#instalasi-ide-visual-studio-code-atau-android-studio)
  - [Plugin/Ekstensi Penting](#pluginekstensi-penting)
  - [Konfigurasi Emulator/Simulator](#konfigurasi-emulatorsimulator)

</details>

---

Modul ini adalah langkah praktis pertama bagi setiap pembelajar Flutter. Tanpa lingkungan pengembangan yang benar, mustahil untuk mulai menulis dan menjalankan aplikasi Flutter. Bagian ini akan membimbing pembelajar melalui proses pengaturan semua alat yang diperlukan, mulai dari Flutter SDK hingga IDE dan perangkat _debugging_.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Modul ini secara langsung membahas prasyarat teknis untuk pengembangan Flutter. Pembelajar akan diajari cara mengunduh dan menginstal Flutter SDK, mengkonfigurasi _Integrated Development Environment_ (IDE) pilihan mereka (Visual Studio Code atau Android Studio) dengan _plugin_ yang relevan, serta menyiapkan emulator atau perangkat fisik untuk menguji aplikasi. Selain itu, pembelajar akan diperkenalkan dengan _Command Line Interface_ (CLI) Flutter dan Flutter DevTools, alat-alat esensial untuk mengelola proyek dan melakukan _debugging_ serta _profiling_. Ini adalah fase "persiapan medan perang" yang mutlak diperlukan sebelum melangkah ke penulisan kode.

**Konsep Kunci & Filosofi Mendalam:**

- **SDK (Software Development Kit):** Kumpulan alat perangkat lunak, _library_, dokumentasi, dan _sample code_ yang diperlukan untuk mengembangkan aplikasi untuk platform tertentu. Flutter SDK adalah inti dari lingkungan pengembangan Flutter.

  - **Filosofi:** SDK menyederhanakan proses pengembangan dengan menyediakan semua yang dibutuhkan dalam satu paket, memungkinkan pengembang untuk fokus pada logika aplikasi daripada harus mengumpulkan setiap komponen alat secara terpisah.

- **IDE (Integrated Development Environment):** Aplikasi perangkat lunak yang menyediakan fasilitas komprehensif untuk pengembang perangkat lunak. IDE biasanya terdiri dari editor kode sumber, alat otomatisasi _build_, dan _debugger_.

  - **Filosofi:** IDE bertujuan untuk memaksimalkan produktivitas pengembang dengan mengintegrasikan berbagai alat yang berbeda ke dalam satu antarmuka pengguna yang nyaman dan efisien.

- **CLI (Command Line Interface):** Antarmuka berbasis teks untuk berinteraksi dengan sistem operasi atau program komputer. Dalam konteks Flutter, CLI digunakan untuk membuat, menjalankan, dan mengelola proyek Flutter.

  - **Filosofi:** CLI menyediakan cara yang cepat, efisien, dan otomatis untuk melakukan tugas-tugas berulang, serta memungkinkan skrip dan otomatisasi dalam alur kerja pengembangan.

- **Emulator/Simulator:** Perangkat lunak yang meniru perangkat keras dan lingkungan sistem operasi. Emulator (untuk Android) meniru arsitektur CPU dan periferal, sementara Simulator (untuk iOS) meniru lingkungan perangkat lunak.

  - **Filosofi:** Memungkinkan pengembang untuk menguji aplikasi di berbagai konfigurasi perangkat dan versi OS tanpa memerlukan perangkat fisik yang banyak.

- **DevTools:** Serangkaian alat _debugging_ dan _profiling_ yang kaya fitur, dirancang khusus untuk aplikasi Dart dan Flutter.

  - **Filosofi:** Memungkinkan pengembang untuk memvisualisasikan _widget tree_, memeriksa kinerja UI, melacak penggunaan memori, menganalisis _network requests_, dan men-debug kode secara efektif, yang esensial untuk membangun aplikasi yang _performant_ dan bebas _bug_.

**Visualisasi Diagram Alur/Struktur:**

- Diagram alur instalasi: (Download Flutter SDK -\> Setup Path -\> Install IDE -\> Install Plugins -\> Configure Emulator).
- Ilustrasi antarmuka DevTools yang menunjukkan panel-panel utama (Widget Inspector, Performance, Memory).

**Hubungan dengan Modul Lain:**
Pengaturan lingkungan adalah prasyarat _mutlak_ untuk semua modul selanjutnya. Tanpa ini, pembelajar tidak dapat mempraktikkan apa pun yang mereka pelajari di bagian mana pun dari kurikulum. Penggunaan CLI dan DevTools akan menjadi bagian integral dari proses pengembangan di seluruh fase kurikulum, terutama saat melakukan _debugging_ dan optimasi di fase-fase lanjutan.

---

### 1.2.1 IDE dan Tools Setup

Sub-bagian ini memandu pembelajar melalui langkah-langkah praktis untuk menyiapkan semua perangkat lunak yang diperlukan untuk memulai pengembangan Flutter.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah panduan _hands-on_ untuk menginstal Flutter SDK, memilih dan mengkonfigurasi IDE (Visual Studio Code atau Android Studio), serta menyiapkan perangkat pengujian (emulator/simulator atau perangkat fisik). Setiap langkah dijelaskan secara rinci untuk memastikan pembelajar dapat berhasil menyiapkan lingkungan mereka tanpa hambatan berarti. Bagian ini juga menekankan pentingnya _plugin_ atau ekstensi IDE yang relevan untuk pengalaman pengembangan yang optimal.

**Struktur Pembelajaran Internal:**

- **Instalasi Flutter SDK**
- **Instalasi IDE (Visual Studio Code atau Android Studio)**
- **Plugin/Ekstensi Penting**
- **Konfigurasi Emulator/Simulator**

---

#### Instalasi Flutter SDK

**Deskripsi Konkret & Peran dalam Kurikulum:**
Langkah pertama dan paling fundamental adalah mendapatkan Flutter SDK. SDK ini berisi semua _library_ Dart, _engine_ Flutter, dan alat-alat _command-line_ yang diperlukan untuk membangun aplikasi Flutter. Instalasi yang benar memastikan bahwa sistem Anda dapat mengenali perintah Flutter dan memfungsikan lingkungan pengembangan.

**Konsep Kunci & Filosofi Mendalam:**

- **Path Environment Variable:** Variabel sistem yang menyimpan daftar direktori tempat sistem operasi mencari program yang dapat dieksekusi. Menambahkan _path_ ke direktori `bin` Flutter SDK memungkinkan Anda menjalankan perintah `flutter` dari mana saja di terminal.
  - **Filosofi:** Mempermudah akses ke alat CLI tanpa harus menavigasi ke direktori instalasi setiap saat.

**Sintaks Dasar / Contoh Implementasi Inti:**

1.  **Unduh Flutter SDK:** Kunjungi situs web resmi Flutter dan unduh versi stabil terbaru yang sesuai dengan sistem operasi Anda (Windows, macOS, Linux).

    - [Download Flutter SDK](https://flutter.dev/docs/get-started/install)

2.  **Ekstrak File:** Ekstrak file `.zip` (atau `.tar.xz` untuk Linux/macOS) ke lokasi yang mudah diakses, misalnya `C:\src\flutter` (Windows) atau `~/development/flutter` (macOS/Linux). Jangan ekstrak ke direktori yang memerlukan hak akses khusus seperti `C:\Program Files\`.

3.  **Tambahkan Flutter ke Path Lingkungan Sistem:**

    - **Windows:**
      1.  Cari "Edit the system environment variables".
      2.  Klik "Environment Variables...".
      3.  Di bagian "User variables" atau "System variables", cari variabel bernama `Path`.
      4.  Klik "Edit..." dan tambahkan _path_ ke direktori `bin` dari folder `flutter` Anda (contoh: `C:\src\flutter\bin`).
      5.  Klik OK di semua jendela.
    - **macOS/Linux:**
      1.  Buka terminal.
      2.  Edit file `~/.bashrc`, `~/.zshrc`, atau `~/.profile` (tergantung _shell_ Anda) dengan editor teks (misal: `nano ~/.zshrc`).
      3.  Tambahkan baris berikut di akhir file, sesuaikan _path_ dengan lokasi instalasi Flutter Anda:
          ```bash
          export PATH="$PATH:/path/to/flutter/bin"
          ```
          Contoh: `export PATH="$PATH:$HOME/development/flutter/bin"`
      4.  Simpan file dan tutup editor.
      5.  Muat ulang _shell_ dengan `source ~/.zshrc` (atau file yang sesuai) atau buka terminal baru.

4.  **Verifikasi Instalasi:** Buka terminal baru dan jalankan perintah:

    ```bash
    flutter doctor
    ```

    Perintah ini akan memeriksa lingkungan Anda dan melaporkan apakah ada dependensi yang perlu diinstal atau dikonfigurasi lebih lanjut (misalnya, Android Studio, Xcode, Visual Studio). Output yang sukses akan menunjukkan tanda centang hijau (`[✓]`) untuk komponen yang telah dikonfigurasi dengan benar.

**Visualisasi Diagram Alur/Struktur:**

- Tangkapan layar jendela konfigurasi _environment variable_ di Windows.
- Contoh output `flutter doctor`.

**Terminologi Esensial & Penjelasan Detail:**

- **SDK (Software Development Kit):** Kumpulan alat lengkap untuk mengembangkan aplikasi.
- **Environment Variable:** Variabel sistem yang menyimpan informasi konfigurasi.
- **Path:** Variabel lingkungan yang memberitahu sistem operasi di mana mencari file yang dapat dieksekusi.
- **`flutter doctor`:** Perintah CLI untuk memverifikasi instalasi Flutter dan dependensi lainnya.

**Sumber Referensi Lengkap:**

- [Install Flutter (Official Documentation)](https://flutter.dev/docs/get-started/install)
- [Update your path for Flutter (Official Guide)](https://flutter.dev/docs/get-started/install/windows%23update-your-path)
- [Flutter Doctor Command](https://flutter.dev/docs/reference/flutter-cli%23flutter-doctor)

**Tips dan Praktik Terbaik:**

- **Lokasi Instalasi:** Pilih lokasi instalasi yang singkat dan tidak mengandung spasi atau karakter khusus. Ini akan menghindari potensi masalah _path_ di kemudian hari.
- **Perbarui Path dengan Benar:** Ini adalah langkah paling krusial. Jika `flutter` tidak dikenali di terminal Anda, hampir pasti masalahnya ada di konfigurasi _path_.
- **Jalankan `flutter doctor` Secara Rutin:** Terutama setelah pembaruan Flutter SDK atau perubahan lingkungan, `flutter doctor` adalah teman terbaik Anda untuk memverifikasi semuanya baik-baik saja.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Perintah `flutter` tidak dikenali setelah instalasi.

  - **Penyebab:** _Path environment variable_ tidak diatur dengan benar atau terminal yang digunakan belum me-_refresh_ _path_ yang baru.
  - **Solusi:** Pastikan Anda menambahkan _path_ ke direktori `bin` (misal: `C:\src\flutter\bin`) dan bukan hanya `C:\src\flutter`. Setelah menambahkan _path_, buka terminal _baru_ untuk memastikan perubahan diterapkan. Jika masih bermasalah, coba _restart_ komputer.

- **Kesalahan:** `flutter doctor` melaporkan masalah dengan dependensi (misalnya Android SDK, Android Studio, Xcode).

  - **Penyebab:** Komponen yang diperlukan belum terinstal atau belum dikonfigurasi dengan benar.
  - **Solusi:** Ikuti instruksi yang diberikan oleh `flutter doctor` untuk menginstal atau mengkonfigurasi komponen yang hilang. Misalnya, jika Android Studio belum terdeteksi, instal Android Studio terlebih dahulu.

---

#### Instalasi IDE (Visual Studio Code atau Android Studio)

**Deskripsi Konkret & Peran dalam Kurikulum:**
IDE adalah "rumah" bagi kode Anda. Bagian ini menjelaskan dua pilihan IDE utama untuk pengembangan Flutter: Visual Studio Code (lebih ringan dan fleksibel) dan Android Studio (lebih lengkap, terutama untuk pengembangan Android _native_). Pembelajar akan diajari cara menginstal dan melakukan konfigurasi dasar untuk IDE pilihan mereka.

**Konsep Kunci & Filosofi Mendalam:**

- **IntelliSense/Code Completion:** Fitur IDE yang menyediakan saran kode otomatis saat Anda mengetik, mempercepat penulisan kode dan mengurangi kesalahan.
- **Debugger:** Alat yang memungkinkan Anda menghentikan eksekusi program pada titik tertentu (_breakpoint_) dan memeriksa nilai variabel untuk melacak _bug_.
- **Integrated Terminal:** Terminal yang terintegrasi di dalam IDE, memungkinkan Anda menjalankan perintah CLI tanpa harus beralih aplikasi.

**Sintaks Dasar / Contoh Implementasi Inti:**

1.  **Pilih IDE Anda:**

    - **Visual Studio Code (VS Code):** Pilihan populer karena ringan, cepat, dan sangat dapat disesuaikan dengan ekstensi. Direkomendasikan untuk sebagian besar pengembang Flutter.
    - **Android Studio:** IDE resmi untuk pengembangan Android. Lebih berat, tetapi menyediakan alat yang sangat lengkap, terutama jika Anda juga berencana melakukan pengembangan Android _native_. Menginstal Android Studio juga akan menginstal Android SDK yang diperlukan oleh Flutter.

2.  **Instalasi Visual Studio Code:**

    - Unduh VS Code dari situs web resminya: [Download VS Code](https://code.visualstudio.com/)
    - Ikuti instruksi instalasi untuk sistem operasi Anda.
    - Setelah terinstal, buka VS Code.

3.  **Instalasi Android Studio:**

    - Unduh Android Studio dari situs web resminya: [Download Android Studio](https://developer.android.com/studio)
    - Ikuti instruksi instalasi untuk sistem operasi Anda. Pastikan untuk menginstal semua komponen yang disarankan, termasuk Android SDK, Android SDK Platform-Tools, dan Android Virtual Device (AVD).

**Visualisasi Diagram Alur/Struktur:**

- Tangkapan layar antarmuka VS Code/Android Studio setelah instalasi.

**Terminologi Esensial & Penjelasan Detail:**

- **IDE (Integrated Development Environment):** Lingkungan perangkat lunak yang menyediakan alat pengembangan.
- **Visual Studio Code (VS Code):** Editor kode ringan dan kaya fitur yang populer.
- **Android Studio:** IDE resmi Google untuk pengembangan Android.
- **Android SDK:** Kumpulan alat untuk pengembangan Android.
- **Android Virtual Device (AVD):** Emulator Android.

**Sumber Referensi Lengkap:**

- [Install VS Code (Official Documentation)](https://code.visualstudio.com/docs/setup/setup-overview)
- [Install Android Studio (Official Documentation)](https://developer.android.com/studio/install)

**Tips dan Praktik Terbaik:**

- **Pilih Berdasarkan Kebutuhan:** Jika Anda baru memulai dan ingin lingkungan yang cepat, VS Code adalah pilihan yang sangat baik. Jika Anda membutuhkan integrasi yang lebih dalam dengan ekosistem Android atau debugging _native_, Android Studio mungkin lebih cocok. Banyak pengembang menggunakan keduanya.
- **Pastikan SDK Terinstal:** Ketika menginstal Android Studio, pastikan Android SDK juga terinstal. Ini adalah salah satu dependensi utama yang diperiksa oleh `flutter doctor`.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Android Studio tidak terdeteksi oleh `flutter doctor`.
  - **Penyebab:** Android Studio tidak terinstal dengan benar atau Android SDK tidak ditemukan.
  - **Solusi:** Pastikan Anda telah menyelesaikan proses instalasi Android Studio sepenuhnya. Di Android Studio, buka **SDK Manager** (File \> Settings \> Appearance & Behavior \> System Settings \> Android SDK) dan pastikan Android SDK Platform dan Android SDK Build-Tools terinstal. Pastikan juga `ANDROID_HOME` _environment variable_ telah diatur, biasanya secara otomatis oleh Android Studio. Anda mungkin perlu menjalankan `flutter doctor --android-licenses` untuk menerima lisensi Android.

---

#### Plugin/Ekstensi Penting

**Deskripsi Konkret & Peran dalam Kurikulum:**
_Plugin_ atau ekstensi adalah tambahan yang memperluas fungsionalitas IDE, memberikan dukungan spesifik untuk Flutter dan Dart, seperti _syntax highlighting_, _code completion_, _debugging_, dan _linting_. Instalasi _plugin_ yang tepat sangat meningkatkan produktivitas pengembang.

**Konsep Kunci & Filosofi Mendalam:**

- **Syntax Highlighting:** Fitur editor yang menampilkan teks sumber, terutama kode, dalam berbagai warna dan font sesuai dengan kategori istilah.
- **Code Linting:** Proses analisis kode sumber untuk menemukan _bug_, kesalahan _style_, dan konstruksi yang mencurigakan.
- **Code Snippets:** Potongan kode yang dapat disisipkan dengan cepat, mempercepat penulisan kode berulang.

**Sintaks Dasar / Contoh Implementasi Inti:**

1.  **Untuk Visual Studio Code:**

    - Buka VS Code.
    - Buka tampilan Extensions (klik ikon persegi di sisi kiri atau tekan `Ctrl+Shift+X`).
    - Cari dan instal ekstensi berikut:
      - **Flutter:** Ekstensi resmi yang menyediakan semua dukungan Flutter (termasuk Dart).
      - **Dart:** Ekstensi ini biasanya terinstal secara otomatis bersama Flutter, tetapi pastikan sudah ada.
    - Setelah instalasi, Anda mungkin diminta untuk me-_restart_ VS Code.

2.  **Untuk Android Studio:**

    - Buka Android Studio.
    - Pergi ke **File \> Settings** (Windows/Linux) atau **Android Studio \> Preferences** (macOS).
    - Pilih **Plugins** di menu samping kiri.
    - Cari dan instal _plugin_ berikut:
      - **Flutter:** _Plugin_ resmi yang menambahkan dukungan Flutter ke Android Studio.
      - **Dart:** _Plugin_ ini adalah dependensi dari _plugin_ Flutter dan akan diinstal secara otomatis bersamanya.
    - Klik Apply, lalu OK, dan _restart_ Android Studio jika diminta.

**Visualisasi Diagram Alur/Struktur:**

- Tangkapan layar halaman _plugin_ di VS Code dan Android Studio yang menunjukkan ekstensi Flutter dan Dart terinstal.

**Terminologi Esensial & Penjelasan Detail:**

- **Plugin/Ekstensi:** Tambahan perangkat lunak yang memperluas fungsionalitas aplikasi utama.
- **Syntax Highlighting:** Fitur yang membuat kode lebih mudah dibaca dengan mewarnai elemen sintaksis.
- **Code Completion:** Saran otomatis untuk nama variabel, fungsi, dll.
- **Linting:** Analisis kode untuk kesalahan dan masalah gaya.

**Sumber Referensi Lengkap:**

- [Install Flutter and Dart plugins (VS Code)](https://www.google.com/search?q=https://flutter.dev/docs/get-started/editor%3Ftab%3Dvscode)
- [Install Flutter and Dart plugins (Android Studio)](https://flutter.dev/docs/get-started/editor?tab=androidstudio)

**Tips dan Praktik Terbaik:**

- **Jaga Tetap Terbarui:** Pastikan _plugin_ Flutter dan Dart Anda selalu diperbarui untuk mendapatkan fitur terbaru dan perbaikan _bug_.
- **Eksplorasi Ekstensi Lain:** Setelah mahir, eksplorasi ekstensi VS Code atau _plugin_ Android Studio lainnya yang dapat meningkatkan alur kerja Anda (misalnya, _Bracket Pair Colorizer_, _Todo Tree_, _GitLens_).

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Fitur seperti _code completion_ atau _Hot Reload_ tidak berfungsi di IDE.
  - **Penyebab:** _Plugin_ Flutter atau Dart tidak terinstal dengan benar, atau IDE tidak mengenali instalasi Flutter SDK.
  - **Solusi:** Pastikan _plugin_ terinstal dan diaktifkan. Jalankan `flutter doctor` di terminal IDE untuk memeriksa apakah ada masalah dengan integrasi SDK. Coba _restart_ IDE.

---

#### Konfigurasi Emulator/Simulator

**Deskripsi Konkret & Peran dalam Kurikulum:**
Setelah IDE siap, langkah selanjutnya adalah menyiapkan tempat untuk menjalankan aplikasi Anda. Bagian ini akan memandu pembelajar dalam mengkonfigurasi emulator Android atau simulator iOS, atau menghubungkan perangkat fisik, untuk menguji aplikasi Flutter yang sedang dikembangkan.

**Konsep Kunci & Filosofi Mendalam:**

- **Emulator (Android):** Perangkat lunak yang meniru perangkat keras perangkat Android.
- **Simulator (iOS):** Aplikasi yang berjalan di macOS yang meniru lingkungan perangkat lunak iOS.
- **ADB (Android Debug Bridge):** Alat _command-line_ yang memungkinkan komunikasi antara komputer pengembangan dan perangkat Android (baik emulator maupun fisik).
- **Xcode (for iOS):** IDE Apple yang diperlukan untuk membangun aplikasi iOS, termasuk menjalankan simulator dan mengelola sertifikat.

**Sintaks Dasar / Contoh Implementasi Inti:**

1.  **Untuk Android Emulator (membutuhkan Android Studio):**

    - Buka Android Studio.
    - Pergi ke **Tools \> Device Manager** (atau AVD Manager di versi lama).
    - Klik "Create Device".
    - Pilih definisi hardware (misalnya Pixel 7).
    - Pilih _System Image_ (versi Android, misal: API Level 34, Android U). Pastikan Anda telah mengunduh _System Image_ yang diperlukan.
    - Klik "Next" dan berikan nama AVD Anda, lalu "Finish".
    - Setelah dibuat, Anda dapat menjalankan emulator dari Device Manager.

2.  **Untuk iOS Simulator (membutuhkan macOS dan Xcode):**

    - **Instal Xcode:** Unduh dan instal Xcode dari Mac App Store. Ini adalah file yang sangat besar (sekitar 30-40 GB) dan membutuhkan waktu.
    - Setelah instalasi, buka Xcode setidaknya sekali untuk menerima persyaratan lisensi.
    - Di terminal, jalankan perintah berikut untuk menginstal alat baris perintah Xcode:
      ```bash
      sudo xcode-select --install
      ```
    - Untuk meluncurkan simulator: Anda dapat membuka Xcode, lalu pilih **Xcode \> Open Developer Tool \> Simulator**. Atau dari terminal:
      ```bash
      open -a Simulator
      ```

3.  **Untuk Perangkat Fisik (Android):**

    - Aktifkan **Developer Options** dan **USB Debugging** di perangkat Android Anda.
      - Biasanya: Pergi ke Settings \> About Phone, lalu ketuk "Build Number" beberapa kali hingga Developer Options aktif. Kemudian, di Settings, cari Developer Options dan aktifkan USB Debugging.
    - Hubungkan perangkat ke komputer Anda menggunakan kabel USB.
    - Di terminal, jalankan `flutter devices` untuk memastikan perangkat Anda terdeteksi.

4.  **Untuk Perangkat Fisik (iOS - membutuhkan macOS dan Xcode):**

    - Di Xcode, buka proyek Flutter Anda (misal: `your_project/ios/Runner.xcworkspace`).
    - Pastikan perangkat Anda terhubung dan terdeteksi di Xcode.
    - Anda mungkin perlu mendaftarkan perangkat Anda di akun pengembang Apple Anda (Developer Account) untuk _deployment_.

**Visualisasi Diagram Alur/Struktur:**

- Tangkapan layar jendela Device Manager Android Studio.
- Tangkapan layar iOS Simulator.
- Tangkapan layar pengaturan Developer Options di perangkat Android.

**Terminologi Esensial & Penjelasan Detail:**

- **Emulator:** Perangkat lunak yang meniru perangkat keras Android.
- **Simulator:** Perangkat lunak yang meniru lingkungan iOS di macOS.
- **AVD (Android Virtual Device):** Konfigurasi emulator Android.
- **Xcode:** IDE Apple untuk pengembangan iOS/macOS.
- **USB Debugging:** Pengaturan di Android yang memungkinkan komputer berkomunikasi dengan perangkat melalui USB untuk _debugging_.
- **`flutter devices`:** Perintah CLI untuk melihat perangkat yang terhubung dan tersedia untuk menjalankan aplikasi Flutter.

**Sumber Referensi Lengkap:**

- [Run Flutter app on Android Emulator](https://www.google.com/search?q=https://flutter.dev/docs/get-started/install/windows%23set-up-your-android-device)
- [Run Flutter app on iOS Simulator](https://www.google.com/search?q=https://flutter.dev/docs/get-started/install/macos%23set-up-the-ios-simulator)
- [Run Flutter app on physical Android device](https://www.google.com/search?q=https://flutter.dev/docs/get-started/install/windows%23set-up-your-android-device)
- [Run Flutter app on physical iOS device](https://www.google.com/search?q=https://flutter.dev/docs/get-started/install/macos%23deploy-to-ios-devices)

**Tips dan Praktik Terbaik:**

- **Gunakan SSD:** Jika Anda menggunakan emulator atau simulator, pastikan komputer Anda memiliki SSD. Ini akan secara dramatis mempercepat waktu _boot_ dan kinerja emulator/simulator.
- **Alokasikan RAM yang Cukup:** Berikan RAM yang cukup untuk emulator/simulator di pengaturannya untuk performa yang lebih baik.
- **Perangkat Fisik Lebih Baik:** Untuk pengalaman pengembangan yang paling akurat, selalu disarankan untuk menguji di perangkat fisik jika memungkinkan.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Emulator/Simulator tidak muncul atau tidak dapat dijalankan.

  - **Penyebab:** Gambar sistem (System Image) untuk AVD belum diunduh, atau pengaturan virtualisasi di BIOS/UEFI komputer belum diaktifkan (untuk emulator Android). Untuk iOS, Xcode atau alat baris perintahnya belum terinstal dengan benar.
  - **Solusi:** Untuk Android, pastikan gambar sistem sudah diunduh di SDK Manager. Periksa apakah virtualisasi (Intel VT-x atau AMD-V) diaktifkan di BIOS/UEFI komputer Anda. Untuk iOS, pastikan Xcode terinstal dan `sudo xcode-select --install` telah dijalankan.

- **Kesalahan:** Perangkat fisik tidak terdeteksi oleh `flutter devices`.

  - **Penyebab:** USB Debugging tidak aktif, kabel USB bermasalah, atau driver USB tidak terinstal (terutama di Windows).
  - **Solusi:** Pastikan USB Debugging aktif di perangkat Anda. Coba kabel USB lain atau port USB lain. Di Windows, Anda mungkin perlu menginstal driver USB universal atau driver khusus dari produsen ponsel Anda.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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
