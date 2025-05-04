
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
// Ruang masuk untuk setiap kode yang akan dieksekusi dan ditampilkan

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Widget ini adalah akar aplikasi Anda.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Ini adalah tema aplikasi Anda.
        //
        // COBA INI: Coba jalankan aplikasi Anda dengan "flutter run". Anda akan melihat
        // aplikasi memiliki bilah alat berwarna ungu. Kemudian, tanpa keluar dari aplikasi,
        // coba ubah seedColor dalam colorScheme di bawah ini menjadi Colors.green
        // lalu panggil "hot reload" (simpan perubahan Anda atau tekan tombol "hot
        // reload" di IDE yang didukung Flutter, atau tekan "r" jika Anda menggunakan
        // baris perintah untuk memulai aplikasi).
        //
        // Perhatikan bahwa penghitung tidak disetel ulang ke nol; status aplikasi
        // tidak hilang selama pemuatan ulang. Untuk menyetel ulang status, gunakan hot
        // restart sebagai gantinya.
        //
        // Ini juga berlaku untuk kode, bukan hanya nilai: Sebagian besar perubahan kode dapat
        // diuji hanya dengan hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Widget ini adalah beranda aplikasi Anda. Widget ini bersifat stateful, artinya
  // widget ini memiliki objek State (didefinisikan di bawah) yang berisi kolom yang memengaruhi
  // tampilannya.

  // Kelas ini adalah konfigurasi untuk status.
  // Kelas ini menyimpan nilai (dalam hal ini judul) yang disediakan oleh induk (dalam hal ini widget Aplikasi)
  // dan digunakan oleh metode pembuatan Status. Kolom dalam subkelas Widget selalu ditandai "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // Panggilan ke setState ini memberi tahu framework Flutter bahwa ada sesuatu yang telah
      // berubah dalam State ini, yang menyebabkannya menjalankan ulang metode build di bawah
      // sehingga tampilan dapat mencerminkan nilai yang diperbarui. Jika kita mengubah
      // _counter tanpa memanggil setState(), maka metode build tidak akan
      // dipanggil lagi, sehingga tidak akan terjadi apa-apa.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Metode ini dijalankan ulang setiap kali setState dipanggil, misalnya seperti yang dilakukan
    // oleh metode _incrementCounter di atas.
    //
    // Kerangka kerja Flutter telah dioptimalkan untuk membuat metode pembuatan ulang
    // cepat, sehingga Anda dapat membangun ulang apa pun yang perlu diperbarui alih-alih
    // harus mengubah contoh widget satu per satu.
    return Scaffold(
      appBar: AppBar(
        // COBA INI: Coba ubah warna di sini ke warna tertentu (mungkin ke
        // Colors.amber?) dan picu hot reload untuk melihat AppBar
        // ubah warna sementara warna lainnya tetap sama.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Di sini kita mengambil nilai dari objek MyHomePage yang dibuat oleh
        // metode App.build, dan menggunakannya untuk mengatur judul appbar kita.
        title: Text(widget.title),
      ),
      body: Center(
        // Center adalah widget tata letak. Widget ini mengambil satu anak dan menempatkannya
        // di tengah induk.
        child: Column(
          // Kolom juga merupakan widget tata letak. Widget ini mengambil daftar anak-anak dan
          // mengaturnya secara vertikal. Secara default, ukurannya sendiri agar sesuai dengan
          // anak-anaknya secara horizontal, dan mencoba untuk setinggi induknya.
          //
          // Kolom memiliki berbagai properti untuk mengontrol bagaimana ukurannya sendiri dan
          // bagaimana memposisikan anak-anaknya. Di sini kita menggunakan mainAxisAlignment untuk
          // memusatkan anak-anak secara vertikal; sumbu utama di sini adalah sumbu vertikal
          // karena Kolom bersifat vertikal (sumbu silang akan menjadi
          // horizontal).
          //
          // COBA INI: Panggil "debug painting" (pilih tindakan "Toggle Debug Paint"
          // di IDE, atau tekan "p" di konsol), untuk melihat
          // wireframe untuk setiap widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // Tanda koma yang ditambahkan membuat pemformatan otomatis lebih baik untuk metode pembuatan.
    );
  }
}

```
