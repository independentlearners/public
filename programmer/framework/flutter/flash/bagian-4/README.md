> [flash][pro4]

# **[FASE 4: Navigation & Routing][0]**

### **DAFTAR ISI FASE**

<details>
  <summary>📃 Struktur Daftar Materi</summary>

- **6. Navigation Architecture**

  - **6.1 Basic Navigation**
    - Navigator 1.0
      - Konsep Dasar Navigator Stack
      - Metode `Navigator.push()` dan `Navigator.pop()`
      - Objek `Route` dan `MaterialPageRoute`
      - Metode `pushReplacement()` dan `pushAndRemoveUntil()`

- **6. Navigation Architecture**

  - **6.1 Basic Navigation (Lanjutan)**

    - **Named routes setup:** Bagaimana mendefinisikan dan menggunakan _named routes_ untuk navigasi yang lebih terstruktur.
    - **Route arguments passing:** Mekanisme untuk mengirimkan data antar layar saat bernavigasi.
    - **`onGenerateRoute` callback:** Penggunaan _callback_ ini untuk kontrol navigasi yang lebih dinamis dan terpusat.
    - **Route guards dan conditions:** Implementasi logika untuk melindungi _route_ atau mengarahkan ulang navigasi berdasarkan kondisi tertentu (misalnya, otentikasi pengguna).
    - _Tambahan Pendalaman:_ Praktik terbaik untuk arsitektur navigasi dasar.

  - **6.2 Advanced Navigation**

    - **Navigator 2.0 (Router API):** Pendekatan deklaratif untuk navigasi di Flutter.
      - `RouterDelegate` implementation
      - `RouteInformationParser` usage
      - `RouteInformationProvider` setup
      - `Router` widget configuration
      - `Nested routing strategies`
      - `Back button handling`
    - **GoRouter Implementation:** Menggunakan _package_ `GoRouter` sebagai solusi _routing_ yang populer dan modern.
      - `GoRouter setup dan configuration`
      - `Route definitions dan sub-routes`
      - `Route parameters dan query parameters`
      - `Route redirects dan guards`
      - `ShellRoute untuk persistent UI`
      - `GoRouter dengan state management`
    - **Auto Route & Code Generation:** Mengotomatiskan definisi _route_ menggunakan _code generation_ dengan `Auto Route`.
      - `Auto route setup dan annotations`
      - `Route generation process`
      - `Nested routes dengan AutoRoute`
      - `Route guards implementation`
      - `Auto route testing`

  - **6.3 Deep Linking & URL Handling**
    - **Web URL Strategies:** Mengelola URL aplikasi Flutter di _web_.
      - `Hash vs Path URL strategies`
      - `Browser history integration`
      - `URL parameter handling`
      - `SEO considerations`
    - **Mobile Deep Linking:** Mengkonfigurasi dan menangani _deep link_ di perangkat _mobile_.
      - `Android App Links setup`
      - `iOS Universal Links setup`
      - `Custom URL schemes`
      - `Deep link parameter extraction`
      - `Deep link testing`

</details>

---

#### **6. Navigation Architecture**

**Deskripsi Detail & Peran:**
Bagian ini adalah fondasi untuk memahami bagaimana aplikasi Flutter mengelola navigasi antar layar (atau _route_). Navigasi adalah komponen kunci dari setiap aplikasi mobile yang memungkinkan pengguna berpindah dari satu tampilan ke tampilan lain. Memahami arsitektur navigasi yang berbeda sangat penting untuk membangun _user experience_ yang lancar dan intuitif, serta mengelola _state_ yang terkait dengan navigasi.

**Konsep Kunci & Filosofi:**
Filosofi utama di balik arsitektur navigasi Flutter adalah konsep _stack_ (tumpukan). Setiap kali pengguna berpindah ke layar baru, layar tersebut "didorong" (pushed) ke atas tumpukan. Ketika pengguna kembali dari layar tersebut, layar itu "dikeluarkan" (popped) dari tumpukan. Flutter menyediakan API yang kuat untuk mengelola tumpukan _route_ ini.

Berikut adalah aspek-aspek utama dari _Navigation Architecture_:

---

##### **6.1 Basic Navigation**

###### **Navigator 1.0**

- **Peran:** Memperkenalkan mekanisme navigasi asli dan paling dasar di Flutter, yang sering disebut sebagai "Navigator 1.0" atau "Imperative Navigator". Ini adalah API yang lebih sederhana dan cocok untuk sebagian besar skenario navigasi aplikasi yang tidak terlalu kompleks.

- **Detail:** `Navigator 1.0` beroperasi berdasarkan konsep _stack_ atau tumpukan _route_ (layar). Setiap layar di aplikasi Anda dianggap sebagai sebuah `Route`. Ketika Anda berpindah ke layar baru, Anda "mendorong" (push) _route_ baru ke atas tumpukan. Ketika Anda ingin kembali ke layar sebelumnya, Anda "mengeluarkan" (pop) _route_ dari atas tumpukan.

  `Navigator 1.0` secara implisit mengelola _route stack_. Anda berinteraksi dengannya menggunakan _method_ seperti `Navigator.push()` dan `Navigator.pop()`.

  **Komponen Utama:**

  - **`Navigator` Widget:** Ini adalah _widget_ yang mengelola tumpukan _route_. Biasanya, ada satu `Navigator` utama di `MaterialApp` atau `CupertinoApp` Anda.
  - **`Route` Class:** Sebuah _abstract class_ yang merepresentasikan satu layar atau tujuan navigasi. `MaterialPageRoute` adalah implementasi `Route` yang paling umum digunakan.
  - **`MaterialPageRoute`:** Sebuah _route_ yang menggantikan seluruh layar dengan transisi platform-spesifik. Ini adalah cara termudah untuk membuat halaman baru dan mendorongnya ke _Navigator stack_.

- **Sintaks:**

  - **Untuk Pindah ke Layar Baru (Push):**

    ```dart
    // Contoh dari Layar A ke Layar B
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LayarB()),
    );
    ```

    _Penjelasan:_

    - `context`: `BuildContext` dari _widget_ saat ini. Ini diperlukan karena `Navigator` biasanya ditemukan di _widget tree_ di atas _widget_ Anda.
    - `MaterialPageRoute`: Membuat _route_ baru dengan _builder_ yang mengembalikan _widget_ untuk layar tujuan (`LayarB`).

  - **Untuk Kembali ke Layar Sebelumnya (Pop):**

    ```dart
    // Contoh dari Layar B ke Layar A
    Navigator.pop(context);
    ```

    _Penjelasan:_

    - `Navigator.pop(context)`: Menghapus _route_ teratas dari tumpukan, sehingga layar sebelumnya menjadi aktif kembali.

  - **Untuk Pindah dan Mengganti Layar Saat Ini (Push Replacement):**

    ```dart
    // Contoh dari Layar A ke Layar B, dan Layar A dihapus dari stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LayarB()),
    );
    ```

    _Penjelasan:_ Berguna untuk skenario seperti navigasi setelah login, di mana Anda tidak ingin pengguna dapat kembali ke layar login dengan tombol kembali.

  - **Untuk Pindah dan Menghapus Semua Layar Sebelumnya hingga Tujuan (Push And Remove Until):**

    ```dart
    // Contoh dari Layar X ke Layar B, menghapus semua layar di atas Layar A (termasuk X)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LayarB()),
      (Route<dynamic> route) => route.isFirst, // Kondisi untuk menghentikan penghapusan (misal: hingga root route)
      // atau (route) => false, untuk menghapus semua route sebelumnya
    );
    ```

    _Penjelasan:_ Umumnya digunakan setelah proses login atau onboarding untuk membersihkan _stack_ navigasi.

- **Visualisasi Konseptual Navigator Stack:**

  ```
  ┌───────────────────────────┐
  │       Navigator Stack     │
  └─────────────────┬─────────┘
                    │
                    ▼
  ┌───────────────────────────┐
  │     Layar C (Top of Stack)│ <-- Aktif, terlihat oleh pengguna
  └─────────────────┬─────────┘
                    │  ▲ Pop()
                    │  │
                    ▼  │ Push()
  ┌─────────────────┴─┐
  │     Layar B       │
  └─────────────────┬─┘
                    │  ▲ Pop()
                    │  │
                    ▼  │ Push()
  ┌─────────────────┴─┐
  │     Layar A (Base)│ <-- Layar awal aplikasi
  └───────────────────┘
  ```

  **Penjelasan Visual:**
  Setiap kotak merepresentasikan sebuah `Route` (layar) dalam tumpukan `Navigator`. Ketika Anda `push()` sebuah _route_, itu ditambahkan ke atas tumpukan. Ketika Anda `pop()`, _route_ teratas dihapus.

