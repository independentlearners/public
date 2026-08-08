## 🌟 **FOUNDATION LEVEL: Memulai Petualangan dengan Dart**

Kita akan mulai dari dasar sekali, ibaratnya ini seperti belajar mengenal huruf dan kata sebelum bisa menulis kalimat.

### 🚀 **Module 1: Lingkungan dan Ekosistem Dart**

Di modul ini, kita akan mengenal Dart, kenapa Dart itu penting, dan bagaimana cara mempersiapkan "markas" kita untuk mulai ngoding (menulis kode) dengan Dart.

---

### **001: Selamat Datang di Dart**

Bayangkan Dart itu seperti sebuah **bahasa khusus** yang dipakai untuk "bicara" dengan komputer. Dengan bahasa ini, kita bisa memberikan perintah agar komputer melakukan sesuatu. Dart diciptakan oleh Google.

**Kenapa Penting?**
Dart ini unik karena bisa dipakai untuk membuat berbagai macam aplikasi:

- **Aplikasi di HP (Android dan iOS):** Ini yang paling populer, terutama berkat **Flutter**.
- **Aplikasi di Website:** Kita bisa membuat tampilan website yang interaktif.
- **Aplikasi di Komputer (Windows, macOS, Linux):** Ya, aplikasi desktop juga bisa.
- **Aplikasi di Server (Backend):** Ini untuk bagian "dapur" dari aplikasi, yang mengurus data dan logika di balik layar.

**Contoh Analogi:**
Bayangkan Dart itu seperti bahasa Inggris. Dengan bahasa Inggris, Anda bisa berbicara dengan orang dari berbagai negara, membaca buku, menulis surat, dan lainnya. Begitu juga Dart, dengan satu bahasa, Anda bisa membuat program untuk berbagai "platform" atau tempat berbeda.

**Contoh Kode Sederhana (dan Penjelasannya):**

```dart
void main() {
  print('Halo, Dunia!');
}
```

**Penjelasan per Sintaks:**

- `void`: Ini sebuah kata kunci khusus fungsi (bagian ini akan kita jelaskan sebentar lagi) dan maksud dari kata kunci ini yaitu tidak akan menghasilkan "nilai balikan" apa pun. Anggap saja seperti Anda memberikan perintah "nyalakan lampu", lampu menyala, tapi tidak ada jawaban lisan yang kembali ke Anda.
- `main()`: Ini adalah bagian paling penting! Semua program Dart **harus** punya bagian `main()`. Anggap saja ini adalah "titik awal" atau "pintu masuk" program Anda. Saat komputer menjalankan program Dart, ia akan selalu mencari dan memulai dari pintu masuk tersebut, itulah `main()`, kode ini desebut _main finction atau fungsi utama_.
- `{ }`: Tanda kurung kurawal ini seperti "sebuah kotak" yang berisi semua perintah yang harus dijalankan di dalam `main()`. Semua perintah di dalam `main()` harus berada di antara buka tutup kurung kurawal `{` dan `}`.
- `print('Halo, Dunia!');`: Ini adalah perintah untuk **menampilkan teks** ke layar.
  - `print`: Ini adalah kata kunci (perintah bawaan) khusus di Dart untuk menampilkan sesuatu di layar, seperti namanya **print** yaitu **mencetak**.
  - `'Halo, Dunia!'`: Ini adalah **teks** yang ingin kita tampilkan. Teks selalu ditulis di antara tanda kutip tunggal (`' '`) atau ganda (`" "`) dan apapun yang di tulis disini maka itu disebut teks meskipun berupa angka, kita akan mendalami bagian ini pada saatnya nanti.
  - `;`: Titik koma ini wajib ada di akhir setiap perintah (setiap baris instruksi) di Dart. Ibaratnya seperti titik di akhir kalimat.

**Jadi, kode di atas berarti:** "Saat program ini dijalankan, tampilkan tulisan 'Halo, Dunia!' ke layar."

---

### **002: Filosofi Dart (Kenapa Pakai Dart?)**

Dart dirancang dengan beberapa filosofi utama:

