/*
  # Dalam bahasa pemrograman Dart, Symbol adalah representasi dari string dinamis yang digunakan untuk mencerminkan metadata dari suatu library. Secara sederhana, Symbol adalah cara untuk menyimpan hubungan antara string yang dapat dibaca manusia dan string yang dioptimalkan untuk digunakan oleh komputer. Symbol sering digunakan dalam mekanisme refleksi (reflection) untuk mendapatkan metadata suatu tipe pada saat runtime, seperti jumlah metode atau fungsi dalam suatu kelas, jumlah konstruktor yang dimilikinya, atau jumlah parameter dalam suatu fungsi
  # https://api.dart.dev/dart-core/Symbol/Symbol.html
*/

void main() {
  print('\n' * 5);

  final simbol = Symbol('dart');
  var symbol = #simbol;
  print('$simbol\n$symbol');

  print('\n' * 5);
}
