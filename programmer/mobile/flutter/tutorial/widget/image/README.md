```dart
import 'package:flutter/material.dart';

void main() => runApp(My());

class My extends StatelessWidget {
  const My({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                color: Colors.black,
                height: 200,
                width: 200,
                padding: EdgeInsets.all(3),
                child: Image(
                  image: AssetImage(
                    "assets/spon.jpg",
                  ),
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeat,
                ),
              ),
              Container(
                color: Colors.black,
                height: 200,
                width: 200,
                padding: EdgeInsets.all(3),
                child: Image(
                  image: NetworkImage(
                    "https://i.scdn.co/image/ab6761610000e5eb877d4c061d08c040974224be",
                  ),
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Tambahkan dependensi di dalam file

### pubspec.yaml

```yaml
name: proyekFlutter
description: "A new Flutter project."
publish_to: "none"
version: 0.1.0

environment:
  sdk: ^3.5.0-32.0.dev

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

# Bagian berikut untuk mendaftarkan asetnya

flutter:
  uses-material-design: true
  assets:
    - assets/spon.jpg
```
