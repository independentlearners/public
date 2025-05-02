void main() {
  print('\n' * 5);

  // % Dari ke non null ke null
  String name = 'Amir';
  String? nullable = name;
  print(nullable);

  // % Dari null ke non null butuh metode pengecekan seperti ini
  x(int? age) {
    if (age != null) {
      // age = 1; // $ ktifkan untuk menentukan nilai konversi secara manual
      double ageDouble = age.toDouble();
      print(ageDouble);
    }
  }

  print(x(DateTime.january));
  print(x(0));
  print(x);

/*

$ Dalam kode diatas, fungsi `x` tidak mengembalikan nilai apa pun, sehingga fungsi tersebut mengembalikan `null` secara default. Berikut adalah alasan mengapa output yang muncul adalah `1.0` diikuti oleh `null`:

% 1. print(x(DateTime.august));
   - Argument `DateTime.august` adalah nilai konstan dari tipe `int`, jadi `x` akan menetapkannya menjadi 1, mengkonversinya menjadi double, dan mencetaknya. Hasilnya adalah `1.0`.
   - Karena fungsi `x` tidak mengembalikan nilai apa pun, panggilan `print(x(DateTime.august))` akan mencetak `null`.

% 2. print(x(0));
   - `age` tidak `null`, jadi `age` diatur menjadi 1, dikonversi ke double, dan dicetak. Hasilnya adalah `1.0`.
   - Karena fungsi `x` tidak mengembalikan nilai, `print(x(0))` akan mencetak `null` setelah mencetak `1.0`.

% 3. print(x(x(0)));
   - Panggilan pertama `x(0)` mencetak `1.0` dan mengembalikan `null`.
   - Panggilan kedua menjadi `x(null)` karena hasil dari `x(0)` adalah `null`. Dalam hal ini, `age` adalah `null` dan tidak ada yang dicetak di dalam fungsi.
   - `print(x(x(0)))` mencetak hasil dari panggilan terluar, yaitu `null`.

*/

  // % Default value
  String? guest;
  guest = 'Oke Google';
  var guestName = guest ?? 'Guest';
  print(guestName);
  // $ Contoh disini mengartikan apabila variabel tidak di deklarasikan terlebih dahulu `guest = 'Oke Google';`.
  // $ Maka dia akan mengambil nilai dari `var guestName = guest ?? 'Guest';` dimana nilai disini di sebut nilai default

  // % Konversi secara paksa
  int? nullableNumber;
  nullableNumber = 1; // $ aktifkan untuk menghapus error
  int nonNullable = nullableNumber;
  print(nonNullable);

  int? dataInt;
  double? dikonversi = dataInt?.toDouble();
  print(dikonversi);

/*
  $ Berikut adalah dokumentasi resmi Dart yang menjelaskan tentang fungsi yang tidak mengembalikan nilai dan bagaimana nilai `null` digunakan secara default:
  $ Dart Null Safety https://dart.dev/null-safety
  $ Dart Language Tour - Functions https://dart.dev/guides/language/language-tour#functions
*/

  print('\n' * 5);
}
