# widget text

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    "maxLines";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("ini adalah AppBar")),
        body: Center(
          child: Container(
            width: 150,
            height: 100,
            color: Colors.lightBlue,
            child: Text(
              "Halo dunia, oke google, oke siap",
              maxLines: 2,
              // membatasi susunan baris teks secara vertikal
              overflow: TextOverflow.fade,
              // menyesuaikan tampilan teks
              textAlign: TextAlign.center,
              // menyesuaikan posisi teks
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
              // mengatur gaya teks seperti model italic atau bold
            ),
          ),
        ),
      ),
    );
  }
}
```
