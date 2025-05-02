void namedParameter({name, age}) {
  print("Named Parameter");
  print("Name: $name");
  print("Age: $age");
}

var garis = '-' * 20;
void main() {
  print('\n' * 5);

  namedParameter(name: "John", age: 30);
  print(garis);

  namedParameter(age: 25, name: "Doe");
  print(garis);

  namedParameter(name: "Alice");
  print(garis);

  namedParameter(age: 22);
  print('\n' * 5);
}
