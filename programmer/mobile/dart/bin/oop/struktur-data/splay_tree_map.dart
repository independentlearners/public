import 'dart:collection';

void main() {
  SplayTreeMap<String, int> studentScores = SplayTreeMap<String, int>();

  // Menambahkan elemen ke SplayTreeMap
  studentScores["Alice"] = 85;
  studentScores["Bob"] = 92;
  studentScores["Charlie"] = 78;

  // Menampilkan elemen
  print(studentScores); // Output: {Alice: 85, Bob: 92, Charlie: 78}

  // Memeriksa apakah kunci ada dalam SplayTreeMap
  bool hasAlice = studentScores.containsKey("Alice");
  print(hasAlice); // Output: true
}
