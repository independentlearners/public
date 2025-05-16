# Operator aritmatika

Operator aritmatika digunakan untuk melakukan operasi matematika seperti penjumlahan, pengurangan, perkalian, pembagian, dan modulus.

- `+` penjumlahan _(Pertambahan)_
- `-` Expression _(Pengurangan atau Negatif)_
- `*` perkalian
- `/` pembagian _(Hasil **double**)_
- `%` modulus _(Sisa Bagi)_
- `~/` div _(Hasil **int**)_

#

#### Kode saya

```dart
void main() {
  print('\n' * 5);

  var a = 10 + 5;
  var b = 20 - 10;
  var c = 10 * 5;
  var d = 20 / 2;
  var e = 10 % 3;
  var f = 20 ~/ 2;

  print(a);
  print('=' * 5 + '\n');

  print(b);
  print('=' * 5 + '\n');

  print(c);
  print('=' * 5 + '\n');

  print(d);
  print('=' * 5 + '\n');

  print(e);
  print('=' * 5 + '\n');

  print(f);
  print('=' * 5 + '\n');

  print('\n' * 5);
}
```

#

> [**Dokumentasi Resmi**](https://dart.dev/guides/language/language-tour#arithmetic-operators "dart.dev") tentang operator aritmatika di dart
