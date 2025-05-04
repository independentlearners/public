#  Variable
###### baca: variabel
### Tempat untuk menyimpan data

Sebetulnya tanpa menggunakan variabel, jika tujuannya hanya untuk menampilkan teks di terminal, kita bisa hanya dengan menggunakan cara seperti ini:

```Dart
print('Hello world');
```
>Otput terminal : Hello world
#
```dart
atau Hello world sebanyak 5x

print('Hello world');
print('Hello world');
print('Hello world');
print('Hello world');
print('Hello world');
```
##### Output Terminal:
```
Hello world
Hello world
Hello world
Hello world
Hello world
```

Cara ini akan memakan banyak memori jika isi datanya sama, oleh karenanya disinila pentingnya penggunaan variabel, kita bisa menampilkan banyak output yang sama hanya dengan satu baris kode saja.

##### Sintaks:
```Dart
String variabel = "inlai";
```
 Di Dart, variable memiliki tipe data yang harus dideklarasikan sebelum digunakan. Tipe data variable dapat berupa banyak variasi seperti  int untuk number, atau String untuk teks, boolean untuk pernyataan benar atau salah, list, map, dan seterusnya. Untuk mendeklarasikan variable, kita dapat menggunakan kata kunci seperti
* `var` `dynamic` `final` `const` `int` `double` `String` `bool` `List` `Map`

Dan seterusnya. Untuk saat ini kita akan menggunakan tipe data String untuk menampilkan teks, silahkan pelajari lebih lanjut dalam  [dokumentasi resmi.](https://dart.dev/guides/language/language-tour#variables "dart.dev") tentang variabel dalam  dart


`import 'saya.dart';`

Abaikan! kode file import ini atau hapus jika tidak kalian gunakan, tujuannya hanya untuk membuat tampilan diterminal sediki lebih respossif. Baik, jadi berikut inilah cara untuk mendemonstrasikan nilai kedalam variabel yang kemudian sistem akan mencetak dan memunculkannya di terminal sesuai dengan nilai yang sudah kita deklarasikan. Penulisan variabel ada dua cara,  pertama adalah dengan membuat tipe data kemudian variabelnya, atau langsung tipe data, variabel beserta nilainya sekaligus

```Dart
  String camelCase;

  camelCase = 'world';
  print('Hello $camelCase');
```

```Dart
  String name = 'world';
  print('Hello $name');
```
Dalam Dart, bast-practice penulisan variabel adalah menggunakan camelCase, yaitu huruf kecil semua tetapi apabila terdapat dua kata maka kita menggabungkannya seperti berikut > <span style="border-bottom: 1px solid orange;">
camelCase
</span>
#### Kode berikut adalah cara lain untuk mendemonstrasikan nilai kedalam variabel dengan tipe data yang berbeda


```Dart
void main() {

  print(pembatas);

  String name = 'name';
  print('Hello $name');

  print(pembatas);
  name = 'name = dart';
  print('Hello $name');

  print(pembatas);
  var nam = 'var name';
  print('Hello $nam');

  print(pembatas);
  final names = 'final names';
  print('Hello $names');

  print(pembatas);
  final array1 = [1, 2, 3];
  array1[1] = 9;
  print("const array1 $array1");

  // ignore: unused_local_variable
  const array2 = [1, 2, 3]; // Constant List (Compile-time constant)
  // array2[0] = 4; // ! Error: Cannot modify a constant list 'Penulisan const array2 (Bisa Error)'
  // $ print(array2);

  print(pembatas);

  late var value = getValue();
  print('variable sudah di buat:');
  print(value);
  // @late digunakan untuk mendeklarasikan variabel yang nilainya akan diinisialisasi nanti.

}

String getValue() {
  print('getValue() dipanggil');
  return 'Amirkhalilzain';
}
```

