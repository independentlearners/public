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
  // ^ Berikut adalah konversi tipe data yang implisit:
  String inputString =
      '1000'; // ! Warning: Jangan menulis nilai selain angka  jika ingin mengkonversi ke int atau double
  var inputInt = int.parse(inputString); // ? Konversi tipe data string ke int
  var inputDouble = double.parse(inputString); // ? Konversi tipe data string ke double
  var inputStringInt = inputInt.toString(); // ? Konversi tipe data int ke string

  print(
      "$tab$enter$inputInt => Ini adalah String aslinya" // ! Output: 1000 berarti masih dalam bentuk string dan tidak berwarna
      "$enter$garis$enter$biru$inputDouble => Di konversi ke Double $reset$enter$garis" // ! Output: 1000.0 berarti sudah menjadi double dan tidak ada koma serta berwarna biru
      "$enter$kuning$inputStringInt => Dari Double dikembalikan lagi ke String$reset$enter$garis" // ! Output: 1000 berarti sudah kembali ke string dan berwarna kuning
      );

  // ^ Contoh Konversi Tipe Data secara eksplisit
  int intToDouble = 1000;
  double angkaDouble = intToDouble.toDouble();
  int doubleToInt = angkaDouble.toInt();
  String angkaString = doubleToInt.toString();

  print("$enter$merah$angkaDouble => Dari Int dikonversi ke Double$reset$enter"
      "$garis$enter$hijau$doubleToInt => Dari Double dikonversi ke Int$reset$enter$garis"
      "$enter$ungu$angkaString => Dari Int dikonversi ke String$reset$enter$garis");
}
```

**Output**

Di terminal, output berikut akan memiliki warna masing-masing

```PS

1000 => Ini adalah String aslinya
------------------------
1000.0 => Di konversi ke Double
------------------------
1000 => Dari Double dikembalikan lagi ke String
------------------------

1000.0 => Dari Int dikonversi ke Double
------------------------
1000 => Dari Double dikonversi ke Int
------------------------
1000 => Dari Int dikonversi ke String
------------------------
```
