# Anonymous Function

````dart
import '../../../saya.dart';

// #

void sayHello(String name, String Function(String) filter) {
  print('hello ${filter(name)}');
}

var upperFunction = (String name) {
  return name.toUpperCase();
};

var lowerFunction = (String name) => name.toLowerCase();
void main() {
  print(batas);

  sayHello('ismail', (name) => name.toUpperCase());

  print(garis);

  print(upperFunction('Amir'));
  print(lowerFunction('Amir'));

  print(batas);
}```
````
