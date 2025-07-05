> pro

# **[FASE 4: Navigation & Routing][0]**

### Daftar Isi

<details>
  <summary>📃 Struktur Materi</summary>

- **[6. Navigation Architecture](#6-navigation-architecture)**
  - **[6.1. Basic Navigation](#61-basic-navigation)**
    - [6.1.1. Navigator 1.0](#611-navigator-10)
  - **[6.2. Advanced Navigation](#62-advanced-navigation)**
    - [6.2.1. Navigator 2.0 (Router API)](#621-navigator-20-router-api)
    - [6.2.2. GoRouter Implementation](#622-gorouter-implementation)
    - [6.2.3. Auto Route & Code Generation](#623-auto-route--code-generation)
  - **[6.3. Deep Linking & URL Handling](#63-deep-linking--url-handling)**
    - [6.3.1. Web URL Strategies](#631-web-url-strategies)
    - [6.3.2. Mobile Deep Linking](#632-mobile-deep-linking)

---

</details>

### **6. Navigation Architecture**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Navigasi adalah tulang punggung dari alur interaksi pengguna (UX) dalam sebuah aplikasi. Bagian ini mengajarkan cara mengelola tumpukan layar (disebut **Routes**), memungkinkan pengguna untuk berpindah dari satu layar ke layar lain, dan kembali lagi. Menguasai arsitektur navigasi sangat penting untuk membangun aplikasi yang terasa intuitif dan terstruktur, tidak peduli seberapa kompleksnya.

---

#### **6.1. Basic Navigation**

##### **6.1.1. Navigator 1.0**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Navigator 1.0** adalah sistem navigasi imperatif dan berbasis _stack_ (tumpukan) yang telah ada di Flutter sejak awal. Disebut "imperatif" karena Anda secara eksplisit memberikan perintah: "dorong" (`push`) layar baru ke atas tumpukan, atau "keluarkan" (`pop`) layar saat ini dari tumpukan. Ini adalah cara navigasi yang paling sederhana dan paling umum digunakan. Memahaminya adalah prasyarat absolut sebelum melangkah ke sistem yang lebih canggih.

**Konsep Kunci & Filosofi Mendalam:**

- **Navigasi sebagai Tumpukan (Stack):** Bayangkan layar-layar aplikasi Anda seperti tumpukan kartu. Saat Anda membuka layar baru, Anda meletakkan kartu baru di atas tumpukan. Saat Anda menekan tombol "kembali", Anda mengambil kartu teratas dari tumpukan untuk menampilkan kartu di bawahnya. Layar yang pertama kali dibuka adalah dasar dari tumpukan.
- **`Navigator` Widget:** Flutter secara otomatis membungkus aplikasi Anda dengan widget `Navigator`. Widget inilah yang mengelola tumpukan layar tersebut. Anda berinteraksi dengannya melalui metode statis seperti `Navigator.of(context)`.
- **`Route`:** Sebuah `Route` adalah objek yang merepresentasikan satu layar (termasuk UI dan transisi animasinya) di dalam tumpukan `Navigator`. `MaterialPageRoute` adalah implementasi `Route` yang paling umum, yang memberikan transisi sesuai platform (geser ke atas di iOS, memudar di Android).

**Terminologi Esensial & Penjelasan Detil:**

- **`Navigator.push(context, route)`:** Perintah untuk menambahkan `Route` baru ke atas tumpukan, membuat layar baru muncul.
- **`Navigator.pop(context, [result])`:** Perintah untuk menghapus `Route` teratas dari tumpukan, menyebabkan pengguna kembali ke layar sebelumnya. Anda dapat secara opsional mengirimkan data (`result`) kembali ke layar sebelumnya.
- **`MaterialPageRoute`:** Sebuah implementasi `Route` yang membangun layar dengan transisi platform-aware dan membungkusnya dengan konten yang diperlukan.
- **Named Routes (Rute Bernama):** Sebuah cara untuk memberikan nama (seperti `/home` atau `/detail`) ke rute Anda, memungkinkan Anda untuk bernavigasi tanpa perlu membuat `MaterialPageRoute` setiap saat. Ini membantu memisahkan definisi rute dari logika panggilan.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini menunjukkan navigasi dasar dari `LayarA` ke `LayarB` dan kembali lagi sambil mengirim data.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LayarA(), // Layar awal kita
    );
  }
}

// LAYAR PERTAMA
class LayarA extends StatelessWidget {
  const LayarA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layar A')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Pergi ke Layar B'),
          onPressed: () {
            // Aksi Navigasi: Mendorong Layar B ke atas tumpukan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LayarB()),
            );
          },
        ),
      ),
    );
  }
}

// LAYAR KEDUA
class LayarB extends StatelessWidget {
  const LayarB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layar B')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Kembali ke Layar A'),
          onPressed: () {
            // Aksi Navigasi: Mengeluarkan Layar B dari tumpukan
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
```

**Representasi Diagram Alur & Kode:**

- **Diagram Alur Konseptual:**

  ```
  ┌──────────┐         ┌──────────┐
  │  Layar A │  push   │  Layar B │
  │ (Bawah)  ├────────►│  (Atas)  │
  └──────────┘         └──────────┘
        ▲                   │
        │                   │ pop
        └───────────────────┘
  ```

  Diagram ini menunjukkan `Layar A` sebagai dasar tumpukan. Perintah `push` menambahkan `Layar B` di atasnya. Perintah `pop` menghapus `Layar B`, mengembalikan pengguna ke `Layar A`.

- **Representasi Kode:**

  ```
  // Kode di dalam onPressed di Layar A
  Navigator.push( ... MaterialPageRoute(builder: (_) => LayarB()) ... );

  ┌──────────────────────────┐
  │  Navigator.push()        │  // Perintah untuk "mendorong"
  │  (Aksi Navigasi)         │
  └──────────┬───────────────┘
             │
  ┌──────────▼───────────────┐
  │  MaterialPageRoute       │  // "Pembungkus" untuk layar baru
  │  (Objek Route)           │
  └──────────┬───────────────┘
             │
  ┌──────────▼────────────────┐
  │  builder: (_) => LayarB() │  // Fungsi yang membangun UI layar
  │  (Konten Layar)           │
  └───────────────────────────┘
  ```

  Diagram ini memecah perintah navigasi. `Navigator.push` adalah aksinya. `MaterialPageRoute` adalah objek yang mendeskripsikan "bagaimana" layar baru akan ditampilkan. `builder` adalah fungsi yang berisi `Widget` dari layar tujuan itu sendiri (`LayarB`).

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Memanggil `Navigator.of(context)` pada sebuah `context` yang berada di atas `MaterialApp`. Ini akan menyebabkan error "Navigator not found".
- **Solusi:** `Navigator` dibuat oleh `MaterialApp` (atau `CupertinoApp`). Pastikan `context` yang Anda gunakan berasal dari widget yang berada di **dalam** `MaterialApp` (seperti `Scaffold` atau turunannya).
- **Kesalahan:** Pengguna dapat menekan tombol "kembali" berkali-kali dan mengeluarkan layar dari tumpukan yang kosong, menyebabkan aplikasi menjadi hitam atau _crash_.
- **Solusi:** Gunakan `Navigator.canPop(context)` untuk memeriksa apakah aman untuk memanggil `pop` sebelum melakukannya. Untuk mengganti layar saat ini alih-alih menambahkannya (misalnya, setelah login), gunakan `Navigator.pushReplacement()`.

**Sumber Referensi Lengkap:**

- **Cookbook Resmi:** [Navigate to a new screen and back - Flutter Docs](https://docs.flutter.dev/cookbook/navigation/navigation-basics)
- **Video Penjelasan:** [Navigator (Flutter Widget of the Week)](https://www.youtube.com/watch%3Fv%3D_Y_-JJ5sn3g)

---

Kita telah membahas fondasi dan dasar-dasar navigasi imperatif pada Navigator 1.0. Ini adalah sistem yang kuat dan memadai untuk banyak jenis aplikasi.

Selanjutnya, kita akan melihat bagaimana sistem ini berevolusi untuk menangani skenario yang lebih kompleks seperti _nested routing_ dan sinkronisasi URL di web. Ini adalah sistem yang jauh lebih kuat, fleksibel, namun juga lebih kompleks. Sistem ini dirancang khusus untuk mengatasi kelemahan Navigator 1.0 dalam skenario aplikasi modern.

### **6.2. Advanced Navigation**

#### **6.2.1. Navigator 2.0 (Router API)**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Navigator 2.0** (atau **Router API**) adalah sistem navigasi deklaratif yang diperkenalkan Flutter untuk mengatasi kasus-kasus kompleks yang sulit ditangani oleh Navigator 1.0. Kasus utama tersebut adalah sinkronisasi URL di aplikasi web (membuat URL di _address bar_ browser sesuai dengan state aplikasi) dan skenario _nested navigation_ (memiliki navigator di dalam navigator, seperti pada layout tablet dengan _master-detail view_). Perannya dalam kurikulum ini adalah untuk memperkenalkan Anda pada fondasi API navigasi modern di Flutter, yang menjadi dasar bagi semua _package_ navigasi populer seperti GoRouter.

**Konsep Kunci & Filosofi Mendalam:**

- **Declarative vs. Imperative:** Ini adalah perubahan fundamental.

  - **Imperatif (Navigator 1.0):** Anda memberi perintah. "Hai Navigator, **dorong** layar ini\!" (`push`).
  - **Deklaratif (Navigator 2.0):** Anda mendeskripsikan hasilnya. "Hai Flutter, berdasarkan _state_ aplikasi saat ini, tumpukan navigasi **seharusnya adalah** [LayarA, LayarB, LayarC]". Flutter kemudian akan mencari cara paling efisien untuk bertransisi dari tumpukan lama ke tumpukan baru yang Anda deklarasikan.

- **Empat Komponen Utama:** Router API terdiri dari beberapa bagian yang bekerja sama:

  1.  **`RouteInformationParser`:** "Penerjemah". Tugasnya adalah mengambil informasi rute mentah (seperti string URL dari browser, misal `/book/123`) dan mengubahnya menjadi tipe data yang Anda definisikan sendiri (misalnya, objek `AppRoutePath(bookId: 123)`).
  2.  **`RouterDelegate`:** "Otak" atau "Delegasi". Ini adalah bagian terpenting. Ia memegang _state_ aplikasi saat ini, mendengarkan perubahan dari `RouteInformationParser` atau dari dalam aplikasi, dan bertanggung jawab untuk membangun (`build`) widget `Navigator` dengan tumpukan halaman (`List<Page>`) yang benar.
  3.  **`RouteInformationProvider`:** "Pemasok Informasi". Tugasnya adalah menyediakan informasi rute ke `Parser`. Biasanya Anda tidak perlu berinteraksi langsung dengannya.
  4.  **`Router`:** Widget yang mengikat semua komponen ini bersama-sama. Anda biasanya menggunakan konstruktor `MaterialApp.router` untuk mengkonfigurasinya.

- **`Page` sebagai Unit Deklaratif:** Berbeda dengan `Route` di Navigator 1.0, di sini kita menggunakan `Page`. `Page` adalah deskripsi _immutable_ dari sebuah `Route`. Saat `RouterDelegate` membangun ulang, Flutter membandingkan daftar `Page` yang baru dengan yang lama. Perbandingan ini (berdasarkan tipe dan _key_) memungkinkan Flutter untuk menentukan apakah perlu menambah, menghapus, atau memperbarui layar dengan animasi yang tepat.

**Terminologi Esensial & Penjelasan Detil:**

- **`RouterDelegate`:** Kelas inti yang Anda implementasikan. Ia mengubah state aplikasi menjadi `List<Page>`.
- **`RouteInformationParser`:** Kelas yang Anda implementasikan untuk parsing URL menjadi state navigasi.
- **`MaterialApp.router`:** Konstruktor yang digunakan untuk mengaktifkan Navigator 2.0 di aplikasi Anda, yang memerlukan `routerDelegate` dan `routeInformationParser`.

**Sintaks Dasar / Contoh Implementasi Inti:**
Kode Navigator 2.0 asli sangatlah _verbose_ (bertele-tele). Contoh ini disederhanakan secara konseptual untuk menunjukkan bagaimana bagian-bagiannya terhubung, bukan untuk di-copy-paste secara langsung.

```dart
// Konsep ini akan diimplementasikan oleh library seperti GoRouter
// untuk membuatnya jauh lebih sederhana.

// --- 1. Definisikan state aplikasi yang memengaruhi navigasi ---
class AppState extends ChangeNotifier {
  String? _selectedBookId;
  String? get selectedBookId => _selectedBookId;

  void selectBook(String bookId) {
    _selectedBookId = bookId;
    notifyListeners();
  }
}

// --- 2. Implementasikan RouterDelegate ---
class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {

  final AppState appState;
  AppRouterDelegate(this.appState) {
    appState.addListener(notifyListeners); // Dengarkan perubahan state
  }

  @override
  Widget build(BuildContext context) {
    // Bangun Navigator berdasarkan state aplikasi saat ini
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: BookListScreen()), // Selalu ada layar daftar buku
        if (appState.selectedBookId != null)
          MaterialPage(child: BookDetailsScreen(id: appState.selectedBookId!)),
      ],
      onPopPage: (route, result) {
        // Logika saat tombol 'kembali' ditekan
        // ...
        return route.didPop(result);
      },
    );
  }
  // ... metode lainnya ...
}

