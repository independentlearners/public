# Konversi

Konversi tipe data dalam dart adalah proses mengubah tipe data dari satu tipe data ke tipe data lain. Ini bisa dilakukan secara eksplisit ataupun implisit.

Untuk mengubah tipe data variable menjadi tipe data lain, kita dapat menggunakan metode konversi tipe data **seperti :**

#

- `toString()`

Digunakan untuk mengonversi tipe data dari **`int`integer** atau **`double`** menjadi tipe data `String`.

**_Contoh pengonversian implisit dari `String` ke `int`_**

```dart
String inputString = '1000';
var inputInt = int.parse(inputString);
```

Perhatikan bahwa nilai dalam variabel `inputString` harus ditulis sebagai angka, atau akan menghasilkan **<span style="color: red; border-bottom: 2px wavy red;">Error!</span>**

#

- `toInt()`

  - Dari <span style="color: green;">**String**</span> atau <span style="color: green;">**double**</span> ke <span style="color: green;">**int**</span>

- `toDouble()`

  - Dari <span style="color: green;">**String**</span> atau <span style="color: green;">**int**</span> ke <span style="color: green;">**double**</span>

#

**_Eksplisit_**

```dart
// input utama bertipe int
int intToDouble = 1000;

// lalu di output ke double
double angkaDouble = intToDouble.toDouble();

// setelah dikonversi ke double di output lagi ke int
int doubleToInt = angkaDouble.toInt();
```

**_Implisit_**

```dart
// setelah berubah menjadi int di output ke String
String angkaString = doubleToInt.toString();
```

---

### $Kode$ $Saya$

**Input**

```Dart
void main() {
  print('\n' * 5);

  // ^ Berikut adalah konversi tipe data yang implisit:
  String inputString = '1000';
  print(inputString);

  var inputInt = int.parse(inputString);
  print(inputInt);

  var inputDouble = double.parse(inputString);
  print(inputDouble);

  var inputStringInt = inputInt.toString();
  print(inputStringInt);

  print('\n' * 1);
  print('=' * 10);
  print('\n' * 1);

  // ^ Contoh Konversi Tipe Data secara eksplisit
  int intToDouble = 1000;
  print(intToDouble);

  double angkaDouble = intToDouble.toDouble();
  print(angkaDouble);

  int doubleToInt = angkaDouble.toInt();
  print(doubleToInt);

  String angkaString = doubleToInt.toString();
  print(angkaString);

  print('\n' * 5);
}
```
