> [pro][flash11]

# **[FASE 11: Deployment & Distribution][0]**

Ini adalah fase terakhir dalam siklus hidup pengembangan aplikasi: membawanya dari mesin lokal Anda ke tangan jutaan pengguna di seluruh dunia. Fase ini sangat penting karena menunjukan ketika di mana kode bertemu dengan dunia nyata.

### Daftar Isi

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- **17. App Store Deployment**
  - **17.1. Android Deployment**
    - 17.1.1. Google Play Store Deployment
    - 17.1.2. Alternative Android Stores (Konseptual)
  - **17.2. iOS Deployment**
    - 17.2.1. App Store Connect & TestFlight
  - **17.3. Web & Desktop Deployment**
    - 17.3.1. Web Deployment
    - 17.3.2. Desktop Deployment
- **18. DevOps & Release Management**
  - **18.1. CI/CD Pipeline**
    - 18.1.1. Automated Builds & Release Automation
  - **18.2. Monitoring & Maintenance**
    - 18.2.1. Production Monitoring

</details>

---

### **17. App Store Deployment**

**Deskripsi Konkret & Peran dalam Kurikulum:**
_Deployment_ (penerapan) adalah proses mengambil kode aplikasi Anda yang sudah jadi, mengemasnya ke dalam format rilis yang dapat didistribusikan, dan mengirimkannya ke toko aplikasi (_app store_). _Distribution_ (distribusi) adalah tentang bagaimana toko aplikasi tersebut membuat aplikasi Anda tersedia untuk diunduh oleh pengguna. Fase ini adalah jembatan terakhir antara pengembangan dan pengguna akhir. Menguasai proses ini memastikan aplikasi Anda dapat menjangkau audiensnya dengan lancar dan profesional.

---

#### **17.1. Android Deployment**

##### **17.1.1. Google Play Store Deployment**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Google Play Store adalah platform distribusi utama untuk aplikasi Android. Bagian ini adalah panduan langkah demi langkah untuk mempersiapkan dan mempublikasikan aplikasi Flutter Anda ke Play Store. Ini mencakup proses teknis yang krusial seperti penandatanganan aplikasi (_app signing_) untuk keamanan, pembuatan _build_ rilis yang dioptimalkan, dan tugas-tugas administratif di Google Play Console.

**Konsep Kunci & Filosofi Mendalam:**

- **Build Rilis vs. Debug:** Build yang Anda gunakan untuk pengembangan (_debug build_) berisi banyak alat bantu dan informasi _debugging_ yang membuatnya besar dan kurang berkinerja. **Release Build** adalah versi yang dioptimalkan, di-_obfuscate_, dan "dilucuti" dari semua hal yang tidak perlu, membuatnya kecil dan cepat. Perintah `flutter build` menghasilkan _build_ rilis.
- **App Signing (Penandatanganan Aplikasi):** Ini adalah proses yang **wajib** dilakukan. Anda menandatangani paket aplikasi Anda dengan sebuah kunci digital pribadi. Tujuannya adalah untuk:
  1.  **Membuktikan Kepemilikan:** Hanya Anda yang memiliki kunci pribadi tersebut, sehingga Google dan pengguna tahu bahwa pembaruan aplikasi benar-benar datang dari Anda.
  2.  **Menjamin Integritas:** Tanda tangan digital memastikan bahwa paket aplikasi belum diubah atau dirusak oleh pihak lain sejak Anda membuatnya. **Kehilangan kunci ini berarti Anda tidak akan pernah bisa memperbarui aplikasi Anda lagi.** Sangat penting untuk menyimpannya dengan sangat aman.
- **Android App Bundle (`.aab`) vs. APK (`.apk`):**
  - **APK:** Format tradisional. Satu file APK berisi semua yang dibutuhkan aplikasi untuk berjalan di semua jenis perangkat (berbagai arsitektur CPU dan kepadatan layar). Ini membuatnya besar.
  - **App Bundle (`.aab`):** Format modern yang direkomendasikan Google. Anda mengunggah satu file `.aab` ke Play Store. Kemudian, Play Store secara dinamis akan membuat dan menyajikan APK yang dioptimalkan khusus untuk setiap konfigurasi perangkat pengguna. Ini menghasilkan ukuran unduhan yang jauh lebih kecil. **Selalu gunakan App Bundle.**