// --- 3. Konfigurasi di MaterialApp ---
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Navigator 2.0 Demo',
      routerDelegate: AppRouterDelegate(AppState()),
      routeInformationParser: AppRouteInformationParser(),
    );
  }
}
```

**Representasi Diagram Alur & Kode:**

- **Diagram Alur Konseptual:**

  ```
  ┌──────────────────┐      ┌────────────────────────┐      ┌─────────────────┐
  │     URL/OS       ├─────►│ RouteInformationParser ├─────►│  Objek State    │
  │ (misal '/book/1')│      │     (Penerjemah)       │      │ (misal AppPath) │
  └──────────────────┘      └──────────┬─────────────┘      └────────┬────────┘
                                       │                             │
                                       │◄────────────────────────────┘
                                       │
                             ┌─────────▼──────────┐      ┌─────────────────────┐
                             │   RouterDelegate   ├─────►│       UI State      │
                             │       (Otak)       │      │   (ChangeNotifier)  │
                             └─────────┬──────────┘      └─────────────────────┘
                                       │
                             ┌─────────▼────────────┐
                             │   build(Navigator)   │
                             │ dengan [Page1,Page2] │
                             └──────────────────────┘
  ```

  Diagram ini menunjukkan bagaimana informasi (dari URL atau OS) diterjemahkan oleh `Parser` menjadi objek state, yang kemudian digunakan oleh `Delegate` untuk membangun tumpukan `Page` yang sesuai.

- **Representasi Kode:**

  ```
  // Kode di dalam build() method di RouterDelegate
  return Navigator(
    pages: [
      MaterialPage(child: BookListScreen()),
      if (appState.selectedBookId != null)
        MaterialPage(child: BookDetailsScreen(...)),
    ],
    //...
  );

  ┌──────────────────────────┐
  │  if (state berubah)      │  // Kondisi dari state aplikasi
  │  (Logika di Delegate)    │
  └──────────┬───────────────┘
             │
  ┌──────────▼───────────────┐
  │  pages: [ ... ]          │  // Mendeklarasikan tumpukan halaman
  │  (Properti Navigator)    │
  └──────────┬───────────────┘
             │
  ┌──────────▼───────────────┐
  │  MaterialPage            │  // "Pembungkus" deklaratif
  │  (Deskripsi Route)       │
  └──────────┬───────────────┘
             │
  ┌──────────▼───────────────┐
  │ child: BookDetailsScreen │  // Widget UI aktual
  │ (Konten Layar)           │
  └──────────────────────────┘
  ```

  Diagram ini menunjukkan bagaimana logika di dalam `RouterDelegate` secara deklaratif menghasilkan sebuah `List<Page>` yang akan menjadi tumpukan navigasi. Jika `selectedBookId` tidak null, maka daftar `pages` akan berisi dua item. Jika null, hanya berisi satu.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mencoba mengimplementasikan Navigator 2.0 secara manual untuk aplikasi sederhana. Hal ini menyebabkan kerumitan yang luar biasa dan banyak kode _boilerplate_ yang tidak perlu.
- **Solusi:** **Navigator 2.0 adalah API tingkat rendah**. Ia tidak dimaksudkan untuk digunakan secara langsung dalam banyak kasus. Gunakan ini sebagai dasar pemahaman, tetapi untuk implementasi nyata, gunakan _package_ seperti `go_router` yang dibangun di atasnya dan menyembunyikan semua kerumitan ini.
- **Kesalahan:** Bingung di mana menempatkan logika.
- **Solusi:** Ingat pembagian tugasnya: `Parser` hanya menerjemahkan string ke data. `Delegate` adalah otaknya; ia memegang _state_ dan memutuskan halaman mana yang akan ditampilkan.

**Sumber Referensi Lengkap:**

- **Dokumentasi Resmi:** [Learning Flutter's new navigation and routing system](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade) (Artikel panduan utama dari tim Flutter)
- **API Docs:** [Router class - Flutter API](https://api.flutter.dev/flutter/widgets/Router-class.html)

---

Kita telah membahas fondasi teoritis dari navigasi modern di Flutter. Anda sekarang mengerti mengapa API ini ada dan masalah apa yang dipecahkannya.

---

Mengingat kerumitannya, langkah selanjutnya yang paling logis adalah mempelajari _package_ yang menyederhanakannya. Bagian ini akan memahami bahwa Navigator 2.0 API sangat kompleks, komunitas Flutter telah menciptakan berbagai _package_ untuk menyederhanakannya. Yang paling populer dan direkomendasikan secara resmi oleh tim Flutter adalah GoRouter.

### **6.2.2 GoRouter Implementation**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**GoRouter** adalah sebuah _package_ navigasi deklaratif yang dibangun di atas Navigator 2.0. Tujuannya adalah untuk menyembunyikan semua kerumitan `RouterDelegate` dan `RouteInformationParser`, lalu menyediakan API yang sederhana dan berbasis URL untuk mendefinisikan alur navigasi aplikasi. Perannya dalam kurikulum ini adalah sebagai implementasi **praktis dan direkomendasikan** dari navigasi modern di Flutter. Dengan GoRouter, Anda mendapatkan semua kekuatan Navigator 2.0 (seperti _deep linking_ dan sinkronisasi URL web) dengan usaha yang jauh lebih minimal.

**Konsep Kunci & Filosofi Mendalam:**

- **URL-Based Routing (Navigasi Berbasis URL):** Ini adalah filosofi inti GoRouter. Anda berhenti berpikir tentang "mendorong" atau "mengeluarkan" layar, dan mulai berpikir tentang **lokasi** atau **URL** dari state aplikasi saat ini. Setiap layar di aplikasi Anda direpresentasikan oleh sebuah _path_ URL (misalnya, `/`, `/home`, `/settings`, `/users/123`). Navigasi menjadi sesederhana "pergi" (`go`) ke _path_ yang baru.
- **Single Source of Truth untuk Navigasi:** Alamat URL di _browser_ (atau rute internal di aplikasi seluler) menjadi sumber kebenaran tunggal untuk state navigasi. Ini membuat aplikasi lebih prediktif dan mudah di-debug.
- **Konfigurasi Terpusat:** Semua rute aplikasi Anda didefinisikan di satu tempat, yaitu di dalam konstruktor `GoRouter`. Ini membuat struktur navigasi aplikasi menjadi sangat jelas dan mudah dikelola.
- **Parameters dan Type-Safety:** GoRouter memudahkan pengiriman data melalui URL, baik sebagai _path parameters_ (misalnya `/users/:id`) maupun _query parameters_ (`/search?q=flutter`). Data ini dapat diekstrak dengan mudah di layar tujuan.

**Terminologi Esensial & Penjelasan Detil:**

- **`GoRouter`:** Objek utama yang berisi seluruh konfigurasi navigasi Anda. Anda akan memberikannya ke properti `routerConfig` pada `MaterialApp.router`.
- **`GoRoute`:** Objek yang mendefinisikan satu rute. Ia memetakan sebuah `path` (URL) ke sebuah `builder` (fungsi yang mengembalikan widget layar).
- **`GoRouter.of(context)` atau `context.go()`:** Cara modern untuk memicu navigasi. `context.go('/path')` akan membangun ulang tumpukan navigasi agar sesuai dengan _path_ baru (cocok untuk item di `BottomNavigationBar`).
- **`context.push('/path')`:** Mirip dengan `Navigator.push` di Navigator 1.0. Ia akan menambahkan _path_ baru di atas tumpukan saat ini, tanpa menghapus yang lama.
- **Path Parameters:** Bagian dinamis dari sebuah URL, ditandai dengan titik dua (`:`), misalnya `/users/:userId`.
- **Query Parameters:** Parameter key-value di akhir URL, setelah tanda tanya (`?`), misalnya `/search?query=flutter`.
- **`GoRouterState`:** Objek yang tersedia di dalam `builder` sebuah `GoRoute`. Objek ini berisi informasi tentang rute saat ini, termasuk parameter yang diekstrak.
- **`ShellRoute`:** Fitur canggih untuk membuat UI yang persisten (seperti `BottomNavigationBar` atau `Drawer`) yang tidak ikut dibangun ulang saat navigasi terjadi di antara rutan-rutan anaknya.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini menunjukkan aplikasi dengan dua layar: daftar item dan detail item, di mana ID item dikirim melalui _path parameter_.

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 1. Konfigurasi GoRouter. Semua rute didefinisikan di sini.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    // Rute untuk halaman utama
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      // Rute-rute anak (sub-routes)
      routes: <RouteBase>[
        // Rute untuk halaman detail dengan parameter 'itemId'
        GoRoute(
          path: 'details/:itemId', // ':itemId' adalah path parameter
          builder: (BuildContext context, GoRouterState state) {
            // Ekstrak parameter dari state
            final String itemId = state.pathParameters['itemId']!;
            return DetailsScreen(itemId: itemId);
          },
        ),
      ],
    ),
  ],
);

// 2. Gunakan .router constructor dan berikan konfigurasi.
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'GoRouter Demo',
    );
  }
}

// --- Widget Layar ---

// Layar Utama (HomeScreen)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              // 3. Navigasi ke rute detail dengan ID '123'
              onPressed: () => context.go('/details/123'),
              child: const Text('Lihat Detail Item 123'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/details/456'),
              child: const Text('Lihat Detail Item 456'),
            ),
          ],
        ),
      ),
    );
  }
}

// Layar Detail (DetailsScreen)
class DetailsScreen extends StatelessWidget {
  final String itemId;
  const DetailsScreen({super.key, required this.itemId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Menampilkan detail untuk item ID: $itemId', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'), // Kembali ke home
              child: const Text('Kembali ke Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### **Representasi Diagram Alur & Kode GoRouter**

Berikut adalah diagram yang memvisualisasikan struktur dan alur kerja dari contoh kode GoRouter di atas, sesuai dengan format yang Anda minta.

```
┌──────────────────────────────┐
│  MaterialApp.router          │ Pembungkus utama aplikasi.
│  (Titik Awal Konfigurasi)    │─────────┐
│  ┌────────────────────────┐  │         ▼
│  │ routerConfig: _router  │  │ Memberitahu MaterialApp untuk menggunakan
│  │                        │  │ konfigurasi dari objek GoRouter.
│  │ ┌────────────────────┐ │  │
│  │ │ GoRouter           │ │  │
│  │ │ (Otak Routing)     │ │─────┐
│  │ │ ┌────────────────┐ │ │  │  ▼
│  │ │ │ routes: [      │ │ │  │ Berisi daftar semua rute (GoRoute)
│  │ │ │                │ │ │  │ yang dikenali oleh aplikasi.
│  │ │ │   GoRoute(     │ │ │  │
│  │ │ │     path:'/',  │ │ │  │
│  │ │ │     builder:.. │ │ │  │
│  │ │ │     routes: [  │ │ │  │
│  │ │ │      GoRoute() │ │ │  │
│  │ │ │     ]          │ │ │  │
│  │ │ │   )            │ │ │  │
│  │ │ │ ]              │ │ │  │
│  │ │ └────────────────┘ │ │  │
│  │ └────────────────────┘ │  │
│  └────────────────────────┘  │
└──────────────────────────────┘
```

**Penjelasan Diagram:**

1.  **`MaterialApp.router`**: Ini adalah "Induk" paling atas. Alih-alih properti `home`, ia menggunakan `routerConfig` untuk mendelegasikan semua urusan navigasi.
2.  **`GoRouter`**: Ini adalah "Otak" atau konfigurasi pusat. Di sinilah Anda mendefinisikan `routes`, yaitu daftar semua kemungkinan "lokasi" atau URL yang ada di aplikasi Anda.
3.  **`routes: [ ... ]`**: Ini adalah "Daftar Isi" dari aplikasi Anda.
4.  **`GoRoute`**: Setiap entri dalam daftar isi adalah sebuah `GoRoute`.

Mari kita bedah satu `GoRoute` secara lebih detail:

```
┌──────────────────────────────┐
│  GoRoute                     │ Mendefinisikan satu rute tunggal.
│  (Entri Rute)                │─────────┐
│  ┌────────────────────────┐  │         ▼
│  │ path: '/details/:itemId│  │ Pola URL. ':itemId' adalah placeholder
│  │ (Pola URL)             │  │ dinamis (path parameter).
│  └──────────┬─────────────┘  │
│             │                │
│  ┌──────────▼─────────────┐  │
│  │ builder:               │  │
│  │  (context, state) =>   │  │ Fungsi yang akan dipanggil untuk
│  │   DetailsScreen(       │  │ membangun UI layar ini.
│  │    itemId: state.      │  │─────────┐
│  │     pathParameters[...]│  │         ▼
│  │   )                    │  │ state.pathParameters digunakan untuk
│  │ (Pembangun UI)         │  │ mengambil nilai dari placeholder ':itemId'.
│  └────────────────────────┘  │
└──────────────────────────────┘
```

**Alur Kerja Saat Navigasi:**

1.  Pengguna menekan tombol: `context.go('/details/123')` dipanggil.
2.  GoRouter mencari di dalam daftar `routes`-nya, sebuah `GoRoute` yang `path`-nya cocok dengan pola `/details/:itemId`.
3.  GoRouter menemukan `GoRoute` yang cocok.
4.  GoRouter memanggil fungsi `builder` dari `GoRoute` tersebut.
5.  Di dalam `builder`, `GoRouterState` (`state`) akan berisi `pathParameters` dengan nilai `{'itemId': '123'}`.
6.  Nilai `'123'` diekstrak dan diberikan ke konstruktor `DetailsScreen`.
7.  `DetailsScreen` ditampilkan kepada pengguna.

---

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Lupa menyertakan garis miring di awal _path_ saat memanggil `context.go()`, misalnya `context.go('details/123')`.
- **Solusi:** Ini akan menghasilkan rute relatif. Jika Anda berada di `/home` dan memanggil `go('details/123')`, Anda akan diarahkan ke `/home/details/123`. Untuk pergi ke rute absolut, selalu mulai dengan `/`, misalnya `context.go('/details/123')`.
- **Kesalahan:** Path parameter bernilai `null`.
- **Solusi:** `state.pathParameters` mengembalikan `Map<String, String>`. Jika Anda yakin parameter tersebut akan selalu ada (karena pola URL-nya), Anda bisa menggunakan operator `!` (contoh: `state.pathParameters['itemId']!`). Jika opsional, selalu lakukan pengecekan `null`.

**Sumber Referensi Lengkap:**

- **Paket Resmi:** [go_router package - pub.dev](https://pub.dev/packages/go_router)
- **Dokumentasi Resmi Flutter:** [Declarative routing with GoRouter - Flutter Docs](https://docs.flutter.dev/ui/navigation/declarative)

---

Kita telah membahas GoRouter, solusi yang sangat direkomendasikan untuk navigasi di Flutter modern. Anda kini memahami cara kerjanya dan bagaimana ia menyederhanakan Navigator 2.0 API.

Selanjutnya, kita akan melihat alternatif lain yang juga populer dan menggunakan pendekatan yang sedikit berbeda, yaitu berbasis _code generation_.

### **6.2.3. Auto Route & Code Generation**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Auto Route** adalah _package_ navigasi Flutter yang mengambil pendekatan berbeda: ia menggunakan **code generation** untuk menciptakan seluruh logika routing untuk Anda. Alih-alih mendefinisikan rute secara manual dengan string `path`, Anda cukup memberikan anotasi pada kelas-kelas halaman Anda. _Code generator_ kemudian akan membuat kelas _router_ yang sepenuhnya _type-safe_ (aman secara tipe). Perannya dalam kurikulum adalah untuk menunjukkan pendekatan navigasi yang mengutamakan **type-safety** dan mengurangi _boilerplate code_ secara maksimal, menjadikannya pilihan yang sangat kuat untuk proyek besar di mana kesalahan pengetikan nama rute atau parameter dapat menyebabkan _bug_.

**Konsep Kunci & Filosofi Mendalam:**

- **Code Generation sebagai Sumber Kebenaran:** Filosofi utamanya adalah "biarkan mesin yang menulis kode membosankan". Anda fokus pada pembuatan halaman (widget), dan `auto_route_generator` akan menangani pembuatan kelas `AppRouter` yang kompleks, termasuk semua logika untuk _parsing_ parameter, _deep linking_, dan banyak lagi.
- **Type-Safety adalah Raja:** Karena _router_ dibuat secara otomatis, navigasi tidak lagi menggunakan string (`context.go('/details/123')`), melainkan memanggil kelas dan metode yang sudah ada (`_appRouter.push(DetailRoute(itemId: 123))`). Jika Anda salah mengetik nama rute atau tipe parameter, aplikasi Anda tidak akan bisa di-_compile_. Ini secara drastis mengurangi _runtime errors_.
- **Anotasi sebagai Definisi:** Anda tidak lagi membuat daftar `GoRoute`. Sebaliknya, Anda menggunakan anotasi seperti `@RoutePage` di atas kelas widget halaman Anda. Anotasi ini adalah penanda bagi _code generator_.

**Terminologi Esensial & Penjelasan Detil:**

- **`@RoutePage`:** Anotasi yang Anda tempatkan di atas sebuah widget untuk menandainya sebagai sebuah halaman/rute.
- **`@AutoRouterConfig`:** Anotasi yang Anda tempatkan pada sebuah kelas kosong yang akan menjadi konfigurasi _router_ Anda. Di sinilah Anda mendaftarkan semua halaman yang telah Anda tandai dengan `@RoutePage`.
- **`auto_route_generator` & `build_runner`:** Alat-alat yang membaca anotasi Anda dan secara otomatis menghasilkan file `app_router.gr.dart` yang berisi kelas `AppRouter` Anda.
- **`AppRouter`:** Kelas yang dihasilkan secara otomatis, yang Anda gunakan untuk berinteraksi dengan sistem navigasi.
- **`*Route` objects:** Untuk setiap halaman yang Anda anotasi (misal, `DetailsScreen`), _generator_ akan membuat kelas `DetailRoute`. Objek inilah yang Anda gunakan untuk bernavigasi, memungkinkan Anda untuk memberikan argumen dengan cara yang _type-safe_.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini membangun ulang aplikasi daftar/detail, kali ini dengan Auto Route.

**Langkah 1: Definisikan Halaman dengan Anotasi**

```dart
// file: presentation/home_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage() // Tandai sebagai halaman rute
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // ... (isi widget sama seperti sebelumnya) ...
}