- **Contoh Implementasi Lengkap (main.dart):**

  ```dart
  import 'package:flutter/material.dart';

  void main() {
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Basic Navigation Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const LayarA(), // Layar awal aplikasi
      );
    }
  }

  // Layar A
  class LayarA extends StatelessWidget {
    const LayarA({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Layar A')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ini adalah Layar A',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Pindah ke Layar B
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LayarB()),
                  );
                },
                child: const Text('Pergi ke Layar B'),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Layar B
  class LayarB extends StatelessWidget {
    const LayarB({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Layar B')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ini adalah Layar B',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Kembali ke Layar A (pop Layar B dari stack)
                  Navigator.pop(context);
                },
                child: const Text('Kembali ke Layar A'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Pindah ke Layar C dan Layar B diganti
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LayarC()),
                  );
                },
                child: const Text('Ganti ke Layar C'),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Layar C
  class LayarC extends StatelessWidget {
    const LayarC({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Layar C')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ini adalah Layar C',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Kembali ke root (Layar A) dan hapus semua di atasnya
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LayarA()),
                    (Route<dynamic> route) => false, // Hapus semua route
                  );
                },
                child: const Text('Kembali ke Layar A (Hapus semua)'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Kembali ke layar sebelumnya (jika ada), dalam kasus ini akan kembali ke A jika dari B, atau keluar app jika dari root
                  Navigator.pop(context);
                },
                child: const Text('Kembali (Pop)'),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Terminologi Esensial:**

  - **`Navigator`:** _Widget_ yang mengelola tumpukan _route_ (layar).
  - **`Route`:** Sebuah objek yang merepresentasikan satu halaman atau tampilan di aplikasi.
  - **`MaterialPageRoute`:** Implementasi `Route` yang umum untuk tampilan standar dengan transisi Material Design.
  - **`push()`:** Menambahkan _route_ baru ke atas tumpukan `Navigator`.
  - **`pop()`:** Menghapus _route_ teratas dari tumpukan `Navigator`.
  - **`pushReplacement()`:** Menambahkan _route_ baru ke tumpukan dan menghapus _route_ yang saat ini aktif.
  - **`pushAndRemoveUntil()`:** Menambahkan _route_ baru dan menghapus semua _route_ sebelumnya hingga kondisi tertentu terpenuhi.
  - **`Stack` (Tumpukan):** Struktur data yang digunakan oleh `Navigator` untuk mengelola urutan layar.

- **Hubungan dengan Bagian Lain:**

  - **State Management:** Navigasi sering kali melibatkan _state_ antar layar (misalnya, mengirim data dari satu layar ke layar lain).
  - **Widget Tree:** `Navigator` adalah _widget_ yang berada di _widget tree_, dan fungsinya sangat bergantung pada `BuildContext` dari _widget_ yang memanggilnya.
  - **Architectural Patterns:** Dalam arsitektur yang lebih kompleks, navigasi dapat dikelola oleh lapisan terpisah (misalnya, menggunakan _router package_).

- **Tips & Best Practices (untuk peserta):**

  - **Gunakan `Navigator.of(context)` jika Anda tidak berada di dalam `StatefulWidget` atau `StatelessWidget` yang memiliki `context`:** Biasanya, `Navigator.push(context, ...)` sudah cukup.
  - **Hindari `pop` terlalu agresif:** Pastikan pengguna dapat kembali ke layar yang diharapkan.
  - **Pertimbangkan `pushReplacement` untuk alur seperti login:** Ini menghindari _stack_ yang tidak perlu dan membingungkan.
  - **Untuk aplikasi yang lebih kompleks, pertimbangkan Named Routes atau Navigator 2.0:** Ini akan kita bahas di materi selanjutnya.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Mencoba memanggil `Navigator.pop(context)` ketika tidak ada lagi _route_ yang bisa di-_pop_ (misalnya di layar paling awal/root).
    - **Solusi:** Pastikan Anda berada di layar yang bukan layar pertama atau tambahkan _conditional check_ jika perlu. Aplikasi akan secara otomatis menangani ini dengan menutup aplikasi jika tidak ada _route_ lain.
  - **Kesalahan:** Mengirim data antar layar secara langsung melalui _constructor_ _widget_ tanpa mempertimbangkan _state_ yang lebih kompleks.
    - **Solusi:** Untuk data sederhana, _constructor_ baik-baik saja. Untuk data yang lebih kompleks atau _state_ yang perlu di-_maintain_, gunakan solusi _state management_ dan ambil data di layar tujuan.
  - **Kesalahan:** Menggunakan `pushAndRemoveUntil` dengan predikat yang salah, sehingga menghapus terlalu banyak _route_ atau tidak menghapus cukup _route_.
    - **Solusi:** Pahami predikat `(Route<dynamic> route) => ...` dengan baik. `route.isFirst` akan kembali ke _root route_. `(route) => false` akan menghapus semua _route_ sebelumnya.

---

Kita telah menyelesaikan pembahasan **6.1 Basic Navigation - Navigator 1.0**. Materi ini memberikan pemahaman dasar tentang bagaimana navigasi bekerja di Flutter.

#### **6. Navigation Architecture (Lanjutan)**

##### **6.1 Basic Navigation (Lanjutan)**

###### **Named Routes Setup**

- **Peran:** Memperkenalkan konsep _named routes_ sebagai alternatif untuk navigasi yang lebih terstruktur dan mudah dikelola dibandingkan dengan membangun `MaterialPageRoute` secara langsung setiap kali. Ini sangat berguna untuk aplikasi dengan banyak layar atau alur navigasi yang kompleks.

- **Detail:** _Named routes_ adalah _string_ unik yang diasosiasikan dengan sebuah `Route` (layar) di aplikasi Anda. Daripada membuat `MaterialPageRoute` baru setiap kali Anda ingin berpindah ke layar tertentu, Anda cukup memanggil `Navigator.pushNamed()` dengan nama _route_ yang telah didefinisikan.

  **Keuntungan Penggunaan Named Routes:**

  1.  **Keterbacaan Kode:** Lebih mudah untuk memahami tujuan navigasi daripada melihat `MaterialPageRoute(builder: ...)` yang berulang.
  2.  **Pemeliharaan:** Jika lokasi file atau konstruktor layar berubah, Anda hanya perlu memperbarui definisi _route_ di satu tempat (`MaterialApp` atau `CupertinoApp`), bukan di setiap titik navigasi.
  3.  **Pengiriman Argumen:** Lebih mudah untuk mengirimkan argumen ke layar tujuan.
  4.  **Deep Linking:** Memfasilitasi implementasi _deep linking_ (akan dibahas lebih lanjut).

- **Sintaks & Konfigurasi Awal:**
  Untuk menggunakan _named routes_, Anda perlu mendefinisikannya di properti `routes` pada `MaterialApp` atau `CupertinoApp` Anda. Properti `routes` menerima sebuah `Map<String, WidgetBuilder>` di mana kunci adalah nama _route_ (String) dan nilai adalah _builder function_ yang mengembalikan _widget_ untuk layar tersebut.

  ```dart
  // Konfigurasi di MaterialApp
  MaterialApp(
    title: 'Named Routes Demo',
    // ... properti lainnya
    initialRoute: '/', // Route awal saat aplikasi dimulai
    routes: {
      '/': (context) => const HomeScreen(),
      '/detail': (context) => const DetailScreen(),
      '/settings': (context) => const SettingsScreen(),
      // Anda bisa menambahkan rute lain di sini
    },
  );
  ```

  - **`initialRoute`:** Menentukan _route_ yang akan ditampilkan pertama kali saat aplikasi diluncurkan. Default-nya adalah `/`.
  - **`routes`:** Sebuah `Map` yang berisi semua definisi _named routes_.

- **Menggunakan Named Routes untuk Navigasi:**
  Setelah _named routes_ didefinisikan, Anda dapat bernavigasi ke layar tersebut menggunakan `Navigator.pushNamed()`:

  ```dart
  // Dari HomeScreen ke DetailScreen
  Navigator.pushNamed(context, '/detail');

  // Untuk mengganti rute saat ini
  Navigator.pushReplacementNamed(context, '/settings');

  // Untuk kembali ke rute tertentu di stack dan menghapus rute di atasnya
  Navigator.popUntil(context, ModalRoute.withName('/')); // Kembali ke root route
  ```

- **Visualisasi Named Routes:**

  ```
  ┌───────────────────────────────┐
  │       MaterialApp             │
  │                               │
  │ routes: {                     │
  │   '/': HomeScreen,            │
  │   '/detail': DetailScreen,    │
  │   '/settings': SettingsScreen,│
  │ }                             │
  └────────────┬──────────────────┘
               │
               │
  ┌────────────▼──────────────┐
  │     Layar A (HomeScreen)  │
  │                           │
  │ onPressed: () {           │
  │   Navigator.pushNamed(    │
  │     context, '/detail');  │
  │ }                         │
  └───────────────────────────┘
              │
              │ Navigator.pushNamed('/detail')
              ▼
  ┌───────────────────────────┐
  │     Layar B (DetailScreen)│
  └───────────────────────────┘
  ```

  **Penjelasan Visual:**

  - `MaterialApp` bertindak sebagai pusat registrasi _named routes_.
  - Ketika sebuah tombol di `HomeScreen` memanggil `Navigator.pushNamed('/detail')`, `Navigator` mencari _route_ dengan nama `/detail` yang telah terdaftar dan mendorongnya ke _stack_.

---

###### **Route Arguments Passing**

- **Peran:** Menjelaskan bagaimana data dapat dilewatkan dari satu layar ke layar lain saat menggunakan _named routes_. Ini adalah kebutuhan umum dalam navigasi.

- **Detail:** `Navigator.pushNamed()` memiliki parameter opsional `arguments` yang dapat Anda gunakan untuk meneruskan objek apa pun ke _route_ tujuan. Objek ini kemudian dapat diakses di layar tujuan menggunakan `ModalRoute.of(context)!.settings.arguments`.

- **Sintaks:**

  - **Mengirim Argumen:**

    ```dart
    // Dari Layar Pengirim (misal: HomeScreen)
    Navigator.pushNamed(
      context,
      '/detail',
      arguments: {
        'itemId': 123,
        'itemName': 'Produk A',
      },
    );

    // Anda juga bisa mengirim objek kustom atau tipe data tunggal
    // Navigator.pushNamed(context, '/detail', arguments: 'Halo dari Home!');
    // Navigator.pushNamed(context, '/profile', arguments: User(id: '1', name: 'John Doe'));
    ```

  - **Menerima Argumen di Layar Tujuan (misal: DetailScreen):**

    ```dart
    class DetailScreen extends StatelessWidget {
      const DetailScreen({super.key});

      @override
      Widget build(BuildContext context) {
        // Mengambil argumen
        final args = ModalRoute.of(context)!.settings.arguments;

        // Pastikan tipe data argumen yang diterima
        // Jika Anda tahu itu Map<String, dynamic>:
        final Map<String, dynamic> arguments = args as Map<String, dynamic>;
        final int itemId = arguments['itemId'];
        final String itemName = arguments['itemName'];

        // Jika Anda tahu itu String:
        // final String message = args as String;

        // Jika Anda tahu itu objek User:
        // final User user = args as User;

        return Scaffold(
          appBar: AppBar(title: const Text('Detail Layar')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Item ID: $itemId'),
                Text('Nama Item: $itemName'),
                // ...
              ],
            ),
          ),
        );
      }
    }
    ```

- **Visualisasi Route Arguments Passing:**

  ```
  ┌───────────────────────────┐
  │       HomeScreen          │
  │                           │
  │ Navigator.pushNamed(      │
  │   context, '/detail',     │
  │   arguments: {            │
  │     'id': 123,            │
  │     'name': 'Produk A'    │
  │   }                       │
  │ );                        │
  └────────────┬──────────────┘
               │
               │ (Map<String, dynamic> args)
               ▼
  ┌─────────────────────────────┐
  │       DetailScreen          │
  │                             │
  │ final args =                │
  │   ModalRoute.of(context)!   │
  │     .settings.arguments;    │
  │                             │
  │ // Mengambil 'id' dan 'name'│
  └─────────────────────────────┘
  ```

  **Penjelasan Visual:**

  - `HomeScreen` menyiapkan sebuah `Map` berisi data.
  - `Navigator.pushNamed()` membawa `arguments` tersebut ke _route_ tujuan.
  - `DetailScreen` mengakses `arguments` melalui `ModalRoute.of(context)!.settings.arguments` untuk mengambil data yang dilewatkan.

---

###### **onGenerateRoute Callback**

- **Peran:** Menyediakan mekanisme yang lebih kuat dan fleksibel untuk mengelola pembuatan _route_ secara dinamis, terutama saat Anda perlu memproses argumen atau melakukan validasi sebelum membuat _route_. Ini adalah alternatif dari properti `routes` yang statis.

- **Detail:** Properti `onGenerateRoute` pada `MaterialApp` menerima sebuah _callback_ yang dipanggil setiap kali Anda mencoba menavigasi ke sebuah _named route_ yang _belum_ didefinisikan secara eksplisit di `routes` `Map`, atau jika Anda ingin mengelola semua _named routes_ secara terpusat.

  - `onGenerateRoute` menerima objek `RouteSettings` sebagai argumen, yang berisi `name` (nama _route_) dan `arguments` (argumen yang dilewatkan).
  - Anda harus mengembalikan sebuah `Route` (misalnya `MaterialPageRoute`) dari _callback_ ini. Jika Anda mengembalikan `null`, navigasi akan gagal.

- **Kapan Menggunakan `onGenerateRoute`:**

  - Ketika Anda memiliki banyak _named routes_ dan ingin mengelolanya di satu tempat.
  - Ketika Anda perlu memproses argumen secara _type-safe_ atau melakukan validasi sebelum membangun layar.
  - Untuk menangani _named routes_ yang dinamis (misalnya `/products/123` di mana `123` adalah ID produk).
  - Untuk implementasi _nested routing_ yang kompleks.

- **Sintaks:**

  ```dart
  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'onGenerateRoute Demo',
        initialRoute: '/',
        // Jangan gunakan 'routes' jika Anda mengelola semua rute dengan onGenerateRoute
        // routes: {'/': (context) => const HomeScreen()}, // Bisa juga digunakan bersama, tapi onGenerateRoute diprioritaskan
        onGenerateRoute: (settings) {
          // settings.name: Nama rute (misal: '/detail', '/profile')
          // settings.arguments: Argumen yang dilewatkan

          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => const HomeScreen());
            case '/detail':
              // Ambil argumen
              final args = settings.arguments as Map<String, dynamic>?;
              final itemId = args?['itemId'] as int?;
              final itemName = args?['itemName'] as String?;

              // Validasi argumen
              if (itemId != null && itemName != null) {
                return MaterialPageRoute(
                  builder: (context) => DetailScreen(itemId: itemId, itemName: itemName),
                );
              }
              // Jika argumen tidak valid, kembali ke home atau tampilkan error
              return MaterialPageRoute(builder: (context) => const UnknownRouteScreen());

            case '/profile':
              final userId = settings.arguments as String?;
              if (userId != null) {
                return MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: userId),
                );
              }
              return MaterialPageRoute(builder: (context) => const UnknownRouteScreen());

            default:
              // Handle rute yang tidak dikenal
              return MaterialPageRoute(builder: (context) => const UnknownRouteScreen());
          }
        },
      );
    }
  }

  // Contoh Layar Detail yang menerima argumen langsung di constructor
  class DetailScreen extends StatelessWidget {
    final int itemId;
    final String itemName;

    const DetailScreen({super.key, required this.itemId, required this.itemName});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Layar')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Item ID: $itemId'),
              Text('Nama Item: $itemName'),
            ],
          ),
        ),
      );
    }
  }

  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: {'itemId': 456, 'itemName': 'Contoh Produk'},
                );
              },
              child: const Text('Pergi ke Detail'),
            ),
          ),
        );
      }
  }

  class ProfileScreen extends StatelessWidget {
    final String userId;
    const ProfileScreen({super.key, required this.userId});
    @override
    Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: Text('Profil Pengguna $userId')), body: const Center(child: Text('Profil Pengguna')));
    }
  }

  class UnknownRouteScreen extends StatelessWidget {
    const UnknownRouteScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')), body: const Center(child: Text('Halaman yang Anda cari tidak ada.')));
    }
  }
  ```

- **Visualisasi onGenerateRoute Flow:**

  ```
  ┌────────────────────────────────────────────────────────────────┐
  │       MaterialApp                                              │
  │                                                                │
  │   onGenerateRoute: (settings) {                                │
  │     switch (settings.name) {                                   │
  │       case '/detail':                                          │
  │         // Proses argumen                                      │
  │         // Kembalikan MaterialPageRoute(builder: DetailScreen) │
  │       default:                                                 │
  │         // Handle tidak dikenal                                │
  │     }                                                          │
  │   }                                                            │
  └────────────┬───────────────────────────────────────────────────┘
               │
               │ Navigator.pushNamed('/detail', arguments: {...})
               ▼
  ┌──────────────────────────────────────┐
  │       onGenerateRoute Callback       │
  │ (Menerima RouteSettings: name, args) │
  └─────────────────┬────────────────────┘
                    │
                    ▼ (Berdasarkan settings.name dan settings.arguments)
  ┌──────────────────────────┐
  │ Return MaterialPageRoute │
  │ (dengan widget tujuan)   │
  └─────────────────┬────────┘
                    │
                    ▼
  ┌──────────────────────────────┐
  │ Target Screen (DetailScreen) │
  │ (sudah menerima data)        │
  └──────────────────────────────┘
  ```

  **Penjelasan Visual:**

  - `onGenerateRoute` di `MaterialApp` mencegat semua permintaan `pushNamed()`.
  - Di dalam _callback_, Anda memiliki kontrol penuh untuk memeriksa nama _route_, memproses argumen, dan mengembalikan `MaterialPageRoute` yang sesuai, atau bahkan mengarahkan ke halaman _error_ jika _route_ tidak valid.

---

###### **Route Guards dan Conditions**

- **Peran:** Memungkinkan Anda untuk mengimplementasikan logika kontrol akses atau kondisi tertentu sebelum navigasi ke suatu _route_ diizinkan. Ini penting untuk mengamankan bagian-bagian aplikasi atau memandu alur pengguna.

- **Detail:** Dalam konteks `Navigator 1.0`, _route guards_ biasanya diimplementasikan di dalam _callback_ `onGenerateRoute` atau langsung di dalam _handler_ tombol navigasi. Anda akan memeriksa sebuah kondisi (misalnya, apakah pengguna sudah _login_, apakah ada koneksi internet, apakah ada data tertentu) dan kemudian memutuskan apakah akan melanjutkan ke _route_ yang diminta atau mengarahkan ke _route_ lain (misalnya, layar _login_ atau layar _error_).

- **Sintaks (di dalam `onGenerateRoute`):**

  ```dart
  // Asumsikan ada service untuk mengecek status otentikasi
  class AuthService {
    static bool _isLoggedIn = false; // Simulasi status login

    static void login() {
      _isLoggedIn = true;
      print('User logged in.');
    }

    static void logout() {
      _isLoggedIn = false;
      print('User logged out.');
    }

    static bool get isLoggedIn => _isLoggedIn;
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Route Guards Demo',
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => const HomeScreen());

            case '/dashboard':
              // Implementasi Route Guard: Cek apakah pengguna sudah login
              if (AuthService.isLoggedIn) {
                return MaterialPageRoute(builder: (context) => const DashboardScreen());
              } else {
                // Jika belum login, arahkan ke halaman login
                return MaterialPageRoute(builder: (context) => const LoginScreen());
              }

            case '/admin':
              // Contoh guard berlapis: cek login dan peran admin
              if (AuthService.isLoggedIn && _isUserAdmin()) { // Asumsikan _isUserAdmin() adalah fungsi cek peran
                return MaterialPageRoute(builder: (context) => const AdminScreen());
              } else if (AuthService.isLoggedIn) {
                return MaterialPageRoute(builder: (context) => const UnauthorizedScreen()); // Pengguna login tapi bukan admin
              } else {
                return MaterialPageRoute(builder: (context) => const LoginScreen()); // Belum login
              }

            case '/login':
              return MaterialPageRoute(builder: (context) => const LoginScreen());

            default:
              return MaterialPageRoute(builder: (context) => const UnknownRouteScreen());
          }
        },
      );
    }

    // Fungsi simulasi untuk cek peran admin
    bool _isUserAdmin() {
      // Implementasi logika cek peran admin
      return true; // Contoh: selalu true untuk demo
    }
  }

  // Contoh layar
  class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});
    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Status Login: ${AuthService.isLoggedIn ? "LoggedIn" : "LoggedOut"}'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/dashboard');
                },
                child: const Text('Pergi ke Dashboard (Protected)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin');
                },
                child: const Text('Pergi ke Admin (Protected)'),
              ),
              ElevatedButton(
                onPressed: () {
                  AuthService.login();
                  setState(() {});
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  AuthService.logout();
                  setState(() {});
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      );
    }
  }

  class DashboardScreen extends StatelessWidget {
    const DashboardScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: const Text('Dashboard')), body: const Center(child: Text('Selamat datang di Dashboard!')));
    }
  }

  class AdminScreen extends StatelessWidget {
    const AdminScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: const Text('Admin Panel')), body: const Center(child: Text('Panel Admin Khusus!')));
    }
  }

  class LoginScreen extends StatelessWidget {
    const LoginScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Silakan Login untuk melanjutkan.'),
              ElevatedButton(
                onPressed: () {
                  AuthService.login();
                  // Setelah login berhasil, arahkan ke dashboard dan hapus halaman login dari stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    (route) => false, // Hapus semua route sebelumnya
                  );
                },
                child: const Text('Login Sekarang'),
              ),
            ],
          ),
        ),
      );
    }
  }

  class UnauthorizedScreen extends StatelessWidget {
    const UnauthorizedScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: const Text('Akses Ditolak')), body: const Center(child: Text('Anda tidak memiliki izin untuk mengakses halaman ini.')));
    }
  }
  ```

- **Visualisasi Route Guard Flow:**

  ```
  ┌───────────────────────────┐
  │      Pengguna Meminta     │
  │   Navigasi ke '/dashboard'│
  └────────────┬──────────────┘
               │ Navigator.pushNamed('/dashboard')
               ▼
  ┌──────────────────────────────────┐
  │     onGenerateRoute Callback     │
  │  (settings.name == '/dashboard') │
  └────────────┬─────────────────────┘
               │
               ▼
  ┌───────────────────────────┐
  │    Cek Kondisi (e.g.,     │
  │  AuthService.isLoggedIn)  │
  └────────────┬──────────────┘
     ┌─────────┴─────────┐
     ▼                   ▼
  ┌───────────┐   ┌───────────────┐
  │ Kondisi   │   │  Kondisi      │
  │  Benar    │   │   Salah       │
  │ (LoggedIn)│   │ (Not LoggedIn)│
  └─────┬─────┘   └─────────────┬─┘
        │                       │
        ▼                       ▼
  ┌────────────────────────┐   ┌────────────────────┐
  │ Return DashboardScreen │   │ Return LoginScreen │
  └────────────────────────┘   └────────────────────┘
  ```

  **Penjelasan Visual:**

  - Permintaan navigasi ke `'/dashboard'` masuk ke `onGenerateRoute`.
  - Di dalamnya, dilakukan pengecekan kondisi (misalnya, status login).
  - Berdasarkan hasil pengecekan, `Navigator` akan diarahkan ke `DashboardScreen` (jika kondisi terpenuhi) atau ke `LoginScreen` (jika kondisi tidak terpenuhi).

---

**Terminologi Esensial:**

- **`Named Routes`:** _String_ unik yang diasosiasikan dengan sebuah layar untuk navigasi yang terstruktur.
- **`Navigator.pushNamed()`:** Metode untuk berpindah ke _named route_.
- **`arguments`:** Parameter opsional di `pushNamed()` untuk meneruskan data.
- **`ModalRoute.of(context)!.settings.arguments`:** Cara mengambil argumen di layar tujuan.
- **`onGenerateRoute`:** _Callback_ di `MaterialApp` untuk mengelola pembuatan _route_ secara dinamis dan terpusat.
- **`RouteSettings`:** Objek yang berisi nama _route_ dan argumen yang diteruskan ke `onGenerateRoute`.
- **`Route Guards`:** Logika atau kondisi yang diimplementasikan untuk mengontrol akses atau alur navigasi ke suatu _route_.

**Hubungan dengan Bagian Lain:**

- **State Management:** Status otentikasi (login/logout) sering kali dikelola oleh solusi _state management_, yang kemudian digunakan oleh _route guards_.
- **Testing:** _Named routes_ dan `onGenerateRoute` membuat navigasi lebih mudah diuji karena Anda dapat mensimulasikan navigasi ke _string_ tertentu dan memeriksa _route_ yang dihasilkan.

**Tips & Best Practices (untuk peserta):**

- **Konsistensi Penamaan:** Gunakan konvensi penamaan yang konsisten untuk _named routes_ (misalnya, _snake_case_ atau _kebab-case_).
- **Validasi Argumen:** Selalu validasi argumen yang diterima di layar tujuan, terutama saat menggunakan `as Type` untuk _casting_.
- **Sentralisasi Logika Navigasi:** `onGenerateRoute` adalah tempat yang sangat baik untuk mensentralisasi semua logika navigasi, terutama _route guards_.
- **Jangan Terlalu Kompleks:** Untuk aplikasi yang sangat kompleks dengan _nested navigation_ yang dalam atau _deep linking_ tingkat lanjut, pertimbangkan `Navigator 2.0` atau _package_ seperti `GoRouter` atau `Auto Route` yang akan kita bahas selanjutnya.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Lupa mendefinisikan _named route_ di `routes` `Map` atau tidak menangani `onGenerateRoute` dengan benar, sehingga aplikasi mengalami _crash_ karena _route_ tidak ditemukan.
  - **Solusi:** Selalu pastikan setiap _named route_ yang akan dipanggil memiliki definisi yang sesuai, baik di `routes` maupun ditangani di `onGenerateRoute`.
- **Kesalahan:** Kesalahan _type-casting_ saat menerima argumen.
  - **Solusi:** Gunakan `as Type` dengan hati-hati atau gunakan _pattern matching_ dengan `is` atau `as` yang lebih aman, dan selalu tambahkan _fallback_ atau penanganan _error_.
- **Kesalahan:** Logika _route guard_ yang terlalu kompleks atau tidak mencakup semua skenario.
  - **Solusi:** Uji _route guards_ Anda secara menyeluruh untuk setiap kemungkinan kondisi (login, logout, peran pengguna, data hilang, dll.).

---

Kita telah membahas secara mendalam **Named routes setup**, **Route arguments passing**, **onGenerateRoute callback**, dan **Route guards dan conditions**. Ini adalah dasar yang kuat untuk mengelola navigasi di aplikasi Flutter Anda.

### **Navigator 2.0 (Router API)**

- **Peran:** Memperkenalkan mekanisme navigasi yang lebih baru dan deklaratif di Flutter, dikenal sebagai "Navigator 2.0" atau "Router API". Ini dirancang untuk menangani skenario navigasi yang lebih kompleks, seperti:

  - _Deep linking_ dan penanganan URL web yang mulus.
  - _Nested navigation_ (navigasi di dalam navigasi).
  - Mengelola _state_ navigasi secara eksplisit.
  - Menangani tombol kembali perangkat dengan lebih baik.
  - Integrasi yang lebih erat dengan solusi _state management_.

- **Detail:** Berbeda dengan `Navigator 1.0` yang imperatif (Anda memerintahkan Navigator untuk melakukan `push` atau `pop`), `Navigator 2.0` bersifat deklaratif. Anda mendeskripsikan _state_ dari tumpukan navigasi Anda, dan Flutter akan mengonfigurasi `Navigator` agar sesuai dengan _state_ tersebut. Ini mirip dengan bagaimana Anda mendeskripsikan _state_ UI Anda dalam _widget tree_.

  `Navigator 2.0` tidak menggantikan `Navigator 1.0`, tetapi menyediakan lapisan abstraksi yang lebih tinggi. Ia beroperasi dengan tiga komponen inti: `Router`, `RouterDelegate`, dan `RouteInformationParser`, yang bersama-sama membentuk siklus hidup navigasi.

  **Komponen Utama Navigator 2.0:**

  1.  **`Router` Widget:** _Widget_ tingkat tinggi yang menghubungkan `RouterDelegate` dan `RouteInformationParser` dengan `Navigator` itu sendiri. Ini adalah titik masuk untuk sistem navigasi deklaratif.
  2.  **`RouterDelegate`:** Ini adalah "otak" dari Navigator 2.0. Ia bertanggung jawab untuk:
      - Membangun tumpukan `Page` (bukan `Route` seperti di Navigator 1.0).
      - Membuat `Navigator` dan mengelola _list_ `Page` yang ditampilkan.
      - Merespons perubahan _state_ navigasi (misalnya, dari _deep link_).
      - Menerima notifikasi ketika tombol kembali ditekan (`popRoute`).
  3.  **`RouteInformationParser`:** Bertanggung jawab untuk:
      - Mengambil informasi _route_ dari sistem (misalnya URL di web atau _deep link_ di mobile) dalam bentuk `RouteInformation` (yang berisi `location` dan `state`).
      - Menguraikan `RouteInformation` ini menjadi tipe data kustom Anda (sering disebut _configuration_ atau _AppRoutePath_).
      - Mengembalikan _configuration_ ini ke `RouterDelegate`.
  4.  **`RouteInformationProvider`:** Secara _default_, ini adalah `PlatformRouteInformationProvider` yang memantau perubahan URL dari platform (web, _deep link_). Ini menyediakan `RouteInformation` ke `RouteInformationParser`.

- **Siklus Hidup Navigasi (Flow):**

  1.  Pengguna melakukan tindakan (misal: mengklik tombol, memasukkan URL).
  2.  `RouteInformationProvider` memberitahu `RouteInformationParser` ada perubahan `RouteInformation`.
  3.  `RouteInformationParser` mengubah `RouteInformation` menjadi _configuration_ kustom (misal: `AppRoutePath`).
  4.  _Configuration_ ini diserahkan ke `RouterDelegate`.
  5.  `RouterDelegate` membangun ulang _list_ `Page` berdasarkan _configuration_ tersebut.
  6.  `Router` Widget menggunakan _list_ `Page` ini untuk memperbarui `Navigator` stack dan tampilan UI.
  7.  Ketika pengguna menekan tombol kembali, `Navigator` akan memanggil `popRoute` pada `RouterDelegate`.
  8.  `RouterDelegate` harus memutuskan apakah akan mem-_pop_ _route_ dari tumpukan atau tidak, dan jika ya, mengupdate _state_ navigasi dan `RouteInformation`.

- **Visualisasi Konseptual Navigator 2.0 Flow:**

  ```
  ┌───────────────────────────┐     ┌───────────────────────────┐     ┌───────────────────────────┐
  │    Platform/URL Changes   │     │  RouteInformationProvider │     │ RouteInformationParser    │
  │  (e.g., /home, /settings) │────►│                           │────►│ (Parses URL/DeepLink)     │
  └───────────────────────────┘     └─────────────┬─────────────┘     │ (to AppRoutePath/Config)  │
                                                  │                   └─────────────┬─────────────┘
                                                  │                       (AppRoutePath/Config)
                                                  ▼                                 │
  ┌───────────────────────────┐     ┌───────────────────────────┐                   │
  │     User Action           │     │      RouterDelegate       │◀──────────────────┘
  │ (e.g., Button Press)      │────►│    (Builds Page List)     │
  └───────────────────────────┘     │    (Handles Pop Route)    │
                                    └─────────────┬─────────────┘
                                                  │
                                                  ▼
  ┌───────────────────────────┐     ┌───────────────────────────┐
  │       Router Widget       │     │      Navigator            │
  │ (Ties everything together)│────►│ (Manages Page Stack)      │
  └───────────────────────────┘     └───────────────────────────┘
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana berbagai komponen Navigator 2.0 berinteraksi dalam sebuah alur lingkaran. Perubahan dari platform (URL) atau tindakan pengguna memicu proses parsing, yang kemudian mengarahkan `RouterDelegate` untuk membangun ulang tumpukan `Page` yang akan ditampilkan oleh `Navigator`.

