import 'dart:collection';

void main() {
  Queue<String> queue = Queue<String>();

  // Menambahkan elemen ke Queue
  queue.add("First");
  queue.add("Second");
  queue.add("Third");

  // Menampilkan elemen
  print(queue); // Output: (First, Second, Third)

  // Menghapus elemen dari Queue
  String removedElement = queue.removeFirst();
  print(removedElement); // Output: First

  print(queue); // Output: (Second, Third)
}