// file: presentation/details_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage() // Tandai sebagai halaman rute
class DetailsScreen extends StatelessWidget {
  final String itemId;
  const DetailsScreen({super.key, @PathParam('itemId') required this.itemId});
  // ... (isi widget sama seperti sebelumnya) ...
}
```

**Langkah 2: Konfigurasi Router**

```dart
// file: navigation/app_router.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter_app/presentation/home_screen.dart';
import 'package:flutter_app/presentation/details_screen.dart';

part 'app_router.gr.dart'; // Ini penting!

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    // Daftarkan semua halaman yang sudah dianotasi
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: DetailRoute.page, path: '/details/:itemId'),
  ];
}
```

**Langkah 3: Jalankan Code Generator**
Di terminal, jalankan: `flutter pub run build_runner build --delete-conflicting-outputs`. Ini akan membuat file `app_router.gr.dart`.

**Langkah 4: Hubungkan ke MaterialApp dan Gunakan**

```dart
// file: main.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/navigation/app_router.dart';

// Buat instance dari router yang dihasilkan
final _appRouter = AppRouter();

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan .router constructor dengan router yang dihasilkan
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      title: 'Auto Route Demo',
    );
  }
}

// Cara menggunakannya di HomeScreen
class HomeScreen extends StatelessWidget {
  // ...
  onPressed: () {
    // Navigasi secara type-safe! Tidak ada lagi string.
    _appRouter.push(DetailRoute(itemId: '123'));
  }
  // ...
}
```

---

### **Visualisasi Hasil Kode**

Berikut adalah _mockup_ visual dari UI yang dihasilkan oleh kode di atas.

```
┌──────────────────────────────────┐
│ Tampilan HomeScreen              │
├──────────────────────────────────┤
│ AppBar: [Auto Route Demo]        │
│ -------------------------------- │
│                                  │
│                                  │
│                                  │
│    ┌──────────────────────┐      │
│    │ Lihat Detail Item 123│      │  <-- onPressed: _appRouter.push(DetailRoute(itemId: '123'));
│    └──────────────────────┘      │
│                                  │
│                                  │
│                                  │
└──────────────────────────────────┘

        ↓ (Setelah Tombol Ditekan)

