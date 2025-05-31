# $Boolean-to-String$

Untuk mengkonversi tipe data `bool` ke `String`, gunakan metode `toString()`

**Eksplisit**

```dart
void main() {
  bool inputBool = false;
  String inputString = inputBool.toString();

  print(inputBool);
  print(inputString);
}
```

**Implisit**

Jika kamu ingin mengonversi string ke boolean menggunakan `contains()`, kamu tetap bisa membuat fungsi custom, seperti:

```dart
bool parseBoolean(String value) {
  return value.toLowerCase().contains('true');
}
```

Dengan begitu, kamu bisa mengonversi string yang mengandung `'true'` menjadi boolean `true`. Tetapi ingat bahwa ini tidak akan bekerja untuk _strings_ yang hanya mengandung `'true'` sebagai bagian dari kata lainnya (misalnya, `'a true statement'`), jadi tetap harus berhati-hati dalam penggunaannya.

#

_Menggunakan metode `contains()`_

Metode `contains()` di Dart digunakan untuk memeriksa apakah sebuah substring terdapat dalam string. Tapi perlu diingat bahwa metode ini tidak mengonversi string ke boolean, hanya memastikan sebuah keadaan dimana hasilnya akan mengembalikan nilai `bool`.

Berikut contoh penggunaannya metode `contains()`:

```dart
void main() {
  String str = 'true';

  if (str.contains('true')) {
    print('String contains true');
  } else {
    print('String does not contain true');
  }

  // mengubah nilai dari variabel str selain kata 'true' dan sebagainya akan menghasilkan output:
  'String does not contain true';
}
```

Tipe pengonversi data boolean semacam ini harus dilakukan secara eksplisit, karena Dart tidak menyediakan metode parse untuk tipe data boolean. Dan metode contains yang mengonversi tipe data string ke boolean seperti ini dilakukan untuk memastikan kedua variable memiliki nilai yang sama dimana hasilnya akan menunjukan tipe data Boolean.

#

Cara lain untuk melakukan hal yang sama sebagaimana penggunaan `contains()` adalah dengan mengkonversi tipe data string ke boolean menggunakan operator `==` dimana ini akan membandingkan string dengan boolean dan hasilnya akan mengembalikan nilai boolean apabila nilainya tidak sama

Operator `==` di Dart digunakan untuk membandingkan dua nilai atau objek. Berikut adalah beberapa contoh penggunaannya:

### Membandingkan Bilangan

```dart
void main() {
  int a = 10;
  int b = 20;

  if (a == b) {
    print('a is equal to b');
  } else {
    print('a is not equal to b');
  }
  // Output: a is not equal to b
}
```

### Membandingkan String

```dart
void main() {
  String str1 = 'hello';
  String str2 = 'hello';

  if (str1 == str2) {
    print('str1 is equal to str2');
  } else {
    print('str1 is not equal to str2');
  }
  // Output: str1 is equal to str2
}
```

### Membandingkan Boolean

```dart
void main() {
  bool isTrue = true;
  bool isFalse = false;

  if (isTrue == isFalse) {
    print('isTrue is equal to isFalse');
  } else {
    print('isTrue is not equal to isFalse');
  }
  // Output: isTrue is not equal to isFalse
}
```

### Membandingkan Objek

```dart
class Person {
  String name;

  Person(this.name);
}

void main() {
  Person person1 = Person('Alice');
  Person person2 = Person('Alice');

  if (person1 == person2) {
    print('person1 is equal to person2');
  } else {
    print('person1 is not equal to person2');
  }
  // Output: person1 is not equal to person2 (karena mereka adalah contoh yang berbeda)
}
```

Dalam contoh yang terakhir, meskipun kedua objek memiliki atribut yang sama, mereka dianggap tidak sama karena merupakan instance yang berbeda.

#

**$Disclaimer$**

_Jadi pada dasarnya, tidak ada cara yang dibuat secara eksplisit untuk mengonversi tipe data dari `String` ke `bool` melainkan kita membuatt analogi sendiri untuk menncapainya._

#

Dokumentasi resmi Dart mengenai konversi dan metode `contains()`:

- [Dokumentasi Konversi di Dart](https://dart.dev/libraries/dart-convert) - Dokumentasi ini mencakup berbagai konverter dan codec yang tersedia di pustaka `dart:convert`.
- [Metode `contains()` dari Kelas String](https://api.dart.dev/dart-core/String/contains.html)

Dengan tautan-tautan ini, kamu bisa mendapatkan informasi lebih mendetail tentang kedua topik tersebut.
