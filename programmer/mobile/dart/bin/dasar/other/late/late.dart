String getTag() {
  print('fungsi getTag() dipanggil');
  return 'Hello Flutter';
}

class Example {
  late String? name;

  void initializeName() {
    name = "Dart Developer"; // Variabel diinisialisasi sebelum digunakan
  }

  void printName() {
    print(name); // Akan error jika `name` belum diinisialisasi
  }
}

void main() {
  print('\n' * 5);

  late var value = getTag();
  print('variabel dipanggil');
  print(value);

  print(
    '\n' * 1 + '=' * 10 + '\n' * 1,
  );

  var example = Example();
  example.initializeName();
  example.printName();

  print('\n' * 5);
}
