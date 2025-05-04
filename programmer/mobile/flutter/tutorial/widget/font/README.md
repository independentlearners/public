# Font Style

Menambahkan font Google ke proyek Flutter cukup mudah dan bisa dilakukan dengan menggunakan package `google_fonts`. Berikut langkah-langkahnya:

### 1. Tambahkan Dependensi

Buka file `pubspec.yaml` dan tambahkan package `google_fonts`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0 # Pastikan versi terbaru
```

Lalu jalankan perintah berikut di terminal:

```sh
flutter pub get
```

### 2. Gunakan Font Google di Aplikasi

Di dalam kode Flutter, gunakan `GoogleFonts` untuk mengatur font pada `TextStyle`. Contoh penggunaan:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Google Fonts di Flutter')),
        body: Center(
          child: Text(
            'Halo, dunia!',
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
```

### 3. Menggunakan Font Secara Global

Untuk mengaplikasikan font ke seluruh aplikasi, gunakan `theme` pada `MaterialApp`:

```dart
return MaterialApp(
  theme: ThemeData(
    textTheme: GoogleFonts.latoTextTheme(),
  ),
);
```

### 4. Menampilkan Daftar Font Google

Jika ingin melihat daftar font yang tersedia, kamu bisa mengunjungi [Google Fonts](https://fonts.google.com).
#
Ketika kamu sudah terbiasa dengan Flutter, menggunakan `google_fonts` ini akan mempercepat styling dibanding mengatur font secara manual.

```dart
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import "package:google_fonts/google_fonts.dart" show GoogleFonts;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String message = 'halo masbro';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Text Style',
            style: GoogleFonts.allura(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Alam semesta didalam dirimu',
            style: GoogleFonts.aboreto(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
```
