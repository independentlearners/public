import 'access.dart';
import 'getter.dart';
import 'setter.dart';
import 'encapsulation.dart';

String batas = '\n' * 10;
String garis = '=' * 10;
void main() {
  print(batas);

  var b = Access(9, 'oke');
  print(b.v);
  print(b.v = 10);

  print(garis);

  var c = Encapsulation();
  c.a = 2;
  print(c.a);

  c.i = 2;
  print(c.i);

  print(garis);

  var h = Getter();
  h.i = 2;
  print(h.i);

  h.f = 2;
  print(h.f);

  print(garis);

  var e = Setter(0);
  print(e);

  print(batas);
}

/*

  % disini _AccessModifier() tidak bisa diakses
  - var a = _AccessModifier(100, 'AccessModifier');
  - print(a.value);
  - print(a.name);

*/

/*


Setter 'a' tidak didefinisikan untuk tipe 'GetterSetter'.
Coba impor pustaka yang mendefinisikan 'a', perbaiki nama dengan nama setter yang sudah ada, atau definisikan setter atau kolom bernama 'a'


 */