- **Implementasi Utama:**

  Untuk mengimplementasikan Navigator 2.0, Anda perlu mendefinisikan setidaknya:

  1.  Sebuah kelas yang merepresentasikan _state_ navigasi Anda (sering disebut `AppRoutePath` atau _configuration_).
  2.  Implementasi `RouteInformationParser`.
  3.  Implementasi `RouterDelegate`.
  4.  Menghubungkan semuanya di `MaterialApp.router` (bukan `MaterialApp` biasa).

  Mari kita lihat struktur dasarnya:

  ```dart
  // 1. Definisikan State/Configuration Navigasi Anda
  //    Representasi abstrak dari URL/path
  class AppRoutePath {
    final int? id; // Contoh: untuk detail page /items/123
    final bool isHomePage;
    final bool isUnknown;

    AppRoutePath.home() : id = null, isHomePage = true, isUnknown = false;
    AppRoutePath.detail(this.id) : isHomePage = false, isUnknown = false;
    AppRoutePath.unknown() : id = null, isHomePage = false, isUnknown = true;

    // Getter untuk mengetahui tipe rute
    bool get isDetailPage => id != null;
  }

  // 2. Implementasi RouteInformationParser
  //    Mengubah RouteInformation (dari URL) menjadi AppRoutePath
  class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
    @override
    Future<AppRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
      final uri = Uri.parse(routeInformation.location ?? '/'); // Ambil URI dari lokasi

      if (uri.pathSegments.isEmpty) {
        return AppRoutePath.home();
      }

      if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'items') {
        final id = int.tryParse(uri.pathSegments[1]);
        if (id != null) {
          return AppRoutePath.detail(id);
        }
      }

      return AppRoutePath.unknown(); // Rute tidak dikenal
    }

    @override
    RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
      // Mengubah AppRoutePath kembali menjadi RouteInformation (URL)
      if (configuration.isHomePage) {
        return const RouteInformation(location: '/');
      }
      if (configuration.isDetailPage) {
        return RouteInformation(location: '/items/${configuration.id}');
      }
      if (configuration.isUnknown) {
        return const RouteInformation(location: '/404');
      }
      return null; // Tidak ada rute yang cocok
    }
  }

  // 3. Implementasi RouterDelegate
  //    Membangun tumpukan Page berdasarkan AppRoutePath
  class AppRouterDelegate extends RouterDelegate<AppRoutePath>
      with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
    AppRoutePath? _currentConfiguration;
    int? _selectedItemId;

    @override
    final GlobalKey<NavigatorState> navigatorKey;

    AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

    @override
    AppRoutePath? get currentConfiguration {
      if (_selectedItemId == null) {
        return AppRoutePath.home();
      } else {
        return AppRoutePath.detail(_selectedItemId);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
            key: const ValueKey('HomePage'),
            child: HomeScreen(
              onViewItem: (itemId) {
                _selectedItemId = itemId;
                notifyListeners(); // Beri tahu Router untuk membangun ulang stack
              },
            ),
          ),
          if (_selectedItemId != null)
            MaterialPage(
              key: ValueKey('DetailPage$_selectedItemId'),
              child: DetailScreen(itemId: _selectedItemId!),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }

          // Tangani pop, kembali ke home atau pop item detail
          if (_selectedItemId != null) {
            _selectedItemId = null; // Kembali ke home jika item detail di-pop
            notifyListeners();
          }
          return true;
        },
      );
    }

    @override
    Future<void> setNewRoutePath(AppRoutePath configuration) async {
      if (configuration.isUnknown) {
        _selectedItemId = null; // Bisa diarahkan ke 404 page
      } else if (configuration.isDetailPage) {
        _selectedItemId = configuration.id;
      } else {
        _selectedItemId = null;
      }
      notifyListeners();
    }
  }

  // --- Contoh Screen Sederhana ---
  class HomeScreen extends StatelessWidget {
    final ValueChanged<int> onViewItem;
    const HomeScreen({super.key, required this.onViewItem});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Home Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome Home!'),
              ElevatedButton(
                onPressed: () => onViewItem(123),
                child: const Text('View Item 123'),
              ),
              ElevatedButton(
                onPressed: () => onViewItem(456),
                child: const Text('View Item 456'),
              ),
            ],
          ),
        ),
      );
    }
  }

  class DetailScreen extends StatelessWidget {
    final int itemId;
    const DetailScreen({super.key, required this.itemId});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Detail for Item $itemId')),
        body: Center(
          child: Text('You are viewing details for Item $itemId'),
        ),
      );
    }
  }

  // 4. Hubungkan di MaterialApp.router
  void main() {
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp.router(
        title: 'Navigator 2.0 Demo',
        routerDelegate: AppRouterDelegate(),
        routeInformationParser: AppRouteInformationParser(),
        // Untuk deep linking/web history, tambahkan:
        // routeInformationProvider: PlatformRouteInformationProvider(
        //   initialRouteInformation: RouteInformation(location: WidgetsBinding.instance.platformDispatcher.defaultRouteName),
        // ),
      );
    }
  }
  ```