┌──────────────────────────────────┐
│ Tampilan DetailsScreen           │
├──────────────────────────────────┤
│ AppBar: [Auto Route Demo]        │
│ -------------------------------- │
│                                  │
│   Menampilkan detail untuk       │
│   item ID: 123                   │
│                                  │
│    ┌──────────────────────┐      │
│    │       Kembali        │      │  <-- onPressed: _appRouter.pop();
│    └──────────────────────┘      │
│                                  │
└──────────────────────────────────┘

```

### **Representasi Diagram Alur & Kode Auto Route**

```
┌──────────────────────────────┐
│  @RoutePage                  │ // Anotasi di atas kelas Widget.
│  (Penanda Halaman)           │─────────┐
└──────────────┬───────────────┘         ▼
               │                   Memberitahu Code Generator bahwa
┌──────────────▼───────────────┐       widget ini adalah sebuah layar/rute.
│  @AutoRouterConfig           │
│  (Konfigurasi Pusat)         │─────────┐
│  ┌────────────────────────┐  │         ▼
│  │ routes: [              │  │ Di sini Anda mendaftarkan semua
│  │  AutoRoute(            │  │ 'Route' yang akan dibuat,
│  │   page: HomeRoute.page,│  │ memberikan path URL jika perlu.
│  │   initial: true        │  │
│  │   ),                   │  │
│  │ ]                      │  │
│  └────────────────────────┘  │
└──────────────┬───────────────┘
               │
