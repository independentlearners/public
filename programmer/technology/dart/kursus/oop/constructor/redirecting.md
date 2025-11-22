class Redorecting {
  String a = 'Smoke';
  String? b;
  final String c = 'Diplomat';

  Redorecting(this.a, this.b);

  Redorecting.one(String a) : this(a, 'Dari redirecting pertama');

  Redorecting.two(String b) : this('Dari redirecting kedua', b);

  Redorecting.tree() : this.two('Ke redirecting ketiga');
}

String garis = '=' * 10;
String batas = '-' * 10;
void main() {
  print(batas);

  // %  di deklarasikan menggunakan konsep polymorphism
  var aaa;

  aaa = Redorecting(
    'Constructor Primary',
    'Succes',
  );

  print(aaa.a);
  print(aaa.b);
  print(garis);

  aaa = Redorecting.one('Satu');
  print(aaa.a);
  print(aaa.b);
  print(garis);

  aaa = Redorecting.two('Oke Google');
  print(aaa.a);
  print(aaa.b);
  print(garis);

  aaa = Redorecting.tree();
  print(aaa.a);
  print(aaa.b);

  print(batas);
}
