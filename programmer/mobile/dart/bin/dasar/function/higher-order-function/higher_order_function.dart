// Dart program to demonstrate if-else statement
// # untuk menjadikan function didalam function maka parameter wajib di tulis Function() setelah tipe data return-nya

void sayHello(String name, String Function(String) filter) {
  String filterName = filter(name);
  print('Hi $filterName');
}

String filterBadWord(name) {
  if (name == 'gila') {
    return '***';
  } else {
    return name;
  }
}

void main(dynamic nama) {
  print('\n' * 5);

  sayHello('gila', filterBadWord);

  print('\n' * 5);
}