┌──────────────▼───────────────┐
│ flutter pub run build_runner │ // Perintah yang dijalankan di terminal.
│ (Code Generator)             │─────────┐
└──────────────┬───────────────┘         ▼
               │                   Membaca semua anotasi dan menghasilkan
┌──────────────▼───────────────┐       file `app_router.gr.dart`
│  app_router.gr.dart          │
│  (File Hasil Generate)       │
│  ┌────────────────────────┐  │
│  │ class AppRouter ...    │  │
│  │ class HomeRoute ...    │  │ Berisi semua kelas dan logika
│  │ class DetailRoute ...  │  │ routing yang siap pakai.
│  │                        │  │
│  └────────────────────────┘  │
└──────────────┬───────────────┘
               │
┌──────────────▼───────────────┐
│ _appRouter.push(             │ // Cara pemanggilan di UI.
│   DetailRoute(itemId: '123') │─────────┐
│ )                            │         ▼
│ (Navigasi Type-Safe)         │ Memanggil objek yang sudah jadi.
└──────────────────────────────┘       Tidak ada string, aman dari kesalahan ketik.
```

---

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Mendapat error `part 'app_router.gr.dart'` tidak ditemukan.
- **Solusi:** Ini adalah error paling umum. Artinya Anda belum menjalankan _code generator_ atau terjadi kesalahan saat proses _generation_. Jalankan kembali perintah `flutter pub run build_runner build --delete-conflicting-outputs`.
- **Kesalahan:** Setelah menambahkan halaman baru dengan anotasi `@RoutePage`, rutenya tidak ditemukan.
- **Solusi:** Anda tidak hanya harus menganotasi halaman, tetapi juga **mendaftarkannya** di dalam daftar `routes` pada kelas `AppRouter` Anda, lalu jalankan kembali _code generator_.

**Sumber Referensi Lengkap:**

- **Paket Resmi:** [auto_route package - pub.dev](https://pub.dev/packages/auto_route)
- **Dokumentasi Lengkap:** [auto_route - Documentation](https://autoroute.vercel.app/)

---

Kita telah membahas pendekatan _code generation_ dengan Auto Route yang memberikan keuntungan besar dalam hal _type-safety_. Kini kita siap untuk beralih ke bagian terakhir dari fase navigasi, yaitu menangani bagaimana aplikasi kita berinteraksi dengan URL dari luar, seperti dari _browser_ atau aplikasi lain. Ini adalah langkah yang sangat krusial untuk aplikasi modern yang perlu berinteraksi dengan dunia luar.

### **6.3. Deep Linking & URL Handling**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Bagian ini adalah tentang membuat aplikasi Anda menjadi "warga negara" yang baik di ekosistem web dan seluler. **Deep Linking** adalah mekanisme yang memungkinkan URL untuk membuka aplikasi Anda langsung ke konten spesifik, bukan hanya ke halaman utama. Misalnya, mengklik tautan `your-app.com/products/123` akan membuka aplikasi Anda langsung ke halaman detail produk 123. Ini sangat penting untuk kampanye pemasaran, berbagi konten, dan integrasi antar-aplikasi. **URL Handling** adalah aspek teknis yang terkait, terutama di web, tentang bagaimana URL ditampilkan dan dikelola oleh browser.

---

#### **6.3.1. Web URL Strategies**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Saat Anda membangun aplikasi Flutter untuk platform web, Anda harus memutuskan bagaimana URL akan ditampilkan di _address bar_ browser. Flutter menyediakan dua strategi utama. Memilih strategi yang tepat memiliki implikasi signifikan terhadap pengalaman pengguna, _Search Engine Optimization_ (SEO), dan konfigurasi server. Bagian ini penting untuk memastikan aplikasi web Flutter Anda berperilaku seperti situs web modern pada umumnya.

**Konsep Kunci & Filosofi Mendalam:**

- **URL sebagai Refleksi State:** Seperti yang telah kita pelajari di Navigator 2.0, URL harus menjadi cerminan dari state aplikasi saat ini. Strategi URL menentukan _format_ dari cerminan tersebut.

- **Strategi Hash (`#`)**:

  - **Format**: `yourdomain.com/#/users/123`
  - **Cara Kerja**: Ini adalah strategi _default_ dan yang paling lawas. Semua _path_ aplikasi ditempatkan setelah tanda pagar (`#`). Bagi browser, semua yang ada setelah `#` adalah _fragment identifier_ atau "hash". Perubahan pada _hash_ **tidak** menyebabkan _full page reload_. Server web hanya melihat `yourdomain.com/` dan tidak peduli dengan bagian _hash_-nya.
  - **Keuntungan**: Sangat mudah dikonfigurasi. Tidak memerlukan konfigurasi khusus di sisi server. Anda cukup mengunggah file `index.html` dan aset Flutter lainnya, dan semuanya akan berjalan.
  - **Kerugian**: URL terlihat kurang bersih dan "tradisional". Dianggap kurang baik untuk SEO karena beberapa _web crawler_ mungkin tidak mengindeks konten setelah _hash_ dengan baik.