- **Mudah Dipelajari dan Digunakan:** Sintaksnya (cara penulisannya) mirip dengan bahasa populer lain seperti Java atau JavaScript, jadi lebih mudah bagi yang sudah pernah ngoding atau cepat dipahami bagi pemula.
- **Sangat Produktif:** Ada fitur seperti "Hot Reload" dan "Hot Restart" (khususnya di Flutter) yang membuat proses pengembangan jadi super cepat. Anda ubah kode sedikit, langsung kelihatan hasilnya tanpa perlu menunggu lama. Ini seperti punya pensil dan penghapus ajaib yang langsung mengubah gambar di kertas.
- **Performa Cepat:** Dart bisa dikompilasi (diubah ke bahasa mesin) menjadi kode yang sangat cepat. Ini penting agar aplikasi tidak lambat.
- **Fleksibel untuk Berbagai Platform:** Seperti yang dijelaskan sebelumnya, satu kode Dart bisa jalan di berbagai tempat (HP, web, desktop, server). Ini menghemat waktu dan tenaga karena tidak perlu belajar bahasa berbeda untuk setiap platform.

**Contoh Analogi Produktivitas (Hot Reload):**
Bayangkan Anda sedang melukis. Jika Anda menggunakan cat biasa, setiap kali Anda ingin mengubah warna sedikit, Anda harus menunggu cat kering, lalu mengecat ulang. Tapi dengan Hot Reload, ini seperti Anda punya kuas digital, setiap kali Anda mengubah warna di layar, langsung terlihat perubahan warnanya secara instan tanpa menunggu.

---

### **003: Sejarah & Evolusi Dart**

Dart pertama kali diperkenalkan oleh Google pada tahun **2011**. Awalnya, Dart dibuat untuk menjadi alternatif yang lebih baik daripada JavaScript di web. Namun, seiring waktu, Google menemukan potensi Dart yang jauh lebih besar, terutama dengan munculnya **Flutter** pada tahun 2017. Flutter adalah _framework_ (kerangka kerja) untuk membuat aplikasi multi-platform yang menggunakan Dart sebagai bahasanya. Sejak saat itu, popularitas Dart meroket.

**Perkembangan Penting:**

- **2011:** Diperkenalkan sebagai bahasa web.
- **2017:** Flutter dirilis, membuat Dart menjadi bintang untuk pengembangan aplikasi mobile.
- **2020:** Versi 2.0 dirilis dengan banyak peningkatan, termasuk "Null Safety" (akan kita bahas nanti) yang membuat kode lebih aman dibandingkan JS / JavaScript.

**Kenapa Penting Tahu Sejarah?**
Memahami sejarahnya membantu kita mengerti kenapa Dart punya fitur-fitur tertentu dan bagaimana bahasa ini berkembang untuk memenuhi kebutuhan para developer.

---

### **004: Kenapa Dart Mampu Mengembangkan Banyak Hal (Use Cases)**

Dart sangat fleksibel dan kuat karena bisa diubah menjadi kode yang berjalan di berbagai "platform".

- **Aplikasi Mobile (Android & iOS):** Ini adalah penggunaan paling populer berkat Flutter. Dengan satu kode Dart, Anda bisa membuat aplikasi yang berjalan mulus di iPhone maupun Android.
- **Aplikasi Web:** Anda bisa membuat aplikasi web modern yang cepat dan interaktif menggunakan Dart.
- **Aplikasi Desktop (Windows, macOS, Linux):** Flutter juga memungkinkan Anda membuat aplikasi desktop yang terlihat bagus dan berfungsi di semua sistem operasi utama.
- **Server/Backend:** Dart bisa digunakan untuk membuat server API (Application Programming Interface) yang menjadi "otak" aplikasi. Ini tempat data disimpan dan logika bisnis dijalankan.
- **Command-Line Tools (CLI):** Anda bisa membuat program kecil yang berjalan di terminal komputer (seperti Command Prompt di Windows atau Terminal di macOS/Linux) untuk tugas-tugas aotomasi.

**Contoh Analogi:**
Bayangkan Dart seperti seorang koki serba bisa yang bisa memasak makanan Indonesia, Italia, Jepang, dan Amerika, semuanya dengan resep yang sama. Jadi, Anda tidak perlu memanggil koki berbeda untuk setiap jenis masakan.

