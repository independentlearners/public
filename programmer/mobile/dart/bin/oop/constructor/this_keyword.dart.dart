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

// % contoh variable shadowinhg yang berhasil diatasi dengan kata kunci "this"
class Shadowinhg {
  String a = 'Guest';
  String? b;
  final String c = 'Diplomat';

  Shadowinhg(String a, String b) {
    this.a = a = 'amir';
    print(a);

    this.b = b = 'algoritmic';
    print(b);
  }
}

String garis = '=' * 10;
String batas = '\n' * 10;
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