- **`RouterDelegate` Implementation:**

  - **`navigatorKey`**: Kunci global yang digunakan oleh `Navigator` untuk mengidentifikasi dan mengakses `NavigatorState` yang terkait dengan `RouterDelegate`.
  - **`currentConfiguration`**: Getter yang mengembalikan `AppRoutePath` saat ini, yang merepresentasikan _state_ navigasi yang sedang ditampilkan. Ini digunakan oleh sistem untuk memperbarui URL di _browser_ (jika di web).
  - **`build(BuildContext context)`**: Metode paling penting di mana Anda membangun daftar `Page` yang akan membentuk tumpukan `Navigator`. Anda mengontrol `pages` secara deklaratif.
  - **`onPopPage(route, result)`**: Dipanggil ketika _route_ di-_pop_ (misalnya, pengguna menekan tombol kembali). Anda harus mengembalikan `true` jika _pop_ berhasil ditangani oleh `RouterDelegate` Anda.
  - **`setNewRoutePath(configuration)`**: Dipanggil ketika `RouteInformationParser` menguraikan _route_ baru (misalnya dari URL yang dimasukkan secara manual atau _deep link_). Anda harus memperbarui _state_ internal `RouterDelegate` Anda dan memanggil `notifyListeners()` untuk memicu `build` ulang.

- **`RouteInformationParser` Usage:**

  - **`parseRouteInformation(routeInformation)`**: Mengambil `RouteInformation` dan mengubahnya menjadi `AppRoutePath` kustom. Ini adalah _parsing_ dari URL/deep link ke _state_ navigasi Anda.
  - **`restoreRouteInformation(configuration)`**: Mengambil `AppRoutePath` kustom dan mengubahnya kembali menjadi `RouteInformation`. Ini digunakan oleh sistem untuk memperbarui URL di _browser_ atau untuk menyimpan _history_ navigasi.

- **`Router` Widget Configuration:**

  - Dihubungkan melalui `MaterialApp.router` (atau `CupertinoApp.router`).
  - Parameter utamanya adalah `routerDelegate` dan `routeInformationParser`.
  - Opsional `routeInformationProvider` dapat digunakan untuk mengontrol sumber informasi rute (misalnya, jika Anda ingin _provider_ kustom selain `PlatformRouteInformationProvider`).

- **Nested Routing Strategies:**
  `Navigator 2.0` secara inheren mendukung _nested routing_ karena Anda dapat memiliki `Navigator` lain di dalam _page_ yang dibangun oleh `RouterDelegate` utama. Setiap `Navigator` akan memiliki `RouterDelegate` dan `RouteInformationParser`-nya sendiri. Ini memungkinkan Anda memiliki "mini-aplikasi" di dalam aplikasi utama dengan tumpukan navigasi terpisah.

  ```
  ┌───────────────────────────┐
  │     Main RouterDelegate   │
  │ (Membangun Pages utama)   │
  └───────────┬───────────────┘
              │
              ▼
  ┌───────────────────────────┐
  │  Page: HomeScreen         │
  │  (Container untuk Sub-Nav)│
  └───────────┬───────────────┘
              │
              ▼
  ┌───────────────────────────┐
  │  Nested Navigator Widget  │
  │(dengan Sub-RouterDelegate)│
  └───────────┬───────────────┘
              │
              ▼
  ┌─────────────────────────────┐
  │Sub-Pages: Tab A, Tab B, ... │
  └─────────────────────────────┘
  ```

  **Penjelasan Visual (Nested Routing):**
  `Main RouterDelegate` membangun halaman utama. Salah satu halaman utama tersebut (misalnya `HomeScreen`) mungkin berisi `Nested Navigator` sendiri dengan `Sub-RouterDelegate`, yang kemudian mengelola tumpukan halamannya sendiri (misalnya tab atau sub-bagian dalam sebuah fitur).

- **Back Button Handling:**
  Dengan `Navigator 2.0`, penanganan tombol kembali lebih eksplisit. Ketika tombol kembali perangkat ditekan, `Navigator` akan memanggil `popRoute` pada `RouterDelegate` teratas. Anda bertanggung jawab untuk memutuskan bagaimana _state_ aplikasi harus berubah sebagai respons terhadap _pop_ tersebut (misalnya, menghapus item dari daftar, menutup dialog, atau mem-_pop_ _page_ dari tumpukan). Jika `popRoute` mengembalikan `true`, itu berarti _pop_ telah ditangani. Jika `false`, _pop_ akan diteruskan ke `RouterDelegate` berikutnya di _stack_ (jika ada _nested navigator_) atau akan keluar dari aplikasi.

- **Terminologi Esensial:**

  - **`Router`:** _Widget_ inti yang mengatur sistem navigasi deklaratif.
  - **`RouterDelegate`:** Kelas yang bertanggung jawab membangun dan mengelola tumpukan `Page` dari `Navigator`.
  - **`RouteInformationParser`:** Kelas yang menguraikan URL/deep link menjadi _state_ navigasi kustom.
  - **`RouteInformationProvider`:** Menyediakan `RouteInformation` dari platform.
  - **`Page`:** Representasi deklaratif dari sebuah layar dalam tumpukan `Navigator 2.0` (menggantikan `Route` pada Navigator 1.0).
  - **`AppRoutePath` (atau _configuration_):** Objek kustom yang merepresentasikan _state_ navigasi aplikasi.

- **Hubungan dengan Bagian Lain:**

  - **State Management:** `RouterDelegate` sering kali akan berinteraksi dengan solusi _state management_ Anda (misalnya `ChangeNotifier`, `Provider`, `Riverpod`, BLoC) untuk mengubah _state_ navigasi dan memicu pembangunan ulang UI.
  - **Deep Linking:** Navigator 2.0 adalah fondasi yang kokoh untuk _deep linking_ karena kemampuannya dalam mem-parsing URL dan membangun _stack_ yang sesuai.
  - **Testing:** Meskipun lebih kompleks untuk di-_setup_, Navigator 2.0 menawarkan kontrol yang lebih baik atas _state_ navigasi, yang dapat mempermudah _testing_ skenario navigasi kompleks.

