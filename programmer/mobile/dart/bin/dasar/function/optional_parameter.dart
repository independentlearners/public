// ^ Dart adalah bahasa berorientasi objek sejati, jadi bahkan fungsi adalah objek dan memiliki jenis, Function. Ini berarti bahwa fungsi dapat ditetapkan ke variabel atau diteruskan sebagai argumen ke fungsi lain. Anda juga dapat memanggil instance kelas Dart seolah-olah itu adalah fungsi. Untuk mengetahui detailnya
// https://dart.dev/language/functions

// # function parameter adalah nilai yang diterima oleh sebuah fungsi saat fungsi tersebut dipanggil. Parameter ini didefinisikan saat kita mendeklarasikan fungsi. Contoh dasar dari fungsi dengan parameter adalah sebagai berikut:
void sayHello(String a, String? b) {
  print('<<waib>> $a');
  print('<<print kedua dari sayHello>> ');
}

// # function opsional parameter, yang berarti bahwa parameter tersebut tidak harus diberikan nilai saat fungsi dipanggil. Ditandai dengan tanda kurung siku []
void say(String a, [String? b]) {
  print('<<print pertama>> $a\n$b');
  print('<<print kedua dari say>> ');
}

// # contoh function opsional parameter yan glebih dari satu nilai
void hello(String a, [String? b, String? c, String? d]) {
  print('<<oke google>> $a\n$b');
  print('<<oke siap>> ');
} // $ optional parameter tidak bisa berada didepan, apabila ingin menambahkan parameter lebih dari dua, maka harus diletakan didalam kurung kotak, yang berarti bahwa semua parameter selain parameter pertama adalah opsional

void main() {
  print('\n' * 5);

  sayHello('parameter-1-sayHello()',
      null); // $ wajib mengisi parameter kedua yaitu "null" meskipun variabel string interpolation-nya tidak dipanggil dari dalam print() di dalam body

  sayHello(
      'parameter-1-sayHello', 'parameter-sayHello-2-wajib'); // $ paramter kedua wajib

  print('=' * 10 + '\n' * 1);

  say('paramter pertama say'); // $ karena parameter kedua yaitu "[String? b]" di tambahkan kurung kotak ini berarti opsional, maka parameter kedua tidak wajib diisi

  say('opsional-1-say()', 'opsional-2-say()');

  print('=' * 10 + '\n' * 1);

  hello('hello()');
  hello('1-hello()', '2-amirkulal', '3-malang', '4-jawa-timur');

  print('=' * 10 + '\n' * 1);

  'Defaul Value';
  // $ adalah kondisi dimana ketika kita ingin menambahkan opsional parameter namun tidak ingin bertipe nullable, maka harus menambahkan string kosong dalam parameter opsionalnya seperti berikut:
  defaultvalue('parameter awal tanpa parameter kedua');

  print('\n' * 5);
}

// # function default value
void defaultvalue(String a, [String b = '']) => print('ini adalah "Defaul Value"');
