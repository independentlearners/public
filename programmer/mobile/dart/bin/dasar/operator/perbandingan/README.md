# Operator Perbandingan

Operator Perbandingan adalah operator yang digunakan untuk membandingkan dua nilai dimana hasilnya adalah tipe data boolean, yaitu `true` atau `false`.

#

- `==`

  - Sama dengan

- `!=`

  - Tidak sama dengan

- `>`

  - Lebih besar dari

- `<`

  - Lebih kecil dari

- `>=`

  - Lbih besar dari atau sama dengan

- `<=`
  - Lebih kecil dari atau sama dengan

### Contoh

```dart
void main() {
  print('\n' * 5);

  print(10 == 5);
  print(20 != 10);
  print(10 > 5);
  print(20 < 2);
  print(10 >= 3);
  print(20 <= 2);
  // print(
  //   '${10 == 5}\n'
  //   '${20 != 10}\n'
  //   '${10 > 5}\n'
  //   '${20 < 2}\n'
  //   '${10 >= 3}\n'
  //   '${20 <= 2}\n',
  // );

  print('saya' == 'saya'); // true
  print('saya' != 'saya'); // false

  print('\n' * 5);
}
```

#### $Kode Saya$

```dart
import '../../saya.dart';

void main() {
  print(bawah);

  print('$merah${10 == 5}$reg'
      '$biru${20 != 10}$reg'
      '$kuning${10 > 5}$reg'
      '$hijau${20 < 2}$reg'
      '$ungu${10 >= 3}$reg'
      '$cyan${20 <= 2}$reg');

  print('saya' == 'saya'); // true
  print('saya' != 'saya'); // false

  print(atas);
}
```

#

> [Dokumentasi Resmi tentang operator perbandingan](https://dart.dev/guides/language/language-tour#comparison-operators "dar.dev")
