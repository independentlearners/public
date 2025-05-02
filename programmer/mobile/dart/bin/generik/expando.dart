// # Expando: Digunakan untuk menambahkan properti secara dinamis ke objek.

void main() {
  print('\n' * 5);

  Expando<String> ids = Expando<String>();
  var obj = {};
  ids[obj] = '1234';
  print(ids[obj]); // Output: 1234

  print('\n' * 5);
}