- **Tips & Best Practices (untuk peserta):**

  - **Pahami Konsep Deklaratif:** Pergeseran dari imperatif ke deklaratif adalah kunci. Pikirkan tentang "apa _state_ navigasi saya" daripada "bagaimana saya berpindah dari A ke B."
  - **Mulai dari Sederhana:** Navigator 2.0 bisa terasa rumit di awal. Mulai dengan aplikasi kecil dan tingkatkan kompleksitasnya secara bertahap.
  - **Pertimbangkan Library:** Untuk sebagian besar proyek, menggunakan _library_ pihak ketiga seperti `GoRouter` atau `Auto Route` (yang akan kita bahas selanjutnya) sangat direkomendasikan karena mereka mengabstraksi banyak kompleksitas Navigator 2.0.
  - **Debugging:** Debugging Navigator 2.0 bisa menantang. Gunakan _logging_ dan _debugger_ untuk memahami bagaimana `RouterDelegate` Anda membangun _list_ `Page`.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Lupa memanggil `notifyListeners()` di `RouterDelegate` setelah mengubah _state_ navigasi.
    - **Solusi:** Pastikan `notifyListeners()` dipanggil kapan pun _state_ yang memengaruhi _list_ `Page` berubah, baik karena tindakan pengguna maupun _setNewRoutePath_.
  - **Kesalahan:** Masalah dengan penanganan tombol kembali (`onPopPage`). Jika tidak diimplementasikan dengan benar, tombol kembali mungkin tidak berfungsi atau keluar dari aplikasi secara tidak terduga.
    - **Solusi:** Pastikan `onPopPage` secara akurat mencerminkan logika bagaimana _page_ harus di-_pop_ dan bagaimana _state_ navigasi harus diperbarui.
  - **Kesalahan:** Kebingungan dalam membedakan antara `Route` (Navigator 1.0) dan `Page` (Navigator 2.0).
    - **Solusi:** Ingat bahwa `Page` adalah representasi deklaratif dari sebuah layar yang digunakan oleh `RouterDelegate` untuk membangun `Navigator`. `MaterialPage` adalah implementasi `Page` yang paling umum.

---

Kita telah menyelesaikan pembahasan **Navigator 2.0 (Router API)**, termasuk `RouterDelegate` dan `RouteInformationParser`. Ini adalah fondasi navigasi deklaratif di Flutter. Selanjutnya, kita akan membahas implementasi navigasi tingkat lanjut menggunakan _package_ populer: **GoRouter Implementation**.

### **6. Navigation Architecture (Lanjutan)**

###### **GoRouter Implementation**

- **Peran:** `GoRouter` adalah _declarative router_ untuk Flutter yang dibangun di atas `Router API` (Navigator 2.0). Tujuannya adalah untuk menyederhanakan kompleksitas `Navigator 2.0` sambil tetap mempertahankan fleksibilitas dan kekuatan yang ditawarkannya. `GoRouter` sangat cocok untuk aplikasi yang membutuhkan _deep linking_, navigasi web, dan _nested navigation_ yang kompleks.

- **Mengapa Menggunakan GoRouter?**

  - **Penyederhanaan:** Mengabstraksi banyak _boilerplate code_ dari `RouterDelegate` dan `RouteInformationParser`.
  - **URL-based Routing:** Navigasi didasarkan pada jalur URL, sehingga memudahkan _deep linking_ dan integrasi web.
  - **Mudah Dipelajari:** Sintaks yang intuitif, mirip dengan navigasi berbasis _named route_ dari Navigator 1.0, namun dengan kekuatan Navigator 2.0.
  - **Nested Navigation:** Dukungan kuat untuk navigasi bersarang (`ShellRoute`).
  - **Redirects & Guards:** Fitur bawaan untuk mengimplementasikan _route redirects_ dan _route guards_ (proteksi rute).
  - **State Management Friendly:** Mudah diintegrasikan dengan berbagai solusi _state management_.

