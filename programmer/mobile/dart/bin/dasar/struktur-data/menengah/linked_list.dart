import 'dart:collection';

final class Node<E> extends LinkedListEntry<Node<E>> {
  E value;

  Node(this.value);

  @override
  String toString() => '$value';
}

void main() {
  LinkedList<Node<int>> linkedList = LinkedList<Node<int>>();

  // Menambahkan elemen ke LinkedList
  linkedList.add(Node<int>(1));
  linkedList.add(Node<int>(2));
  linkedList.add(Node<int>(3));

  // Menampilkan elemen
  print(linkedList); // Output: (1, 2, 3)

  // Menghapus elemen pertama
  linkedList.first.unlink();
  print(linkedList); // Output: (2, 3)
}