---

### **005: Instalasi Dart SDK**

**SDK (Software Development Kit)** adalah "paket alat" yang berisi semua yang Anda butuhkan untuk mulai mengembangkan aplikasi dengan Dart. Ini termasuk:

- **Dart Compiler:** Alat yang mengubah kode Dart Anda menjadi kode yang bisa dimengerti komputer.
- **Dart VM (Virtual Machine):** Lingkungan untuk menjalankan kode Dart Anda (terutama saat pengembangan).
- **Dart Tools:** Berbagai alat bantu lainnya seperti `pub` (untuk mengelola paket) dan `dartfmt` (untuk merapikan kode).

**Cara Instalasi (Ringkasan, detail ada di link):**
Umumnya, Anda bisa menginstal Dart SDK melalui berbagai cara tergantung sistem operasi Anda (Windows, macOS, Linux). Cara paling umum adalah dengan mengunduh installer dari situs resmi Dart atau menggunakan _package manager_ seperti `brew` (untuk macOS).

**Penting:** Setelah instalasi, Anda perlu memastikan Dart "terlihat" oleh sistem operasi Anda. Ini biasanya dilakukan dengan menambahkan lokasi Dart ke dalam **PATH** sistem.

**Contoh Analogi:**
Menginstal Dart SDK itu seperti Anda membeli satu set perkakas lengkap untuk membangun rumah. Di dalamnya sudah ada palu, obeng, meteran, dan semua alat yang Anda butuhkan, itu adalah ketika nantinya kita membuat perintah perintah di terminal untuk melakukan perubahan atau penyesuaian apapun terkait SDK yang kita meliki, biasanya perintahnya diawali dengan `dart` dsb.

---

### **006: DartPad**

DartPad adalah cara paling mudah untuk mencoba Dart **tanpa perlu instalasi apa pun**. Ini adalah editor kode online yang memungkinkan Anda menulis dan menjalankan kode Dart langsung di browser web Anda.

**Kapan Pakai DartPad?**

- **Belajar Cepat:** Sangat cocok untuk pemula yang ingin langsung mencoba kode Dart tanpa ribet instalasi.
- **Eksperimen Cepat:** Jika Anda ingin mencoba potongan kode kecil atau menguji ide singkat, DartPad adalah pilihan yang tepat.
- **Berbagi Kode:** Anda bisa berbagi link kode Anda di DartPad dengan orang lain.

**Cara Menggunakan:**

1.  Buka `https://dartpad.dev/` di browser Anda.
2.  Tulis kode Dart di konsol editor.
3.  Klik tombol "Run" untuk melihat hasilnya.

**Contoh Kode di DartPad:**

```dart
void main() {
  String nama = 'Budi'; // Membuat 'kotak' bernama nama dan mengisi dengan 'Budi'
  int umur = 30; // Membuat 'kotak' bernama umur dan mengisi dengan angka 30

  print('Halo, nama saya $nama dan saya berumur $umur tahun.');
}
```

**Penjelasan Tambahan:**

- `String nama = 'Budi';`: Ini adalah cara membuat **variabel** (kotak penyimpanan data) di Dart.
  - `String`: Ini adalah **Tipe Data / Tanda Pengenal** khusus untuk menyimpan teks (kata atau kalimat).
  - `nama`: Nama dari variabel / kotak kita.
  - `= 'Budi'`: Mengisi variabel `nama` dengan teks `'Budi'`.
- `int umur = 30;`: Sama seperti di atas, tapi untuk angka bulat.
  - `int`: Tipe data untuk menyimpan angka bulat (integer).
  - `umur`: Nama variabel.
  - `=`: simbol ini (disebut operator) adalah bagian penugasan
  - `= 30`: Mengisi variabel `umur` dengan angka `30`.
  - `$nama` dan `$umur`: Ini disebut **variabel interpolation** adalah cara cepat untuk "memasukkan" nilai dari variabel `nama` dan `umur` ke dalam teks yang akan ditampilkan.

**Hasil Output di DartPad:**
`Halo, nama saya Budi dan saya berumur 30 tahun.`

---

### **007: IDE Setup (Menyiapkan Lingkungan Kerja)**