- **Strategi Path (Clean URL)**:

  - **Format**: `yourdomain.com/users/123`
  - **Cara Kerja**: Ini adalah strategi modern yang diharapkan oleh pengguna. URL terlihat bersih tanpa tanda `#`. Namun, ini memerlukan kerja sama dari server. Ketika pengguna me-_refresh_ halaman di `yourdomain.com/users/123`, browser akan membuat permintaan ke server untuk _path_ tersebut. Server Anda **harus** dikonfigurasi untuk selalu merespons dengan file `index.html` utama aplikasi Flutter Anda, tidak peduli apa pun _path_-nya. Flutter kemudian akan mengambil alih, membaca URL, dan menampilkan layar yang benar.
  - **Keuntungan**: URL bersih dan profesional. Jauh lebih baik untuk SEO.
  - **Kerugian**: Memerlukan konfigurasi sisi server (disebut _URL rewriting_). Jika server tidak dikonfigurasi dengan benar, pengguna akan mendapatkan error 404 saat me-_refresh_ halaman.

**Sintaks Dasar / Contoh Implementasi Inti:**
Konfigurasi strategi ini sangat sederhana dan dilakukan sebelum aplikasi dijalankan.

```dart
// file: main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Atau package router lainnya

// Untuk GoRouter
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/users/:id',
      builder: (context, state) => const UserScreen(),
    ),
  ],
);

void main() {
  // PENTING: Panggil ini sebelum runApp()
  // Untuk menghapus '#' dari URL (Strategi Path)
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

  // Jika Anda ingin tetap menggunakan '#' (Strategi Hash)
  // GoRouter.setUrlPathStrategy(UrlPathStrategy.hash); // Ini adalah default

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'URL Strategy Demo',
    );
  }
}

// ... sisa widget (HomeScreen, UserScreen)
```

**Konfigurasi Server untuk Strategi Path (Contoh untuk Firebase Hosting):**
Jika Anda menggunakan Firebase Hosting, Anda hanya perlu menambahkan konfigurasi "rewrites" di file `firebase.json` Anda.

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

Ini memberitahu Firebase: "untuk permintaan apa pun (`**`), layani file `/index.html`".

---

### **Visualisasi Hasil Kode**

