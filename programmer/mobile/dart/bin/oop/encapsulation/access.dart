import 'modifier.dart';
// # dart\bin\oop\encapsulation\access.dart

String batas = '\n' * 10;

class Access {
  String n;
  final int? _i;
  Access(this._i, this.n);

  int? get v => _i;
  set v(int? v) {
    v = _i;
  }
}

class _AccessModifier {
  String u;
  final int? t;

  _AccessModifier(this.t, this.u);

  int? get e => t;
}

void main() {
  print(batas);

  // $ variabel yang dideklarasikan untuk tipe data modify tidak bisa menjadi pholymorphism
  // $ artinya tidak bisa di deklarasikan untuk selain tipe data modify yang sudah di deklarasikan
  // $ kecuali property atau field atau method yang ada di dalamnya

  var a = _AccessModifier(100, 'AccessModifier');
  print(a.e);
  print(a.u);

  var b = Access(9, 'oke');

  print(batas);
}
