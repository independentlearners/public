
void main() {
  List<int> stack = [];

  // Menambahkan elemen ke Stack
  stack.add(10);
  stack.add(20);
  stack.add(30);

  // Menampilkan elemen
  print(stack); // Output: [10, 20, 30]

  // Menghapus elemen dari Stack
  int removedElement = stack.removeLast();
  print(removedElement); // Output: 30

  print(stack); // Output: [10, 20]
}