- **GoRouter Setup dan Configuration**
  Langkah pertama adalah menambahkan `go_router` ke `pubspec.yaml` Anda:

  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    go_router: ^latest_version # Ganti dengan versi terbaru
  ```

  Kemudian jalankan `flutter pub get`.

  Konfigurasi dasar `GoRouter` melibatkan pendefinisian daftar `GoRoute` dan menghubungkannya dengan `MaterialApp.router`.

  ```dart
  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';

  // Contoh Layar:
  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/profile'), // Navigasi ke named route
                child: const Text('Go to Profile'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/settings'),
                child: const Text('Go to Settings'),
              ),
            ],
          ),
        ),
      );
    }
  }

  class ProfileScreen extends StatelessWidget {
    const ProfileScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/'), // Kembali ke home
            child: const Text('Go to Home'),
          ),
        ),
      );
    }
  }

  class SettingsScreen extends StatelessWidget {
    const SettingsScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.pop(), // Pop layar saat ini
            child: const Text('Go Back'),
          ),
        ),
      );
    }
  }

  // Konfigurasi GoRouter
  final GoRouter _router = GoRouter(
    initialLocation: '/', // Lokasi awal aplikasi
    routes: <GoRoute>[
      GoRoute(
        path: '/', // Path untuk home screen
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/profile', // Path untuk profile screen
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: '/settings', // Path untuk settings screen
        builder: (BuildContext context, GoRouterState state) {
          return const SettingsScreen();
        },
      ),
    ],
  );

  void main() {
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp.router(
        routerConfig: _router, // Gunakan routerConfig dengan instance GoRouter
        debugShowCheckedModeBanner: false,
      );
    }
  }
  ```

- **Visualisasi GoRouter Basic Setup:**

  ```
  main.dart
  └── MaterialApp.router
      └── routerConfig: GoRouter (instance)
          └── routes: <GoRoute>[]
              ├── GoRoute (path: '/')
              │   └── builder: HomeScreen()
              ├── GoRoute (path: '/profile')
              │   └── builder: ProfileScreen()
              └── GoRoute (path: '/settings')
                  └── builder: SettingsScreen()
  ```

  **Penjelasan Visual:**
  Konfigurasi `GoRouter` di `MaterialApp.router` secara hierarkis mendefinisikan _routes_ dengan `GoRoute` sebagai elemen dasar, di mana setiap _path_ (jalur URL) dipetakan ke _widget builder_ yang akan menampilkan layar yang sesuai.

---

###### **Route Definitions dan Sub-routes**

- **Peran:** Memungkinkan Anda mendefinisikan _route_ utama dan _sub-routes_ yang bersarang di bawahnya, menciptakan struktur navigasi yang logis dan terorganisir.

- **Detail:** `GoRouter` memungkinkan Anda mendefinisikan _sub-routes_ (atau _nested routes_) di dalam sebuah `GoRoute` menggunakan properti `routes` yang bersarang. Ini sangat berguna untuk skenario seperti tab navigasi atau bagian aplikasi yang memiliki navigasi internalnya sendiri.

  ```dart
  // Contoh dengan Sub-routes:
  final GoRouter _routerWithSubRoutes = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
        routes: <GoRoute>[ // Sub-routes dari Home
          GoRoute(
            path: 'detail/:id', // Sub-route dengan parameter
            builder: (BuildContext context, GoRouterState state) {
              final itemId = state.pathParameters['id'];
              return DetailScreen(itemId: itemId!);
            },
          ),
          GoRoute(
            path: 'favorites', // Sub-route tanpa parameter
            builder: (BuildContext context, GoRouterState state) => const FavoritesScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
      ),
    ],
  );

  // Navigasi ke sub-route:
  // context.go('/detail/123'); // Salah, harus /detail/123 jika di level root
  // context.go('/detail/123'); // Jika 'detail/:id' adalah root route
  // context.go('/detail/123'); // Jika dari home screen, akan menjadi '/detail/123'
  // Untuk sub-route, navigasi relatif dari parent:
  // Misal dari Home screen:
  // context.go('/detail/123'); // Path lengkap
  // context.go('/favorites'); // Path lengkap
  ```

  **Catatan:** Ketika mendefinisikan _sub-route_, _path_ untuk _sub-route_ tersebut tidak diawali dengan `/`. `GoRouter` akan menginterpretasikannya sebagai relatif terhadap _path_ _parent route_. Jadi `path: 'detail/:id'` di bawah `path: '/'` akan menghasilkan _full path_ `/detail/:id`.

- **Visualisasi Route Definitions dan Sub-routes:**

  ```
  GoRouter (Root)
  └── routes: <GoRoute>[]
      ├── GoRoute (path: '/')
      │   └── builder: HomeScreen()
      │   └── routes: <GoRoute>[] (Sub-routes dari '/')
      │       ├── GoRoute (path: 'detail/:id') -> Full path: /detail/:id
      │       │   └── builder: DetailScreen()
      │       └── GoRoute (path: 'favorites') -> Full path: /favorites
      │           └── builder: FavoritesScreen()
      └── GoRoute (path: '/settings')
          └── builder: SettingsScreen()
  ```

  **Penjelasan Visual:**
  Representasi _tree_ ini menunjukkan bagaimana `GoRoute` dapat memiliki _nested_ `GoRoute` di dalamnya, membentuk hierarki navigasi.

---

###### **Route Parameters dan Query Parameters**

- **Peran:** Memungkinkan Anda untuk meneruskan data dinamis sebagai bagian dari URL (`path parameters`) atau sebagai bagian dari _query string_ URL (`query parameters`).

- **Detail:**

  - **Path Parameters:** Data yang disematkan langsung di dalam _path_ URL (misalnya `/users/123` di mana `123` adalah ID pengguna). Didefinisikan dalam _path_ `GoRoute` dengan awalan `:` (contoh: `:id`).
  - **Query Parameters:** Data yang ditambahkan ke akhir URL setelah tanda `?` dan dipisahkan dengan `&` (misalnya `/products?category=food&sort=asc`). Tidak perlu didefinisikan dalam _path_ `GoRoute`.

- **Sintaks:**

  ```dart
  // 1. Definisi GoRoute dengan Path Parameter
  GoRoute(
    path: '/item/:itemId', // Mendefinisikan itemId sebagai path parameter
    builder: (BuildContext context, GoRouterState state) {
      final itemId = state.pathParameters['itemId']; // Mengakses path parameter
      return ItemDetailScreen(itemId: itemId!);
    },
  ),

  // 2. Navigasi dengan Path Parameter
  // context.go('/item/abc'); // itemId = 'abc'
  // context.push('/item/123'); // itemId = '123'

  // 3. Navigasi dengan Query Parameters
  // Tidak perlu didefinisikan di path GoRoute
  context.go('/products?category=electronics&sort=desc');

  // 4. Mengakses Query Parameters di Layar Tujuan
  class ProductsScreen extends StatelessWidget {
    const ProductsScreen({super.key});

    @override
    Widget build(BuildContext context) {
      final String? category = GoRouterState.of(context).uri.queryParameters['category'];
      final String? sortOrder = GoRouterState.of(context).uri.queryParameters['sort'];

      return Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: Center(
          child: Text('Category: ${category ?? 'All'}, Sort: ${sortOrder ?? 'Default'}'),
        ),
      );
    }
  }
  ```

- **Visualisasi Parameter Flow:**

  ```
  ┌───────────────────────────┐     ┌───────────────────────────┐
  │      Source Screen        │     │        GoRouter           │
  │                           │     │                           │
  │ context.go('/users/123?   │────►│GoRoute(path: '/users/:id')│
  │     name=Alice')          │     │                           │
  └───────────────────────────┘     └─────────────┬─────────────┘
                                                  │
                                                  ▼
  ┌──────────────────────────────────┐     ┌──────────────────────────────────┐
  │   Target Screen                  │     │        GoRouterState             │
  │   (UserDetailScreen)             │◀────│                                  │
  │                                  │     │ pathParameters['id'] = '123'     │
  │ state.pathParameters['id']       │     │ queryParameters['name'] = 'Alice'│
  │ state.uri.queryParameters['name']│     └──────────────────────────────────┘
  └──────────────────────────────────┘
  ```

  **Penjelasan Visual:**
  Diagram ini menggambarkan bagaimana data (parameter jalur dan parameter _query_) disalurkan melalui `GoRouter` dari layar sumber ke layar tujuan, di mana data tersebut dapat diakses melalui objek `GoRouterState`.

---

###### **Route Redirects dan Guards**

- **Peran:** Mengimplementasikan logika kontrol akses, otentikasi, atau pengalihan alur navigasi berdasarkan kondisi tertentu sebelum pengguna mencapai _route_ yang dituju.

- **Detail:** `GoRouter` menyediakan properti `redirect` pada konstruktor `GoRouter` itu sendiri atau pada setiap `GoRoute`.

  - **Redirect (Global/Router-level):** Digunakan untuk mengarahkan ulang navigasi secara global (misalnya, jika pengguna belum _login_, arahkan semua _route_ yang dilindungi ke halaman _login_). Dipanggil setiap kali terjadi perubahan _route_.
  - **Redirect (Per-Route):** Digunakan untuk mengarahkan ulang dari _route_ spesifik ke _route_ lain.

  _Route guards_ adalah implementasi dari logika `redirect` ini, di mana Anda "menjaga" sebuah _route_ agar tidak dapat diakses kecuali kondisi tertentu terpenuhi.

- **Sintaks:**

  ```dart
  // Asumsikan AuthService seperti contoh Navigator 1.0 sebelumnya
  class AuthService {
    static bool isLoggedIn = false;
    static void login() { isLoggedIn = true; }
    static void logout() { isLoggedIn = false; }
  }

  // Redirect global di GoRouter
  final GoRouter _protectedRouter = GoRouter(
    redirect: (BuildContext context, GoRouterState state) {
      // Cek apakah pengguna berada di halaman login/registrasi
      final bool loggingIn = state.uri.toString() == '/login';

      // Jika belum login dan bukan di halaman login, redirect ke login
      if (!AuthService.isLoggedIn && !loggingIn) {
        return '/login';
      }

      // Jika sudah login dan mencoba ke halaman login, redirect ke home
      if (AuthService.isLoggedIn && loggingIn) {
        return '/';
      }

      // Tidak perlu redirect, biarkan navigasi berlanjut
      return null;
    },
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (BuildContext context, GoRouterState state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/admin',
        // Redirect per-route (bisa juga pakai redirect global)
        redirect: (BuildContext context, GoRouterState state) {
          // Asumsi ada logic _isAdmin()
          final bool isAdmin = true; // Simulasi
          if (!isAdmin) {
            return '/dashboard'; // Redirect ke dashboard jika bukan admin
          }
          return null;
        },
        builder: (BuildContext context, GoRouterState state) => const AdminScreen(),
      ),
    ],
  );

  // Di dalam widget:
  // Untuk login/logout:
  // AuthService.login();
  // context.go('/dashboard'); // GoRouter akan redirect jika belum login

  // Contoh Layar Login sederhana
  class LoginScreen extends StatelessWidget {
    const LoginScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              AuthService.isLoggedIn = true;
              context.go('/dashboard'); // Setelah login, coba ke dashboard
            },
            child: const Text('Perform Login'),
          ),
        ),
      );
    }
  }

  // Contoh Layar Dashboard dan Admin
  class DashboardScreen extends StatelessWidget {
    const DashboardScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to Dashboard!'),
              ElevatedButton(
                onPressed: () {
                  AuthService.logout();
                  context.go('/'); // Logout dan kembali ke home (akan di-redirect ke login)
                },
                child: const Text('Logout'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/admin'),
                child: const Text('Go to Admin Page'),
              ),
            ],
          ),
        ),
      );
    }
  }
  class AdminScreen extends StatelessWidget {
    const AdminScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: const Text('Admin Page')), body: const Center(child: Text('Welcome, Admin!')));
    }
  }
  ```

- **Visualisasi Redirect/Guard Flow:**

  ```
  ┌───────────────────────────┐
  │     User Tries to go to   │
  │       '/dashboard'        │
  └────────────┬──────────────┘
               │ context.go('/dashboard')
               ▼
  ┌──────────────────────────────────┐
  │GoRouter (Global)                 │
  │redirect: (context, state) {      │
  │  // Check AuthService.isLoggedIn │
  │     }                            │
  └────────────┬─────────────────────┘
     ┌─────────┴─────────┐
     ▼                   ▼
  ┌───────────┐     ┌───────────────┐
  │ Logged In │     │ Not Logged In │
  └─────┬─────┘     └─────────────┬─┘
        │                         │
        ▼                         ▼
  ┌────────────────────────┐   ┌──────────────────────┐
  │  Allow to '/dashboard' │   │ Redirect to '/login' │
  └────────────────────────┘   └──────────────────────┘
  ```

  **Penjelasan Visual:**
  Ketika pengguna mencoba mengakses suatu _path_, `GoRouter` akan menjalankan fungsi `redirect` yang telah didefinisikan. Fungsi ini akan mengevaluasi kondisi (misalnya status _login_) dan mengembalikan _path_ tujuan baru jika ada pengalihan yang diperlukan, atau `null` jika navigasi dapat dilanjutkan.

---

###### **ShellRoute untuk Persistent UI**

- **Peran:** Memungkinkan Anda untuk menjaga bagian UI tertentu tetap terlihat di layar saat navigasi, seperti _BottomNavigationBar_, _Drawer_, atau _AppBar_ yang tidak berubah. Ini menciptakan pengalaman pengguna yang lebih mulus untuk navigasi tingkat atas.

- **Detail:** `ShellRoute` adalah `GoRoute` khusus yang membungkus _nested navigator_ di dalam _shell_ UI. Ketika Anda bernavigasi ke _route_ di dalam `ShellRoute`, hanya konten di dalam _shell_ yang akan berubah, sedangkan elemen UI _shell_ (misalnya _bottom bar_) akan tetap ada.

- **Sintaks:**

  ```dart
  final GoRouter _shellRouter = GoRouter(
    routes: <GoRoute>[
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          // 'child' adalah widget dari sub-route yang aktif
          return ScaffoldWithNavBar(child: child); // Contoh shell UI dengan BottomNavBar
        },
        routes: <GoRoute>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) => const HomePageContent(),
          ),
          GoRoute(
            path: '/books',
            builder: (BuildContext context, GoRouterState state) => const BooksPageContent(),
          ),
          GoRoute(
            path: '/profile',
            builder: (BuildContext context, GoRouterState state) => const ProfilePageContent(),
          ),
        ],
      ),
    ],
  );

  // Contoh ScaffoldWithNavBar (shell UI)
  class ScaffoldWithNavBar extends StatelessWidget {
    final Widget child;
    const ScaffoldWithNavBar({super.key, required this.child});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('My App')),
        body: child, // Konten sub-route ditampilkan di sini
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(context, idx),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      );
    }

    // Helper untuk menentukan indeks tab saat ini
    int _calculateSelectedIndex(BuildContext context) {
      final String location = GoRouterState.of(context).uri.toString();
      if (location == '/') return 0;
      if (location.startsWith('/books')) return 1;
      if (location.startsWith('/profile')) return 2;
      return 0; // Default
    }

    // Helper untuk navigasi berdasarkan tap BottomNavigationBar
    void _onItemTapped(BuildContext context, int idx) {
      switch (idx) {
        case 0:
          context.go('/');
          break;
        case 1:
          context.go('/books');
          break;
        case 2:
          context.go('/profile');
          break;
      }
    }
  }

  // Contoh konten halaman untuk ShellRoute
  class HomePageContent extends StatelessWidget {
    const HomePageContent({super.key});
    @override
    Widget build(BuildContext context) => const Center(child: Text('Content for Home Tab'));
  }

  class BooksPageContent extends StatelessWidget {
    const BooksPageContent({super.key});
    @override
    Widget build(BuildContext context) => const Center(child: Text('Content for Books Tab'));
  }

  class ProfilePageContent extends StatelessWidget {
    const ProfilePageContent({super.key});
    @override
    Widget build(BuildContext context) => const Center(child: Text('Content for Profile Tab'));
  }
  ```

- **Visualisasi ShellRoute:**

  ```
  ┌───────────────────────────┐
  │     ScaffoldWithNavBar    │ (Shell UI - Persistent)
  │ ┌───────────────────────┐ │
  │ │        AppBar         │ │
  │ └───────────────────────┘ │
  │ ┌───────────────────────┐ │
  │ │     Child Widget      │ │ <--- Konten halaman berubah di sini
  │ │                       │ │      (HomePageContent, BooksPageContent, ...)
  │ └───────────────────────┘ │
  │ ┌───────────────────────┐ │
  │ │ BottomNavigationBar   │ │
  │ └───────────────────────┘ │
  └───────────────────────────┘
  ```

  **Penjelasan Visual:**
  `ShellRoute` memungkinkan Anda mendefinisikan sebuah "cangkang" UI (`ScaffoldWithNavBar` dalam contoh) yang akan tetap statis, sementara `child` _widget_ di dalamnya akan diganti dengan konten dari _sub-route_ yang aktif.

---

###### **GoRouter dengan State Management**

- **Peran:** Menunjukkan bagaimana `GoRouter` dapat diintegrasikan dengan solusi _state management_ untuk mengelola _state_ yang terkait dengan navigasi atau data aplikasi.

- **Detail:** `GoRouter` dirancang agar agnostik terhadap _state management_, artinya dapat bekerja dengan hampir semua _state management solution_ (Provider, BLoC, Riverpod, dll.). Anda biasanya akan menggunakan _state management_ untuk:

  1.  **Mengontrol Navigasi:** Memanggil `context.go()` atau `context.push()` dari _state manager_ (misalnya, setelah operasi _login_ berhasil, _state manager_ memberitahu UI untuk bernavigasi).
  2.  **Membaca Data Navigasi:** Membaca _path parameters_ atau _query parameters_ dan menggunakannya untuk memuat data di _state manager_.
  3.  **Route Guards:** Kondisi untuk _redirect_ dapat berasal dari _state_ yang dikelola oleh _state management solution_ Anda (misalnya, `AuthService` yang dibungkus oleh `ChangeNotifierProvider`).

- **Contoh Integrasi dengan `Provider` (simulasi):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import 'package:provider/provider.dart';

  // 1. Definisikan AuthProvider
  class AuthProvider extends ChangeNotifier {
    bool _isLoggedIn = false;
    bool get isLoggedIn => _isLoggedIn;

    Future<void> login(String username, String password) async {
      // Simulasi proses login
      await Future.delayed(const Duration(seconds: 1));
      if (username == 'user' && password == 'pass') {
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _isLoggedIn = false;
        notifyListeners();
        return false;
      }
    }

    void logout() {
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  // 2. Konfigurasi GoRouter dengan Redirect yang membaca dari Provider
  final GoRouter _stateManagedRouter = GoRouter(
    redirect: (BuildContext context, GoRouterState state) {
      // Akses AuthProvider menggunakan Provider.of
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final bool loggedIn = auth.isLoggedIn;
      final bool loggingIn = state.uri.toString() == '/login';

      if (!loggedIn && !loggingIn) {
        return '/login'; // Belum login, redirect ke login
      }
      if (loggedIn && loggingIn) {
        return '/dashboard'; // Sudah login, tidak boleh ke halaman login lagi
      }
      return null; // Lanjutkan navigasi
    },
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (BuildContext context, GoRouterState state) => const DashboardScreen(),
      ),
    ],
  );

  // 3. Pasang MultiProvider di atas MaterialApp.router
  void main() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const MyApp(),
      ),
    );
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp.router(
        routerConfig: _stateManagedRouter,
        debugShowCheckedModeBanner: false,
      );
    }
  }

  // --- Contoh Screen Sederhana ---
  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});
    @override
    Widget build(BuildContext context) {
      final auth = Provider.of<AuthProvider>(context);
      return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Status Login: ${auth.isLoggedIn ? "LoggedIn" : "LoggedOut"}'),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Go to Dashboard (Protected)'),
              ),
              if (auth.isLoggedIn)
                ElevatedButton(
                  onPressed: () => auth.logout(),
                  child: const Text('Logout'),
                )
              else
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Go to Login'),
                ),
            ],
          ),
        ),
      );
    }
  }

  class LoginScreen extends StatefulWidget {
    const LoginScreen({super.key});
    @override
    State<LoginScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    String _errorMessage = '';

    @override
    Widget build(BuildContext context) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                ),
              ElevatedButton(
                onPressed: () async {
                  final success = await auth.login(_usernameController.text, _passwordController.text);
                  if (success) {
                    context.go('/dashboard'); // GoRouter akan menangani redirect
                  } else {
                    setState(() {
                      _errorMessage = 'Username atau password salah.';
                    });
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }
  }

  class DashboardScreen extends StatelessWidget {
    const DashboardScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: const Text('Dashboard')), body: const Center(child: Text('Selamat datang di Dashboard!')));
    }
  }
  ```

