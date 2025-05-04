class InitializerList {
  String a = ' ';
  String b = ' ';
  String c = ' ';

  InitializerList(this.c)
      : a = c.split(' ')[0],
        b = c.split(' ')[1] {
    print('object');
  }
}

String garis = '=' * 10;
void main() {
  print('\n' * 5);

  var a;

  a = InitializerList('Initializer List');

  print(a.a);
  print(a.b);
  print(a.c);
  print(garis);

  print('\n' * 5);
}
