```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Menyimpan widget teks yang akan ditampilkan
  List<Widget> widgets = [];
  // Counter untuk menampilkan nomor data
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('List View')),
        body: ListView(
          children: [
            // Baris tombol untuk tambah dan hapus data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Menambahkan widget teks baru dan menaikkan counter
                      widgets.add(Text("data ke - ${counter.toString()}"));
                      ++counter;
                    });
                  },
                  child: const Text('tambah data'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Menghapus widget terakhir bila list tidak kosong
                      if (widgets.isNotEmpty) {
                        widgets.removeLast();
                        --counter;
                      }
                    });
                  },
                  child: const Text('hapus data'),
                ),
              ],
            ),
            // Menampilkan semua widget teks yang telah ditambahkan
            ...widgets,
          ],
        ),
      ),
    );
  }
}
```