**Langkah-langkah Utama untuk Deployment ke Play Store:**

1.  **Siapkan Ikon Aplikasi:** Ganti ikon Flutter default dengan ikon aplikasi Anda menggunakan paket seperti `flutter_launcher_icons`.
2.  **Buat Kunci Penandatanganan (Upload Keystore):**
    - Ini hanya perlu dilakukan **satu kali** seumur hidup aplikasi Anda.
    - Gunakan perintah `keytool` (bagian dari Java Development Kit) untuk menghasilkan file `upload-keystore.jks`.
    - **Simpan file ini dan catat kata sandinya di tempat yang sangat aman\!**
3.  **Konfigurasi Gradle untuk Menggunakan Kunci:**
    - Buat file `android/key.properties` untuk menyimpan informasi rahasia kata sandi (jangan masukkan file ini ke Git).
    - Edit file `android/app/build.gradle` untuk membaca properti dari `key.properties` dan menggunakannya untuk menandatangani _build_ rilis Anda.
4.  **Bangun App Bundle Rilis:**
    - Di terminal, jalankan perintah: `flutter build appbundle`.
    - Ini akan menghasilkan file di `build/app/outputs/bundle/release/app-release.aab`.
5.  **Google Play Console:**
    - Buat akun Google Play Developer (memerlukan biaya pendaftaran satu kali).
    - Buat entri aplikasi baru di konsol.
    - Lengkapi semua informasi yang diperlukan: nama aplikasi, deskripsi, _screenshot_, ikon, kebijakan privasi, rating konten, dll.
    - Buka bagian rilis (misalnya, "Internal testing", "Closed testing", atau "Production").
    - **Unggah file `.aab`** yang telah Anda buat.
    - Google akan memproses _bundle_ tersebut. Setelah selesai, Anda dapat meluncurkan rilis ke target audiens Anda.

### **Representasi Diagram Alur (Proses Deployment Android)**

```
┌────────────────────────────────────────────────────────┐
│  LANGKAH 1 & 2: PERSIAPAN LOKAL (Sekali Seumur Hidup)     │
└───────────────┬────────────────────────────────────────┘
                │
┌───────────────▼──────────────┐   ┌───────────────────────┐
│ flutter_launcher_icons       │   │ keytool (Terminal)      │
│ (Membuat ikon aplikasi)      │   │ (Menghasilkan kunci)    │
└───────────────┬──────────────┘   └──────────┬────────────┘
                │                             │
┌───────────────▼──────────────┐   ┌──────────▼────────────┐
│ android/app/build.gradle     │   │ upload-keystore.jks   │
│ (Konfigurasi penandatanganan)│   │ (SIMPAN DENGAN AMAN!)   │
└──────────────────────────────┘   └───────────────────────┘

┌────────────────────────────────────────────────────────┐
│  LANGKAH 3: BUILD RILIS (Setiap Kali Rilis Baru)         │
└───────────────┬────────────────────────────────────────┘
                │
┌───────────────▼──────────────┐
│ `flutter build appbundle`    │
│ (Perintah di Terminal)       │
└───────────────┬──────────────┘
                │
┌───────────────▼──────────────┐
│ app-release.aab              │
│ (File Hasil Build)           │
└──────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│  LANGKAH 4: PUBLIKASI (di Web)                           │
└───────────────┬────────────────────────────────────────┘
                │
┌───────────────▼──────────────┐
│  Google Play Console         │
│  (Dasbor Web)                │
└───────────────┬──────────────┘
                │ 1. Unggah file `.aab`
                │ 2. Isi detail toko
                │ 3. Kirim untuk ditinjau
┌───────────────▼──────────────┐
│  Pengguna di Seluruh Dunia   │
│  (Mengunduh dari Play Store) │
└──────────────────────────────┘
```

---

##### **17.1.2. Alternative Android Stores (Konseptual)**