IDE (Integrated Development Environment) adalah "lingkungan kerja" yang lengkap untuk para _programmer_. Ini seperti kantor lengkap dengan meja, kursi, komputer, dan semua alat yang dibutuhkan. IDE populer untuk Dart adalah **Visual Studio Code (VS Code)**.

**Kenapa Pakai IDE?**

- **Editor Kode Canggih:** Membantu Anda menulis kode dengan fitur seperti _auto-completion_ (melengkapi kode secara otomatis), _syntax highlighting_ (mewarnai kode agar mudah dibaca), dan _error checking_ (mendeteksi kesalahan).
- **Debugging:** Membantu Anda menemukan dan memperbaiki kesalahan dalam program.
- **Terintegrasi dengan Tools Lain:** Bisa langsung menjalankan kode, terhubung ke sistem kontrol versi (Git), dll.
- **Ekstensi:** Bisa ditambahkan fitur-fitur baru melalui ekstensi, misalnya ekstensi khusus untuk Dart dan Flutter.

**Langkah Umum Setup VS Code untuk Dart:**

1.  Instal VS Code.
2.  Buka VS Code, pergi ke bagian "Extensions".
3.  Cari dan instal ekstensi **"Dart"** (ini akan otomatis menginstal ekstensi Flutter juga jika Anda membutuhkannya).

**Contoh Analogi:**
DartPad itu seperti Anda mencoba memasak di dapur teman. Sedangkan IDE (VS Code) adalah dapur pribadi Anda yang lengkap dengan semua peralatan profesional.

---

### **008: CLI Tools (Alat Baris Perintah)**

CLI (Command-Line Interface) tools adalah program yang Anda jalankan dengan mengetik perintah di **terminal** (atau Command Prompt/PowerShell di Windows). Dart punya beberapa CLI tools yang sangat berguna:

- `dart`: Perintah utama untuk menjalankan file Dart, membuat proyek baru, dll.
- `pub`: Untuk mengelola paket (library) yang kita gunakan di proyek Dart.
- `dartfmt`: Untuk merapikan format kode Dart secara otomatis.

**Contoh Penggunaan:**

Misalkan Anda sudah menginstal Dart SDK.

1.  Buka terminal/Command Prompt.
2.  Ketik `dart --version` untuk melihat versi Dart yang terinstal.

```bash
dart --version
```

**Output yang Mungkin Anda Lihat:**
`Dart SDK version: 3.4.3 (stable) (Mon Jun 10 16:51:30 2024 +0000) on "windows_x64"`

Ini artinya:

- `dart`: Anda memanggil perintah `dart`.
- `--version`: Ini adalah "flag" atau opsi yang Anda berikan kepada perintah `dart`, yang meminta untuk menampilkan versi.

---

### **009: Dart DevTools**

DevTools adalah serangkaian alat visual yang membantu Anda **menganalisis dan mengoptimalkan** aplikasi Dart (terutama Flutter) Anda. Ini seperti "panel kontrol" yang memberikan informasi detail tentang apa yang sedang terjadi di aplikasi Anda.

**Fitur Utama DevTools:**

- **Inspektur Tata Letak (Layout Inspector):** Melihat bagaimana elemen-elemen di aplikasi Anda disusun.
- **Profiler Kinerja (Performance Profiler):** Mengukur seberapa cepat aplikasi Anda berjalan dan menemukan bagian yang lambat.
- **Debugger:** Membantu melacak kesalahan dalam kode Anda.
- **Inspektur Memori (Memory Inspector):** Melihat penggunaan memori aplikasi Anda.
- **Log Viewer:** Melihat pesan-pesan yang dicetak oleh aplikasi Anda.

**Kapan Digunakan?**
Saat Anda sudah mulai membuat aplikasi yang lebih kompleks dan ingin memastikan aplikasi Anda berjalan dengan lancar dan tanpa masalah.

**Contoh Analogi:**
Jika aplikasi Anda adalah sebuah mobil, DevTools adalah alat diagnostik canggih yang bisa memberitahu Anda seberapa efisien mesin bekerja, apakah ada bagian yang boros bensin, atau di mana letak masalah jika mobil mogok.

---

### **010: pub Package Manager**

