### Riverpod
Adalah sebuah package untuk manajemen state dalam pengembangan aplikasi Flutter. Riverpod dirancang untuk menjadi lebih aman, fleksibel, dan mudah digunakan dibandingkan dengan package manajemen state lainnya seperti Provider.

Berikut adalah beberapa fitur utama dari Riverpod:
#
**Immutability**:
Riverpod mendorong penggunaan state yang tidak dapat diubah, yang membantu mengurangi bug dan membuat aplikasi lebih mudah untuk diuji.

**Compile-time safety**: Riverpod memberikan jaminan keamanan pada waktu kompilasi, sehingga kesalahan dapat ditemukan lebih awal dalam proses pengembangan.

**Provider Scope**: Riverpod memungkinkan Anda untuk mendefinisikan scope dari provider, sehingga Anda dapat mengontrol kapan dan di mana state diinisialisasi dan dihancurkan.

**Dependency Injection**: Riverpod mendukung dependency injection, yang memungkinkan Anda untuk mengelola dependensi dengan lebih mudah dan membuat kode lebih modular.

Berikut adalah contoh sederhana penggunaan Riverpod:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Definisikan sebuah provider
final counterProvider = StateProvider<int>((ref) => 0);

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Riverpod Example')),
        body: Center(
          child: Consumer(builder: (context, watch, child) {
            final count = watch(counterProvider).state;
            return Text('$count');
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read(counterProvider).state++;
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
```

Dalam contoh di atas, counterProvider adalah sebuah provider yang menyimpan state berupa integer. Dengan menggunakan Consumer, kita dapat mengakses dan menampilkan nilai dari provider tersebut di dalam widget. Tombol FloatingActionButton digunakan untuk menambah nilai counter setiap kali ditekan.

Riverpod menawarkan cara yang lebih terstruktur dan aman untuk mengelola state dalam aplikasi Flutter, membuatnya menjadi pilihan yang populer di kalangan pengembang Flutter.