- **Visualisasi GoRouter dengan State Management:**

  ```shell
  main.dart
  └── MultiProvider (Root Widget)
      └── ChangeNotifierProvider<AuthProvider>
          └── MaterialApp.router
              └── routerConfig: GoRouter
                  └── redirect: (context, state) {
                      └── Provider.of<AuthProvider>(context, listen: false).isLoggedIn
                      └── // Logic based on auth state
                  }
                  └── routes: <GoRoute>[]
                      ├── GoRoute (path: '/')
                      ├── GoRoute (path: '/login')
                      └── GoRoute (path: '/dashboard')
                          └── // Screen can consume AuthProvider as well
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana `AuthProvider` (menggunakan `ChangeNotifierProvider`) diposisikan di atas `MaterialApp.router`. Ini memungkinkan fungsi `redirect` di `GoRouter` untuk mengakses `state` `AuthProvider` dan membuat keputusan navigasi berdasarkan status _login_ pengguna.

---

**Terminologi Esensial GoRouter:**

- **`GoRouter`:** Objek utama untuk mengkonfigurasi dan mengelola navigasi deklaratif.
- **`GoRoute`:** Definisi individual untuk setiap _path_ atau _route_.
- **`path`:** _String_ URL yang terkait dengan `GoRoute`.
- **`builder`:** Fungsi yang mengembalikan _widget_ untuk _route_ yang sesuai.
- **`sub-routes`:** `GoRoute` yang bersarang di bawah `GoRoute` lain.
- **`context.go()`:** Metode untuk navigasi imperatif ke _path_ baru.
- **`context.push()`:** Metode untuk mendorong _path_ baru ke tumpukan, memungkinkan kembali ke _path_ sebelumnya.
- **`context.pop()`:** Metode untuk mengeluarkan _route_ dari tumpukan.
- **`state.pathParameters`:** `Map` untuk mengakses parameter dari _path_ URL (misalnya `/item/:id`).
- **`state.uri.queryParameters`:** `Map` untuk mengakses parameter dari _query string_ URL (misalnya `?name=value`).
- **`redirect`:** Fungsi yang dieksekusi sebelum navigasi untuk mengarahkan ulang _route_ berdasarkan kondisi.
- **`ShellRoute`:** `GoRoute` khusus untuk menciptakan UI yang persisten selama navigasi di dalamnya.

**Hubungan dengan Bagian Lain:**

- **Navigator 2.0:** `GoRouter` adalah implementasi dan abstraksi yang kuat dari `Navigator 2.0 Router API`.
- **State Management:** Integrasi yang mulus untuk mengontrol navigasi dan _route guards_ berdasarkan _state_ aplikasi.
- **Deep Linking:** Mempermudah implementasi _deep linking_ karena basisnya adalah URL.

**Tips & Best Practices (untuk peserta):**

- **Gunakan GoRouter:** Untuk sebagian besar aplikasi yang membutuhkan navigasi non-trivial (lebih dari sekadar `push`/`pop` sederhana), `GoRouter` adalah pilihan yang sangat baik.
- **Organisasi Route:** Untuk aplikasi besar, pertimbangkan untuk memisahkan definisi `GoRoute` ke dalam file-file terpisah atau _extensions_ untuk menjaga keterbacaan kode.
- **Nama Route vs Path:** `GoRouter` lebih mengandalkan _path_. Meskipun ada kemampuan untuk memberi nama _route_ (`name` properti di `GoRoute`), navigasi umumnya dilakukan dengan _path_.
- **Error Handling:** Manfaatkan `errorBuilder` di `GoRouter` untuk menampilkan halaman 404 kustom atau penanganan kesalahan lainnya.

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Menggunakan `context.go()` padahal seharusnya `context.push()`, atau sebaliknya. `go()` akan menghapus semua _stack_ navigasi sebelumnya hingga _path_ yang dituju, sedangkan `push()` akan menambahkan _path_ ke _stack_ dan memungkinkan `pop()`.
  - **Solusi:** Pahami perbedaan fungsionalitas `go()` dan `push()`. `go()` untuk navigasi yang "mengganti sejarah", `push()` untuk navigasi "menambah sejarah" yang bisa di-_pop_.
- **Kesalahan:** Kesalahan dalam menangani _path parameters_ atau _query parameters_ (misalnya, _type casting_ yang salah atau parameter tidak ada).
  - **Solusi:** Selalu cek _nullability_ dan lakukan _type casting_ dengan aman (`as Type?` atau cek `is`).
- **Kesalahan:** `redirect` loop tak terbatas karena logika yang salah.
  - **Solusi:** Pastikan logika `redirect` Anda memiliki kondisi keluar yang jelas dan tidak akan mengarahkan ulang tanpa henti. Uji dengan cermat skenario _login_, _logout_, dan akses ke _protected routes_.

---

Kita telah menyelesaikan pembahasan **GoRouter Implementation** secara mendalam. Ini adalah alat yang sangat kuat untuk mengelola navigasi di aplikasi Flutter modern. Selanjutnya, kita akan membahas **Auto Route & Code Generation**, _package_ lain yang memanfaatkan _code generation_ untuk menyederhanakan _routing_.

##### **6.2 Advanced Navigation (Lanjutan)**

###### **Auto Route & Code Generation**

- **Peran:** `Auto Route` adalah _package routing_ yang populer untuk Flutter yang memanfaatkan _code generation_ untuk mengotomatiskan pembuatan _route_ dan menyederhanakan navigasi yang kompleks. Ini mengurangi _boilerplate code_ dan membantu mencegah kesalahan _typo_ yang umum terjadi pada _named routes_ manual.

- **Detail:** Daripada menulis definisi `GoRoute` atau `MaterialPageRoute` secara manual untuk setiap layar, Anda cukup menggunakan _annotations_ pada _widget_ atau kelas `Page` Anda. `Auto Route` kemudian akan menghasilkan kode _router_ yang diperlukan secara otomatis. Ini sangat efisien untuk aplikasi dengan jumlah layar yang besar.

- **Mengapa Menggunakan Auto Route?**

  - **Mengurangi Boilerplate:** Mengeliminasi kebutuhan untuk menulis definisi _route_ secara manual.
  - **Type-Safe Routing:** Argumen _route_ dilewatkan secara _type-safe_ melalui konstruktor yang dihasilkan, mengurangi kesalahan saat runtime.
  - **Pencegahan Kesalahan:** Karena _route_ dihasilkan, kesalahan _typo_ pada nama _route_ atau parameter akan terdeteksi saat kompilasi.
  - **Deep Linking:** Dukungan bawaan untuk _deep linking_ karena basisnya adalah URL.
  - **Nested Routing:** Kemampuan untuk mendefinisikan _nested routes_ dengan mudah.
  - **Route Guards:** Integrasi yang kuat dengan _route guards_ untuk kontrol akses.

- **Auto Route Setup dan Annotations**
  Langkah pertama adalah menambahkan `auto_route` dan `build_runner` (untuk _code generation_) ke `pubspec.yaml` Anda:

  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    auto_route: ^latest_version # Ganti dengan versi terbaru

  dev_dependencies:
    auto_route_generator: ^latest_version # Ganti dengan versi terbaru
    build_runner: ^latest_version # Ganti dengan versi terbaru
  ```

  Kemudian jalankan `flutter pub get`.

  **Annotations Utama:**

  - **`@RoutePage()`:** Digunakan di atas kelas `StatelessWidget` atau `StatefulWidget` yang merepresentasikan sebuah halaman. Ini menandai _widget_ ini sebagai _route page_.
  - **`@AutoRouter()`:** Digunakan pada sebuah _abstract class_ atau _mixin_ (biasanya bernama `AppRouter`) yang akan berisi definisi semua _route_ Anda. Ini adalah titik di mana `auto_route_generator` akan mulai menghasilkan kode.
  - **`@PathParam()` / `@QueryParam()`:** Digunakan pada parameter konstruktor _widget_ halaman untuk secara otomatis mengekstrak _path_ atau _query parameters_.

- **Route Generation Process**
  Setelah mendefinisikan _routes_ dengan _annotations_, Anda perlu menjalankan perintah berikut di terminal Anda untuk menghasilkan kode:

  ```bash
  flutter pub run build_runner build
  ```

  Atau, jika Anda ingin _watch_ perubahan file secara terus-menerus:

  ```bash
  flutter pub run build_runner watch
  ```

  Ini akan menghasilkan file `*.gr.dart` (GoRouter-generated Dart) yang berisi definisi _router_ dan _routes_ yang diperlukan.

- **Contoh Implementasi Lengkap (main.dart & router.dart):**

  Buat file `lib/router/app_router.dart`:

  ```dart
  // lib/router/app_router.dart
  import 'package:auto_route/auto_route.dart';
  import 'package:flutter/material.dart';

  import '../screens/home_screen.dart';
  import '../screens/detail_screen.dart';
  import '../screens/settings_screen.dart';
  import '../screens/login_screen.dart'; // Untuk Route Guards

  part 'app_router.gr.dart'; // Bagian ini akan dihasilkan secara otomatis

  @AutoRouterConfig() // Anotasi untuk menandai AppRouter sebagai konfigurasi router
  class AppRouter extends _$AppRouter { // Perhatikan _$AppRouter
    @override
    List<AutoRoute> get routes => [
          AutoRoute(page: HomeRoute.page, path: '/'),
          AutoRoute(page: DetailRoute.page, path: '/detail/:id'), // Path parameter
          AutoRoute(page: SettingsRoute.page, path: '/settings'),
          AutoRoute(page: LoginRoute.page, path: '/login'),
        ];
  }
  ```

  Buat file `lib/screens/home_screen.dart`:

  ```dart
  // lib/screens/home_screen.dart
  import 'package:auto_route/auto_route.dart';
  import 'package:flutter/material.dart';
  import '../router/app_router.gr.dart'; // Impor rute yang dihasilkan

  @RoutePage() // Anotasi bahwa ini adalah halaman rute
  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigasi type-safe menggunakan Route yang dihasilkan
                  context.pushRoute(DetailRoute(id: 123, name: 'Produk A'));
                },
                child: const Text('Go to Detail (ID 123)'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushRoute(const SettingsRoute());
                },
                child: const Text('Go to Settings'),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

  Buat file `lib/screens/detail_screen.dart`:

  ```dart
  // lib/screens/detail_screen.dart
  import 'package:auto_route/auto_route.dart';
  import 'package:flutter/material.dart';

  @RoutePage()
  class DetailScreen extends StatelessWidget {
    // Auto Route akan secara otomatis mengisi parameter ini
    // dari path atau query parameter, atau arguments.
    final int id;
    final String name;

    const DetailScreen({
      @PathParam('id') required this.id, // Ambil 'id' dari path parameter
      @QueryParam('name') required this.name, // Ambil 'name' dari query parameter
      super.key,
    });

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Detail for Item $id')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Item ID: $id'),
              Text('Item Name: $name'),
            ],
          ),
        ),
      );
    }
  }
  ```

  Buat file `lib/screens/settings_screen.dart`:

  ```dart
  // lib/screens/settings_screen.dart
  import 'package:auto_route/auto_route.dart';
  import 'package:flutter/material.dart';

  @RoutePage()
  class SettingsScreen extends StatelessWidget {
    const SettingsScreen({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.popRoute(), // Pop layar saat ini
            child: const Text('Go Back'),
          ),
        ),
      );
    }
  }
  ```

  Edit file `main.dart`:

  ```dart
  // main.dart
  import 'package:flutter/material.dart';
  import 'package:auto_route/auto_route.dart'; // Penting!
  import 'package:flutter_advanced_course/router/app_router.dart'; // Impor router kita

  void main() {
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    final _appRouter = AppRouter(); // Inisialisasi router kita

    MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp.router(
        routerConfig: _appRouter.config(), // Gunakan config() dari instance AppRouter
        debugShowCheckedModeBanner: false,
      );
    }
  }
  ```

  **Jangan Lupa Jalankan:** `flutter pub run build_runner build` setelah membuat perubahan pada `@RoutePage()` atau `@AutoRouterConfig()`.

- **Visualisasi Auto Route Generation Flow:**

```
┌───────────────────────────────────────┐
│       Source Files (Input)            │
│ ┌───────────────────────────────────┐ │
│ │  lib/router/app_router.dart       │ │
│ │  @AutoRouterConfig()              │ │
│ │  class AppRouter { ... }          │ │
│ ├───────────────────────────────────┤ │
│ │  lib/screens/home_screen.dart     │ │
│ │  @RoutePage()                     │ │
│ │  class HomeScreen { ... }         │ │
│ ├───────────────────────────────────┤ │
│ │  lib/screens/detail_screen.dart   │ │
│ │  @RoutePage()                     │ │
│ │  class DetailScreen { ... }       │ │
│ └───────────────────────────────────┘ │
└────────────────────┬──────────────────┘
                     │ (Processed by)
                     ▼
┌───────────────────────────┐
│    build_runner           │
│ (Code Generation Tool)    │
└────────────┬──────────────┘
             │ (Generates)
             ▼
