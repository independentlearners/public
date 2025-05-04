// # Versi sederhana dari for-loop yang tidak membutuhkan init statement
void main() {
  print('\n' * 5);

  int counter = 0;

  while (counter <= 10) {
    print('perulangan ke-$counter');

    counter++; // ! Opsional, jika tidak diaktifan akan menyebabkan perulangan yang tidak pernah berhenti
  }

  print('\n' * 5);
}
