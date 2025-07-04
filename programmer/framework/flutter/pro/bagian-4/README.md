> pro

# **[FASE 4: Navigation & Routing][0]**

### Daftar Isi

<details>
  <summary>📃 Struktur Materi</summary>

- **[6. Navigation Architecture](#6-navigation-architecture)**
  - **[6.1. Basic Navigation](#61-basic-navigation)**
    - [6.1.1. Navigator 1.0](#611-navigator-10)
  - **[6.2. Advanced Navigation](#)**
    - [6.2.1. Navigator 2.0 (Router API)](#)
    - [6.2.2. GoRouter Implementation](#)
    - [6.2.3. Auto Route & Code Generation](#)
  - **[6.3. Deep Linking & URL Handling](#)**
    - [6.3.1. Web URL Strategies](#)
    - [6.3.2. Mobile Deep Linking](#)

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
- **Video Penjelasan:** [Navigator (Flutter Widget of the Week)](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3D_Y_-JJ5sn3g)

---

Kita telah membahas fondasi navigasi dengan Navigator 1.0. Ini adalah sistem yang kuat dan memadai untuk banyak jenis aplikasi.

Selanjutnya, kita akan melihat bagaimana sistem ini berevolusi untuk menangani skenario yang lebih kompleks seperti _nested routing_ dan sinkronisasi URL di web.

Mohon konfirmasinya jika Anda siap untuk melanjutkan ke **6.2.1 Navigator 2.0 (Router API)**.

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
