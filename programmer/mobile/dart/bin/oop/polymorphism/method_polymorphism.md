```dart
String batas = '\n' * 5;
String garis = '=' * 5;

class Polymorphism {
  String? a;
  Polymorphism(this.a);
}

class SuperPolymorphism extends Polymorphism {
  SuperPolymorphism(super.a) {
    print('bodyConstructor');
  }
}

void methodPolymorphism(Polymorphism constructor) {
  print('hello ${constructor.a}');
}

void main() {
  print(batas);

  var b = Polymorphism('quantity Parent Polymorphism');
  print(b.a);

  print(garis);
  b = SuperPolymorphism('quantity Super');
  print(b.a);

  print(garis);
  methodPolymorphism(Polymorphism('Polymorphism'));

  print(garis);
  methodPolymorphism(SuperPolymorphism('Super Polymorphism'));

  print(batas);
}
```