- **Deskripsi:** Selain Google Play, ada toko aplikasi lain seperti Amazon Appstore (untuk perangkat Fire), Samsung Galaxy Store, dan Huawei AppGallery.
- **Proses:** Prosesnya secara umum mirip. Alih-alih membuat App Bundle (`.aab`), Anda biasanya akan membuat **APK (`flutter build apk --split-per-abi`)** yang spesifik untuk arsitektur CPU. Anda kemudian mengikuti proses pengunggahan dan pendaftaran di konsol developer masing-masing toko.

---

#### **17.2. iOS Deployment**

##### **17.2.1. App Store Connect & TestFlight**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Mempublikasikan ke App Store milik Apple adalah proses yang lebih ketat dan terstruktur dibandingkan Google Play. Anda **memerlukan perangkat macOS dengan Xcode terinstal** untuk melakukan _build_ dan pengiriman. Bagian ini menjelaskan alur kerja utama, mulai dari konfigurasi proyek di Xcode, manajemen sertifikat, hingga penggunaan TestFlight untuk beta testing sebelum rilis publik.

**Konsep Kunci & Filosofi Mendalam:**

- **Xcode sebagai Pusat Komando:** Meskipun Anda menulis kode di Flutter, Xcode adalah alat yang tak terhindarkan untuk rilis iOS. Ia digunakan untuk mengatur kemampuan (_capabilities_), menandatangani aplikasi, dan mengarsipkannya untuk diunggah.
- **Penandatanganan & Provisioning:** Sistem penandatanganan Apple lebih kompleks. Anda memerlukan:
  1.  **Apple Developer Program Membership:** Program berbayar tahunan.
  2.  **Certificate:** Kunci digital yang membuktikan identitas Anda sebagai developer.
  3.  **App ID:** Identifier unik untuk aplikasi Anda.
  4.  **Provisioning Profile:** File yang "mengikat" sertifikat Anda, App ID, dan daftar perangkat (untuk pengujian) bersama-sama. Xcode modern dapat mengelola sebagian besar proses ini secara otomatis (_Automatically manage signing_).
- **TestFlight:** Ini adalah platform beta testing dari Apple. Sebelum merilis ke publik, Anda mengunggah _build_ Anda ke TestFlight. Anda kemudian dapat mengundang pengguna internal (tim Anda) atau eksternal untuk mengunduh dan menguji aplikasi Anda, serta memberikan umpan balik. Ini adalah langkah yang sangat direkomendasikan.
- **App Review:** Setiap aplikasi dan pembaruan yang dikirimkan ke App Store akan melalui proses peninjauan manual oleh tim Apple untuk memastikan ia mematuhi pedoman kualitas dan keamanan mereka yang ketat (`App Review Guidelines`).

**Langkah-langkah Utama untuk Deployment ke App Store:**

1.  **Konfigurasi Proyek di Xcode:** Buka file `Runner.xcworkspace` di dalam direktori `ios` proyek Anda. Atur _Bundle Identifier_, versi, dan pastikan penandatanganan otomatis diaktifkan.
2.  **Siapkan Ikon Aplikasi:** Gunakan aset Xcode untuk menetapkan semua ukuran ikon yang diperlukan.
3.  **Bangun Arsip Rilis:**
    - Di terminal, jalankan: `flutter build ipa`.
    - Perintah ini akan membuat arsip Xcode (`.xcarchive`).
4.  **Unggah ke App Store Connect (via Xcode atau Transporter):**
    - Buka arsip tersebut di Xcode Organizer. Validasi dan distribusikan ke App Store.
    - Atau, Anda dapat mengekspor `.ipa` dan mengunggahnya menggunakan aplikasi Transporter dari Apple.
5.  **App Store Connect:**
    - Ini adalah dasbor web yang setara dengan Google Play Console.
    - Lengkapi semua metadata aplikasi: nama, deskripsi, _screenshot_ (untuk berbagai ukuran layar iPhone dan iPad), kata kunci, dll.
    - Setelah _build_ selesai diproses, kirimkan ke **TestFlight** untuk pengujian internal/eksternal.
    - Jika sudah siap, kirimkan aplikasi dari TestFlight untuk **App Review**.
    - Setelah disetujui, Anda dapat merilisnya ke App Store.

