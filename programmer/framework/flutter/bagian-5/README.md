# [FASE 3: Navigation & Routing][0]

### Overview Fase

**Deskripsi Fase:**
Fase ini berfokus pada mekanisme inti navigasi antar layar dalam aplikasi Flutter. Pembelajar akan memahami bagaimana aplikasi multi-layar bekerja, mulai dari navigasi dasar `push` dan `pop`, penggunaan _named routes_ untuk navigasi yang lebih terstruktur, hingga konsep lanjutan seperti animasi transisi dan _overlays_ UI. Penguasaan navigasi adalah kunci untuk membangun aplikasi yang fungsional dan memiliki pengalaman pengguna yang lancar.

**Tujuan Pembelajaran Fase:**
Setelah menyelesaikan fase ini, peserta akan mampu:

- Menerapkan navigasi antar layar menggunakan `Navigator.push()` dan `Navigator.pop()`.
- Mengelola data yang dikirim antar layar menggunakan argumen rute.
- Menggunakan _named routes_ untuk navigasi yang lebih bersih dan terkelola.
- Memahami dan mengimplementasikan _route generation_ untuk _named routes_ dinamis.
- Menggunakan `Hero` _animation_ untuk transisi visual yang menarik.
- Menampilkan dialog, _bottom sheets_, dan _snackbars_ sebagai bentuk _overlay_ UI.

**Hubungan dengan Fase Sebelumnya:**
Fase ini sangat bergantung pada pemahaman _Widget System_ (Fase 2). Setiap "layar" dalam aplikasi Flutter adalah sebuah _widget_. Pemahaman tentang bagaimana _widget_ dibangun, bagaimana _state_ dikelola, dan bagaimana _layout_ diatur akan menjadi prasyarat untuk merancang dan mengimplementasikan layar-layar yang akan dinavigasikan.

**Durasi Estimasi:** 2-3 minggu

---

Berikut adalah struktur terperinci untuk **FASE 3: Navigation & Routing**:

# FASE 3: Navigation & Routing

## 3. Navigation & Routing

