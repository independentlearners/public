# Number

Adalah tipe data yang digunakan untuk menyimpan nilai numerik. Di dart, number terdiri dari dua tipe, yaitu `int` dan `double`.

`Int` digunakan untuk menyimpan nilai bilangan bulat, sedangkan `double` digunakan untuk menyimpan nilai bilangan desimal.

**Dart** juga memiliki tipe data **`num`** yang dapat menampung nilai numerik baik `int` maupun `double`.

Untuk mendeklarasikan variabel dengan tipe data number, kita dapat menggunakan kata kunci **`int`**, **`double`**, atau **`num`** seperti pada contoh berikut

```dart
int number1 = 10;
double number2 = 10.50;
num number3 = 10;
num number4 = 10.50;

void main() {
  print(number1);
  print(number2);
  print(number3);
  print(number4);

  num number = 10;
  print(number);

  number = 10.50;
  print(number);
}
```

Anda bisa mengkopi-paste baris kode diatas apabila kode dalam file saya terasa menyulitkan

> Klik kntuk info lebih lanjut tentang dokumentasi [number](https://api.dart.dev/stable/2.14.2/dart-core/num-class.html "api.dart.dev") di dart
