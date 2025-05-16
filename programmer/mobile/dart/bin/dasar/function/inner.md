// # Dalam Dart, inner function (fungsi dalam) adalah fungsi yang didefinisikan di dalam fungsi lain. Ini memungkinkan kita untuk membuat fungsi dengan akses ke variabel dan parameter dari fungsi induknya. Fungsi dalam ini dapat membantu dalam mengatur kode agar lebih terstruktur dan lebih mudah dibaca.

void main() {
  print('\n' * 5);

  void sayHello() => print('oke google');

  print(sayHello);

  sayHello();

  print('\n' * 5);
}

sayHello() => print('halo dunia');
