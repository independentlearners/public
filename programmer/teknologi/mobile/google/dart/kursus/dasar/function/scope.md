/*

# apa itu scope dalam dart
Scope dalam bahasa pemrograman Dart mengacu pada aturan yang menentukan di mana variabel dan fungsi dideklarasikan dan dapat diakses dalam kode Anda. Scope membantu mengontrol visibilitas dan umur variabel serta fungsi.

Ada dua jenis scope utama dalam Dart:
Scope Lokal: Variabel atau fungsi yang dideklarasikan di dalam sebuah blok kode (seperti dalam fungsi atau loop) hanya dapat diakses di dalam blok tersebut.

Scope Global: Variabel atau fungsi yang dideklarasikan di luar semua blok kode (seperti di awal program) dapat diakses di mana saja dalam program.

*/

void main() {
  print('\n' * 5);

  var globalVar = 'Global Variable';

  void myFunction() {
    var localVar = 'Local Variable';
    print(globalVar); // Mengakses variabel global
    print(localVar); // Mengakses variabel lokal
  }

  myFunction();
  // print(localVar); // Akan menghasilkan error karena localVar tidak dapat diakses di sini

  print('\n' * 5);
}

/*

Pada contoh di atas, globalVar adalah variabel global yang dapat diakses di mana saja dalam fungsi main, sementara localVar adalah variabel lokal yang hanya dapat diakses di dalam fungsi myFunction.

*/
