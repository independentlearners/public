void sayHello(String name, String Function(String) filter) {
  print('hello ${filter(name)}');
}

var upperFunction = (String name) {
  return name.toUpperCase();
};

var lowerFunction = (String name) => name.toLowerCase();
void main() {
  print('\n' * 5);

  sayHello('ismail', (name) => name.toUpperCase());

  print(
    '\n' * 1 + '=' * 10 + '\n' * 1,
  );

  print(upperFunction('Amir'));
  print(lowerFunction('Amir'));

  print('\n' * 5);
}
