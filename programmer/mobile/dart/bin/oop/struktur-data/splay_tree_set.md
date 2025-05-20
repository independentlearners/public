```dart
import 'dart:collection';

void main() {
  SplayTreeSet<int> numbers = SplayTreeSet<int>();

  // Menambahkan elemen ke SplayTreeSet
  numbers.addAll([10, 20, 30, 40, 50]);

  // Menampilkan elemen
  print(numbers); // Output: {10, 20, 30, 40, 50}

  // Memeriksa apakah elemen ada dalam SplayTreeSet
  bool hasThirty = numbers.contains(30);
  print(hasThirty); // Output: true
}
```