# Variabel Pembantu
Ini adalah alat bantu manual yang saya buat untuk memudahkan tampilan output di console, kita bisa mengubah warna output, atau menambahkan "Enter" sebagai pembatas, garis, background teks dan semacamnya, untuk membuatnya bekerja, import file "saya.dart" ke dalam file tempat anda menulis kode.

```dart
// & Variabel pembantu
var batas = '\n' * 2;
var garis = '------------------------';
var enter = '\n';
var tab = '\b' * 1;
var spasi = ' ' * 1;
// & Variabel warna
var merah = '\x1B[31m';
var hijau = '\x1B[32m';
var kuning = '\x1B[33m';
var biru = '\x1B[34m';
var ungu = '\x1B[35m';
var cyan = '\x1B[36m';
var putih = '\x1B[37m';
var reset =
    '\x1B[0m'; // untuk menghentikan sejauh mana teks yang ingin kita warnai, letakan varaible "reset" ini di setiap akhir teks di dalam tanda kutip, lakukan hal yang sama untuk semua warna dan jenis tampilan

// & Variabel pencoret
var pencoret = '\x1B[9m';

// & Variabel tebal
var tebal = '\x1B[1m';

// & Variabel miring
var miring = '\x1B[3m';

// & Variabel garis bawah
var garisBawah = '\x1B[4m';

// & Variabel background
var background = '\x1B[7m';
var backgroundPutih = '\x1B[47m';
var backgroundMerah = '\x1B[41m';
var backgroundHijau = '\x1B[42m';
var backgroundKuning = '\x1B[43m';
var backgroundBiru = '\x1B[44m';
var backgroundUngu = '\x1B[45m';
var backgroundCyan = '\x1B[46m';

// & Variabel warna teks bermacam
var warnaTeks = '\x1B[38;2;255;255;255m';

// & Variabel warna background
var warnaBackground = '\x1B[48;2;255;255;255m';
// !----------------------------------

var rege =
    '$reset$enter$garis$enter'; // $ gabungan antara reset, enter, garis dan enter lagi yang di simmpan dalam satu variable

String atas = '''

⬆️

''';

String bawah = '''


⬇️
''';
```

Panggil variable tersebut

### Contoh :
```dart
import 'saya.dart';

void main() {
  String name = 'world';
  print('$merah Hello $name$reset Oke Berhasil');
}
```
### Output :
<span style="color: red; border-bottom: 2px wavy red;">
Hello world
</span>Oke Berhasil

