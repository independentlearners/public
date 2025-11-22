# String

String adalah tipe data yang digunakan untuk menyimpan teks. Variabel dengan tipe data `String` ini bisa ditulis dengan cara seperti berikut

**Tanda Petik Satu Atau Dua**

```dart
String nama = 'pemrograman dart';
String kata = "frmework flutter";
```

#

**$Multi-line$ $String$**

`"""` `'''`

Multi-line String bisa dibuat dengan menggunakan tanda petik tiga `"""` atau `'''`. Ini akan membuat string yang panjang dan memiliki banyak baris tetapi sangat sensitif terhadap <span style="border-bottom: 1px solid orange;">whitespace</span>.

Output yang muncul menggunakan penulisan _Multi-line String_ akan tampil sebagaimana `String` tersebut ditulis

**Input**

```dart
String flutter = """

framework flutter keren

"""; // nilai ditulis dengan jarak Enter
```

**Ouput**

```PS


framework flutter keren
# maka akan muncul dengan jarak vertikal atas bawah

```

```dart
String multiLineString = '''
Oke Google
Halo Google
Oke Siap
''';
```

#

Memasukan tanda kutip ke dalam nilai

```dart
String dart =
"'pemrograman dart menyenangkan'";
```

#

**$String$ $Concatenation$**

`'' ''`

Menggabungkan dua atau lebih kata dalam satu `String`

```dart
String dart = 'Satu' 'Dua' 'Tiga';
// output: SatuDuaTiga
```

#

**$String$ $Interpolation$**

`$` _Default_ `${}` _Kompleks_

Ini adalah teknik yang digunakan untuk menyisipkan suatu ekspresi _(expression)_ atau variabel ke dalam variabel dari `String` yang lain.

**`String interpolation`** ditulis menggunakan simbol `$` untuk variabel sederhana atau `${}` untuk versi yang lebih kompleks.

```dart
String flutter = "framework flutter";
String dart = 'dart dan $flutter';
String google = "deikembangkan oleh google";
String bahasa = 'bahasa pemrograman ${dart + google}';

void main() {
  print(google);
  print(dart);
  print(flutter);
  print(bahasa);
}
```

#

**$Operator$ $Backlas$**

`\\`

Biasanya digunakan untuk beberapa hal sebagai berikut:

1. **Escape Character**: Menggunakan `\\` untuk memberi tahu kompiler bahwa karakter berikutnya adalah karakter yang harus diperlakukan secara khusus. Misalnya, `\\n` untuk baris baru, `\\t` untuk tab, dan sebagainya.
2. **File Paths**: Jika Anda bekerja dengan file paths di Windows, Anda mungkin menggunakan `\\` karena Windows menggunakan backlas sebagai pemisah direktori.
3. **String Literals**: Untuk memasukkan karakter backlas itu sendiri dalam string, Anda juga akan menggunakan `\\`. Misalnya, untuk menulis sebuah string yang berisi backlas, Anda akan menulisnya seperti ini: `"C:\\\\Users\\\\username\\\\Documents"`.

#

> Pelajari dokumentasi lebih lanjut tentang [`String`](https://api.dart.dev/stable/2.14.2/dart-core/String-class.html "api.dart.dev") di dart

**$Kode-Saya$**

```dart
import '../../../saya.dart';

void main() {
  String nama = 'amirzain';
  String kata = "halo dunia";
  String dart = "'pemrograman dart menyenangkan'";
  String flutter = """

framework flutter keren

  """;

  print('''
      nama = $nama
      kata = $kata
      dart = $dart
      flutter = $flutter
      $garis
      ''');

  String string = '$nama'
      '\n$kata'
      '\n$dart'
      '\n$flutter';
  var vr = string;
  print('$vr\n$garis');

  var single = nama + enter + kata;
  var saya = 'nama ' ' saya' ' amirkulal';
  print(single + enter + saya + enter + garis);

  String multiLineString = """
      Oke Google
      Halo Google
      Oke Siap
      """;
  print(multiLineString);
}
```

Saya rasa kode saya memang benar-benar menyulitkan untuk dibaca, anda bisa meninggalkan halaman ini sekarang 😁