### **Representasi Diagram Alur (Proses Deployment iOS)**

```
┌────────────────────────────────────────────────────────┐
│  LANGKAH 1 & 2: PERSIAPAN (di macOS)                     │
└───────────────┬────────────────────────────────────────┘
                │
┌───────────────▼──────────────┐
│ `flutter build ipa`          │ // Perintah untuk membuat build rilis
└───────────────┬──────────────┘
                │
┌───────────────▼──────────────┐
│  Xcode (Organizer)           │ // Alat untuk mengelola arsip build
└───────────────┬──────────────┘
                │ 1. Validasi Arsip
                │ 2. Distribusikan ke App Store Connect
┌───────────────▼──────────────┐
│  App Store Connect           │
│  (Dasbor Web)                │
└───────────────┬──────────────┘
      ┌─────────┴─────────┐
      │                   │
┌─────▼─────────────┐ ┌───▼──────────────────┐
│  TestFlight         │ │  Rilis Publik        │
└─────┬─────────────┘ └──────┬───────────────┘
      │                       │
┌─────▼─────────────┐ ┌──────▼───────────────┐
│ Beta Testing        │ │  App Review oleh     │
│ (Internal/Eksternal)│ │  Tim Apple           │
└─────┬─────────────┘ └──────┬───────────────┘
      │                       │ (Jika Disetujui)
      └─────────┬─────────────┘
                │
┌───────────────▼───────────────┐
│  Pengguna di Seluruh Dunia   │
│  (Mengunduh dari App Store)  │
└───────────────────────────────┘
```

---

Kita telah menyelesaikan bagian paling umum dari deployment, yaitu ke toko aplikasi seluler. Sekarang, kita akan melengkapi kemampuan multi-platform Flutter dengan mempelajari cara merilis aplikasi ke platform Web dan Desktop.

---

#### **17.3. Web & Desktop Deployment**

##### **17.3.1. Web Deployment**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Men-deploy aplikasi Flutter ke web berarti membuatnya dapat diakses oleh siapa pun melalui browser tanpa perlu instalasi. Proses ini melibatkan pembuatan _build_ web yang dioptimalkan dan meng-hosting-nya di layanan web. Bagian ini membahas langkah-langkah teknis dan pertimbangan untuk merilis aplikasi web Flutter yang cepat dan dapat ditemukan.

**Konsep Kunci & Filosofi Mendalam:**

- **Web Renderers:** Flutter untuk web memiliki dua _renderer_:
  1.  **HTML Renderer:** Menggunakan kombinasi elemen HTML, CSS, Canvas, dan SVG. Ini menghasilkan ukuran unduhan yang lebih kecil dan kompatibilitas yang lebih baik. Pilihan default.
  2.  **Canvaskit Renderer:** Menggunakan WebAssembly dan WebGL untuk merender Skia (mesin grafis Flutter) langsung di browser. Ini memberikan fidelitas grafis yang lebih tinggi dan performa yang lebih konsisten dengan aplikasi seluler, tetapi dengan ukuran unduhan awal yang lebih besar.
- **PWA (Progressive Web App):** Anda dapat dengan mudah mengkonfigurasi aplikasi web Flutter Anda menjadi PWA. PWA adalah aplikasi web yang dapat "diinstal" ke _home screen_ pengguna, bekerja secara offline (dengan _caching_), dan mengirim notifikasi _push_. Ini menjembatani kesenjangan antara web dan aplikasi _native_.
- **Hosting:** Setelah Anda membangun aplikasi (`flutter build web`), Anda akan mendapatkan sebuah direktori `build/web` yang berisi file-file statis (`index.html`, JavaScript, aset). Anda perlu mengunggah seluruh isi direktori ini ke layanan hosting.

**Langkah-langkah Utama untuk Deployment Web:**

1.  **Konfigurasi `index.html`:** Anda dapat menyesuaikan file `web/index.html` untuk mengubah judul, deskripsi, atau menambahkan tag meta untuk SEO.
2.  **Bangun Aplikasi Web:**
    - Di terminal, jalankan: `flutter build web`.
    - (Opsional) Untuk menggunakan renderer Canvaskit: `flutter build web --web-renderer canvaskit`.
