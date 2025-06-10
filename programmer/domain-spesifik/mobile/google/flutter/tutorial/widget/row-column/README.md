# Tataletak

**Column**

Menyusun Kebawah

`mainAxisAlignment: MainAxisAlignment.center,` Mengatur secara vertikal

`crossAxisAlignment: CrossAxisAlignment.start,` Mengatut secara horizontal

#

**Row**

Menyusun Kesamping

`mainAxisAlignment: MainAxisAlignment.center,` Mengatur secara horizontal

`crossAxisAlignment: CrossAxisAlignment.start,` Mengatut secara vertikal

#

Kelas `MyApp` adalah bagian yang akan mengikuti semua yang ada di dalam `StatelessWidget`

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
```
Metode `build(BuildContext context)` adalah tempat dimana arsitektur dibangun

```dart
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
```

`debugShowCheckedModeBanner`
Menghapus banner

```dart
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
```


```dart
      // darkTheme: ThemeData(colorScheme: ColorScheme.dark()), // explorasi
      home: Scaffold(
        appBar: AppBar(
          title: Text('Row dan Column'),
          centerTitle: true, // explorasi
        ),
        body: Column(
          // tataletak horizontal
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          // properti tataletak
          children: [
            Text('Column Satu'),
            Text('Column Dua'),
            Text('Column Tiga'),
            Row(
              // tataletak vertikal
              children: [Text('Row Satu'), Text('Row Dua'), Text('Row Tiga')],
            ),
          ],
          // objek widget
        ),
      ),
    );
  }
}
```
