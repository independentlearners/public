# Dynamic

Dynamic adalah tipe data yang bisa menampung berbagai jenis tipe data lainnya seperti

```dart
int, double, String, bool, List, Map,
// dan sebagainya.
```

Ini sangat berguna ketika kita tidak tahu tipe data yang akan kita gunakan atau ketika kita ingin membuat variabel yang bisa menampung berbagai jenis tipe data.

#### Mendeklarasikan variabel dengan tipe data dynamic

```dart
void main() {
dynamic name;

name = 'Amir';
print('name = $name');

name = 12;
print('name = $name');

name = 1.0;
print('name = $name');

name = false;
print('name = $name');

name = name;
print('name = $name');
}
```

#

Beberapa sumber dokumentasi resmi dan postingan komunitas mengenai tipe data `dynamic` di Dart:

### Dokumentasi Resmi

1. **Dart Documentation - Built-in Types**: Dokumentasi resmi Dart mengenai tipe data bawaan termasuk `dynamic` yang bisa kamu baca di [dokumentasi Dart](https://dart.dev/language/built-in-types).
2. **The Dart Type System**: Penjelasan lebih mendalam tentang tipe sistem di Dart dapat ditemukan di [Dart Type System](https://dart.dev/language/type-system).

### Postingan Komunitas di DEV.to dan Medium

1. **Postingan di DEV.to mengenai Dart Types**: Artikel ini oleh Daniel Ko memberikan penjelasan tentang berbagai tipe data di Dart, termasuk `dynamic` yang tersedia di [dev.to](https://dev.to/danko56666/dart-types-17je).
2. **Var vs Dynamic in Dart**: Postingan oleh Nitish Kumar Singh yang membahas perbedaan antara `var` dan `dynamic` di Dart tersedia di [dev.to](https://dev.to/nitishk72/var-vs-dynamic-in-dart-29al).
3. **Dart Type Cast: Converting Between Data Types**: Artikel ini di DhiWise memberikan panduan mendetail tentang konversi tipe data di Dart, termasuk `dynamic`, bisa ditemukan di [dhiwise.com](https://www.dhiwise.com/post/the-ultimate-guide-to-dart-type-cast-converting-data-types).
