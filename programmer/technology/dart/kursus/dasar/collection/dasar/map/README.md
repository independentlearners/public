```dart
/*
  # Dalam Dart, Map adalah kumpulan data yang disimpan dalam bentuk pasangan key-value.
  # Setiap key hanya dapat memiliki satu nilai yang terkait dengannya.
  # Map dapat dideklarasikan dengan dua cara utama: menggunakan Map literal atau Map constructor
  # Ada tiga cara berbeda untuk mendeklarasikan Map dalam Dart, dan masing-masingnya memiliki istilah penulisan tersendiri.
  # Tetapi satu diantara keduanya sudah kadaluarsa. Berikut penulisan yang sudah kadaluiiarsa tersebut:
  $ final product = <double, String>() {}; penulisan ini disebut "Constructor Map dengan variabel tipe dinamis:"
  # atau bisa di tulis seperti:
  $ final product = Map<double, String>(); dua jenis penulisan ini sudah tidak di rekomendasikan lagi

  # Penjelasan mengenai yang sudah kadaluarsa bisa dilihat melalui:
  # https://dart.dev/tools/diagnostic-messages?utm_source=dartdev&utm_medium=redir&utm_id=diagcode&utm_content=prefer_collection_literals#prefer_collection_literals

  # Penbjelasan lanjutan mengenai Map disini:
  # https://api.dart.dev/dart-core/Map-class.html


*/
void main() {
  print('\n' * 5);

  Map<String, String> person = {};
  print(person);
  // $ Literal Map dengan Type Annotation (anotasi tipe):
  // $ Mendeklarasikan Map dengan tipe yang ditentukan secara eksplisit (di sini, key dan value adalah tipe String).

  final product = <double, String>{};
  print(product);
  // $ Constructor Map dengan variabel tipe dinamis:
  // $ Menggunakan konstruktor Map dan kata kunci var untuk mendeklarasikan Map. Tipe key dan value ditentukan di dalam constructor.

  var address = <String, bool>{};
  print(
    '$address\n\n'
    'Hasil dari deklarasi Map kosong',
  );
  // $ Literal Map dengan argumen tipe generik:
  // $ Menggunakan notasi literal Map dengan argumen tipe generik untuk mendefinisikan tipe key dan value.
  // $ Ketiga cara ini pada dasarnya mencapai hal yang sama dan tidak menghasilkan fungsi yang berbeda selain gaya penulisan, jadi satu-satunya tujuan disini hanya untuk mendeklarasikan Map, Pilihan di antara ketiganya biasanya bergantung pada preferensi atau kebutuhan kode Anda.

  person['Nama'] = 'Amirzain';
  person['Teknologi'] = 'Dart';
  person['Alamat'] = 'Malang';
  person['Kunci'] = 'Nilai'; // $ tanpa nilai tidak akan di deklasikan
  person['Key'];

  // product[2.5] = 'Km';

  var deklarasiLangsung = <String, int>{
    'Jarak': 200,
    'Panjang': 300,
    'Lebar': 400,
  };

  print(
    '$person\n'
    '${person['Kunci']}\n' // $ mengambil properti
    '${person['Kunci'] = 'kunciii'}\n' // Yang sebelumnya memiliki value "Nilai" telah berhasil diubah
    '$product\n'
    '$address\n'
    '$deklarasiLangsung\n'
    '${person.remove('Kunci')}\n' // $ key 'Kunci' dihapus dari daftar Map, nonaktifkan kode untuk menampilkan output: Kunci: kunciii
  );
  var value = <String, String>{};
  value['key'];
  var key = value['key'] = 'value';
  print(value);
  print(key);

  print('\n' * 5);
}
```