Berikut adalah _mockup_ visual dari bagaimana URL akan terlihat di browser untuk kedua strategi saat membuka halaman yang sama.

```
┌────────────────────────────────────────────────────────┐
│  Browser - Strategi Hash (Default)                     │
├────────────────────────────────────────────────────────┤
│  Alamat │ yourdomain.com/#/users/123                   │
│ ------------------------------------------------------ │
│                                                        │
│   ┌──────────────────────────────────────────────┐     │
│   │ Aplikasi Flutter Anda                        │     │
│   │                                              │     │
│   │ Menampilkan detail untuk pengguna ID: 123    │     │
│   └──────────────────────────────────────────────┘     │
│                                                        │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│ Browser - Strategi Path (Clean URL)                    │
├────────────────────────────────────────────────────────┤
│ Alamat │ yourdomain.com/users/123                      │
│ ------------------------------------------------------ │
│                                                        │
│   ┌──────────────────────────────────────────────┐     │
│   │ Aplikasi Flutter Anda                        │     │
│   │                                              │     │
│   │ Menampilkan detail untuk pengguna ID: 123    │     │
│   └──────────────────────────────────────────────┘     │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### **Representasi Diagram Alur & Kode Strategi URL**

```
┌──────────────────────────────┐
│  main()                      │ // Fungsi utama aplikasi.
│  (Titik Awal Eksekusi)       │
└──────────────┬───────────────┘
               │
┌──────────────▼───────────────┐
│  GoRouter.setUrlPathStrategy(│ // Konfigurasi strategi URL.
│    UrlPathStrategy.path      │─────────┐
│  )                           │         ▼
│  (Konfigurasi Pra-Jalan)     │ Ini harus dipanggil sebelum `runApp`
└──────────────┬───────────────┘ untuk memberi tahu Flutter bagaimana
               │                 cara memformat URL di web.
┌──────────────▼───────────────┐
│  runApp(const MyApp())       │ // Menjalankan aplikasi Flutter.
│                              │
└──────────────┬───────────────┘
               │
┌──────────────▼───────────────┐
│  MaterialApp.router(...)     │ // Aplikasi menggunakan router
│  (Aplikasi dengan Router)    │   yang kini sadar akan strategi URL.
└──────────────────────────────┘
```

**Alur Kerja Permintaan (Strategi Path):**

```
┌───────────────┐        ┌─────────────────┐      ┌─────────────────┐
│ Pengguna      │        │ Server Web      │      │ Aplikasi Flutter│
│ (Browser)     ├───────►│ (misal Firebase)├─────►│ (index.html)    │
│ me-refresh di │        │                 │      │                 │
│ /users/123    │        │ Menerima        │      └────────┬────────┘
└───────────────┘        │ permintaan untuk│               │
                         │ path /users/123 │               │
                         └────────┬────────┘               │
                                  │                        │
                         ┌────────▼────────┐               │
                         │ Aturan Rewrite  │               │
                         │ "source": "**"  │               │
                         │ "dest": "/index"│               │
                         └────────┬────────┘               │
                                  │                        │
                         ┌────────▼────────┐               │
                         │ Mengirim        ├───────────────┘
                         │ index.html      │
                         │ kembali ke user │
                         └─────────────────┘

                         ┌─────────────────┐       ┌─────────────────┐
                         │ GoRouter di     ├──────►│ Menampilkan     │
                         │ Flutter membaca │       │ UserScreen      │
                         │ URL /users/123  │       │ dengan id: 123  │
                         └─────────────────┘       └─────────────────┘
```

Diagram ini menjelaskan bagaimana server bekerja sama dengan Flutter untuk strategi _path_. Server tidak mencoba mencari file `/users/123.html`, melainkan selalu menyajikan `index.html`, dan kemudian GoRouter di sisi klien melakukan tugasnya.

**Sumber Referensi Lengkap:**

- **Dokumentasi Resmi:** [strategies on the web - Flutter Docs](https://docs.flutter.dev/development/ui/navigation/url-strategies)
- **Contoh Konfigurasi Server:** [Configuring your web server to host a Flutter app](https://docs.flutter.dev/deployment/web%23configuring-your-web-server-to-host-a-flutter-app)

---

Kita telah membahas bagaimana mengatur perilaku URL di aplikasi web Flutter. Ini adalah langkah penting untuk membuat aplikasi web yang terasa profesional. Selanjutnya, kita akan beralih ke platform seluler dan membahas cara kerja _deep linking_ di Android dan iOS. Dimana kita kita akan fokus pada bagaimana aplikasi seluler kita dapat dibuka secara cerdas melalui tautan. Ini adalah kapabilitas esensial yang menghubungkan aplikasi Anda dengan ekosistem digital yang lebih luas, seperti email, situs web, dan aplikasi lainnya.

### **6.3.2. Mobile Deep Linking**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Mobile Deep Linking** adalah sebuah teknologi yang memungkinkan tautan web (seperti `https://your-brand.com/orders/54321`) untuk membuka aplikasi seluler Anda secara langsung ke konten yang spesifik (dalam hal ini, halaman detail pesanan 54321), alih-alih hanya membuka halaman utama. Jika aplikasi tidak terinstal, tautan tersebut dapat secara cerdas mengarahkan pengguna ke App Store atau Play Store. Perannya dalam kurikulum ini adalah untuk melengkapi kemampuan navigasi aplikasi Anda, memungkinkan integrasi yang mulus dengan dunia luar dan secara dramatis meningkatkan pengalaman pengguna serta efektivitas strategi pemasaran.

**Konsep Kunci & Filosofi Mendalam:**

- **Dari Web ke Aplikasi:** Filosofi utamanya adalah menciptakan transisi yang mulus dari web ke aplikasi. Pengguna tidak perlu lagi membuka aplikasi secara manual dan mencari konten yang mereka lihat di web; tautan tersebut yang akan menavigasi mereka.

- **Dua Jenis Tautan:**

  1.  **Custom URL Schemes:**
      - **Format:** `yourapp://orders/54321`
      - **Cara Kerja:** Ini adalah metode lama. Anda mendaftarkan sebuah "skema" URL unik untuk aplikasi Anda. Ketika OS menemukan tautan dengan skema ini, ia akan meluncurkan aplikasi Anda.
      - **Kelemahan:** Tidak aman (aplikasi lain bisa mengklaim skema yang sama) dan tidak memiliki mekanisme _fallback_ (jika aplikasi tidak terinstal, tautan akan mati). Oleh karena itu, metode ini **tidak lagi direkomendasikan** untuk penggunaan publik.
  2.  **Verified App Links (Android) & Universal Links (iOS):**
      - **Format:** `https://your-brand.com/orders/54321` (URL web standar)
      - **Cara Kerja:** Ini adalah metode modern dan aman. Anda membuktikan kepemilikan domain web Anda kepada sistem operasi (Android/iOS). Caranya adalah dengan mengunggah sebuah file konfigurasi ke situs web Anda (`assetlinks.json` untuk Android, `apple-app-site-association` untuk iOS). Ketika pengguna mengklik tautan HTTPS ke domain Anda, OS akan memeriksa apakah ada aplikasi yang terverifikasi untuk domain tersebut. Jika ada, OS akan langsung membuka aplikasi Anda ke tautan tersebut. Jika tidak, tautan akan terbuka di browser seperti biasa.
      - **Keuntungan:** Aman, terverifikasi, dan memiliki _fallback_ yang sempurna.

