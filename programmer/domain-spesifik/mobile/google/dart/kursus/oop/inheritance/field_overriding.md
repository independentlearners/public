String batas = '\n' * 5;
String garis = '-' * 10;

class Inheritance {
  String? name;

  void say(String name) => print('Hello $name, my name is inheritance ${this.name}');
}

class Child extends Inheritance {
  String? name = 'Amirkulal Al-Qurthubi';
  @override
  void say(String name) => print('Hello $name, my name is child ${this.name}');
}

class Children extends Child {
  String? name = 'Amirzain';
  @override
  void say(String name) => print('Hello $name, my name is children ${this.name}');
}

void main() {
  print(batas);

  var a = Inheritance();
  a.name = 'Amirkulal';
  a.say('World');

  print(garis);

  var b = Child();
  b.say('World');

  print(garis);

  var c = Children();
  c.say('World');

  print(batas);
}