Di dunia _programming_, seringkali kita tidak perlu membuat semuanya dari nol. Ada banyak orang yang sudah membuat "paket" atau "library" (kumpulan kode yang siap pakai) yang bisa kita gunakan. **pub** adalah "manajer paket" resmi untuk Dart.

**Apa Itu Paket (Package)?**
Bayangkan Anda ingin membuat kue. Anda tidak perlu membuat tepung, gula, atau telur sendiri. Anda bisa membelinya dari toko. Dalam _programming_, "paket" ini seperti bahan-bahan yang sudah jadi (atau resep siap pakai) yang bisa Anda tambahkan ke proyek Anda.

**Fungsi pub:**

- **Mencari Paket:** Anda bisa mencari paket di `pub.dev` (situs resmi untuk paket Dart).
- **Menginstal Paket:** `pub` akan mengunduh dan menambahkan paket yang Anda butuhkan ke proyek Anda.
- **Mengelola Ketergantungan:** Jika satu paket membutuhkan paket lain untuk bekerja, `pub` akan mengurus semua itu secara otomatis.

**Contoh Penggunaan (dalam file `pubspec.yaml`):**
Setiap proyek Dart punya file bernama `pubspec.yaml`. Ini adalah file konfigurasi di mana Anda mendeklarasikan paket apa saja yang ingin Anda gunakan.

```yaml
# pubspec.yaml
name: my_app
description: A new Dart project.
version: 1.0.0

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  http: ^1.1.0 # Ini adalah paket yang ingin kita gunakan untuk komunikasi internet
  path: ^1.8.0 # Ini adalah paket untuk bekerja dengan jalur file
```

**Penjelasan per Sintaks (`pubspec.yaml`):**

- `name: my_app`: Nama proyek Anda.
- `description: A new Dart project.`: Deskripsi singkat tentang proyek Anda.
- `version: 1.0.0`: Versi proyek Anda.
- `environment:`: Bagian ini menentukan versi Dart SDK yang dibutuhkan oleh proyek Anda.
  - `sdk: '>=3.0.0 <4.0.0'`: Proyek ini membutuhkan Dart SDK versi 3.0.0 atau lebih baru, tapi kurang dari 4.0.0.
- `dependencies:`: Di sinilah Anda mendaftar paket-paket yang ingin Anda gunakan.
  - `http: ^1.1.0`: Ini artinya kita ingin menggunakan paket `http` (untuk komunikasi web), dan versi yang diinginkan adalah 1.1.0 atau yang kompatibel (yaitu, versi yang dimulai dengan 1.x.x).
  - `path: ^1.8.0`: Sama, tapi untuk paket `path`.

Setelah menambahkan ini, Anda tinggal menjalankan perintah di terminal:

```bash
dart pub get
```

Perintah `dart pub get` akan mengunduh semua paket yang terdaftar di `dependencies` dan menyiapkannya untuk digunakan dalam proyek Anda.

---

### **011: Project Structure (Struktur Proyek)**

Ketika Anda membuat proyek Dart baru, Dart akan otomatis membuat struktur folder dan file standar. Ini membantu menjaga proyek Anda terorganisir dan mudah dikelola.

**Struktur Umum Proyek Dart:**

```
my_dart_project/
├── .dart_tool/       # File-file yang dihasilkan secara otomatis oleh Dart (jangan diubah)
├── lib/              # Kode sumber (source code) aplikasi Anda. Ini adalah tempat utama Anda menulis kode.
│   └── main.dart     # File Dart utama, seringkali tempat fungsi main() berada
├── test/             # File-file untuk pengujian (testing) kode Anda
├── .gitignore        # File untuk Git (sistem kontrol versi), memberitahu file mana yang tidak perlu disimpan
├── analysis_options.yaml # Konfigurasi untuk penganalisis kode Dart (untuk menemukan potensi masalah)
├── CHANGELOG.md      # Catatan perubahan versi proyek Anda
├── pubspec.yaml      # File konfigurasi utama proyek Anda (tempat mendeklarasikan paket, dll.)
├── README.md         # File penjelasan proyek Anda (informasi umum)
```

**Penjelasan Singkat:**

