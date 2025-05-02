// % parent class
class Constructor {
  String? a;
  Constructor(this.a);
}

// % super class
class SuperConstructor extends Constructor {
  SuperConstructor(super.a) {
    print('bodyConstructor');
  }
} // ! super class wajib menyertakan contructor apabila di parent class-nya terdapat contructor juga

String garis = '-' * 20;
String batas = '=' * 20;
void main() {
  print(batas);

  // %  di deklarasikan secara eksplisit tanpa menggunakan konsep polymorphism
  var b = Constructor('quantityParent');
  print(b.a);

  print(garis);

  var c = SuperConstructor('quantitySuper');
  print(c.a);

  print(batas);
}
