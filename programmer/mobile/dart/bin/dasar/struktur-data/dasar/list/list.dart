void main() {
  print('\n' * 5);

  // ^ Membuat List kosong
  List<int> emptyInt = [];

  List<String> emptyString = [];

  List<String> emptyBool = [];

  print('$emptyString Tipe String inisialisasi kosong '
      '$emptyInt Tipe Integer inisialisasi kosong '
      '$emptyBool Tipe Boolean inisialisasi kosong');

  print('\n' * 5);

  var dinamik = ['Ini', 'adalah', 'Lsit', 'Dinamik'];

  dinamik.add('Dart');

  var string = <String>['Amir', 'Khalil', 'Zain'];
  var integer = <int>[1, 2, 3, 4, 5];
  var boolean = <bool>[false, true, false];

  print('$dinamik Tipe Dinamik\n${dinamik.length}'
      '$string Tipe String'
      '$integer Tipe Integer'
      '$boolean Tipe Boolean');

  // ^ Membuat list dengan beberapa elemen
  List<int> numbers = [1, 2, 3, 4, 5];

  // ^ Menambahkan elemen ke dalam list
  numbers.add(266);
  print('$numbers'); // $ [1, 2, 3, 4, 5, 6]

  // ^ Mengakses elemen berdasarkan indeks
  int firstNumber = numbers[4]; // 1
  print('$firstNumber'
      'Angka 5 berhasil diakses sebagai index ke empat'
      'dan dimasukan kedalam Set{}'); // $ Mengakses elemen pertama dalam list (indeks ke-0) (nilai 1)

  // ^ Menghapus elemen dari list
  numbers.removeAt(2); // $ Menghapus elemen pada indeks ke-2 (nilai 3)

  // ^ Menampilkan semua elemen dalam list secara berurutan menggunakan perulangan "for(in){}"
  //sehingga akan menampilkan nilai 1, 2, 4, 5, 6 dalam bentuk vertikal
  for (int number in numbers) {
    print(number); // $ 1, 2, 4, 5, 6 ditampilkan secara berurutan vertikal
  }

  // ^ Deklarasi secara langsung
  string = ['Oke Google'];
  print(string.first);

  print('\n' * 5);
}