- **`lib/`**: Ini adalah folder terpenting di mana sebagian besar kode aplikasi Anda akan berada.
- **`pubspec.yaml`**: Ini adalah "otak" proyek Anda, berisi informasi dasar proyek dan daftar paket yang Anda gunakan.
- **`test/`**: Di sini Anda akan menulis kode untuk menguji apakah program Anda bekerja dengan benar.

**Mengapa Penting?**
Struktur yang konsisten memudahkan Anda dan _developer_ lain untuk memahami dan bekerja di proyek yang sama. Ini seperti memiliki lemari pakaian yang terorganisir, Anda tahu di mana mencari kemeja atau celana.

---

### **012: Dart vs. Bahasa Lain (Perbandingan)**

Dart memiliki beberapa fitur yang membuatnya berbeda dari bahasa pemrograman lain:

- **Optimized for UI (User Interface):** Dart, terutama dengan Flutter, dirancang khusus untuk membangun antarmuka pengguna yang cepat dan indah.
- **Ahead-of-Time (AOT) dan Just-in-Time (JIT) Compilation:** Ini adalah fitur teknis yang sangat penting dan akan dijelaskan lebih lanjut di bagian 013. Singkatnya, Dart bisa diubah menjadi kode yang sangat cepat atau bisa juga diinterpretasikan dengan cepat saat pengembangan.
- **Sound Null Safety:** Ini adalah fitur yang membantu mencegah kesalahan umum (akan dijelaskan di bagian 014).
- **Strongly Typed (Sistem Tipe Kuat):** Setiap variabel memiliki tipe data yang jelas (angka, teks, dll.), yang membantu mencegah kesalahan (akan dijelaskan di bagian 015).

**Perbandingan Singkat:**

| Fitur/Aspek     | Dart (dengan Flutter)                | JavaScript (dengan React/Vue) | Python                           | Java                                  |
| :-------------- | :----------------------------------- | :---------------------------- | :------------------------------- | :------------------------------------ |
| **Fokus Utama** | UI Lintas Platform                   | Web (depan/belakang)          | Data Science, AI, Web (belakang) | Aplikasi Enterprise, Android (native) |
| **Kompilasi**   | JIT (dev), AOT (prod)                | Interpretasi / JIT            | Interpretasi                     | JIT                                   |
| **Tipe Data**   | Kuat (Strongly Typed)                | Dinamis                       | Dinamis                          | Kuat (Strongly Typed)                 |
| **Null Safety** | Ya (Sound Null Safety)               | Tidak (atau dengan TS)        | Tidak                            | Tergantung versi/implementasi         |
| **Komunitas**   | Berkembang Pesat (khususnya Flutter) | Sangat Besar                  | Sangat Besar                     | Besar dan Mature                      |

**Analogi:**
Memilih bahasa pemrograman itu seperti memilih alat transportasi.

- **Dart + Flutter:** Mobil listrik modern, efisien, bisa dipakai di berbagai medan (kota, desa), cepat, dan ramah lingkungan.
- **JavaScript:** Sepeda motor, sangat populer, lincah, tapi kadang perlu penyesuaian khusus untuk medan yang berbeda.
- **Python:** Kereta api, sangat kuat untuk membawa banyak penumpang/data, tapi jalurnya spesifik.
- **Java:** Bus besar, handal, bisa membawa banyak orang, sudah lama ada dan teruji.

---

### **013: JIT vs. AOT (Mode Eksekusi Kode)**

Ini adalah dua cara berbeda bagaimana kode Dart bisa dijalankan:

- **JIT (Just-in-Time) Compilation:**

  - **Apa itu?** Kode Dart diubah ke kode yang bisa dimengerti komputer **saat program sedang berjalan**.
  - **Kapan Digunakan?** Saat Anda sedang **mengembangkan** aplikasi.
  - **Keuntungan:** Memungkinkan fitur **"Hot Reload"** dan **"Hot Restart"** yang super cepat di Flutter. Anda ubah kode sedikit, hasilnya langsung kelihatan dalam hitungan detik. Ini membuat proses pengembangan sangat efisien.
  - **Kekurangan:** Performa bisa sedikit lebih lambat karena kompilasi dilakukan "on the fly".