3.  **Pilih Layanan Hosting:**
    - **Firebase Hosting:** Pilihan yang sangat populer dan terintegrasi baik dengan ekosistem Flutter/Firebase. Menyediakan hosting cepat, SSL gratis, dan konfigurasi yang mudah.
    - **Netlify / Vercel:** Pilihan bagus lainnya yang sangat populer di kalangan developer web, terkenal dengan kemudahan penggunaan dan alur kerja CI/CD yang hebat.
    - **GitHub Pages:** Pilihan gratis dan sederhana untuk proyek-proyek sumber terbuka atau portofolio.
4.  **Deploy:** Ikuti instruksi dari penyedia hosting pilihan Anda untuk mengunggah konten dari direktori `build/web`.

### **Representasi Diagram Alur (Proses Deployment Web)**

```
┌────────────────────────────────────────┐
│  Kode Aplikasi Flutter                 │
└───────────────┬────────────────────────┘
                │
┌───────────────▼────────────────────────┐
│  `flutter build web`                   │
│  (Perintah di Terminal)                │
└───────────────┬────────────────────────┘
                │
┌───────────────▼────────────────────────┐
│  Direktori `build/web`                 │
│  (Hasil Build: File Statis)            │
│  ┌───────────────────────────────────┐ │
│  │ index.html                        │ │
│  │ main.dart.js                      │ │
│  │ assets/                           │ │
│  │ manifest.json (untuk PWA)         │ │
│  └───────────────────────────────────┘ │
└───────────────┬────────────────────────┘
                │
┌───────────────▼────────────────────────┐
│  Layanan Hosting (misal, Firebase)     │
│  (Mengunggah direktori `build/web`)    │
└───────────────┬────────────────────────┘
                │
┌───────────────▼────────────────────────┐
│  Pengguna Mengakses Via Browser        │
│  (https://aplikasi-anda.web.app)       │
└────────────────────────────────────────┘
```

---

##### **17.3.2. Desktop Deployment**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Flutter juga mendukung pembuatan aplikasi desktop _native_ untuk Windows, macOS, dan Linux. Proses _deployment_-nya melibatkan pengemasan aplikasi ke dalam format installer atau paket yang dapat didistribusikan yang familiar bagi pengguna di setiap platform.

**Konsep Kunci & Implementasi:**

- **Windows:**
  - Anda dapat membuat file `.exe` yang mandiri.
  - Untuk distribusi yang lebih baik, disarankan menggunakan paket seperti `msix` untuk membuat paket MSIX yang dapat dipublikasikan ke Microsoft Store.
- **macOS:**
  - Anda membangun aplikasi sebagai file `.app`.
  - Untuk distribusi di luar Mac App Store, Anda **harus** melakukan **Notarisasi** dengan Apple. Ini adalah proses otomatis di mana Apple memindai aplikasi Anda untuk komponen berbahaya. Tanpa notarisasi, macOS Gatekeeper akan memblokir pengguna untuk membuka aplikasi Anda.
- **Linux:**
  - Anda dapat mendistribusikannya dalam berbagai format, dengan **Snap** dan **Flatpak** menjadi yang paling umum dan modern.

---

### **18. DevOps & Release Management**

**Deskripsi Konkret & Peran dalam Kurikulum:**
DevOps (Development & Operations) adalah tentang mengotomatiskan dan menyederhanakan proses antara penulisan kode dan pengiriman ke pengguna. Bagian ini membahas otomatisasi proses _build_, tes, dan rilis (CI/CD) serta pemantauan aplikasi setelah dirilis. Ini adalah praktik inti dari tim pengembangan perangkat lunak modern yang memungkinkan rilis yang cepat dan andal.

---

#### **18.1. CI/CD Pipeline**

##### **18.1.1. Automated Builds & Release Automation**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah jantung dari CI/CD. Alih-alih melakukan semua langkah _deployment_ (menjalankan tes, membangun, menandatangani, mengunggah) secara manual di mesin Anda, Anda membuat _script_ otomatis yang melakukan semuanya di server CI/CD setiap kali Anda mendorong kode baru.

