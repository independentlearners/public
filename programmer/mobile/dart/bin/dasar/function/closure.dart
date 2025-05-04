/*

# apa itu closure dalam dart
Closure dalam Dart adalah fungsi yang dapat menangkap variabel-variabel dari konteks di mana ia didefinisikan, meskipun fungsi tersebut dieksekusi di luar konteks aslinya. Ini memungkinkan fungsi untuk mengingat dan menggunakan variabel-variabel tersebut bahkan setelah lingkup fungsi asli telah berakhir.

Closure berguna dalam berbagai skenario, seperti ketika bekerja dengan fungsi anonim, callback, dan fungsi dalam kelas.
Contoh sederhana dari closure dalam Dart:

*/

void main() {
  print('\n' * 5);

  var addBy = createAdder(2);

  print(addBy(3)); // Output: 5

  print(addBy(0)); // Output: 2

  print(addBy(1)); // Output: 3

  print('\n' * 5);
}

Function createAdder(int addBy) {
  return (int i) => addBy + i;
}