- **AOT (Ahead-of-Time) Compilation:**
  - **Apa itu?** Kode Dart diubah ke kode yang bisa dimengerti komputer **sebelum program dijalankan** (saat Anda ingin membuat aplikasi final).
  - **Kapan Digunakan?** Saat Anda ingin **merilis aplikasi** Anda ke pengguna (misalnya, di Play Store atau App Store).
  - **Keuntungan:** Menghasilkan kode yang sangat **cepat dan efisien** karena semua proses kompilasi sudah selesai di awal. Ukuran aplikasi juga bisa lebih kecil.
  - **Kekurangan:** Tidak ada Hot Reload/Hot Restart karena kode sudah dikompilasi sepenuhnya.

**Analogi:**

- **JIT (Just-in-Time):** Anda sedang belajar memasak. Setiap kali Anda mengikuti langkah resep, Anda langsung memotong bawang, mengiris daging, dan memasaknya saat itu juga. Cepat untuk latihan.
- **AOT (Ahead-of-Time):** Anda ingin menjual masakan. Anda sudah menyiapkan semua bahan, memotong, mengiris, dan memasak semuanya terlebih dahulu menjadi makanan jadi, baru kemudian siap disajikan. Ini lebih efisien untuk produksi massal.

---

### **014: Null Safety (Keamanan Null)**

Ini adalah fitur modern di Dart yang sangat penting untuk mencegah kesalahan umum.

**Apa Itu 'Null'?**
Dalam _programming_, `null` itu artinya "tidak ada nilai" atau "kosong". Bayangkan Anda punya kotak, tapi kotak itu kosong. Jika Anda mencoba mengambil sesuatu dari kotak yang kosong, maka Anda akan mendapatkan masalah (program bisa error atau _crash_). Ini disebut **"Null Pointer Exception"** atau **"Null Reference Error"**.

**Bagaimana Dart Mengatasi Ini dengan Null Safety?**
Dart dengan "Sound Null Safety" memastikan bahwa:

1.  Secara _default_, semua variabel **tidak boleh** `null`. Jadi, jika Anda membuat kotak, Anda harus langsung mengisinya.
2.  Jika Anda memang ingin sebuah variabel boleh `null`, Anda harus **secara eksplisit memberitahu Dart** dengan menambahkan tanda tanya (`?`) setelah tipe datanya.

**Contoh Kode (Sebelum & Sesudah Null Safety):**

**Dart Tanpa Null Safety (Contoh di masa lalu, atau bahasa lain tanpa fitur ini):**

```dart
// Ini bisa menyebabkan error di masa depan!
String nama; // Variabel 'nama' belum diisi, bisa jadi null
print(nama.length); // Akan error karena 'nama' kosong, tidak punya panjang
```

**Dart Dengan Null Safety (Modern Dart):**

```dart
void main() {
  // Contoh 1: Variabel yang TIDAK boleh null (default)
  String nama = 'Alice'; // Harus langsung diisi, tidak boleh kosong
  // String nama_lain; // ERROR! Ini tidak boleh karena 'nama_lain' tidak diisi dan tidak diizinkan null

  print(nama.length); // Aman, 'nama' pasti ada isinya

  // ---

  // Contoh 2: Variabel yang BOLEH null (ditandai dengan '?')
  String? nama_opsional; // Variabel ini boleh kosong (null)
  print(nama_opsional); // Output: null

  nama_opsional = 'Bob'; // Sekarang ada isinya
  print(nama_opsional); // Output: Bob

  // Jika Anda ingin menggunakan variabel yang bisa null, Anda harus hati-hati:
  if (nama_opsional != null) { // Cek dulu apakah tidak null
    print(nama_opsional.length); // Baru bisa menggunakan properti .length
  } else {
    print('Nama opsional kosong.');
  }
}
```

**Penjelasan per Sintaks:**

- `String nama = 'Alice';`: Di sini, variabel `nama` harus selalu berisi teks (tipe `String`). Anda tidak bisa meninggalkannya kosong atau mengisinya dengan `null`. Ini adalah **keamanan default**.
- `String? nama_opsional;`: Tanda tanya `?` setelah `String` memberitahu Dart bahwa variabel `nama_opsional` ini **boleh berisi teks, atau boleh juga kosong (null)**.
- `if (nama_opsional != null)`: Ini adalah **cara aman** untuk bekerja dengan variabel yang bisa `null`. Kita memeriksa dulu apakah `nama_opsional` _tidak_ kosong (`!= null`) sebelum mencoba menggunakannya. Jika kosong, kita akan mendapatkan masalah.

