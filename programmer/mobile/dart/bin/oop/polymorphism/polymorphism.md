```dart
String batas = '\n' * 50;
String garis = '-' * 50;

class Polymorphism {
  String? a;
  Polymorphism(this.a);
}

class SuperPolymorphism extends Polymorphism {
  SuperPolymorphism(super.a) {
    print('bodyPolymorphism');
  }
}

void main() {
  print(batas);

  var b = Polymorphism('quantityParent');
  print(b.a);

  print(garis);
  b = SuperPolymorphism('quantitySuper');
  print(b.a);

  print(batas);
}
```
