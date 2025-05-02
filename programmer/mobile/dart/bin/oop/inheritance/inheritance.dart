String batas = '\n' * 5;
String garis = '-' * 50;

class Inheritance {
  String name;
  Inheritance(this.name);

  void say(String name) => print('Hello $name, my name is ${this.name}');
}

class Child extends Inheritance {
  String name;
  Child(this.name) : super(name);

  void say(String name) => print('Hello $name, my name is ${this.name}');
}

void main() {
  print(batas);

  var a = Inheritance('World');
  a.name = 'Qbit';
  a.say('byte');

  print(garis);

  a = Child('Everyone');
  a.name = 'Al-Qurthubi';
  a.say('Amir');

  print(garis);

  print(Child == Inheritance);
  print(a == a);

  print(batas);
}
