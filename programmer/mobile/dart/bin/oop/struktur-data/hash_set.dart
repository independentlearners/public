import 'dart:collection';

void main() {
  HashSet<String> fruits = HashSet<String>();

  // Menambahkan elemen ke HashSet
  fruits.add("apple");
  fruits.add("banana");
  fruits.add("orange");
  fruits.add("apple"); // duplikat tidak akan ditambahkan

  // Menampilkan elemen
  print(fruits); // Output: {apple, banana, orange}

  // Memeriksa apakah elemen ada dalam HashSet
  bool hasApple = fruits.contains("apple");
  print(hasApple); // Output: true
}
