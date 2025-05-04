class Named {
  String a = 'Smoke';
  String? b;
  final String c = 'Diplomat';

  Named(this.a, this.b);

  Named.one(this.a);

  Named.two(this.b);
}

String batas = '\n' * 10;
String garis = '-' * 10;
void main() {
  print(batas);

  // %  di deklarasikan menggunakan konsep polymorphism
  var aaa;

  aaa = Named(
    'Constructor Primary',
    'Succes',
  );

  print(aaa.a);
  print(aaa.b);
  print(garis);

  aaa = Named.one('Named Constructor One Succes');
  print(aaa.a);
  print(aaa.b);
  print(garis);

  aaa = Named.two('Oke Google');
  print(aaa.a);
  print(aaa.b);

  print(batas);
}
