# Main Function

Sebelum masuk pada pembahasan widget kita perlu memahami dengan baik mengenai berikut

```dart
void main() => runApp(const MyApp());
```

Fungsi `main()` adalah titik pertama aplikasi dimulai, kode tersebut merupakan singkatan dari penulisan seperti berikut

```dart
void main() {
  runApp(const MyApp());
}
```

**Mari kita bahas secara rinci:**

- `void main()` → Ini adalah fungsi utama dalam aplikasi Dart, yang pertama kali dijalankan saat aplikasi dimulai.
- `runApp(const MyApp());` → Fungsi ini digunakan untuk menjalankan aplikasi Flutter. `runApp()` akan menampilkan widget yang diberikan sebagai argumen dalam pohon widget utama aplikasi.
- `const MyApp` → `MyApp` adalah widget utama dari aplikasi ini, dan kata kunci `const` digunakan untuk mengoptimalkan kinerja dengan membuatnya sebagai instance konstanta.

Dengan kata lain, kode ini memulai aplikasi Flutter dengan `MyApp` sebagai widget utama. Bagian ini adalah ruang masuk untuk setiap kode yang akan dieksekusi dan ditampilkan, untuk saat ini kode masih akan terbaca error karena terdapat beberapa komponen yang harusnya dilengkapi karenenya disinilah kita masuk pada berukutnya mengenai `StatelessWidget`.

# StatelessWidget

Ini adalah Widget satatis yang tidak akan berubah-ubah atau kita bisa mengartikannya sebagai benda padat yang sifatnya mati, sebab konsepnya berbeda dengan sesuatu yang sifatnya hidup seperti benda hidup atau sesuatu yang sifatnya berkembang. Dalam flutter benda hidup disebut `StatefulWidget` Widget ini adalah bagian yang yang berkembang seperti `tombol` pada contoh mudahnya, jadi dia adalah wiget dinamis. Sampai disini kita sudah paham bahwa terdapat dua konsep benda dalam flutter yang perlu kita pahami dengan baik sebagai dasar awal dari pembelajaran. Untuk saat ini kita akan fokus terlebih dahulu pada pembahasan `StatelessWidget`

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```
