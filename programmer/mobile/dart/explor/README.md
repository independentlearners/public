# Hasil Eksplorasi Saya

```dart
void a() {
  var a = '-' * 5, o = '=' * 5;
  print('$a$o');
}

void loop() {
  var i, t = <String>['Dart', 'Flutter', 'Mobile', 'Developer'];

  for (i = 1; i <= 5; ++i) {
    print("Halo Dunia $i");
  }

  a();

  for (i in t) {
    print(i);
  }
}

void main() {
  var i;

  loop();

  a();

  for (i = 0; i < 5; ++i) {
    print(i);
  }
}
```