**Kenapa Ini Penting?**
Null Safety mengurangi banyak kesalahan yang umum terjadi di program. Ini membuat kode Anda lebih stabil, aman, dan mudah ditebak, karena Dart membantu Anda "mencegah" kesalahan sebelum terjadi. Ibaratnya ada penjaga pintu yang tidak membiarkan Anda masuk ke sebuah ruangan kosong.

---

### **015: Sound Type System (Sistem Tipe Kuat)**

Dart adalah bahasa dengan "sistem tipe yang kuat" (Strongly Typed).

**Apa Maksudnya "Sistem Tipe Kuat" (Strongly Typed)?**
Artinya, setiap variabel yang Anda buat di Dart harus memiliki **tipe data yang jelas**. Dan setelah Anda menentukan tipenya, Anda hanya bisa menyimpan nilai yang sesuai dengan tipe tersebut.

**Apa Itu Tipe Data?**
Tipe data adalah kategori untuk jenis nilai yang bisa disimpan oleh variabel. Misalnya:

- **Angka Bulat (Integer):** `10`, `500` (tipe `int`)
- **Angka Pecahan (Double):** `3.14`, `0.5` (tipe `double`)
- **Teks (String):** `'Halo'`, `'Dart Programming'` (tipe `String`)
- **Benar/Salah (Boolean):** `true`, `false` (tipe `bool`)

**Keuntungan Sistem Tipe Yang Kuat:**

- **Deteksi Kesalahan Awal:** Banyak kesalahan bisa dideteksi oleh Dart bahkan sebelum Anda menjalankan program (saat Anda menulis kode), bukan saat program sudah berjalan dan tiba-tiba _crash_.
- **Kode Lebih Jelas:** Dengan tipe yang jelas, kode Anda jadi lebih mudah dibaca dan dipahami oleh Anda sendiri maupun _developer_ lain. Anda tahu persis jenis data apa yang diharapkan oleh sebuah variabel.
- **Performa Lebih Baik:** Dart bisa mengoptimalkan kode lebih baik karena tahu jenis data yang sedang dikerjakan.

**Contoh Kode:**

```dart
void main() {
  // Deklarasi variabel dengan tipe data eksplisit
  int angka = 10;          // Variabel 'angka' hanya bisa menyimpan angka bulat
  String pesan = 'Ini adalah pesan.'; // Variabel 'pesan' hanya bisa menyimpan teks
  bool isAktif = true;     // Variabel 'isAktif' hanya bisa menyimpan nilai true/false

  print(angka);
  print(pesan);
  print(isAktif);

  // Contoh kesalahan (akan ditolak oleh Dart karena beda tipe data):
  // angka = 'dua belas'; // ERROR: Tidak bisa mengisi angka dengan teks
  // pesan = 50;       // ERROR: Tidak bisa mengisi teks dengan angka
}
```

**Penjelasan per Sintaks:**

- `int angka = 10;`: Kita secara eksplisit menyatakan bahwa `angka` adalah variabel yang akan menyimpan **angka bulat (`int`)**. Jadi, Anda tidak bisa mengisi `angka` dengan teks atau nilai `true`/`false` atau `doubel` seperti `5.0`.
- `String pesan = 'Ini adalah pesan.';`: Kita menyatakan bahwa `pesan` akan menyimpan **teks (`String`)**.
- `bool isAktif = true;`: Kita menyatakan bahwa `isAktif` akan menyimpan nilai **benar/salah (`bool`)**.

Jika Anda mencoba melakukan `angka = 'dua belas';`, Dart akan langsung memberitahu Anda bahwa ini adalah kesalahan tipe data, bahkan sebelum Anda mencoba menjalankan program. Ini membantu Anda menghindari banyak masalah di kemudian hari.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../README.md
[selanjutnya]: ../../materi/modul-2/README.md

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
