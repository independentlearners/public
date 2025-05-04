String batas = '=' * 10;
String garis = '\n' * 10;

// % contoh benar
class Constructor {
  String a = 'Guest';
  String? b;
  final String c = 'Diplomat';

  Constructor(String aa, String bb) {
    a = aa = 'amir';
    print(aa);

    b = bb = 'algoritmic';
    print(bb);
  }
}

// % contoh variable shadowinhg
class Shadowinhg {
  String a = 'Guest';
  String? b;
  final String c = 'Diplomat';

  Shadowinhg(String a, String b) {
    a = a = 'amir';
    print(a);

    b = b = 'algoritmic';
    print(b);
  }
}

void main() {
  print(batas);

  // %  di deklarasikan menggunakan konsep polymorphism
  var a;

  a = Constructor('satu', 'dua');
  print(a.a);
  print(garis);

  print(a.b);
  print(garis);

  print(batas);

  a = Shadowinhg('satu', 'dua');
  print(a.a);
  print(garis);

  print(a.b);
  print(garis);

  print(batas);
}