**Konsep Kunci & Alat Populer:**

- **Automated Builds:** Server CI/CD (seperti GitHub Actions, Codemagic, Bitrise) akan secara otomatis membangun aplikasi Anda untuk berbagai platform (Android, iOS) setiap kali ada _commit_ baru.
- **Code Signing Automation:** Menyimpan kunci penandatanganan dan sertifikat secara aman di dalam _secrets manager_ milik layanan CI/CD, memungkinkan server untuk menandatangani _build_ rilis Anda secara otomatis.
- **Release Automation (`fastlane`):** Fastlane adalah alat yang sangat kuat yang mengotomatiskan tugas-tugas yang membosankan seperti:
  - Mengambil _screenshot_ secara otomatis.
  - Berinteraksi dengan App Store Connect dan Play Console untuk mengunggah _build_ dan metadata.
  - Mengelola profil _provisioning_.
- **Semantic Versioning:** Praktik standar untuk penomoran versi (misalnya, `1.2.5`). Formatnya: `MAJOR.MINOR.PATCH`.
  - `PATCH`: Untuk perbaikan _bug_ yang kompatibel ke belakang.
  - `MINOR`: Untuk penambahan fungsionalitas baru yang kompatibel ke belakang.
  - `MAJOR`: Untuk perubahan yang tidak kompatibel ke belakang (_breaking changes_).

---

#### **18.2. Monitoring & Maintenance**

##### **18.2.1. Production Monitoring**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pekerjaan tidak selesai setelah aplikasi dirilis. Anda perlu terus memantau kesehatannya di dunia nyata untuk memahami bagaimana pengguna berinteraksi dengannya dan untuk menangani masalah secara proaktif.

**Konsep Kunci & Implementasi:**

- **Real-time Error Tracking:** Ini adalah _crash reporting_ yang telah kita bahas di Fase 10 (Firebase Crashlytics, Sentry). Ini adalah bagian terpenting dari pemantauan produksi.
- **User Analytics (Firebase Analytics, Mixpanel, Amplitude):** Mengumpulkan data anonim tentang bagaimana pengguna menggunakan aplikasi Anda. Pertanyaan apa yang bisa dijawab:
  - Fitur mana yang paling populer?
  - Di bagian mana pengguna paling sering keluar dari aplikasi (_drop-off_)?
  - Bagaimana demografi pengguna Anda?
- **Feature Flags:** Teknik yang memungkinkan Anda untuk mengaktifkan atau menonaktifkan fitur tertentu di aplikasi Anda dari jarak jauh tanpa perlu merilis pembaruan baru. Sangat berguna untuk:
  - Meluncurkan fitur baru secara bertahap ke sebagian kecil pengguna.
  - Segera menonaktifkan fitur jika ditemukan _bug_ kritis.
- **A/B Testing:** Menampilkan dua (atau lebih) versi dari sebuah fitur atau UI ke segmen pengguna yang berbeda untuk mengukur secara statistik versi mana yang berkinerja lebih baik terhadap suatu metrik (misalnya, tingkat konversi).

---

### **Selamat !**

Kita telah secara resmi menyelesaikan **FASE 11: Deployment & Distribution**.

Anda kini telah melengkapi perjalanan dari developer menjadi _publisher_. Anda telah mempelajari seluk-beluk teknis untuk mempersiapkan, menandatangani, dan mengirimkan aplikasi Flutter Anda ke **Google Play Store** dan **Apple App Store**. Anda juga memahami cara merilis aplikasi ke platform **Web** dan **Desktop**.

Lebih jauh lagi, Anda telah diperkenalkan pada praktik **DevOps** modern untuk mengotomatiskan proses rilis melalui **CI/CD** dan pentingnya **pemantauan produksi** untuk menjaga kesehatan aplikasi Anda setelah diluncurkan.

Dengan ini, Anda memiliki pengetahuan _end-to-end_ dari ide awal, pengembangan, pengujian, hingga aplikasi berada di tangan pengguna.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-10/README.md
[selanjutnya]: ../bagian-12/README.md
[flash11]:../../flash/bagian-11/README.md

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