- [3.1 Basic Navigation (Push/Pop)](#31-basic-navigation-pushpop)
  - [3.1.1 Navigator and MaterialPageRoute](#311-navigator-and-materialpageroute)
  - [3.1.2 Passing Data Between Screens (Arguments)](#312-passing-data-between-screens-arguments)
- [3.2 Named Routes](#32-named-routes)
  - [3.2.1 Defining Named Routes (`routes` property)](#321-defining-named-routes-routes-property)
  - [3.2.2 Generating Routes (`onGenerateRoute`)](#322-generating-routes-ongenerateroute)
- [3.3 Advanced Navigation Concepts](#33-advanced-navigation-concepts)
  - [3.3.1 Hero Animations](#331-hero-animations)
  - [3.3.2 Dialogs, Bottom Sheets, and Snackbars (as overlays)](#332-dialogs-bottom-sheets-and-snackbars-as-overlays)

---

### 3.1 Basic Navigation (Push/Pop)

Sub-bagian ini adalah fondasi dari semua navigasi di Flutter. Ini akan memperkenalkan konsep _stack navigasi_ dan metode dasar untuk berpindah antar layar.

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pembelajar akan mempelajari bagaimana Flutter mengelola "halaman" atau "layar" aplikasi sebagai tumpukan (_stack_). Setiap kali Anda "membuka" layar baru, itu didorong (_pushed_) ke atas tumpukan. Ketika Anda "kembali" dari layar, itu ditarik (_popped_) dari tumpukan. Ini akan dijelaskan melalui dua _widget_ utama: `Navigator` (yang mengelola tumpukan) dan `MaterialPageRoute` (yang mendefinisikan transisi antar layar). Penguasaan konsep _push_ dan _pop_ adalah prasyarat untuk semua bentuk navigasi yang lebih canggih di Flutter.

**Konsep Kunci & Filosofi Mendalam:**

- **Stack-based Navigation:** Flutter mengimplementasikan navigasi menggunakan konsep _stack_ (tumpukan). Layar yang sedang aktif selalu berada di paling atas tumpukan.

  - **Filosofi:** Model ini intuitif dan mudah dipahami, mirip dengan bagaimana orang berpikir tentang membuka dan menutup halaman di browser atau aplikasi. Ini juga memungkinkan Flutter untuk mengelola _lifecycle_ layar secara efisien.

- **Imperative Navigation (for basic cases):** Menggunakan `Navigator.push()` dan `Navigator.pop()` adalah bentuk navigasi imperatif di mana Anda secara eksplisit memberitahu `Navigator` untuk melakukan aksi.

  - **Filosofi:** Meskipun Flutter menggunakan UI deklaratif, navigasi seringkali melibatkan aksi yang imperatif sebagai respons terhadap _event_ pengguna. Ini adalah salah satu area di mana pendekatan hibrida paling efektif.

- **Route:** Sebuah "rute" (atau _route_) adalah abstraksi dari sebuah layar atau halaman dalam aplikasi. `MaterialPageRoute` adalah jenis _route_ yang paling umum untuk aplikasi Material Design.

  - **Filosofi:** Memisahkan definisi layar dari navigasi itu sendiri, memungkinkan _reusability_ dan modularitas.

**Visualisasi Diagram Alur/Struktur:**

- Diagram tumpukan (_stack_) dengan beberapa kotak (layar) yang menunjukkan bagaimana layar didorong ke atas (`push`) dan ditarik keluar (`pop`).
- Diagram sederhana yang menunjukkan aplikasi dengan dua layar (Layar A, Layar B) dan panah yang menunjukkan `push` dari A ke B, dan `pop` dari B kembali ke A.

**Hubungan dengan Modul Lain:**
Navigasi adalah jembatan antara berbagai _widget_ dan _state_. Tombol (`ElevatedButton`, `TextButton`) dan _gestures_ akan sering memicu aksi navigasi. Data yang dilewatkan antar layar akan memengaruhi _state_ dan tampilan _widget_ di layar tujuan.

---

#### 3.1.1 Navigator and MaterialPageRoute

Sub-bagian ini akan menyelami detail penggunaan `Navigator` dan `MaterialPageRoute` untuk berpindah antar layar.

**Deskripsi Konkret & Peran dalam Kurikulum:**

- **`Navigator`**: Sebuah _widget_ yang mengelola tumpukan `Route`. Ada satu `Navigator` per `MaterialApp` (atau `CupertinoApp`). Anda berinteraksi dengannya menggunakan metode statis seperti `Navigator.of(context).push()` atau `Navigator.of(context).pop()`.
- **`MaterialPageRoute`**: Sebuah kelas yang membuat `Route` yang menggantikan seluruh layar dengan transisi platform-spesifik (misalnya, geser dari kanan di Android, geser dari kiri di iOS). Anda perlu menyediakan `builder` yang mengembalikan _widget_ untuk layar baru.

Ini adalah metode navigasi paling dasar dan langsung, ideal untuk aplikasi kecil atau untuk memahami konsep inti navigasi.

**Konsep Kunci & Filosofi Mendalam:**

- **`BuildContext` dalam Navigasi:** Setiap _widget_ memiliki `BuildContext`. Untuk melakukan navigasi, Anda perlu `BuildContext` dari _widget_ yang berada di bawah `Navigator` di _widget tree_. `Navigator.of(context)` menggunakan `context` untuk menemukan `Navigator` terdekat di atasnya.

  - **Filosofi:** Menekankan pentingnya `BuildContext` sebagai "handle" ke lokasi _widget_ dalam _tree_ dan bagaimana _widget_ dapat berinteraksi dengan _ancestor_-nya.

- **Transisi Platform-Specific:** `MaterialPageRoute` menyediakan transisi default yang terasa _native_ di Android dan iOS.

  - **Filosofi:** Mengurangi pekerjaan pengembang dalam menciptakan _user experience_ yang konsisten dengan platform, sekaligus memungkinkan kustomisasi jika diperlukan.

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:flutter/material.dart';

// --- Layar Pertama ---
class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layar Pertama'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Anda berada di Layar Pertama.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Sintaks: Navigator.of(context).push(MaterialPageRoute(builder: (context) => YourNewScreen()));
                // 'push' menambahkan rute baru ke atas stack.
                // 'MaterialPageRoute' mendefinisikan rute dan transisi UI.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SecondScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Pergi ke Layar Kedua'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Layar Kedua ---
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layar Kedua'),
        backgroundColor: Colors.green,
        // Tombol kembali (panah) secara otomatis ditambahkan jika ada rute sebelumnya di stack.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Anda berada di Layar Kedua.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Sintaks: Navigator.of(context).pop();
                // 'pop' menghapus rute paling atas dari stack, kembali ke rute sebelumnya.
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Kembali ke Layar Pertama'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FirstScreen(),
  ));
}
```

**Penjelasan Konteks Kode:**

- **`Navigator.of(context)`**: Ini adalah cara untuk mendapatkan instance `Navigator` yang terdekat dengan `context` _widget_ Anda. Ini sangat penting karena operasi navigasi memerlukan `Navigator` untuk mengelola _stack_.
- **`push()`**: Metode ini digunakan untuk menambahkan `Route` baru ke bagian atas tumpukan `Navigator`. Ketika sebuah `Route` didorong, `Navigator` membangun `widget` yang sesuai untuk `Route` tersebut dan menganimasikannya ke dalam tampilan.
- **`MaterialPageRoute`**: Ini adalah implementasi `PageRoute` yang menyediakan transisi visual Material Design dan efek _swiping_ ke belakang (di iOS). Konstruktornya memerlukan parameter `builder` yang merupakan fungsi yang mengembalikan _widget_ untuk layar baru. `builder` menerima `BuildContext` baru untuk _widget_ layar kedua.
- **`pop()`**: Metode ini digunakan untuk menghapus `Route` paling atas dari tumpukan `Navigator`. Ketika sebuah `Route` ditarik, `Navigator` menganimasikannya keluar dari tampilan, dan layar di bawahnya akan terlihat kembali. `AppBar` secara otomatis menambahkan tombol kembali jika ada sesuatu untuk kembali.

**Visualisasi Diagram Alur/Struktur:**

- Animasi singkat yang menunjukkan `FirstScreen` diganti oleh `SecondScreen` dengan transisi geser, lalu `SecondScreen` menghilang dengan transisi geser kembali.
- Representasi visual dari _stack_ navigasi:
  - Awal: `[FirstScreen]`
  - Setelah push: `[FirstScreen, SecondScreen]`
  - Setelah pop: `[FirstScreen]`

**Terminologi Esensial & Penjelasan Detail:**

- **Navigator:** _Widget_ yang mengelola tumpukan `Route`.
- **Route:** Representasi abstrak dari sebuah layar atau halaman.
- **MaterialPageRoute:** Jenis `Route` yang menyediakan transisi Material Design.
- **Push:** Aksi menambahkan `Route` ke tumpukan.
- **Pop:** Aksi menghapus `Route` dari tumpukan.
- **Stack:** Struktur data tumpukan di mana `Route` disimpan.
- **BuildContext:** Handle ke lokasi _widget_ dalam _widget tree_, diperlukan untuk operasi `Navigator`.

**Sumber Referensi Lengkap:**

- [Navigator Class (API Docs)](https://api.flutter.dev/flutter/widgets/Navigator-class.html)
- [MaterialPageRoute Class (API Docs)](https://api.flutter.dev/flutter/material/MaterialPageRoute-class.html)
- [Navigation and routing in Flutter (Official Docs)](https://www.google.com/search?q=https://docs.flutter.dev/data/navigation/navigation-basics)
- [Flutter Navigators in 100 Seconds](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3DR9C5J2P22vQ)

**Tips dan Praktik Terbaik:**

- **Kapan Menggunakan `push()` dan `pop()`?** Ini adalah cara yang baik untuk navigasi sederhana di mana Anda tahu persis ke layar mana Anda akan pergi dan Anda hanya bergerak satu langkah maju atau mundur.
- **Jangan Lupa `BuildContext`**: Pastikan `context` yang Anda gunakan untuk `Navigator.of(context)` adalah `context` dari _widget_ yang berada di bawah `Navigator` di _widget tree_. `BuildContext` yang salah bisa menyebabkan _error_.
- **Pikirkan Stack:** Selalu bayangkan _stack_ layar Anda. Setiap `push` menambah, setiap `pop` mengurangi.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** `Navigator.of(context).push()` gagal atau _crash_ karena `Navigator` tidak ditemukan.

  - **Penyebab:** `BuildContext` yang digunakan tidak memiliki `Navigator` sebagai _ancestor_. Ini sering terjadi jika Anda mencoba memanggil navigasi dari _widget_ yang bukan bagian dari _widget tree_ yang dimulai oleh `MaterialApp` (atau `CupertinoApp`).
  - **Solusi:** Pastikan `MaterialApp` atau `CupertinoApp` adalah _ancestor_ dari _widget_ tempat Anda memanggil navigasi. Untuk _widget_ yang sangat dalam di _tree_, pastikan `context` yang diteruskan adalah yang benar.

- **Kesalahan:** Tidak ada tombol kembali di `AppBar` setelah `push()`.

  - **Penyebab:** Tombol kembali otomatis di `AppBar` hanya muncul jika ada lebih dari satu `Route` di _stack_. Jika `FirstScreen` adalah `home` dari `MaterialApp` dan Anda `push()` ke `SecondScreen`, tombol kembali akan muncul. Tetapi jika Anda `pushReplacement()` atau `popAndPushNamed()` ke `SecondScreen` (yang menghapus `FirstScreen` dari _stack_), maka tidak ada yang bisa dikembalikan, sehingga tidak ada tombol kembali.
  - **Solusi:** Pastikan Anda memahami cara `push()` vs `pushReplacement()`, dll. Jika Anda ingin tombol kembali, pastikan ada `Route` sebelumnya di _stack_. Atau, Anda bisa menambahkan `IconButton` secara manual ke `AppBar` jika diperlukan.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Framework][framework]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../domain-spesifik/README.md
[framework]: ../../../framework/README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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