┌───────────────────────────────────────────────────────────────────┐
│     Generated File: lib/router/app_router.gr.dart                 │
│ (Contains GoRouter-like route definitions, typed arguments, etc.) │
│                                                                   │
│ class HomeRoute extends PageRouteInfo<void> {...}                 │
│ class DetailRoute extends PageRouteInfo<DetailRouteArgs> {...}    │
│ // ... dan definisi router lainnya yang diperlukan                │
└───────────────────────────────────────────────────────────────────┘
```

    **Penjelasan Visual:**
    Diagram ini menunjukkan bagaimana Anda mendefinisikan *routes* dengan *annotations* di berbagai file Dart. Kemudian, `build_runner` membaca *annotations* ini dan secara otomatis menghasilkan file `*.gr.dart` yang berisi semua kode *boilerplate* navigasi yang diperlukan.

- **Nested Routes dengan AutoRoute**
  `Auto Route` mendukung _nested routing_ melalui `AutoRoute` dengan properti `children`. Ini mirip dengan `ShellRoute` di `GoRouter` atau `routes` bersarang.

  ```dart
  // Di lib/router/app_router.dart:
  @AutoRouterConfig()
  class AppRouter extends _$AppRouter {
    @override
    List<AutoRoute> get routes => [
          AutoRoute(
            page: MainShellRoute.page, // Ini adalah shell kita
            path: '/',
            children: [ // Sub-routes untuk shell ini
              AutoRoute(page: HomeRoute.page, path: ''), // Path kosong untuk default tab
              AutoRoute(page: ProfileRoute.page, path: 'profile'),
              AutoRoute(page: SettingsRoute.page, path: 'settings'),
              AutoRoute(page: DetailRoute.page, path: 'detail/:id'), // Detail juga bisa di dalam shell
              // _emptyRoutes: true // Jika ini adalah rute tanpa tampilan, hanya untuk mengelompokkan
            ],
          ),
          AutoRoute(page: LoginRoute.page, path: '/login'), // Rute terpisah, di luar shell
          AutoRoute(page: UnknownRoute.page, path: '*'), // Halaman 404
        ];
  }

  // Buat file lib/screens/main_shell.dart untuk shell UI Anda
  @RoutePage(name: 'MainShellRoute') // Nama rute untuk shell
  class MainShellScreen extends StatelessWidget {
    const MainShellScreen({super.key});

    @override
    Widget build(BuildContext context) {
      // AutoRouter widget akan menampilkan child route yang aktif
      return AutoRouter(); // Ini adalah tempat di mana halaman anak akan ditampilkan
      // Atau Anda bisa membungkusnya dengan Scaffold dan BottomNavigationBar
      // return Scaffold(
      //   body: const AutoRouter(), // Child route
      //   bottomNavigationBar: BottomNavigationBar(...),
      // );
    }
  }

  // Di main.dart, navigasi normal:
  // context.go('/profile'); // Akan menampilkan Shell dengan ProfileRoute di dalamnya
  // context.go('/detail/456'); // Akan menampilkan Shell dengan DetailRoute di dalamnya
  ```

- **Visualisasi Nested Routes dengan AutoRoute:**

  ```
  AppRouter (Root)
  └── routes: <AutoRoute>[]
      ├── AutoRoute (page: MainShellRoute.page, path: '/')
      │   └── children: <AutoRoute>[] (Nested Navigator)
      │       ├── AutoRoute (page: HomeRoute.page, path: '') -> Full path: /
      │       ├── AutoRoute (page: ProfileRoute.page, path: 'profile') -> Full path: /profile
      │       ├── AutoRoute (page: SettingsRoute.page, path: 'settings') -> Full path: /settings
      │       └── AutoRoute (page: DetailRoute.page, path: 'detail/:id') -> Full path: /detail/:id
      └── AutoRoute (page: LoginRoute.page, path: '/login')
      └── AutoRoute (page: UnknownRoute.page, path: '*')
  ```

  **Penjelasan Visual:**
  Struktur _tree_ menunjukkan bagaimana `MainShellRoute` bertindak sebagai _parent_ untuk beberapa _child routes_. `AutoRouter()` _widget_ di dalam `MainShellScreen` adalah tempat konten dari _child routes_ ini akan di-_render_.

- **Route Guards Implementation**
  `Auto Route` menyediakan konsep `AutoRouteGuard` untuk melindungi _route_. Anda dapat melampirkan _guard_ ke `AutoRoute` atau `AutoRouterConfig`.

  ```dart
  // 1. Buat kelas Guard Anda
  import 'package:auto_route/auto_route.dart';
  import 'package:flutter/material.dart'; // Untuk MaterialApp

  // Asumsi AuthManager sebagai state management Anda
  class AuthManager {
    bool isLoggedIn = false;
    // ... (metode login/logout)
  }

  class AuthGuard extends AutoRouteGuard {
    final AuthManager authManager; // Dapatkan instance AuthManager melalui constructor

    AuthGuard(this.authManager);

    @override
    void onNavigation(NavigationResolver resolver, StackRouter router) {
      if (authManager.isLoggedIn) {
        // Jika sudah login, lanjutkan navigasi ke route yang dituju
        resolver.next(true);
      } else {
        // Jika belum login, redirect ke halaman login
        router.push(LoginRoute()); // Navigasi ke halaman login
        resolver.next(false); // Jangan lanjutkan navigasi ke route awal
      }
    }
  }

  // 2. Terapkan Guard di AppRouter
  // lib/router/app_router.dart
  @AutoRouterConfig()
  class AppRouter extends _$AppRouter {
    final AuthGuard authGuard;

    AppRouter({required this.authGuard}); // Injeksi guard melalui konstruktor

    @override
    List<AutoRoute> get routes => [
          AutoRoute(page: HomeRoute.page, path: '/'),
          AutoRoute(page: DashboardRoute.page, path: '/dashboard', guards: [authGuard]), // Protected route
          AutoRoute(page: LoginRoute.page, path: '/login'),
        ];
  }

  // Buat kelas DashboardScreen
  @RoutePage()
  class DashboardScreen extends StatelessWidget {
    const DashboardScreen({super.key});
    @override
    Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: const Text('Dashboard')), body: const Center(child: Text('Welcome to your Dashboard!')));
    }
  }

  // Di main.dart, Anda perlu memberikan instance AuthGuard ke AppRouter:
  // Contoh di main.dart:
  // final _authManager = AuthManager(); // Atau dari Provider/BLoC
  // final _appRouter = AppRouter(authGuard: AuthGuard(_authManager));
  ```

- **Visualisasi Auto Route Guard Flow:**

  ```
  ┌───────────────────────────┐
  │     User Tries to go to   │
  │       '/dashboard'        │
  └────────────┬──────────────┘
               │ context.pushRoute(DashboardRoute())
               ▼
  ┌───────────────────────────────┐
  │   AutoRoute (DashboardRoute)  │
  │       guards: [authGuard]     │
  └────────────┬──────────────────┘
               │ Call authGuard.onNavigation()
               ▼
  ┌───────────────────────────────┐
  │       AuthGuard               │
  │ (Check AuthManager.isLoggedIn)│
  └────────────┬──────────────────┘
     ┌─────────┴─────────┐
     ▼                   ▼
  ┌───────────┐     ┌───────────────┐
  │ Logged In │     │ Not Logged In │
  └─────┬─────┘     └─────────────┬─┘
        │                         │   
        ▼                         ▼   
  ┌────────────────────┐       ┌───────────────────────────┐
  │ resolver.next(true)│       │ router.push(LoginRoute()) │
  │                    │       │ resolver.next(false)      │
  │                    │       │                           │
  │Proceed to Dashboard│       │ Redirect to Login         │
  └────────────────────┘       └───────────────────────────┘
  ```

  **Penjelasan Visual:**
  Ketika navigasi dipicu ke _route_ yang dilindungi, `Auto Route` akan memanggil `onNavigation` pada `AutoRouteGuard` yang terkait. _Guard_ kemudian memeriksa kondisi (misalnya, status _login_) dan memutuskan apakah akan melanjutkan navigasi ke _route_ yang diminta (`resolver.next(true)`) atau mengarahkan ke _route_ lain (`router.push()` dan `resolver.next(false)`).

- **Auto Route Testing:**
  Testing dengan `Auto Route` menjadi lebih mudah karena Anda bisa menguji _route_ yang dihasilkan dan memastikan _builder_ yang benar dipanggil, serta argumen dilewatkan dengan benar. Anda bisa menguji `AppRouter` Anda dengan membuat instance-nya dan memanggil metode `go()` atau `push()` pada instance `router` tersebut dalam lingkungan _test_.

```dart
    // Contoh Test (mocking AuthManager)
 import 'package:flutter_test/flutter_test.dart';
 import 'package:auto_route/auto_route.dart';
 import 'package:mockito/mockito.dart'; // Untuk mocking

 class MockAuthManager extends Mock implements AuthManager {}

 void main() {
   group('AppRouter Guard Tests', () {
     late MockAuthManager mockAuthManager;
     late AppRouter router;

     setUp(() {
       mockAuthManager = MockAuthManager();
       router = AppRouter(authGuard: AuthGuard(mockAuthManager));
     });

     test('redirects to login if not logged in', () async {
       when(mockAuthManager.isLoggedIn).thenReturn(false);

       // Coba navigasi ke protected route
       await router.push(const DashboardRoute());

       // Verifikasi bahwa router mencoba push LoginRoute
       expect(router.currentPath, '/login'); // Atau cara lain untuk memverifikasi navigasi
     });

     test('allows navigation if logged in', () async {
       when(mockAuthManager.isLoggedIn).thenReturn(true);

       await router.push(const DashboardRoute());

       expect(router.currentPath, '/dashboard');
     });
   });
 }
```

- **Terminologi Esensial Auto Route:**

  - **`@RoutePage()`:** Anotasi pada _widget_ halaman untuk menandainya sebagai _route_.
  - **`@AutoRouterConfig()`:** Anotasi pada kelas _router_ untuk memicu _code generation_.
  - **`_$.AppRouter`:** Kelas _mixin_ yang dihasilkan oleh _code generator_ untuk `AppRouter`.
  - **`*.gr.dart`:** File yang dihasilkan oleh `auto_route_generator`.
  - **`context.pushRoute()` / `context.replaceRoute()` / `context.popRoute()`:** Metode navigasi _type-safe_ yang dihasilkan.
  - **`PageRouteInfo`:** Objek yang dihasilkan untuk setiap _route_, merepresentasikan informasi _route_ termasuk argumen _type-safe_.
  - **`@PathParam()` / `@QueryParam()`:** Anotasi untuk otomatis mengekstrak _path_ dan _query parameters_.
  - **`AutoRouteGuard`:** Kelas untuk mengimplementasikan logika proteksi _route_.
  - **`resolver.next(true/false)`:** Metode di `AutoRouteGuard` untuk melanjutkan atau menghentikan navigasi.
  - **`router.push()`:** Metode `StackRouter` di dalam _guard_ untuk memicu navigasi lain (misalnya _redirect_).

- **Hubungan dengan Bagian Lain:**

  - **Code Generation:** Bergantung pada `build_runner` untuk menghasilkan kode, yang merupakan konsep penting dalam Flutter untuk mengurangi _boilerplate_.
  - **State Management:** Integrasi yang erat untuk mengelola _state_ yang memengaruhi _route guards_ atau alur navigasi.
  - **Testing:** Struktur _type-safe_ yang dihasilkan mempermudah pengujian unit dan integrasi navigasi.

- **Tips & Best Practices (untuk peserta):**

  - **Gunakan `.gr.dart`:** Selalu impor file `.gr.dart` Anda untuk mengakses _route_ yang dihasilkan (misalnya `HomeRoute`).
  - **Organisasi File:** Pisahkan definisi `AppRouter` dan _screens_ ke dalam file yang berbeda untuk menjaga kebersihan kode.
  - **Rebuild Sering:** Pastikan untuk menjalankan `flutter pub run build_runner watch` saat Anda mengembangkan untuk memastikan _route_ Anda selalu terbarui.
  - **Pahami Generasi Kode:** Meskipun otomatis, memahami bagaimana _route_ dihasilkan dapat membantu saat _debugging_.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** Lupa menjalankan `build_runner` setelah menambahkan atau memodifikasi _route_.
    - **Solusi:** Periksa _output_ konsol `build_runner` untuk kesalahan dan pastikan Anda menjalankan ulang perintah `build` atau `watch` setiap kali ada perubahan pada anotasi _route_ Anda.
  - **Kesalahan:** Kesalahan kompilasi karena parameter yang tidak cocok antara definisi _route_ dan konstruktor _widget_ (misalnya, `id` sebagai `int` di _path_ tetapi _constructor_ mengharapkan `String`).
    - **Solusi:** Periksa kembali tipe data parameter di _path_ Anda dan pastikan konstruktor _widget_ menerima tipe data yang sesuai. `Auto Route` akan membantu mendeteksi ini saat _code generation_.
  - **Kesalahan:** `Route guard` tidak berfungsi seperti yang diharapkan atau menyebabkan _redirect loop_.
    - **Solusi:** Debug _guard_ Anda dengan `print` atau _debugger_ untuk melihat kondisi `onNavigation` dan `resolver.next()` yang dieksekusi. Pastikan logika `redirect` Anda memiliki kondisi keluar yang jelas.

---

Kita telah menyelesaikan pembahasan **Auto Route & Code Generation**. Ini melengkapi diskusi kita tentang _Advanced Navigation_ di **FASE 4**.

Selanjutnya, kita akan beralih ke **6.3 Deep Linking & URL Handling**, yang merupakan bagian terakhir dari FASE 4.

Apakah Anda siap untuk melanjutkan, atau ada pertanyaan lebih lanjut tentang **Auto Route**?

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md
[pro4]: ../../pro/bagian-4/README.md

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
