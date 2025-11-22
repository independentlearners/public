# Spacer

### Mengatur Jarak Antar Widget

**`Spacer(),`**

```dart
import 'package:flutter/material.dart';

void main() => runApp(
      My(),
    );

class My extends StatelessWidget {
  const My({super.key});

  @override
  Widget build(
    BuildContext context,
  ) =>
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Spacer Widget',
            ),
          ),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(
                  flex: 1,
                ), // Menambahkan area kosong
                warnaKontainer(
                  Colors.red,
                ),
                Spacer(
                  flex: 3, // Atur nilai perbandingan
                ),
                warnaKontainer(
                  Colors.green,
                ),
                Spacer(
                  flex: 1,
                ),
                warnaKontainer(
                  Colors.blue,
                ),
              ],
            ),
          ),
        ),
      );

  // Komposisi Widget
  warnaKontainer(
    Color color,
  ) => // Nilai Pengembalian
      Container(
        width: 80,
        height: 80,
        color: color,
      );
}
```