- **Integrasi dengan Router:** Paket navigasi modern seperti **GoRouter** dirancang untuk menangani _deep links_ secara otomatis. Karena GoRouter sudah berbasis URL, ketika aplikasi dibuka melalui _deep link_, GoRouter hanya perlu mencocokkan _path_ dari tautan tersebut dengan daftar rute yang telah Anda definisikan dan langsung menavigasi ke sana.

**Sintaks Dasar / Contoh Implementasi Inti:**
Konfigurasi _deep linking_ lebih banyak terjadi di luar kode Flutter (di file manifes Android dan konfigurasi Xcode) daripada di dalam kode Dart. Kode Dart (dengan GoRouter) sebagian besar tetap sama.

**Langkah 1: Konfigurasi Android (`AndroidManifest.xml`)**
Anda perlu menambahkan sebuah `intent-filter` ke dalam `Activity` utama Anda.

```xml
<activity ...>
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" android:host="your-brand.com" />
    </intent-filter>
</activity>
```

**Langkah 2: Konfigurasi iOS (`Info.plist` & `*.entitlements`)**
Anda perlu menambahkan _Associated Domains_ di Xcode.

1.  Buka proyek di Xcode.
2.  Pilih Target -\> Signing & Capabilities.
3.  Klik `+ Capability` dan tambahkan **Associated Domains**.
4.  Tambahkan domain Anda dengan prefix `applinks:`, contoh: `applinks:your-brand.com`.

**Langkah 3: Konfigurasi di Sisi Server**
Anda harus meng-host file asosiasi di domain Anda.

- **Untuk Android:** Buat file `assetlinks.json` dan letakkan di `https://your-brand.com/.well-known/assetlinks.json`.
- **Untuk iOS:** Buat file `apple-app-site-association` (tanpa ekstensi) dan letakkan di `https://your-brand.com/.well-known/apple-app-site-association`.

**Langkah 4: Kode Dart (dengan GoRouter)**
Tidak ada perubahan signifikan yang diperlukan! Router yang telah kita buat sebelumnya sudah siap menangani _deep link_.

```dart
// file: main.dart (Sama seperti contoh GoRouter sebelumnya)
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', ...),
    GoRoute(path: '/orders/:orderId', ...), // Rute ini akan dicocokkan oleh deep link
  ],
);
```

---

### **Visualisasi Hasil Kode & Pengalaman Pengguna**

Berikut adalah _mockup_ visual dari alur kerja _deep linking_.

```
┌──────────────────────────────────┐        ┌──────────────────────────────────┐
│  Tampilan Aplikasi Email/Web     │        │  Aplikasi Flutter Anda           │
├──────────────────────────────────┤        ├──────────────────────────────────┤
│                                  │        │ AppBar: [Detail Pesanan]         │
│  Dari: Toko Kami                 │        │ -------------------------------- │
│                                  │        │                                  │
│  Halo, pesanan Anda telah        │  Klik  │   ID Pesanan: 54321              │
│  dikirim!                       ┌┼───────►│   Status: Dalam Pengiriman       │
│                                 ││        │   ...                            │
│  Lacak di sini:        ─┐       ││        │                                  │
│  https://your-brand.com │───────┘│        │                                  │
|  /orders/54321/user/233 │        │        |                                  │
│                        ─┘        │        │                                  │
│                                  │        │                                  │
└──────────────────────────────────┘        └──────────────────────────────────┘
```

**Penjelasan Alur:**

1.  Pengguna menerima email atau melihat tautan di web.
2.  Pengguna mengklik tautan `https://your-brand.com/orders/54321`.
3.  Sistem Operasi (Android/iOS) mencegat klik ini.
4.  OS memeriksa domain `your-brand.com` dan melihat bahwa aplikasi Anda telah terverifikasi untuk menangani tautan dari domain ini.
5.  OS membuka aplikasi Anda dan meneruskan URL `/orders/54321` kepadanya.
6.  GoRouter di dalam aplikasi Anda menerima _path_ ini, mencocokkannya dengan `GoRoute(path: '/orders/:orderId', ...)` yang telah Anda definisikan.
7.  Aplikasi langsung menampilkan halaman `OrderDetailsScreen` dengan ID `54321`.

---

### **Representasi Diagram Alur & Konfigurasi**

```
┌──────────────────────────────┐
│  User Klik Tautan            │ // https://your-brand.com/orders/54321
│  (di Email, Web, dll.)       │
└──────────────┬───────────────┘
               │
┌──────────────▼───────────────┐
│  Sistem Operasi (Android/iOS)│ // Mencegat klik tautan HTTPS.
│  (OS Interception)           │─────────┐
└──────────────┬───────────────┘         ▼
               │                   OS memeriksa file asosiasi di server
┌──────────────▼───────────────┐       untuk verifikasi domain.
│  Verifikasi Domain?          │
│  (Cek `assetlinks.json` atau │
│ `apple-app-site-association`)│
└──────────────┬───────────────┘
      ┌────────┴────────┐
      │                 │
┌─────▼─────┐     ┌─────▼─────┐
│  TIDAK    │     │  YA       │
│  (Gagal)  │     │  (Sukses) │
└─────┬─────┘     └─────┬─────┘
      │                 │
┌─────▼─────┐     ┌─────▼─────┐
│  Buka di  │     │  Buka App │
│  Browser  │     │  dan kirim│
└───────────┘     │  URL      │
                  └─────┬─────┘
                        │
┌──────────────▼───────────────┐
│  GoRouter di Aplikasi        │ // Menerima path '/orders/54321'.
│  (Router Handling)           │─────────┐
└──────────────┬───────────────┘         ▼
               │                   Mencocokkan path dengan GoRoute
┌──────────────▼───────────────┐       yang telah didefinisikan.
│  Menampilkan Layar Spesifik  │
│  (OrderDetailsScreen)        │
└──────────────────────────────┘
```

---

### **Ringkasan dan Penutupan Fase 4**

Dengan ini, kita telah secara resmi menyelesaikan seluruh **FASE 4: Navigation & Routing**.

Anda telah membangun pemahaman yang lengkap, mulai dari navigasi dasar yang imperatif dengan **Navigator 1.0**, beralih ke arsitektur deklaratif modern dengan **Navigator 2.0 API**, lalu mempelajari implementasi praktisnya menggunakan **GoRouter** dan **Auto Route**. Terakhir, kita menutupnya dengan menghubungkan aplikasi kita ke dunia luar melalui **strategi URL web** dan **mobile deep linking**.

Aplikasi Anda kini tidak hanya memiliki struktur internal yang kuat, tetapi juga dapat diakses dan dinavigasi dari luar dengan cara yang cerdas dan profesional.

Kini aplikasi kita sudah memiliki "tubuh" (UI), "otak" (State), dan "peta" (Navigasi). Langkah berikutnya adalah memberinya kemampuan untuk "makan" atau mengonsumsi data dari sumber eksternal seperti API.

# Selamat!

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
