class Person {
  String name;
  int age;

  Person(this.name, this.age);

  @override
  String toString() => 'Name: $name, Age: $age';
}

void main() {
  print('\n' * 5);

  Person p = Person('Alice', 30);
  print(p.toString()); // $ Output: Name: Alice, Age: 30

  print('\n' * 5);
}
