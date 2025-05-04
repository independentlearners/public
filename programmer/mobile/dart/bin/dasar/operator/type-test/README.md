# Operator Type Test

Tentu! Operator jenis tes di Dart adalah operator yang digunakan untuk memeriksa tipe suatu objek pada waktu proses. Berikut adalah beberapa operator jenis tes yang sering digunakan dalam bahasa Dart:

1. **`is`**: Mengecek apakah objek tersebut adalah tipe yang ditentukan.
2. **`is!`**: Mengecek apakah objek tersebut bukan tipe yang ditentukan.
3. **`as`**: Untuk melakukan casting tipe (type conversion) ke tipe yang diinginkan, yang mungkin akan menimbulkan pengecualian jika tipe sebenarnya tidak sesuai.

### Contoh Penggunaan:

```dart
void main() {
  var number = 42;
  var text = 'Flutter';

  // Menggunakan 'is' untuk mengecek tipe
  if (number is int) {
    print('number adalah int');
  }

  // Menggunakan 'is!' untuk mengecek apakah objek bukan tipe yang ditentukan
  if (text is! int) {
    print('text bukan int');
  }

  // Menggunakan 'as' untuk casting tipe
  dynamic something = 'Dart';
  var length = (something as String).length;
  print('Panjang teks: $length');
}
```

### Penjelasan:

- `number is int`: Mengecek apakah `number` adalah tipe `int`.
- `text is! int`: Mengecek apakah `text` bukan tipe `int`.
- `something as String`: Men-cast tipe dari `something` ke `String`.

### Dokumentasi:

Untuk informasi lebih lanjut mengenai operator jenis tes di Dart, kunjungi dokumentasi resmi [Dart disini](https://dart.dev/guides/language/type-system#type-predicates "dart.dev.type-predicates").

> [Atau Disini](https://dart.dev/guides/language/language-tour#type-test-operators "dart.dev.type-test-operators")

# Kode saya

```dart
import '../../saya.dart';

void main() {
  print('$pembatas Metode: is dalam operator type test$rege');
  // ignore: prefer_function_declarations_over_variables
  dynamic tipe = (dynamic value) => value;
  var nama = tipe('Dian');
  var umur = tipe(20);
  var nilai = tipe(80.5);

  if (nama is String) {
    print('$merah Nama: $nama$reset');
  }
  if (umur is int) {
    print('$biru Umur: $umur$reset');
  }
  if (nilai is double) {
    print('$hijau Nilai: $nilai$rege');
  } else {
    return;
  }

  print('$merah ${nama is String} => tipe di inisialisasi dengan benar$rege');
  print('$biru ${umur is int} => tipe di inisialisasi dengan benar$rege');
  print('$hijau ${nilai is double} => tipe di inisialisasi dengan benar$rege');

  // ^ Operator type test juga bisa digunakan untuk mengecek tipe data dari variabel yang bertipe data null.
  print('$pembatas Metode: as dan is! dalam operator type test$rege');

  var string = nama as String; // ^ selain String akan error 😅
  print('$merah $string ${string is! int} $rege');

  var integer = umur as int; // ^ selain int akan error 😁
  print('$biru $integer ${integer is! bool} $rege');

  var doubel = nilai as double; // ^ selain double akan error 😀
  print('$hijau $doubel ${doubel is! double} $rege'); // ! Output: 80.5 true
}
```
