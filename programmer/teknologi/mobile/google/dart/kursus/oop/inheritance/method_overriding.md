```dart
String batas = '\n' * 5;
String garis = '=' * 5;

class Inheritance {
  String? name;

  void say(String name) => print('Hello $name, my name is inheritance ${this.name}');
}

class Child extends Inheritance {
  @override
  void say(String name) => print('Hello $name, my name is child ${this.name}');
}

class Children extends Child {
  void say(String name) => print('Hello $name, my name is children ${this.name}');
}

void main() {
  print(batas);

  var a = Inheritance();
  a.name = 'Amirkulal';
  a.say('World');

  print(garis);

  var b = Child();
  b.name = 'Al-Qurthubi';
  b.say('World');

  print(garis);

  var c = Children();
  c.name = 'Ameerkhalzen';
  c.say('World');

  print(garis);
  print(b == c);

  print(batas);
}
```
